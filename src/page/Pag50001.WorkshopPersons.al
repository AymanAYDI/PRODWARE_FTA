namespace Prodware.FTA;
page 50001 "Workshop Persons"
{

    Caption = 'Workshop Persons';
    PaGetype = List;
    SourceTable = "Workshop Person";
    ApplicationArea = All;

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

