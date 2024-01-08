namespace Prodware.FTA;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Pricing;
report 50007 "Calculate Unit Price Item"
{

    Caption = 'Calculate unit Price';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Vendor No.";

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "No.");

                FctCalcSalesPriceFTA(Item);
                MODIFY(true);
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN(
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
        Text000: Label 'Updating Unit Prices...\\';
        Text005: Label 'The item prices have now been updated in accordance with the suggested price changes.\\Do you want to delete the suggested price changes?';
        Text007: Label 'Item No.               #1##########\';
        Text008: Label 'Vendor No.             #2##########\';
        Text009: Label 'Sales Code             #3##########\';
        Text010: Label 'Currency Code          #3##########\';
        Text011: Label 'Starting Date          #4######';
        Window: Dialog;
        DeleteWhstLine: Boolean;
}

