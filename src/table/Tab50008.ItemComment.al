namespace Prodware.FTA;
table 50008 "Item Comment"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'N° article';
        }
        field(3; Date; Date)
        {
            Caption = 'Date';
            Editable = false;
        }
        field(4; User; Code[50])
        {
            Caption = 'Utilisateur';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Date := TODAY;
        User := COPYSTR(USERID, 1, 50);
    end;
}

