namespace Prodware.FTA;

using Microsoft.Purchases.Document;
report 50014 "TPL Update Order"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = const(Order));

            trigger OnAfterGetRecord()
            var
                RecLPurchaseLine: Record "Purchase Line";
            begin



                RecLPurchaseLine.Reset();
                RecLPurchaseLine.SetRange("Document Type", "Document Type");
                RecLPurchaseLine.SetRange("Document No.", "No.");
                RecLPurchaseLine.SetRange("Promised Receipt Date", 0D);
                RecLPurchaseLine.SetFilter(Quantity, '<>%1', 0);
                if RecLPurchaseLine.IsEmpty then begin
                    "Confirmed AR Order" := true;
                    Modify(false);
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Terminé');
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

