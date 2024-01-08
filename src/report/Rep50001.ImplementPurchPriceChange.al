namespace Prodware.FTA;

using Microsoft.Purchases.Pricing;
report 50001 "Implement Purch. Price Change"
{
    Caption = 'Implement Purchase Price Change';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem3883; "Purchase Price Worksheet")
        {
            DataItemTableView = sorting("Starting Date", "Ending Date", "Vendor No.", "Currency Code", "Item No.", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            RequestFilterFields = "Item No.", "Vendor No.", "Unit of Measure Code", "Currency Code";

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "Item No.");
                Window.UPDATE(2, "Vendor No.");
                //Window.UPDATE(3,"Sales Code");
                Window.UPDATE(3, "Currency Code");
                Window.UPDATE(4, "Starting Date");

                PurchasePrice.INIT();
                PurchasePrice.VALIDATE("Item No.", "Item No.");
                PurchasePrice.VALIDATE("Vendor No.", "Vendor No.");
                //PurchasePrice.VALIDATE("Sales Code","Sales Code");
                PurchasePrice.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                PurchasePrice.VALIDATE("Variant Code", "Variant Code");
                PurchasePrice.VALIDATE("Starting Date", "Starting Date");
                PurchasePrice.VALIDATE("Ending Date", "Ending Date");
                PurchasePrice."Minimum Quantity" := "Minimum Quantity";
                PurchasePrice."Currency Code" := "Currency Code";
                PurchasePrice."Direct Unit Cost" := "New Unit Cost";
                //PurchasePrice."Price Includes VAT" := "Price Includes VAT";
                //PurchasePrice."Allow Line Disc." := "Allow Line Disc.";
                //PurchasePrice."Allow Invoice Disc." := "Allow Invoice Disc.";
                //PurchasePrice."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
                if PurchasePrice."Direct Unit Cost" <> 0 then begin
                    if PurchasePrice."Starting Date" <> 0D then begin
                        RecGPuchPrice.SETRANGE("Item No.", "Item No.");
                        RecGPuchPrice.SETRANGE("Vendor No.", "Vendor No.");
                        RecGPuchPrice.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
                        RecGPuchPrice.SETRANGE("Variant Code", "Variant Code");
                        RecGPuchPrice.SETRANGE("Minimum Quantity", "Minimum Quantity");
                        RecGPuchPrice.SETRANGE("Currency Code", "Currency Code");
                        RecGPuchPrice.SETFILTER("Ending Date", '%1', 0D);
                        if RecGPuchPrice.FINDSET() then
                            repeat
                                RecGPuchPrice.VALIDATE("Ending Date", CALCDATE('<-1D>', PurchasePrice."Starting Date"));
                                RecGPuchPrice.MODIFY(true);
                            until RecGPuchPrice.NEXT() = 0;
                    end;
                    if not PurchasePrice.INSERT(true) then
                        PurchasePrice.MODIFY(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN(
                  Text000 +
                  Text007 +
                  Text008 +
                  //Text009 +
                  Text010 +
                  Text011);
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

    var
        PurchasePrice: Record "Purchase Price";
        RecGPuchPrice: Record "Purchase Price";
        Text000: Label 'Updating Unit Prices...\\';
        Text007: Label 'Item No.               #1##########\';
        Text008: Label 'Vendor No.             #2##########\';
        Text010: Label 'Currency Code          #3##########\';
        Text011: Label 'Starting Date          #4######';
        Window: Dialog;
        DeleteWhstLine: Boolean;


    [Scope('Internal')]
    procedure InitializeRequest(NewDeleteWhstLine: Boolean)
    begin
        DeleteWhstLine := NewDeleteWhstLine;
    end;
}

