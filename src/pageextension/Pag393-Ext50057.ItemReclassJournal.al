namespace Prodware.FTA;

using Microsoft.Inventory.Journal;

pageextension 50057 "ItemReclassJournal" extends "Item Reclass. Journal" //393
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
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }
    }
}
