pageextension 50042 "ItemSubstitutionEntries" extends "Item Substitution Entries"
{

    layout
    {

        addafter("Condition")
        {
            field("Avaibility no reserved"; Rec."Avaibility no reserved")
            {
                ToolTip = 'Avaibility no reserved';
                ApplicationArea = All;
                Visible = FALSe;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        "Avaibility no reserved" := CalcAvailableNoReserv;
    end;
}
