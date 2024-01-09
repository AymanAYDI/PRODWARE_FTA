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
                    Item.GET("Item No.");
                    Window.UPDATE(1, "Item No.");
                end;


                CLEAR(PurchPriceWksh);


                if ToSalesCode <> '' then
                    PurchPriceWksh.VALIDATE("Vendor No.", ToSalesCode)
                else
                    PurchPriceWksh.VALIDATE("Vendor No.", "Vendor No.");
                PurchPriceWksh.VALIDATE("Item No.", "Item No.");
                PurchPriceWksh."New Unit Cost" := "Direct Unit Cost";
                PurchPriceWksh."Minimum Quantity" := "Minimum Quantity";

                if not ReplaceUnitOfMeasure then
                    PurchPriceWksh."Unit of Measure Code" := "Unit of Measure Code"
                else begin
                    PurchPriceWksh."Unit of Measure Code" := ToUnitOfMeasure.Code;
                    if not (PurchPriceWksh."Unit of Measure Code" in ['', Item."Base Unit of Measure"]) then
                        if not ItemUnitOfMeasure.GET("Item No.", PurchPriceWksh."Unit of Measure Code") then
                            CurrReport.SKIP();
                    PurchPriceWksh."New Unit Cost" :=
                      PurchPriceWksh."New Unit Cost" *
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, PurchPriceWksh."Unit of Measure Code") /
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");
                end;
                PurchPriceWksh.VALIDATE("Unit of Measure Code");
                PurchPriceWksh.VALIDATE("Variant Code", "Variant Code");

                if not ReplaceCurrency then
                    PurchPriceWksh."Currency Code" := "Currency Code"
                else
                    PurchPriceWksh."Currency Code" := ToCurrency.Code;

                if not ReplaceStartingDate then
                    PurchPriceWksh.VALIDATE("Starting Date", "Starting Date")
                else
                    PurchPriceWksh.VALIDATE("Starting Date", ToStartDate);
                if not ReplaceEndingDate then
                    PurchPriceWksh.VALIDATE("Ending Date", "Ending Date")
                else
                    PurchPriceWksh.VALIDATE("Ending Date", ToEndDate);

                if "Currency Code" <> PurchPriceWksh."Currency Code" then begin
                    if "Currency Code" <> '' then begin
                        FromCurrency.GET("Currency Code");
                        FromCurrency.TESTFIELD(Code);
                        PurchPriceWksh."New Unit Cost" :=
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WORKDATE(), "Currency Code", PurchPriceWksh."New Unit Cost",
                            CurrExchRate.ExchangeRate(
                              WORKDATE(), "Currency Code"));
                    end;
                    if PurchPriceWksh."Currency Code" <> '' then
                        PurchPriceWksh."New Unit Cost" :=
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            WORKDATE(), PurchPriceWksh."Currency Code",
                            PurchPriceWksh."New Unit Cost", CurrExchRate.ExchangeRate(
                              WORKDATE(), PurchPriceWksh."Currency Code"));
                end;

                if PurchPriceWksh."Currency Code" = '' then
                    Currency2.InitRoundingPrecision()
                else begin
                    Currency2.GET(PurchPriceWksh."Currency Code");
                    Currency2.TESTFIELD("Unit-Amount Rounding Precision");
                end;
                PurchPriceWksh."New Unit Cost" :=
                  ROUND(PurchPriceWksh."New Unit Cost", Currency2."Unit-Amount Rounding Precision");

                if PurchPriceWksh."New Unit Cost" > PriceLowerLimit then
                    PurchPriceWksh."New Unit Cost" := PurchPriceWksh."New Unit Cost" * UnitPriceFactor;
                if RoundingMethod.Code <> '' then begin
                    RoundingMethod."Minimum Amount" := PurchPriceWksh."New Unit Cost";
                    if RoundingMethod.FIND('=<') then begin
                        PurchPriceWksh."New Unit Cost" :=
                          PurchPriceWksh."New Unit Cost" + RoundingMethod."Amount Added Before";
                        if RoundingMethod.Precision > 0 then
                            PurchPriceWksh."New Unit Cost" :=
                              ROUND(
                                PurchPriceWksh."New Unit Cost",
                                RoundingMethod.Precision, COPYSTR('=><', RoundingMethod.Type + 1, 1));
                        PurchPriceWksh."New Unit Cost" := PurchPriceWksh."New Unit Cost" +
                          RoundingMethod."Amount Added After";
                    end;
                end;


                PurchPriceWksh.CalcCurrentPrice(PriceAlreadyExists);

                if PriceAlreadyExists or CreateNewPrices then begin
                    PurchPriceWksh2 := PurchPriceWksh;
                    if PurchPriceWksh2.FIND('=') then
                        PurchPriceWksh.MODIFY(true)
                    else
                        PurchPriceWksh.INSERT(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN(Text001);
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
                            VendList: Page "27";
                        begin
                            //>>MODIF HL 18/02/2016
                            case ToSalesType of
                                ToSalesType::Vendor:
                                    begin
                                        VendList.LOOKUPMODE(true);
                                        VendList.SETRECORD(ToVend);
                                        if VendList.RUNMODAL() = ACTION::LookupOK then begin
                                            VendList.GETRECORD(ToVend);
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
                                ToUnitOfMeasure.FIND();
                        end;
                    }
                    field("ToCurrency.Code";
                    ToCurrency.Code)
                    {
                        Caption = 'Currency Code';

                        trigger OnValidate()
                        begin
                            if ToCurrency.Code <> '' then
                                ToCurrency.FIND();
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
                        ToVend.FIND()
                    else begin
                        if not ToVend.FIND() then
                            ToVend.INIT();
                        ToSalesCode := ToVend."No.";
                    end;
                end;

        end;

        ReplaceUnitOfMeasure := ToUnitOfMeasure.Code <> '';
        ReplaceCurrency := ToCurrency.Code <> '';
        ReplaceStartingDate := ToStartDate <> 0D;
        ReplaceEndingDate := ToEndDate <> 0D;

        if ReplaceUnitOfMeasure and (ToUnitOfMeasure.Code <> '') then
            ToUnitOfMeasure.FIND();

        RoundingMethod.SETRANGE(Code, RoundingMethod.Code);

    end;

    var
        Text001: Label 'Processing items  #1##########';
        PurchPrice2: Record "Purchase Price";
        PurchPriceWksh2: Record "Purchase Price Worksheet";
        PurchPriceWksh: Record "Purchase Price Worksheet";
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
        [InDataSet]
        BooGEnableSalesCodeCtrl: Boolean;

    [Scope('Internal')]
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

