
namespace Prodware.FTA;

using Microsoft.Sales.Pricing;
using Microsoft.Inventory.Item;
tableextension 50070 SalesLineDiscount extends "Sales Line Discount"
{
    fields
    {
        modify(Code)
        {
            TableRelation = IF (Type = CONST(Item)) Item WHERE("Quote Associated" = FILTER(false))
            ELSE
            IF (Type = CONST("Item Disc. Group")) "Item Discount Group";
        }


        field(50000; "Item Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD(Code)));
            Caption = 'Description';

            Editable = false;

        }
        field(50001; "Item No. 2"; Code[20])
        {

            FieldClass = FlowField;

            CalcFormula = Lookup(Item."No. 2" WHERE("No." = FIELD(Code)));
            Caption = 'No. 2';

            Editable = false;

        }
    }

}