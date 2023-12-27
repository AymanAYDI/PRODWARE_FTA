namespace Prodware.FTA;
page 50001 "Workshop Persons"
{

    Caption = 'Workshop Persons';
    PageType = List;
    SourceTable = "Workshop Person";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
        }
    }

    actions
    {
    }
}

