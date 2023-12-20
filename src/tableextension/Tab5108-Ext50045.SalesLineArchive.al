namespace Prodware.FTA;

using Microsoft.Sales.Archive;
tableextension 50045 SalesLineArchive extends "Sales Line Archive" //5108
{
    fields
    {
        field(51000; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordered';
        }
        field(51001; "Qty Shipped on Order"; Decimal)
        {
            Caption = 'Qty Shipped on Order';
        }
    }
    keys
    {
        key(Key50000; "Document Type", Type, "No.")
        {
        }
    }
}

