namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50041 "PostedSalesInvoices" extends "Posted Sales Invoices" //143
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
        }
    }
}
