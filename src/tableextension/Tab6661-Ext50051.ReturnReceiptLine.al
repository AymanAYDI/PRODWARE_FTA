namespace Prodware.FTA;

using Microsoft.Sales.History;
tableextension 50051 ReturnReceiptLine extends "Return Receipt Line" //6661
{
    fields
    {
        field(51000; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordred ';
        }
        field(51001; "Qty Shipped on Order"; Decimal)
        {
            Caption = 'Qty Shipped on Order';
        }
    }
}

