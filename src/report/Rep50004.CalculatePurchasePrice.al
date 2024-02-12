namespace Prodware.FTA;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Pricing;
report 50004 "Calculate Purchase Price"
{


    Caption = 'Calculate Purchase Price Base';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Vendor No.";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "No.");

                FctCalcPurchasePriceFTA(Item);
                Modify(true);
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Text000 +
                  Text007);
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
        DeleteWhstLine: Boolean;
        Window: Dialog;
        Text000: Label 'Updating Unit Prices...\\';
        Text005: Label 'The item prices have now been updated in accordance with the suggested price changes.\\Do you want to Delete the suggested price changes?';
        Text007: Label 'Item No.               #1##########\';
        Text008: Label 'Vendor No.             #2##########\';
        Text009: Label 'Sales Code             #3##########\';
        Text010: Label 'Currency Code          #3##########\';
        Text011: Label 'Starting Date          #4######';
}

