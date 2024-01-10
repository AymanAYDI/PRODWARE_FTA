table 50004 "Workshop Person"
{

    Caption = 'Workshop Person';
    LookupPageID = "Workshop Persons";

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

