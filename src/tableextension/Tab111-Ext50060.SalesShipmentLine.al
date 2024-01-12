tableextension 50060 SalesShipmentLine extends "Sales Shipment Line" //111
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
    keys
    {
        key(Key50; "Shortcut Dimension 1 Code", "Document No.")
        {
        }
    }
}

