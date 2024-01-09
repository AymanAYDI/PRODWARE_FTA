namespace Prodware.FTA;

using Microsoft.Inventory.Reports;
using Microsoft.Inventory.Item;
reportextension 50006 "ItemRegisterQuantity" extends "Item Register - Quantity" //703
{
    RDLCLayout = './src/reportextension/rdlc/ItemRegisterQuantity.rdl';
    dataset
    {
        modify("Item Ledger Entry")
        {
            trigger OnAfterAfterGetRecord()

            begin
                if not Item1.Get("Item No.") then
                    Item1.Init();
            end;
        }
        add("Item Register")
        {
            column(ItemShelfNo; Item1."Shelf No.")
            {
            }
            column(ItemShelfNoCaption; Item1.FIELDCAPTION("Shelf No."))
            {
            }
        }
    }
    var
        Item1: Record Item;
}
