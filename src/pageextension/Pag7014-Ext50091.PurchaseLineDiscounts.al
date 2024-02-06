
namespace Prodware.FTA;

using Microsoft.Purchases.Pricing;
pageextension 50091 "PurchaseLineDiscounts" extends "Purchase Line Discounts"//7014
{
    layout
    {

        addafter("Item No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ToolTip = 'Item Description';
                ApplicationArea = All;
            }
            field("Item No. 2"; Rec."Item No. 2")
            {
                ToolTip = 'Item Description';
                ApplicationArea = All;
            }
        }
    }
}
