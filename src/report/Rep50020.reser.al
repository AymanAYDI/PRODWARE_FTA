report 50020 reser
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = where("Entry No." = filter(582393 .. 582396));

            trigger OnAfterGetRecord()
            begin
                "Item Ledger Entry"."Reserved Quantity" := 0;
                MODIFY();
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

