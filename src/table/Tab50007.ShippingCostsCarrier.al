namespace Prodware.FTA;

using Microsoft.Foundation.Shipping;
using Microsoft.Inventory.Item;
table 50007 "Shipping Costs Carrier"
{
    Caption = 'Frais de port transporteur';

    fields
    {
        field(1; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Transporteur';
            TableRelation = "Shipping Agent";
        }
        field(2; "Min. Weight"; Decimal)
        {
            Caption = 'Poids mini';
        }
        field(3; "Max. Weight"; Decimal)
        {
            Caption = 'Poids maxi';
        }
        field(4; "Cost Amount"; Decimal)
        {
            Caption = 'Montant port';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'N° article';
            TableRelation = Item;
        }
    }

    keys
    {
        key(Key1; "Shipping Agent Code", "Min. Weight", "Max. Weight")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

