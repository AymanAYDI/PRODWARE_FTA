table 60008 "Rep Obs Cli"
{

    fields
    {
        field(2; COCDID; Code[10])
        {
        }
        field(3; CONOLI; Text[4])
        {
        }
        field(4; COOBS; Text[50])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; COCDID, CONOLI, COOBS)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

