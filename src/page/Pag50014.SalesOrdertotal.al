namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Sales.Pricing;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Inventory.Availability;
using Microsoft.Utilities;
using Microsoft.Inventory.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Foundation.Navigate;
using Microsoft.Inventory.Item;
page 50014 "Sales Order total"
{

    Caption = 'Total Lines';
    PaGetype = CardPart;
    SourceTable = "Sales Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Total)
            {
                Caption = 'Total';
                field("Invoice Discount Amount"; TotalSalesLine."Inv. Discount Amount")
                {
                    AutoFormatType = 1;
                    Caption = 'Invoice Discount Amount';
                    Editable = InvDiscAmountEditable;
                    Style = Subordinate;
                    StyleExpr = RefreshMessageEnabled;
                    ToolTip = 'Specifies the value of the Invoice Discount Amount field.';
                    trigger OnValidate()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalSalesLine."Inv. Discount Amount", SalesHeader);
                        CurrPage.Update(false);
                    end;
                }
                field("Invoice Disc. Pct."; SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec))
                {
                    Caption = 'Invoice Discount %';
                    DecimalPlaces = 0 : 2;
                    Editable = false;
                    Style = Subordinate;
                    StyleExpr = RefreshMessageEnabled;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Invoice Discount % field.';
                }
                field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
                {
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalExclVATCaption(SalesHeader."Currency Code");
                    Caption = 'Total Amount Excl. VAT';
                    DrillDown = false;
                    Editable = false;
                    Style = Subordinate;
                    StyleExpr = RefreshMessageEnabled;
                    ToolTip = 'Specifies the value of the Total Amount Excl. VAT field.';
                }
                field("Total VAT Amount"; VATAmount)
                {
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalVATCaption(SalesHeader."Currency Code");
                    Caption = 'Total VAT';
                    Editable = false;
                    Style = Subordinate;
                    StyleExpr = RefreshMessageEnabled;
                    ToolTip = 'Specifies the value of the Total VAT field.';
                }
                field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
                {
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalInclVATCaption(SalesHeader."Currency Code");
                    Caption = 'Total Amount Incl. VAT';
                    Editable = false;
                    StyleExpr = TotalAmountStyle;
                    ToolTip = 'Specifies the value of the Total Amount Incl. VAT field.';
                }
                field(RefreshTotals; RefreshMessaGetext)
                {
                    DrillDown = true;
                    Editable = false;
                    Enabled = RefreshMessageEnabled;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
                        CurrPage.Update(false);
                    end;
                }
                field("Tot.WorkTime"; TotWorkTime(Rec, false))
                {
                    Caption = 'Total temps de montage et usinage(en heures)';
                }
            }
            group(Total1)
            {
                Caption = 'Total';
                field("Tot.SalesLineAmountPrepare"; TotalSalesLineAmountPrepare(Rec))
                {
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalExclVATCaption(SalesHeader."Currency Code");
                    Caption = 'Total Amount Excl. VAT';
                    DrillDown = false;
                    Editable = false;
                    Style = Subordinate;
                    StyleExpr = RefreshMessageEnabled;
                }
                field("Tot.SalesLineAmountIncludingVATPrepare"; TotalSalesLineAmountIncludingVATPrepare(Rec))
                {
                    AutoFormatType = 1;
                    CaptionClass = DocumentTotals.GetTotalInclVATCaption(SalesHeader."Currency Code");
                    Caption = 'Total Amount Incl. VAT';
                    Editable = false;
                    StyleExpr = TotalAmountStyle;
                }
                field("To.tWorkTime"; TotWorkTime(Rec, true))
                {
                    Caption = 'Total temps de montage et usinage(en heures)';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then;

        DocumentTotals.SalesUpdateTotalsControls(Rec, TotalSalesHeader, TotalSalesLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessaGetext, InvDiscAmountEditable, true, VATAmount); //TODO -> Verif Test

        TypeChosen := Rec.Type <> Rec.Type::" ";
        SetLocationCodeMandatory();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
    end;

    var
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        RecGInventorySetup: Record "Inventory Setup";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        VATAmount: Decimal;
        ShortcutDimCode: array[8] of Code[20];
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';

        ItemPanelVisible: Boolean;
        TypeChosen: Boolean;
        LocationCodeMandatory: Boolean;
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessaGetext: Text;
        DecGxQuantity: Decimal;
        OptGxPreparationType: Option " ",Stock,Assembly,Purchase,Remainder;
        BooGOK: Boolean;



    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;


    procedure CalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;


    procedure ExplodeBOM()
    begin
        if Rec."Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
    end;


    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        Rec.TestField("Purchase Order No.");
        PurchHeader.SetRange("No.", Rec."Purchase Order No.");
        PurchOrder.SetTableView(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run();
    end;


    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
    begin
        Rec.TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.", Rec."Special Order Purchase No.");
        if not PurchHeader.IsEmpty then begin
            PurchOrder.SetTableView(PurchHeader);
            PurchOrder.Editable := false;
            PurchOrder.Run();
        end else begin
            PurchRcptHeader.SetRange("Order No.", Rec."Special Order Purchase No.");
            if PurchRcptHeader.Count = 1 then
                PAGE.Run(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
            else
                PAGE.Run(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
        end;
    end;


    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord();
            Commit();
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate() then
            UpdateForm(true);
    end;


    procedure ShowNonstockItems()
    begin
        Rec.ShowNonstock();
    end;


    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RunModal();
    end;


    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt();
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;


    procedure ShowPrices()
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader, Rec);
    end;


    procedure ShowLineDisc()
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader, Rec);
    end;


    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
        OrderPromisingLines: Page "Order Promising Lines";
    begin
        OrderPromisingLine.SetRange("Source Type", Rec."Document Type");
        OrderPromisingLine.SetRange("Source ID", Rec."Document No.");
        OrderPromisingLine.SetRange("Source Line No.", Rec."Line No.");

        OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
        OrderPromisingLines.SetTableView(OrderPromisingLine);
        OrderPromisingLines.RunModal();
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Rec.Type = Rec.Type::Item;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord();

        if (Rec."Item Base" = Rec."Item Base"::Transitory) then
            CurrPage.Update();
        SaveAndAutoAsmToOrder();

        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            if (Rec."Outstanding Qty. (Base)" <> 0) and (Rec."No." <> xRec."No.") then begin
                Rec.AutoReserve();
                CurrPage.Update(false);
            end;
        end;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder();
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder();

        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Location Code" <> xRec."Location Code")
        then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;
    end;

    local procedure ReserveOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and (Rec."Outstanding Qty. (Base)" <> 0) then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;
    end;

    local procedure QuantityOnAfterValidate()
    var
        RecLItem: Record Item;
        PgeLAssignmentItem: Page "Assignment Item";
        UpdateIsDone: Boolean;
        OK: Boolean;
        BoopF12: Boolean;
    begin

        //>>FED_20090415:PA 15/04/2009
        RecGInventorySetup.Get();
        if RecGInventorySetup."Reservation FTA" then begin
            if Rec.Quantity > DecGxQuantity then begin
                //>>FED_20090415:PA Kit Build up or remove into pieces
                if RecLItem.Get(Rec."No.") then;
                if (Rec.Quantity <> 0) and (Rec."Reserved Quantity" <> Rec.Quantity) and
                    (Rec.Type = Rec.Type::Item) and (Rec."Document Type" <> Rec."Document Type"::Quote) and not (RecLItem."Inventory Value Zero") then begin

                    CurrPage.SaveRecord();

                    Clear(PgeLAssignmentItem);
                    BoopF12 := false;
                    PgeLAssignmentItem.FctGetParm(Rec, DecGxQuantity, OptGxPreparationType);
                    PgeLAssignmentItem.SetTableView(Rec);
                    PgeLAssignmentItem.SetRecord(Rec);
                    PgeLAssignmentItem.Run();

                    //OK := FORM.RunModal(50003,Rec) = ACTION::LookupOK;
                    //IF NOT OK THEN
                    //  Error('abandon');

                    //>> AT Migration
                    /*
                       CurrPage.Update(FALSE);
                          IF (DecGxQuantity = Quantity) AND
                              (OptGxPreparationType = "Preparation Type") THEN
                            IF Get("Document Type","Document No.","Line No.") THEN
                              CurrPage.EcrQty.ACTIVATE;
                              */
                    //<< AT
                end;
            end;
        end else begin
            if Rec.Type = Rec.Type::Item then
                case Rec.Reserve of
                    Rec.Reserve::Always:
                        begin
                            CurrPage.SaveRecord();
                            Rec.AutoReserve();
                            CurrPage.Update(false);
                            UpdateIsDone := true;
                        end;
                    Rec.Reserve::Optional:
                        if (Rec.Quantity < xRec.Quantity) and (xRec.Quantity > 0) then begin
                            CurrPage.SaveRecord();
                            CurrPage.Update(false);
                            UpdateIsDone := true;
                        end;
                end;

            if (Rec.Type = Rec.Type::Item) and
               (Rec.Quantity <> xRec.Quantity) and
               not UpdateIsDone
            then
                CurrPage.Update(true);
        end;

    end;

    local procedure QtyToAsmToOrderOnAfterValidate()
    begin
        CurrPage.SaveRecord();
        if Rec.Reserve = Rec.Reserve::Always then
            Rec.AutoReserve();
        CurrPage.Update(true);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Shipment Date" <> xRec."Shipment Date")
        then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        if (Rec.Type = Rec.Type::Item) and Rec.IsAsmToOrderRequired() then begin
            CurrPage.SaveRecord();
            Rec.AutoAsmToOrder();
            CurrPage.Update(false);
        end;
    end;

    local procedure SetLocationCodeMandatory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        LocationCodeMandatory := InventorySetup."Location Mandatory" and (Rec.Type = Rec.Type::Item);
    end;

    local procedure RedistributeTotalsOnAfterValidate()
    begin
        CurrPage.SaveRecord();

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if DocumentTotals.SalesCheckNumberOfLinesLimit(SalesHeader) then
            DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.Update();
    end;

    local procedure TotWorkTime(var RecLSalesLine: Record "Sales Line"; pPrepare: Boolean): Decimal
    var
        SalesLine: Record "Sales Line";
        TotWorkTIme: Decimal;
    begin
        SalesLine.SetRange("Document Type", RecLSalesLine."Document Type");
        SalesLine.SetRange("Document No.", RecLSalesLine."Document No.");
        if pPrepare then
            RecLSalesLine.SetRange(Prepare, true);
        if SalesLine.FindSet() then
            repeat
                TotWorkTIme += SalesLine."Item Work Time" + SalesLine."Item Machining Time";
            until SalesLine.Next() = 0;

        exit(TotWorkTIme * 0.016667);
    end;

    local procedure TotalSalesLineAmountPrepare(var SalesLine: Record "Sales Line"): Decimal
    var
        LRecSalesLine: Record "Sales Line";
        TotAmount: Decimal;
    begin
        TotAmount := 0;

        LRecSalesLine.Reset();
        LRecSalesLine.SetRange("Document Type", SalesLine."Document Type");
        LRecSalesLine.SetRange("Document No.", SalesLine."Document No.");
        LRecSalesLine.SetRange(Prepare, true);
        LRecSalesLine.CalcSums(Amount);
        exit(LRecSalesLine.Amount);
    end;

    local procedure TotalSalesLineAmountIncludingVATPrepare(var SalesLine: Record "Sales Line"): Decimal
    var
        LRecSalesLine: Record "Sales Line";
    begin
        LRecSalesLine.Reset();
        LRecSalesLine.SetRange("Document Type", SalesLine."Document Type");
        LRecSalesLine.SetRange("Document No.", SalesLine."Document No.");
        LRecSalesLine.SetRange(Prepare, true);
        LRecSalesLine.CalcSums("Amount Including VAT");
        exit(LRecSalesLine."Amount Including VAT");
    end;
}

