namespace Prodware.FTA;

using System.IO;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Account;
xmlport 51000 "Pay Import SAGE L100"
{

    Caption = 'Pay Import SAGE L100';
    Direction = Import;
    Format = FixedText;
    TableSeparator = '<<NewLine>>';

    schema
    {
        textelement(Root)
        {
            tableelement(firstline; "Gen. Journal Line")
            {
                XmlName = 'FirstLine';
                SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
                textelement(txtgfirstline)
                {
                    XmlName = 'TxtGFirstLine';
                    Width = 250;
                }

                trigger OnBeforeInsertRecord()
                begin
                    currXMLport.BREAK();
                end;
            }
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'Gen.JournalLine';
                SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
                textelement(codgsourcecode)
                {
                    XmlName = 'CodGSourceCode';
                    Width = 3;
                }
                textelement(datgpostdate)
                {
                    XmlName = 'DatGPostDate';
                    Width = 6;
                }
                textelement(codgpartno)
                {
                    XmlName = 'CodGPartNo';
                    Width = 2;
                }
                textelement(codgaccno)
                {
                    XmlName = 'CodGAccNo';
                    Width = 13;
                }
                textelement(codgnotused1)
                {
                    XmlName = 'CodGNotused1';
                    Width = 1;
                }
                textelement(codgnotused2)
                {
                    XmlName = 'CodGNotused2';
                    Width = 13;
                }
                textelement(txtgdescr1)
                {
                    XmlName = 'TxtGDescr1';
                    Width = 13;
                }
                textelement(txtgdescr2)
                {
                    XmlName = 'TxtGDescr2';
                    Width = 25;
                }
                textelement(codgnotused3)
                {
                    XmlName = 'CodGNotused3';
                    Width = 1;
                }
                textelement(datgduedate)
                {
                    XmlName = 'DatGDueDate';
                    Width = 6;
                }
                textelement(codgsens)
                {
                    XmlName = 'CodGSens';
                    Width = 1;
                }
                textelement(decgamount)
                {
                    XmlName = 'DecGAmount';
                    Width = 20;
                }
                textelement(codgentrytype)
                {
                    XmlName = 'CodGEntrytype';
                    Width = 1;
                }
                textelement(codgnotused4)
                {
                    XmlName = 'CodGNotused4';
                    Width = 33;
                }
                textelement(codgcurrencycode)
                {
                    XmlName = 'CodGCurrencyCode';
                    Width = 3;
                }
                textelement(codgnumaxe)
                {
                    XmlName = 'CodGNumAxe';
                    Width = 2;
                }
                textelement(codgnumsection)
                {
                    XmlName = 'CodGNumSection';
                    Width = 25;
                }

                trigger OnBeforeInsertRecord()
                begin
                    if TestAccountNo(CodGAccNo) then begin

                        IntGLineNo := IntGLineNo + 10000;
                        "Gen. Journal Line".VALIDATE("Journal Template Name", RecGGenJnlTempl.Name);
                        "Gen. Journal Line".VALIDATE("Journal Batch Name", RecGGenJnlBatch.Name);
                        "Gen. Journal Line".VALIDATE("Line No.", IntGLineNo);
                        "Gen. Journal Line".VALIDATE("Account Type", "Gen. Journal Line"."Account Type"::"G/L Account");
                        "Gen. Journal Line".VALIDATE("Document Type", "Gen. Journal Line"."Document Type"::" ");
                        "Gen. Journal Line".VALIDATE("Document Date", "Gen. Journal Line"."Posting Date");

                        EVALUATE(DatGPostingDate, DatGPostDate);
                        "Gen. Journal Line".VALIDATE("Posting Date", DatGPostingDate);

                        "Gen. Journal Line".VALIDATE("Source Code", CodGSourceCode);
                        "Gen. Journal Line".VALIDATE("Document No.", CodGDocNo);
                        "Gen. Journal Line".VALIDATE("Account No.", CodGAccNo);
                        "Gen. Journal Line".VALIDATE(Description, TxtGDescr1 + TxtGDescr2);

                        EVALUATE(DatGPostingDate, DatGDueDate);
                        "Gen. Journal Line".VALIDATE("Posting Date", DatGPostingDate);

                        EVALUATE(DecGGenAmout, DecGAmount);
                        if CodGSens = 'D' then
                            "Gen. Journal Line".VALIDATE("Debit Amount", DecGGenAmout)
                        else
                            "Gen. Journal Line".VALIDATE("Credit Amount", DecGGenAmout);
                        //TODO : "Entry Type" is removed
                        // if CodGEntrytype = 'N' then
                        //     "Gen. Journal Line".VALIDATE("Entry Type", "Gen. Journal Line"."Entry Type"::Definitive)
                        // else
                        //     "Gen. Journal Line".VALIDATE("Entry Type", "Gen. Journal Line"."Entry Type"::Simulation);

                        if CodGCurrencyCode <> RecGGLSetup."LCY Code" then
                            "Gen. Journal Line".VALIDATE("Currency Code", CodGCurrencyCode)
                        else
                            "Gen. Journal Line".VALIDATE("Currency Code", '');

                        if BooGInsertDimension then begin
                            if RecGGLSetup."Shortcut Dimension 1 Code" = CodGNumAxe then
                                "Gen. Journal Line".VALIDATE("Gen. Journal Line"."Shortcut Dimension 1 Code", CodGNumSection);
                            if RecGGLSetup."Shortcut Dimension 2 Code" = CodGNumAxe then
                                "Gen. Journal Line".VALIDATE("Gen. Journal Line"."Shortcut Dimension 2 Code", CodGNumSection);
                        end;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(TxtGFilename; TxtGFilename)
                    {
                        AssistEdit = true;
                        Caption = 'File Name';

                        trigger OnAssistEdit()
                        var
                            CduLFileManagement: Codeunit "File Management";
                        begin
                            //TODO : OpenFileDialog not found 
                            // TxtGFilename := CduLFileManagement.OpenFileDialog('Import OD paie SAGE L100', 'OD', TXTFileType)
                        end;
                    }
                    field(CodGGenJnlTempl; CodGGenJnlTempl)
                    {
                        Caption = 'Gen. Jnl. Template Name';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            CLEAR(RecGGenJnlTempl);
                            RecGGenJnlTempl.SETRANGE(Recurring, false);
                            RecGGenJnlTempl.SETRANGE(Type, RecGGenJnlTempl.Type::General);

                            if PAGE.RUNMODAL(0, RecGGenJnlTempl) = ACTION::LookupOK then begin
                                CodGGenJnlBatch := '';
                                CodGGenJnlTempl := RecGGenJnlTempl.Name;
                            end;
                        end;
                    }
                    field(CodGGenJnlBatch; CodGGenJnlBatch)
                    {
                        Caption = 'Gen. Jnl. Batch Name';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            CLEAR(RecGGenJnlBatch);
                            RecGGenJnlBatch.SETRANGE("Journal Template Name", RecGGenJnlTempl.Name);

                            if PAGE.RUNMODAL(0, RecGGenJnlBatch) = ACTION::LookupOK then
                                CodGGenJnlBatch := RecGGenJnlBatch.Name;
                        end;
                    }
                    field(BooGInsertDimension; BooGInsertDimension)
                    {
                        Caption = 'Insert Dimension';
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        currXMLport.FILENAME := TxtGFilename;

        RecGGenJnlLine.RESET();
        RecGGenJnlLine.SETRANGE("Journal Template Name", CodGGenJnlTempl);
        RecGGenJnlLine.SETRANGE("Journal Batch Name", CodGGenJnlBatch);
        if RecGGenJnlLine.FIND('+') then
            IntGLineNo := RecGGenJnlLine."Line No." + 10000;

        COMMIT();
        if RecGGenJnlBatch."No. Series" <> '' then begin
            CLEAR(NoSeriesMgt);
            CodGDocNo := NoSeriesMgt.TryGetNextNo(RecGGenJnlBatch."No. Series", WORKDATE());
        end;

        RecGGLSetup.GET();
    end;

    var
        RecGGenJnlBatch: Record "Gen. Journal Batch";
        RecGGenJnlLine: Record "Gen. Journal Line";
        RecGGenJnlTempl: Record "Gen. Journal Template";
        RecGGLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BooGInsertDimension: Boolean;
        CodGDocNo: Code[20];
        CodGGenJnlBatch: Code[10];
        CodGGenJnlTempl: Code[10];
        DatGPostingDate: Date;
        DecGGenAmout: Decimal;
        IntGLineNo: Integer;
        TxtGFilename: Text[250];
        TXTFileType: Label 'Text Files (*.txt)|*.txt', Comment = '{Split=r''\|''}{Locked=s''1''}';

    procedure TestAccountNo(CodLAccountNo: Code[13]) BooLReturn: Boolean
    var
        RecLGLAccount2: Record "G/L Account";
        RecLGLAccount: Record "G/L Account";
        TxtL001: Label 'The G/L Account No. %1 does not exist. Do you want to create it?';
        TxtL002: Label 'Created during Pay Import';
    begin
        if not RecLGLAccount.GET(CodLAccountNo) then begin
            if CONFIRM(STRSUBSTNO(TxtL001, CodLAccountNo)) then begin
                RecLGLAccount2.INIT();
                RecLGLAccount2.VALIDATE("No.", CodLAccountNo);
                RecLGLAccount2.VALIDATE(Name, TxtL002);
                RecLGLAccount2.VALIDATE("Account Type", RecLGLAccount2."Account Type"::Posting);
                RecLGLAccount2.VALIDATE("Income/Balance", RecLGLAccount2."Income/Balance"::"Balance Sheet");
                RecLGLAccount2.VALIDATE("Debit/Credit", RecLGLAccount2."Debit/Credit"::Both);
                RecLGLAccount2.VALIDATE("Direct Posting", true);
                RecLGLAccount2.VALIDATE(Indentation, 2);
                RecLGLAccount2.INSERT(true);
                BooLReturn := true;
            end else
                BooLReturn := false;
        end else
            BooLReturn := true;
    end;
}

