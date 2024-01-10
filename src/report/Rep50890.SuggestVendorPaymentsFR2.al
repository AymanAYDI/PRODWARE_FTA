namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Payables;
using Microsoft.Bank.Payment;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.Currency;
report 50890 "Suggest Vendor Payments FR 2" // Duplicated from 10862
{

    Caption = 'Suggest Vendor Payments';
    Permissions = TableData "Vendor Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Payment Method Code";

            trigger OnAfterGetRecord()
            begin
                if StopPayments then
                    CurrReport.BREAK();
                Window.UPDATE(1, "No.");

                //>>NAVEASY.001 [Multi_Collectif]
                //STD GetVendLedgEntries(TRUE,FALSE);
                //STD GetVendLedgEntries(FALSE,FALSE);
                if BooGCheckPostGroup then begin
                    GetVendLedgEntries2(true, false);
                    GetVendLedgEntries2(false, false);
                end
                else begin
                    GetVendLedgEntries(true, false);
                    GetVendLedgEntries(false, false);
                end;
                //<<NAVEASY.001 [Multi_Collectif]
                CheckAmounts(false);
            end;

            trigger OnPostDataItem()
            begin
                if UsePriority and not StopPayments then begin
                    RESET();
                    COPYFILTERS(Vend2);
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 0);
                    if FINDFIRST() then
                        repeat
                            Window.UPDATE(1, "No.");
                            GetVendLedgEntries(true, false);
                            GetVendLedgEntries(false, false);
                            CheckAmounts(false);
                        until (NEXT() = 0) or StopPayments;
                end;

                if UsePaymentDisc and not StopPayments then begin
                    RESET();
                    COPYFILTERS(Vend2);
                    Window.OPEN(Text007);
                    if FINDFIRST() then
                        repeat
                            Window.UPDATE(1, "No.");
                            PayableVendLedgEntry.SETRANGE("Vendor No.", "No.");
                            GetVendLedgEntries(true, true);
                            GetVendLedgEntries(false, true);
                            CheckAmounts(true);
                        until (NEXT() = 0) or StopPayments;
                end;

                GenPayLine.LOCKTABLE();
                GenPayLine.SETRANGE("No.", GenPayLine."No.");
                if GenPayLine.FINDLAST() then begin
                    LastLineNo := GenPayLine."Line No.";
                    GenPayLine.INIT();
                end;

                Window.OPEN(Text008);

                PayableVendLedgEntry.RESET();
                PayableVendLedgEntry.SETRANGE(Priority, 1, 2147483647);

                //>>NAVEASY.001 [Multi_Collectif]
                //STD MakeGenPayLines;
                if BooGCheckPostGroup then
                    MakeGenPayLines2()
                else
                    MakeGenPayLines();
                //<<NAVEASY.001 [Multi_Collectif]
                PayableVendLedgEntry.RESET();
                PayableVendLedgEntry.SETRANGE(Priority, 0);

                //>>NAVEASY.001 [Multi_Collectif]
                //STD MakeGenPayLines;
                if BooGCheckPostGroup then
                    MakeGenPayLines2()
                else
                    MakeGenPayLines();
                //<<NAVEASY.001 [Multi_Collectif]
                PayableVendLedgEntry.RESET();
                PayableVendLedgEntry.DELETEALL();

                Window.CLOSE();
                ShowMessage(MessageText);
            end;

            trigger OnPreDataItem()
            begin
                if LastDueDateToPayReq = 0D then
                    ERROR(Text000);
                if PostingDate = 0D then
                    ERROR(Text001);

                GenPayLineInserted := false;
                MessageText := '';

                if UsePaymentDisc and (LastDueDateToPayReq < WORKDATE()) then
                    if not
                       CONFIRM(
                         Text003 +
                         Text004, false,
                         WORKDATE())
                    then
                        ERROR(Text005);

                Vend2.COPYFILTERS(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                if UsePriority then begin
                    SETCURRENTKEY(Priority);
                    SETRANGE(Priority, 1, 2147483647);
                    UsePriority := true;
                end;
                Window.OPEN(Text006);

                NextEntryNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(LastPaymentDate; LastDueDateToPayReq)
                    {
                        Caption = 'Last Payment Date';
                    }
                    field(UsePaymentDisc; UsePaymentDisc)
                    {
                        Caption = 'Find Payment Discounts';
                        MultiLine = true;
                    }
                    field(SummarizePer; SummarizePer)
                    {
                        Caption = 'Summarize per';
                        OptionCaption = ' ,Vendor,Due date';
                    }
                    field(UsePriority; UsePriority)
                    {
                        Caption = 'Use Vendor Priority';

                        trigger OnValidate()
                        begin
                            if not UsePriority and (AmountAvailable <> 0) then
                                ERROR(Text011);
                        end;
                    }
                    field(AvailableAmountLCY; AmountAvailable)
                    {
                        Caption = 'Available Amount (LCY)';

                        trigger OnValidate()
                        begin
                            AmountAvailableOnAfterValidate();
                        end;
                    }
                    field(CurrencyFilter; CurrencyFilter)
                    {
                        Caption = 'Currency Filter';
                        Editable = false;
                        TableRelation = Currency;
                    }
                    field(CodGPayMetFilter; CodGPayMetFilter)
                    {
                        Caption = 'Payment Method Filter';
                        TableRelation = "No. Series";
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin

            //>> FIN.02 20080723
            BooGCheckPostGroup := true;
            //<< FIN.02 20080723
        end;
    }

    labels
    {
    }

    var
        PayableVendLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        PaymentClass: Record "Payment Class";
        GenPayHead: Record "Payment Header";
        GenPayLine: Record "Payment Line";
        OldTempPaymentPostBuffer: Record "Payment Post. Buffer" temporary;
        TempPaymentPostBuffer: Record "Payment Post. Buffer" temporary;
        Vend2: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        VendEntryEdit: Codeunit "Vend. Entry-Edit";
        BooGCheckPostGroup: Boolean;
        GenPayLineInserted: Boolean;
        StopPayments: Boolean;
        UsePaymentDisc: Boolean;
        UsePriority: Boolean;
        CurrencyFilter: Code[10];
        CodGNextDocNo: Code[20];
        NextDocNo: Code[20];
        CodGPayMetFilter: Code[50];
        LastDueDateToPayReq: Date;
        PostingDate: Date;
        AmountAvailable: Decimal;
        OriginalAmtAvailable: Decimal;
        Window: Dialog;
        LastLineNo: Integer;
        NextEntryNo: Integer;
        Text000: Label 'Please enter the last payment date.';
        Text001: Label 'Please enter the posting date.';
        Text003: Label 'The selected last due date is earlier than %1.\\';
        Text004: Label 'Do you still want to run the batch job?';
        Text005: Label 'The batch job was interrupted.';
        Text006: Label 'Processing vendors     #1##########';
        Text007: Label 'Processing vendors for payment discounts #1##########';
        Text008: Label 'Inserting payment journal lines #1##########';
        Text011: Label 'Use Vendor Priority must be activated when the value in the Amount Available field is not 0.';
        Text016: Label ' is already applied to %1 %2 for vendor %3.';
        SummarizePer: Option " ",Vendor,"Due date";
        MessageText: Text;


    procedure SetGenPayLine(NewGenPayLine: Record "Payment Header")
    begin
        GenPayHead := NewGenPayLine;
        GenPayLine."No." := NewGenPayLine."No.";
        PaymentClass.GET(GenPayHead."Payment Class");
        PostingDate := GenPayHead."Posting Date";
        CurrencyFilter := GenPayHead."Currency Code";
    end;


    procedure GetVendLedgEntries(Positive: Boolean; Future: Boolean)
    begin
        VendLedgEntry.RESET();
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendLedgEntry.SETRANGE(Open, true);
        VendLedgEntry.SETRANGE(Positive, Positive);
        VendLedgEntry.SETRANGE("Currency Code", CurrencyFilter);
        VendLedgEntry.SETRANGE("Applies-to ID", '');
        if Future then begin
            VendLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, 19991231D);
            VendLedgEntry.SETRANGE("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SETFILTER("Original Pmt. Disc. Possible", '<0');
        end else
            VendLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        VendLedgEntry.SETRANGE("On Hold", '');

        //>>NAVEASY.001 [Payment Method propagation]
        VendLedgEntry.SETFILTER("Payment Method Code", CodGPayMetFilter);
        //<<NAVEASY.001 [Payment Method propagation]

        if VendLedgEntry.FINDFIRST() then
            repeat
                SaveAmount();
            until VendLedgEntry.NEXT() = 0;
    end;

    local procedure SaveAmount()
    begin
        with GenPayLine do begin
            "Account Type" := "Account Type"::Vendor;
            VALIDATE("Account No.", VendLedgEntry."Vendor No.");
            "Posting Date" := VendLedgEntry."Posting Date";
            "Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
            if "Currency Factor" = 0 then
                "Currency Factor" := 1;
            VALIDATE("Currency Code", VendLedgEntry."Currency Code");
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            if ((VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::"Credit Memo") and
                (VendLedgEntry."Remaining Pmt. Disc. Possible" <> 0) or
                (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice)) and
               (PostingDate <= VendLedgEntry."Pmt. Discount Date")
            then
                Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Original Pmt. Disc. Possible")
            else
                Amount := -VendLedgEntry."Remaining Amount";
            VALIDATE(Amount);
        end;

        if UsePriority then
            PayableVendLedgEntry.Priority := Vendor.Priority
        else
            PayableVendLedgEntry.Priority := 0;
        PayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        PayableVendLedgEntry."Entry No." := NextEntryNo;
        PayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
        PayableVendLedgEntry.Amount := GenPayLine.Amount;
        PayableVendLedgEntry."Amount (LCY)" := GenPayLine."Amount (LCY)";
        PayableVendLedgEntry.Positive := (PayableVendLedgEntry.Amount > 0);
        PayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
        PayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        PayableVendLedgEntry."Due Date" := VendLedgEntry."Due Date";
        PayableVendLedgEntry.INSERT();
        NextEntryNo := NextEntryNo + 1;
    end;


    procedure CheckAmounts(Future: Boolean)
    var
        PrevCurrency: Code[10];
        CurrencyBalance: Decimal;
    begin
        PayableVendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        PayableVendLedgEntry.SETRANGE(Future, Future);
        if PayableVendLedgEntry.FINDFIRST() then begin
            PrevCurrency := PayableVendLedgEntry."Currency Code";
            repeat
                if PayableVendLedgEntry."Currency Code" <> PrevCurrency then begin
                    if CurrencyBalance < 0 then begin
                        PayableVendLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                        PayableVendLedgEntry.DELETEALL();
                        PayableVendLedgEntry.SETRANGE("Currency Code");
                    end else
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := PayableVendLedgEntry."Currency Code";
                end;
                if (OriginalAmtAvailable = 0) or
                   (AmountAvailable >= CurrencyBalance + PayableVendLedgEntry."Amount (LCY)")
                then
                    CurrencyBalance := CurrencyBalance + PayableVendLedgEntry."Amount (LCY)"
                else
                    PayableVendLedgEntry.DELETE();
            until PayableVendLedgEntry.NEXT() = 0;
            if CurrencyBalance < 0 then begin
                PayableVendLedgEntry.SETRANGE("Currency Code", PrevCurrency);
                PayableVendLedgEntry.DELETEALL();
                PayableVendLedgEntry.SETRANGE("Currency Code");
            end else
                if OriginalAmtAvailable > 0 then
                    AmountAvailable := AmountAvailable - CurrencyBalance;
            if (OriginalAmtAvailable > 0) and (AmountAvailable <= 0) then
                StopPayments := true;
        end;
        PayableVendLedgEntry.RESET();
    end;

    local procedure MakeGenPayLines()
    var
        GenPayLine3: Record "Gen. Journal Line";
    begin
        TempPaymentPostBuffer.DELETEALL();

        if PayableVendLedgEntry.FINDFIRST() then
            repeat
                PayableVendLedgEntry.SETRANGE("Vendor No.", PayableVendLedgEntry."Vendor No.");
                PayableVendLedgEntry.FINDFIRST();
                repeat
                    VendLedgEntry.GET(PayableVendLedgEntry."Vendor Ledg. Entry No.");
                    TempPaymentPostBuffer."Account No." := VendLedgEntry."Vendor No.";
                    TempPaymentPostBuffer."Currency Code" := VendLedgEntry."Currency Code";
                    if SummarizePer = SummarizePer::"Due date" then
                        TempPaymentPostBuffer."Due Date" := VendLedgEntry."Due Date";

                    TempPaymentPostBuffer."Dimension Entry No." := 0;
                    TempPaymentPostBuffer."Global Dimension 1 Code" := '';
                    TempPaymentPostBuffer."Global Dimension 2 Code" := '';

                    if SummarizePer in [SummarizePer::" ", SummarizePer::Vendor, SummarizePer::"Due date"] then begin
                        TempPaymentPostBuffer."Auxiliary Entry No." := 0;
                        if TempPaymentPostBuffer.FIND() then begin
                            TempPaymentPostBuffer.Amount := TempPaymentPostBuffer.Amount + PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)" + PayableVendLedgEntry."Amount (LCY)";
                            TempPaymentPostBuffer.MODIFY();
                        end else begin
                            LastLineNo := LastLineNo + 10000;
                            TempPaymentPostBuffer."Payment Line No." := LastLineNo;
                            if PaymentClass."Line No. Series" = '' then
                                NextDocNo := COPYSTR(GenPayHead."No." + '/' + FORMAT(LastLineNo), 1, MAXSTRLEN(NextDocNo))
                            else
                                NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);

                            //>>NAVEASY.001 [ID_Lettrage] Recupération du N° de Bordereau + N° Ligne
                            CodGNextDocNo := GenPayHead."No." + '/' + FORMAT(LastLineNo);
                            //<<NAVEASY.001 [ID_Lettrage] Recupération du N° de Bordereau + N° Ligne

                            TempPaymentPostBuffer."Document No." := NextDocNo;
                            NextDocNo := INCSTR(NextDocNo);
                            TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                            Window.UPDATE(1, VendLedgEntry."Vendor No.");
                            TempPaymentPostBuffer.INSERT();
                        end;

                        //>>NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de l'Ecriture fournisseur
                        // avec le N° de Bordereau + N° Ligne
                        //std VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Document No.";
                        VendLedgEntry."Applies-to ID" := CodGNextDocNo;
                        //<<NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de l'Ecriture fournisseur

                        //VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Document No.";
                        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                    end else begin
                        GenPayLine3.RESET();
                        GenPayLine3.SETCURRENTKEY(
                          "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
                        GenPayLine3.SETRANGE("Account Type", GenPayLine3."Account Type"::Vendor);
                        GenPayLine3.SETRANGE("Account No.", VendLedgEntry."Vendor No.");
                        GenPayLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry."Document Type");
                        GenPayLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry."Document No.");
                        if GenPayLine3.FINDFIRST() then
                            GenPayLine3.FIELDERROR(
                              "Applies-to Doc. No.",
                              STRSUBSTNO(
                                Text016,
                                VendLedgEntry."Document Type", VendLedgEntry."Document No.",
                                VendLedgEntry."Vendor No."));

                        TempPaymentPostBuffer."Applies-to Doc. Type" := VendLedgEntry."Document Type";
                        TempPaymentPostBuffer."Applies-to Doc. No." := VendLedgEntry."Document No.";
                        TempPaymentPostBuffer."Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
                        TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                        TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                        TempPaymentPostBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                        TempPaymentPostBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                        TempPaymentPostBuffer."Auxiliary Entry No." := VendLedgEntry."Entry No.";
                        Window.UPDATE(1, VendLedgEntry."Vendor No.");
                        TempPaymentPostBuffer.INSERT();
                    end;
                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                until PayableVendLedgEntry.NEXT() = 0;
                PayableVendLedgEntry.SETFILTER("Vendor No.", '>%1', PayableVendLedgEntry."Vendor No.");
            until not PayableVendLedgEntry.FINDFIRST();

        CLEAR(OldTempPaymentPostBuffer);
        TempPaymentPostBuffer.SETCURRENTKEY("Document No.");
        if TempPaymentPostBuffer.FINDSET() then
            repeat
                with GenPayLine do begin
                    INIT();
                    Window.UPDATE(1, TempPaymentPostBuffer."Account No.");
                    if SummarizePer = SummarizePer::" " then begin
                        LastLineNo := LastLineNo + 10000;
                        "Line No." := LastLineNo;
                        if PaymentClass."Line No. Series" = '' then
                            NextDocNo := GenPayHead."No." + '/' + FORMAT("Line No.")
                        else
                            NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                    end else begin
                        "Line No." := TempPaymentPostBuffer."Payment Line No.";
                        NextDocNo := TempPaymentPostBuffer."Document No.";
                    end;
                    "Document No." := NextDocNo;

                    //>>NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de l'Ecriture fournisseur
                    // avec le N° de Bordereau + N° Ligne
                    //std VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Document No.";
                    VendLedgEntry."Applies-to ID" := CodGNextDocNo;
                    //<<NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de l'Ecriture fournisseur

                    //"Applies-to ID" := "Document No.";
                    OldTempPaymentPostBuffer := TempPaymentPostBuffer;
                    OldTempPaymentPostBuffer."Document No." := "Document No.";
                    if SummarizePer = SummarizePer::" " then begin
                        VendLedgEntry.GET(TempPaymentPostBuffer."Auxiliary Entry No.");

                        //>>NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de la ligne VENDOR LEDG. ENTRY
                        //std VendLedgEntry."Applies-to ID" := NextDocNo;
                        VendLedgEntry."Applies-to ID" := CodGNextDocNo;
                        //<<NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de la Ligne VENDOR LEDG. ENTRY

                        //VendLedgEntry."Applies-to ID" := NextDocNo;
                        VendLedgEntry.MODIFY();
                    end;
                    "Account Type" := "Account Type"::Vendor;
                    VALIDATE("Account No.", TempPaymentPostBuffer."Account No.");
                    "Currency Code" := TempPaymentPostBuffer."Currency Code";
                    Amount := TempPaymentPostBuffer.Amount;
                    if Amount > 0 then
                        "Debit Amount" := Amount
                    else
                        "Credit Amount" := -Amount;
                    "Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)";
                    "Currency Factor" := TempPaymentPostBuffer."Currency Factor";
                    if ("Currency Factor" = 0) and (Amount <> 0) then
                        "Currency Factor" := Amount / "Amount (LCY)";
                    Vend2.GET("Account No.");
                    VALIDATE("Bank Account Code", Vend2."Preferred Bank Account Code");
                    "Payment Class" := GenPayHead."Payment Class";
                    VALIDATE("Status No.");
                    "Posting Date" := PostingDate;
                    if SummarizePer = SummarizePer::" " then begin
                        "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                        "Applies-to Doc. No." := VendLedgEntry."Document No.";
                    end;
                    case SummarizePer of
                        SummarizePer::" ":
                            "Due Date" := VendLedgEntry."Due Date";
                        SummarizePer::Vendor:
                            begin
                                PayableVendLedgEntry.SETCURRENTKEY("Vendor No.", "Due Date");
                                PayableVendLedgEntry.SETRANGE("Vendor No.", TempPaymentPostBuffer."Account No.");
                                PayableVendLedgEntry.FINDFIRST();
                                "Due Date" := PayableVendLedgEntry."Due Date";
                                PayableVendLedgEntry.DELETEALL();
                            end;
                        SummarizePer::"Due date":
                            "Due Date" := TempPaymentPostBuffer."Due Date";
                    end;
                    if Amount <> 0 then
                        INSERT();
                    GenPayLineInserted := true;
                end;
            until TempPaymentPostBuffer.NEXT() = 0;
    end;

    local procedure ShowMessage(Text: Text)
    begin
        if (Text <> '') and GenPayLineInserted then
            MESSAGE(Text);
    end;

    local procedure AmountAvailableOnAfterValidate()
    begin
        if AmountAvailable <> 0 then
            UsePriority := true;
    end;


    procedure "---NAVEASY.001---"()
    begin
    end;


    procedure GetVendLedgEntries2(Positive: Boolean; Future: Boolean)
    begin
        VendLedgEntry.RESET();
        //VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Vendor Posting Group", "Due Date");
        VendLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendLedgEntry.SETRANGE(Open, true);
        VendLedgEntry.SETRANGE(Positive, Positive);
        VendLedgEntry.SETRANGE("Currency Code", CurrencyFilter);
        VendLedgEntry.SETRANGE("Applies-to ID", '');
        if Future then begin
            VendLedgEntry.SETRANGE("Due Date", LastDueDateToPayReq + 1, 19991231D);
            VendLedgEntry.SETRANGE("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SETFILTER("Original Pmt. Disc. Possible", '<0');
        end else
            VendLedgEntry.SETRANGE("Due Date", 0D, LastDueDateToPayReq);
        VendLedgEntry.SETRANGE("On Hold", '');

        //>>NAVEASY.001 [Payment Method propagation]
        VendLedgEntry.SETFILTER("Payment Method Code", CodGPayMetFilter);
        //<<NAVEASY.001 [Payment Method propagation]


        if VendLedgEntry.FINDFIRST() then
            repeat
                SaveAmount();
            until VendLedgEntry.NEXT() = 0;
    end;

    local procedure MakeGenPayLines2()
    var
        GenPayLine3: Record "Gen. Journal Line";
        EntryNo: Integer;
    begin
        TempPaymentPostBuffer.DELETEALL();

        if PayableVendLedgEntry.FINDFIRST() then
            repeat
                PayableVendLedgEntry.SETRANGE("Vendor No.", PayableVendLedgEntry."Vendor No.");
                PayableVendLedgEntry.FINDFIRST();
                repeat
                    VendLedgEntry.GET(PayableVendLedgEntry."Vendor Ledg. Entry No.");
                    TempPaymentPostBuffer."Account No." := VendLedgEntry."Vendor No.";
                    TempPaymentPostBuffer."Currency Code" := VendLedgEntry."Currency Code";
                    if SummarizePer = SummarizePer::"Due date" then
                        TempPaymentPostBuffer."Due Date" := VendLedgEntry."Due Date";

                    TempPaymentPostBuffer."Dimension Entry No." := 0;
                    TempPaymentPostBuffer."Global Dimension 1 Code" := '';
                    TempPaymentPostBuffer."Global Dimension 2 Code" := '';

                    //>>FIN.02 20080723
                    if SummarizePer in [SummarizePer::Vendor, SummarizePer::"Due date"] then begin
                        //IF SummarizePer IN [SummarizePer::" ",SummarizePer::Vendor,SummarizePer::"Due date"] THEN BEGIN
                        //<<FIN.02 20080723

                        TempPaymentPostBuffer."Auxiliary Entry No." := 0;

                        //>>NAVEASY.001 [Multi_Collectif]
                        //STD IF (TempPaymentPostBuffer.FIND) THEN BEGIN
                        if (TempPaymentPostBuffer.FIND()) and
                           (TempPaymentPostBuffer."Posting Group" = VendLedgEntry."Vendor Posting Group") then begin
                            //<<NAVEASY.001 [Multi_Collectif]

                            TempPaymentPostBuffer.Amount := TempPaymentPostBuffer.Amount + PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)" + PayableVendLedgEntry."Amount (LCY)";
                            TempPaymentPostBuffer.MODIFY();
                        end else begin
                            LastLineNo := LastLineNo + 10000;
                            TempPaymentPostBuffer."Payment Line No." := LastLineNo;
                            if PaymentClass."Line No. Series" = '' then
                                NextDocNo := GenPayHead."No." + '/' + FORMAT(LastLineNo)
                            else
                                NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);

                            //>>NAVEASY.001 [ID_Lettrage] Recupération du N° de Bordereau + N° Ligne
                            CodGNextDocNo := GenPayHead."No." + '/' + FORMAT(LastLineNo);
                            //<<NAVEASY.001 [ID_Lettrage] Recupération du N° de Bordereau + N° Ligne

                            TempPaymentPostBuffer."Document No." := NextDocNo;

                            //>>NAVEASY.001 [Multi_Collectif]
                            TempPaymentPostBuffer."Posting Group" := VendLedgEntry."Vendor Posting Group";
                            //<<NAVEASY.001 [Multi_Collectif]

                            NextDocNo := INCSTR(NextDocNo);
                            TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                            Window.UPDATE(1, VendLedgEntry."Vendor No.");
                            TempPaymentPostBuffer.INSERT();
                        end;

                        //>>NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de l'Ecriture fournisseur
                        // avec le N° de Bordereau + N° Ligne
                        //std VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Document No.";
                        VendLedgEntry."Applies-to ID" := CodGNextDocNo;
                        //<<NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de l'Ecriture fournisseur

                        VendEntryEdit.RUN(VendLedgEntry)
                    end else begin
                        GenPayLine3.RESET();
                        GenPayLine3.SETCURRENTKEY(
                          "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
                        GenPayLine3.SETRANGE("Account Type", GenPayLine3."Account Type"::Vendor);
                        GenPayLine3.SETRANGE("Account No.", VendLedgEntry."Vendor No.");
                        GenPayLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry."Document Type");
                        GenPayLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry."Document No.");
                        if GenPayLine3.FINDFIRST() then
                            GenPayLine3.FIELDERROR(
                              "Applies-to Doc. No.",
                              STRSUBSTNO(
                                Text016,
                                VendLedgEntry."Document Type", VendLedgEntry."Document No.",
                                VendLedgEntry."Vendor No."));

                        TempPaymentPostBuffer."Applies-to Doc. Type" := VendLedgEntry."Document Type";
                        TempPaymentPostBuffer."Applies-to Doc. No." := VendLedgEntry."Document No.";
                        TempPaymentPostBuffer."Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
                        TempPaymentPostBuffer.Amount := PayableVendLedgEntry.Amount;
                        TempPaymentPostBuffer."Amount (LCY)" := PayableVendLedgEntry."Amount (LCY)";
                        TempPaymentPostBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                        TempPaymentPostBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                        TempPaymentPostBuffer."Auxiliary Entry No." := VendLedgEntry."Entry No.";

                        //>>FIN.02 20080723
                        TempPaymentPostBuffer."Posting Group" := VendLedgEntry."Vendor Posting Group";
                        //<<FIN.02 20080723

                        Window.UPDATE(1, VendLedgEntry."Vendor No.");
                        TempPaymentPostBuffer.INSERT();
                    end;
                    VendLedgEntry.CALCFIELDS(VendLedgEntry."Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    VendEntryEdit.RUN(VendLedgEntry);
                until PayableVendLedgEntry.NEXT() = 0;
                PayableVendLedgEntry.DELETEALL();
                PayableVendLedgEntry.SETRANGE("Vendor No.");
            until not PayableVendLedgEntry.FINDFIRST();

        CLEAR(OldTempPaymentPostBuffer);
        TempPaymentPostBuffer.SETCURRENTKEY("Document No.");
        if TempPaymentPostBuffer.FINDFIRST() then
            repeat
                with GenPayLine do begin
                    INIT();
                    Window.UPDATE(1, TempPaymentPostBuffer."Account No.");
                    if SummarizePer = SummarizePer::" " then begin
                        LastLineNo := LastLineNo + 10000;
                        "Line No." := LastLineNo;
                        if PaymentClass."Line No. Series" = '' then
                            NextDocNo := GenPayHead."No." + '/' + FORMAT(GenPayLine."Line No.")
                        else
                            NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                    end else begin
                        "Line No." := TempPaymentPostBuffer."Payment Line No.";
                        NextDocNo := TempPaymentPostBuffer."Document No.";
                    end;

                    //>>NAVEASY.001 [ID_Lettrage] Recupération du N° de Bordereau + N° Ligne
                    CodGNextDocNo := GenPayLine."No." + '/' + FORMAT("Line No.");
                    //<<NAVEASY.001 [ID_Lettrage] Recupération du N° de Bordereau + N° Ligne

                    "Document No." := NextDocNo;

                    //>>NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de la Ligne Bordereau
                    //std GenPayLine."Applies-to ID" := "Document No.";
                    GenPayLine."Applies-to ID" := CodGNextDocNo;
                    //<<NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de la Ligne Bordereau

                    OldTempPaymentPostBuffer := TempPaymentPostBuffer;
                    OldTempPaymentPostBuffer."Document No." := "Document No.";
                    if SummarizePer = SummarizePer::" " then begin
                        VendLedgEntry.GET(TempPaymentPostBuffer."Auxiliary Entry No.");
                        //>>NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de la ligne VENDOR LEDG. ENTRY
                        //std VendLedgEntry."Applies-to ID" := NextDocNo;
                        VendLedgEntry."Applies-to ID" := CodGNextDocNo;
                        //<<NAVEASY.001 [ID_Lettrage] Mise à jour de l'ID Lettrage de la Ligne VENDOR LEDG. ENTRY
                        VendLedgEntry.MODIFY();
                    end;
                    "Account Type" := "Account Type"::Vendor;
                    VALIDATE("Account No.", TempPaymentPostBuffer."Account No.");
                    "Currency Code" := TempPaymentPostBuffer."Currency Code";
                    Amount := TempPaymentPostBuffer.Amount;
                    if Amount > 0 then
                        "Debit Amount" := Amount
                    else
                        "Credit Amount" := -Amount;
                    "Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)";
                    "Currency Factor" := TempPaymentPostBuffer."Currency Factor";
                    if ("Currency Factor" = 0) and (Amount <> 0) then
                        "Currency Factor" := Amount / "Amount (LCY)";
                    Vend2.GET(GenPayLine."Account No.");
                    //MIG2015 FTA Default Bank Account code n'existe plus en 2015
                    /*      VALIDATE(GenPayLine."Bank Account Code", Vend2."Default Bank Account Code"); */
                    //MIG2015 FTA
                    "Payment Class" := GenPayHead."Payment Class";
                    if SummarizePer = SummarizePer::" " then begin
                        "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                        "Applies-to Doc. No." := VendLedgEntry."Document No.";
                    end;
                    if SummarizePer in [SummarizePer::" ", SummarizePer::Vendor] then
                        "Due Date" := VendLedgEntry."Due Date"
                    else
                        "Due Date" := TempPaymentPostBuffer."Due Date";

                    //>>NAVEASY.001 [Multi_Collectif]
                    GenPayLine."Posting Group" := TempPaymentPostBuffer."Posting Group";
                    //<<NAVEASY.001 [Multi_Collectif]

                    if Amount <> 0 then
                        INSERT();
                    GenPayLineInserted := true;
                end;
            until TempPaymentPostBuffer.NEXT() = 0;

    end;
}

