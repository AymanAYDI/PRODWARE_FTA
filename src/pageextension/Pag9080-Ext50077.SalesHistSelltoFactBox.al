namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Archive;
pageextension 50077 "SalesHistSelltoFactBox" extends "Sales Hist. Sell-to FactBox" //9080
{
    layout
    {
        modify("No. of Quotes")
        {
            DrillDownPageID = "Sales Lines";
        }
        modify("No. of Blanket Orders")
        {
            DrillDownPageID = "Sales Lines";
        }
        modify("No. of Orders")
        {
            DrillDownPageID = "Sales Lines";
        }
        modify("No. of Invoices")
        {
            DrillDownPageID = "Sales Lines";
        }
        modify("No. of Return Orders")
        {
            DrillDownPageID = "Sales Lines";
        }
        modify("No. of Credit Memos")
        {
            DrillDownPageID = "Sales Lines";
        }
        modify("No. of Pstd. Shipments")
        {
            DrillDownPageID = "Posted Sales Shipment Lines";
        }
        modify("No. of Pstd. Invoices")
        {
            DrillDownPageID = "Posted Sales Invoice Lines";
        }
        modify("No. of Pstd. Credit Memos")
        {
            DrillDownPageID = "Posted Sales Credit Memo Lines";
        }
        addafter("No. of Pstd. Credit Memos")
        {
            field("No. of Archive Quotes"; rec."No. of Archive Quotes")
            {
                DrillDownPageID = "Sales Quote Archives";
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. of Quotes field.';
            }
        }
    }
}
