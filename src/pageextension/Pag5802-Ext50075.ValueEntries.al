namespace Prodware.FTA;

using Microsoft.Inventory.Ledger;

pageextension 50075 ValueEntries extends "Value Entries" //5802
{
    layout
    {


        addafter("Salespers./Purch. Code")
        {
            field("Mobile Salesperson Code"; Rec."Mobile Salesperson Code")
            {
                Visible = false;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
                ApplicationArea = All;
            }
        }

    }
}

