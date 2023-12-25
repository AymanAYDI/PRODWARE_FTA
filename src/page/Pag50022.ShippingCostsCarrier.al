namespace Prodware.FTA;
page 50022 "Shipping Costs Carrier"
{
    // //>>FTA1.00
    // FTA:AM  31.03.2023  Create page

    Caption = 'Frais de port transporteur';
    PageType = List;
    SourceTable = "Shipping Costs Carrier";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Min. Weight"; Rec."Min. Weight")
                {
                    ToolTip = 'Specifies the value of the Min. Weight field.';
                }
                field("Max. Weight"; Rec."Max. Weight")
                {
                    ToolTip = 'Specifies the value of the Max. Weight field.';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ToolTip = 'Specifies the value of the Cost Amount field.';
                }
            }
        }
    }

    actions
    {
    }
}

