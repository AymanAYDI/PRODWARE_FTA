namespace prodware.fta;

using Microsoft.Foundation.Shipping;

pageextension 50058 "ShippingAgents" extends "Shipping Agents"  //428
{
    layout
    {
        addaFter("Account No.")
        {
            field("Shipping Costs"; rec."Shipping Costs")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Frais de port field.';
            }
        }
    }
}
