namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50019 PurchaseQuote extends "Purchase Quote" //49
{
    layout
    {
        addafter("VAT Bus. Posting Group")
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s market type to link business transactions to.';
            }
        }

    }
}

