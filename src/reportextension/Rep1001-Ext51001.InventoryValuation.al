namespace Prodware.FTA;

using Microsoft.Inventory.Reports;
reportextension 51001 InventoryValuation extends "Inventory Valuation" //1001
{
    dataset
    {
        modify(Item)
        {
            RequestFilterFields = "No.", "Inventory Posting Group", "Statistics Group", "Vendor No.";
            //DataItemTableView = SORTING("Search Description") ORDER(Ascending); //TODO
        }
        add(Item)
        {
            column(UnitCost; Item."Unit Cost")
            {
            }
            column(UnitCostCaption; UnitCosCaptionLbl)
            {
            }
        }

    }
    var
        UnitCosCaptionLbl: Label 'Unit Cost';

}
