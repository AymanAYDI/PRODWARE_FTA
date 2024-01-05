namespace Prodware.FTA;

using Microsoft.Sales.Document;

pageextension 50081 BlanketSalesOrders extends "Blanket Sales Orders" //9303
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
