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
                Window.Update(1, "Item No.");
                Window.Update(2, "Vendor No.");
                //Window.Update(3,"Sales Code");
                Window.Update(3, "Currency Code");
                Window.Update(4, "Starting Date");

                PurchasePrice.Init();
                PurchasePrice.Validate("Item No.", "Item No.");
                PurchasePrice.Validate("Vendor No.", "Vendor No.");
                //PurchasePrice.Validate("Sales Code","Sales Code");
                PurchasePrice.Validate("Unit of Measure Code", "Unit of Measure Code");
                PurchasePrice.Validate("Variant Code", "Variant Code");
                PurchasePrice.Validate("Starting Date", "Starting Date");
                PurchasePrice.Validate("Ending Date", "Ending Date");
                PurchasePrice."Minimum Quantity" := "Minimum Quantity";
                PurchasePrice."Currency Code" := "Currency Code";
                PurchasePrice."Direct Unit Cost" := "New Unit Cost";
                //PurchasePrice."Price Includes VAT" := "Price Includes VAT";
                //PurchasePrice."Allow Line Disc." := "Allow Line Disc.";
                //PurchasePrice."Allow Invoice Disc." := "Allow Invoice Disc.";
                //PurchasePrice."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
                if PurchasePrice."Direct Unit Cost" <> 0 then begin
                    if PurchasePrice."Starting Date" <> 0D then begin
                        RecGPuchPrice.SetRange("Item No.", "Item No.");
                        RecGPuchPrice.SetRange("Vendor No.", "Vendor No.");
                        RecGPuchPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
                        RecGPuchPrice.SetRange("Variant Code", "Variant Code");
                        RecGPuchPrice.SetRange("Minimum Quantity", "Minimum Quantity");
                        RecGPuchPrice.SetRange("Currency Code", "Currency Code");
                        RecGPuchPrice.SetFilter("Ending Date", '%1', 0D);
                        if RecGPuchPrice.FindSet() then
                            repeat
                                RecGPuchPrice.Validate("Ending Date", CalcDate('<-1D>', PurchasePrice."Starting Date"));
                                RecGPuchPrice.Modify(true);
                            until RecGPuchPrice.Next() = 0;
                    end;
                    if not PurchasePrice.Insert(true) then
                        PurchasePrice.Modify(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
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



    procedure InitializeRequest(NewDeleteWhstLine: Boolean)
    begin
        DeleteWhstLine := NewDeleteWhstLine;
    end;
}

