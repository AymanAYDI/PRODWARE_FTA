namespace Prodware.FTA;
page 50023 "Item Comment"
{
    // //>>FTA1.00
    // FTA:AM  31.03.2023  Create page

    Caption = 'Historique article';
    CardPageID = "Item Comment Card";
    PaGetype = List;
    SourceTable = "Item Comment";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(User; Rec.User)
                {
                    ToolTip = 'Specifies the value of the User field.';
                }
            }
        }
    }

    actions
    {
    }
}

