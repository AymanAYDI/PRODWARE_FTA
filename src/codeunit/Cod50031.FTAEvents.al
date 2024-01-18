namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
using Microsoft.Sales.Document;
using Microsoft.Utilities;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Posting;
using Microsoft.Sales.Posting;
using Microsoft.Foundation.BatchProcessing;
using System.Environment;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Assembly.Document;
using Microsoft.Inventory.Costing;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Journal;
using Microsoft.Sales.Pricing;
using Microsoft.Bank.Payment;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Setup;
codeunit 50031 "FTA_Events"
{

    //Record 36 OnDelete
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeShowPostedDocsToPrintCreatedMsg', '', false, false)]
    local procedure OnBeforeShowPostedDocsToPrintCreatedMsg(var ShowPostedDocsToPrint: Boolean)
    var
        RecLPurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";//TODO A verifier
        TextCdeTransp002: Label 'There is a Shipping Purchase order linked (Order %1), do you want to delete this order?';

    begin
        if SalesHeader."Shipping Order No." <> '' then
            if CONFIRM(STRSUBSTNO(TextCdeTransp002, SalesHeader."Shipping Order No.")) then
                if RecLPurchHeader.GET(RecLPurchHeader."Document Type"::Order, SalesHeader."Shipping Order No.") then RecLPurchHeader.DELETE(true);
    end;


    //Codeunit 12 Line 811
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostCustOnBeforeResetCustLedgerEntryAppliesToFields', '', false, false)]
    local procedure OnPostCustOnBeforeResetCustLedgerEntryAppliesToFields(var CustLedgEntry: Record "Cust. Ledger Entry"; var IsHandled: Boolean)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        IsHandled := true;
        CustLedgEntry."Amount to Apply" := 0;
        CustLedgEntry."Applies-to Doc. No." := '';
        CustLedgEntry."Applies-to ID" := '';
        CustLedgEntry."Payment Method Code" := GenJournalLine."Payment Method Code";
        CustLedgEntry."Payment Terms Code" := GenJournalLine."Payment Terms Code";
    end;

    //Codeunit 12 Line 819
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCustLedgEntryInsertInclPreviewMode', '', true, false)]
    local procedure OnAfterCustLedgEntryInsertInclPreviewMode(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldLedgEntryInserted: Boolean; PreviewMode: Boolean)
    var
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        CduGPropagation: Codeunit Propagation;
    begin
        CduGPropagation."GenJnlLine->DCustLedgEntryBuf"(GenJournalLine, TempDtldCVLedgEntryBuf);
    end;

    //Codeunit 12 Line 900
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    local procedure OnBeforeVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        VendorLedgerEntry."Payment Method Code" := GenJournalLine."Payment Method Code";
        VendorLedgerEntry."Payment Terms Code" := GenJournalLine."Payment Terms Code";
    end;
    //Codeunit 12 Line 908
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterVendLedgEntryInsertInclPreviewMode', '', true, false)]
    local procedure OnAfterVendLedgEntryInsertInclPreviewMode(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var DtldLedgEntryInserted: Boolean; PreviewMode: Boolean)
    var
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        CduGPropagation: Codeunit Propagation;
    begin
        CduGPropagation."GenJnlLine->DCustLedgEntryBuf"(GenJournalLine, TempDtldCVLedgEntryBuf);
    end;
    //Codeunit 12 Line 2416
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnApplyCustLedgEntryOnBeforeTempOldCustLedgEntryDelete', '', true, false)]
    local procedure OnApplyCustLedgEntryOnBeforeTempOldCustLedgEntryDelete(var TempOldCustLedgEntry: Record "Cust. Ledger Entry" temporary; var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; var GenJnlLine: Record "Gen. Journal Line"; var Cust: Record Customer; NextEntryNo: Integer; GLReg: Record "G/L Register"; AppliedAmount: Decimal; var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer")
    var
        FTAfct: Codeunit "FTA_Functions";
        BooGPaymentMgt: Boolean;
    begin
        BooGPaymentMgt := true;
        if not BooGPaymentMgt then
            //<<MIG NAV 2015 : Update Code
            FTAfct.CheckCustPostGroup(NewCVLedgEntryBuf, TempOldCustLedgEntry);
    end;
    //Codeunit 12 Line 2957
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnApplyVendLedgEntryOnBeforeTempOldVendLedgEntryDelete', '', true, false)]
    local procedure OnApplyVendLedgEntryOnBeforeTempOldVendLedgEntryDelete(var GenJournalLine: Record "Gen. Journal Line"; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; AppliedAmount: Decimal; var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer")
    var
        TempOldVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        FTAfct: Codeunit "FTA_Functions";
        BooGPaymentMgt: Boolean;
    begin
        BooGPaymentMgt := true;
        TempOldVendLedgEntry.DELETE();
        if not BooGPaymentMgt then
            FTAfct.CheckVendPostGroup(NewCVLedgEntryBuf, TempOldVendLedgEntry);
    end; //TODO-> Verif

    // procedure FctFromPaymentMgt(BooPPaymentMgt: Boolean);
    // var
    // begin
    //     BooGPaymentMgt := BooPPaymentMgt;
    // end;//Codeunit 12 line 5270 //TODO possible not needed 

    //COdeUnit 86 Line 149
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnAfterOnRun', '', false, false)]
    local procedure OnAfterOnRun(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        RecLInventorySetup: Record "Inventory Setup";
        RecLItem: Record Item;
        SalesOrderLine: Record "Sales Line";
        FrmLAssignmentItem: Page "Assignment Item";
    begin
        RecLInventorySetup.GET();
        if RecLInventorySetup."Reservation FTA" then begin
            SalesOrderLine.RESET();
            SalesOrderLine.SETRANGE("Document Type", SalesOrderLine."Document Type"::Order);
            SalesOrderLine.SETRANGE("Document No.", SalesOrderHeader."No.");//CodLSalesOrderNo
            SalesOrderLine.SETRANGE(Type, SalesOrderLine.Type::Item);
            SalesOrderLine.SETRANGE("Preparation Type", SalesOrderLine."Preparation Type"::" ");
            if SalesOrderLine.FINDSET() then
                repeat
                    //>>FED_20090415:PA Kit Build up or remove into pieces
                    if RecLItem.GET(SalesOrderLine."No.") then;
                    if (SalesOrderLine.Quantity <> 0) and (SalesOrderLine."Reserved Quantity" <> SalesOrderLine.Quantity) and
                           not (RecLItem."Inventory Value Zero") then begin
                        CLEAR(FrmLAssignmentItem);
                        //BoopF12 := false; //TODO variable Globale
                        FrmLAssignmentItem.FctGetParm(SalesOrderLine, SalesOrderLine.Quantity, SalesOrderLine."Preparation Type");
                        FrmLAssignmentItem.SETTABLEVIEW(SalesOrderLine);
                        FrmLAssignmentItem.SETRECORD(SalesOrderLine);
                        FrmLAssignmentItem.RUN();
                    end;
                until SalesOrderLine.NEXT() = 0;
        end;
    end;

    //COdeUnit 86 Line 330 //TODO-> A verifier
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeTransferQuoteLineToOrderLineLoop', '', false, false)]
    local procedure OnBeforeTransferQuoteLineToOrderLineLoop(var SalesQuoteLine: Record "Sales Line"; var SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        ATOLink: Record "Assemble-to-Order Link";
        Customer: Record Customer;
        RecLItem: Record Item;
        SalesOrderLine: Record "Sales Line";
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        SalesOrderLine := SalesQuoteLine;
        SalesOrderLine."Document Type" := SalesOrderHeader."Document Type";
        SalesOrderLine."Document No." := SalesOrderHeader."No.";
        SalesOrderLine."Shortcut Dimension 1 Code" := SalesQuoteLine."Shortcut Dimension 1 Code";
        SalesOrderLine."Shortcut Dimension 2 Code" := SalesQuoteLine."Shortcut Dimension 2 Code";
        SalesOrderLine."Dimension Set ID" := SalesQuoteLine."Dimension Set ID";
        SalesOrderLine."Transaction Type" := SalesOrderHeader."Transaction Type";
        if Customer."Prepayment %" <> 0 then
            SalesOrderLine."Prepayment %" := Customer."Prepayment %";
        PrepmtMgt.SetSalesPrepaymentPct(SalesOrderLine, SalesOrderHeader."Posting Date");
        SalesOrderLine.Validate("Prepayment %");
        IsHandled := false;
        if not IsHandled then
            if SalesOrderLine."No." <> '' then
                SalesOrderLine.DefaultDeferralCode();
        SalesOrderLine.Insert();
        ATOLink.MakeAsmOrderLinkedToSalesOrderLine(SalesQuoteLine, SalesOrderLine);
        ReserveSalesLine.TransferSaleLineToSalesLine(
          SalesQuoteLine, SalesOrderLine, SalesQuoteLine."Outstanding Qty. (Base)");
        ReserveSalesLine.VerifyQuantity(SalesOrderLine, SalesQuoteLine);
        if SalesOrderLine.Reserve = SalesOrderLine.Reserve::Always then
            SalesOrderLine.AutoReserve();
        if (SalesQuoteLine.Type = SalesQuoteLine.Type::Item) and
         RecLItem.GET(SalesQuoteLine."No.") and
         RecLItem."Quote Associated" then begin
            RecLItem."Quote Associated" := false;
            RecLItem.MODIFY();
        end;
    end;
    //codeunit 92 Line 109
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPost(var PurchaseHeader: Record "Purchase Header")
    var
        RecGPurchHeader: Record "Purchase Header";
        RecGPurchLine: Record "Purchase Line";
        CuGPurchPost: Codeunit "Purch.-Post";
        CuGReleasePurchaseDoc: Codeunit "Release Purchase Document";
        BooGARefermer: Boolean;
        CodGNumDoc: Code[20];
        CodGNumDocMarchandise: Code[20];
        DecGQty: Decimal;
    begin
        CodGNumDoc := PurchaseHeader."Shipping Order No.";
        CodGNumDocMarchandise := PurchaseHeader."No.";
        //>>NAVEASY.001 [Cde_Transport] la Cde achat marchandise est livr‚e et
        //est li‚e … une cde achat transport alors il y a validation en R‚ception de la cde achat transport
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) and
           (PurchaseHeader.Receive) and
           (CodGNumDoc <> '') then
            if (RecGPurchHeader.GET(RecGPurchHeader."Document Type"::Order, CodGNumDoc)) then begin
                RecGPurchHeader.CALCFIELDS("Order Type");
                if (RecGPurchHeader."Order Type" = RecGPurchHeader."Order Type"::Transport) then begin

                    //Cas 1 : 1 Cde achat transport li‚e … 1 seule Cde achat marchandise
                    if (RecGPurchHeader."Initial Order No." <> '') and
                       (RecGPurchHeader."Initial Order Type" <> RecGPurchHeader."Initial Order Type"::" ") then begin
                        RecGPurchHeader.Receive := true;
                        CuGPurchPost.RUN(RecGPurchHeader);
                    end;

                    //Cas 2 : 1 Cde achat transport li‚e … n Cdes achat marchandise
                    BooGARefermer := false;
                    if (RecGPurchHeader."Initial Order No." = '') and
                       (RecGPurchHeader."Initial Order Type" = RecGPurchHeader."Initial Order Type"::" ") then begin

                        //Si la cde achat transport est lanc‚e, on r‚ouvre la cde
                        if RecGPurchHeader.Status = RecGPurchHeader.Status::Released then begin
                            BooGARefermer := true;
                            CuGReleasePurchaseDoc.Reopen(RecGPurchHeader);
                        end;

                        //Modification des lignes de la cde achat transport pour ne recevoir que la ligne achat li‚e … la cde achat marchandise
                        RecGPurchLine.RESET();
                        RecGPurchLine.SETRANGE("Document Type", RecGPurchHeader."Document Type");
                        RecGPurchLine.SETRANGE("Document No.", RecGPurchHeader."No.");
                        if RecGPurchLine.FINDSET(true, false) then
                            repeat
                                if RecGPurchLine."Initial Order No." = CodGNumDocMarchandise then begin
                                    DecGQty := RecGPurchLine.Quantity;
                                    RecGPurchLine.VALIDATE(Quantity, DecGQty);             //on valide la Qt‚ … recevoir pour la ligne achat li‚e
                                end;

                                if RecGPurchLine."Initial Order No." <> CodGNumDocMarchandise then
                                    RecGPurchLine.VALIDATE("Qty. to Receive", 0);          //on met … 0 la Qt‚ … recevoir pr les autres lignes

                                RecGPurchLine.MODIFY();
                            until RecGPurchLine.NEXT() = 0;

                        //Si la cde achat transport ‚tait lanc‚e, on referme la cde
                        if BooGARefermer then
                            CuGReleasePurchaseDoc.RUN(RecGPurchHeader);

                        //On lance la r‚ception de la cde achat transport
                        RecGPurchHeader.Receive := true;
                        CuGPurchPost.RUN(RecGPurchHeader);

                    end;  //Fin Cas 2
                end;
            end;
        //<<NAVEASY.001 [Cde_Transport] la Cde achat marchandise est livr‚e et est li‚e … une cde achat transport

    end;

    //Codeunit 414
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseATOs', '', false, false)]
    local procedure OnAfterReleaseATOs(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; PreviewMode: Boolean)
    var
        RecLCust: Record Customer;
        RecLItem: Record Item;
        BooLNegMargin: Boolean;
        DecLAmount: Decimal;
        CstL001: Label 'The franco amount%1  is not enought (%2), do you want to add some additionals charges?';
        CstL002: Label 'Please add delivery charge';
        CstL003: Label 'This document has some having a negative margin (example line no. %1 item %2), do you want to modfy what you have entered?';
        CstL004: Label 'Please, correct the data';
        CstL005: Label 'Preparation Type empty on the line %1 for the item %2, please recreate the line';
        CstL006: Label 'No. item empty on the line %1, please complete the line';
    begin
        //>>FED_20090415:PA 15/04/2009
        BooLNegMargin := false;
        if RecLCust.GET(SalesHeader."Sell-to Customer No.") then
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        if SalesLine.FINDSET() then
            repeat
                if (SalesLine."Margin %" <= 0) and not BooLNegMargin then
                    if CONFIRM(STRSUBSTNO(CstL003, SalesLine."Line No.", SalesLine."No."), true) then
                        ERROR(CstL004)
                    else
                        BooLNegMargin := true;
                if DecLAmount < RecLCust."Franco Amount" then
                    DecLAmount += SalesLine.Amount;
            until SalesLine.NEXT() = 0;
        SalesLine.RESET();
        if RecLCust."Franco Amount" <> 0 then
            if DecLAmount < RecLCust."Franco Amount" then
                if CONFIRM(STRSUBSTNO(CstL001, FORMAT(RecLCust."Franco Amount"), FORMAT(DecLAmount))) then
                    ERROR(CstL002);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            SalesLine.SETRANGE("Preparation Type", SalesLine."Preparation Type"::" ");
            if SalesLine.FINDFIRST() then
                repeat
                    if RecLItem.GET(SalesLine."No.") then
                        if RecLItem."Inventory Value Zero" = false then
                            ERROR(CstL005, SalesLine."Line No.", SalesLine."No.");
                until SalesLine.NEXT() = 0;
        end;
        SalesLine.RESET();
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETRANGE("No.", '');
        if SalesLine.FINDFIRST() then
            repeat
                ERROR(CstL006, SalesLine."Line No.");
            until SalesLine.NEXT() = 0;

        //<<FED_20090415:PA 15/04/2009
    end;

    //Codeunit 905
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly Line Management", 'OnExplodeAsmListOnAfterToAssemblyLineInsert', '', false, false)]
    local procedure OnExplodeAsmListOnAfterToAssemblyLineInsert(var FromAssemblyLine: Record "Assembly Line"; var ToAssemblyLine: Record "Assembly Line")
    var
        FTAfct: Codeunit "FTA_Functions";
    begin
        //>> FTA1.02
        // if AutoReserveOk then  //TODO -> possibly not needed
        ToAssemblyLine.FctAutoReserveFTA();
        //<< FTA1.02
    end;



    //Codeunit 5895 Line 1660
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Adjustment", 'OnAfterInitAdjmtJnlLine', '', false, false)]
    local procedure OnAfterInitAdjmtJnlLine(var ItemJnlLine: Record "Item Journal Line"; OrigValueEntry: Record "Value Entry"; EntryType: Enum "Cost Entry Type"; VarianceType: Enum "Cost Variance Type"; InvoicedQty: Decimal)
    begin
        with OrigValueEntry do
            ItemJnlLine."Mobile Salesperson Code" := "Mobile Salesperson Code";
    end;


    //Codeunit 7000 line 76
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice', '', false, false)]
    local procedure OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary; CalledByFieldNo: Integer; FoundSalesPrice: Boolean)
    var
        FTAfct: Codeunit "FTA_Functions";
    begin
        FTAfct.Fct_GetDiscforAll(SalesHeader, SalesLine);
    end;


    //Codeunit 7171 line 325
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Info-Pane Management", 'OnBeforeLookupItem', '', false, false)]
    local procedure OnBeforeLookupItem(var SalesLine: Record "Sales Line"; Item: Record Item; var IsHandled: Boolean)
    var
        SalesInfoPaneManagement: Codeunit "Sales Info-Pane Management";
        FrmLItemCard: Page "Item Card";
        FrmLTransItemCard: Page "Transitory Item Card";
        FrmLTransKitItemCard: Page "Transitory Kit Item Card";

    begin
        SalesLine.TestField(Type, SalesLine.Type::Item);
        SalesLine.TestField("No.");
        SalesInfoPaneManagement.GetItem(SalesLine);
        case Item."Item Base" of
            Item."Item Base"::Standard:
                begin
                    CLEAR(FrmLItemCard);
                    FrmLItemCard.SETRECORD(Item);
                    FrmLItemCard.RUN();
                end;
            Item."Item Base"::Transitory:
                begin
                    CLEAR(FrmLTransItemCard);
                    FrmLTransItemCard.SETRECORD(Item);
                    FrmLTransItemCard.RUN();
                end;
            Item."Item Base"::"Transitory Kit":
                begin
                    CLEAR(FrmLTransKitItemCard);
                    FrmLTransKitItemCard.SETRECORD(Item);
                    FrmLTransKitItemCard.RUN();
                end;
        end;
        PAGE.RunModal(PAGE::"Item Card", Item);
        IsHandled := true;
    end;


    //Codeunit 10861 //TODO Verifier
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment-Apply", 'OnAfterApply', '', false, false)]
    local procedure OnAfterApply(GenJnlLine: Record "Gen. Journal Line")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        PaymentLine: Record "Payment Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        CodLPostingGroup: Code[10];
        accNo: Code[20];
        AccType: Enum "Gen. Journal Account Type";
    begin
        //AccType := GenJnlLine."Account Type";
        accNo := GenJnlLine."Account No.";
        case AccType of
            AccType::Customer:
                begin
                    CustLedgEntry.get();
                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                    CustLedgEntry.SETRANGE("Customer No.", AccNo);
                    CustLedgEntry.SETRANGE(Open, true);
                    CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                    CodLPostingGroup := CustLedgEntry."Customer Posting Group";
                end;
            AccType::Vendor:
                begin
                    VendLedgEntry.get();
                    VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                    VendLedgEntry.SetRange("Vendor No.", AccNo);
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                    CodLPostingGroup := VendLedgEntry."Vendor Posting Group";
                end;
        end;

        //"Posting Group" := CodLPostingGroup;
        PaymentLine.SetRange("Account Type", GenJnlLine."Account Type");
        PaymentLine.SetRange("Account No.", GenJnlLine."Account No.");
        PaymentLine.SetRange(Amount, GenJnlLine.Amount);
        PaymentLine.SetRange("Amount (LCY)", GenJnlLine."Amount (LCY)");
        PaymentLine.SetRange("Currency Code", GenJnlLine."Currency Code");
        PaymentLine.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
        PaymentLine.SetRange("Applies-to Doc. No.", GenJnlLine."Applies-to Doc. No.");
        PaymentLine.SetRange("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type");

        PaymentLine."Posting Group" := CodLPostingGroup;
        PaymentLine.Modify();

    end;

    //codeunit 99000830
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnTransferReservEntryOnAfterTransferFields', '', false, false)]
    local procedure OnTransferReservEntryOnAfterTransferFields(var NewReservationEntry: Record "Reservation Entry"; var OldReservationEntry: Record "Reservation Entry"; var UseQtyToHandle: Boolean; var UseQtyToInvoice: Boolean; var CurrSignFactor: Integer)
    var
        ItemJournalLine: Record "Item Journal Line";
        RecLReservEntry: Record "Reservation Entry";
        RecLxOldReservEntry: Record "Reservation Entry" temporary;
        RecLSalesLine: Record "Sales Line";
        RecLSalesLine2: Record "Sales Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
        TransferQty: Decimal;
        xTransferQty: Decimal;

    begin

        RecLxOldReservEntry.TRANSFERFIELDS(OldReservationEntry);


        /*******************/
        case OldReservationEntry."Source Type" of
            Database::"Sales Line":
                begin
                    UseQtyToHandle := OldReservationEntry.TrackingExists();
                    RecLSalesLine2.get(OldReservationEntry."Source Type", OldReservationEntry."Source ID", OldReservationEntry."Source Ref. No.");
                    TransferQty := RecLSalesLine2."Outstanding Qty. (Base)";
                    CurrSignFactor := CreateReservEntry.SignFactor(OldReservationEntry);
                    TransferQty := TransferQty * CurrSignFactor;
                    xTransferQty := TransferQty;

                    if UseQtyToHandle then begin // Used when handling Item Tracking
                        QtyToHandleThisLine := OldReservationEntry."Qty. to Handle (Base)";
                        QtyToInvoiceThisLine := OldReservationEntry."Qty. to Invoice (Base)";
                        if Abs(TransferQty) > Abs(QtyToHandleThisLine) then
                            TransferQty := QtyToHandleThisLine;
                        if UseQtyToInvoice then // Used when posting sales and purchase
                            if Abs(TransferQty) > Abs(QtyToInvoiceThisLine) then
                                TransferQty := QtyToInvoiceThisLine;
                    end else
                        QtyToHandleThisLine := OldReservationEntry."Quantity (Base)";
                end;
            Database::"Item Journal Line":
                begin
                    UseQtyToHandle := OldReservationEntry.TrackingExists();
                    ItemJournalLine.get(OldReservationEntry."Source Type", OldReservationEntry."Source ID", OldReservationEntry."Source Ref. No.");
                    //TransferQty := ItemJournalLine."Outstanding Qty. (Base)";//QtyToBeShippedBase("Quanity (Base)")
                    CurrSignFactor := CreateReservEntry.SignFactor(OldReservationEntry);
                    TransferQty := TransferQty * CurrSignFactor;
                    xTransferQty := TransferQty;

                    if UseQtyToHandle then begin // Used when handling Item Tracking
                        QtyToHandleThisLine := OldReservationEntry."Qty. to Handle (Base)";
                        QtyToInvoiceThisLine := OldReservationEntry."Qty. to Invoice (Base)";
                        if Abs(TransferQty) > Abs(QtyToHandleThisLine) then
                            TransferQty := QtyToHandleThisLine;
                        if UseQtyToInvoice then // Used when posting sales and purchase
                            if Abs(TransferQty) > Abs(QtyToInvoiceThisLine) then
                                TransferQty := QtyToInvoiceThisLine;
                    end else
                        QtyToHandleThisLine := OldReservationEntry."Quantity (Base)";
                end;
        end;
        /*************************/


        if (TransferQty <> 0) and (RecLxOldReservEntry."Source Type" = 39) then begin
            RecLReservEntry.SETRANGE("Entry No.", RecLxOldReservEntry."Entry No.");
            RecLReservEntry.SETRANGE("Source Type", 37);
            RecLReservEntry.SETRANGE("Item No.", RecLxOldReservEntry."Item No.");
            if not RecLReservEntry.ISEMPTY then begin
                RecLReservEntry.FINDSET();
                repeat
                    if RecLSalesLine.GET(RecLReservEntry."Source Subtype", RecLReservEntry."Source ID", RecLReservEntry."Source Ref. No.") then begin
                        RecLSalesLine.CALCFIELDS("Reserved Quantity");
                        if (RecLSalesLine."Preparation Type" <> RecLSalesLine."Preparation Type"::Stock) and
                           (RecLSalesLine."Reserved Quantity" <= ABS(TransferQty)) and
                            (RecLSalesLine."Outstanding Qty. (Base)" <= ABS(TransferQty)) then begin
                            RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Stock;
                            RecLSalesLine.MODIFY();
                        end;
                    end;
                until RecLReservEntry.NEXT() = 0;
            end;
        end;
        //<<FE-DIVERS 18/09/2009
    end;


    //Report 296   
    [EventSubscriber(ObjectType::Report, Report::"Batch Post Sales Orders", 'OnAfterOnOpenPage', '', true, false)]
    local procedure OnAfterOnOpenPage(var ShipReq: Boolean; var InvReq: Boolean; var PostingDateReq: Date; var ReplacePostingDate: Boolean; var ReplaceDocumentDate: Boolean; var CalcInvDisc: Boolean; var ReplaceVATDateReq: Boolean; var VATDateReq: Date)
    var
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        //>>FE-DIVERS 18/09/2009
        RecLSalesReceivablesSetup.GET();
        if RecLSalesReceivablesSetup."Default Posting Date" = RecLSalesReceivablesSetup."Default Posting Date"::"Work Date" then begin
            PostingDateReq := WORKDATE();
            ReplacePostingDate := true;
        end;
        ShipReq := false;
        InvReq := true;
        //<<FE-DIVERS 18/09/2009
    end;




    procedure SetParms(BooPOpenDialogueBox: Boolean; BooPMultiLevel: Boolean);
    begin
        BooGOpenDialogueBox := BooPOpenDialogueBox;
        BooGMultiLevel := BooPMultiLevel;
    end;


    //Page 233
    [EventSubscriber(ObjectType::Page, Page::"Apply Vendor Entries", 'OnBeforeCallVendEntrySetApplIDSetApplId', '', true, false)]
    local procedure OnBeforeCallVendEntrySetApplIDSetApplId(VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; var TempApplyingVendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean)
    var
        AppVendEntries: Page "Apply Vendor Entries";
    begin
        AppVendEntries.VerifPostingGroup(VendorLedgerEntry."Applies-to ID", VendorLedgerEntry."Vendor Posting Group");
    end;
    //Codeunit 86 Line 126 //TODO A verifier
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeDeleteSalesQuote', '', false, false)]
    local procedure OnBeforeDeleteSalesQuote(var QuoteSalesHeader: Record "Sales Header"; var OrderSalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SalesQuoteLine: Record "Sales Line")
    var
        RecGParmNavi: Record "NavEasy Setup";
        RecGArchiveManagement: Codeunit ArchiveManagement;
    begin
        if RecGParmNavi.GET() then
            if RecGParmNavi."Filing Sales Quotes" then begin
                QuoteSalesHeader."Cause filing" := QuoteSalesHeader."Cause filing"::"Change in Order";
                QuoteSalesHeader.MODIFY();
                RecGArchiveManagement.StoreSalesDocument(QuoteSalesHeader, false);
            end;
    end;

    //Codeunit 92 Line 65
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnBeforeSelectPostOrderOption', '', false, false)]
    local procedure OnBeforeSelectPostOrderOption(var PurchaseHeader: Record "Purchase Header"; DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    var
        FTAfct: Codeunit "FTA_Functions";
    begin
        Result := FTAfct.ConfirmPostPurchaseDocument(PurchaseHeader, DefaultOption, false, false);
        IsHandled := true;
    end;

    //Page 54 Line 35
    [EventSubscriber(ObjectType::Page, Page::"Purchase order Subform", 'OnBeforeOnDeleteRecord', '', false, false)]
    local procedure OnBeforeOnDeleteRecord(var PurchaseLine: Record "Purchase Line"; var Result: Boolean; var IsHandled: Boolean)
    begin
        PurchaseLine.CALCFIELDS("Reserved Quantity");
        PurchaseLine.TESTFIELD("Reserved Quantity", 0);
    end;

    //Report 296
    // [EventSubscriber(ObjectType::Report, Report::"Batch Post Sales Orders", 'OnAfterSalesBatchPostMgt', '', false, false)]
    // local procedure OnAfterSalesBatchPostMgt(var SalesHeader: Record "Sales Header"; var SalesBatchPostMgt: Codeunit "Sales Batch Post Mgt.")
    // var
    //     RecGPurchHeader: Record "Purchase Header";
    //     CuGPurchPost: Codeunit "Purch.-Post";
    //     CodGNumDoc: Code[20];
    // begin
    //     CodGNumDoc := SalesHeader."Shipping Order No.";
    //     if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and
    //                                    (SalesHeader.Ship) and
    //                                    (CodGNumDoc <> '') then
    //         if (RecGPurchHeader.GET(RecGPurchHeader."Document Type"::Order, CodGNumDoc)) then begin
    //             RecGPurchHeader.CALCFIELDS("Order Type");
    //             if (RecGPurchHeader."Order Type" = RecGPurchHeader."Order Type"::Transport) then begin
    //                 RecGPurchHeader.Receive := true;
    //                 CLEAR(CuGPurchPost);
    //                 // CuGPurchPost.SetPostingDate(ReplacePostingDate, ReplaceDocumentDate, PostingDateReq);
    //                 // CuGPurchPost.RUN(RecGPurchHeader);
    //                 SalesBatchPostMgt.RunBatch(RecGPurchHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, ShipReq, InvReq);

    //             end;
    //         end;
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", 'SubstituteReport', '', false, false)]
    local procedure SubstituteReport(ReportId: Integer; RunMode: Option Normal,ParametersOnly,Execute,Print,SaveAs,RunModal; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer)
    begin
        if ReportId = Report::"Batch Post Sales Orders" then
            NewReportId := Report::"Batch.Post.Sales.Orders";
    end;








    var
        BooGOpenDialogueBox: Boolean;
        BooGMultiLevel: Boolean;
    //HasInvtSetup:Boolean;
    //BooGPaymentMgt:Boolean;
    //CodLSalesOrderNo:Code[20];
    //CodGNumDoc:Code[20]; //Codeunit 92
    //CodGNumDocMarchandise:Code[20]; //Codeunit 92
    //AutoReserveOk: Boolean; //Codeunit 905

}