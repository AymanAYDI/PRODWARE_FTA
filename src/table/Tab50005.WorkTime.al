table 50005 "Work Time"
{
    //TODO: page 50015 Not migrated yet
    // DrillDownPageID = 50015;
    // LookupPageID = 50015;

    fields
    {
        field(1; "Time in minutes"; Integer)
        {
            Caption = 'Temps (en minutes)';

            trigger OnValidate()
            begin
                "Time in hours" := "Time in minutes" * 0.016667;
            end;
        }
        field(2; "Time in hours"; Decimal)
        {
            Caption = 'Temps (en heures)';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Time in minutes")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Time in minutes", "Time in hours")
        {
        }
    }
}

