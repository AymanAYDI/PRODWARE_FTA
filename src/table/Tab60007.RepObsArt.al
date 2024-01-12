namespace Prodware.FTA;
table 60007 "Rep Obs Art"
{

    fields
    {
        field(1; AOCDIR; Code[8])
        {
        }
        field(2; AONOLI; Code[4])
        {
        }
        field(3; AOOBS; Text[50])
        {
        }
        field(4; AOFLG1; Text[1])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; AOCDIR, AONOLI, AOOBS, AOFLG1)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

