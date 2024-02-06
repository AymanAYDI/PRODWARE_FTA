namespace Prodware.FTA;

using Microsoft.Inventory.Reports;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
reportextension 50007 "PhysInventoryList" extends "Phys. Inventory List" //722
{
    RDLCLayout = './src/reportextension/rdlc/PhysInventoryList.rdl';
    dataset
    {
        modify("Item Journal Line")
        {
            //TODO : DataItemTableView cannot be customized
            // DataItemTableView = sorting(description);
            trigger OnAfterAfterGetRecord()
            begin
                if not ItemCard.GET("Item Journal Line"."Item No.") then;
                "Bin Code" := ItemCard."Shelf No.";
            end;

        }
        add("Item Journal Line")
        {
            column(Lib_emplacement; CstTxt001)
            {
                IncludeCaption = false;
            }
            column(ItemCardNO2; ItemCard."No. 2")
            {

            }

        }
    }
    var
        ItemCard: Record Item;
        CstTxt001: label 'Shelf No.';

}
