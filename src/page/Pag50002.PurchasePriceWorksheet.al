page 50002 "Purchase Price Worksheet"
{
    Caption = 'Purchase Price Worksheet';
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Purchase Price Worksheet";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Repeater)
            {
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Item No. 2"; Rec."Item No. 2")
                {
                    ToolTip = 'Specifies the value of the No. 2 field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ToolTip = 'Specifies the value of the Minimum Quantity field.';
                }
                field("Current Unit Cost"; Rec."Current Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Current Unit Cost field.';
                }
                field("New Unit Cost"; Rec."New Unit Cost")
                {
                    ToolTip = 'Specifies the value of the New Unit Price field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Suggest &Item Price on Wksh.")
                {
                    Caption = 'Suggest &Item Price on Wksh.';
                    Ellipsis = true;
                    Image = SuggestItemPrice;
                    Visible = false;
                    ToolTip = 'Executes the Suggest &Item Price on Wksh. action.';
                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Suggest Item Price on Wksh.", true, true);
                    end;
                }
                //TODO-> Reports Specifiques
                // action("Suggest &Purchase Price on Wksh.")
                // {
                //     Caption = 'Suggest &Purchase Price on Wksh.';
                //     Ellipsis = true;
                //     ToolTip = 'Executes the Suggest &Purchase Price on Wksh. action.';
                //     trigger OnAction()
                //     begin
                //         REPORT.RUNMODAL(REPORT::"Suggest Purch. Price on Wksh.", TRUE, TRUE);
                //     end;
                // }
                // action("I&mplement Price Change")
                // {
                //     Caption = 'I&mplement Price Change';
                //     Ellipsis = true;
                //     ToolTip = 'Executes the I&mplement Price Change action.';
                //     trigger OnAction()
                //     begin
                //         REPORT.RUNMODAL(REPORT::"Implement Purch. Price Change", TRUE, TRUE, Rec);
                //     end;
                // }
            }
        }
    }
}

