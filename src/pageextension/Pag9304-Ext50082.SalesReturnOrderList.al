namespace Prodware.FTA;

using Microsoft.Sales.Document;

pageextension 50082 SalesReturnOrderList extends "Sales Return Order List" //9304
{

    layout
    {
        addafter("Salesperson Code")
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