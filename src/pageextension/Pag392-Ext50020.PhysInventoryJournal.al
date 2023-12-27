namespace Prodware.FTA;

using Microsoft.Inventory.Counting.Journal;

pageextension 50020 "PhysInventoryJournal" extends "Phys. Inventory Journal" //392
{
    layout
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                rec.CALCFIELDS("Shelf No.");
            end;
        }
        addafter(Description)
        {
            field("Shelf No."; rec."Shelf No.")
            {
                ToolTip = 'Specifies the value of the Shelf No. field.';
                ApplicationArea = All;
            }
        }
    }
}
