namespace Prodware.FTA;
using Microsoft.Sales.Document;
pageextension 50042 "SalesLines" extends "Sales Lines" //516
{
    layout
    {
        addafter("Reserved Qty. (Base)")
        {
            field("Preparation Type"; rec."Preparation Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Preparation Type field.';
            }
        }
        addafter("Job No.")
        {
            field("Kit Qty To Build Up"; rec."Kit Qty To Build Up")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Kit Qty To Build Up field.';
            }
        }
        addafter("Outstanding Quantity")
        {
            field("Unit Price"; rec."Unit Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the price for one unit on the sales line.';
            }
            field("Posting Date"; rec."Posting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Date field.';
            }
            field("Quantity Shipped"; rec."Quantity Shipped")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';
            }
            field("Quantity Invoiced"; rec."Quantity Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
            }
            field("Line Discount %"; rec."Line Discount %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
            }
            field("Unit Price Discounted"; rec."Unit Price Discounted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Price Discounted field.';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        rec.FctCalcQtyToSetOn();
    end;
}
