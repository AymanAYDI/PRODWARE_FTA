
namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Reports;
using Microsoft.Finance.GeneralLedger.Ledger;
reportextension 50013 "GLDetailTrialBalance" extends "G/L Detail Trial Balance"//10804
{
    dataset
    {
        add("G/L Account")
        {
            column(ConstGText001; ConstGText001)
            {

            }
            column(BoolCentralisationPiece; GBoolCentralisationPiece)
            {
            }
        }
        modify("G/L Entry")
        {
            //TODO : verifier hadil 
            trigger OnBeforeAfterGetRecord()
            var
                RecGLEntryTEMP: Record "G/L Entry" temporary;
                RecGLEntry: Record "G/L Entry";
            begin
                if GBoolCentralisationPiece then begin
                    RecGLEntryTEMP.RESET();
                    RecGLEntryTEMP.SETCURRENTKEY("G/L Account No.", "Document No.", "Posting Date");
                    RecGLEntryTEMP.SETRANGE("G/L Account No.", "G/L Account No.");
                    RecGLEntryTEMP.SETRANGE("Posting Date", "Posting Date");
                    RecGLEntryTEMP.SETRANGE("Document Type", "Document Type");
                    RecGLEntryTEMP.SETRANGE("Document No.", "Document No.");
                    if RecGLEntryTEMP.FINDFIRST() then
                        CurrReport.SKIP();
                    RecGLEntry.RESET();
                    RecGLEntry.SETCURRENTKEY("G/L Account No.", "Document No.", "Posting Date");
                    RecGLEntry.COPYFILTERS("G/L Entry");
                    RecGLEntry.SETRANGE("G/L Account No.", "G/L Account No.");
                    RecGLEntry.SETRANGE("Posting Date", "Posting Date");
                    RecGLEntry.SETRANGE("Document Type", "Document Type");
                    RecGLEntry.SETRANGE("Document No.", "Document No.");
                    if RecGLEntry.FINDFIRST() then
                        repeat
                            if RecGLEntry."Entry No." > "Entry No." then begin
                                "Debit Amount" := "Debit Amount" + RecGLEntry."Debit Amount";
                                "Credit Amount" := "Credit Amount" + RecGLEntry."Credit Amount";
                            end;
                        until RecGLEntry.NEXT() = 0;

                    RecGLEntryTEMP.INIT();
                    RecGLEntryTEMP := "G/L Entry";
                    RecGLEntryTEMP.INSERT();

                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            addafter(SortedByDocumentNo)
            {
                field(GBoolCentralisationPiece; GBoolCentralisationPiece)
                {
                    Caption = 'Total by document';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total by document field.';
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        GBoolCentralisationPiece := true;
    end;

    var
        GBoolCentralisationPiece: Boolean;
        ConstGText001: Label 'Total by document.';
}
