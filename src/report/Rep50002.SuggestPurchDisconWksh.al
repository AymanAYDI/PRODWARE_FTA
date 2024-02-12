namespace Prodware.FTA;

using Microsoft.Purchases.Pricing;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Pricing;
using Microsoft.CRM.Campaign;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Finance.Currency;
using Microsoft.Utilities;
report 50002 "Suggest Purch. Disc. on Wksh."
{

    Caption = 'Suggest Purchase Discount on Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem9652; "Purchase Line Discount")
        {
            DataItemTableView = sorting("Item No.");
            RequestFilterFields = "Item No.", "Vendor No.", "Currency Code", "Starting Date";

            trigger OnAfterGetRecord()
            begin
                if Item."No." <> "Item No." then begin
                    Item.Get("Item No.");
                    Window.Update(1, "Item No.");
                end;

                Clear(PurchDiscWksh);
                if ToSalesCode <> '' then
                    PurchDiscWksh.Validate("Vendor No.", ToSalesCode)
                else
                    PurchDiscWksh.Validate("Vendor No.", "Vendor No.");
                PurchDiscWksh.Validate("Item No.", "Item No.");
                PurchDiscWksh."Line Discount %" := "Line Discount %";
                PurchDiscWksh."New Line Discount %" := "Line Discount %";
                PurchDiscWksh."Minimum Quantity" := "Minimum Quantity";

                if not ReplaceUnitOfMeasure then
                    PurchDiscWksh."Unit of Measure Code" := "Unit of Measure Code"
                else begin
                    PurchDiscWksh."Unit of Measure Code" := ToUnitOfMeasure.Code;
                    if not (PurchDiscWksh."Unit of Measure Code" in ['', Item."Base Unit of Measure"]) then
                        if not ItemUnitOfMeasure.Get("Item No.", PurchDiscWksh."Unit of Measure Code") then
                            CurrReport.Skip();
                    PurchDiscWksh."New Line Discount %" :=
                      PurchDiscWksh."New Line Discount %" *
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, PurchDiscWksh."Unit of Measure Code") /
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                end;
                PurchDiscWksh.Validate("Unit of Measure Code");
                PurchDiscWksh.Validate("Variant Code", "Variant Code");

                if not ReplaceCurrency then
                    PurchDiscWksh."Currency Code" := "Currency Code"
                else
                    PurchDiscWksh."Currency Code" := ToCurrency.Code;

                if not ReplaceStartingDate then
                    PurchDiscWksh.Validate("Starting Date", "Starting Date")
                else
                    PurchDiscWksh.Validate("Starting Date", ToStartDate);
                if not ReplaceEndingDate then
                    PurchDiscWksh.Validate("Ending Date", "Ending Date")
                else
                    PurchDiscWksh.Validate("Ending Date", ToEndDate);

                if "Currency Code" <> PurchDiscWksh."Currency Code" then begin
                    if "Currency Code" <> '' then begin
                        FromCurrency.Get("Currency Code");
                        FromCurrency.TestField(Code);
                        PurchDiscWksh."New Line Discount %" :=
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate(), "Currency Code", PurchDiscWksh."New Line Discount %",
                            CurrExchRate.ExchangeRate(
                              WorkDate(), "Currency Code"));
                    end;
                    if PurchDiscWksh."Currency Code" <> '' then
                        PurchDiscWksh."New Line Discount %" :=
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            WorkDate(), PurchDiscWksh."Currency Code",
                            PurchDiscWksh."New Line Discount %", CurrExchRate.ExchangeRate(
                              WorkDate(), PurchDiscWksh."Currency Code"));
                end;

                if PurchDiscWksh."Currency Code" = '' then
                    Currency2.InitRoundingPrecision()
                else begin
                    Currency2.Get(PurchDiscWksh."Currency Code");
                    Currency2.TestField("Unit-Amount Rounding Precision");
                end;
                PurchDiscWksh."New Line Discount %" :=
                  Round(PurchDiscWksh."New Line Discount %", Currency2."Unit-Amount Rounding Precision");

                if PurchDiscWksh."New Line Discount %" > PriceLowerLimit then
                    PurchDiscWksh."New Line Discount %" := PurchDiscWksh."New Line Discount %" * UnitPriceFactor;
                if RoundingMethod.Code <> '' then begin
                    RoundingMethod."Minimum Amount" := PurchDiscWksh."New Line Discount %";
                    if RoundingMethod.Find('=<') then begin
                        PurchDiscWksh."New Line Discount %" :=
                          PurchDiscWksh."New Line Discount %" + RoundingMethod."Amount Added Before";
                        if RoundingMethod.Precision > 0 then
                            PurchDiscWksh."New Line Discount %" :=
                              Round(
                                PurchDiscWksh."New Line Discount %",
                                RoundingMethod.Precision, CopyStr('=><', RoundingMethod.Type + 1, 1));
                        PurchDiscWksh."New Line Discount %" := PurchDiscWksh."New Line Discount %" +
                          RoundingMethod."Amount Added After";
                    end;
                end;
                DecGNewDisc := PurchDiscWksh."New Line Discount %";
                PurchDiscWksh.CalcCurrentPrice(PriceAlreadyExists);
                if DecGNewDisc <> 0 then
                    PurchDiscWksh."New Line Discount %" := DecGNewDisc;
                if PriceAlreadyExists or CreateNewPrices then begin
                    PurchDiscWksh2 := PurchDiscWksh;
                    if PurchDiscWksh2.Find('=') then
                        PurchDiscWksh.Modify(true)
                    else
                        PurchDiscWksh.Insert(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    label("Copy to Purchase Price Worksheet...")
                    {
                        Caption = 'Copy to Purchase Price Worksheet...';
                    }
                    field(ToSalesType; ToSalesType)
                    {
                        Caption = 'Purchase Type';
                    }
                    field(SalesCodeCtrl; ToSalesCode)
                    {
                        Caption = 'Vendor Code';
                        Enabled = BooGEnableSalesCodeCtrl;
                    }
                    field("ToUnitOfMeasure.Code"; ToUnitOfMeasure.Code)
                    {
                        Caption = 'Unit of Measure Code';

                        trigger OnValidate()
                        begin
                            if ToUnitOfMeasure.Code <> '' then
                                ToUnitOfMeasure.Find();
                        end;
                    }
                    field("ToCurrency.Code"; ToCurrency.Code)
                    {
                        Caption = 'Currency Code';

                        trigger OnValidate()
                        begin
                            if ToCurrency.Code <> '' then
                                ToCurrency.Find();
                        end;
                    }
                    field(ToStartDateCtrl; ToStartDate)
                    {
                        Caption = 'Starting Date';
                    }
                    field(ToEndDateCtrl; ToEndDate)
                    {
                        Caption = 'Ending Date';
                    }
                    field(UnitPriceFactor; UnitPriceFactor)
                    {
                        Caption = 'Adjustment Factor';
                    }
                    field("RoundingMethod.Code"; RoundingMethod.Code)
                    {
                        Caption = 'Rounding Method';
                    }
                    field(CreateNewPrices; CreateNewPrices)
                    {
                        Caption = 'Create New Prices';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if UnitPriceFactor = 0 then begin
                UnitPriceFactor := 1;
                ToCustPriceGr.Code := '';
                ToUnitOfMeasure.Code := '';
                ToCurrency.Code := '';
            end;
            BooGEnableSalesCodeCtrl := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        case ToSalesType of
            ToSalesType::Vendor:
                begin
                    ToVend."No." := ToSalesCode;
                    if ToVend."No." <> '' then
                        ToVend.Find()
                    else begin
                        if not ToVend.Find() then
                            ToVend.Init();
                        ToSalesCode := ToVend."No.";
                    end;
                end;
        end;


        ReplaceUnitOfMeasure := ToUnitOfMeasure.Code <> '';
        ReplaceCurrency := ToCurrency.Code <> '';
        ReplaceStartingDate := ToStartDate <> 0D;
        ReplaceEndingDate := ToEndDate <> 0D;

        if ReplaceUnitOfMeasure and (ToUnitOfMeasure.Code <> '') then
            ToUnitOfMeasure.Find();

        RoundingMethod.SetRange(Code, RoundingMethod.Code);

    end;

    var
        Text001: Label 'Processing items  #1##########';
        PurchDisc2: Record "Purchase Line Discount";
        PurchDiscWksh2: Record "Purchase Discount Worksheet";
        PurchDiscWksh: Record "Purchase Discount Worksheet";
        ToVend: Record Vendor;
        ToCustPriceGr: Record "Customer Price Group";
        ToCampaign: Record Campaign;
        ToUnitOfMeasure: Record "Unit of Measure";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ToCurrency: Record Currency;
        FromCurrency: Record Currency;
        Currency2: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RoundingMethod: Record "Rounding Method";
        Item: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        Window: Dialog;
        PriceAlreadyExists: Boolean;
        CreateNewPrices: Boolean;
        UnitPriceFactor: Decimal;
        PriceLowerLimit: Decimal;
        ToSalesType: Option Vendor;
        ToSalesCode: Code[20];
        ToStartDate: Date;
        ToEndDate: Date;
        ReplaceSalesCode: Boolean;
        ReplaceUnitOfMeasure: Boolean;
        ReplaceCurrency: Boolean;
        ReplaceStartingDate: Boolean;
        ReplaceEndingDate: Boolean;
        Text002: Label 'Sales Code must be specified when copying from %1 to All Customers.';
        DecGNewDisc: Decimal;
        [InDataSet]
        BooGEnableSalesCodeCtrl: Boolean;


    procedure InitializeRequest(NewToSalesType: Option Vendor; NewToSalesCode: Code[20]; NewToStartDate: Date; NewToEndDate: Date; NewToCurrCode: Code[10]; NewToUOMCode: Code[10]; NewCreateNewPrices: Boolean)
    begin
        ToSalesType := NewToSalesType;
        ToSalesCode := NewToSalesCode;
        ToStartDate := NewToStartDate;
        ToEndDate := NewToEndDate;
        ToCurrency.Code := NewToCurrCode;
        ToUnitOfMeasure.Code := NewToUOMCode;
        CreateNewPrices := NewCreateNewPrices;
    end;
}

