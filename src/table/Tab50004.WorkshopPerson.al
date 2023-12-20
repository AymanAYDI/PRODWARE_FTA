table 50004 "Workshop Person"
{

    Caption = 'Workshop Person';
    //TODO: page 50001 Not migrated yet
    //LookupPageID = 50001;

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

