
namespace Prodware.FTA;

using Microsoft.Inventory.Journal;

pageextension 50052 RecurringItemJnl extends "Recurring Item Jnl." //286
{

    layout
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.CALCFIELDS("Shelf No.");
            end;

        }
        addafter(Description)
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }
    }
}

