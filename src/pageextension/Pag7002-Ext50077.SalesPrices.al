namespace Prodware.FTA;

using Microsoft.Sales.Pricing;

pageextension 50077 SalesPrices extends "Sales Prices" //7002
{

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

