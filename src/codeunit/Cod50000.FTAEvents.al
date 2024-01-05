codeunit 50000 "FTA_Events"
{
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeOnInsert', '', false, false)]
    local procedure OnBeforeOnInsert(var Item: Record Item; var IsHandled: Boolean; xRecItem: Record Item)
    var
        RecLItem: Record 27;
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
    var
        "**FTA1.00": Integer;
        CduLTemplateMgt: Codeunit 8612;
        RecRef: RecordRef;
        RecLTemplateHeader: Record 8618;
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
        SalesHeader: Record 36;
        AssembletoOrderLines: page 914;
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
}
