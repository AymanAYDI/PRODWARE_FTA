report 50040 TI357187
{
    Permissions = TableData "Item Ledger Entry" = rimd,
                  TableData "Value Entry" = rimd;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = where("Entry Type" = filter(Output),
                                      "Completely Invoiced" = const(false));
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item Ledger Entry No." = field("Entry No.");

                trigger OnAfterGetRecord()
                begin
                    "Value Entry"."Invoiced Quantity" := "Item Ledger Entry".Quantity;
                    "Value Entry"."Cost Amount (Actual)" := "Value Entry"."Cost Amount (Expected)";
                    "Value Entry"."Cost Amount (Expected)" := 0;
                    "Value Entry"."Expected Cost" := false;
                    Modify();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Item Ledger Entry"."Invoiced Quantity" := "Item Ledger Entry".Quantity;
                "Item Ledger Entry"."Completely Invoiced" := true;
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

