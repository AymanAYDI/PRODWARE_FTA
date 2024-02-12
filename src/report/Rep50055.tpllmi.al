namespace Prodware.FTA;
using Microsoft.Sales.Document;
report 50055 "tpl lmi"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                where("Document No." = const('C53514'));

            trigger OnAfterGetRecord()
            begin
                "Sales Line"."Internal field" := false;
                Modify();
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

