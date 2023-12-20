namespace Prodware.FTA;

using Microsoft.Inventory.Item.Catalog;
using Microsoft.Inventory.Item;
tableextension 50020 ItemVendor extends "Item Vendor" //99
{
    fields
    {
        modify("Item No.")
        {
            TableRelation = Item where("Quote Associated" = filter(false));
        }
    }
}

