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
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Source Code field.';
            }
        }
        addafter("CurrentJnlBatchName")
        {
            field("Posting Group"; rec."Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the posting group that will be used in posting the journal line.The field is used only if the account type is either customer or vendor.';
            }
            field("rec.Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
            }

        }
    }
}

