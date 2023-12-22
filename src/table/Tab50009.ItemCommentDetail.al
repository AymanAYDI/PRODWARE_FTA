table 50009 "Item Comment Detail"
{
    fields
    {
        field(1; "Parent Entry No."; Integer)
        {
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; "Comment Type"; Option)
        {
            OptionMembers = " ",Old,Modify,Comment;
        }
        field(4; Comment; Text[250])
        {
            Caption = 'Commentaires';
        }
    }

    keys
    {
        key(Key1; "Parent Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}

