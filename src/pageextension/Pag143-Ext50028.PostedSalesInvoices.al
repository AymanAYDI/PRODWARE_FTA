namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50028 "PostedSalesInvoices" extends "Posted Sales Invoices" //143
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Visible = false;
            }
        }
    }
}
