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
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Group field.';
            }
        }
        Modify("Due Date")
        {
            Visible = true;
        }
        moveafter(" Posting Group"; "Due Date")

    }
}

