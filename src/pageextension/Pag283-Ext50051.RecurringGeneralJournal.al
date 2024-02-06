
namespace Prodware.FTA;

using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50051 RecurringGeneralJournal extends "Recurring General Journal" //283
{

    layout
    {
        addafter(Description)
        {
            field("Posting Group "; Rec."Posting Group")
            {
                ToolTip = 'Specifies the value of the Posting Group field.';
                ApplicationArea = All;
            }

        }
    }
}

