namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50034 PurchInvoiceSubform extends "Purch. Invoice Subform" //55
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Item No."; rec."Vendor Item No.")
            {
            }
        }
    }
}

