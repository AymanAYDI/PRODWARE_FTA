table 51025 "Shipping Agent Price"
{
    Caption = 'Shipping Agent Price';
    DataCaptionFields = "Shipping Agent";

    fields
    {
        field(1; "Shipping Agent"; Code[10])
        {
            Caption = 'Shipping Agent';
            TableRelation = "Shipping Agent";
        }
        field(2; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
        }
        field(3; "Departement Code"; Code[2])
        {
            Caption = 'Departement Code';
        }
        field(4; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidatePostCode(City, "Post Code", PostCode.County, "Country Code", true);
            end;
        }
        field(5; "Pallet Nb"; Decimal)
        {
            Caption = 'Pallet Nb';
        }
        field(6; "Beginning Date"; Date)
        {
            Caption = 'Beginning Date';
        }
        field(7; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(8; City; Text[30])
        {
            Caption = 'Ville';
        }
        field(9; Status; Option)
        {
            //TODO: Table Vendor not migrated yet
            //CalcFormula = lookup(Vendor.Status where("No." = field("Shipping Agent")));
            Caption = 'Status';
            FieldClass = FlowField;
            OptionCaption = 'Referencing in progress,Referred,No Referred,Unreferred';
            OptionMembers = "Referencing in progress",Referred,"No Referred",Unreferred;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Shipping Agent", "Country Code", "Departement Code", "Post Code", "Pallet Nb", "Beginning Date", "Currency Code")
        {
            Clustered = true;
        }
        key(Key2; "Currency Code", Price)
        {
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record "225";
        County: Text[30];
}

