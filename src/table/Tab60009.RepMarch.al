table 60009 "Rep Marché"
{

    fields
    {
        field(1; MLTYTI; Code[1])
        {
        }
        field(2; MLCDTI; Code[10])
        {
        }
        field(3; MLCDIR; Text[8])
        {
        }
        field(4; ARCDID; Text[30])
        {
        }
        field(5; MLREFX; Text[30])
        {
        }
        field(6; MLPXVT; Text[15])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; MLTYTI, MLCDTI, MLCDIR, ARCDID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

