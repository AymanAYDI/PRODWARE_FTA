namespace Prodware.FTA;
table 50006 "Item Production Cost"
{

    fields
    {
        field(1; "Item No."; Code[20])
        {
        }
        field(2; "Sales Min Qty"; Integer)
        {
            Caption = 'Quantité commandée';
        }
        field(3; "Unit Cost"; Decimal)
        {
            Caption = 'Coût unitaire';
        }
    }

    keys
    {
        key(Key1; "Item No.", "Sales Min Qty")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

