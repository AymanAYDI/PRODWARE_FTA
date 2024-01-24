namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50047 SalesJournal extends "Sales Journal" //253
{
    layout
    {
        addafter(Description)
        {
            field(" Posting Group"; Rec."Posting Group")
            {
            }
        }
        moveafter(" Posting Group"; "Due Date")

    }
}

