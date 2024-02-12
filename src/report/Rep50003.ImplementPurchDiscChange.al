report 50003 "Implement Purch. Disc. Change"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Item Management : Pricing
    //                           - Creation (copy from 7053 Implement Price Change)

    Caption = 'Implement Purchase Price Change';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Discount Worksheet"; "Purchase Discount Worksheet")
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

                PurchLineDiscount.Init();
                PurchLineDiscount.Validate("Item No.", "Item No.");
                PurchLineDiscount.Validate("Vendor No.", "Vendor No.");
                //PurchLineDiscount.Validate("Sales Code","Sales Code");
                PurchLineDiscount.Validate("Unit of Measure Code", "Unit of Measure Code");
                PurchLineDiscount.Validate("Variant Code", "Variant Code");
                PurchLineDiscount.Validate("Starting Date", "Starting Date");
                PurchLineDiscount.Validate("Ending Date", "Ending Date");
                PurchLineDiscount."Minimum Quantity" := "Minimum Quantity";
                PurchLineDiscount."Currency Code" := "Currency Code";
                PurchLineDiscount."Line Discount %" := "New Line Discount %";
                //PurchLineDiscount."Price Includes VAT" := "Price Includes VAT";
                //PurchLineDiscount."Allow Line Disc." := "Allow Line Disc.";
                //PurchLineDiscount."Allow Invoice Disc." := "Allow Invoice Disc.";
                //PurchLineDiscount."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
                if PurchLineDiscount."Line Discount %" <> 0 then begin
                    if PurchLineDiscount."Starting Date" <> 0D then begin
                        RecGPuchLineDisc.SetRange("Item No.", "Item No.");
                        RecGPuchLineDisc.SetRange("Vendor No.", "Vendor No.");
                        RecGPuchLineDisc.SetRange("Unit of Measure Code", "Unit of Measure Code");
                        RecGPuchLineDisc.SetRange("Variant Code", "Variant Code");
                        RecGPuchLineDisc.SetRange("Minimum Quantity", "Minimum Quantity");
                        RecGPuchLineDisc.SetRange("Currency Code", "Currency Code");
                        RecGPuchLineDisc.SetFilter("Ending Date", '%1', 0D);
                        if RecGPuchLineDisc.FindSet() then
                            repeat
                                RecGPuchLineDisc.Validate("Ending Date", CalcDate('<-1D>', PurchLineDiscount."Starting Date"));
                                RecGPuchLineDisc.Modify(true);
                            until RecGPuchLineDisc.Next() = 0;
                    end;

                    if not PurchLineDiscount.Insert(true) then
                        PurchLineDiscount.Modify(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Text000 +
                  Text007 +
                  Text008 +
                  // Text009 +
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
        PurchLineDiscount: Record "Purchase Line Discount";
        RecGPuchLineDisc: Record "Purchase Line Discount";
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

