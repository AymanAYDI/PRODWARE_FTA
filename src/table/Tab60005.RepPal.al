table 60005 "Rep Pal"
{

    fields
    {
        field(1; PLCNAT; Code[1])
        {
        }
        field(2; PLCTYP; Code[1])
        {
        }
        field(3; PLCDIR; Text[8])
        {
        }
        field(4; PLQTE; Text[13])
        {
        }
        field(5; PLPRIX; Text[15])
        {
        }
        field(6; PLREMI; Text[7])
        {
        }
        field(7; PLCOEF; Text[7])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; PLCNAT, PLCTYP, PLCDIR, PLQTE)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

