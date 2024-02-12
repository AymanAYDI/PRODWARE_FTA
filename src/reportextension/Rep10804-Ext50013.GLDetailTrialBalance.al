
namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Reports;
using Microsoft.Finance.GeneralLedger.Ledger;
reportextension 50013 "GLDetailTrialBalance" extends "G/L Detail Trial Balance"//10804
{
    RDLCLayout = './src/reportextension/rdlc/GLDetailTrialBalance.rdl';
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
                    RecGLEntryTEMP.Reset();
                    RecGLEntryTEMP.SetCurrentKey("G/L Account No.", "Document No.", "Posting Date");
                    RecGLEntryTEMP.SetRange("G/L Account No.", "G/L Account No.");
                    RecGLEntryTEMP.SetRange("Posting Date", "Posting Date");
                    RecGLEntryTEMP.SetRange("Document Type", "Document Type");
                    RecGLEntryTEMP.SetRange("Document No.", "Document No.");
                    if RecGLEntryTEMP.findFirst() then
                        CurrReport.Skip();
                    RecGLEntry.Reset();
                    RecGLEntry.SetCurrentKey("G/L Account No.", "Document No.", "Posting Date");
                    RecGLEntry.CopyFilters("G/L Entry");
                    RecGLEntry.SetRange("G/L Account No.", "G/L Account No.");
                    RecGLEntry.SetRange("Posting Date", "Posting Date");
                    RecGLEntry.SetRange("Document Type", "Document Type");
                    RecGLEntry.SetRange("Document No.", "Document No.");
                    if RecGLEntry.findFirst() then
                        repeat
                            if RecGLEntry."Entry No." > "Entry No." then begin
                                "Debit Amount" := "Debit Amount" + RecGLEntry."Debit Amount";
                                "Credit Amount" := "Credit Amount" + RecGLEntry."Credit Amount";
                            end;
                        until RecGLEntry.Next() = 0;

                    RecGLEntryTEMP.Init();
                    RecGLEntryTEMP := "G/L Entry";
                    RecGLEntryTEMP.Insert();

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
