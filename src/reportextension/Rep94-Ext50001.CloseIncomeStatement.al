namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Setup;
reportextension 50001 "CloseIncomeStatement" extends "Close Income Statement" //94
{
    dataset
    {
        modify("G/L Account")
        {
            trigger OnAfterPreDataItem()
            begin
                //TODO : i can't find solution 
            end;
        }
    }
}
