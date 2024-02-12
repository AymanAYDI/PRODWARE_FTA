codeunit 50031 "FTA_Events"
{
    SingleInstance = true;
    //<<<<<<<<<<<<<<<<<<<<<Partie Hadil >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    var
        BooGOpenDialogueBox: Boolean;
        BooGMultiLevel: Boolean;
    //Record 27
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeOnInsert', '', false, false)]
    local procedure OnBeforeOnInsert(var Item: Record Item; var IsHandled: Boolean; xRecItem: Record Item)
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
    begin
        case Item."Item Base" of
            Item."Item Base"::Transitory:
                begin
                    Item.GetInvtSetup();
                    InvtSetup.TESTFIELD("Transitory Item Nos.");
                    NoSeriesMgt.InitSeries(InvtSetup."Transitory Item Nos.", xRecItem."No. Series", 0D, Item."No.", Item."No. Series");
                    Item."Item Base" := Item."Item Base"::Transitory;
                end;
            Item."Item Base"::"Transitory Kit":
                begin
                    Item.GetInvtSetup();
                    InvtSetup.TESTFIELD("Transitory Kit Item Nos.");
                    NoSeriesMgt.InitSeries(InvtSetup."Transitory Kit Item Nos.", xRecItem."No. Series", 0D, Item."No.", Item."No. Series");
                    Item."Item Base" := Item."Item Base"::"Transitory Kit";
                end;
            Item."Item Base"::"Bored blocks":
                begin
                    Item.GetInvtSetup();
                    InvtSetup.TESTFIELD("Bored blocks Item Nos.");
                    NoSeriesMgt.InitSeries(InvtSetup."Bored blocks Item Nos.", xRecItem."No. Series", 0D, Item."No.", Item."No. Series");
                    Item."Item Base" := Item."Item Base"::"Bored blocks";
                end;
            else
                if Item."No." = '' then begin
                    Item.GetInvtSetup();
                    InvtSetup.TESTFIELD("Item Nos.");
                    NoSeriesMgt.InitSeries(InvtSetup."Item Nos.", xRecItem."No. Series", 0D, Item."No.", Item."No. Series");
                end;
        end;
        Item.FILTERGROUP(0);
        DimMgt.UpdateDefaultDim(
              DATABASE::Item, Item."No.",
              Item."Global Dimension 1 Code", Item."Global Dimension 2 Code");
        Item."Creation Date" := WORKDATE();
        Item.User := USERID();
        Item.UpdateReferencedIds();
        Item.SetLastDateTimeModified();

        Item.UpdateItemUnitGroup();
        IsHandled := true;
    end;
    //Record 36
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeValidateNo', '', false, false)]
    local procedure OnBeforeValidateNo(var IsHandled: Boolean; var Item: Record Item; xItem: Record Item; InventorySetup: Record "Inventory Setup"; var NoSeriesMgt: Codeunit NoSeriesManagement)
    begin
        if Item.GETFILTER("Item Base") = '<>Standard' then begin
            Item.GetInvtSetup();
            InventorySetup.TESTFIELD("Transitory Item Nos.");
            NoSeriesMgt.InitSeries(InventorySetup."Transitory Item Nos.", xItem."No. Series", 0D, Item."No.", Item."No. Series");
            Item."Item Base" := Item."Item Base"::Transitory;
        end;
    end;
    //Record 36
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure OnAfterValidateEvent(CurrFieldNo: Integer; var Rec: Record Item; var xRec: Record Item)
    begin
        Rec.Get(CurrFieldNo);
        Rec."Search Description" := DELCHR(Rec."Search Description", '=', '/,- +-#*.\{}><[]()@":=');
    end;
    //Record 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure OnAfterUpdateAmountsDone(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        SalesLine.UpdatePurchaseBasePrice();
    end;
    //Record 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        SalesLine."Item Base" := TempSalesLine."Item Base";
    end;
    //Record 38
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterTransferSavedFields', '', false, false)]
    local procedure OnAfterTransferSavedFields(var DestinationPurchaseLine: Record "Purchase Line"; SourcePurchaseLine: Record "Purchase Line")
    begin
        DestinationPurchaseLine."Special Order Sales No." := SourcePurchaseLine."Special Order Sales No.";
        DestinationPurchaseLine."Special Order Sales Line No." := SourcePurchaseLine."Special Order Sales Line No.";
        DestinationPurchaseLine."Special Order" := SourcePurchaseLine."Special Order Sales Line No." <> 0;
    end;
    //Record 38
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidatePromisedReceiptDate', '', false, false)]
    local procedure OnBeforeValidatePromisedReceiptDate(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; CUrrentFieldNo: Integer)
    var
        RecLPurchLine: Record "Purchase Line";
        CstL001: Label 'This change can delete the reservation of the lines : do want to continue?';
        CstL002: Label 'Canceled operation;FRA=Traitement annul';
    begin
        PurchaseHeader.TestStatusOpen();
        if PurchaseHeader."Promised Receipt Date" <> xPurchaseHeader."Promised Receipt Date" then begin
            RecLPurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            RecLPurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
            RecLPurchLine.SETFILTER("Expected Receipt Date", '<%1', PurchaseHeader."Promised Receipt Date");
            RecLPurchLine.SETRANGE(Type, RecLPurchLine.Type::Item);

            if not RecLPurchLine.ISEMPTY() then begin
                RecLPurchLine.FINDSET();
                repeat
                    RecLPurchLine.CALCFIELDS("Reserved Qty. (Base)");
                    if RecLPurchLine."Reserved Qty. (Base)" <> 0 then
                        if not CONFIRM(CstL001, false) then
                            ERROR(CstL002);
                until (RecLPurchLine.NEXT() = 0) or (RecLPurchLine."Reserved Qty. (Base)" <> 0);
            end;
            PurchaseHeader.UpdatePurchLinesByFieldNo(PurchaseHeader.FieldNo(PurchaseHeader."Promised Receipt Date"), CUrrentFieldNo <> 0);
        end;
        if PurchaseHeader."Promised Receipt Date" <> 0D then
            PurchaseHeader."Planned Receipt Date" := CALCDATE(PurchaseHeader."Lead Time Calculation", PurchaseHeader."Promised Receipt Date")
        else
            if PurchaseHeader."Requested Receipt Date" <> 0D then
                PurchaseHeader."Planned Receipt Date" := CALCDATE(PurchaseHeader."Lead Time Calculation", PurchaseHeader."Requested Receipt Date");
        IsHandled := true;
    end;
    //Record 38
    [EventSubscriber(ObjectType::table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure OnAfterCopyBuyFromVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; xPurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Transaction Type" := Vendor."Transaction Type";
        PurchaseHeader."Transaction Specification" := Vendor."Transaction Specification";
        PurchaseHeader."Transport Method" := Vendor."Transport Method";
        PurchaseHeader."Entry Point" := Vendor."Entry Point";
        PurchaseHeader.Area := Vendor.Area;
        PurchaseHeader."Posting Description" := Vendor.Name;
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetGLAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetGLAccount(var GenJournalLine: Record "Gen. Journal Line"; var GLAccount: Record "G/L Account"; CallingFieldNo: Integer)
    begin
        if (GenJournalLine."Bal. Account No." = '') or (GenJournalLine."Bal. Account Type" in
           [GenJournalLine."Bal. Account Type"::"G/L Account", GenJournalLine."Bal. Account Type"::"Bank Account"]) then
            GenJournalLine."Mobile Salesperson Code" := '';
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetCustomerAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := Customer."Mobile Salesperson Code";
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := '';
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetBankAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetBankAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := '';
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnGetGLBalAccountOnAfterSetDescription', '', false, false)]
    local procedure OnGetGLBalAccountOnAfterSetDescription(var GenJournalLine: Record "Gen. Journal Line"; GLAcc: Record "G/L Account")
    begin
        if (GenJournalLine."Account No." = '') or
         (GenJournalLine."Account Type" in
          [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Bank Account"])
        then
            GenJournalLine."Mobile Salesperson Code" := '';
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnGetCustomerBalAccountOnAfterCustGet', '', false, false)]
    local procedure OnGetCustomerBalAccountOnAfterCustGet(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := Customer."Mobile Salesperson Code";
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorBalAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := '';
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetBankBalAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetBankBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; CallingFieldNo: Integer)
    begin
        if (GenJournalLine."Account No." = '') or
         (GenJournalLine."Account Type" in
          [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Bank Account"])
      then
            GenJournalLine."Mobile Salesperson Code" := '';
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo', '', false, false)]
    local procedure OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        GenJournalLine."Posting Group" := CustLedgerEntry."Customer Posting Group";
    end;
    //Record 81
    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterLookUpAppliesToDocVend', '', false, false)]
    local procedure OnAfterLookUpAppliesToDocVend(var GenJournalLine: Record "Gen. Journal Line"; VendLedgEntry: Record "Vendor Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry"; ApplyVendorEntries: page "Apply Vendor Entries")
    begin
        GenJournalLine."Posting Group" := VendLedgEntry."Vendor Posting Group";
    end;
    //Record 751
    [EventSubscriber(ObjectType::table, Database::"Standard General Journal Line", 'OnAfterGetGLAccount', '', false, false)]
    local procedure OnAfterGetGLAccount(var StandardGenJournalLine: Record "Standard General Journal Line"; GLAcc: Record "G/L Account")
    begin
        if (StandardGenJournalLine."Bal. Account No." = '') or
          (StandardGenJournalLine."Bal. Account Type" in
           [StandardGenJournalLine."Bal. Account Type"::"G/L Account", StandardGenJournalLine."Bal. Account Type"::"Bank Account"])
       then
            StandardGenJournalLine."Mobile Salesperson Code" := '';
    end;
    //Record 904
    [EventSubscriber(ObjectType::table, Database::"Assemble-to-Order Link", 'OnBeforeShowAsmToOrderLines', '', false, false)]
    local procedure OnBeforeShowAsmToOrderLines(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        AssembleOrderLink: Record "Assemble-to-Order Link";
        AsmLine: Record "Assembly Line";
        SalesHeader: Record "Sales Header";
        AssembletoOrderLines: page "Assemble-to-Order Lines";
    begin
        SalesLine.TestField("Qty. to Asm. to Order (Base)");
        if AssembleOrderLink.AsmExistsForSalesLine(SalesLine) then begin
            AsmLine.FilterGroup := 2;
            AsmLine.SetRange("Document Type", AssembleOrderLink."Assembly Document Type");
            AsmLine.SetRange("Document No.", AssembleOrderLink."Assembly Document No.");
            AsmLine.FilterGroup := 0;
            SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
            AssembletoOrderLines.FctSetDate(SalesHeader."Requested Delivery Date");
            AssembletoOrderLines.SETTABLEVIEW(AsmLine);
            AssembletoOrderLines.RUNMODAL();
        end;
        IsHandled := true;
    end;
    //Page 46
    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnBeforeQuantityOnAfterValidate', '', false, false)]
    local procedure OnBeforeQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    var
        OK: Boolean;
        BoopF12: Boolean;
        RecLItem: Record Item;
        PgeLAssignmentItem: Page 50003;
        RecGInventorySetup: Record "Inventory Setup";
    begin
        RecGInventorySetup.GET();
        if RecGInventorySetup."Reservation FTA" then
            // IF Quantity > DecGxQuantity THEN BEGIN
            if SalesLine.Quantity > xSalesLine.Quantity then begin
                if RecLItem.GET(SalesLine."No.") then;
                if (SalesLine.Quantity <> 0) and (SalesLine."Reserved Quantity" <> SalesLine.Quantity) and
                (SalesLine.Type = Type::Item) and (SalesLine."Document Type" <> "Document Type"::Quote) and not (RecLItem."Inventory Value Zero") then begin
                    //TODO : CurrPage not exist in the current context 
                    //CurrPage.SAVERECORD;

                    CLEAR(PgeLAssignmentItem);
                    BoopF12 := false;
                    PgeLAssignmentItem.FctGetParm(SalesLine, xSalesLine.Quantity, xSalesLine."Preparation Type");
                    PgeLAssignmentItem.SETTABLEVIEW(SalesLine);
                    PgeLAssignmentItem.SETRECORD(SalesLine);
                    PgeLAssignmentItem.RUN();
                end;
            end;

    end;
    //Page 232
    [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", 'OnSetCustApplIdAfterCheckAgainstApplnCurrency', '', false, false)]
    local procedure OnSetCustApplIdAfterCheckAgainstApplnCurrency(var CustLedgerEntry: Record "Cust. Ledger Entry"; CalcType: Option; var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; ServHeader: Record "Service Header"; ApplyingCustLedgEntry: Record "Cust. Ledger Entry")
    var
        ApplyCustomerEntries: Page "Apply Customer Entries"; //Todo : verifier 
    begin
        ApplyCustomerEntries.VerifPostingGroup(CustLedgerEntry."Applies-to ID", CustLedgerEntry."Customer Posting Group");
    end;
    //CodeUnit 22
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnCodeOnBeforeTestOrder', '', false, false)]
    local procedure OnCodeOnBeforeTestOrder(ItemJnlLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        if ItemJnlLine.IsAssemblyOutputLine() then
            ItemJnlLine.TestField("Order Line No.", 0);
        IsHandled := true;

    end;
    //CodeUnit 22
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnItemQtyPostingOnBeforeApplyItemLedgEntry', '', false, false)]
    local procedure OnItemQtyPostingOnBeforeApplyItemLedgEntry(var ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        RecLInventorySetup: Record "Inventory Setup";
        RecLItem: Record Item;
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        DecLQuantity: Decimal;
        DecPQtyAvailable: Decimal;
        CstLTxt001: Label 'The amount available for article 1% is lower the amount requested.';
        CstL001: Label 'The quantity %1 is greater than the available quantity %2 for the journal %3 line no. %4';
    begin
        RecLInventorySetup.GET();
        DecLQuantity := 0;
        CLEAR(RecLItem);
        if RecLItem.GET(ItemJournalLine."Item No.") and (RecLInventorySetup."Negative Inventory Not Allowed") then
            if RecLItem.GET(ItemJournalLine."Item No.") and not (RecLItem."Inventory Value Zero") then begin
                if (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase) or
                   (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::"Positive Adjmt.") or
                   (ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output) then
                    DecLQuantity := -ItemJournalLine."Quantity (Base)"
                else
                    DecLQuantity := ItemJournalLine."Quantity (Base)";

                RecLItemLedgerEntry.RESET();
                RecLItemLedgerEntry.SETCURRENTKEY("Item No.", "Location Code", Open, "Posting Date", "Variant Code");
                RecLItemLedgerEntry.SETFILTER("Item No.", '%1', ItemJournalLine."Item No.");
                RecLItemLedgerEntry.SETFILTER("Location Code", '%1', ItemJournalLine."Location Code");
                RecLItemLedgerEntry.SETFILTER(Open, '%1', true);
                RecLItemLedgerEntry.SETFILTER("Variant Code", '%1', ItemJournalLine."Variant Code");
                RecLItemLedgerEntry.CALCSUMS("Remaining Quantity");
                if RecLItemLedgerEntry."Remaining Quantity" - DecLQuantity < 0 then
                    ERROR(CstLTxt001, ItemJournalLine."Item No.");
            end;
        if (ItemJournalLine."Entry Type" in
    [ItemJournalLine."Entry Type"::"Negative Adjmt."]) then begin
            RecLItem.GET(ItemJournalLine."Item No.");
            RecLItem.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
            DecPQtyAvailable := RecLItem.Inventory - (RecLItem."Reserved Qty. on Inventory");
            if ItemJournalLine.Quantity > DecPQtyAvailable then
                ERROR(CstL001, ItemJournalLine.Quantity, DecPQtyAvailable, ItemJournalLine."Journal Batch Name", ItemJournalLine."Line No.");
        end;
    end;
    //CodeUnit 22
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertPhysInvtLedgEntry', '', false, false)]
    local procedure OnBeforeInsertPhysInvtLedgEntry(var PhysInventoryLedgerEntry: Record "Phys. Inventory Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; LastSplitItemJournalLine: Record "Item Journal Line")
    begin
        PhysInventoryLedgerEntry."Mobile Salesperson Code" := ItemJournalLine."Mobile Salesperson Code";
    end;
    //CodeUnit 22
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnBeforeRoundAmtValueEntry', '', false, false)]
    local procedure OnInitValueEntryOnBeforeRoundAmtValueEntry(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        ValueEntry."Mobile Salesperson Code" := ItemJnlLine."Mobile Salesperson Code";
    end;
    //CodeUnit 22
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeGetProdOrderLine', '', false, false)]
    local procedure OnBeforeGetProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; OrderNo: Code[20]; OrderLineNo: Integer; var IsHandled: Boolean)
    begin
        if not ProdOrderLine.GET(ProdOrderLine.Status::Released, OrderNo, OrderLineNo) then
            ProdOrderLine.GET(ProdOrderLine.Status::Finished, OrderNo, OrderLineNo);
        IsHandled := true;
    end;
    //CodeUnit 82
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var SendReportAsEmail: Boolean; var DefaultOption: Integer)
    var
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        RecLSalesReceivablesSetup.GET();
        if RecLSalesReceivablesSetup."Default Posting Date" = RecLSalesReceivablesSetup."Default Posting Date"::"Work Date" then
            SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE());
    end;
    //CodeUnit 82
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost_PP(var SalesHeader: Record "Sales Header")
    var
        RecGPurchHeader: Record "Purchase Header";
        CuGPurchPost: Codeunit "Purch.-Post";
        CodGNumDoc: Code[20];
    begin
        CodGNumDoc := SalesHeader."Shipping Order No.";
        if (SalesHeader."Document Type" = "Document Type"::Order) and
          (SalesHeader.Ship) and
          (CodGNumDoc <> '') then
            if (RecGPurchHeader.GET(RecGPurchHeader."Document Type"::Order, CodGNumDoc)) then begin
                RecGPurchHeader.CALCFIELDS("Order Type");
                if (RecGPurchHeader."Order Type" = RecGPurchHeader."Order Type"::Transport) then begin
                    RecGPurchHeader.Receive := true;
                    CuGPurchPost.RUN(RecGPurchHeader);
                end;
            end;
    end;
    //CodeUnit 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    begin
        PurchaseHeader.CALCFIELDS("Order Type");
    end;
    //CodeUnit 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnAfterFillTempLines', '', false, false)]
    local procedure OnRunOnAfterFillTempLines(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.CALCFIELDS("Order Type");
    end;
    //CodeUnit 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckHeaderPostingType', '', false, false)]
    local procedure OnBeforeCheckHeaderPostingType(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
    begin
        if not (PurchaseHeader.Receive or PurchaseHeader.Invoice or PurchaseHeader.Ship) then begin
            PurchaseHeader.CALCFIELDS("Order Type");
            if (PurchaseHeader."Order Type" = PurchaseHeader."Order Type"::Transport) and
               (PurchaseHeader."Initial Order No." <> '') and
               (PurchaseHeader."Initial Order Type" <> PurchaseHeader."Initial Order Type"::" ") then
                exit
            else
                Error(ErrorInfo.Create(DocumentErrorsMgt.GetNothingToPostErrorMsg(), true, PurchaseHeader));
        end;
        IsHandled := true;
    end;
    //CodeUnit 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WhseReceive: Boolean; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WhseShip: Boolean)
    begin
        PurchRcptHeader."Order Type" := PurchaseHeader."Order Type";
    end;
    //CodeUnit 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvHeaderInsert', '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        PurchInvHeader."Order Type" := PurchHeader."Order Type";
    end;
    //CodeUnit 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine', '', false, false)]
    local procedure OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine2: Record "Purchase Line"; var TotalPurchLineLCY2: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        GenJnlLine."Posting Group" := PurchHeader."Vendor Posting Group";
        GenJnlLine."Payment Method Code" := PurchHeader."Payment Method Code";
    end;
    //CodeUnit 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        CstL001: Label 'Purchase Invoice %1 created.';
    begin
        if PurchaseHeader.Invoice and (PurchInvHdrNo <> '') then
            MESSAGE(CstL001, PurchInvHdrNo);
    end;
    //CodeUnit 225
    //Todo : verifier
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnApplyCustomerLedgerEntryOnBeforeModify', '', false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeModify(var GenJnlLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        GenJnlLine."Posting Group" := CustLedgerEntry."Customer Posting Group";

    end;
    //CodeUnit 225
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnApplyVendorLedgerEntryOnBeforeModify', '', false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeModify(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; VendorLedgerEntryLocal: Record "Vendor Ledger Entry")
    begin
        GenJournalLine."Posting Group" := VendorLedgerEntry."Vendor Posting Group";

    end;
    //CodeUnit 229
    //TODO : a verifier !!!!!!!!!!!!!!!!!
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeDoPrintSalesHeader', '', false, false)]
    local procedure OnBeforeDoPrintSalesHeader(var SalesHeader: Record "Sales Header"; ReportUsage: Integer; SendAsEmail: Boolean; var IsPrinted: Boolean)
    var
        RecLReportUser: Record "Report Email By User";
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SetRange(Usage, ReportUsage);
        ReportSelections.SetFilter("Report ID", '<>0');
        ReportSelections.FindFirst();
        repeat
            if not RecLReportUser.GET(USERID, ReportSelections."Report ID") then begin
                RecLReportUser.INIT();
                RecLReportUser.UserID := USERID;
                RecLReportUser."Report ID" := ReportSelections."Report ID";
                RecLReportUser.INSERT();
            end;
            RecLReportUser.Email := SendAsEmail;
            RecLReportUser.MODIFY();
            COMMIT();
            if SendAsEmail then
                ReportSelections.SendEmailToCust(
                    ReportUsage, SalesHeader, SalesHeader."No.", SalesHeader.GetDocTypeTxt(), true, SalesHeader.GetBillToNo())
            else
                ReportSelections.PrintForCust(ReportUsage, SalesHeader, SalesHeader.FieldNo("Bill-to Customer No."));
        until ReportSelections.Next() = 0;
        IsPrinted := true;
    end;
    //CodeUnit 229
    //TODO : a verifier !!!!!!!!!!!!!!!!!
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeDoPrintPurchHeader', '', false, false)]
    local procedure OnBeforeDoPrintPurchHeader(var PurchHeader: Record "Purchase Header"; ReportUsage: Integer; var IsPrinted: Boolean)
    var
        RecLReportUser: Record "Report Email By User";
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SetRange(Usage, ReportUsage);
        ReportSelections.SetFilter("Report ID", '<>0');
        ReportSelections.FindFirst();
        repeat
            if not RecLReportUser.GET(USERID, ReportSelections."Report ID") then begin
                RecLReportUser.INIT();
                RecLReportUser.UserID := USERID;
                RecLReportUser."Report ID" := ReportSelections."Report ID";
                RecLReportUser.INSERT();
            end;
            RecLReportUser.Email := false;
            RecLReportUser.MODIFY();
            COMMIT();
        until ReportSelections.Next() = 0;
        ReportSelections.PrintWithDialogForVend(ReportUsage, PurchHeader, true, PurchHeader.FieldNo("Buy-from Vendor No."));

        IsPrinted := true;
    end;
    //CodeUnit 229
    //TODO : a verifier !!!!!!!!!!!!!!!!!
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforePrintSalesOrder', '', false, false)]
    local procedure OnBeforePrintSalesOrder(var SalesHeader: Record "Sales Header"; ReportUsage: Integer; var IsPrinted: Boolean)
    var
        RecLReportUser: Record "Report Email By User";
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.SetRange(Usage, ReportUsage);
        ReportSelections.SetFilter("Report ID", '<>0');
        ReportSelections.FindFirst();
        repeat
            if not RecLReportUser.GET(USERID, ReportSelections."Report ID") then begin
                RecLReportUser.INIT();
                RecLReportUser.UserID := USERID;
                RecLReportUser."Report ID" := ReportSelections."Report ID";
                RecLReportUser.INSERT();
            end;
            RecLReportUser.Email := false;
            RecLReportUser.MODIFY();
            COMMIT();
        until ReportSelections.Next() = 0;
        ReportSelections.PrintWithDialogForCust(
            ReportUsage, SalesHeader, GuiAllowed, SalesHeader.FieldNo("Bill-to Customer No."));

        IsPrinted := true;
    end;
    //CodeUnit 5804
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ItemCostManagement, 'OnUpdateStdCostSharesOnAfterCopyCosts', '', false, false)]
    local procedure OnUpdateStdCostSharesOnAfterCopyCosts(var Item: Record Item; FromItem: Record Item)
    begin
        if (Item."Item Base" = Item."Item Base"::"Transitory Kit") or (Item."Item Base" = Item."Item Base"::"Bored blocks") then begin
            Item.VALIDATE("Purchase Price Base", Item."Single-Level Material Cost");
            Item.VALIDATE("Unit Price", Item."Kit - Sales Price");
        end;
    end;
    //Record 27
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterIsMfgItem', '', false, false)]
    local procedure OnAfterIsMfgItem(Item: Record Item; var Result: Boolean)
    begin
        Result := true;
    end;

    procedure SetParms(BooPOpenDialogueBox: Boolean; BooPMultiLevel: Boolean);
    begin
        BooGOpenDialogueBox := BooPOpenDialogueBox;
        BooGMultiLevel := BooPMultiLevel;
    end;
    //CodeUnit 5812
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcItemOnBeforeShowStrMenu', '', false, false)]
    local procedure OnCalcItemOnBeforeShowStrMenu(var Item: Record Item; var ShowStrMenu: Boolean; var NewCalcMultiLevel: Boolean)
    begin
        if not ShowStrMenu then
            if BooGOpenDialogueBox then begin
                NewCalcMultiLevel := BooGMultiLevel;
                ShowStrMenu := false;
            end;
    end;
    //  todo : line 322
    //CodeUnit 5812
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcAssemblyItemOnAfterCalcItemCost', '', false, false)]
    local procedure OnCalcAssemblyItemOnAfterCalcItemCost(var Item: Record Item; CompItem: Record Item; BOMComponent: Record "BOM Component"; ComponentQuantity: Decimal)
    begin
        if not BooGMultiLevel then begin
            Item."Rolled-up Material Cost" += ComponentQuantity * CompItem."Purchase Price Base";
            Item."Single-Level Material Cost" += ComponentQuantity * CompItem."Purchase Price Base"
        end
        else
            if not (CompItem.IsAssemblyItem() or CompItem.IsMfgItem()) then begin
                Item."Rolled-up Material Cost" -= ComponentQuantity * CompItem."Unit Cost";
                Item."Single-Level Material Cost" -= ComponentQuantity * CompItem."Unit Cost";
                Item."Rolled-up Material Cost" += ComponentQuantity * CompItem."Purchase Price Base";
                Item."Single-Level Material Cost" += ComponentQuantity * CompItem."Purchase Price Base";
            end
    end;
    //CodeUnit 5812
    //TODO : I cant find solution line 606
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcProdBOMCostOnAfterCalcAnyItem', '', false, false)]
    local procedure OnCalcProdBOMCostOnAfterCalcAnyItem(var ProductionBOMLine: Record "Production BOM Line"; MfgItem: Record Item; MfgItemQtyBase: Decimal; CompItem: Record Item; CompItemQtyBase: Decimal; Level: Integer; IsTypeItem: Boolean; UOMFactor: Decimal; var SLMat: Decimal; var RUMat: Decimal; var RUCap: Decimal; var RUSub: Decimal; var RUCapOvhd: Decimal; var RUMfgOvhd: Decimal)
    begin
        // GetItem(ProductionBOMLine."No.", CompItem);
        // if CompItem.IsInventoriableType() then
        //     if CompItem.IsMfgItem() or CompItem.IsAssemblyItem() then begin
        //         CalcMfgItem(ProductionBOMLine."No.", CompItem, Level + 1);
        //         IncrCost(SLMat, CompItem."Standard Cost", CompItemQtyBase);
        //         IncrCost(RUMat, CompItem."Rolled-up Material Cost", CompItemQtyBase);
        //         IncrCost(RUCap, CompItem."Rolled-up Capacity Cost", CompItemQtyBase);
        //         IncrCost(RUSub, CompItem."Rolled-up Subcontracted Cost", CompItemQtyBase);
        //         IncrCost(RUCapOvhd, CompItem."Rolled-up Cap. Overhead Cost", CompItemQtyBase);
        //         IncrCost(RUMfgOvhd, CompItem."Rolled-up Mfg. Ovhd Cost", CompItemQtyBase);
        //     end else begin
        //         IncrCost(SLMat, CompItem."Unit Cost", CompItemQtyBase);
        //         IncrCost(RUMat, CompItem."Unit Cost", CompItemQtyBase);
        //     end;
    end;
    // todo : verifier line 606
    //CodeUnit 5812
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcProdBOMCostOnAfterCalcAnyItem', '', false, false)]
    local procedure OnCalcProdBOMCostOnAfterCalcAnyItem2(var ProductionBOMLine: Record "Production BOM Line"; MfgItem: Record Item; MfgItemQtyBase: Decimal; CompItem: Record Item; CompItemQtyBase: Decimal; Level: Integer; IsTypeItem: Boolean; UOMFactor: Decimal; var SLMat: Decimal; var RUMat: Decimal; var RUCap: Decimal; var RUSub: Decimal; var RUCapOvhd: Decimal; var RUMfgOvhd: Decimal)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.get();
        if CompItem.IsInventoriableType() then
            if CompItem.IsMfgItem() or CompItem.IsAssemblyItem() then begin
                SLMat := SLMat - Round(CompItemQtyBase * CompItem."Standard Cost", GLSetup."Unit-Amount Rounding Precision");
                SLMat := SLMat + Round(CompItemQtyBase * CompItem."Purchase Price Base", GLSetup."Unit-Amount Rounding Precision");
            end;
    end;
    //CodeUnit 10860
    //TODO: i can't find solution line 263..264
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnCopyLigBorOnBeforeToPaymentLineInsert', '', false, false)]
    local procedure OnCopyLigBorOnBeforeToPaymentLineInsert(var ToPaymentLine: Record "Payment Line"; var Process: Record "Payment Class")
    var
        tempPyamentLine: Record "Payment Line";
    begin
        // tempPyamentLine.Get(ToPaymentLine."No.");
        // ToPaymentLine."Created from No." := tempPyamentLine."Document No.";
    end;
    //CodeUnit 10860
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnPostInvPostingBufferOnBeforeGenJnlPostLineRunWithCheck', '', false, false)]
    local procedure OnPostInvPostingBufferOnBeforeGenJnlPostLineRunWithCheck(var GenJnlLine: Record "Gen. Journal Line"; var PaymentHeader: Record "Payment Header"; var PaymentClass: Record "Payment Class")
    var
        ftaFunctions: Codeunit FTA_Functions;
    begin
        ftaFunctions.FctFromPaymentMgt(true);
    end;
    //CodeUnit 99000831
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Engine Mgt.", 'OnBeforeCloseReservEntry', '', false, false)]
    local procedure OnBeforeCloseReservEntry(var ReservEntry: Record "Reservation Entry"; var ReTrack: Boolean; DeleteAll: Boolean; var SkipDeleteReservEntry: Boolean)
    var
        RecLSalesLine: Record "Sales Line";
        RecLPurchLine: Record "Purchase Line";
        RecLReservEntry: Record "Reservation Entry";
    begin
        if (ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Reservation) and
            (ReservEntry."Source Type" in [37, 39]) then begin
            if ReservEntry."Source Type" = 37 then begin
                if RecLSalesLine.GET(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.") then
                    RecLSalesLine.CALCFIELDS("Reserved Quantity");
                if ((RecLSalesLine."Preparation Type" <> RecLSalesLine."Preparation Type"::Remainder) and
                  (RecLSalesLine."Preparation Type" <> RecLSalesLine."Preparation Type"::" "))
                  and (RecLSalesLine."Reserved Quantity" = ABS(ReservEntry.Quantity)) then begin
                    RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Remainder;
                    if DeleteAll = false then
                        RecLSalesLine.MODIFY();
                end;
            end;
            if ReservEntry."Source Type" = 39 then begin
                RecLReservEntry.SETRANGE("Entry No.", ReservEntry."Entry No.");
                RecLReservEntry.SETRANGE("Source Type", 37);
                if not RecLReservEntry.ISEMPTY then begin
                    RecLReservEntry.FINDSET();
                    repeat
                        if RecLSalesLine.GET(RecLReservEntry."Source Subtype", RecLReservEntry."Source ID", RecLReservEntry."Source Ref. No.") then begin
                            RecLSalesLine.CALCFIELDS("Reserved Quantity");
                            if ((RecLSalesLine."Preparation Type" <> RecLSalesLine."Preparation Type"::Remainder) and
                              (RecLSalesLine."Preparation Type" <> RecLSalesLine."Preparation Type"::" "))
                              and (RecLSalesLine."Reserved Quantity" = ABS(RecLReservEntry.Quantity)) then begin
                                RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Remainder;
                                if DeleteAll = false then
                                    RecLSalesLine.MODIFY();
                            end;
                        end;
                    until RecLReservEntry.NEXT() = 0;
                end;
            end;
        end;
    end;
    //CodeUnit 81
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    var
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        DefaultOption := 1;
        RecLSalesReceivablesSetup.GET();
        if RecLSalesReceivablesSetup."Default Posting Date" = RecLSalesReceivablesSetup."Default Posting Date"::"Work Date" then
            SalesHeader.Validate("Posting Date", WorkDate());

    end;
    //CodeUnit 81
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost_YN(var SalesHeader: Record "Sales Header")
    var
        RecGPurchHeader: Record "Purchase Header";
        CuGPurchPost: Codeunit "Purch.-Post";
        CodGNumDoc: Code[20];
    begin
        CodGNumDoc := SalesHeader."Shipping Order No.";
        if (SalesHeader."Document Type" = "Document Type"::Order) and
           (SalesHeader.Ship) and
           (CodGNumDoc <> '') then
            if (RecGPurchHeader.GET(RecGPurchHeader."Document Type"::Order, CodGNumDoc)) then begin
                RecGPurchHeader.CALCFIELDS("Order Type");
                if (RecGPurchHeader."Order Type" = RecGPurchHeader."Order Type"::Transport) then begin
                    RecGPurchHeader.Receive := true;
                    CuGPurchPost.RUN(RecGPurchHeader);
                end;
            end;
    end;
    //Table Purchase Line 39
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnDeleteOnBeforeTestStatusOpen', '', false, false)]
    local procedure OnDeleteOnBeforeTestStatusOpen(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        PurchaseLine.TestStatusOpen();
        PurchaseLine.CALCFIELDS("Reserved Quantity");
        PurchaseLine.TESTFIELD("Reserved Quantity", 0);
    end;
    //Table Purchase Line 39
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateWithWarehouseReceive', '', false, false)]
    local procedure OnAfterUpdateWithWarehouseReceive(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine.CheckPriceMinQtyExist(PurchaseLine."Buy-from Vendor No.");
    end;
    //CodeUnit 442
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer"; CommitIsSuppressed: Boolean; SalesHeader: Record "Sales Header"; DocumentType: Option Invoice,"Credit Memo")
    begin
        GenJnlLine."Mobile Salesperson Code" := SalesHeader."Mobile Salesperson Code";
    end;
    //Table 60111
    // [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    // local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    // var
    //     CstG0001: Label 'No %1|Your Ref: %2|Order FTA %3';

    //     "---FTA1.00---": Integer;
    //     RecGSalesShipHeader: Record "110";
    //     CstG0002: Label 'No %1|Your Ref: %2';
    //     TxtGText: Text[250];
    //     CstG0003: Label '===================== ';


    // begin
    //     SalesLine.INSERT();
    //     NextLineNo := NextLineNo + 10000;
    //     SalesLine."Line No." := NextLineNo;
    //     SalesLine."Document Type" := TempSalesLine."Document Type";
    //     SalesLine."Document No." := TempSalesLine."Document No.";
    //     RecGSalesShipHeader.GET(SalesShptLine."Document No.");
    //     if STRLEN(STRSUBSTNO(CstG0001, SalesShptLine."Document No.", RecGSalesShipHeader."External Document No.", RecGSalesShipHeader."Order No."))
    //            <= 50 then
    //         SalesLine.Description := COPYSTR(STRSUBSTNO(SalesShptLine.CstG0001, SalesShptLine."Document No.", SalesShptLine.RecGSalesShipHeader."External Document No.",
    //         RecGSalesShipHeader."Order No."), 1, 50)
    //     else
    //         SalesLine.Description := COPYSTR(STRSUBSTNO(CstG0002, SalesShptLine."Document No.", RecGSalesShipHeader."External Document No."), 1, 50);
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnBeforeAutoReservePurchLine', '', false, false)]
    local procedure OnBeforeAutoReservePurchLine(ReservSummEntryNo: Integer; var RemainingQtyToReserve: Decimal; var RemainingQtyToReserveBase: Decimal; Description: Text[100]; AvailabilityDate: Date; var IsReserved: Boolean; var Search: Text[1]; var NextStep: Integer; CalcReservEntry: Record "Reservation Entry")
    var
        PurchLine: Record "Purchase Line";
    begin
        // PurchLine.FilterLinesForReservation(
        //  CalcReservEntry, Enum::"Purchase Document Type".FromInteger(ReservSummEntryNo - Enum::"Reservation Summary Type"::"Purchase Quote".AsInteger()),
        //  GetAvailabilityFilter(AvailabilityDate), Positive);
        //todo : Ican't find solution
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Management", 'OnBeforeSetValueArray', '', false, false)]
    local procedure OnBeforeSetValueArray(EntryStatus: Option; var ValueArray: array[30] of Integer; var ArrayCounter: Integer; var IsHandled: Boolean)
    begin
        Clear(ValueArray);
        case EntryStatus of
            0:
                begin
                    // Reservation
                    ValueArray[1] := Enum::"Reservation Summary Type"::"Item Ledger Entry".AsInteger();
                    ValueArray[2] := Enum::"Reservation Summary Type"::"Sales Order".AsInteger();
                    //    TODO : variable globale
                    // if BooGResaAssFTA then begin
                    //     ValueArray[1] := 12;
                    //     ValueArray[2] := 1;
                    // end;
                    ValueArray[3] := Enum::"Reservation Summary Type"::"Sales Return Order".AsInteger();
                    ValueArray[4] := Enum::"Reservation Summary Type"::"Purchase Order".AsInteger();
                    ValueArray[5] := Enum::"Reservation Summary Type"::"Purchase Return Order".AsInteger();
                    ValueArray[6] := Enum::"Reservation Summary Type"::"Firm Planned Production Order".AsInteger();
                    ValueArray[7] := Enum::"Reservation Summary Type"::"Released Production Order".AsInteger();
                    ValueArray[8] := Enum::"Reservation Summary Type"::"Firm Planned Prod. Order Comp.".AsInteger();
                    ValueArray[9] := Enum::"Reservation Summary Type"::"Released Prod. Order Comp.".AsInteger();
                    ValueArray[10] := Enum::"Reservation Summary Type"::"Transfer Shipment".AsInteger();
                    ValueArray[11] := Enum::"Reservation Summary Type"::"Transfer Receipt".AsInteger();
                    ValueArray[12] := Enum::"Reservation Summary Type"::"Service Order".AsInteger();
                    ValueArray[13] := Enum::"Reservation Summary Type"::"Job Planning Order".AsInteger();
                    ValueArray[14] := Enum::"Reservation Summary Type"::"Assembly Order Header".AsInteger();
                    ValueArray[15] := Enum::"Reservation Summary Type"::"Assembly Order Line".AsInteger();
                    ValueArray[16] := Enum::"Reservation Summary Type"::"Inventory Receipt".AsInteger();
                    ValueArray[17] := Enum::"Reservation Summary Type"::"Inventory Shipment".AsInteger();
                    ArrayCounter := 17;
                end;
            1:
                begin // Order Tracking
                    ValueArray[1] := Enum::"Reservation Summary Type"::"Item Ledger Entry".AsInteger();
                    ValueArray[2] := Enum::"Reservation Summary Type"::"Sales Order".AsInteger();
                    ValueArray[3] := Enum::"Reservation Summary Type"::"Sales Return Order".AsInteger();
                    ValueArray[4] := Enum::"Reservation Summary Type"::"Requisition Line".AsInteger();
                    ValueArray[5] := Enum::"Reservation Summary Type"::"Purchase Order".AsInteger();
                    ValueArray[6] := Enum::"Reservation Summary Type"::"Purchase Return Order".AsInteger();
                    ValueArray[7] := Enum::"Reservation Summary Type"::"Planned Production Order".AsInteger();
                    ValueArray[8] := Enum::"Reservation Summary Type"::"Firm Planned Production Order".AsInteger();
                    ValueArray[9] := Enum::"Reservation Summary Type"::"Released Production Order".AsInteger();
                    ValueArray[10] := Enum::"Reservation Summary Type"::"Planned Prod. Order Comp.".AsInteger();
                    ValueArray[11] := Enum::"Reservation Summary Type"::"Firm Planned Prod. Order Comp.".AsInteger();
                    ValueArray[12] := Enum::"Reservation Summary Type"::"Released Prod. Order Comp.".AsInteger();
                    ValueArray[13] := Enum::"Reservation Summary Type"::"Transfer Shipment".AsInteger();
                    ValueArray[14] := Enum::"Reservation Summary Type"::"Transfer Receipt".AsInteger();
                    ValueArray[15] := Enum::"Reservation Summary Type"::"Service Order".AsInteger();
                    ValueArray[16] := Enum::"Reservation Summary Type"::"Job Planning Order".AsInteger();
                    ValueArray[17] := Enum::"Reservation Summary Type"::"Assembly Order Header".AsInteger();
                    ValueArray[18] := Enum::"Reservation Summary Type"::"Assembly Order Line".AsInteger();
                    ValueArray[19] := Enum::"Reservation Summary Type"::"Inventory Receipt".AsInteger();
                    ValueArray[20] := Enum::"Reservation Summary Type"::"Inventory Shipment".AsInteger();
                    ArrayCounter := 20;
                end;
            2:
                begin // Simulation order tracking
                    ValueArray[1] := Enum::"Reservation Summary Type"::"Sales Quote".AsInteger();
                    ValueArray[2] := Enum::"Reservation Summary Type"::"Simulated Production Order".AsInteger();
                    ValueArray[3] := Enum::"Reservation Summary Type"::"Simulated Prod. Order Comp.".AsInteger();
                    ArrayCounter := 3;
                end;
            3:
                begin // Item Tracking
                    ValueArray[1] := Enum::"Reservation Summary Type"::"Item Ledger Entry".AsInteger();
                    ValueArray[2] := Enum::"Reservation Summary Type"::"Item Tracking Line".AsInteger();
                    ArrayCounter := 2;
                end;
        end;
        IsHandled := true;
    end;
    //Page 498
    [EventSubscriber(ObjectType::Page, Page::"Reservation", 'OnAfterSetSalesLine', '', false, false)]
    local procedure OnAfterSetSalesLine2(var EntrySummary: Record "Entry Summary"; ReservEntry: Record "Reservation Entry")
    begin
        // SetReservEntryFTA(ReservEntry); //TODO : i can't find solution
    end;
    //<<<<<<<<<<<<<<<<<<Partie Mortadha >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnTransferReservEntryOnAfterTransferFields', '', false, false)]
    // local procedure OnTransferReservEntryOnAfterTransferFields(var NewReservationEntry: Record "Reservation Entry"; var OldReservationEntry: Record "Reservation Entry"; var UseQtyToHandle: Boolean; var UseQtyToInvoice: Boolean; var CurrSignFactor: Integer)
    // var
    //     ItemJournalLine: Record "Item Journal Line";
    //     RecLReservEntry: Record "Reservation Entry";
    //     RecLxOldReservEntry: Record "Reservation Entry" temporary;
    //     RecLSalesLine: Record "Sales Line";
    //     RecLSalesLine2: Record "Sales Line";
    //     CreateReservEntry: Codeunit "Create Reserv. Entry";
    //     QtyToHandleThisLine: Decimal;
    //     QtyToInvoiceThisLine: Decimal;
    //     TransferQty: Decimal;
    //     xTransferQty: Decimal;

    // begin

    //     RecLxOldReservEntry.TRANSFERFIELDS(OldReservationEntry);


    //     /*******************/
    //     case OldReservationEntry."Source Type" of
    //         Database::"Sales Line":
    //             begin
    //                 UseQtyToHandle := OldReservationEntry.TrackingExists();
    //                 RecLSalesLine2.get(OldReservationEntry."Source Type", OldReservationEntry."Source ID", OldReservationEntry."Source Ref. No.");
    //                 TransferQty := RecLSalesLine2."Outstanding Qty. (Base)";
    //                 CurrSignFactor := CreateReservEntry.SignFactor(OldReservationEntry);
    //                 TransferQty := TransferQty * CurrSignFactor;
    //                 xTransferQty := TransferQty;

    //                 if UseQtyToHandle then begin // Used when handling Item Tracking
    //                     QtyToHandleThisLine := OldReservationEntry."Qty. to Handle (Base)";
    //                     QtyToInvoiceThisLine := OldReservationEntry."Qty. to Invoice (Base)";
    //                     if Abs(TransferQty) > Abs(QtyToHandleThisLine) then
    //                         TransferQty := QtyToHandleThisLine;
    //                     if UseQtyToInvoice then // Used when posting sales and purchase
    //                         if Abs(TransferQty) > Abs(QtyToInvoiceThisLine) then
    //                             TransferQty := QtyToInvoiceThisLine;
    //                 end else
    //                     QtyToHandleThisLine := OldReservationEntry."Quantity (Base)";
    //             end;
    //         Database::"Item Journal Line":
    //             begin
    //                 UseQtyToHandle := OldReservationEntry.TrackingExists();
    //                 ItemJournalLine.get(OldReservationEntry."Source Type", OldReservationEntry."Source ID", OldReservationEntry."Source Ref. No.");
    //                 // TransferQty := ItemJournalLine."Outstanding Qty. (Base)";//QtyToBeShippedBase("Quanity (Base)")
    //                 CurrSignFactor := CreateReservEntry.SignFactor(OldReservationEntry);
    //                 TransferQty := TransferQty * CurrSignFactor;
    //                 xTransferQty := TransferQty;

    //                 if UseQtyToHandle then begin // Used when handling Item Tracking
    //                     QtyToHandleThisLine := OldReservationEntry."Qty. to Handle (Base)";
    //                     QtyToInvoiceThisLine := OldReservationEntry."Qty. to Invoice (Base)";
    //                     if Abs(TransferQty) > Abs(QtyToHandleThisLine) then
    //                         TransferQty := QtyToHandleThisLine;
    //                     if UseQtyToInvoice then // Used when posting sales and purchase
    //                         if Abs(TransferQty) > Abs(QtyToInvoiceThisLine) then
    //                             TransferQty := QtyToInvoiceThisLine;
    //                 end else
    //                     QtyToHandleThisLine := OldReservationEntry."Quantity (Base)";
    //             end;
    //     end;
    //     /*************************/


    //     if (TransferQty <> 0) and (RecLxOldReservEntry."Source Type" = 39) then begin
    //         RecLReservEntry.SETRANGE("Entry No.", RecLxOldReservEntry."Entry No.");
    //         RecLReservEntry.SETRANGE("Source Type", 37);
    //         RecLReservEntry.SETRANGE("Item No.", RecLxOldReservEntry."Item No.");
    //         if not RecLReservEntry.ISEMPTY then begin
    //             RecLReservEntry.FINDSET();
    //             repeat
    //                 if RecLSalesLine.GET(RecLReservEntry."Source Subtype", RecLReservEntry."Source ID", RecLReservEntry."Source Ref. No.") then begin
    //                     RecLSalesLine.CALCFIELDS("Reserved Quantity");
    //                     if (RecLSalesLine."Preparation Type" <> RecLSalesLine."Preparation Type"::Stock) and
    //                        (RecLSalesLine."Reserved Quantity" <= ABS(TransferQty)) and
    //                         (RecLSalesLine."Outstanding Qty. (Base)" <= ABS(TransferQty)) then begin
    //                         RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Stock;
    //                         RecLSalesLine.MODIFY();
    //                     end;
    //                 end;
    //             until RecLReservEntry.NEXT() = 0;
    //         end;
    //     end;
    //     //<<FE-DIVERS 18/09/2009
    // end; //TODO Verif

    //codeunit 99000830
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnTransferReservEntryOnAfterCalcNewButUnchangedVersion', '', false, false)]
    local procedure OnTransferReservEntryOnAfterCalcNewButUnchangedVersion(var NewReservEntry: Record "Reservation Entry"; OldReservEntry: Record "Reservation Entry"; TransferQty: Decimal; var DoCreateNewButUnchangedVersion: Boolean)
    var
        RecLReservEntry: Record "Reservation Entry";
        RecLxOldReservEntry: Record "Reservation Entry" temporary;
        RecLSalesLine: Record "Sales Line";
    begin
        RecLxOldReservEntry.TRANSFERFIELDS(OldReservEntry);

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
    end;
    //<<<<<<<<<<<<<<<<<<Partie Iheb >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //Report 295
    [EventSubscriber(ObjectType::Report, report::"Combine Shipments", 'OnBeforeSalesInvHeaderModify', '', false, false)]

    local procedure OnBeforeSalesInvHeaderModify(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    var

        Fct_FinalizeAdress: Report "Combine Shipments";


    begin

        //>>FTA1.04
        SalesHeader."Mobile Salesperson Code" := SalesOrderHeader."Mobile Salesperson Code";
        //<<FTA1.04
        //>>FE VTE_REGROUPEMENT_BL: SOBI 25/07/2011
        if not SalesOrderHeader."Combine Shipments" then


            //<<FE VTE_REGROUPEMENT_BL: SOBI 25/07/2011
            Fct_FinalizeAdress.Fct_FinalizeAdress();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPost_CU91(var PurchaseHeader: Record "Purchase Header")
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

        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) and
           (PurchaseHeader.Receive) and
           (CodGNumDoc <> '') then
            if (RecGPurchHeader.GET(RecGPurchHeader."Document Type"::Order, CodGNumDoc)) then begin
                RecGPurchHeader.CALCFIELDS("Order Type");
                if (RecGPurchHeader."Order Type" = RecGPurchHeader."Order Type"::Transport) then begin

                    if (RecGPurchHeader."Initial Order No." <> '') and
                       (RecGPurchHeader."Initial Order Type" <> RecGPurchHeader."Initial Order Type"::" ") then begin
                        RecGPurchHeader.Receive := true;
                        CuGPurchPost.RUN(RecGPurchHeader);
                    end;

                    BooGARefermer := false;
                    if (RecGPurchHeader."Initial Order No." = '') and
                       (RecGPurchHeader."Initial Order Type" = RecGPurchHeader."Initial Order Type"::" ") then begin

                        if RecGPurchHeader.Status = RecGPurchHeader.Status::Released then begin
                            BooGARefermer := true;
                            CuGReleasePurchaseDoc.Reopen(RecGPurchHeader);
                        end;

                        RecGPurchLine.RESET();
                        RecGPurchLine.SETRANGE("Document Type", RecGPurchHeader."Document Type");
                        RecGPurchLine.SETRANGE("Document No.", RecGPurchHeader."No.");
                        if RecGPurchLine.FINDSET(true, false) then
                            repeat
                                if RecGPurchLine."Initial Order No." = CodGNumDocMarchandise then begin
                                    DecGQty := RecGPurchLine.Quantity;
                                    RecGPurchLine.VALIDATE(Quantity, DecGQty);
                                end;

                                if RecGPurchLine."Initial Order No." <> CodGNumDocMarchandise then
                                    RecGPurchLine.VALIDATE("Qty. to Receive", 0);

                                RecGPurchLine.MODIFY();
                            until RecGPurchLine.NEXT() = 0;

                        if BooGARefermer then
                            CuGReleasePurchaseDoc.RUN(RecGPurchHeader);

                        RecGPurchHeader.Receive := true;
                        CuGPurchPost.RUN(RecGPurchHeader);
                    end;
                end;
            end;
    end;
    //Page 233
    [EventSubscriber(ObjectType::Page, Page::"Apply Vendor Entries", 'OnBeforeCallVendEntrySetApplIDSetApplId', '', true, false)]
    local procedure OnBeforeCallVendEntrySetApplIDSetApplId(VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; var TempApplyingVendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean)
    var
        AppVendEntries: Page "Apply Vendor Entries"; //todo : ---> verifier 
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
    //redirect report
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", 'SubstituteReport', '', false, false)]
    local procedure SubstituteReport(ReportId: Integer; RunMode: Option Normal,ParametersOnly,Execute,Print,SaveAs,RunModal; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer)
    begin
        if ReportId = Report::"Batch Post Sales Orders" then
            NewReportId := Report::"Batch.Post.Sales.Orders";
        if ReportId = Report::"Sales Reservation Avail." then
            NewReportId := Report::"Sales Reservation Avail.spe";
        if ReportId = Report::"Item Register - Quantity" then
            NewReportId := Report::"Item Register - Quantityspe";
        if ReportId = Report::Journals then
            NewReportId := Report::JournalsFTA;
    end;
    //Table 21
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."Mobile Salesperson Code" := GenJournalLine."Mobile Salesperson Code";
    end;
    //TODO A verifier
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
    //Codeunit 80
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckMandatoryFields', '', false, false)]

    local procedure OnAfterCheckMandatoryFields(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        function: Codeunit FTA_Functions;

    begin

        function."FTA.UPDATECOST"(SalesHeader);

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader.TESTFIELD(Preparer);
            SalesHeader.TESTFIELD(Assembler);
            SalesHeader.TESTFIELD(Packer);
        end;
    end;
    //Codeunit 80
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeArchiveUnpostedOrder', '', false, false)]

    local procedure OnBeforeArchiveUnpostedOrder(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; PreviewMode: Boolean; var OrderArchived: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";

        SalesLine: Record "Sales Line";
        ArchiveManagement: Codeunit ArchiveManagement;

    begin
        IsHandled := true;
        OnBeforeArchiveUnpostedOrder(SalesHeader, IsHandled, PreviewMode, OrderArchived);
        if IsHandled then
            exit;

        // todo a supprimer a verifeir  GetSalesSetup();
        SalesSetup.Get();
        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"]) then
            exit;
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and not SalesSetup."Archive Orders" then
            exit;
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") and not SalesSetup."Archive Return Orders" then
            exit;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Quantity, '<>0');
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SalesLine.SETRANGE(Prepare, true);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SalesLine.SetFilter("Qty. to Ship", '<>0')
        else
            SalesLine.SetFilter("Return Qty. to Receive", '<>0');
        if not SalesLine.IsEmpty() and not PreviewMode then begin
            ArchiveManagement.RoundSalesDeferralsForArchive(SalesHeader, SalesLine);
            ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
            OrderArchived := true;
        end;
    end;
    //todo emplacement
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterSetEverythingInvoiced', '', false, false)]

    local procedure OnPostSalesLineOnAfterSetEverythingInvoiced(SalesLine: Record "Sales Line"; var EverythingInvoiced: Boolean; var IsHandled: Boolean; SalesHeader: Record "Sales Header")
    begin
        //>>FTA 28.01.2022
        if SalesHeader.Ship and (SalesLine.Type = SalesLine.Type::Item) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then
            SalesLine.TESTFIELD(Quantity);
        //<<FTA 28.01.2022
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeRecalculateSalesLine', '', false, false)]
    local procedure OnBeforeRecalculateSalesLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; var FromSalesHeader: Record "Sales Header"; var FromSalesLine: Record "Sales Line"; var CopyThisLine: Boolean; var IsHandled: Boolean)
    var
        GLAcc: Record "G/L Account";
    begin
        ToSalesLine.Validate(Type, FromSalesLine.Type);
        ToSalesLine.Description := FromSalesLine.Description;
        ToSalesLine.Validate("Description 2", FromSalesLine."Description 2");

        if (FromSalesLine.Type <> FromSalesLine.Type::" ") and (FromSalesLine."No." <> '') then begin
            if ToSalesLine.Type = ToSalesLine.Type::"G/L Account" then begin
                ToSalesLine."No." := FromSalesLine."No.";
                GLAcc.Get(FromSalesLine."No.");
                CopyThisLine := GLAcc."Direct Posting";
                if CopyThisLine then begin
                    ToSalesLine.VALIDATE("Item Base", FromSalesLine."Item Base");
                    ToSalesLine.VALIDATE("No.", FromSalesLine."No.");
                end
            end else begin
                ToSalesLine.VALIDATE("Item Base", FromSalesLine."Item Base");
                ToSalesLine.Validate("No.", FromSalesLine."No.");
            end;

            ToSalesLine.Validate("Variant Code", FromSalesLine."Variant Code");

            IsHandled := false;
            if not IsHandled then
                ToSalesLine.Validate("Location Code", FromSalesLine."Location Code");

            ToSalesLine.Validate("Unit of Measure", FromSalesLine."Unit of Measure");
            ToSalesLine.Validate("Unit of Measure Code", FromSalesLine."Unit of Measure Code");
            ToSalesLine.Validate(Quantity, FromSalesLine.Quantity);

            if not (FromSalesLine.Type in [FromSalesLine.Type::Item, FromSalesLine.Type::Resource]) then begin
                if (FromSalesHeader."Currency Code" <> ToSalesHeader."Currency Code") or
                   (FromSalesHeader."Prices Including VAT" <> ToSalesHeader."Prices Including VAT")
                then begin
                    ToSalesLine."Unit Price" := 0;
                    ToSalesLine."Line Discount %" := 0;
                end else begin
                    ToSalesLine.Validate("Unit Price", FromSalesLine."Unit Price");
                    ToSalesLine.Validate("Line Discount %", FromSalesLine."Line Discount %");
                end;
                if ToSalesLine.Quantity <> 0 then
                    ToSalesLine.Validate("Line Discount Amount", FromSalesLine."Line Discount Amount");
            end;

            ToSalesLine.Validate("Work Type Code", FromSalesLine."Work Type Code");
            if (ToSalesLine."Document Type" = ToSalesLine."Document Type"::Order) and
               (FromSalesLine."Purchasing Code" <> '')
            then
                ToSalesLine.Validate("Purchasing Code", FromSalesLine."Purchasing Code");
        end;
        if (FromSalesLine.Type = FromSalesLine.Type::" ") and (FromSalesLine."No." <> '') then
            ToSalesLine.Validate("No.", FromSalesLine."No.");
    end;
    //TODO : verifier ihab les variables
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesDocument', '', false, false)]

    local procedure OnAfterCopySalesDocument(FromDocumentType: Option; FromDocumentNo: Code[20]; var ToSalesHeader: Record "Sales Header"; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; IncludeHeader: Boolean; RecalculateLines: Boolean; MoveNegLines: Boolean)
    var
        //todo a verifier sales line line variable
        ToSalesLine: Record "Sales Line";
        FrmLAssignmentItem: Page "Assignment Item";
        RecLInventorySetup: Record 313;
        RecLItem: Record Item;
        BoopF12: Boolean;
    begin
        //>>FED_20090415:PA 15/04/2009
        COMMIT();
        RecLInventorySetup.GET();
        if RecLInventorySetup."Reservation FTA" and
           (ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Order) then begin

            ToSalesLine.RESET();
            ToSalesLine.SETRANGE("Document Type", ToSalesLine."Document Type"::Order);
            ToSalesLine.SETRANGE("Document No.", ToSalesHeader."No.");
            ToSalesLine.SETRANGE(Type, ToSalesLine.Type::Item);
            ToSalesLine.SETRANGE("Preparation Type", ToSalesLine."Preparation Type"::" ");
            if ToSalesLine.FINDSET() then
                repeat
                    if RecLItem.GET(ToSalesLine."No.") then;
                    if (ToSalesLine.Quantity <> 0) and (ToSalesLine."Reserved Quantity" <> ToSalesLine.Quantity) and
                         not (RecLItem."Inventory Value Zero") then begin
                        CLEAR(FrmLAssignmentItem);
                        BoopF12 := false;
                        FrmLAssignmentItem.FctGetParm(ToSalesLine, ToSalesLine.Quantity, ToSalesLine."Preparation Type");
                        FrmLAssignmentItem.SETTABLEVIEW(ToSalesLine);
                        FrmLAssignmentItem.SETRECORD(ToSalesLine);
                        FrmLAssignmentItem.RUNMODAL();
                    end;
                until ToSalesLine.NEXT() = 0;
        end;
    end;
    //todo a verifier
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin

        GenJournalLine."Posting Group" := SalesHeader."Customer Posting Group";

        GenJournalLine."Payment Method Code" := SalesHeader."Payment Method Code";

        GenJournalLine."Posting Group" := SalesHeader."Customer Posting Group";
    end;
    //Todo a verifier
    // [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterCopyToGenJnlLine', '', false, false)]
    // local procedure OnAfterCopyToGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer");
    // begin
    //     //>>REGLEMENT 01/08/2006 COR001 [13] Mise … jour du champ Mode de r‚glement de la feuille de saisie
    //     GenJnlLine."Payment Method Code" := InvoicePostingBuffer."Payment Method Code";
    //     //<<REGLEMENT 01/08/2006 COR001 [13] Mise … jour du champ Mode de r‚glement de la feuille de saisie
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostLines', '', false, false)]
    local procedure OnBeforePostLines(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin

        if SalesHeader."Document Type" = "Document Type"::Order then
            SalesLine.SETRANGE(Prepare, true);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFindNotShippedLines', '', false, false)]

    local procedure OnAfterFindNotShippedLines(SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line" temporary)

    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            //SalesLine.SETFILTER("Planned Delivery Date",'<=%1',TODAY);
            TempSalesLine.SETRANGE(Prepare, true);
    end;
    //todo a verifier emplcament
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateLastPostingNos', '', false, false)]
    local procedure OnAfterUpdateLastPostingNos(var SalesHeader: Record "Sales Header")
    begin

        SalesHeader."Total Parcels" := 0;
        SalesHeader."Total weight" := 0;
        SalesHeader.Preparer := '';
        SalesHeader.Assembler := '';
        SalesHeader.Packer := '';
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostUpdateOrderLineOnBeforeGetReturnQtyReceived', '', false, false)]

    local procedure OnPostUpdateOrderLineOnBeforeGetReturnQtyReceived(TempSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin

        TempSalesLine.Prepare := false;
        TempSalesLine."Start Date" := TODAY;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateWhseDocuments', '', false, false)]
    local procedure OnAfterUpdateWhseDocuments(SalesHeader: Record "Sales Header"; WhseShip: Boolean; WhseReceive: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; WhseRcptHeader: Record "Warehouse Receipt Header"; EverythingInvoiced: Boolean)
    var
        RecGParmNavi: Record 51004;
        RecGArchiveManagement: Codeunit 5063;
    begin

        if RecGParmNavi.GET() then
            if RecGParmNavi."Filing Sales Orders" then
                RecGArchiveManagement.StoreSalesDocument(SalesHeader, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure OnBeforeSalesShptHeaderModify(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin

        SalesShptHeader."Total weight" := SalesShptHeader."Total weight";
        SalesShptHeader."Total Parcels" := SalesShptHeader."Total Parcels";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ArchiveManagement", 'OnAfterTransferFromArchToSalesHeader', '', false, false)]
    local procedure OnAfterTransferFromArchToSalesHeader(var SalesHeader: Record "Sales Header"; var SalesHeaderArchive: Record "Sales Header Archive")
    begin
        SalesHeader.VALIDATE("Mobile Salesperson Code", SalesHeaderArchive."Mobile Salesperson Code");
    end;
    //Codeunit 5815
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Sales Shipment Line", 'OnBeforeNewSalesShptLineInsert', '', false, false)]

    local procedure OnBeforeNewSalesShptLineInsert(var NewSalesShipmentLine: Record "Sales Shipment Line"; OldSalesShipmentLine: Record "Sales Shipment Line")
    var

        RecLKitSalesShipLine: Record 914;
        CstL001: label 'ENU=Deletion forbidden because of the line %1 having a Kit.;FRA=Annulation impossible … cause de la ligne %1 contenant un Kit.';
    begin
        repeat
            RecLKitSalesShipLine.SETRANGE("Document No.", OldSalesShipmentLine."Document No.");
            RecLKitSalesShipLine.SETRANGE("Document Line No.", OldSalesShipmentLine."Line No.");
            if not RecLKitSalesShipLine.ISEMPTY then
                ERROR(CstL001, OldSalesShipmentLine."Line No.");
        until OldSalesShipmentLine.NEXT() = 0;
        //<<FTA_DIVERS.001

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCopySellToCustomerAddressFieldsFromCustomerOnAfterAssignSellToCustomerAddress', '', false, false)]

    local procedure OnCopySellToCustomerAddressFieldsFromCustomerOnAfterAssignSellToCustomerAddress(var SalesHeader: Record "Sales Header"; Customer: Record Customer)

    begin

        SalesHeader."Transaction Type" := Customer."Transaction Type";
        SalesHeader."Transaction Specification" := Customer."Transaction Specification";
        SalesHeader."Transport Method" := Customer."Transport Method";
        SalesHeader."Exit Point" := Customer."Exit Point";
        SalesHeader.Area := Customer.Area;
        SalesHeader."EU 3-Party Trade" := Customer."EU 3-Party Trade";



        SalesHeader."Posting Description" := Customer.Name;



        SalesHeader."Fax No." := Customer."Fax No.";
        SalesHeader."E-Mail" := Customer."E-Mail";


    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeSetBillToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnBeforeSetBillToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; var BillToCustomer: Record Customer; var SkipBillToContact: Boolean; var IsHandled: Boolean; xSalesHeader: Record "Sales Header"; var GLSetup: Record "General Ledger Setup"; CurrentFieldNo: Integer)
    begin

        SalesHeader."Mobile Salesperson Code" := BillToCustomer."Mobile Salesperson Code";
        SalesHeader."Customer Typology" := BillToCustomer."Customer Typology";


    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCopyShipToCustomerAddressFieldsFromShipToAddr', '', false, false)]
    local procedure OnBeforeCopyShipToCustomerAddressFieldsFromShipToAddr(var SalesHeader: Record "Sales Header"; var ShipToAddress: Record "Ship-to Address"; var IsHandled: Boolean)
    begin

        SalesHeader."Transaction Type" := ShipToAddress."Transaction Type";
        SalesHeader."Transaction Specification" := ShipToAddress."Transaction Specification";
        SalesHeader."Transport Method" := ShipToAddress."Transport Method";
        SalesHeader."Exit Point" := ShipToAddress."Exit Point";
        SalesHeader.Area := ShipToAddress.Area;
        SalesHeader."EU 3-Party Trade" := ShipToAddress."EU 3-Party Trade";


    end;


    //todo a verifier
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateRequestedDeliveryDate', '', false, false)]
    local procedure OnBeforeValidateRequestedDeliveryDate(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; xSalesHeader: Record "Sales Header"; CurrentFieldNo: Integer)

    var
        RecLSalesLine: Record 37;
        CstL001: label 'ENU=This change can delete the reservation of the lines : do want to continue?;FRA=Cette op‚ration risque de d‚r‚server les lignes : souhaitez-vous continuer?';
        CstL002: label 'ENU=Canceled operation;FRA=Op‚ration annul‚e';
    begin
        //>>FED_20090415:PA 15/04/2009
        RecLSalesLine.SETRANGE("Document Type", xSalesHeader."Document Type");
        RecLSalesLine.SETRANGE("Document No.", xSalesHeader."No.");
        RecLSalesLine.SETFILTER("Promised Delivery Date", '>%1', xSalesHeader."Requested Delivery Date");
        RecLSalesLine.SETRANGE(Type, RecLSalesLine.Type::Item);

        if not RecLSalesLine.ISEMPTY then begin
            RecLSalesLine.FINDSET();
            repeat
                RecLSalesLine.CALCFIELDS("Reserved Qty. (Base)");
                if RecLSalesLine."Reserved Qty. (Base)" <> 0 then
                    if not CONFIRM(CstL001, false) then
                        ERROR(CstL002);
            until (RecLSalesLine.NEXT() = 0) or (RecLSalesLine."Reserved Qty. (Base)" <> 0);
        end;
        //<<FED_20090415:PA 15/04/2009
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidatePromisedDeliveryDate', '', false, false)]
    local procedure OnBeforeValidatePromisedDeliveryDate(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        RecLSalesLine: Record 37;
        CstL001: Label 'ENU=This change can delete the reservation of the lines : do want to continue?;FRA=Cette op‚ration risque de d‚r‚server les lignes : souhaitez-vous continuer?';
        CstL002: label 'ENU=Canceled operation;FRA=Op‚ration annul‚e';
    begin
        //>>FED_20090415:PA 15/04/2009
        RecLSalesLine.SETRANGE("Document Type", xSalesHeader."Document Type");
        RecLSalesLine.SETRANGE("Document No.", xSalesHeader."No.");
        RecLSalesLine.SETFILTER("Requested Delivery Date", '>%1', xSalesHeader."Promised Delivery Date");
        RecLSalesLine.SETRANGE(Type, RecLSalesLine.Type::Item);

        if not RecLSalesLine.ISEMPTY then begin
            RecLSalesLine.FINDSET();
            repeat
                RecLSalesLine.CALCFIELDS("Reserved Qty. (Base)");
                if RecLSalesLine."Reserved Qty. (Base)" <> 0 then
                    if not CONFIRM(CstL001, false) then
                        ERROR(CstL002);
            until (RecLSalesLine.NEXT() = 0) or (RecLSalesLine."Reserved Qty. (Base)" <> 0);
        end;
        //<<FED_20090415:PA 15/04/2009


    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict', '', false, false)]
    local procedure OnUpdateSalesLinesByFieldNoOnAfterCalcShouldConfirmReservationDateConflict(var SalesHeader: Record "Sales Header"; ChangedFieldNo: Integer; var ShouldConfirmReservationDateConflict: Boolean)
    begin

        if SalesHeader."Promised Delivery Date" <> 0D then
            SalesHeader."Planned Shipment Date" := CALCDATE(SalesHeader."Shipping Time", SalesHeader."Promised Delivery Date")
        else
            if SalesHeader."Requested Delivery Date" <> 0D then
                SalesHeader."Planned Shipment Date" := CALCDATE(SalesHeader."Shipping Time", SalesHeader."Requested Delivery Date");

    end;




    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnInitRecordOnBeforeAssignResponsibilityCenter', '', false, false)]

    local procedure OnInitRecordOnBeforeAssignResponsibilityCenter(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if SalesHeader."Sell-to Customer Name" <> '' then
            SalesHeader."Posting Description" := SalesHeader."Sell-to Customer Name";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnInitRecordOnBeforeAssignOrderDate', '', false, false)]

    local procedure OnInitRecordOnBeforeAssignOrderDate(var SalesHeader: Record "Sales Header"; var NewOrderDate: Date)
    begin
        SalesHeader."Order Shipment Date" := WORKDATE();
    end;



    [EventSubscriber(ObjectType::Table, Database::"Assembly Line", 'OnAfterCopyFromResource', '', false, false)]


    local procedure OnAfterCopyFromResource(var AssemblyLine: Record "Assembly Line"; Resource: Record Resource; AssemblyHeader: Record "Assembly Header")

    var
        //    todo verifier les variable se sont des varibale global
        RecLItem: Record 27;

        RecLProductionBOMLine: Record 90;
        BoolFirstRead: Boolean;
        DecLAvailibityNoReserved: Decimal;
        DecGQtyKit: Decimal;
        RecGKitSalesLine: Record 901;
        RecGAssemLink: Record 904;
        BooGResaAssFTA: Boolean;
    begin

        if AssemblyLine.Type = Type::Item then
            RecLItem.SETFILTER("Location Filter", AssemblyLine."Location Code");
        if RecLItem.GET(AssemblyLine."No.") then begin
            AssemblyLine."Vendor No." := RecLItem."Vendor No.";


            RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
            DecGQtyKit := 0;
            RecGKitSalesLine.SETRANGE("Document Type", RecGKitSalesLine."Document Type"::Order);
            RecGKitSalesLine.SETRANGE(Type, RecGKitSalesLine.Type::Item);
            RecGKitSalesLine.SETRANGE("No.", AssemblyLine."No.");
            RecGKitSalesLine.SETFILTER("Remaining Quantity (Base)", '<>0');


            if not RecGKitSalesLine.ISEMPTY then begin
                RecGKitSalesLine.FINDSET();
                repeat

                    //>>MIG NAV 2015 : Upgrade Old Code
                    if RecGAssemLink.GET(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.") then
                        //<<MIG NAV 2015 : Upgrade Old Code

                        //>>MIG NAV 2015 : Upgrade Old Code
                        //OLD IF (RecGKitSalesLine."Document No." <> xKitSalesLine."Document No.") OR
                        //OLD      (RecGKitSalesLine."Line No." <> xKitSalesLine."Document Line No.") THEN
                        if (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") or (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") then
                            //<<MIG NAV 2015 : Upgrade Old Code
                            DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
                until RecGKitSalesLine.NEXT() = 0;
            end;

            AssemblyLine."Avaibility no reserved" := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + DecGQtyKit)
                                        + RecLItem."Reserved Qty. on Purch. Orders";
            //<<FED_20090415:PA 15/04/2009

            //>>MIG NAV 2015 : Upgrade Old Code
            //OLD IF RecLItem."Kit BOM No." = '' THEN
            RecLItem.CALCFIELDS("Assembly BOM");
            if RecLItem."Assembly BOM" then
                AssemblyLine."Kit Qty Available by Assembly" := 0
            else begin
                AssemblyLine."Kit Qty Available by Assembly" := 0;
                BoolFirstRead := false;
                RecLProductionBOMLine.RESET();
                RecLProductionBOMLine.SETRANGE("Parent Item No.", RecLItem."No.");
                if RecLProductionBOMLine.FINDSET() then
                    repeat
                        if (RecLProductionBOMLine.Type = RecLProductionBOMLine.Type::Item) then
                            if RecLItem.GET(RecLProductionBOMLine."No.") then begin
                                //PAMO RecLItem.SETRANGE("Date Filter","Shipment Date");
                                RecLItem.SETFILTER("Location Filter", AssemblyLine."Location Code");
                                //>>FED_20090415:PA 15/04/2009
                                // {RecLItem.CALCFIELDS(Inventory,"Reserved Qty. on Inventory");
                                // DecLAvailibityNoReserved := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";      }
                                RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
                                DecGQtyKit := 0;
                                RecGKitSalesLine.SETRANGE("Document Type", RecGKitSalesLine."Document Type"::Order);
                                RecGKitSalesLine.SETRANGE(Type, RecGKitSalesLine.Type::Item);
                                RecGKitSalesLine.SETRANGE("No.", AssemblyLine."No.");
                                RecGKitSalesLine.SETFILTER(RecGKitSalesLine."Remaining Quantity (Base)", '<>0');

                                //>>MIG NAV 2015 : Upgrade Old Code
                                RecGAssemLink.GET(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.");
                                //<<MIG NAV 2015 : Upgrade Old Code

                                if not RecGKitSalesLine.ISEMPTY then begin
                                    RecGKitSalesLine.FINDSET();
                                    repeat
                                        //>>MIG NAV 2015 : Upgrade Old Code
                                        //OLD IF (RecGKitSalesLine."Document No." <> xKitSalesLine."Document No.") OR
                                        //OLD      (RecGKitSalesLine."Line No." <> xKitSalesLine."Document Line No.") THEN
                                        if (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") or (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") then
                                            //<<MIG NAV 2015 : Upgrade Old Code
                                            DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
                                    until RecGKitSalesLine.NEXT() = 0;
                                end;

                                DecLAvailibityNoReserved := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + DecGQtyKit) +
                                                            RecLItem."Reserved Qty. on Purch. Orders";
                                //<<FED_20090415:PA 15/04/2009

                                if not BoolFirstRead then
                                    AssemblyLine."Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<')
                                else
                                    if ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<') < AssemblyLine."Kit Qty Available by Assembly" then
                                        AssemblyLine."Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<');
                                BoolFirstRead := true;
                            end;
                    until RecLProductionBOMLine.NEXT() = 0;
            end;
        end;
        //<<FED_20090415:PA 15/04/2009
    end;
    //Table 901 ...  par hadil
    [EventSubscriber(ObjectType::Table, Database::"Assembly Line", 'OnBeforeShowReservation', '', false, false)]
    local procedure OnBeforeShowReservation(var AssemblyLine: Record "Assembly Line"; var IsHandled: Boolean)
    var
        Reservation: Page Reservation;
    begin
        if IsHandled then
            exit;

        if AssemblyLine.Type = Type::Item then begin
            AssemblyLine.TestField("No.");
            AssemblyLine.TestField(Reserve);
            Clear(Reservation);
            //TODO Global
            // if BooGResaAssFTA then
            //     Reservation.FctSetBooResaASSFTA(true);
            Reservation.SetReservSource(AssemblyLine);
            Reservation.RunModal();
        end;
        IsHandled := true;
    end;
    // Table 111 ajouté par hadil
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    var
        CstG0003: Label '======================================================================================================';
        RecGSalesShipHeader: Record 110;
        CstG0001: Label 'No %1|Your Ref: %2|Order FTA %3';
        CstG0002: Label 'No %1|Your Ref: %2';
    begin
        SalesLine.Description := COPYSTR(CstG0003, 1, 50);

        SalesLine.INSERT();
        NextLineNo := NextLineNo + 10000;
        SalesLine."Line No." := NextLineNo;
        SalesLine."Document Type" := TempSalesLine."Document Type";
        SalesLine."Document No." := TempSalesLine."Document No.";

        RecGSalesShipHeader.GET(SalesShptLine."Document No.");
        if STRLEN(STRSUBSTNO(CstG0001, SalesShptLine."Document No.", RecGSalesShipHeader."External Document No.", RecGSalesShipHeader."Order No."))
               <= 50 then
            SalesLine.Description := COPYSTR(STRSUBSTNO(CstG0001, SalesShptLine."Document No.", RecGSalesShipHeader."External Document No.",
            RecGSalesShipHeader."Order No."), 1, 50)
        else
            SalesLine.Description := COPYSTR(STRSUBSTNO(CstG0002, SalesShptLine."Document No.", RecGSalesShipHeader."External Document No."), 1, 50);
    end;
    //Table 111 ajouté par hadil
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnInsertInvLineFromShptLineOnBeforeValidateQuantity', '', false, false)]
    local procedure OnInsertInvLineFromShptLineOnBeforeValidateQuantity(SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean; var SalesInvHeader: Record "Sales Header")
    begin
        SalesLine.FctParmFromCompileBL();
    end;
    //todo a verifier
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure OnBeforePostCustomerEntry2(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GenJnlLine."Mobile Salesperson Code" := SalesHeader."Mobile Salesperson Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostBalancingEntryOnAfterInitNewLine', '', false, false)]

    local procedure OnPostBalancingEntryOnAfterInitNewLine(SalesHeader: Record "Sales Header"; var GenJnlLine: Record "Gen. Journal Line")
    begin

        GenJnlLine."Mobile Salesperson Code" := SalesHeader."Mobile Salesperson Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', false, false)]

    local procedure OnAfterCopyItemJnlLineFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin

        ItemJnlLine."Mobile Salesperson Code" := SalesHeader."Mobile Salesperson Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateAssosOrderPostingNos', '', false, false)]

    local procedure OnAfterUpdateAssosOrderPostingNos(SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line" temporary; var DropShipment: Boolean)
    var
        RecGParmNavi: Record "NavEasy Setup";
        RecGArchiveManagement: Codeunit ArchiveManagement;

    begin

        if RecGParmNavi.GET() then
            if RecGParmNavi."Filing Sales Orders" then
                RecGArchiveManagement.StoreSalesDocument(SalesHeader, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostUpdateOrderLineOnBeforeGetQuantityShipped', '', false, false)]
    local procedure OnPostUpdateOrderLineOnBeforeGetQuantityShipped(TempSalesLine: Record "Sales Line"; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader.Ship then begin
            IsHandled := true;

            if not IsHandled then begin

                TempSalesLine.Prepare := false;
                TempSalesLine."Start Date" := TODAY;
            end;
        end;
    end;
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Partie Chaima >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    // TODO Can not  find an event has SalesLine on parametre
    // [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnAfterReserveFromCurrentLine', '', false, false)]
    // local procedure OnAfterReserveFromCurrentLine(ReservEntry: Record "Reservation Entry")
    // var
    //     RecLSalesLine: Record "Sales Line";
    //     RecLReservEntry: Record "Reservation Entry";
    //     RecLReservEntry2: Record "Reservation Entry";
    // begin
    //     IF ReservEntry."Source Type" = DATABASE::"Sales Line" THEN BEGIN
    //         IF "Table ID" = DATABASE::"Purchase Line" THEN
    //             SalesLine."Preparation Type" := SalesLine."Preparation Type"::Purchase;
    //         IF "Table ID" = DATABASE::"Item Ledger Entry" THEN
    //             SalesLine."Preparation Type" := SalesLine."Preparation Type"::Stock;
    //         SalesLine.MODIFY();
    //     END ELSE
    //         //>>TI298981
    //         IF ReservEntry."Source Type" = DATABASE::"Purchase Line" THEN BEGIN
    //             RecLReservEntry.RESET();
    //             IF RecLReservEntry.FINDLAST() THEN
    //                 IF RecLReservEntry2.GET(RecLReservEntry."Entry No.", FALSE) THEN
    //                     IF RecLSalesLine.GET(RecLReservEntry2."Source Subtype", RecLReservEntry2."Source ID", RecLReservEntry2."Source Ref. No.") THEN BEGIN
    //                         IF ReservEntry."Source Type" = DATABASE::"Purchase Line" THEN
    //                             RecLSalesLine."Preparation Type" := SalesLine."Preparation Type"::Purchase
    //                         ELSE
    //                             IF "Table ID" = DATABASE::"Item Ledger Entry" THEN
    //                                 RecLSalesLine."Preparation Type" := SalesLine."Preparation Type"::Stock;
    //                         RecLSalesLine.MODIFY();
    //                     END;
    //         END;

    //Page 498
    // TODO CodeUnit ReservMgt
    [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnUpdateReservMgt', '', false, false)]
    local procedure OnUpdateReservMgt(var ReservationEntry: Record "Reservation Entry"; var ReservationManagement: Codeunit "Reservation Management")
    var
        FTASingleInstance: Codeunit FTASingleInstance;
    begin
        if FTASingleInstance.FctGetBooResaFTA() then
            FTASingleInstance.FctSetBooResaFTA(true);
        if FTASingleInstance.FctGetBooResaAssFTA() then
            FTASingleInstance.FctSetBooResaAssFTA(true);
    end;
    // TODO Can not find event has RecGItem and ReserveEntry on parametre
    // [EventSubscriber(ObjectType::Page, PAge::Reservation, 'OnAfterUpdateReservFrom', '', False, False)]
    // local procedure OnAfterUpdateReservFrom(var EntrySummary: Record "Entry Summary")
    // begin
    //      //>>FED_20090415:PA
    //   IF NOT RecGItem.GET(ReservEntry."Item No.") THEN
    //     CLEAR(RecGItem);
    //<<FED_20090415:PA
    // end;

    //Page 498
    // TODO CodeUnit ReservMgt (est-ce qu'on peut utiliser la méme event sur 2 procédures différentes ?)
    // [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnUpdateReservMgt', '', false, false)]
    // local procedure OnUpdateReservMgt(var ReservationEntry: Record "Reservation Entry"; var ReservationManagement: Codeunit "Reservation Management")
    // begin
    //     //>>NDBI
    //     IF BooGResaFTA THEN
    //         ReservMgt.FctSetBooResaFTA(TRUE);
    //     IF BooGResaAssFTA THEN
    //         ReservMgt.FctSetBooResaAssFTA(TRUE);
    //     //<<NDBI
    // end;
    // TODO CodeUnitReservMgt
    //Page 498
    [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnBeforeAutoReserve', '', false, false)]
    local procedure OnBeforeAutoReserve(ReservEntry: Record "Reservation Entry"; var FullAutoReservation: Boolean; QtyToReserve: Decimal; QtyReserved: Decimal; QtyToReserveBase: Decimal; QtyReservedBase: Decimal; var IsHandled: Boolean)
    var
        FTASingleInstance: Codeunit FTASingleInstance;
    begin
        if FTASingleInstance.FctGetBooResaFTA() then
            FTASingleInstance.FctSetBooResaFTA(true);
        if FTASingleInstance.FctGetBooResaAssFTA() then
            FTASingleInstance.FctSetBooResaAssFTA(true);
    end;
    // todo : prod AutoReserve page 498
    //    [EventSubscriber(ObjectType::Page, Page::Reservation, 'OnAfterAutoReserve', '', false, false)]
    //     local procedure OnAfterAutoReserve(ReservEntry: Record "Reservation Entry")
    //     var
    //         RecLReservEntry: Record "Reservation Entry";
    //         RecLReservEntry2: Record "Reservation Entry";
    //         RecLSalesLine: Record "Sales Line";
    //     begin
    //         if SalesLine."Document No." <> '' then begin
    //             RecLReservEntry.SETRANGE("Reservation Status", RecLReservEntry."Reservation Status"::Reservation);
    //             RecLReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
    //             RecLReservEntry.SETRANGE("Source Subtype", SalesLine."Document Type");
    //             RecLReservEntry.SETRANGE("Source ID", SalesLine."Document No.");
    //             RecLReservEntry.SETRANGE("Source Ref. No.", SalesLine."Line No.");
    //             if RecLReservEntry.FINDLAST then begin
    //                 if RecLReservEntry2.GET(RecLReservEntry."Entry No.", true) then begin
    //                     if RecLReservEntry2."Source Type" = DATABASE::"Purchase Line" then
    //                         SalesLine."Preparation Type" := SalesLine."Preparation Type"::Purchase;
    //                     if "Table ID" = DATABASE::"Item Ledger Entry" then
    //                         SalesLine."Preparation Type" := SalesLine."Preparation Type"::Stock;
    //                     SalesLine.MODIFY;
    //                 end;
    //             end
    //         end else
    //             if PurchLine."Document No." <> '' then begin
    //                 //>>TI298981
    //                 RecLReservEntry.SETRANGE("Reservation Status", RecLReservEntry."Reservation Status"::Reservation);
    //                 RecLReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
    //                 RecLReservEntry.SETRANGE("Source Subtype", PurchLine."Document Type");
    //                 RecLReservEntry.SETRANGE("Source ID", PurchLine."Document No.");
    //                 RecLReservEntry.SETRANGE("Source Ref. No.", PurchLine."Line No.");
    //                 if RecLReservEntry.FINDLAST then
    //                     if RecLReservEntry2.GET(RecLReservEntry."Entry No.", false) then
    //                         if RecLReservEntry2."Source Type" = DATABASE::"Sales Line" then
    //                             if RecLSalesLine.GET(RecLReservEntry2."Source Subtype", RecLReservEntry2."Source ID", RecLReservEntry2."Source Ref. No.") then begin
    //                                 RecLSalesLine."Preparation Type" := SalesLine."Preparation Type"::Purchase;
    //                                 RecLSalesLine.MODIFY();
    //                             end;
    //             end;
    //     end;
    //    TODO can't find event  on DrillDownTotalQuantity
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Selection Management", 'OnConfirmPostSalesDocumentOnBeforeSalesOrderGetSalesInvoicePostingPolicy', '', false, false)]
    local procedure OnConfirmPostSalesDocumentOnBeforeSalesOrderGetSalesInvoicePostingPolicy(var SalesHeader: Record "Sales Header")
    var
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        RecLSalesReceivablesSetup.GET();
        if RecLSalesReceivablesSetup."Default Posting Date" = RecLSalesReceivablesSetup."Default Posting Date"::"Work Date" then
            SalesHeader.VALIDATE("Posting Date", WORKDATE());
    end;
    // Todo : i can't find solution table 9053
    // [EventSubscriber(ObjectType::Table, Database::"Sales Cue", 'OnFilterOrdersOnAfterSalesHeaderSetFilters', '', false, false)]
    // local procedure OnFilterOrdersOnAfterSalesHeaderSetFilters(var SalesHeader: Record "Sales Header")
    // begin
    //     SalesHeader.reset();
    //     SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
    //     SalesHeader.SetRange(Status, SalesHeader.Status::Released);
    //     SalesHeader.SetRange("Completely Shipped", false);
    // end;
}
