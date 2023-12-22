
namespace Prodware.FTA;

using Microsoft.Foundation.Shipping;

pageextension 50002 ShipmentMethods extends "Shipment Methods" //11
{
    layout
    {
        addafter("Description")
        {
            field("Shipping Costs"; rec."Shipping Costs")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Costs field.';
            }
        }
    }
}

