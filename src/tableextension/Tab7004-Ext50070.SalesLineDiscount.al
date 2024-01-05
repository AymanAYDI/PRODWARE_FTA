
namespace Prodware.FTA;

using Microsoft.Sales.Pricing;
using Microsoft.Inventory.Item;
tableextension 50070 SalesLineDiscount extends "Sales Line Discount" //7004
{
    fields
    {
        modify(Code)
        {
            TableRelation = if (Type = const(Item)) Item where("Quote Associated" = filter(false))
            else
            if (Type = const("Item Disc. Group")) "Item Discount Group";
        }


        field(50000; "Item Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field(Code)));
            Caption = 'Description';

            Editable = false;

        }
        field(50001; "Item No. 2"; Code[20])
        {

            FieldClass = FlowField;

            CalcFormula = lookup(Item."No. 2" where("No." = field(Code)));
            Caption = 'No. 2';

            Editable = false;

        }
    }

}