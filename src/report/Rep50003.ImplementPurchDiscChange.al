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
                Window.UPDATE(1, "Item No.");
                Window.UPDATE(2, "Vendor No.");
                //Window.UPDATE(3,"Sales Code");
                Window.UPDATE(3, "Currency Code");
                Window.UPDATE(4, "Starting Date");

                PurchLineDiscount.INIT();
                PurchLineDiscount.VALIDATE("Item No.", "Item No.");
                PurchLineDiscount.VALIDATE("Vendor No.", "Vendor No.");
                //PurchLineDiscount.VALIDATE("Sales Code","Sales Code");
                PurchLineDiscount.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                PurchLineDiscount.VALIDATE("Variant Code", "Variant Code");
                PurchLineDiscount.VALIDATE("Starting Date", "Starting Date");
                PurchLineDiscount.VALIDATE("Ending Date", "Ending Date");
                PurchLineDiscount."Minimum Quantity" := "Minimum Quantity";
                PurchLineDiscount."Currency Code" := "Currency Code";
                PurchLineDiscount."Line Discount %" := "New Line Discount %";
                //PurchLineDiscount."Price Includes VAT" := "Price Includes VAT";
                //PurchLineDiscount."Allow Line Disc." := "Allow Line Disc.";
                //PurchLineDiscount."Allow Invoice Disc." := "Allow Invoice Disc.";
                //PurchLineDiscount."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
                if PurchLineDiscount."Line Discount %" <> 0 then begin
                    if PurchLineDiscount."Starting Date" <> 0D then begin
                        RecGPuchLineDisc.SETRANGE("Item No.", "Item No.");
                        RecGPuchLineDisc.SETRANGE("Vendor No.", "Vendor No.");
                        RecGPuchLineDisc.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
                        RecGPuchLineDisc.SETRANGE("Variant Code", "Variant Code");
                        RecGPuchLineDisc.SETRANGE("Minimum Quantity", "Minimum Quantity");
                        RecGPuchLineDisc.SETRANGE("Currency Code", "Currency Code");
                        RecGPuchLineDisc.SETFILTER("Ending Date", '%1', 0D);
                        if RecGPuchLineDisc.FINDSET() then
                            repeat
                                RecGPuchLineDisc.VALIDATE("Ending Date", CALCDATE('<-1D>', PurchLineDiscount."Starting Date"));
                                RecGPuchLineDisc.MODIFY(true);
                            until RecGPuchLineDisc.NEXT() = 0;
                    end;

                    if not PurchLineDiscount.INSERT(true) then
                        PurchLineDiscount.MODIFY(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN(
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

