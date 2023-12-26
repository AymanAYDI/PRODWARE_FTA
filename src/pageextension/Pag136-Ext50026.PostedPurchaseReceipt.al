namespace Prodware.FTA;

using Microsoft.Purchases.History;
pageextension 50026 "PostedPurchaseReceipt" extends "Posted Purchase Receipt" //136
{
    Editable = false;
    layout
    {
        addafter("Quote No.")
        {
            field("Order Type"; rec."Order Type")
            {
            }
        }
        addafter("Lead Time Calculation")
        {
            field("Shipping Agent Name"; rec."Shipping Agent Name")
            {
                Editable = false;
            }
            field("Shipping Order No."; rec."Shipping Order No.")
            {
                Editable = false;
            }
            field("Shipping Agent Code"; rec."Shipping Agent Code")
            {
                Editable = false;
            }
        }
    }
}
