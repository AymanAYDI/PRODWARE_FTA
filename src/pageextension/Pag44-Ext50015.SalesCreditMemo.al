namespace Prodware.FTA;

using Microsoft.Sales.Document;
pageextension 50015 SalesCreditMemo extends "Sales Credit Memo" //44
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            // field("Customer India Product"; "Customer India Product")
            // {
            // }
        }
        addafter("Salesperson Code")
        {
            // field("Mobile Salesperson Code"; "Mobile Salesperson Code")
            // {
            // }
        }
        addafter(Status)
        {
            // field("Fax No."; "Fax No.")
            // {
            // }
            // field("E-Mail"; "E-Mail")
            // {
            // }
            // field("Subject Mail"; "Subject Mail")
            // {
            // }
        }
    }
}

