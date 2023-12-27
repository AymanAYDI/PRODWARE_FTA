namespace Prodware.FTA;

using Microsoft.Sales.Receivables;
pageextension 50021 AppliedCustomerEntries extends "Applied Customer Entries" //61
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
        }
    }
}

