namespace Prodware.FTA;

using Microsoft.Inventory.Item.Substitution;
using Microsoft.Inventory.Item;
tableextension 50047 ItemSubstitution extends "Item Substitution"//5715
{
    fields
    {
        field(50004; "Avaibility no reserved"; Decimal)
        {
            Caption = 'Avaibility';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
    }
    procedure CalcAvailableNoReserv() AvaibilityNoReserved: Decimal
    var
        Item: Record Item;
    begin
        AvaibilityNoReserved := 0;
        if Type = Type::Item then begin
            Item.GET("Substitute No.");
            if "Location Filter" <> '' then
                Item.SETRANGE("Location Filter", "Location Filter");
            Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
            AvaibilityNoReserved := Item.Inventory
                                    - Item."Qty. on Sales Order"
                                    - Item."Qty. on Asm. Component"
                                    + Item."Reserved Qty. on Purch. Orders";
        end;
    end;
}

