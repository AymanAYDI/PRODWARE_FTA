namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;
pageextension 50012 GeneralJournal extends "General Journal" //39
{
    layout
    {




        moveafter(Control120; Description, "reason code")


        addafter("Document Date")
        {
            field("Source Code"; rec."Source Code")
            {
            }
        }
        addafter("CurrentJnlBatchName")
        {
            field("Posting Group"; rec."Posting Group")
            {
            }
            field("rec.Reason Code"; Rec."Reason Code")
            {
            }

        }
    }
}

