namespace Prodware.FTA;

using Microsoft.Inventory.Item.Substitution;
pageextension 50046 "ItemSubstitutionEntries" extends "Item Substitution Entries"
{

    layout
    {

        addafter("Inventory")
        {
            field("Avaibility no reserved"; Rec."Avaibility no reserved")
            {
                ToolTip = '"Avaibility no reserved" ';
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin

    end;
}