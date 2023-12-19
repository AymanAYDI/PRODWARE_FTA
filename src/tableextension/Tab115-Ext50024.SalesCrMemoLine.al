namespace Prodware.FTA;
using Microsoft.Sales.History;
tableextension 50024 SalesCrMemoLine extends "Sales Cr.Memo Line" //115
{
    fields
    {
        field(50041; Prepare; Boolean)
        {
            Caption = 'Préparé';

        }
        field(50044; "Parcel No."; Integer)
        {
            Caption = 'Parcel No.';

        }
        field(51000; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordered';

        }
        field(51001; "Qty Shipped on Order"; Decimal)
        {
            Caption = 'Qty Shipped on Order';

        }
    }
}

