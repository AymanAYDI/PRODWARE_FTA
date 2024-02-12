report 50005 "Generate Purchase Order"
{
    Caption = 'Generate Purchase Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = where("Vendor No." = filter(<> ''), "Selected for Order" = const(true));
            RequestFilterFields = "Vendor No.";

            trigger OnAfterGetRecord()
            begin
                CurrReport.Break();
            end;

            trigger OnPreDataItem()
            begin
                if GetFilter("Vendor No.") = '' then
                    Error(CstG001);
                RecGVendor.Get(GetFilter("Vendor No."));
                CodPDocNo := '';
                FctCreatePurchaseOrderLine(RecPSalesLine, CodPDocNo);
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

    trigger OnPostReport()
    begin
        if CodPDocNo <> '' then begin
            Commit();
            Clear(PageGPurchOrder);
            RecLPurchHeader.SetRange("No.", CodPDocNo);
            PageGPurchOrder.SetTableView(RecLPurchHeader);
            PageGPurchOrder.RunModal();
        end;
    end;

    var

        RecPSalesLine: Record "Sales Line";
        RecLPurchHeader: Record "Purchase Header";
        RecGVendor: Record Vendor;
        PageGPurchOrder: Page "Purchase Order";
        CstG001: Label 'Vendor Code mandatory';
        CodPDocNo: Code[20];
}

