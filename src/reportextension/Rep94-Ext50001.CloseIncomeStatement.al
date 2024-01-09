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
                //TODO : I can't find solution line 140
            end;
        }
    }
}
