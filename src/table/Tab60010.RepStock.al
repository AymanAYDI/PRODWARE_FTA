table 60010 "Rep Stock"
{

    fields
    {
        field(1; FSCDIR; Text[8])
        {
        }
        field(2; FSQCAS; Text[13])
        {
        }
        field(3; FSPAMP; Text[15])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; FSCDIR)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

