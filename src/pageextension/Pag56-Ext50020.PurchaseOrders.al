namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50020 PurchaseOrders extends "Purchase Orders" //56
{
    layout
    {
        addafter("Outstanding Quantity")
        {
            field("Requested Receipt Date"; rec."Requested Receipt Date")
            {
            }
            field("Promised Receipt Date"; rec."Promised Receipt Date")
            {
            }
        }
    }
}

