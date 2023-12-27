namespace Prodware.FTA;

using Microsoft.Purchases.History;
pageextension 50039 "PostedPurchaseReceipt" extends "Posted Purchase Receipt" //136
{
    Editable = false;
    layout
    {
        addafter("Quote No.")
        {
            field("Order Type"; rec."Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Type field.';
            }
        }
        addafter("Lead Time Calculation")
        {
            field("Shipping Agent Name"; rec."Shipping Agent Name")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Agent Name field.';
            }
            field("Shipping Order No."; rec."Shipping Order No.")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Order No. field.';
            }
            field("Shipping Agent Code"; rec."Shipping Agent Code")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Agent Code field.';
            }
        }
    }
}
