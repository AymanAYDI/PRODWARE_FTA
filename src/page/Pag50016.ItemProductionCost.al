namespace Prodware.FTA;

page 50016 "Item Production Cost"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Item Production Cost";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Min Qty"; Rec."Sales Min Qty")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Sales Min Qty field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
            }
        }
    }

    actions
    {
    }
}

