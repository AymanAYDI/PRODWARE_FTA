namespace Prodware.FTA;

using Microsoft.Purchases.History;
pageextension 50041 "GetReceiptLines" extends "Get Receipt Lines"//5709
{
    layout
    {

        addafter("Quantity")
        {
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ToolTip = 'Direct Unit Cost.';
                ApplicationArea = All;
            }
        }
    }
}