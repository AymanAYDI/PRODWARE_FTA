table 50021 "Customer Typology"
{
    Caption = 'Customer Typology';
    //TODO: Page SPE not migrated yet
    // DrillDownPageID = 50021;
    // LookupPageID = 50021;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ExtTextHeader.SETRANGE("Table Name", ExtTextHeader."Table Name"::"Standard Text");
        ExtTextHeader.SETRANGE("No.", Code);
        ExtTextHeader.DELETEALL(true);
    end;

    var
        ExtTextHeader: Record 279;
}

