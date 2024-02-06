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
            }
        }
        modify("Quantity Avail. on Shpt. Date")
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    begin
        rec."Avaibility no reserved" := rec.CalcAvailableNoReserv();
    end;
}
