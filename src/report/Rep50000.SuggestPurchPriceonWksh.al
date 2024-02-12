namespace Prodware.FTA;

using Microsoft.Purchases.Pricing;
using Microsoft.Utilities;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Pricing;
using Microsoft.CRM.Campaign;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Finance.Currency;
report 50000 "Suggest Purch. Price on Wksh."
{

    Caption = 'Suggest Purchase Price on Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Price"; "Purchase Price")
        {
            DataItemTableView = sorting("Item No.");
            RequestFilterFields = "Item No.", "Currency Code", "Starting Date";

            trigger OnAfterGetRecord()
            begin
                if Item."No." <> "Item No." then begin
                    Item.Get("Item No.");
                    Window.Update(1, "Item No.");
                end;


                Clear(PurchPriceWksh);


                if ToSalesCode <> '' then
                    PurchPriceWksh.Validate("Vendor No.", ToSalesCode)
                else
                    PurchPriceWksh.Validate("Vendor No.", "Vendor No.");
                PurchPriceWksh.Validate("Item No.", "Item No.");
                PurchPriceWksh."New Unit Cost" := "Direct Unit Cost";
                PurchPriceWksh."Minimum Quantity" := "Minimum Quantity";

                if not ReplaceUnitOfMeasure then
                    PurchPriceWksh."Unit of Measure Code" := "Unit of Measure Code"
                else begin
                    PurchPriceWksh."Unit of Measure Code" := ToUnitOfMeasure.Code;
                    if not (PurchPriceWksh."Unit of Measure Code" in ['', Item."Base Unit of Measure"]) then
                        if not ItemUnitOfMeasure.Get("Item No.", PurchPriceWksh."Unit of Measure Code") then
                            CurrReport.Skip();
                    PurchPriceWksh."New Unit Cost" :=
                      PurchPriceWksh."New Unit Cost" *
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, PurchPriceWksh."Unit of Measure Code") /
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                end;
                PurchPriceWksh.Validate("Unit of Measure Code");
                PurchPriceWksh.Validate("Variant Code", "Variant Code");

                if not ReplaceCurrency then
                    PurchPriceWksh."Currency Code" := "Currency Code"
                else
                    PurchPriceWksh."Currency Code" := ToCurrency.Code;

                if not ReplaceStartingDate then
                    PurchPriceWksh.Validate("Starting Date", "Starting Date")
                else
                    PurchPriceWksh.Validate("Starting Date", ToStartDate);
                if not ReplaceEndingDate then
                    PurchPriceWksh.Validate("Ending Date", "Ending Date")
                else
                    PurchPriceWksh.Validate("Ending Date", ToEndDate);

                if "Currency Code" <> PurchPriceWksh."Currency Code" then begin
                    if "Currency Code" <> '' then begin
                        FromCurrency.Get("Currency Code");
                        FromCurrency.TestField(Code);
                        PurchPriceWksh."New Unit Cost" :=
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate(), "Currency Code", PurchPriceWksh."New Unit Cost",
                            CurrExchRate.ExchangeRate(
                              WorkDate(), "Currency Code"));
                    end;
                    if PurchPriceWksh."Currency Code" <> '' then
                        PurchPriceWksh."New Unit Cost" :=
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            WorkDate(), PurchPriceWksh."Currency Code",
                            PurchPriceWksh."New Unit Cost", CurrExchRate.ExchangeRate(
                              WorkDate(), PurchPriceWksh."Currency Code"));
                end;

                if PurchPriceWksh."Currency Code" = '' then
                    Currency2.InitRoundingPrecision()
                else begin
                    Currency2.Get(PurchPriceWksh."Currency Code");
                    Currency2.TestField("Unit-Amount Rounding Precision");
                end;
                PurchPriceWksh."New Unit Cost" :=
                  Round(PurchPriceWksh."New Unit Cost", Currency2."Unit-Amount Rounding Precision");

                if PurchPriceWksh."New Unit Cost" > PriceLowerLimit then
                    PurchPriceWksh."New Unit Cost" := PurchPriceWksh."New Unit Cost" * UnitPriceFactor;
                if RoundingMethod.Code <> '' then begin
                    RoundingMethod."Minimum Amount" := PurchPriceWksh."New Unit Cost";
                    if RoundingMethod.Find('=<') then begin
                        PurchPriceWksh."New Unit Cost" :=
                          PurchPriceWksh."New Unit Cost" + RoundingMethod."Amount Added Before";
                        if RoundingMethod.Precision > 0 then
                            PurchPriceWksh."New Unit Cost" :=
                              Round(
                                PurchPriceWksh."New Unit Cost",
                                RoundingMethod.Precision, CopyStr('=><', RoundingMethod.Type + 1, 1));
                        PurchPriceWksh."New Unit Cost" := PurchPriceWksh."New Unit Cost" +
                          RoundingMethod."Amount Added After";
                    end;
                end;


                PurchPriceWksh.CalcCurrentPrice(PriceAlreadyExists);

                if PriceAlreadyExists or CreateNewPrices then begin
                    PurchPriceWksh2 := PurchPriceWksh;
                    if PurchPriceWksh2.Find('=') then
                        PurchPriceWksh.Modify(true)
                    else
                        PurchPriceWksh.Insert(true);
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
        Caption = 'Copy to Purchase Price Worksheet...';

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

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            VendList: Page "Vendor List";
                        begin
                            //>>MODIF HL 18/02/2016
                            case ToSalesType of
                                ToSalesType::Vendor:
                                    begin
                                        VendList.LookupMode(true);
                                        VendList.SetRecord(ToVend);
                                        if VendList.RunModal() = ACTION::LookupOK then begin
                                            VendList.GetRecord(ToVend);
                                            ToSalesCode := ToVend."No.";
                                        end;
                                    end;
                            end;
                            //<<MODIF HL 18/02/2016
                        end;
                    }
                    field("ToUnitOfMeasure.Code";
                    ToUnitOfMeasure.Code)
                    {
                        Caption = 'Unit of Measure Code';

                        trigger OnValidate()
                        begin
                            if ToUnitOfMeasure.Code <> '' then
                                ToUnitOfMeasure.Find();
                        end;
                    }
                    field("ToCurrency.Code";
                    ToCurrency.Code)
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
                    field(PriceLowerLimit; PriceLowerLimit)
                    {
                        Caption = 'Only Prices Above';
                    }
                    field(UnitPriceFactor; UnitPriceFactor)
                    {
                        Caption = 'Adjustment Factor';
                        DecimalPlaces = 0 : 5;
                    }
                    field("RoundingMethod.Code";
                    RoundingMethod.Code)
                    {
                        Caption = 'Rounding Method';
                        TableRelation = "Rounding Method";
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
        ToCampaign: Record Campaign;
        Currency2: Record Currency;
        FromCurrency: Record Currency;
        ToCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ToCustPriceGr: Record "Customer Price Group";
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        PurchPrice2: Record "Purchase Price";
        PurchPriceWksh: Record "Purchase Price Worksheet";
        PurchPriceWksh2: Record "Purchase Price Worksheet";
        RoundingMethod: Record "Rounding Method";
        ToUnitOfMeasure: Record "Unit of Measure";
        ToVend: Record Vendor;
        UOMMgt: Codeunit "Unit of Measure Management";


        [InDataSet]
        BooGEnableSalesCodeCtrl: Boolean;
        CreateNewPrices: Boolean;
        PriceAlreadyExists: Boolean;
        ReplaceCurrency: Boolean;
        ReplaceEndingDate: Boolean;
        ReplaceSalesCode: Boolean;
        ReplaceStartingDate: Boolean;
        ReplaceUnitOfMeasure: Boolean;
        ToSalesCode: Code[20];
        ToEndDate: Date;
        ToStartDate: Date;
        PriceLowerLimit: Decimal;
        UnitPriceFactor: Decimal;
        Window: Dialog;
        Text001: Label 'Processing items  #1##########';
        Text002: Label 'Sales Code must be specified when copying from %1 to All Customers.';
        ToSalesType: Option Vendor;

    procedure InitializeRequest(NewToSalesType: Option Customer,"Customer Price Group",Campaign,"All CUstomers"; NewToSalesCode: Code[20]; NewToStartDate: Date; NewToEndDate: Date; NewToCurrCode: Code[10]; NewToUOMCode: Code[10]; NewCreateNewPrices: Boolean)
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

