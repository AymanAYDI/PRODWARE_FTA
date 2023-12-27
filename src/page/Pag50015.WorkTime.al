namespace Prodware.FTA;


page 50015 "Work Time"
{
    PageType = List;
    SourceTable = "Work Time";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Time in minutes"; Rec."Time in minutes")
                {
                    ToolTip = 'Specifies the value of the Time in minutes field.';
                }
                field("Time in hours"; Rec."Time in hours")
                {
                    ToolTip = 'Specifies the value of the Time in hours field.';
                }
            }
        }
    }

    actions
    {
    }
}

