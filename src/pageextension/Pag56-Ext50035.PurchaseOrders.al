namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50035 PurchaseOrders extends "Purchase Orders" //56
{
    layout
    {
        addafter("Outstanding Quantity")
        {
            field("Requested Receipt Date"; rec."Requested Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested Receipt Date field.';
            }
            field("Promised Receipt Date"; rec."Promised Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Promised Receipt Date field.';
            }
        }
    }
}

