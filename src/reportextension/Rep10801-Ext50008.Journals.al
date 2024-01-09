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
            trigger OnAfterAfterGetRecord()
            begin
                //TODO : i can't find solution 
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
