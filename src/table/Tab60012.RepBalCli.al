namespace Prodware.FTA;
table 60012 "Rep Bal Cli"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(3; CPHIST; Text[30])
        {
        }
        field(4; CPARTI; Text[15])
        {
        }
        field(5; CPJRNL; Text[15])
        {
        }
        field(6; CPWWW1; Text[15])
        {
        }
        field(7; CPIECE; Text[15])
        {
        }
        field(8; ZONE06; Text[30])
        {
        }
        field(9; CPLIB1; Text[30])
        {
        }
        field(10; CPNFAC; Text[30])
        {
        }
        field(11; CPLIB2; Text[30])
        {
        }
        field(12; CPCPTE; Text[30])
        {
        }
        field(13; CPCNTR; Text[30])
        {
        }
        field(14; CPBANQ; Text[30])
        {
        }
        field(15; CPAUXI; Text[30])
        {
        }
        field(16; CPDEBI; Text[30])
        {
        }
        field(17; CPCRED; Text[30])
        {
        }
        field(18; CPFLG1; Text[30])
        {
        }
        field(19; DTEMOD; Text[30])
        {
        }
        field(20; CPTYPE; Text[30])
        {
        }
        field(21; CPCPAU; Text[30])
        {
        }
        field(22; CPRESV; Text[30])
        {
        }
        field(23; CPFLG2; Text[30])
        {
        }
        field(24; CPDLET; Text[30])
        {
        }
        field(25; CPCLES; Text[30])
        {
        }
        field(26; CPAUXE; Text[30])
        {
        }
        field(27; CPDEC1; Text[30])
        {
        }
        field(28; CPDEC2; Text[30])
        {
        }
        field(29; DTECMA; Text[30])
        {
        }
        field(30; CPINDL; Text[30])
        {
        }
        field(31; CPFLG3; Text[30])
        {
        }
        field(32; CPFLG4; Text[30])
        {
        }
        field(33; CPREMB; Text[30])
        {
        }
        field(34; CPDAIL; Text[30])
        {
        }
        field(35; CPOINT; Text[30])
        {
        }
        field(36; CPWWW2; Text[30])
        {
        }
        field(37; CPWWW3; Text[30])
        {
        }
        field(38; CPMPAR; Text[30])
        {
        }
        field(39; CPNREL; Text[30])
        {
        }
        field(40; DTEREL; Text[30])
        {
        }
        field(41; CPLIGF; Text[30])
        {
        }
        field(42; CPECRF; Text[30])
        {
        }
        field(43; CPACCF; Text[30])
        {
        }
        field(44; CPANLT; Text[30])
        {
        }
        field(45; CPQTEA; Text[30])
        {
        }
        field(46; CPDEVD; Text[30])
        {
        }
        field(47; CPDEVC; Text[30])
        {
        }
        field(48; CPDEVI; Text[30])
        {
        }
        field(49; CPCOUR; Text[30])
        {
        }
        field(50; CPMVTD; Text[30])
        {
        }
        field(51; CPTAUX; Text[30])
        {
        }
        field(52; CPFAIP; Text[30])
        {
        }
        field(53; CPANIP; Text[30])
        {
        }
        field(54; CPEUDB; Text[30])
        {
        }
        field(55; CPEUCR; Text[30])
        {
        }
        field(56; CPEUPA; Text[30])
        {
        }
        field(57; CPEUEF; Text[30])
        {
        }
        field(58; CPFI02; Text[30])
        {
        }
        field(59; CPFI03; Text[30])
        {
        }
        field(60; CPFI04; Text[30])
        {
        }
        field(61; CPFI05; Text[30])
        {
        }
        field(70; Imported; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        RecLRepBalTiers: Record "Rep Bal Cli";
    begin
        if "Entry No." = 0 then
            if RecLRepBalTiers.FindLast() then
                "Entry No." := RecLRepBalTiers."Entry No." + 1
            else
                "Entry No." := 1;
    end;
}

