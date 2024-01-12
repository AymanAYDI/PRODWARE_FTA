namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Reports;
using Microsoft.Finance.GeneralLedger.Ledger;
reportextension 50008 Journals extends Journals //10801
{
    RDLCLayout = './src/reportextension/rdlc/Journals.rdl';
    dataset
    {
        add(Date)
        {
            column(GBoolCentralisationPiece; GBoolCentralisationPiece)
            {

            }
            column(ConstGText001; ConstGText001)
            {

            }
        }
        modify("G/L Entry")
        {
            trigger OnBeforeAfterGetRecord()
            var
                DisplayEntries: Boolean;
            begin
                if DisplayEntries then
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

                    end
            end;

        }
    }

    requestpage
    {
        layout
        {
            addafter("Posting Date")
            {
                field("Total by document"; GBoolCentralisationPiece)
                {
                    Caption = 'Total by document';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total by document field.';
                }
            }
            modify("Journals")
            {
                trigger OnAfterValidate()
                var
                    Display: Option Journals,"Centralized Journals","Journals and Centralization";
                begin
                end;
                //TODO : i can't find solution for OnAfterGetRecord "G/L Entry"
            }
        }

    }
    var
        RecGLEntry: Record "G/L Entry";
        RecGLEntryTEMP: Record "G/L Entry" temporary;
        ConstGText001: label 'Total by document.';
        "GBoolCentralisationPiece": Boolean;

    trigger OnPreReport()
    begin
        GBoolCentralisationPiece := true;
    end;

}
