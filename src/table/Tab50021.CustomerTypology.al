table 50021 "Customer Typology"
{
    Caption = 'Customer Typology';
    DrillDownPageID = "Customer Typology List";
    LookupPageID = "Customer Typology List";

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
        ExtTextHeader: Record "Extended Text Header";
}

