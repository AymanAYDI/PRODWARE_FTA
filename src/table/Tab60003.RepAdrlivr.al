table 60003 "Rep Adr livr"
{

    fields
    {
        field(1; CLCDID; Code[10])
        {
        }
        field(2; CLSUFF; Text[3])
        {
        }
        field(3; CLRASO; Text[35])
        {
        }
        field(4; CLADR1; Text[35])
        {
        }
        field(5; CLADR2; Text[35])
        {
        }
        field(6; CLLOCA; Text[35])
        {
        }
        field(7; CLCDPO; Text[5])
        {
        }
        field(8; CLBRDI; Text[29])
        {
        }
        field(9; CLCDPY; Text[3])
        {
        }
        field(10; CLTELP; Text[25])
        {
        }
        field(11; CLCRNM; Text[20])
        {
        }
        field(12; CLLVMD; Text[2])
        {
        }
        field(13; CLLVCN; Text[2])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; CLCDID, CLSUFF)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

