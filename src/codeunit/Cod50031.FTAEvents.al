codeunit 50031 "FTA_Events"
{
    SingleInstance = true;

    var
        BooGOpenDialogueBox: Boolean;
        BooGMultiLevel: Boolean;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeOnInsert', '', false, false)]
    local procedure OnBeforeOnInsert(var Item: Record Item; var IsHandled: Boolean; xRecItem: Record Item)
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
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
        // Item.DimMgt.UpdateDefaultDim(
        //       DATABASE::Item, Item."No.",
        //       Item."Global Dimension 1 Code", Item."Global Dimension 2 Code");
        // Item."Creation Date" := WORKDATE();
        // Item.User := USERID();
        // Item.UpdateReferencedIds();
        // Item.SetLastDateTimeModified();

        // Item.UpdateItemUnitGroup();
        // IsHandled := true;
    end;

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

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Description', false, false)]
    local procedure OnAfterValidateEvent(CurrFieldNo: Integer; var Rec: Record Item; var xRec: Record Item)
    begin
        Rec.Get(CurrFieldNo);
        Rec."Search Description" := DELCHR(Rec."Search Description", '=', '/,- +-#*.\{}><[]()@":=');
    end;
    //TODO: a verifier procedure protection level
    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    // local procedure OnAfterUpdateAmountsDone(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    // begin
    //     SalesLine.UpdatePurchaseBasePrice();
    // end;
    //TODO: a verifier onvalidate field No.

    // [EventSubscriber(ObjectType::Report, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', 'No.', false, false)]
    // local procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    // begin
    //     SalesLine."Item Base" := TempSalesLine."Item Base";
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterTransferSavedFields', '', false, false)]
    local procedure OnAfterTransferSavedFields(var DestinationPurchaseLine: Record "Purchase Line"; SourcePurchaseLine: Record "Purchase Line")
    begin //TODO -> A verifier
        // if SourcePurchaseLine.Quantity <> 0 then
        DestinationPurchaseLine."Special Order Sales No." := SourcePurchaseLine."Special Order Sales No.";
        DestinationPurchaseLine."Special Order Sales Line No." := SourcePurchaseLine."Special Order Sales Line No.";
        DestinationPurchaseLine."Special Order" := SourcePurchaseLine."Special Order Sales Line No." <> 0;
    end;

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

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetGLAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetGLAccount(var GenJournalLine: Record "Gen. Journal Line"; var GLAccount: Record "G/L Account"; CallingFieldNo: Integer)
    begin
        if (GenJournalLine."Bal. Account No." = '') or (GenJournalLine."Bal. Account Type" in
           [GenJournalLine."Bal. Account Type"::"G/L Account", GenJournalLine."Bal. Account Type"::"Bank Account"]) then
            GenJournalLine."Mobile Salesperson Code" := '';
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetCustomerAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := Customer."Mobile Salesperson Code";
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := '';
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetBankAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetBankAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := '';
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnGetGLBalAccountOnAfterSetDescription', '', false, false)]
    local procedure OnGetGLBalAccountOnAfterSetDescription(var GenJournalLine: Record "Gen. Journal Line"; GLAcc: Record "G/L Account")
    begin
        if (GenJournalLine."Account No." = '') or
         (GenJournalLine."Account Type" in
          [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Bank Account"])
        then
            GenJournalLine."Mobile Salesperson Code" := '';
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnGetCustomerBalAccountOnAfterCustGet', '', false, false)]
    local procedure OnGetCustomerBalAccountOnAfterCustGet(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := Customer."Mobile Salesperson Code";
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetVendorBalAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetVendorBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    begin
        GenJournalLine."Mobile Salesperson Code" := '';
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetBankBalAccount', '', false, false)]
    local procedure OnAfterAccountNoOnValidateGetBankBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; CallingFieldNo: Integer)
    begin
        if (GenJournalLine."Account No." = '') or
         (GenJournalLine."Account Type" in
          [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Bank Account"])
      then
            GenJournalLine."Mobile Salesperson Code" := '';
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo', '', false, false)]
    local procedure OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        GenJournalLine."Posting Group" := CustLedgerEntry."Customer Posting Group";
    end;

    [EventSubscriber(ObjectType::table, Database::"Gen. Journal Line", 'OnAfterLookUpAppliesToDocVend', '', false, false)]
    local procedure OnAfterLookUpAppliesToDocVend(var GenJournalLine: Record "Gen. Journal Line"; VendLedgEntry: Record "Vendor Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry"; ApplyVendorEntries: page "Apply Vendor Entries")
    begin
        GenJournalLine."Posting Group" := VendLedgEntry."Vendor Posting Group";
    end;

    [EventSubscriber(ObjectType::table, Database::"Standard General Journal Line", 'OnAfterGetGLAccount', '', false, false)]
    local procedure OnAfterGetGLAccount(var StandardGenJournalLine: Record "Standard General Journal Line"; GLAcc: Record "G/L Account")
    begin
        if (StandardGenJournalLine."Bal. Account No." = '') or
          (StandardGenJournalLine."Bal. Account Type" in
           [StandardGenJournalLine."Bal. Account Type"::"G/L Account", StandardGenJournalLine."Bal. Account Type"::"Bank Account"])
       then
            StandardGenJournalLine."Mobile Salesperson Code" := '';
    end;

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
            //TODO:  page 914 not migrated yet
            //AssembletoOrderLines.FctSetDate(SalesHeader."Requested Delivery Date");
            AssembletoOrderLines.SETTABLEVIEW(AsmLine);
            AssembletoOrderLines.RUNMODAL();
        end;
        IsHandled := true;
    end;
    //TODO : i can't find event 
    // [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder', '', false, false)]
    // local procedure OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder(var SalesLine: Record "Sales Line")
    // begin
    //     IF (SalesLine."Item Base" = SalesLine."Item Base"::Transitory) THEN
    //         CurrPage.UPDATE;
    // end;
    //TODO: page SPE not migrated yet
    // [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnBeforeQuantityOnAfterValidate', '', false, false)]
    // local procedure OnBeforeQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    // var
    //     OK: Boolean;
    //     BoopF12: Boolean;
    //     RecLItem: Record Item;
    //     PgeLAssignmentItem: Page 50003;
    //     RecGInventorySetup: Record "Inventory Setup";
    //     DecGxQuantity: Decimal;
    // begin
    //     RecGInventorySetup.GET();
    //     if RecGInventorySetup."Reservation FTA" then begin
    //         if SalesLine.Quantity > DecGxQuantity then
    //             if RecLItem.GET(SalesLine."No.") then;
    //         if (SalesLine.Quantity <> 0) and (SalesLine."Reserved Quantity" <> SalesLine.Quantity) and
    //             (SalesLine.Type = Type::Item) and (SalesLine."Document Type" <> "Document Type"::Quote) and not (RecLItem."Inventory Value Zero") then begin

    //             CurrPage.SAVERECORD;

    //             CLEAR(PgeLAssignmentItem);
    //             BoopF12 := false;
    //             PgeLAssignmentItem.FctGetParm(Rec, DecGxQuantity, OptGxPreparationType);
    //             PgeLAssignmentItem.SETTABLEVIEW(Rec);
    //             PgeLAssignmentItem.SETRECORD(Rec);
    //             PgeLAssignmentItem.RUN;
    //         end;
    //     end;
    // end;
    //TODO : i can't find fields 
    // [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", 'OnSetCustApplIdAfterCheckAgainstApplnCurrency', '', false, false)]
    // local procedure OnSetCustApplIdAfterCheckAgainstApplnCurrency(var CustLedgerEntry: Record "Cust. Ledger Entry"; CalcType: Option; var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; ServHeader: Record "Service Header"; ApplyingCustLedgEntry: Record "Cust. Ledger Entry")
    // var
    //     ApplyCustomerEntries: Page "Apply Customer Entries";
    // begin
    //     ApplyCustomerEntries.VerifPostingGroup("Applies-to ID", "Customer Posting Group");
    // end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnCodeOnBeforeTestOrder', '', false, false)]
    local procedure OnCodeOnBeforeTestOrder(ItemJnlLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        if not IsHandled then
            if ItemJnlLine.IsAssemblyOutputLine() then
                ItemJnlLine.TestField("Order Line No.", 0);
        IsHandled := true;
    end;

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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertPhysInvtLedgEntry', '', false, false)]
    local procedure OnBeforeInsertPhysInvtLedgEntry(var PhysInventoryLedgerEntry: Record "Phys. Inventory Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; LastSplitItemJournalLine: Record "Item Journal Line")
    begin
        PhysInventoryLedgerEntry."Mobile Salesperson Code" := ItemJournalLine."Mobile Salesperson Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnBeforeRoundAmtValueEntry', '', false, false)]
    local procedure OnInitValueEntryOnBeforeRoundAmtValueEntry(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        ValueEntry."Mobile Salesperson Code" := ItemJnlLine."Mobile Salesperson Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeGetProdOrderLine', '', false, false)]
    local procedure OnBeforeGetProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; OrderNo: Code[20]; OrderLineNo: Integer; var IsHandled: Boolean)
    begin
        if not ProdOrderLine.GET(ProdOrderLine.Status::Released, OrderNo, OrderLineNo) then
            ProdOrderLine.GET(ProdOrderLine.Status::Finished, OrderNo, OrderLineNo);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var SendReportAsEmail: Boolean; var DefaultOption: Integer)
    var
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        RecLSalesReceivablesSetup.GET();
        if RecLSalesReceivablesSetup."Default Posting Date" = RecLSalesReceivablesSetup."Default Posting Date"::"Work Date" then
            SalesHeader.VALIDATE(SalesHeader."Posting Date", WORKDATE());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var SalesHeader: Record "Sales Header")
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
    //TODO: a verifier 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    begin
        PurchaseHeader.CALCFIELDS("Order Type");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnAfterFillTempLines', '', false, false)]
    local procedure OnRunOnAfterFillTempLines(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.CALCFIELDS("Order Type");
    end;

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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WhseReceive: Boolean; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WhseShip: Boolean)
    begin
        PurchRcptHeader."Order Type" := PurchaseHeader."Order Type";
    end;

    //  todo : verfier 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine', '', false, false)]
    local procedure OnBeforeInitGenJnlLineAmountFieldsFromTotalPurchLine(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine2: Record "Purchase Line"; var TotalPurchLineLCY2: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        GenJnlLine."Posting Group" := PurchHeader."Vendor Posting Group";
        GenJnlLine."Payment Method Code" := PurchHeader."Payment Method Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        CstL001: Label 'Purchase Invoice %1 created.';
    begin
        if PurchaseHeader.Invoice and (PurchInvHdrNo <> '') then
            MESSAGE(CstL001, PurchInvHdrNo);
    end;
    //Todo : verifier
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnApplyCustomerLedgerEntryOnBeforeModify', '', false, false)]
    local procedure OnApplyCustomerLedgerEntryOnBeforeModify(var GenJnlLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        GenJnlLine."Posting Group" := CustLedgerEntry."Customer Posting Group";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnApplyVendorLedgerEntryOnBeforeModify', '', false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeModify(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; VendorLedgerEntryLocal: Record "Vendor Ledger Entry")
    begin
        GenJournalLine."Posting Group" := VendorLedgerEntry."Vendor Posting Group";

    end;
    //TODO : a verifier !!!!!!!!!!!!!!!!!
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeDoPrintSalesHeader', '', false, false)]
    local procedure OnBeforeDoPrintSalesHeader(var SalesHeader: Record "Sales Header"; ReportUsage: Integer; SendAsEmail: Boolean; var IsPrinted: Boolean)
    var
        RecLReportUser: Record 50003;
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
        until ReportSelections.Next() = 0;
        if SendAsEmail then
            ReportSelections.SendEmailToCust(
                ReportUsage, SalesHeader, SalesHeader."No.", SalesHeader.GetDocTypeTxt(), true, SalesHeader.GetBillToNo())
        else
            ReportSelections.PrintForCust(ReportUsage, SalesHeader, SalesHeader.FieldNo("Bill-to Customer No."));
        IsPrinted := true;
    end;
    //TODO : a verifier !!!!!!!!!!!!!!!!!
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeDoPrintPurchHeader', '', false, false)]
    local procedure OnBeforeDoPrintPurchHeader(var PurchHeader: Record "Purchase Header"; ReportUsage: Integer; var IsPrinted: Boolean)
    var
        RecLReportUser: Record 50003;
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
    //TODO : a verifier !!!!!!!!!!!!!!!!!
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforePrintSalesOrder', '', false, false)]
    local procedure OnBeforePrintSalesOrder(var SalesHeader: Record "Sales Header"; ReportUsage: Integer; var IsPrinted: Boolean)
    var
        RecLReportUser: Record 50003;
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ItemCostManagement, 'OnUpdateStdCostSharesOnAfterCopyCosts', '', false, false)]
    local procedure OnUpdateStdCostSharesOnAfterCopyCosts(var Item: Record Item; FromItem: Record Item)
    begin
        if (Item."Item Base" = Item."Item Base"::"Transitory Kit") or (Item."Item Base" = Item."Item Base"::"Bored blocks") then begin
            Item.VALIDATE("Purchase Price Base", Item."Single-Level Material Cost");
            Item.VALIDATE("Unit Price", Item."Kit - Sales Price");
        end;
    end;

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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcItemOnBeforeShowStrMenu', '', false, false)]
    local procedure OnCalcItemOnBeforeShowStrMenu(var Item: Record Item; var ShowStrMenu: Boolean; var NewCalcMultiLevel: Boolean)
    begin
        if not ShowStrMenu then
            if BooGOpenDialogueBox then begin
                NewCalcMultiLevel := BooGMultiLevel;
                ShowStrMenu := false;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcAssemblyItemOnAfterCalcItemCost', '', false, false)]
    local procedure OnCalcAssemblyItemOnAfterCalcItemCost(var Item: Record Item; CompItem: Record Item; BOMComponent: Record "BOM Component"; ComponentQuantity: Decimal)
    begin
        if not BooGMultiLevel then begin
            Item."Rolled-up Material Cost" += ComponentQuantity * CompItem."Purchase Price Base";
            Item."Single-Level Material Cost" += ComponentQuantity * CompItem."Purchase Price Base"
        end
        else
            if not (CompItem.IsAssemblyItem() or CompItem.IsMfgItem()) then begin
                Item."Rolled-up Material Cost" += ComponentQuantity * CompItem."Purchase Price Base";
                Item."Single-Level Material Cost" += ComponentQuantity * CompItem."Purchase Price Base";
            end
    end;

    //TODO : I cant find solution line 606
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Standard Cost", 'OnCalcProdBOMCostOnAfterCalcCompItemQtyBase', '', false, false)]
    local procedure OnCalcProdBOMCostOnAfterCalcCompItemQtyBase(CalculationDate: Date; MfgItem: Record Item; MfgItemQtyBase: Decimal; IsTypeItem: Boolean; var ProdBOMLine: Record "Production BOM Line"; var CompItemQtyBase: Decimal; RtngNo: Code[20]; UOMFactor: Decimal)
    begin


    end;
    //TODO: verifier 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnCopyLigBorOnBeforeToPaymentLineInsert', '', false, false)]
    local procedure OnCopyLigBorOnBeforeToPaymentLineInsert(var ToPaymentLine: Record "Payment Line"; var Process: Record "Payment Class")
    var
        tempPyamentLine: Record "Payment Line";
    begin
        tempPyamentLine.Get(ToPaymentLine."No.");
        ToPaymentLine."Created from No." := tempPyamentLine."Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnPostInvPostingBufferOnBeforeGenJnlPostLineRunWithCheck', '', false, false)]
    local procedure OnPostInvPostingBufferOnBeforeGenJnlPostLineRunWithCheck(var GenJnlLine: Record "Gen. Journal Line"; var PaymentHeader: Record "Payment Header"; var PaymentClass: Record "Payment Class")
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        //TODO : procedure not migrated yet
        //GenJnlPostLine.FctFromPaymentMgt(true);
    end;

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

}