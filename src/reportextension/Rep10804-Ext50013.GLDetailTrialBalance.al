
namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Reports;
reportextension 50013 "GLDetailTrialBalance" extends "G/L Detail Trial Balance"//10804
{
    dataset
    {
        add("G/L Account")
        {
            column(ConstGText001; ConstGText001)
            {

            }
            column(BoolCentralisationPiece; BoolCentralisationPiece)
            {

            }
        }
    }
    trigger OnPostReport()
    begin
        GBoolCentralisationPiece := TRUE;
    end;
}
