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



}
