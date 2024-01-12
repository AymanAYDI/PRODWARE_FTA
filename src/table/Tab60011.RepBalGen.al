namespace Prodware.FTA;
table 60011 "Rep Bal Gen"
{

    fields
    {
        field(1; BALCPT; Text[6])
        {
        }
        field(2; BALLIB; Text[30])
        {
        }
        field(3; BALDEB; Text[15])
        {
        }
        field(4; BALCRE; Text[15])
        {
        }
        field(5; BALSOD; Text[15])
        {
        }
        field(6; BALSOC; Text[15])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; BALCPT)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

