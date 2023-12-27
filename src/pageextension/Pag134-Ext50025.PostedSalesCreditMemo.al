namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50025 "PostedSalesCreditMemo" extends "Posted Sales Credit Memo" //134
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
        }
        addafter("No. Printed")
        {
            field("Fax No."; rec."Fax No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Fax No. field.';
            }
            field("E-Mail"; rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the E-Mail field.';
            }
            field("Subject Mail"; rec."Subject Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Subject Mail field.';
            }
        }
    }
}
