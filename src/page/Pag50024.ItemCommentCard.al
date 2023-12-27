namespace Prodware.FTA;
page 50024 "Item Comment Card"
{
    // //>>FTA1.00
    // FTA:AM  31.03.2023  Create page

    PageType = Card;
    SourceTable = "Item Comment";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
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
            part("Item Comment Detail Old"; "Item Comment Detail Old")
            {
                ShowFilter = false;
                SubPageLink = "Parent Entry No." = field("Entry No.");
                //ToolTip = 'Specifies the value of the No field.';
            }
            part("Item Comment Detail Modify"; "Item Comment Detail Modify")
            {
                ShowFilter = false;
                SubPageLink = "Parent Entry No." = field("Entry No.");
                //ToolTip = 'Specifies the value of the No field.';
            }
            part("Item Comment Detail Comment"; "Item Comment Detail Comment")
            {
                ShowFilter = false;
                SubPageLink = "Parent Entry No." = field("Entry No.");
                //ToolTip = 'Specifies the value of the No field.';
            }
        }
    }

    actions
    {
    }
}

