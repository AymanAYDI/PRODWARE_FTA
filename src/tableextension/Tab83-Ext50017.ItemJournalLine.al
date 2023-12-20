namespace Prodware.FTA;

using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Item;
using Microsoft.CRM.Team;




tableextension 50017 ItemJournalLine extends "Item Journal Line" //83
{

    fields
    {
        modify("Item No.")

        {
            TableRelation = Item where("Quote Associated" = filter(false));


        }
        field(50000; "Shelf No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Shelf No." where("No." = field("Item No.")));
            Caption = 'Shelf No.';

            Editable = false;

        }
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';

            TableRelation = "Salesperson/Purchaser";

        }
    }
    keys
    {
        key(Key9; Description)
        {
        }
    }
}

