
namespace Prodware.FTA;

using Microsoft.Inventory.BOM;
using Microsoft.Inventory.Item;
pageextension 50011 WhereUsedList extends "Where-Used List" //37
{
    layout
    {
        addafter("Position")
        {
            field(CalcInventory; CalcInventory(Rec."Parent Item No."))
            {
                Caption = 'Inventory';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inventory field.';
            }
            field(CalcAvailableInvt; CalcAvailableInvt(Rec."Parent Item No."))
            {
                Caption = 'Available';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Available field.';
            }
        }
    }

    local procedure CalcInventory(ItemNo: Code[20]): Decimal
    var
        Item: Record "Item";
    begin
        IF Item.GET(ItemNo) THEN BEGIN
            Item.CALCFIELDS(Inventory);
            EXIT(Item.Inventory);
        END;

        EXIT(0);
    end;

    local procedure CalcAvailableInvt(ItemNo: Code[20]): Decimal
    var
        Item: Record Item;
    begin
        IF Item.GET(ItemNo) THEN BEGIN
            Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Reserved Qty. on Purch. Orders", "Qty. on Asm. Component");
            EXIT(Item.Inventory - (Item."Qty. on Sales Order" + Item."Qty. on Asm. Component") + Item."Reserved Qty. on Purch. Orders");
        END;

        EXIT(0);
    end;
}

