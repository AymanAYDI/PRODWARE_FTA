namespace Prodware.FTA;

using Microsoft.Purchases.Document;
reportextension 50005 "BatchPostPurchaseOrders" extends "Batch Post Purchase Orders" //496
{
    dataset
    {
        modify("Purchase Header")
        {
            RequestFilterFields = "No.", Status, "Order Type";
            CalcFields = "Order Type";
            //TODO : i can't find solution for OnAfterGetRecord
        }
    }
}
