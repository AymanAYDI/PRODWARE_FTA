namespace Prodware.FTA;
table 60004 "Rep Ens"
{

    fields
    {
        field(1; ENPFIR; Code[8])
        {
        }
        field(2; ENARIR; Text[8])
        {
        }
        field(3; ENNRLG; Text[6])
        {
        }
        field(4; ENQTEA; Text[13])
        {
        }
        field(5; ARCDID; Text[30])
        {
        }
        field(6; ARCDID01; Text[30])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; ENPFIR, ENNRLG)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

