report 50009 "Calculate FTA Prices"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Item Management : Pricing
    //                           - Creation

    Caption = 'Calculate FTA Prices';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Vendor No.";

            trigger OnAfterGetRecord()
            var
                NewUseAssemblyList: Boolean;
            begin
                Window.UPDATE(1, "No.");

                FctCalcPurchasePriceFTA(Item);
                FctCalcSalesPriceFTA(Item);
                FctCalcKitPriceFTA(Item, BooGMonoLevel);
                MODIFY(true);
                CALCFIELDS("Assembly BOM");
                NewUseAssemblyList := "Assembly BOM";
                if BooGMonoLevel then
                    FTAEvent.SetParms(true, false)
                else
                    FTAEvent.SetParms(true, true);


                CalculateStdCost.CalcItem("No.", NewUseAssemblyList);
                FTAEvent.SetParms(false, false);
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
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(BooGMonoLevel; BooGMonoLevel)
                    {
                        Caption = 'Calculation On 1 level';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        BooGMonoLevel := true;
    end;

    var
        Text000: Label 'Updating Unit Prices...\\';
        Text005: Label 'The item prices have now been updated in accordance with the suggested price changes.\\Do you want to delete the suggested price changes?';
        Text007: Label 'Item No.               #1##########\';
        Text008: Label 'Vendor No.             #2##########\';
        Text009: Label 'Sales Code             #3##########\';
        Text010: Label 'Currency Code          #3##########\';
        Text011: Label 'Starting Date          #4######';
        PurchasePrice: Record 7012;
        Window: Dialog;
        DeleteWhstLine: Boolean;
        CalculateStdCost: Codeunit 5812;
        FTAEvent: Codeunit FTA_Events;
        BooGMonoLevel: Boolean;
}

