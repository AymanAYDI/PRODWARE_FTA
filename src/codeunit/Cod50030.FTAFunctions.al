codeunit 50030 "FTA_Functions"
{
    //<<Migration Codeunit 229 2/1/2024>>
    procedure EmailPurchHeader(PurchHeader: Record "Purchase Header");
    begin
        DoPrintPurchHeader(PurchHeader, true);
    end;
    //<<Migration Codeunit 229 2/1/2024>>
    local procedure DoPrintPurchHeader(PurchHeader: Record "Purchase Header"; SendAsEmail: Boolean);
    var
        ReportSelection: Record "Report Selections";
        DocumentMailing: Codeunit "Document-Mailing";
        AttachmentFilePath: Text[250];
        BooLLogo: Boolean;
        RecLReportUser: Record "Report Email By User";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        PurchCalcDisc: Codeunit "Purch.-Calc.Discount";
    begin
        PurchHeader.SETRANGE("No.", PurchHeader."No.");
        PurchSetup.GET();
        SalesSetup.GET();
        if PurchSetup."Calc. Inv. Discount" then begin
            PurchLine.RESET();
            PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
            PurchLine.SETRANGE("Document No.", PurchHeader."No.");
            PurchLine.FINDFIRST();
            PurchCalcDisc.RUN(PurchLine);
            PurchHeader.GET(PurchHeader."Document Type", PurchHeader."No.");
            COMMIT();
        end;

        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::Quote:
                ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"P.Quote");
            PurchHeader."Document Type"::"Blanket Order":
                ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"P.Blanket");
            PurchHeader."Document Type"::Order:
                ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"P.Order");
            PurchHeader."Document Type"::"Return Order":
                ReportSelection.SETRANGE(Usage, ReportSelection.Usage::"P.Return");
            else
                exit;
        end;
        ReportSelection.SETFILTER("Report ID", '<>0');
        ReportSelection.FIND('-');
        repeat
            if not RecLReportUser.GET(USERID, ReportSelection."Report ID") then begin
                RecLReportUser.INIT();
                RecLReportUser.UserID := USERID;
                RecLReportUser."Report ID" := ReportSelection."Report ID";
                RecLReportUser.INSERT();
            end;
            RecLReportUser.Email := SendAsEmail;
            RecLReportUser.MODIFY();
            COMMIT();
        //TODO : functions not found
        // if SendAsEmail then begin
        //     AttachmentFilePath := SavePurchHeaderReportAsPdf(PurchHeader, ReportSelection."Report ID");
        //     DocumentMailing.EmailFileFromPurchHeader(PurchHeader, AttachmentFilePath);

        //     end else
        //         REPORT.RUNMODAL(ReportSelection."Report ID", true, false, PurchHeader)
        until ReportSelection.NEXT() = 0;
    end;
    //<<Migration Codeunit 229 2/1/2024>>
    //todo: Scope OnPrem
    // local procedure SavePurchHeaderReportAsPdf(var PurchHeader: Record "Purchase Header"; ReportId: Integer): Text[250];
    // var
    //     FileManagement: Codeunit "File Management";
    //     ServerAttachmentFilePath: Text;
    //     ServerSaveAsPdfFailedErr: Label 'Cannot open the document because it is empty or cannot be created.';
    // begin
    //     ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

    //     REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, PurchHeader);
    //     if not EXISTS(ServerAttachmentFilePath) then
    //         ERROR(ServerSaveAsPdfFailedErr);

    //     exit(ServerAttachmentFilePath);
    // end;
    //<<Migration Codeunit 260 2/1/2024>>
    procedure EmailFileFromPurchHeader(PurchHeader: Record "Purchase Header"; AttachmentFilePath: Text[250]);
    begin
        EmailFileVendor(AttachmentFilePath,
          PurchHeader."No.",
          PurchHeader."Buy-from Vendor No.",
          PurchHeader."Buy-from Vendor Name",
          FORMAT(PurchHeader."Document Type"));
    end;
    //<<Migration Codeunit 260 2/1/2024>>
    procedure EmailFileVendor(AttachmentFilePath: Text[250]; PostedDocNo: Code[20]; SendEmaillToCustNo: Code[20]; SendEmaillToCustName: Text[50]; EmailDocName: Text[50]);
    var
        TempEmailItem: Record "Email Item" temporary;
        AttachmentFileName: Text[250];
        ReportAsPdfFileNameMsg2: Label '@@@="%1 = Document Type %2 = Invoice No.";Purchases %1 %2.pdf';
        EmailSubjectCapTxt: Label '@@@="%1 = Customer Name. %2 = Document Type %3 = Invoice No.";%1 - %2 %3';
    begin
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg2, EmailDocName, PostedDocNo);

        with TempEmailItem do begin
            //TODO : procedure not found
            // "Send to" := GetToAddressFromCustomer(SendEmaillToCustNo);
            Subject := COPYSTR(
                STRSUBSTNO(
                  EmailSubjectCapTxt, SendEmaillToCustName, EmailDocName, PostedDocNo), 1,
                MAXSTRLEN(Subject));
            "Attachment File Path" := AttachmentFilePath;
            "Attachment Name" := AttachmentFileName;
            Send(false);
        end;
    end;
    //<<Migration Codeunit 260 2/1/2024>>
    procedure GetToAddressFromVendor(BuyFromVendorNo: Code[20]): Text[250];
    var
        Vendor: Record Vendor;
        ToAddress: Text;
    begin
        if Vendor.GET(BuyFromVendorNo) then
            ToAddress := Vendor."E-Mail";
        exit(ToAddress);
    end;
    //<<Migration Codeunit 260 2/1/2024>>
    procedure EmailFileFromQO(AttachmentFilePath: Text[250]; PostedDocNo: Code[20]; SendEmaillToVendNo: Code[20]; SendEmaillToVendName: Text[50]; EmailDocName: Text[50]; EmailSendTo: Text[50]; EmailSubject: Text[100]);
    var
        TempEmailItem: Record "Email Item" temporary;
        AttachmentFileName: Text[250];
        ReportAsPdfFileNameMsg: Label '@@@="%1 = Document Type %2 = Invoice No."; Sales %1 %2.pdf';
    begin
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, EmailDocName, PostedDocNo);

        with TempEmailItem do begin
            "Send to" := EmailSendTo;
            //TODO : EmailSubjectCapTxt not found
            //     if EmailSubject = '' then
            //         Subject :=
            //           COPYSTR(
            //               STRSUBSTNO(
            //                 EmailSubjectCapTxt, SendEmaillToVendName, EmailDocName, PostedDocNo), 1,
            //               MAXSTRLEN(Subject))
            //     else
            //         Subject := EmailSubject;
            //     "Attachment File Path" := AttachmentFilePath;
            //     "Attachment Name" := AttachmentFileName;
            //     Send(false);
        end;
    end;
    //<<Migration codeunit 0099000831>>
    procedure CloseReservEntry2(ReservEntry: Record "Reservation Entry");
    var
        ReservEntry3: Record "Reservation Entry";
        TempSurplusEntry: Record "Reservation Entry" temporary;
        LastEntryNo: Integer;
        ResEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        ReservEntry.TESTFIELD("Reservation Status", ReservEntry."Reservation Status"::Reservation);

        ReservEntry3.LOCKTABLE();
        if ReservEntry3.FINDLAST() then
            LastEntryNo := ReservEntry3."Entry No.";

        ReservEntry3.GET(ReservEntry."Entry No.", not ReservEntry.Positive);
        if (ReservEntry3."Lot No." <> '') or (ReservEntry3."Serial No." <> '') or
           (ReservEntry."Lot No." <> '') or (ReservEntry."Serial No." <> '') then begin
            ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
            ReservEntry3."Reservation Status" := ReservEntry3."Reservation Status"::Surplus;
            ReservEntry.MODIFY();
            ReservEntry3.DELETE();
            ReservEntry3."Entry No." := LastEntryNo + 1;
            ReservEntry3.INSERT();
            TempSurplusEntry.DELETEALL();
            //TODO : not found
            // ResEngineMgt.UpdateTempSurplusEntry(ReservEntry);
            // ResEngineMgt.UpdateTempSurplusEntry(ReservEntry3);
            ResEngineMgt.UpdateOrderTracking(TempSurplusEntry);
        end else
            ResEngineMgt.CloseReservEntry(ReservEntry, true, false);
    end;


    //<<Migration codeunit 5701>> 

    procedure ExplodeItemAssemblySubst(var AssemblyLine: Record "Assembly Line"; OnlyAvailableQty: Boolean; RemplaceOk: Boolean);
    var
        TempAssemblyLine: Record "Assembly Line" temporary;
        ToAssemblyLine: Record "Assembly Line";
        NoOfItemSubsLines: Integer;
        LineSpacing: Integer;
        NextLineNo: Integer;
        TempItemSubstitution: Record "Item Substitution" temporary;
        ReqBaseQty: Decimal;
        ErrorOk: Boolean;
        DeleteOriginalAssLineOk: Boolean;
        OnlyOneSubstOk: Boolean;
        AutoReserveOk: Boolean;
        SaveItemNo: Code[20];
        SaveVariantCode: Code[10];
        Item: Record Item;
        OldSalesUOM: Code[10];
        ItemSubstitution: Record "Item Substitution";
        Text002: Label 'An Item Substitution does not exist for Item No. ''%1''';
        Text003: Label 'There is not enough space to explode the Substitution.';
        SaveQty: Decimal;
        SaveLocation: Code[10];
    begin
        TempItemSubstitution.RESET();
        TempItemSubstitution.DELETEALL();
        NextLineNo := 0;

        if RemplaceOk then begin
            ErrorOk := false;
            DeleteOriginalAssLineOk := true;
            OnlyOneSubstOk := true;
            AutoReserveOk := true;
        end else begin
            ErrorOk := false;
            DeleteOriginalAssLineOk := false;
            OnlyOneSubstOk := false;
            AutoReserveOk := false;
        end;

        with AssemblyLine do begin

            TESTFIELD(Type, Type::Item);
            TESTFIELD("Consumed Quantity", 0);
            CALCFIELDS("Reserved Qty. (Base)");
            TESTFIELD("Reserved Qty. (Base)", 0);
            ReqBaseQty := 0;
            ReqBaseQty := "Quantity (Base)";
            SaveItemNo := "No.";
            SaveVariantCode := "Variant Code";
            Item.GET(AssemblyLine."No.");
            Item.SETFILTER("Location Filter", "Location Code");
            Item.SETFILTER("Variant Filter", "Variant Code");
            Item.SETRANGE("Date Filter", 0D, "Due Date");
            Item.CALCFIELDS(Inventory);
            Item.CALCFIELDS("Qty. on Sales Order");
            Item.CALCFIELDS("Qty. on Service Order");
            OldSalesUOM := Item."Sales Unit of Measure";

            NoOfItemSubsLines := 0;
            ItemSubstitution.RESET();
            ItemSubstitution.SETRANGE(Type, ItemSubstitution.Type::Item);
            ItemSubstitution.SETRANGE("No.", AssemblyLine."No.");
            ItemSubstitution.SETRANGE("Variant Code", "Variant Code");
            ItemSubstitution.SETRANGE("Location Filter", "Location Code");
            if ItemSubstitution.FIND('-') then
                repeat
                    TempItemSubstitution.INIT();
                    TempItemSubstitution."No." := ItemSubstitution."No.";
                    TempItemSubstitution."Variant Code" := ItemSubstitution."Variant Code";
                    TempItemSubstitution."Substitute No." := ItemSubstitution."Substitute No.";
                    TempItemSubstitution."Substitute Variant Code" := ItemSubstitution."Substitute Variant Code";
                    TempItemSubstitution.Description := ItemSubstitution.Description;
                    TempItemSubstitution.Interchangeable := ItemSubstitution.Interchangeable;
                    TempItemSubstitution."Location Filter" := ItemSubstitution."Location Filter";
                    TempItemSubstitution.Condition := ItemSubstitution.Condition;
                    TempItemSubstitution."Shipment Date" := AssemblyLine."Due Date";
                    if ItemSubstitution."Substitute Type" = ItemSubstitution."Substitute Type"::Item then begin
                        Item.GET(ItemSubstitution."Substitute No.");
                        Item.CALCFIELDS(Inventory);
                        TempItemSubstitution.Inventory := Item.Inventory;
                        TempItemSubstitution."Avaibility no reserved" := ItemSubstitution.CalcAvailableNoReserv();
                    end else begin
                        TempItemSubstitution."Substitute Type" := TempItemSubstitution."Substitute Type"::"Nonstock Item";
                        TempItemSubstitution."Quantity Avail. on Shpt. Date" := 0;
                        TempItemSubstitution."Avaibility no reserved" := 0;
                        TempItemSubstitution.Inventory := 0;
                    end;
                    if (not OnlyAvailableQty) or
                       ((TempItemSubstitution."Avaibility no reserved" > 0) and
                        (TempItemSubstitution."Avaibility no reserved" >= ReqBaseQty)) then
                        TempItemSubstitution.INSERT();
                until ItemSubstitution.NEXT() = 0;

            NoOfItemSubsLines := TempItemSubstitution.COUNT;
            if NoOfItemSubsLines = 0 then
                if ErrorOk then
                    ERROR(Text002, "No.");

            ToAssemblyLine.RESET();
            ToAssemblyLine.SETRANGE("Document Type", "Document Type");
            ToAssemblyLine.SETRANGE("Document No.", "Document No.");
            ToAssemblyLine.GET("Document Type", "Document No.", "Line No.");
            LineSpacing := 10000;
            if ToAssemblyLine.FIND('>') then begin
                LineSpacing := (ToAssemblyLine."Line No." - "Line No.") div (1 + NoOfItemSubsLines);
                if LineSpacing = 0 then
                    ERROR(Text003);
            end;

            NextLineNo := "Line No.";
        end;

        TempItemSubstitution.RESET();
        if TempItemSubstitution.FIND('-') then begin
            repeat
                TempAssemblyLine.INIT();
                TempAssemblyLine := AssemblyLine;
                TempAssemblyLine."Document Type" := AssemblyLine."Document Type";
                TempAssemblyLine."Document No." := AssemblyLine."Document No.";
                NextLineNo := NextLineNo + LineSpacing;
                TempAssemblyLine."Line No." := NextLineNo;
                TempAssemblyLine.INSERT(true);

                TempAssemblyLine."No." := TempItemSubstitution."Substitute No.";
                TempAssemblyLine."Variant Code" := TempItemSubstitution."Substitute Variant Code";
                SaveQty := TempAssemblyLine.Quantity;
                SaveLocation := TempAssemblyLine."Location Code";

                TempAssemblyLine.Quantity := 0;
                TempAssemblyLine.VALIDATE("No.", TempItemSubstitution."Substitute No.");
                TempAssemblyLine.VALIDATE("Variant Code", TempItemSubstitution."Substitute Variant Code");
                TempAssemblyLine."Originally Ordered No." := SaveItemNo;
                TempAssemblyLine."Originally Ordered Var. Code" := SaveVariantCode;
                TempAssemblyLine."Location Code" := SaveLocation;
                TempAssemblyLine.VALIDATE(Quantity, SaveQty);
                TempAssemblyLine.VALIDATE("Unit of Measure Code", OldSalesUOM);
                TempAssemblyLine.MODIFY(true);
            until OnlyOneSubstOk or (TempItemSubstitution.NEXT() = 0);

            TempAssemblyLine.RESET();
            if TempAssemblyLine.FINDSET() then begin
                repeat
                    ToAssemblyLine.INIT();
                    ToAssemblyLine := TempAssemblyLine;
                    ToAssemblyLine.INSERT();
                    if AutoReserveOk then
                        ToAssemblyLine.FctAutoReserveFTA();

                until TempAssemblyLine.NEXT() = 0;
                if DeleteOriginalAssLineOk then
                    AssemblyLine.DELETE(true);
            end;
        end else
            if ErrorOk then
                ERROR(Text002, AssemblyLine."No.");
    end;
    //<<Dupliquer de codeunit "CRM Integration Management"
    procedure IsIntegrationEnabled(): Boolean
    var
        CRMConnectionSentup: Record "CRM Connection Setup";
    begin
        if not CRMConnectionSentup.ReadPermission() then
            exit(false);

        if not CRMConnectionSentup.Get() then
            exit(false);

        if not CRMConnectionSentup."Is Enabled" then
            exit(false);

        exit(true);
    end;

    procedure CheckCustPostGroup(RecNewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; RecOldCustLedgEntry: Record "Cust. Ledger Entry");
    var
        CodLPostingGroup: Code[20];
        CstL001: Label 'Posting group values not corresponding between selected entries.';
    begin
        //Check if all entries have same posting group
        if RecOldCustLedgEntry."Customer Posting Group" <> RecNewCVLedgEntryBuf."CV Posting Group" then
            ERROR(CstL001);
    end;//Codeunit 12

    procedure CheckHeaderNo(): Boolean;
    var
        PaymentLine: Record "Payment Line";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        PaymentLine.SETRANGE("No.", GenJnlLine."Document No.");
        if PaymentLine.FINDFIRST() then
            exit(true)
        else
            exit(false);

    end;//Codeunit 12

    procedure CheckVendPostGroup(RecNewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; RecOldVendLedgEntry: Record "Vendor Ledger Entry");
    var
        CodLPostingGroup: Code[20];
        CstL001: Label 'ENU=Posting group values not corresponding between selected entries.';
    begin
        //Check if all entries have same posting group
        if RecOldVendLedgEntry."Vendor Posting Group" <> RecNewCVLedgEntryBuf."CV Posting Group" then
            ERROR(CstL001);
    end;//Codeunit 12

    // procedure FctFromPaymentMgt(BooPPaymentMgt: Boolean);
    // var
    // begin
    //     BooGPaymentMgt := BooPPaymentMgt;
    // end;//Codeunit 12


    //CodeUnit 246
    procedure OnRunDisAssembly(var Rec: Record "Item Journal Line");
    var
        ToItemJnlLine: Record "Item Journal Line";
        FromBOMComp: Record "BOM Component";
        Item: Record Item;
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        UOMMgt: Codeunit "Unit of Measure Management";
        LineSpacing: Integer;
        NextLineNo: Integer;
        NoOfBOMComp: Integer;
        Selection: Integer;
        Text000: Label 'Item %1 is not a BOM.';
        Text002: Label 'There is not enough space to explode the BOM.';
        Text003: Label '&Copy dimensions from BOM,&Retrieve dimensions from components';
    begin
        //>> MIGR NAV 2015 - ADAPATATION DEMONTAGE
        with Rec do begin
            TESTFIELD("Item No.");
            CALCFIELDS("Reserved Qty. (Base)");
            TESTFIELD("Reserved Qty. (Base)", 0);
            TESTFIELD("Entry Type", "Entry Type"::"Negative Adjmt.");
            FromBOMComp.SETRANGE("Parent Item No.", "Item No.");
            FromBOMComp.SETRANGE(Type, FromBOMComp.Type::Item);
            NoOfBOMComp := FromBOMComp.COUNT;
            if NoOfBOMComp = 0 then
                ERROR(
                  Text000,
                  "Item No.");

            Selection := STRMENU(Text003, 2);
            if Selection = 0 then
                exit;

            ToItemJnlLine.RESET();
            ToItemJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
            ToItemJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
            ToItemJnlLine.SETRANGE("Document No.", "Document No.");
            ToItemJnlLine.SETRANGE("Posting Date", "Posting Date");
            ToItemJnlLine.SETRANGE("Entry Type", "Entry Type");
            ToItemJnlLine := Rec;
            if ToItemJnlLine.FIND('>') then begin
                LineSpacing := (ToItemJnlLine."Line No." - "Line No.") div (1 + NoOfBOMComp);
                if LineSpacing = 0 then
                    ERROR(Text002);
            end else
                LineSpacing := 10000;

            ToItemJnlLine := Rec;
            FromBOMComp.SETFILTER("No.", '<>%1', '');
            if FromBOMComp.FIND('-') then
                repeat
                    Item.GET(FromBOMComp."No.");
                    ToItemJnlLine."Line No." := 0;
                    ToItemJnlLine."Entry Type" := "Entry Type"::"Positive Adjmt.";
                    ToItemJnlLine."Item No." := FromBOMComp."No.";
                    ToItemJnlLine."Variant Code" := FromBOMComp."Variant Code";
                    ToItemJnlLine."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToItemJnlLine."Qty. per Unit of Measure" :=
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                    ToItemJnlLine.Quantity := ROUND("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001);
                    if ToItemJnlLine.Quantity > 0 then
                        if ItemCheckAvail.ItemJnlCheckLine(ToItemJnlLine) then
                            ItemCheckAvail.RaiseUpdateInterruptedError();
                until FromBOMComp.NEXT() = 0;

            ToItemJnlLine := Rec;
            //ToItemJnlLine.INIT;
            //ToItemJnlLine.Description := Description;
            ToItemJnlLine.MODIFY();

            FromBOMComp.RESET();
            FromBOMComp.SETRANGE("Parent Item No.", "Item No.");
            FromBOMComp.SETRANGE(Type, FromBOMComp.Type::Item);
            FromBOMComp.FINDSET();
            NextLineNo := "Line No.";

            repeat
                ToItemJnlLine.INIT();
                ToItemJnlLine."Journal Template Name" := "Journal Template Name";
                ToItemJnlLine."Document No." := "Document No.";
                ToItemJnlLine."Document Date" := "Document Date";
                ToItemJnlLine."Posting Date" := "Posting Date";
                ToItemJnlLine."External Document No." := "External Document No.";
                ToItemJnlLine.VALIDATE("Entry Type", "Entry Type"::"Positive Adjmt.");
                ToItemJnlLine."Location Code" := "Location Code";
                NextLineNo := NextLineNo + LineSpacing;
                ToItemJnlLine."Line No." := NextLineNo;
                ToItemJnlLine."Drop Shipment" := "Drop Shipment";
                ToItemJnlLine."Source Code" := "Source Code";
                ToItemJnlLine."Reason Code" := "Reason Code";
                ToItemJnlLine.VALIDATE("Item No.", FromBOMComp."No.");
                ToItemJnlLine.VALIDATE("Variant Code", FromBOMComp."Variant Code");
                ToItemJnlLine.VALIDATE("Unit of Measure Code", FromBOMComp."Unit of Measure Code");
                ToItemJnlLine.VALIDATE(
                  Quantity,
                  ROUND("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001));
                ToItemJnlLine.Description := FromBOMComp.Description;
                ToItemJnlLine.INSERT();

                if Selection = 1 then begin
                    ToItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    ToItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    ToItemJnlLine."Dimension Set ID" := "Dimension Set ID";
                    ToItemJnlLine.MODIFY();
                end;
            until FromBOMComp.NEXT() = 0;
        end;

        //<< MIGR NAV 2015 - ADAPATATION DEMONTAGE
    end;

    //CodeUnit 246
    procedure OnRunAssembly(var Rec: Record "Item Journal Line");
    var

        ToItemJnlLine: Record "Item Journal Line";
        FromBOMComp: Record "BOM Component";
        Item: Record Item;
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        UOMMgt: Codeunit "Unit of Measure Management";
        LineSpacing: Integer;
        NextLineNo: Integer;
        NoOfBOMComp: Integer;
        Selection: Integer;
        Text000: Label 'Item %1 is not a BOM.';
        Text002: Label 'There is not enough space to explode the BOM.';
        Text003: Label '&Copy dimensions from BOM,&Retrieve dimensions from components';
    begin
        //>> MIGR NAV 2015 - ADAPATATION DEMONTAGE
        with Rec do begin
            TESTFIELD("Item No.");
            CALCFIELDS("Reserved Qty. (Base)");
            TESTFIELD("Reserved Qty. (Base)", 0);
            TESTFIELD("Entry Type", "Entry Type"::"Positive Adjmt.");
            FromBOMComp.SETRANGE("Parent Item No.", "Item No.");
            FromBOMComp.SETRANGE(Type, FromBOMComp.Type::Item);
            NoOfBOMComp := FromBOMComp.COUNT;
            if NoOfBOMComp = 0 then
                ERROR(
                  Text000,
                  "Item No.");

            Selection := STRMENU(Text003, 2);
            if Selection = 0 then
                exit;

            ToItemJnlLine.RESET();
            ToItemJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
            ToItemJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
            ToItemJnlLine.SETRANGE("Document No.", "Document No.");
            ToItemJnlLine.SETRANGE("Posting Date", "Posting Date");
            ToItemJnlLine.SETRANGE("Entry Type", "Entry Type");
            ToItemJnlLine := Rec;
            if ToItemJnlLine.FIND('>') then begin
                LineSpacing := (ToItemJnlLine."Line No." - "Line No.") div (1 + NoOfBOMComp);
                if LineSpacing = 0 then
                    ERROR(Text002);
            end else
                LineSpacing := 10000;

            ToItemJnlLine := Rec;
            FromBOMComp.SETFILTER("No.", '<>%1', '');
            if FromBOMComp.FIND('-') then
                repeat
                    Item.GET(FromBOMComp."No.");
                    ToItemJnlLine."Line No." := 0;
                    ToItemJnlLine."Entry Type" := "Entry Type"::"Negative Adjmt.";
                    ToItemJnlLine."Item No." := FromBOMComp."No.";
                    ToItemJnlLine."Variant Code" := FromBOMComp."Variant Code";
                    ToItemJnlLine."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToItemJnlLine."Qty. per Unit of Measure" :=
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                    ToItemJnlLine.Quantity := ROUND("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001);
                    if ToItemJnlLine.Quantity > 0 then
                        if ItemCheckAvail.ItemJnlCheckLine(ToItemJnlLine) then
                            ItemCheckAvail.RaiseUpdateInterruptedError();
                until FromBOMComp.NEXT() = 0;

            ToItemJnlLine := Rec;
            //ToItemJnlLine.INIT;
            //ToItemJnlLine.Description := Description;
            ToItemJnlLine.MODIFY();

            FromBOMComp.RESET();
            FromBOMComp.SETRANGE("Parent Item No.", "Item No.");
            FromBOMComp.SETRANGE(Type, FromBOMComp.Type::Item);
            FromBOMComp.FINDSET();
            NextLineNo := "Line No.";

            repeat
                ToItemJnlLine.INIT();
                ToItemJnlLine."Journal Template Name" := "Journal Template Name";
                ToItemJnlLine."Document No." := "Document No.";
                ToItemJnlLine."Document Date" := "Document Date";
                ToItemJnlLine."Posting Date" := "Posting Date";
                ToItemJnlLine."External Document No." := "External Document No.";
                ToItemJnlLine.VALIDATE("Entry Type", "Entry Type"::"Negative Adjmt.");
                ToItemJnlLine."Location Code" := "Location Code";
                NextLineNo := NextLineNo + LineSpacing;
                ToItemJnlLine."Line No." := NextLineNo;
                ToItemJnlLine."Drop Shipment" := "Drop Shipment";
                ToItemJnlLine."Source Code" := "Source Code";
                ToItemJnlLine."Reason Code" := "Reason Code";
                ToItemJnlLine.VALIDATE("Item No.", FromBOMComp."No.");
                ToItemJnlLine.VALIDATE("Variant Code", FromBOMComp."Variant Code");
                ToItemJnlLine.VALIDATE("Unit of Measure Code", FromBOMComp."Unit of Measure Code");
                ToItemJnlLine.VALIDATE(
                  Quantity,
                  ROUND("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001));
                ToItemJnlLine.Description := FromBOMComp.Description;
                ToItemJnlLine.INSERT();

                if Selection = 1 then begin
                    ToItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    ToItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    ToItemJnlLine."Dimension Set ID" := "Dimension Set ID";
                    ToItemJnlLine.MODIFY();
                end;
            until FromBOMComp.NEXT() = 0;
        end;

        //<< MIGR NAV 2015 - ADAPATATION DEMONTAGE
    end;






    // codeunit 905
    procedure FctRefreshTempSubKitSalesFTA(var AsmLine: Record "Assembly Line");
    var
        RecLReservEntry: Record "Reservation Entry";
        AssemblyHeader: Record "Assembly Header";
        FromBOMComp: Record "BOM Component";
        ToAssemblyLine: Record "Assembly Line";
        RecLAsmLine: Record "Assembly Line";
        TempAssemblyLine: Record "Assembly Line" temporary;
        CduLReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        AssemblyLineMgt: Codeunit "Assembly Line Management";
        NoOfBOMCompLines: Integer;
        LineSpacing: Integer;
        NextLineNo: Integer;
        DueDateBeforeWorkDate: Boolean;
        NewLineDueDate: Date;
        IntLAfterCompLineNo: Integer;
        BooLEndLoop: Boolean;
        Text006: Label 'Item %1 is not a BOM.';
        Text007: Label 'There is not enough space to explode the BOM.';
    begin
        //>>MIGR NAV 2015

        if AsmLine."Kit Action" = AsmLine."Kit Action"::" " then
            exit;

        with AsmLine do
            if AsmLine."Kit Action" = AsmLine."Kit Action"::Disassembly then begin
                TESTFIELD(Type, Type::Item);
                //TESTFIELD("Consumed Quantity",0);
                //CALCFIELDS("Reserved Qty. (Base)");
                //TESTFIELD("Reserved Qty. (Base)",0);

                AssemblyHeader.GET("Document Type", "Document No.");
                FromBOMComp.SETRANGE("Parent Item No.", "No.");
                NoOfBOMCompLines := FromBOMComp.COUNT;
                if NoOfBOMCompLines = 0 then
                    ERROR(Text006, "No.");

                ToAssemblyLine.RESET();
                ToAssemblyLine.SETRANGE("Document Type", "Document Type");
                ToAssemblyLine.SETRANGE("Document No.", "Document No.");
                ToAssemblyLine := AsmLine;
                LineSpacing := 10000;
                if ToAssemblyLine.FIND('>') then begin
                    LineSpacing := (ToAssemblyLine."Line No." - "Line No.") div (1 + NoOfBOMCompLines);
                    if LineSpacing = 0 then
                        ERROR(Text007);
                end;

                TempAssemblyLine.INIT();
                TempAssemblyLine := AsmLine;
                TempAssemblyLine."x Quantity per" := AsmLine."Quantity per";
                //TempAssemblyLine."x Quantity per (Base)" := AsmLine."Quantity per (Base)";
                //TempAssemblyLine."x Extended Quantity" := AsmLine."Extended Quantity";
                //TempAssemblyLine."x Extended Quantity (Base)" := AsmLine."Extended Quantity (Base)";
                TempAssemblyLine."Quantity per" := 0;
                TempAssemblyLine.VALIDATE(Quantity, 0);
                //TempAssemblyLine."Extended Quantity" := 0;
                //TempAssemblyLine."Extended Quantity (Base)" := 0;
                TempAssemblyLine.VALIDATE("Remaining Quantity (Base)", 0);
                TempAssemblyLine.VALIDATE("Remaining Quantity", 0);
                TempAssemblyLine."x Outstanding Quantity" := AsmLine."Remaining Quantity";
                TempAssemblyLine."x Outstanding Qty. (Base)" := AsmLine."Remaining Quantity (Base)";
                TempAssemblyLine.INSERT();

                RecLReservEntry.SETRANGE("Reservation Status", RecLReservEntry."Reservation Status"::Reservation);
                RecLReservEntry.SETRANGE("Source Type", DATABASE::"Assembly Line");
                RecLReservEntry.SETRANGE("Source ID", AsmLine."Document No.");
                RecLReservEntry.SETRANGE("Source Prod. Order Line", AsmLine."Line No.");
                RecLReservEntry.SETRANGE("Source Ref. No.", AsmLine."Line No.");
                //Delete reservation
                if RecLReservEntry.FINDFIRST() then
                    repeat
                        CduLReservEngineMgt.CloseReservEntry2(RecLReservEntry);
                    until RecLReservEntry.NEXT() = 0;


                NextLineNo := "Line No.";
                FromBOMComp.FINDSET();
                repeat
                    TempAssemblyLine.INIT();
                    TempAssemblyLine."Document Type" := "Document Type";
                    TempAssemblyLine."Document No." := "Document No.";
                    NextLineNo := NextLineNo + LineSpacing;
                    TempAssemblyLine."Line No." := NextLineNo;
                    TempAssemblyLine.INSERT(true);
                    AddBOMLine2(AssemblyHeader, TempAssemblyLine, true, FromBOMComp, false);
                    TempAssemblyLine.Quantity := TempAssemblyLine.Quantity * "Quantity per" * "Qty. per Unit of Measure";
                    TempAssemblyLine."Quantity (Base)" := TempAssemblyLine."Quantity (Base)" * "Quantity per" * "Qty. per Unit of Measure";
                    TempAssemblyLine."Quantity per" := TempAssemblyLine."Quantity per" * "Quantity per" * "Qty. per Unit of Measure";
                    TempAssemblyLine."Remaining Quantity" := TempAssemblyLine."Remaining Quantity" * "Quantity per" * "Qty. per Unit of Measure";
                    TempAssemblyLine."Remaining Quantity (Base)" :=
                    TempAssemblyLine."Remaining Quantity (Base)" * "Quantity per" * "Qty. per Unit of Measure";
                    TempAssemblyLine."Quantity to Consume" :=
                    TempAssemblyLine."Quantity to Consume" * "Quantity per" * "Qty. per Unit of Measure";
                    TempAssemblyLine."Quantity to Consume (Base)" :=
                    TempAssemblyLine."Quantity to Consume (Base)" * "Quantity per" * "Qty. per Unit of Measure";
                    TempAssemblyLine."Cost Amount" := TempAssemblyLine."Unit Cost" * TempAssemblyLine.Quantity;
                    TempAssemblyLine."Dimension Set ID" := "Dimension Set ID";
                    TempAssemblyLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    TempAssemblyLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    TempAssemblyLine."Level No." := AsmLine."Level No." + 1;

                    TempAssemblyLine.MODIFY(true);
                until FromBOMComp.NEXT() = 0;

                TempAssemblyLine.RESET();
                TempAssemblyLine.FINDSET();
                ToAssemblyLine := TempAssemblyLine;
                ToAssemblyLine.MODIFY();
                // FTA1.02b
                AsmLine := ToAssemblyLine;

                while TempAssemblyLine.NEXT() <> 0 do begin
                    ToAssemblyLine := TempAssemblyLine;
                    ToAssemblyLine.INSERT();
                    if ToAssemblyLine."Due Date" < WORKDATE() then begin
                        DueDateBeforeWorkDate := true;
                        NewLineDueDate := ToAssemblyLine."Due Date";
                    end;

                    //>> FTA1.02
                    if AutoReserveOk then
                        ToAssemblyLine.FctAutoReserveFTA();
                    //<< FTA1.02

                end;
                if DueDateBeforeWorkDate then
                    AssemblyLineMgt.ShowDueDateBeforeWorkDateMsg(NewLineDueDate);
            end else begin
                TempAssemblyLine.INIT();
                TempAssemblyLine := AsmLine;
                TempAssemblyLine."Quantity per" := AsmLine."x Quantity per";
                TempAssemblyLine."Remaining Quantity" := AsmLine."x Outstanding Quantity";
                TempAssemblyLine."Remaining Quantity (Base)" := AsmLine."x Outstanding Qty. (Base)";
                TempAssemblyLine.Quantity := AsmLine."x Outstanding Quantity";
                TempAssemblyLine."Quantity (Base)" := AsmLine."x Outstanding Qty. (Base)";
                TempAssemblyLine."Quantity to Consume" := TempAssemblyLine."Remaining Quantity";
                TempAssemblyLine."Quantity to Consume (Base)" := TempAssemblyLine."Remaining Quantity (Base)";
                TempAssemblyLine."x Quantity per" := 0;
                TempAssemblyLine."x Outstanding Quantity" := 0;
                TempAssemblyLine."x Outstanding Qty. (Base)" := 0;
                TempAssemblyLine.INSERT();

                TempAssemblyLine.RESET();
                TempAssemblyLine.FINDSET();
                ToAssemblyLine := TempAssemblyLine;
                ToAssemblyLine.MODIFY();

                IntLAfterCompLineNo := 0;
                //Deletion of enreg
                BooLEndLoop := false;
                RecLAsmLine.SETRANGE("Document No.", AsmLine."Document No.");
                //>>TI298979
                RecLAsmLine.SETRANGE("Document Type", AsmLine."Document Type");
                //<<TI298979
                //RecLAsmLine.SETRANGE("Document Line No.","Document line no.");
                RecLAsmLine.SETFILTER("Line No.", '>%1', AsmLine."Line No.");
                if RecLAsmLine.FINDSET() then
                    repeat
                        if RecLAsmLine."Level No." > AsmLine."Level No." then
                            RecLAsmLine.DELETE(true)
                        else begin
                            IntLAfterCompLineNo := RecLAsmLine."Line No.";
                            BooLEndLoop := true;
                        end;
                    until (RecLAsmLine.NEXT() = 0) or (BooLEndLoop = true);
            end;
        //<<MIGR NAV 2015
    end;

    procedure FctCountKitDisposalToBuild(var TmpAssemblyHeader: Record "Assembly Header"; var TempAssemblyLine: Record "Assembly Line" temporary): Decimal;
    var
        Item: Record Item;
        TempAssemblyLine2: Record "Assembly Line" temporary;
        AssemblySetup: Record "Assembly Setup";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        AssemblyLineManagement: Codeunit "Assembly Line Management";
        AssemblyAvailability: Page "Assembly Availability";
        Inventory: Decimal;
        GrossRequirement: Decimal;
        ReservedRequirement: Decimal;
        ScheduledReceipts: Decimal;
        ReservedReceipts: Decimal;
        EarliestAvailableDateX: Date;
        QtyAvailToMake: Decimal;
        QtyAvailTooLow: Boolean;
    begin
        //>>MIGR NAV 2015
        AssemblySetup.GET;
        if not GUIALLOWED or
           TempAssemblyLine.ISEMPTY or
           (not AssemblySetup."Stockout Warning") or
           not GetWarningMode
        then
            exit(0);
        TmpAssemblyHeader.TESTFIELD("Item No.");
        Item.GET(TmpAssemblyHeader."Item No.");

        ItemCheckAvail.AsmOrderCalculate(TmpAssemblyHeader, Inventory,
          GrossRequirement, ReservedRequirement, ScheduledReceipts, ReservedReceipts);
        TempAssemblyLine2.COPY(TempAssemblyLine, true);
        AvailToPromise(TmpAssemblyHeader, TempAssemblyLine2, QtyAvailToMake, EarliestAvailableDateX);
        exit(QtyAvailToMake);
        //<<MIGR NAV 2015
    end;

    procedure SetAutoReserve();
    begin
        //>> FTA1.02
        AutoReserveOk := true;
    end;


    //Codeunit 7000
    procedure Fct_GetDiscforAll(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line");
    var
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
        RecLSalesLineDisc: Record "Sales Line Discount";
        Item: Record Item;
        DatLWorkDate: Date;
        BooLRecOK: Boolean;
    begin
        //>>FED_20090415:PA 15/04/2009

        if (SalesLine.Type <> SalesLine.Type::Item) or
            (not SalesLine."Allow Line Disc.") or
            (SalesLine."Item Base" = SalesLine."Item Base"::Transitory) then
            exit;
        Item.GET(SalesLine."No.");
        if (Item."Inventory Value Zero") then
            exit;

        if SalesLine."Line Discount %" = 0 then begin
            RecLSalesReceivablesSetup.GET();
            if RecLSalesReceivablesSetup."Discount All Item" <> '' then begin
                if SalesHeader."Document Type" in [SalesLine."Document Type"::Invoice, SalesLine."Document Type"::"Credit Memo"] then
                    DatLWorkDate := SalesHeader."Posting Date"
                else
                    DatLWorkDate := SalesHeader."Order Date";
                RecLSalesLineDisc.SETRANGE(Type, RecLSalesLineDisc.Type::"Item Disc. Group");
                RecLSalesLineDisc.SETRANGE("Sales Type", RecLSalesLineDisc."Sales Type"::Customer);
                RecLSalesLineDisc.SETRANGE("Sales Code", SalesLine."Sell-to Customer No.");
                RecLSalesLineDisc.SETRANGE(Code, RecLSalesReceivablesSetup."Discount All Item");
                RecLSalesLineDisc.SETFILTER("Minimum Quantity", '<=%1', SalesLine.Quantity);
                if RecLSalesLineDisc.FINDSET() then
                    repeat
                        BooLRecOK := true;
                        if (SalesLine."Unit of Measure Code" <> RecLSalesLineDisc."Unit of Measure Code") and
                             (RecLSalesLineDisc."Unit of Measure Code" <> '') then
                            BooLRecOK := false;
                        if (RecLSalesLineDisc."Starting Date" <> 0D) and (DatLWorkDate < RecLSalesLineDisc."Starting Date") then
                            BooLRecOK := false;
                        if (RecLSalesLineDisc."Ending Date" <> 0D) and (DatLWorkDate > RecLSalesLineDisc."Ending Date") then
                            BooLRecOK := false;
                        if (BooLRecOK = true) then begin
                            SalesLine."Line Discount %" := RecLSalesLineDisc."Line Discount %";
                            SalesLine."Allow Line Disc." := true;
                        end;
                    until RecLSalesLineDisc.NEXT() = 0;
            end;
        end;
        //<<FED_20090415:PA 15/04/2009
    end;



    //Codeunit 7171
    procedure FctCalcPrepa(var RecPSalesLine: Record "Sales Line") DecPAmount: Decimal;
    var
        RecLSalesLine: Record "Sales Line";
        RecLKitSalesLine: Record "Assembly Line";
    begin
        //>>TI040889.001
        RecLSalesLine.RESET();
        RecLSalesLine.SETCURRENTKEY(Type, "No.");
        //<<TI040889.001
        RecLSalesLine.SETRANGE(Type, RecPSalesLine.Type::Item);
        RecLSalesLine.SETRANGE("No.", RecPSalesLine."No.");
        //RecLSalesLine.SETRANGE("Build Kit",FALSE);
        RecLSalesLine.SETFILTER("Outstanding Quantity", '<>0');
        DecPAmount := 0;
        if RecLSalesLine.FINDSET() then
            repeat
                DecPAmount += RecLSalesLine."Outstanding Quantity";
            until RecLSalesLine.NEXT() = 0;

        //>>TI040889.001
        RecLKitSalesLine.RESET();
        RecLKitSalesLine.SETCURRENTKEY(Type, "No.");
        //<<TI040889.001
        RecLKitSalesLine.SETRANGE(Type, RecLKitSalesLine.Type::Item);
        RecLKitSalesLine.SETRANGE("No.", RecPSalesLine."No.");
        RecLKitSalesLine.SETFILTER("Remaining Quantity", '<>0');
        if RecLKitSalesLine.FINDSET() then
            repeat
                DecPAmount += RecLKitSalesLine."Remaining Quantity";
            until RecLKitSalesLine.NEXT() = 0;
    end;
    //Codeunit 7171
    procedure FctLookupPrepa(var RecPSalesLine: Record "Sales Line");
    var
        RecLSalesLine: Record "Sales Line";
        FrmLSalesLines: Page "Sales Lines";
    begin
        CLEAR(FrmLSalesLines);
        RecLSalesLine.SETRANGE(Type, RecPSalesLine.Type::Item);
        RecLSalesLine.SETRANGE("No.", RecPSalesLine."No.");
        //RecLSalesLine.SETRANGE("Build Kit",FALSE);
        RecLSalesLine.SETFILTER("Outstanding Quantity", '<>0');
        FrmLSalesLines.SETTABLEVIEW(RecLSalesLine);
        FrmLSalesLines.EDITABLE(false);
        FrmLSalesLines.RUNMODAL();
    end;
    //Codeunit 7171
    procedure FctCalcAffectedOnPurchOrder(var RecPSalesLine: Record "Sales Line") DecPAmount: Decimal;
    var
        RecLPurchLine: Record "Purchase Line";
    begin
        RecLPurchLine.SETRANGE(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SETRANGE("No.", RecPSalesLine."No.");
        RecLPurchLine.SETFILTER("Reserved Quantity", '<>0');
        DecPAmount := 0;
        if RecLPurchLine.FINDSET() then
            repeat
                RecLPurchLine.CALCFIELDS("Reserved Quantity");
                DecPAmount += RecLPurchLine."Reserved Quantity";
            until RecLPurchLine.NEXT() = 0;
    end;
    //Codeunit 7171
    procedure FctLookupAffectedOnPurchOrder(var RecPSalesLine: Record "Sales Line");
    var
        RecLPurchLine: Record "Purchase Line";
        FrmLPurchLines: Page "Purchase Lines";
    begin
        CLEAR(FrmLPurchLines);
        RecLPurchLine.SETRANGE(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SETRANGE("No.", RecPSalesLine."No.");
        RecLPurchLine.SETFILTER("Reserved Quantity", '<>0');
        FrmLPurchLines.SETTABLEVIEW(RecLPurchLine);
        FrmLPurchLines.EDITABLE(false);
        FrmLPurchLines.RUNMODAL();
    end;
    //Codeunit 7171
    procedure FctCalcNoAffectedOnPurchOrder(var RecPSalesLine: Record "Sales Line") DecPAmount: Decimal;
    var
        RecLPurchLine: Record "Purchase Line";
    begin
        RecLPurchLine.SETRANGE(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SETRANGE("No.", RecPSalesLine."No.");
        RecLPurchLine.SETFILTER("Reserved Quantity", '<>0');
        DecPAmount := 0;
        if RecLPurchLine.FINDSET() then
            repeat
                RecLPurchLine.CALCFIELDS("Reserved Quantity");
                DecPAmount += RecLPurchLine."Outstanding Quantity" - RecLPurchLine."Reserved Quantity";
            until RecLPurchLine.NEXT() = 0;
    end;
    //Codeunit 7171
    procedure FctLookupNoAffectedOnPurchOrd(var RecPSalesLine: Record "Sales Line");
    var
        RecLPurchLine: Record "Purchase Line";
        FrmLPurchLines: Page "Purchase Lines";
        OptGProcess: enum "Option Process";
    begin
        CLEAR(FrmLPurchLines);
        RecLPurchLine.SETRANGE(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SETRANGE("No.", RecPSalesLine."No.");
        RecLPurchLine.SETFILTER("Outstanding Quantity", '<>0');
        FrmLPurchLines.SETTABLEVIEW(RecLPurchLine);
        FrmLPurchLines.EDITABLE(false);
        FrmLPurchLines.FctGetParm(RecPSalesLine."No.", OptGProcess::NoAffected);
        FrmLPurchLines.RUNMODAL();
    end;
    //Codeunit 7171
    procedure FctCalcAvailability(var SalesLine: Record "Sales Line"): Decimal;
    var
        Item: Record Item;
        SalesInfoPaneManagement: Codeunit "Sales Info-Pane Management";
        AvailabilityDate: Date;
    begin
        if SalesInfoPaneManagement.GetItem(SalesLine) then begin
            if SalesLine."Shipment Date" <> 0D then
                AvailabilityDate := SalesLine."Shipment Date"
            else
                AvailabilityDate := WORKDATE();

            Item.RESET();
            Item.SETRANGE("Date Filter", 0D, AvailabilityDate);
            Item.SETRANGE("Variant Filter", SalesLine."Variant Code");
            Item.SETRANGE("Location Filter", SalesLine."Location Code");
            Item.SETRANGE("Drop Shipment Filter", false);
            Item.CALCFIELDS(Inventory);
            exit(Item.Inventory);
        end;
    end;
    //Codeunit 7171
    procedure FctCalcDispo(var RecPSalesLine: Record "Sales Line") DecPAmount: Decimal;
    var
        RecLItem: Record Item;
    begin
        DecPAmount := 0;
        //>>FED_20090415:PA 15/04/2009
        if RecPSalesLine.Type = RecPSalesLine.Type::Item then
            if RecLItem.GET(RecPSalesLine."No.") then begin
                RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Assembly Order", "Reserved Qty. on Purch. Orders");
                DecPAmount := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + RecLItem."Qty. on Assembly Order") + RecLItem."Reserved Qty. on Purch. Orders";
            end;
        //<<FED_20090415:PA 15/04/2009
    end;



}
