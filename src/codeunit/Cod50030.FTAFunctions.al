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
        PurchLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        RecLReportUser: Record "Report Email By User";
        ReportSelection: Record "Report Selections";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchCalcDisc: Codeunit "Purch.-Calc.Discount";
        AttachmentFilePath: Text[250];
    begin
        PurchHeader.SetRange("No.", PurchHeader."No.");
        PurchSetup.Get();
        SalesSetup.Get();
        if PurchSetup."Calc. Inv. Discount" then begin
            PurchLine.Reset();
            PurchLine.SetRange("Document Type", PurchHeader."Document Type");
            PurchLine.SetRange("Document No.", PurchHeader."No.");
            PurchLine.findFirst();
            PurchCalcDisc.Run(PurchLine);
            PurchHeader.Get(PurchHeader."Document Type", PurchHeader."No.");
            Commit();
        end;

        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::Quote:
                ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Quote");
            PurchHeader."Document Type"::"Blanket Order":
                ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Blanket");
            PurchHeader."Document Type"::Order:
                ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Order");
            PurchHeader."Document Type"::"Return Order":
                ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Return");
            else
                exit;
        end;
        ReportSelection.SetFilter("Report ID", '<>0');
        ReportSelection.findFirst();
        repeat
            if not RecLReportUser.Get(UserId, ReportSelection."Report ID") then begin
                RecLReportUser.Init();
                RecLReportUser.UserId := UserId();
                RecLReportUser."Report ID" := ReportSelection."Report ID";
                RecLReportUser.Insert();
            end;
            RecLReportUser.Email := SendAsEmail;
            RecLReportUser.Modify();
            Commit();
            if SendAsEmail then begin
                AttachmentFilePath := SavePurchHeaderReportAsPdf(PurchHeader, ReportSelection."Report ID", ReportSelection."Report Caption");
                EmailFileFromPurchHeader(PurchHeader, AttachmentFilePath);

            end else
                REPORT.RunModal(ReportSelection."Report ID", true, false, PurchHeader)
        until ReportSelection.Next() = 0;
    end;
    //<<Migration Codeunit 229 2/1/2024>>
    //todo: verifier 
    procedure SavePurchHeaderReportAsPdf(var PurchHeader: Record "Purchase Header"; ReportId: Integer; ReportName: Text[250]): Text[250];
    var
        FileManagement: Codeunit "File Management";
        ReportParameters: Text;
        OStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        Filename: Text;
    begin
        ReportParameters := Report.RunRequestPage(ReportId);
        Filename := Format(ReportId) + '_' + ReportName + '.pdf';
        REPORT.SaveAs(ReportId, ReportParameters, ReportFormat::Pdf, OStream);
        FileManagement.BLOBExport(TempBlob, Filename, true);

        exit(Filename);
    end;
    //<<Migration Codeunit 260 2/1/2024>>
    procedure EmailFileFromPurchHeader(PurchHeader: Record "Purchase Header"; AttachmentFilePath: Text[250]);
    begin
        EmailFileVendor(AttachmentFilePath,
          PurchHeader."No.",
          PurchHeader."Buy-from Vendor No.",
          PurchHeader."Buy-from Vendor Name",
          Format(PurchHeader."Document Type"));
    end;
    //<<Migration Codeunit 260 2/1/2024>>
    procedure EmailFileVendor(AttachmentFilePath: Text[250]; PostedDocNo: Code[20]; SendEmaillToCustNo: Code[20]; SendEmaillToCustName: Text[50]; EmailDocName: Text[50]);
    var
        TempEmailItem: Record "Email Item" temporary;
        DocMailing: Codeunit "Document-Mailing";
        AttachmentFileName: Text[250];
        EmailSubjectCapTxt: Label '@@@="%1 = Customer Name. %2 = Document Type %3 = Invoice No.";%1 - %2 %3';
        ReportAsPdfFileNameMsg2: Label '@@@="%1 = Document Type %2 = Invoice No.";Purchases %1 %2.pdf';
    begin
        AttachmentFileName := StrSubstNo(ReportAsPdfFileNameMsg2, EmailDocName, PostedDocNo);

        with TempEmailItem do begin
            "Send to" := DocMailing.GetToAddressFromCustomer(SendEmaillToCustNo);
            Subject := CopyStr(
                StrSubstNo(
                  EmailSubjectCapTxt, SendEmaillToCustName, EmailDocName, PostedDocNo), 1,
                MaxStrLen(Subject));
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
        if Vendor.Get(BuyFromVendorNo) then
            ToAddress := Vendor."E-Mail";
        exit(ToAddress);
    end;
    //<<Migration Codeunit 260 2/1/2024>>
    procedure EmailFileFromQO(AttachmentFilePath: Text[250]; PostedDocNo: Code[20]; SendEmaillToVendNo: Code[20]; SendEmaillToVendName: Text[50]; EmailDocName: Text[50]; EmailSendTo: Text[50]; EmailSubject: Text[100]);
    var
        TempEmailItem: Record "Email Item" temporary;
        AttachmentFileName: Text[250];
        EmailSubjectCapTxt: Label '%1 - %2 %3', Comment = '%1 = Customer Name. %2 = Document Type %3 = Invoice No.';
        ReportAsPdfFileNameMsg: Label '@@@="%1 = Document Type %2 = Invoice No."; Sales %1 %2.pdf';
    begin
        AttachmentFileName := StrSubstNo(ReportAsPdfFileNameMsg, EmailDocName, PostedDocNo);

        with TempEmailItem do begin
            "Send to" := EmailSendTo;
            if EmailSubject = '' then
                Subject :=
                  CopyStr(
                      StrSubstNo(
                        EmailSubjectCapTxt, SendEmaillToVendName, EmailDocName, PostedDocNo), 1,
                      MaxStrLen(Subject))
            else
                Subject := EmailSubject;
            "Attachment File Path" := AttachmentFilePath;
            "Attachment Name" := AttachmentFileName;
            Send(false);
        end;
    end;
    //<<Migration codeunit 0099000831>>
    procedure CloseReservEntry2(ReservEntry: Record "Reservation Entry");
    var
        ReservEntry3: Record "Reservation Entry";
        TempSurplusEntry: Record "Reservation Entry" temporary;
        ResEngineMgt: Codeunit "Reservation Engine Mgt.";
        LastEntryNo: Integer;
    begin
        ReservEntry.TestField("Reservation Status", ReservEntry."Reservation Status"::Reservation);

        ReservEntry3.LockTable();
        if ReservEntry3.FindLast() then
            LastEntryNo := ReservEntry3."Entry No.";

        ReservEntry3.Get(ReservEntry."Entry No.", not ReservEntry.Positive);
        if (ReservEntry3."Lot No." <> '') or (ReservEntry3."Serial No." <> '') or
           (ReservEntry."Lot No." <> '') or (ReservEntry."Serial No." <> '') then begin
            ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
            ReservEntry3."Reservation Status" := ReservEntry3."Reservation Status"::Surplus;
            ReservEntry.Modify();
            ReservEntry3.Delete();
            ReservEntry3."Entry No." := LastEntryNo + 1;
            ReservEntry3.Insert();
            TempSurplusEntry.DeleteALL();
            UpdateTempSurplusEntry(ReservEntry);
            UpdateTempSurplusEntry(ReservEntry3);
            ResEngineMgt.UpdateOrderTracking(TempSurplusEntry);
        end else
            ResEngineMgt.CloseReservEntry(ReservEntry, true, false);
    end;
    //<<Duplication Procedure UpdateTempSurplusEntry from codeunit 260>> 
    procedure UpdateTempSurplusEntry(var ReservEntry: Record "Reservation Entry")
    var
        TempSurplusEntry: Record "Reservation Entry" temporary;
    begin
        if ReservEntry."Reservation Status" <> ReservEntry."Reservation Status"::Surplus then
            exit;
        if ReservEntry."Quantity (Base)" = 0 then
            exit;
        TempSurplusEntry := ReservEntry;
        if not TempSurplusEntry.Insert() then
            TempSurplusEntry.Modify();
    end;
    //<<Migration codeunit 5701>> 

    procedure ExplodeItemAssemblySubst(var AssemblyLine: Record "Assembly Line"; OnlyAvailableQty: Boolean; RemplaceOk: Boolean);
    var
        TempAssemblyLine: Record "Assembly Line" temporary;
        ToAssemblyLine: Record "Assembly Line";
        Item: Record Item;
        ItemSubstitution: Record "Item Substitution";
        TempItemSubstitution: Record "Item Substitution" temporary;
        AutoReserveOk: Boolean;
        DeleteOriginalAssLineOk: Boolean;
        ErrorOk: Boolean;
        OnlyOneSubstOk: Boolean;
        OldSalesUOM: Code[10];
        SaveLocation: Code[10];
        SaveVariantCode: Code[10];
        SaveItemNo: Code[20];
        ReqBaseQty: Decimal;
        SaveQty: Decimal;
        LineSpacing: Integer;
        NextLineNo: Integer;
        NoOfItemSubsLines: Integer;
        Text002: Label 'An Item Substitution does not exist for Item No. ''%1''';
        Text003: Label 'There is not enough space to explode the Substitution.';
    begin
        TempItemSubstitution.Reset();
        TempItemSubstitution.DeleteALL();
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

            TestField(Type, Type::Item);
            TestField("Consumed Quantity", 0);
            CalcFields("Reserved Qty. (Base)");
            TestField("Reserved Qty. (Base)", 0);
            ReqBaseQty := 0;
            ReqBaseQty := "Quantity (Base)";
            SaveItemNo := "No.";
            SaveVariantCode := "Variant Code";
            Item.Get(AssemblyLine."No.");
            Item.SetFilter("Location Filter", "Location Code");
            Item.SetFilter("Variant Filter", "Variant Code");
            Item.SetRange("Date Filter", 0D, "Due Date");
            Item.CalcFields(Inventory);
            Item.CalcFields("Qty. on Sales Order");
            Item.CalcFields("Qty. on Service Order");
            OldSalesUOM := Item."Sales Unit of Measure";

            NoOfItemSubsLines := 0;
            ItemSubstitution.Reset();
            ItemSubstitution.SetRange(Type, ItemSubstitution.Type::Item);
            ItemSubstitution.SetRange("No.", AssemblyLine."No.");
            ItemSubstitution.SetRange("Variant Code", "Variant Code");
            ItemSubstitution.SetRange("Location Filter", "Location Code");
            if ItemSubstitution.findFirst() then
                repeat
                    TempItemSubstitution.Init();
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
                        Item.Get(ItemSubstitution."Substitute No.");
                        Item.CalcFields(Inventory);
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
                        TempItemSubstitution.Insert();
                until ItemSubstitution.Next() = 0;

            NoOfItemSubsLines := TempItemSubstitution.Count;
            if NoOfItemSubsLines = 0 then
                if ErrorOk then
                    Error(Text002, "No.");

            ToAssemblyLine.Reset();
            ToAssemblyLine.SetRange("Document Type", "Document Type");
            ToAssemblyLine.SetRange("Document No.", "Document No.");
            ToAssemblyLine.Get("Document Type", "Document No.", "Line No.");
            LineSpacing := 10000;
            if ToAssemblyLine.Find('>') then begin
                LineSpacing := (ToAssemblyLine."Line No." - "Line No.") div (1 + NoOfItemSubsLines);
                if LineSpacing = 0 then
                    Error(Text003);
            end;

            NextLineNo := "Line No.";
        end;

        TempItemSubstitution.Reset();
        if TempItemSubstitution.findFirst() then begin
            repeat
                TempAssemblyLine.Init();
                TempAssemblyLine := AssemblyLine;
                TempAssemblyLine."Document Type" := AssemblyLine."Document Type";
                TempAssemblyLine."Document No." := AssemblyLine."Document No.";
                NextLineNo := NextLineNo + LineSpacing;
                TempAssemblyLine."Line No." := NextLineNo;
                TempAssemblyLine.Insert(true);

                TempAssemblyLine."No." := TempItemSubstitution."Substitute No.";
                TempAssemblyLine."Variant Code" := TempItemSubstitution."Substitute Variant Code";
                SaveQty := TempAssemblyLine.Quantity;
                SaveLocation := TempAssemblyLine."Location Code";

                TempAssemblyLine.Quantity := 0;
                TempAssemblyLine.Validate("No.", TempItemSubstitution."Substitute No.");
                TempAssemblyLine.Validate("Variant Code", TempItemSubstitution."Substitute Variant Code");
                TempAssemblyLine."Originally Ordered No." := SaveItemNo;
                TempAssemblyLine."Originally Ordered Var. Code" := SaveVariantCode;
                TempAssemblyLine."Location Code" := SaveLocation;
                TempAssemblyLine.Validate(Quantity, SaveQty);
                TempAssemblyLine.Validate("Unit of Measure Code", OldSalesUOM);
                TempAssemblyLine.Modify(true);
            until OnlyOneSubstOk or (TempItemSubstitution.Next() = 0);

            TempAssemblyLine.Reset();
            if TempAssemblyLine.FindSet() then begin
                repeat
                    ToAssemblyLine.Init();
                    ToAssemblyLine := TempAssemblyLine;
                    ToAssemblyLine.Insert();
                    if AutoReserveOk then
                        ToAssemblyLine.FctAutoReserveFTA();

                until TempAssemblyLine.Next() = 0;
                if DeleteOriginalAssLineOk then
                    AssemblyLine.Delete(true);
            end;
        end else
            if ErrorOk then
                Error(Text002, AssemblyLine."No.");
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
        //CodLPostingGroup: Code[20];
        CstL001: Label 'Posting group values not corresponding between selected entries.';
    begin
        //Check if all entries have same posting group
        if RecOldCustLedgEntry."Customer Posting Group" <> RecNewCVLedgEntryBuf."CV Posting Group" then
            Error(CstL001);
    end;//Codeunit 12

    //Codeunit 12
    procedure CheckHeaderNo(): Boolean;
    var
        GenJnlLine: Record "Gen. Journal Line";
        PaymentLine: Record "Payment Line";
    begin
        PaymentLine.SetRange("No.", GenJnlLine."Document No.");
        if PaymentLine.findFirst() then
            exit(true)
        else
            exit(false);

    end;

    procedure CheckVendPostGroup(RecNewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; RecOldVendLedgEntry: Record "Vendor Ledger Entry");
    var
        //CodLPostingGroup: Code[20];
        CstL001: Label 'Posting group values not corresponding between selected entries.';
    begin
        //Check if all entries have same posting group
        if RecOldVendLedgEntry."Vendor Posting Group" <> RecNewCVLedgEntryBuf."CV Posting Group" then
            Error(CstL001);
    end;//Codeunit 12

    procedure FctFromPaymentMgt(BooPPaymentMgt: Boolean);
    // var
    begin
        //     BooGPaymentMgt := BooPPaymentMgt;
    end;//Codeunit 12


    //CodeUnit 246
    procedure OnRunDisAssembly(var Rec: Record "Item Journal Line");
    var
        FromBOMComp: Record "BOM Component";
        Item: Record Item;
        ToItemJnlLine: Record "Item Journal Line";
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
            TestField("Item No.");
            CalcFields("Reserved Qty. (Base)");
            TestField("Reserved Qty. (Base)", 0);
            TestField("Entry Type", "Entry Type"::"Negative Adjmt.");
            FromBOMComp.SetRange("Parent Item No.", "Item No.");
            FromBOMComp.SetRange(Type, FromBOMComp.Type::Item);
            NoOfBOMComp := FromBOMComp.Count;
            if NoOfBOMComp = 0 then
                Error(
                  Text000,
                  "Item No.");

            Selection := STRMENU(Text003, 2);
            if Selection = 0 then
                exit;

            ToItemJnlLine.Reset();
            ToItemJnlLine.SetRange("Journal Template Name", "Journal Template Name");
            ToItemJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
            ToItemJnlLine.SetRange("Document No.", "Document No.");
            ToItemJnlLine.SetRange("Posting Date", "Posting Date");
            ToItemJnlLine.SetRange("Entry Type", "Entry Type");
            ToItemJnlLine := Rec;
            if ToItemJnlLine.Find('>') then begin
                LineSpacing := (ToItemJnlLine."Line No." - "Line No.") div (1 + NoOfBOMComp);
                if LineSpacing = 0 then
                    Error(Text002);
            end else
                LineSpacing := 10000;

            ToItemJnlLine := Rec;
            FromBOMComp.SetFilter("No.", '<>%1', '');
            if FromBOMComp.findFirst() then
                repeat
                    Item.Get(FromBOMComp."No.");
                    ToItemJnlLine."Line No." := 0;
                    ToItemJnlLine."Entry Type" := "Entry Type"::"Positive Adjmt.";
                    ToItemJnlLine."Item No." := FromBOMComp."No.";
                    ToItemJnlLine."Variant Code" := FromBOMComp."Variant Code";
                    ToItemJnlLine."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToItemJnlLine."Qty. per Unit of Measure" :=
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                    ToItemJnlLine.Quantity := Round("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001);
                    if ToItemJnlLine.Quantity > 0 then
                        if ItemCheckAvail.ItemJnlCheckLine(ToItemJnlLine) then
                            ItemCheckAvail.RaiseUpdateInterruptedError();
                until FromBOMComp.Next() = 0;

            ToItemJnlLine := Rec;
            //ToItemJnlLine.Init;
            //ToItemJnlLine.Description := Description;
            ToItemJnlLine.Modify();

            FromBOMComp.Reset();
            FromBOMComp.SetRange("Parent Item No.", "Item No.");
            FromBOMComp.SetRange(Type, FromBOMComp.Type::Item);
            FromBOMComp.FindSet();
            NextLineNo := "Line No.";

            repeat
                ToItemJnlLine.Init();
                ToItemJnlLine."Journal Template Name" := "Journal Template Name";
                ToItemJnlLine."Document No." := "Document No.";
                ToItemJnlLine."Document Date" := "Document Date";
                ToItemJnlLine."Posting Date" := "Posting Date";
                ToItemJnlLine."External Document No." := "External Document No.";
                ToItemJnlLine.Validate("Entry Type", "Entry Type"::"Positive Adjmt.");
                ToItemJnlLine."Location Code" := "Location Code";
                NextLineNo := NextLineNo + LineSpacing;
                ToItemJnlLine."Line No." := NextLineNo;
                ToItemJnlLine."Drop Shipment" := "Drop Shipment";
                ToItemJnlLine."Source Code" := "Source Code";
                ToItemJnlLine."Reason Code" := "Reason Code";
                ToItemJnlLine.Validate("Item No.", FromBOMComp."No.");
                ToItemJnlLine.Validate("Variant Code", FromBOMComp."Variant Code");
                ToItemJnlLine.Validate("Unit of Measure Code", FromBOMComp."Unit of Measure Code");
                ToItemJnlLine.Validate(
                  Quantity,
                  Round("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001));
                ToItemJnlLine.Description := FromBOMComp.Description;
                ToItemJnlLine.Insert();

                if Selection = 1 then begin
                    ToItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    ToItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    ToItemJnlLine."Dimension Set ID" := "Dimension Set ID";
                    ToItemJnlLine.Modify();
                end;
            until FromBOMComp.Next() = 0;
        end;

        //<< MIGR NAV 2015 - ADAPATATION DEMONTAGE
    end;

    //CodeUnit 246
    procedure OnRunAssembly(var Rec: Record "Item Journal Line");
    var

        FromBOMComp: Record "BOM Component";
        Item: Record Item;
        ToItemJnlLine: Record "Item Journal Line";
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
            TestField("Item No.");
            CalcFields("Reserved Qty. (Base)");
            TestField("Reserved Qty. (Base)", 0);
            TestField("Entry Type", "Entry Type"::"Positive Adjmt.");
            FromBOMComp.SetRange("Parent Item No.", "Item No.");
            FromBOMComp.SetRange(Type, FromBOMComp.Type::Item);
            NoOfBOMComp := FromBOMComp.Count;
            if NoOfBOMComp = 0 then
                Error(
                  Text000,
                  "Item No.");

            Selection := STRMENU(Text003, 2);
            if Selection = 0 then
                exit;

            ToItemJnlLine.Reset();
            ToItemJnlLine.SetRange("Journal Template Name", "Journal Template Name");
            ToItemJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
            ToItemJnlLine.SetRange("Document No.", "Document No.");
            ToItemJnlLine.SetRange("Posting Date", "Posting Date");
            ToItemJnlLine.SetRange("Entry Type", "Entry Type");
            ToItemJnlLine := Rec;
            if ToItemJnlLine.Find('>') then begin
                LineSpacing := (ToItemJnlLine."Line No." - "Line No.") div (1 + NoOfBOMComp);
                if LineSpacing = 0 then
                    Error(Text002);
            end else
                LineSpacing := 10000;

            ToItemJnlLine := Rec;
            FromBOMComp.SetFilter("No.", '<>%1', '');
            if FromBOMComp.findFirst() then
                repeat
                    Item.Get(FromBOMComp."No.");
                    ToItemJnlLine."Line No." := 0;
                    ToItemJnlLine."Entry Type" := "Entry Type"::"Negative Adjmt.";
                    ToItemJnlLine."Item No." := FromBOMComp."No.";
                    ToItemJnlLine."Variant Code" := FromBOMComp."Variant Code";
                    ToItemJnlLine."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToItemJnlLine."Qty. per Unit of Measure" :=
                      UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                    ToItemJnlLine.Quantity := Round("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001);
                    if ToItemJnlLine.Quantity > 0 then
                        if ItemCheckAvail.ItemJnlCheckLine(ToItemJnlLine) then
                            ItemCheckAvail.RaiseUpdateInterruptedError();
                until FromBOMComp.Next() = 0;

            ToItemJnlLine := Rec;
            //ToItemJnlLine.Init;
            //ToItemJnlLine.Description := Description;
            ToItemJnlLine.Modify();

            FromBOMComp.Reset();
            FromBOMComp.SetRange("Parent Item No.", "Item No.");
            FromBOMComp.SetRange(Type, FromBOMComp.Type::Item);
            FromBOMComp.FindSet();
            NextLineNo := "Line No.";

            repeat
                ToItemJnlLine.Init();
                ToItemJnlLine."Journal Template Name" := "Journal Template Name";
                ToItemJnlLine."Document No." := "Document No.";
                ToItemJnlLine."Document Date" := "Document Date";
                ToItemJnlLine."Posting Date" := "Posting Date";
                ToItemJnlLine."External Document No." := "External Document No.";
                ToItemJnlLine.Validate("Entry Type", "Entry Type"::"Negative Adjmt.");
                ToItemJnlLine."Location Code" := "Location Code";
                NextLineNo := NextLineNo + LineSpacing;
                ToItemJnlLine."Line No." := NextLineNo;
                ToItemJnlLine."Drop Shipment" := "Drop Shipment";
                ToItemJnlLine."Source Code" := "Source Code";
                ToItemJnlLine."Reason Code" := "Reason Code";
                ToItemJnlLine.Validate("Item No.", FromBOMComp."No.");
                ToItemJnlLine.Validate("Variant Code", FromBOMComp."Variant Code");
                ToItemJnlLine.Validate("Unit of Measure Code", FromBOMComp."Unit of Measure Code");
                ToItemJnlLine.Validate(
                  Quantity,
                  Round("Quantity (Base)" * FromBOMComp."Quantity per", 0.00001));
                ToItemJnlLine.Description := FromBOMComp.Description;
                ToItemJnlLine.Insert();

                if Selection = 1 then begin
                    ToItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    ToItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    ToItemJnlLine."Dimension Set ID" := "Dimension Set ID";
                    ToItemJnlLine.Modify();
                end;
            until FromBOMComp.Next() = 0;
        end;

        //<< MIGR NAV 2015 - ADAPATATION DEMONTAGE
    end;






    // codeunit 905
    procedure FctRefreshTempSubKitSalesFTA(var AsmLine: Record "Assembly Line"; AutoReserveOk: Boolean);
    var
        AssemblyHeader: Record "Assembly Header";
        RecLAsmLine: Record "Assembly Line";
        TempAssemblyLine: Record "Assembly Line" temporary;
        ToAssemblyLine: Record "Assembly Line";
        FromBOMComp: Record "BOM Component";
        RecLReservEntry: Record "Reservation Entry";
        AssemblyLineMgt: Codeunit "Assembly Line Management";
        CduLReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        BooLEndLoop: Boolean;
        DueDateBeforeWorkDate: Boolean;
        NewLineDueDate: Date;
        IntLAfterCompLineNo: Integer;
        LineSpacing: Integer;
        NextLineNo: Integer;
        NoOfBOMCompLines: Integer;
        Text006: Label 'Item %1 is not a BOM.';
        Text007: Label 'There is not enough space to explode the BOM.';
    begin
        //>>MIGR NAV 2015

        if AsmLine."Kit Action" = AsmLine."Kit Action"::" " then
            exit;

        with AsmLine do
            if AsmLine."Kit Action" = AsmLine."Kit Action"::Disassembly then begin
                TestField(Type, Type::Item);
                //TestField("Consumed Quantity",0);
                //CalcFields("Reserved Qty. (Base)");
                //TestField("Reserved Qty. (Base)",0);

                AssemblyHeader.Get("Document Type", "Document No.");
                FromBOMComp.SetRange("Parent Item No.", "No.");
                NoOfBOMCompLines := FromBOMComp.Count;
                if NoOfBOMCompLines = 0 then
                    Error(Text006, "No.");

                ToAssemblyLine.Reset();
                ToAssemblyLine.SetRange("Document Type", "Document Type");
                ToAssemblyLine.SetRange("Document No.", "Document No.");
                ToAssemblyLine := AsmLine;
                LineSpacing := 10000;
                if ToAssemblyLine.Find('>') then begin
                    LineSpacing := (ToAssemblyLine."Line No." - "Line No.") div (1 + NoOfBOMCompLines);
                    if LineSpacing = 0 then
                        Error(Text007);
                end;

                TempAssemblyLine.Init();
                TempAssemblyLine := AsmLine;
                TempAssemblyLine."x Quantity per" := AsmLine."Quantity per";
                //TempAssemblyLine."x Quantity per (Base)" := AsmLine."Quantity per (Base)";
                //TempAssemblyLine."x Extended Quantity" := AsmLine."Extended Quantity";
                //TempAssemblyLine."x Extended Quantity (Base)" := AsmLine."Extended Quantity (Base)";
                TempAssemblyLine."Quantity per" := 0;
                TempAssemblyLine.Validate(Quantity, 0);
                //TempAssemblyLine."Extended Quantity" := 0;
                //TempAssemblyLine."Extended Quantity (Base)" := 0;
                TempAssemblyLine.Validate("Remaining Quantity (Base)", 0);
                TempAssemblyLine.Validate("Remaining Quantity", 0);
                TempAssemblyLine."x Outstanding Quantity" := AsmLine."Remaining Quantity";
                TempAssemblyLine."x Outstanding Qty. (Base)" := AsmLine."Remaining Quantity (Base)";
                TempAssemblyLine.Insert();

                RecLReservEntry.SetRange("Reservation Status", RecLReservEntry."Reservation Status"::Reservation);
                RecLReservEntry.SetRange("Source Type", DATABASE::"Assembly Line");
                RecLReservEntry.SetRange("Source ID", AsmLine."Document No.");
                RecLReservEntry.SetRange("Source Prod. Order Line", AsmLine."Line No.");
                RecLReservEntry.SetRange("Source Ref. No.", AsmLine."Line No.");
                //Delete reservation
                if RecLReservEntry.findFirst() then
                    repeat
                        CloseReservEntry2(RecLReservEntry);
                    until RecLReservEntry.Next() = 0;


                NextLineNo := "Line No.";
                FromBOMComp.FindSet();
                repeat
                    TempAssemblyLine.Init();
                    TempAssemblyLine."Document Type" := "Document Type";
                    TempAssemblyLine."Document No." := "Document No.";
                    NextLineNo := NextLineNo + LineSpacing;
                    TempAssemblyLine."Line No." := NextLineNo;
                    TempAssemblyLine.Insert(true);
                    AssemblyLineMgt.AddBOMLine(AssemblyHeader, TempAssemblyLine, true, FromBOMComp, false, "Qty. per Unit of Measure");//TODO Verif
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

                    TempAssemblyLine.Modify(true);
                until FromBOMComp.Next() = 0;

                TempAssemblyLine.Reset();
                TempAssemblyLine.FindSet();
                ToAssemblyLine := TempAssemblyLine;
                ToAssemblyLine.Modify();
                // FTA1.02b
                AsmLine := ToAssemblyLine;

                while TempAssemblyLine.Next() <> 0 do begin
                    ToAssemblyLine := TempAssemblyLine;
                    ToAssemblyLine.Insert();
                    if ToAssemblyLine."Due Date" < WorkDate() then begin
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
                TempAssemblyLine.Init();
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
                TempAssemblyLine.Insert();

                TempAssemblyLine.Reset();
                TempAssemblyLine.FindSet();
                ToAssemblyLine := TempAssemblyLine;
                ToAssemblyLine.Modify();

                IntLAfterCompLineNo := 0;
                //Deletion of enreg
                BooLEndLoop := false;
                RecLAsmLine.SetRange("Document No.", AsmLine."Document No.");
                //>>TI298979
                RecLAsmLine.SetRange("Document Type", AsmLine."Document Type");
                //<<TI298979
                //RecLAsmLine.SetRange("Document Line No.","Document line no.");
                RecLAsmLine.SetFilter("Line No.", '>%1', AsmLine."Line No.");
                if RecLAsmLine.FindSet() then
                    repeat
                        if RecLAsmLine."Level No." > AsmLine."Level No." then
                            RecLAsmLine.Delete(true)
                        else begin
                            IntLAfterCompLineNo := RecLAsmLine."Line No.";
                            BooLEndLoop := true;
                        end;
                    until (RecLAsmLine.Next() = 0) or (BooLEndLoop = true);
            end;
        //<<MIGR NAV 2015
    end;

    //Codeunit 905 Used in Page 50003
    procedure FctCountKitDisposalToBuild(var TmpAssemblyHeader: Record "Assembly Header"; var TempAssemblyLine: Record "Assembly Line" temporary): Decimal;
    var
        TempAssemblyLine2: Record "Assembly Line" temporary;
        AssemblySetup: Record "Assembly Setup";
        Item: Record Item;
        AssemblyLineManagement: Codeunit "Assembly Line Management";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        AssemblyAvailability: Page "Assembly Availability";
        QtyAvailTooLow: Boolean;
        EarliestAvailableDateX: Date;
        GrossRequirement: Decimal;
        Inventory: Decimal;
        QtyAvailToMake: Decimal;
        ReservedReceipts: Decimal;
        ReservedRequirement: Decimal;
        ScheduledReceipts: Decimal;
    begin
        //>>MIGR NAV 2015
        AssemblySetup.Get();
        if not GUIALLOWED or
           TempAssemblyLine.IsEmpty or
           (not AssemblySetup."Stockout Warning") //or not AssemblyLineManagement.GetWarningMode
        then
            exit(0);
        TmpAssemblyHeader.TestField("Item No.");
        Item.Get(TmpAssemblyHeader."Item No.");

        ItemCheckAvail.AsmOrderCalculate(TmpAssemblyHeader, Inventory,
          GrossRequirement, ReservedRequirement, ScheduledReceipts, ReservedReceipts);
        TempAssemblyLine2.Copy(TempAssemblyLine, true);
        AvailToPromise(TmpAssemblyHeader, TempAssemblyLine2, QtyAvailToMake, EarliestAvailableDateX);
        exit(QtyAvailToMake);
        //<<MIGR NAV 2015
    end;
    // Duplicate
    //***********************************************************
    procedure AvailToPromise(AsmHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line"; var OrderAbleToAssemble: Decimal; var EarliestDueDate: Date)
    var
        EarliestStartingDate: Date;
        LineAvailabilityDate: Date;
        LineStartingDate: Date;
        LineAbleToAssemble: Decimal;
    begin
        SetLinkToItemLines(AsmHeader, AssemblyLine);
        AssemblyLine.SetFilter("No.", '<>%1', '');
        AssemblyLine.SetFilter("Quantity per", '<>%1', 0);
        OrderAbleToAssemble := AsmHeader."Remaining Quantity";
        EarliestStartingDate := 0D;
        if AssemblyLine.FindSet() then
            repeat
                LineAbleToAssemble := CalcAvailToAssemble(AssemblyLine, AsmHeader, LineAvailabilityDate);

                if LineAbleToAssemble < OrderAbleToAssemble then
                    OrderAbleToAssemble := LineAbleToAssemble;

                if LineAvailabilityDate > 0D then begin
                    LineStartingDate := CalcDate(AssemblyLine."Lead-Time Offset", LineAvailabilityDate);
                    if LineStartingDate > EarliestStartingDate then
                        EarliestStartingDate := LineStartingDate; // latest of all line starting dates
                end;
            until AssemblyLine.Next() = 0;

        EarliestDueDate := CalcEarliestDueDate(AsmHeader, EarliestStartingDate);
    end;

    procedure SetLinkToItemLines(AsmHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line")
    begin
        SetLinkToLines(AsmHeader, AssemblyLine);
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
    end;

    procedure SetLinkToLines(AsmHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line")
    begin
        AssemblyLine.SetRange("Document Type", AsmHeader."Document Type");
        AssemblyLine.SetRange("Document No.", AsmHeader."No.");
    end;

    procedure CalcAvailToAssemble(AssemblyLine: Record "Assembly Line"; AsmHeader: Record "Assembly Header"; var LineAvailabilityDate: Date) LineAbleToAssemble: Decimal
    var
        Item: Record Item;
        ExpectedInventory: Decimal;
        GrossRequirement: Decimal;
        LineInventory: Decimal;
        ScheduledRcpt: Decimal;
    begin
        AssemblyLine.CalcAvailToAssemble(
          AsmHeader, Item, GrossRequirement, ScheduledRcpt, ExpectedInventory, LineInventory,
          LineAvailabilityDate, LineAbleToAssemble);
    end;

    procedure CalcEarliestDueDate(AsmHeader: Record "Assembly Header"; EarliestStartingDate: Date) EarliestDueDate: Date
    var
        ReqLine: Record "Requisition Line";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        EarliestEndingDate: Date;
    begin
        with AsmHeader do begin
            EarliestDueDate := 0D;
            if EarliestStartingDate > 0D then begin
                EarliestEndingDate := // earliest starting date + lead time calculation
                  LeadTimeMgt.PlannedEndingDate("Item No.", "Location Code", "Variant Code",
                    '', LeadTimeMgt.ManufacturingLeadTime("Item No.", "Location Code", "Variant Code"),
                    ReqLine."Ref. Order Type"::Assembly, EarliestStartingDate);
                EarliestDueDate := // earliest ending date + (default) safety lead time
                  LeadTimeMgt.PlannedDueDate("Item No.", "Location Code", "Variant Code",
                    EarliestEndingDate, '', ReqLine."Ref. Order Type"::Assembly);
            end;
        end;
    end;
    //***********************************************************

    procedure SetAutoReserve();
    begin
        //>> FTA1.02
        // AutoReserveOk := true;
    end;


    //Codeunit 7000
    procedure Fct_GetDiscforAll(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line");
    var
        Item: Record Item;
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
        RecLSalesLineDisc: Record "Sales Line Discount";//"Price List Line";//
        BooLRecOK: Boolean;
        DatLWorkDate: Date;
    begin
        //>>FED_20090415:PA 15/04/2009

        if (SalesLine.Type <> SalesLine.Type::Item) or
            (not SalesLine."Allow Line Disc.") or
            (SalesLine."Item Base" = SalesLine."Item Base"::Transitory) then
            exit;
        Item.Get(SalesLine."No.");
        if (Item."Inventory Value Zero") then
            exit;

        if SalesLine."Line Discount %" = 0 then begin
            RecLSalesReceivablesSetup.Get();
            if RecLSalesReceivablesSetup."Discount All Item" <> '' then begin
                if SalesHeader."Document Type" in [SalesLine."Document Type"::Invoice, SalesLine."Document Type"::"Credit Memo"] then
                    DatLWorkDate := SalesHeader."Posting Date"
                else
                    DatLWorkDate := SalesHeader."Order Date";
                RecLSalesLineDisc.SetRange(Type, RecLSalesLineDisc.Type::"Item Disc. Group");
                RecLSalesLineDisc.SetRange("Sales Type", RecLSalesLineDisc."Sales Type"::Customer);
                RecLSalesLineDisc.SetRange("Sales Code", SalesLine."Sell-to Customer No.");
                RecLSalesLineDisc.SetRange(Code, RecLSalesReceivablesSetup."Discount All Item");
                RecLSalesLineDisc.SetFilter("Minimum Quantity", '<=%1', SalesLine.Quantity);
                if RecLSalesLineDisc.FindSet() then
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
                    until RecLSalesLineDisc.Next() = 0;
            end;
        end;
        //<<FED_20090415:PA 15/04/2009
    end;



    //Codeunit 7171
    procedure FctCalcPrepa(var RecPSalesLine: Record "Sales Line") DecPAmount: Decimal;
    var
        RecLKitSalesLine: Record "Assembly Line";
        RecLSalesLine: Record "Sales Line";
    begin
        //>>TI040889.001
        RecLSalesLine.Reset();
        RecLSalesLine.SetCurrentKey(Type, "No.");
        //<<TI040889.001
        RecLSalesLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecLSalesLine.SetRange("No.", RecPSalesLine."No.");
        //RecLSalesLine.SetRange("Build Kit",FALSE);
        RecLSalesLine.SetFilter("Outstanding Quantity", '<>0');
        DecPAmount := 0;
        if RecLSalesLine.FindSet() then
            repeat
                DecPAmount += RecLSalesLine."Outstanding Quantity";
            until RecLSalesLine.Next() = 0;

        //>>TI040889.001
        RecLKitSalesLine.Reset();
        RecLKitSalesLine.SetCurrentKey(Type, "No.");
        //<<TI040889.001
        RecLKitSalesLine.SetRange(Type, RecLKitSalesLine.Type::Item);
        RecLKitSalesLine.SetRange("No.", RecPSalesLine."No.");
        RecLKitSalesLine.SetFilter("Remaining Quantity", '<>0');
        if RecLKitSalesLine.FindSet() then
            repeat
                DecPAmount += RecLKitSalesLine."Remaining Quantity";
            until RecLKitSalesLine.Next() = 0;
    end;
    //Codeunit 7171
    procedure FctLookupPrepa(var RecPSalesLine: Record "Sales Line")
    var
        RecLSalesLine: Record "Sales Line";
        FrmLSalesLines: Page "Sales Lines";
    begin
        Clear(FrmLSalesLines);
        RecLSalesLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecLSalesLine.SetRange("No.", RecPSalesLine."No.");
        //RecLSalesLine.SetRange("Build Kit",FALSE);
        RecLSalesLine.SetFilter("Outstanding Quantity", '<>0');
        FrmLSalesLines.SetTableView(RecLSalesLine);
        FrmLSalesLines.Editable(false);
        FrmLSalesLines.RunModal();
    end;
    //Codeunit 7171
    procedure FctCalcAffectedOnPurchOrder(var RecPSalesLine: Record "Sales Line") DecPAmount: Decimal;
    var
        RecLPurchLine: Record "Purchase Line";
    begin
        RecLPurchLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SetRange("No.", RecPSalesLine."No.");
        RecLPurchLine.SetFilter("Reserved Quantity", '<>0');
        DecPAmount := 0;
        if RecLPurchLine.FindSet() then
            repeat
                RecLPurchLine.CalcFields("Reserved Quantity");
                DecPAmount += RecLPurchLine."Reserved Quantity";
            until RecLPurchLine.Next() = 0;
    end;
    //Codeunit 7171
    procedure FctLookupAffectedOnPurchOrder(var RecPSalesLine: Record "Sales Line");
    var
        RecLPurchLine: Record "Purchase Line";
        FrmLPurchLines: Page "Purchase Lines";
    begin
        Clear(FrmLPurchLines);
        RecLPurchLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SetRange("No.", RecPSalesLine."No.");
        RecLPurchLine.SetFilter("Reserved Quantity", '<>0');
        FrmLPurchLines.SetTableView(RecLPurchLine);
        FrmLPurchLines.Editable(false);
        FrmLPurchLines.RunModal();
    end;
    //Codeunit 7171
    procedure FctCalcNoAffectedOnPurchOrder(var RecPSalesLine: Record "Sales Line") DecPAmount: Decimal;
    var
        RecLPurchLine: Record "Purchase Line";
    begin
        RecLPurchLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SetRange("No.", RecPSalesLine."No.");
        RecLPurchLine.SetFilter("Reserved Quantity", '<>0');
        DecPAmount := 0;
        if RecLPurchLine.FindSet() then
            repeat
                RecLPurchLine.CalcFields("Reserved Quantity");
                DecPAmount += RecLPurchLine."Outstanding Quantity" - RecLPurchLine."Reserved Quantity";
            until RecLPurchLine.Next() = 0;
    end;
    //Codeunit 7171
    procedure FctLookupNoAffectedOnPurchOrd(var RecPSalesLine: Record "Sales Line");
    var
        RecLPurchLine: Record "Purchase Line";
        FrmLPurchLines: Page "Purchase Lines";
        OptGProcess: enum "Option Process";
    begin
        Clear(FrmLPurchLines);
        RecLPurchLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecLPurchLine.SetRange("No.", RecPSalesLine."No.");
        RecLPurchLine.SetFilter("Outstanding Quantity", '<>0');
        FrmLPurchLines.SetTableView(RecLPurchLine);
        FrmLPurchLines.Editable(false);
        FrmLPurchLines.FctGetParm(RecPSalesLine."No.", OptGProcess::NoAffected);
        FrmLPurchLines.RunModal();
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
                AvailabilityDate := WorkDate();

            Item.Reset();
            Item.SetRange("Date Filter", 0D, AvailabilityDate);
            Item.SetRange("Variant Filter", SalesLine."Variant Code");
            Item.SetRange("Location Filter", SalesLine."Location Code");
            Item.SetRange("Drop Shipment Filter", false);
            Item.CalcFields(Inventory);
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
            if RecLItem.Get(RecPSalesLine."No.") then begin
                RecLItem.CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Assembly Order", "Reserved Qty. on Purch. Orders");
                DecPAmount := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + RecLItem."Qty. on Assembly Order") + RecLItem."Reserved Qty. on Purch. Orders";
            end;
        //<<FED_20090415:PA 15/04/2009
    end;

    //Codeunit 92 Dupliquate
    //**************************************************************************************
    procedure ConfirmPostPurchaseDocument(var PurchaseHeaderToPost: Record "Purchase Header"; DefaultOption: Integer; WithPrint: Boolean; WithEmail: Boolean) Result: Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        UserSetupManagement: Codeunit "User Setup Management";
        ConfirmManagement: Codeunit "Confirm Management";
        PostingSelectionManagement: Codeunit "Posting Selection Management";
        Selection: Integer;

    begin
        if DefaultOption > 3 then
            DefaultOption := 3;
        if DefaultOption <= 0 then
            DefaultOption := 1;

        PurchaseHeader.Copy(PurchaseHeaderToPost);

        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    UserSetupManagement.GetPurchaseInvoicePostingPolicy(PurchaseHeader.Receive, PurchaseHeader.Invoice);
                    case true of
                        not PurchaseHeader.Receive and not PurchaseHeader.Invoice:
                            begin
                                Selection := StrMenu(ReceiveInvoiceOptionsQst, DefaultOption);
                                if Selection = 0 then
                                    exit(false);
                                PurchaseHeader.Receive := Selection in [1, 3];
                                PurchaseHeader.Invoice := Selection in [2, 3];
                            end;
                        PurchaseHeader.Receive and not PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(ReceiveConfirmQst, true) then
                                exit(false);
                        PurchaseHeader.Receive and PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(ReceiveInvoiceConfirmQst, true) then
                                exit(false);
                    end;
                end;
            PurchaseHeader."Document Type"::"Return Order":
                begin
                    UserSetupManagement.GetPurchaseInvoicePostingPolicy(PurchaseHeader.Ship, PurchaseHeader.Invoice);
                    case true of
                        not PurchaseHeader.Ship and not PurchaseHeader.Invoice:
                            begin
                                Selection := StrMenu(ShipInvoiceOptionsQst, DefaultOption);
                                if Selection = 0 then
                                    exit(false);
                                PurchaseHeader.Ship := Selection in [1, 3];
                                PurchaseHeader.Invoice := Selection in [2, 3];
                            end;
                        PurchaseHeader.Ship and not PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(ShipConfirmQst, true) then
                                exit(false);
                        PurchaseHeader.Ship and PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(ShipInvoiceConfirmQst, true) then
                                exit(false);
                    end;
                end;
            PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo":
                begin
                    PostingSelectionManagement.CheckUserCanInvoicePurchase();
                    if not ConfirmManagement.GetResponseOrDefault(
                            GetPostConfirmationMessage(PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice, WithPrint, WithEmail), true)
                    then
                        exit(false);
                end;
            else
                if not ConfirmManagement.GetResponseOrDefault(
                        GetPostConfirmationMessage(Format(PurchaseHeader."Document Type"), WithPrint, WithEmail), true)
                then
                    exit(false);
        end;

        PurchaseHeaderToPost.Copy(PurchaseHeader);
        exit(true);
    end;

    procedure GetPostConfirmationMessage(What: Text; WithPrint: Boolean; WithEmail: Boolean): Text
    begin
        if WithPrint then
            exit(StrSubstNo(PostAndPrintConfirmQst, What));

        if WithEmail then
            exit(StrSubstNo(PostAndEmailConfirmQst, What));

        exit(StrSubstNo(PostDocConfirmQst, What));
    end;

    local procedure GetPostConfirmationMessage(IsInvoice: Boolean; WithPrint: Boolean; WithEmail: Boolean): Text
    begin
        if IsInvoice then begin
            if WithPrint then
                exit(PrintInvoiceConfirmQst);

            if WithEmail then
                exit(EmailInvoiceConfirmQst);

            exit(InvoiceConfirmQst);
        end else begin
            if WithPrint then
                exit(PrintCreditMemoConfirmQst);

            if WithEmail then
                exit(EmailCreditMemoConfirmQst);

            exit(CreditMemoConfirmQst);
        end;
    end;

    local procedure OnInsertShipmentLineOnAfterInitQuantityFields(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
        SalesShptLine."Qty. Ordered" := SalesLine.Quantity;
        SalesShptLine."Qty Shipped on Order" := SalesLine."Quantity Shipped";
    end;
    // codeunit 6620 "Copy Document Mgt."

    local procedure RecalculateSalesLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; var FromSalesHeader: Record "Sales Header"; var FromSalesLine: Record "Sales Line"; var CopyThisLine: Boolean)
    var
        GLAcc: Record "G/L Account";
        IsHandled: Boolean;
    begin
        IsHandled := true;
        if not IsHandled then begin
            ToSalesLine.Validate(Type, FromSalesLine.Type);
            ToSalesLine.Description := FromSalesLine.Description;
            ToSalesLine.Validate("Description 2", FromSalesLine."Description 2");

            if (FromSalesLine.Type <> FromSalesLine.Type::" ") and (FromSalesLine."No." <> '') then begin
                if ToSalesLine.Type = ToSalesLine.Type::"G/L Account" then begin
                    ToSalesLine."No." := FromSalesLine."No.";
                    GLAcc.Get(FromSalesLine."No.");
                    CopyThisLine := GLAcc."Direct Posting";

                    if CopyThisLine then
                        ToSalesLine.Validate("No.", FromSalesLine."No.");
                end else
                    if CopyThisLine then begin
                        ToSalesLine.Validate("Item Base", FromSalesLine."Item Base");
                        ToSalesLine.Validate("No.", FromSalesLine."No.");
                    end
            end else begin
                ToSalesLine.Validate("Item Base", FromSalesLine."Item Base");
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

    local procedure IsCreatedFromJob(var SalesLine: Record "Sales Line"): Boolean
    begin
        if (SalesLine."Job No." <> '') and (SalesLine."Job Task No." <> '') and (SalesLine."Job Contract Entry No." <> 0) then
            exit(true);
    end;

    procedure "FTA.UPDATECOST"(SalesHeader: Record "Sales Header");
    var
        ATOLink: Record "Assemble-to-Order Link";
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Type, '>0');
        SalesLine.SetFilter(Quantity, '<>0');

        SalesLine.SetFilter(SalesLine."Qty. to Assemble to Order", '<>0');

        if SalesLine.FindSet() then
            repeat
                ATOLink.RollUpCost(SalesLine);
            until SalesLine.Next() = 0;
    end;
    //****************************************************************************************
    var
        ShipInvoiceFromWhseQst: Label '&Ship,Ship &and Invoice';
        ReceiveInvoiceFromWhseQst: Label '&Receive,Receive &and Invoice';
        PostWhseAndDocConfirmQst: Label 'Do you want to post the %1 and %2?', Comment = '%1 = Activity Type, %2 = Document Type';
        InvoiceConfirmQst: Label 'Do you want to post the invoice?';
        CreditMemoConfirmQst: Label 'Do you want to post the credit memo?';
        PrintInvoiceConfirmQst: Label 'Do you want to post and print the invoice?';
        PrintCreditMemoConfirmQst: Label 'Do you want to post and print the credit memo?';
        EmailInvoiceConfirmQst: Label 'Do you want to post and email the invoice?';
        EmailCreditMemoConfirmQst: Label 'Do you want to post and email the credit memo?';
        ShipConfirmQst: Label 'Do you want to post the shipment?';
        ShipInvoiceConfirmQst: Label 'Do you want to post the shipment and invoice?';
        ReceiveConfirmQst: Label 'Do you want to post the receipt?';
        ReceiveInvoiceConfirmQst: Label 'Do you want to post the receipt and invoice?';
        PostingInvoiceProhibitedErr: Label 'You cannot post the invoice because %1 is %2 in %3.', Comment = '%1 = Invoice Posting Policy, %2 = Prohibited, %3 = User Setup';
        PostAndPrintConfirmQst: Label 'Do you want to post and print the %1?', Comment = '%1 = Document Type';
        PostAndEmailConfirmQst: Label 'Do you want to post and email the %1?', Comment = '%1 = Document Type';
        PostDocConfirmQst: Label 'Do you want to post the %1?', Comment = '%1 = Document Type';
        ReceiveInvoiceOptionsQst: Label '&Receive,&Invoice,Receive &and Invoice';
        ShipInvoiceOptionsQst: Label '&Ship,&Invoice,Ship &and Invoice';



}
