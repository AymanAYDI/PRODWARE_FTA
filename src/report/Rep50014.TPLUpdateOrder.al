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



                RecLPurchaseLine.RESET();
                RecLPurchaseLine.SETRANGE("Document Type", "Document Type");
                RecLPurchaseLine.SETRANGE("Document No.", "No.");
                RecLPurchaseLine.SETRANGE("Promised Receipt Date", 0D);
                RecLPurchaseLine.SETFILTER(Quantity, '<>%1', 0);
                if RecLPurchaseLine.ISEMPTY then begin
                    "Confirmed AR Order" := true;
                    MODIFY(false);
                end;
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE('Terminé');
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

