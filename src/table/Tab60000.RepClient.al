table 60000 "Rep Client"
{

    fields
    {
        field(1; CTCDID; Code[10])
        {
        }
        field(2; CTMODI; Text[35])
        {
        }
        field(3; CTRASO; Text[35])
        {
        }
        field(4; CTADR1; Text[35])
        {
        }
        field(5; CTADR2; Text[35])
        {
        }
        field(6; CTLOCA; Text[35])
        {
        }
        field(7; CTCDPO; Text[5])
        {
        }
        field(8; CTBRDI; Text[29])
        {
        }
        field(9; CTCDPY; Text[3])
        {
        }
        field(10; CTNTVA; Text[13])
        {
        }
        field(11; CTTELP; Text[25])
        {
        }
        field(12; CTTELC; Text[25])
        {
        }
        field(13; CTTELX; Text[25])
        {
        }
        field(14; CTAPE; Text[4])
        {
        }
        field(15; CTSIRE; Text[14])
        {
        }
        field(16; CTCRNM; Text[20])
        {
        }
        field(17; CTRGMD; Text[3])
        {
        }
        field(18; CTRGJO; Text[4])
        {
        }
        field(19; CTRGQN; Text[2])
        {
        }
        field(20; CTDFFM; Text[2])
        {
        }
        field(21; CTBQCD; Text[5])
        {
        }
        field(22; CTBQGC; Text[5])
        {
        }
        field(23; CTBQCP; Text[11])
        {
        }
        field(24; CTBQRB; Text[2])
        {
        }
        field(25; CTDOM1; Text[25])
        {
        }
        field(26; CTDOM2; Text[25])
        {
        }
        field(27; CTCTCR; Text[20])
        {
        }
        field(28; CTLVMD; Text[2])
        {
        }
        field(29; CTLVCN; Text[2])
        {
        }
        field(30; CTFRNV; Text[8])
        {
        }
        field(31; CTFARE; Text[1])
        {
        }
        field(32; CTNBFA; Text[2])
        {
        }
        field(33; CTRTVA; Text[1])
        {
        }
        field(34; CTCDSI; Text[1])
        {
        }
        field(35; CTCDCG; Text[2])
        {
        }
        field(36; CTCDSG; Text[2])
        {
        }
        field(37; CTCDLG; Text[3])
        {
        }
        field(38; CTCDRP; Text[2])
        {
        }
        field(39; CTCTCO; Text[6])
        {
        }
        field(40; CTCDAR; Text[1])
        {
        }
        field(41; CTVLBL; Text[1])
        {
        }
        field(42; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; CTCDID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

