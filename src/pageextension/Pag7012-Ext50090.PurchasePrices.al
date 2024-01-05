namespace Prodware.FTA;

using Microsoft.Sales.Pricing;
using Microsoft.Purchases.Pricing;

pageextension 50090 PurchasePrices extends "Purchase Prices" //7012
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Item Management : Pricing
    //                          - Display field 50000 Item Description
    //                          - Display field 50001 Item No. 2

    layout
    {

        addafter("Item No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description field.';
            }
            field("Item No. 2"; Rec."Item No. 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. 2 field.';
            }

        }
    }
}

