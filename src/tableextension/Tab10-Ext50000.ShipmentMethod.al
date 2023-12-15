namespace Prodware.FTA;

using Microsoft.Foundation.Shipping;
tableextension 50000 ShipmentMethod extends "Shipment Method" //10
{
    fields
    {
        field(50000; "Shipping Costs"; Enum "Shipping Costs")
        {
            Caption = 'Shipping Costs';
        }
    }
}

