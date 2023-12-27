namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50025 PurchInvoiceSubform extends "Purch. Invoice Subform" //55
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Item No."; rec."Vendor Item No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Item No. field.';
            }
        }
    }
}

