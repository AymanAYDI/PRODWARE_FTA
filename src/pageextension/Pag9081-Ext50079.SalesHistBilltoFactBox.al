namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Archive;

pageextension 50079 SalesHistBilltoFactBox extends "Sales Hist. Bill-to FactBox" //9081
{
    layout
    {
        modify("Bill-To No. of Quotes")
        {
            Caption = 'Quotes';
            DrillDownPageID = "Sales Lines";
        }
        modify("Bill-To No. of Blanket Orders")
        {
            Caption = 'Blanket Orders';
            DrillDownPageID = "Sales Lines";
        }
        modify("Bill-To No. of Orders")
        {
            Caption = 'Orders';
            DrillDownPageID = "Sales Lines";
        }
        modify("Bill-To No. of Invoices")
        {
            Caption = 'Invoices';
            DrillDownPageID = "Sales Lines";
        }
        modify("Bill-To No. of Return Orders")
        {
            Caption = 'Return Orders';
            DrillDownPageID = "Sales Lines";
        }
        modify("Bill-To No. of Credit Memos")
        {
            Caption = 'Credit Memos';
            DrillDownPageID = "Sales Lines";
        }
        modify("Bill-To No. of Pstd. Shipments")
        {
            Caption = 'Pstd. Shipments';
            DrillDownPageID = "Posted Sales Shipment Lines";
        }
        modify("Bill-To No. of Pstd. Invoices")
        {
            Caption = 'Pstd. Invoices';
            DrillDownPageID = "Posted Sales Invoice Lines";
        }
        modify("Bill-To No. of Pstd. Cr. Memos")
        {
            Caption = 'Pstd. Credit Memos';
            DrillDownPageID = "Posted Sales Credit Memo Lines";
        }
        addafter("Bill-To No. of Pstd. Cr. Memos")
        {
            field("Bill-to No. of Archive Quotes"; Rec."Bill-to No. of Archive Quotes")
            {
                Caption = ' No. of Quotes';
                DrillDownPageID = "Sales Quote Archives";
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the  No. of Quotes field.';
            }
        }
    }
}

