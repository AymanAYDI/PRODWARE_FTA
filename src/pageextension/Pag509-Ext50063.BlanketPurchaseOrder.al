namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50063 "BlanketPurchaseOrder" extends "Blanket Purchase Order"//509
{
    layout
    {

        addafter("Pay-to Contact")
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                ToolTip = 'Vendor Posting Group"';
                ApplicationArea = All;
            }
        }
    }
}