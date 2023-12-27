namespace Prodware.FTA;
using Microsoft.Sales.Document;
pageextension 50041 "BlanketSalesOrder" extends "Blanket Sales Order" //507
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
        }
        addafter("Bill-to Contact")
        {
            field("Customer Posting Group"; rec."Customer Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Posting Group field.';
            }
        }
    }
}
