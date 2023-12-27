namespace Prodware.FTA;

using Microsoft.Purchases.Vendor;
pageextension 50008 VendorList extends "Vendor List" //27
{
    layout
    {
        addafter("Name")
        {
            field("Balance"; rec.Balance)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Balance field.';
            }
        }
    }
}

