namespace Prodware.FTA;

using Microsoft.Purchases.Pricing;
using Microsoft.Inventory.Item;
tableextension 50055 PurchaseLineDiscount extends "Purchase Line Discount" //7014
{
    fields
    {
        modify("Item No.")
        {
            TableRelation = Item where("Quote Associated" = filter(false));
        }
        field(50000; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Item No. 2"; Code[20])
        {
            CalcFormula = lookup(Item."No. 2" where("No." = field("Item No.")));
            Caption = 'No. 2';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

