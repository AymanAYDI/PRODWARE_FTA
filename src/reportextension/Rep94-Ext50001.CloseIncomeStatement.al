namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Setup;
reportextension 50001 "CloseIncomeStatement" extends "Close Income Statement" //94
{
    dataset
    {
        Modify("G/L Entry")
        {
            trigger OnAfterPreDataItem()
            begin
                //TODO : Entry Type removed 
                // SetCurrentKey( "G/L Account No.","Business Unit Code","Posting Date","Entry Type");
            end;
        }
    }
}
