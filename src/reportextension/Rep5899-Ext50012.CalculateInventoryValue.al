namespace Prodware.FTA;

using Microsoft.Inventory.Journal;
reportextension 50012 "CalculateInventoryValue" extends "Calculate Inventory Value"//5899
{
    dataset
    {
        Modify("Item")
        {
            RequestFilterFields = "No.", "Costing Method", "Location Filter", "Variant Filter", "Shelf No.";
        }
    }

}
