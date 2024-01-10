pageextension 50083 "ItemSubstitutionEntries" extends "Item Substitution Entries"//5718
{

    layout
    {

        addafter("Condition")
        {
            field("Avaibility no reserved"; Rec."Avaibility no reserved")
            {
                ToolTip = 'Avaibility no reserved';
                ApplicationArea = All;
                Visible = false;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        //"Avaibility no reserved" := CalcAvailableNoReserv;
    end;
}
