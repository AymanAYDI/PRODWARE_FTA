report 50008 "Calculate Kit Price Item"
{

    Caption = 'Calculate Kit Price';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where("Assembly BOM" = filter(true));
            RequestFilterFields = "No.", "Vendor No.";

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "No.");

                FctCalcKitPriceFTA(Item, BooGMonoLevel);
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
        Text007: Label 'Item No.               #1##########\';
        Window: Dialog;
        BooGMonoLevel: Boolean;
}

