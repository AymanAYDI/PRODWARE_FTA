namespace Prodware.FTA;

using Microsoft.Inventory.Counting.Journal;

pageextension 50056 "PhysInventoryJournal" extends "Phys. Inventory Journal" //392
{
    layout
    {
        Modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                rec.CalcFields("Shelf No.");
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
