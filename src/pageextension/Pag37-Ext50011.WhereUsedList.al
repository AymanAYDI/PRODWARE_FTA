
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
        if Item.GET(ItemNo) then begin
            Item.CALCFIELDS(Inventory);
            exit(Item.Inventory);
        end;

        exit(0);
    end;

    local procedure CalcAvailableInvt(ItemNo: Code[20]): Decimal
    var
        Item: Record Item;
    begin
        if Item.GET(ItemNo) then begin
            Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Reserved Qty. on Purch. Orders", "Qty. on Asm. Component");
            exit(Item.Inventory - (Item."Qty. on Sales Order" + Item."Qty. on Asm. Component") + Item."Reserved Qty. on Purch. Orders");
        end;

        exit(0);
    end;
}

