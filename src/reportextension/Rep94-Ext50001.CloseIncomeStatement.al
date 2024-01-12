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
                case true of
                // ClosePerBusUnit and not (ClosePerGlobalDim1 or ClosePerGlobalDim2):
                //     SETCURRENTKEY("G/L Account No.", "Business Unit Code",
                //     "Posting Date", "Entry Type");
                end;

                //TODO : ClosePerBusUnit n'est pas initialisé tj false
            end;
        }
    }
}
