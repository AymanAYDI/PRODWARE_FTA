namespace Prodware.FTA;

using Microsoft.Sales.Document;
pageextension 50035 "SalesCreditMemos" extends "Sales Credit Memos" //9302
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Visible = false;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
                ApplicationArea = All;
            }
        }
    }
}
