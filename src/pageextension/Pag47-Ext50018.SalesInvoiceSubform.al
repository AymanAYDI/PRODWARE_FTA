namespace Prodware.FTA;

using Microsoft.Sales.Document;
pageextension 50018 SalesInvoiceSubform extends "Sales Invoice Subform" //47
{
    // AutoSplitKey = true;
    // Caption = 'Lines';
    // DelayedInsert = true;
    // LinksAllowed = false;
    // MultipleNewLines = true;
    // PageType = ListPart;
    // SourceTable = "Sales Line";
    // SourceTableView = WHERE("Document Type"=FILTER(Invoice));

    layout
    {
        addafter("IC Partner Code")
        {
            field("Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.';
            }
        }

    }
}


