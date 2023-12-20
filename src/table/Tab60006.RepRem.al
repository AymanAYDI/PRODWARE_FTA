table 60006 "Rep Rem"
{

    fields
    {
        field(1; RMTYTI; Code[1])
        {
        }
        field(2; RMCDTI; Code[10])
        {
        }
        field(3; RMDESI; Text[25])
        {
        }
        field(4; RMGSFR; Text[1])
        {
        }
        field(5; RMCDFO; Text[10])
        {
        }
        field(6; RMTAUX; Text[7])
        {
        }
        field(7; RMCDIR; Text[8])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; RMTYTI, RMCDTI, RMDESI, RMGSFR)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

