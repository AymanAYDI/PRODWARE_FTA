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

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure OnAfterUpdateAmountsDone(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        SalesLine.UpdatePurchaseBasePrice();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        SalesLine."Item Base" := TempSalesLine."Item Base";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterTransferSavedFields', '', false, false)]
    local procedure OnAfterTransferSavedFields(var DestinationPurchaseLine: Record "Purchase Line"; SourcePurchaseLine: Record "Purchase Line")
    begin
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
            AssembletoOrderLines.FctSetDate(SalesHeader."Requested Delivery Date");
            AssembletoOrderLines.SETTABLEVIEW(AsmLine);
            AssembletoOrderLines.RUNMODAL();
        end;
        IsHandled := true;
    end;
    //TODO : CurrPage not exist in the current context 
    // [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder', '', false, false)]
    // local procedure OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder(var SalesLine: Record "Sales Line")
    // begin
    //     if (SalesLine."Item Base" = SalesLine."Item Base"::Transitory) then
    //         CurrPage.UPDATE;
    // end;
    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnBeforeQuantityOnAfterValidate', '', false, false)]
    local procedure OnBeforeQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    var
        OK: Boolean;
        BoopF12: Boolean;
        RecLItem: Record Item;
        PgeLAssignmentItem: Page 50003;
        RecGInventorySetup: Record "Inventory Setup";
        DecGxQuantity: Decimal;
    begin
        RecGInventorySetup.GET();
        if RecGInventorySetup."Reservation FTA" then begin
            if SalesLine.Quantity > DecGxQuantity then
                if RecLItem.GET(SalesLine."No.") then;
            if (SalesLine.Quantity <> 0) and (SalesLine."Reserved Quantity" <> SalesLine.Quantity) and
                (SalesLine.Type = Type::Item) and (SalesLine."Document Type" <> "Document Type"::Quote) and not (RecLItem."Inventory Value Zero") then begin
                //TODO : CurrPage not exist in the current context 
                //CurrPage.SAVERECORD;

                CLEAR(PgeLAssignmentItem);
                BoopF12 := false;
                PgeLAssignmentItem.FctGetParm(SalesLine, DecGxQuantity, xSalesLine."Preparation Type");
                PgeLAssignmentItem.SETTABLEVIEW(SalesLine);
                PgeLAssignmentItem.SETRECORD(SalesLine);
                PgeLAssignmentItem.RUN();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", 'OnSetCustApplIdAfterCheckAgainstApplnCurrency', '', false, false)]
    local procedure OnSetCustApplIdAfterCheckAgainstApplnCurrency(var CustLedgerEntry: Record "Cust. Ledger Entry"; CalcType: Option; var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; ServHeader: Record "Service Header"; ApplyingCustLedgEntry: Record "Cust. Ledger Entry")
    var
        ApplyCustomerEntries: Page "Apply Customer Entries";
    begin
        ApplyCustomerEntries.VerifPostingGroup(CustLedgerEntry."Applies-to ID", CustLedgerEntry."Customer Posting Group");
    end;

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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvHeaderInsert', '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        PurchInvHeader."Order Type" := PurchHeader."Order Type";
    end;

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
    //Table 60111
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    var
        CstG0001: Label 'No %1|Your Ref: %2|Order FTA %3';

        "---FTA1.00---": Integer;
        RecGSalesShipHeader: Record "110";
        CstG0002: Label 'No %1|Your Ref: %2';
        TxtGText: Text[250];
        CstG0003: Label '===================== ';


    begin
        SalesLine.INSERT();
        NextLineNo := NextLineNo + 10000;
        SalesLine."Line No." := NextLineNo;
        SalesLine."Document Type" := TempSalesLine."Document Type";
        SalesLine."Document No." := TempSalesLine."Document No.";
        RecGSalesShipHeader.GET(SalesShptLine."Document No.");
        if STRLEN(STRSUBSTNO(CstG0001, SalesShptLine."Document No.", RecGSalesShipHeader."External Document No.", RecGSalesShipHeader."Order No."))
               <= 50 then
            SalesLine.Description := COPYSTR(STRSUBSTNO(SalesShptLine.CstG0001, SalesShptLine."Document No.", SalesShptLine.RecGSalesShipHeader."External Document No.",
            RecGSalesShipHeader."Order No."), 1, 50)
        else
            SalesLine.Description := COPYSTR(STRSUBSTNO(CstG0002, SalesShptLine."Document No.", RecGSalesShipHeader."External Document No."), 1, 50);
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

    //Codeunit 12 Line
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeVendLedgEntryInsert', '', false, false)]
    local procedure OnBeforeVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    begin
        VendorLedgerEntry."Payment Method Code" := GenJournalLine."Payment Method Code";
        VendorLedgerEntry."Payment Terms Code" := GenJournalLine."Payment Terms Code";
    end;
    //Codeunit 12 Line
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
    begin
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
    begin
        TempOldVendLedgEntry.DELETE();

        if not BooGPaymentMgt then
            FTAfct.CheckVendPostGroup(NewCVLedgEntryBuf, TempOldVendLedgEntry);
    end; //TODO

    procedure FctFromPaymentMgt(BooPPaymentMgt: Boolean);
    var
    begin
        BooGPaymentMgt := BooPPaymentMgt;
    end;//Codeunit 12
        //COdeUnit 86 Line 49
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnAfterInsertSalesOrderHeader', '', false, false)]
    local procedure OnAfterInsertSalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    begin
        CodLSalesOrderNo := SalesOrderHeader."No.";
    end;


    //COdeUnit 86 Line 149
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnAfterOnRun', '', false, false)]
    local procedure OnAfterOnRun(var SalesHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        SalesOrderLine: Record "Sales Line";
        RecLInventorySetup: Record "Inventory Setup";
        RecLItem: Record Item;
        FrmLAssignmentItem: Page "Assignment Item";
    begin
        RecLInventorySetup.GET();
        if RecLInventorySetup."Reservation FTA" then begin
            SalesOrderLine.RESET();
            SalesOrderLine.SETRANGE("Document Type", SalesOrderLine."Document Type"::Order);
            SalesOrderLine.SETRANGE("Document No.", CodLSalesOrderNo);
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
        SalesOrderLine: Record "Sales Line";
        Customer: Record Customer;
        RecLItem: Record Item;
        ATOLink: Record "Assemble-to-Order Link";
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
    //codeunit 92
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPost(var PurchaseHeader: Record "Purchase Header")
    var
        RecGPurchHeader: Record "Purchase Header";
        RecGPurchLine: Record "Purchase Line";
        CuGPurchPost: Codeunit "Purch.-Post";
        CuGReleasePurchaseDoc: Codeunit "Release Purchase Document";
        CodGNumDoc: Code[20];
        CodGNumDocMarchandise: Code[20];
        BooGARefermer: Boolean;
        DecGQty: Decimal;
    begin
        CodGNumDoc := PurchaseHeader."Shipping Order No.";
        CodGNumDocMarchandise := PurchaseHeader."No.";
        //>>NAVEASY.001 [Cde_Transport] la Cde achat marchandise est livr‚e et
        //est li‚e … une cde achat transport alors il y a validation en R‚ception de la cde achat transport
        if (PurchaseHeader."Document Type" = "Document Type"::Order) and
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
        RecLItem: Record Item;
        RecLCust: Record Customer;
        DecLAmount: Decimal;
        BooLNegMargin: Boolean;
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
        if SalesHeader."Document Type" = "Document Type"::Order then begin
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
        if AutoReserveOk then
            ToAssemblyLine.FctAutoReserveFTA();
        //<< FTA1.02
    end;
    //Codeunit 5895
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
    //Codeunit 10861
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment-Apply", 'OnAfterApply', '', false, false)]
    local procedure OnAfterApply(GenJnlLine: Record "Gen. Journal Line")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        AccType: Enum "Gen. Journal Account Type";
        accNo: Code[20];
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
                    "Posting Group" := CustLedgEntry."Customer Posting Group";
                end;
            AccType::Vendor:
                begin
                    VendLedgEntry.get();
                    VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                    VendLedgEntry.SetRange("Vendor No.", AccNo);
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                    "Posting Group" := VendLedgEntry."Vendor Posting Group";

                end;
        end;
    end;

    //codeunit 99000830
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnTransferReservEntryOnAfterTransferFields', '', false, false)]
    local procedure OnTransferReservEntryOnAfterTransferFields(var NewReservationEntry: Record "Reservation Entry"; var OldReservationEntry: Record "Reservation Entry"; var UseQtyToHandle: Boolean; var UseQtyToInvoice: Boolean; var CurrSignFactor: Integer)
    var
        RecLxOldReservEntry: Record "Reservation Entry" temporary;
        RecLReservEntry: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
    // CreateReservEntry:Codeunit "Create Reserv. Entry";
    // TransferQty:Decimal;
    // QtyToHandleThisLine: Decimal;
    // QtyToInvoiceThisLine: Decimal;
    // xTransferQty:Decimal;

    begin
        RecLxOldReservEntry.TRANSFERFIELDS(OldReservationEntry);

        // UseQtyToHandle := OldReservationEntry.TrackingExists() and false;

        // CurrSignFactor := CreateReservEntry.SignFactor(OldReservationEntry);
        // TransferQty := TransferQty * CurrSignFactor;
        // xTransferQty := TransferQty;

        // if UseQtyToHandle then begin // Used when handling Item Tracking
        //     QtyToHandleThisLine := OldReservationEntry."Qty. to Handle (Base)";
        //     QtyToInvoiceThisLine := OldReservationEntry."Qty. to Invoice (Base)";
        //     if Abs(TransferQty) > Abs(QtyToHandleThisLine) then
        //         TransferQty := QtyToHandleThisLine;
        //     if UseQtyToInvoice then // Used when posting sales and purchase
        //         if Abs(TransferQty) > Abs(QtyToInvoiceThisLine) then
        //             TransferQty := QtyToInvoiceThisLine;
        // end else
        //     QtyToHandleThisLine := OldReservationEntry."Quantity (Base)";
        //>>FE-DIVERS 18/09/2009
        //TransferQty := RecLxOldReservEntry."Quantity (Base)";
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

    //<<<<<<<<<<<<<<<<<<Partie Iheb >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //Report 10862
    [EventSubscriber(ObjectType::Report, report::"Suggest Vendor Payments", 'OnAfterIncludeVendor', '', false, false)]

    local procedure OnAfterIncludeVendor(Vendor: Record Vendor; VendorBalance: Decimal; var Result: Boolean)
    begin
        //>>NAVEASY.001 [Multi_Collectif]
        //STD GetVendLedgEntries(TRUE,FALSE);
        //STD GetVendLedgEntries(FALSE,FALSE);
        if BooGCheckPostGroup then begin
            GetVendLedgEntries2(true, false);
            GetVendLedgEntries2(false, false);
        end

    end;
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
            Fct_FinalizeAdress.Fct_FinalizeAdress;
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
        TextCdeTransp002: Label 'There is a Shipping Purchase order linked (Order %1), do you want to delete this order?';

    begin
        if "Shipping Order No." <> '' then
            if CONFIRM(STRSUBSTNO(TextCdeTransp002, "Shipping Order No.")) then begin
                if RecLPurchHeader.GET(RecLPurchHeader."Document Type"::Order, "Shipping Order No.") then RecLPurchHeader.DELETE(true);
            end;
    end;
    //Codeunit 80
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckMandatoryFields', '', false, false)]


    local procedure OnAfterCheckMandatoryFields(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var

    begin

        " FTA.UPDATECOSTc"(SalesHeader);

        if SalesHeader."Document Type" = "Document Type"::Order then begin
            SalesHeader.TESTFIELD(Preparer);
            SalesHeader.TESTFIELD(Assembler);
            SalesHeader.TESTFIELD(Packer);
        end;




        //<<NDBI
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckPostingFlags', '', false, false)]

    local procedure OnBeforeCheckPostingFlags(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        //      //>>FEP_ST01_20070801_stock negatif.002
        //           {
        //           //>>FEP_ST01_20070801_stock negatif.001
        //           BooLInventory := FALSE;
        //           IF RecLInventorySetup.GET THEN;
        //           IF Ship THEN
        //             IF RecLInventorySetup."Negative Inventory Not Allowed" THEN
        //             BEGIN
        //               CLEAR(RecLSalesLineInventory);
        //               RecLSalesLineInventory.SETRANGE("Document Type",SalesHeader."Document Type");
        //               RecLSalesLineInventory.SETRANGE("Document No.",SalesHeader."No.");
        //               IF RecLSalesLineInventory.FINDFIRST THEN
        //               REPEAT
        //                 IF CuLSalesInfoPaneMgt.CalcAvailability(RecLSalesLineInventory) < 0 THEN
        //                   BooLInventory := TRUE;
        //               UNTIL RecLSalesLineInventory.NEXT = 0;
        //             END;

        //           IF BooLInventory THEN
        //             ERROR(CtsL001);
        //           //<<FEP_ST01_20070801_stock negatif.001
        //           }
        //           //<<FEP_ST01_20070801_stock negatif.002
    end; //TODO
         //Codeunit 80
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeArchiveUnpostedOrder', '', false, false)]
    local procedure OnBeforeArchiveUnpostedOrder(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; PreviewMode: Boolean; var OrderArchived: Boolean)
    var
        SalesLine: Record "Sales Line";
        ArchiveManagement: Codeunit ArchiveManagement;
        " Sales-Post": Codeunit "Sales-Post";

    begin
        IsHandled := true;
        if IsHandled then
            exit;

        //todo GetSalesSetup();
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
            SalesLine.SetFilter("Qty. to Ship", '<>0')


        else
            SalesLine.SetFilter("Return Qty. to Receive", '<>0');
        if not SalesLine.IsEmpty() and not PreviewMode then begin
            ArchiveManagement.RoundSalesDeferralsForArchive(SalesHeader, SalesLine);
            ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
            OrderArchived := true;

            if SalesHeader."Document Type" = "Document Type"::Order then begin

                SalesLine.SETRANGE(Prepare, true);
            end;

        end;
    end;
    //todo a verifier 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostLines', '', false, false)]
    local procedure OnBeforePostLines(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin

        if SalesHeader."Document Type" = "Document Type"::Order then
            SalesLine.SETRANGE(Prepare, true);

    end;



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

        if RecGParmNavi.GET then
            if RecGParmNavi."Filing Sales Orders" then
                RecGArchiveManagement.StoreSalesDocument(SalesHeader, false);
    end;
    // local procedure OnBeforeSelectPostOrderOption(var PurchaseHeader: Record "Purchase Header"; DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    //     begin
    //           //>>FE-DIVERS 21/09/2009
    //               {STD Selection := STRMENU(Text000,3);     }
    //               Selection := STRMENU(Text000,1);
    //               //<<FE-DIVERS 21/09/2009

    // end; 
    //todo 

    //todo a verifier  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeSelectPostReturnOrderOption', '', false, false)]
    local procedure OnBeforeSelectPostReturnOrderOption(var PurchaseHeader: Record "Purchase Header"; DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    var
        RecLPurchReceivablesSetup: Record 312;
        RecGPurchHeader: Record 38;
    begin
        //>>FE-DIVERS 18/09/2009
        RecLPurchReceivablesSetup.GET();
        if RecLPurchReceivablesSetup."Default Posting Date" = RecLPurchReceivablesSetup."Default Posting Date"::"Work Date" then
            RecGPurchHeader.VALIDATE("Posting Date", WORKDATE());
        //<<FE-DIVERS 18/09/2009

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]

    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header")
    var

        RecGPurchHeader: Record 38;
        CodGNumDocMarchandise: Code[20];
        CodGNumDoc: Code[20];



        BooGARefermer@1100267001 : Boolean;
        DecGQty@1100267000 : Decimal;

    begin
        //>>NAVEASY.001 [Cde_Transport] Ajout code pour R‚cup‚ration
        //du Nø cde achat transport + Nø cde achat marchandise
        CodGNumDoc := RecGPurchHeader."Shipping Order No.";
        CodGNumDocMarchandise := RecGPurchHeader."No.";
        //<<NAVEASY.001 [Cde_Transport] Ajout code pour R‚cup‚ration
        //du Nø cde achat transport + Nø cde achat marchandise
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure OnBeforeSalesShptHeaderModify(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin

        SalesShptHeader."Total weight" := SalesShptHeader."Total weight";
        SalesShptHeader."Total Parcels" := SalesShptHeader."Total Parcels";

    end;
    // Invoice Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; CommitIsSuppressed: Boolean)

    //     begin
    //         //TODO  GenJnlLine."Mobile Salesperson Code" := SalesInvHeader."Mobile Salesperson Code";
    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnBeforeSalesInvLineInsert', '', false, false)]
    //     local procedure OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales I
    //     end;
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
        until OldSalesShipmentLine.NEXT = 0;
        //<<FTA_DIVERS.001

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCopySellToCustomerAddressFieldsFromCustomerOnAfterAssignSellToCustomerAddress', '', false, false)]

    procedure OnCopySellToCustomerAddressFieldsFromCustomerOnAfterAssignSellToCustomerAddress(var SalesHeader: Record "Sales Header"; Customer: Record Customer)

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
            until (RecLSalesLine.NEXT = 0) or (RecLSalesLine."Reserved Qty. (Base)" <> 0);
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
            until (RecLSalesLine.NEXT = 0) or (RecLSalesLine."Reserved Qty. (Base)" <> 0);
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
        "**FTA1.00": Integer;
        IntGNumber: Integer;
        "--FTA": Integer;

        RecLProductionBOMLine: Record 90;
        BoolFirstRead: Boolean;
        DecLAvailibityNoReserved: Decimal;
        DecGQtyKit: Decimal;
        RecGKitSalesLine: Record 901;
        RecGAssemLink: Record 904;
        "---- NDBI ----": Integer;
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
                RecLProductionBOMLine.RESET;
                RecLProductionBOMLine.SETRANGE("Parent Item No.", RecLItem."No.");
                if RecLProductionBOMLine.FINDSET then
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
                    until RecLProductionBOMLine.NEXT = 0;
            end;
        end;
        //<<FED_20090415:PA 15/04/2009
    end;

}//