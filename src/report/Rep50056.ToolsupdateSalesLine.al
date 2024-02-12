
namespace Prodware.FTA;

using Microsoft.Sales.Document;
report 50056 "Tools update SalesLine"
{

    // UsageCategory = ReportsAndAnalysis;


    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                where("Document No." = const('C83150'),
                                     "Line No." = const(10000));

            trigger OnAfterGetRecord()
            begin

                "Sales Line"."Outstanding Quantity" := 0;
                "Sales Line"."Qty. to Invoice" := 0;
                "Sales Line"."Qty. to Ship" := 0;
                "Sales Line"."Quantity Shipped" := 10;
                "Sales Line"."Quantity Invoiced" := 10;
                "Sales Line"."Outstanding Qty. (Base)" := 0;
                "Sales Line"."Qty. to Invoice (Base)" := 0;
                "Sales Line"."Qty. to Ship (Base)" := 0;
                "Sales Line"."Qty. Shipped (Base)" := 10;
                "Sales Line"."Qty. Invoiced (Base)" := 10;
                "Sales Line"."Completely Shipped" := true;
                "Sales Line"."Qty. Shipped Not Invoiced" := 0;
                "Sales Line"."Qty. Shipped Not Invd. (Base)" := 0;

                Modify();

                Message('ligne commande modifiée = %1, %2', "Sales Line"."Document No.", "Sales Line"."Line No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

