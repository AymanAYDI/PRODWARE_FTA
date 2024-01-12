table 50003 "Report Email By User"
{

    fields
    {
        field(1; UserID; Code[20])
        {
            TableRelation = User;
        }
        field(2; "Report ID"; Integer)
        {
            //TODO : Scope OnPrem
            // TableRelation = Object where(Type = const(Report));
        }
        field(3; Email; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; UserID, "Report ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

