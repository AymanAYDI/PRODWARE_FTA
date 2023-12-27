namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50019 PurchaseQuote extends "Purchase Quote" //49
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // 
    // NAVEASY:MA 25/06/2008 : [Multi_Collectif]
    //                          - Add field "Vendor Posting Group" sur Onglet "Facturation"
    // 
    // ------------------------------------------------------------------------

    // Caption = 'Purchase Quote';
    // PageType = Document;
    // RefreshOnActivate = true;
    // SourceTable = Table38;
    // SourceTableView = WHERE(Document Type=FILTER(Quote));

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

