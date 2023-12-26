namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50024 "PostedSalesInvoiceSubform" extends "Posted Sales Invoice Subform" //133
{
    layout
    {
        modify("Description 2")
        {
            Visible = false;
        }
    }
}
