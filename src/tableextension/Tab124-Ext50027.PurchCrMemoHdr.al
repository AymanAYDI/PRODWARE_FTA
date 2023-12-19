namespace Prodware.FTA;

using Microsoft.Purchases.History;
using Microsoft.Foundation.Shipping;
tableextension 50027 PurchCrMemoHdr extends "Purch. Cr. Memo Hdr."//124
{
    fields
    {
        field(50030; "Confirmed AR Order"; Boolean)
        {
            Caption = 'Commande AR confirmée';

        }
        field(51011; "Shipping Agent Name"; Text[50])
        {
            Caption = 'Shipping Agent Name';

        }
        field(51012; "Shipping Order No."; Code[20])
        {
            Caption = 'Shipping Order No.';

        }
        field(51023; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';

            TableRelation = "Shipping Agent";
        }
        field(51028; "Order Type"; enum "Order type")
        {
            Caption = 'Order Type';
            Description = 'NAVEASY.001 [Cde_Transport] Ajout du champ';
            Editable = false;

        }
    }
}

