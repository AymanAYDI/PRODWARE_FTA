namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50048 PurchaseJournal extends "Purchase Journal" //254
{

    layout
    {
        addafter(Description)
        {
            field("Posting Group "; Rec."Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Group field.';
            }
        }
        Modify("Reason Code")
        {
            Visible = true;
        }
        moveafter("ShortcutDimCode8"; "Reason Code")
    }
}

