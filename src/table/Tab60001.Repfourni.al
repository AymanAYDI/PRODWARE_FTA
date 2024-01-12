namespace Prodware.FTA;
table 60001 "Rep fourni"
{

    fields
    {
        field(1; FRCDID; Text[10])
        {
        }
        field(2; FRMODI; Text[10])
        {
        }
        field(3; FRRASO; Text[35])
        {
        }
        field(4; FRADR1; Text[35])
        {
        }
        field(5; FRADR2; Text[35])
        {
        }
        field(6; FRLOCA; Text[35])
        {
        }
        field(7; FRCDPO; Text[5])
        {
        }
        field(8; FRBRDI; Text[29])
        {
        }
        field(9; FRCDPY; Text[3])
        {
        }
        field(10; FRNTVA; Text[13])
        {
        }
        field(11; FRTELP; Text[25])
        {
        }
        field(12; FRTELC; Text[25])
        {
        }
        field(13; FRTELX; Text[25])
        {
        }
        field(14; FRAPE; Text[4])
        {
        }
        field(15; FRSIRE; Text[14])
        {
        }
        field(16; FRCRNM; Text[20])
        {
        }
        field(17; FRRGMD; Text[3])
        {
        }
        field(18; FRRGJO; Text[4])
        {
        }
        field(19; FRRGQN; Text[2])
        {
        }
        field(20; FRDFFM; Text[2])
        {
        }
        field(21; FRRGSG; Text[4])
        {
        }
        field(22; FRRGRS; Text[25])
        {
        }
        field(23; FRRGAD; Text[25])
        {
        }
        field(24; FRRGA2; Text[25])
        {
        }
        field(25; FRRGLO; Text[25])
        {
        }
        field(26; FRRGCP; Text[5])
        {
        }
        field(27; FRRGBD; Text[25])
        {
        }
        field(28; FRRGPY; Text[3])
        {
        }
        field(29; FRLVMD; Text[2])
        {
        }
        field(30; FRLVCN; Text[2])
        {
        }
        field(31; FRCDAC; Text[2])
        {
        }
        field(32; FRCDCG; Text[2])
        {
        }
        field(33; FRCDSI; Text[1])
        {
        }
        field(34; FRCTCO; Text[6])
        {
        }
        field(35; FRRTVA; Text[1])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; FRCDID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

