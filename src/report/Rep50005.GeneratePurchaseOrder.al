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
                CurrReport.BREAK();
            end;

            trigger OnPreDataItem()
            begin
                if GETFILTER("Vendor No.") = '' then
                    ERROR(CstG001);
                RecGVendor.GET(GETFILTER("Vendor No."));
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
            COMMIT();
            CLEAR(PageGPurchOrder);
            RecLPurchHeader.SETRANGE("No.", CodPDocNo);
            PageGPurchOrder.SETTABLEVIEW(RecLPurchHeader);
            PageGPurchOrder.RUNMODAL();
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

