namespace Prodware.FTA;

using Microsoft.Sales.Document;
pageextension 50015 SalesCreditMemo extends "Sales Credit Memo" //44
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Customer India Product"; rec."Customer India Product")
            {
                ToolTip = 'Specifies the value of the Customer India Product field.';
                ApplicationArea = All;
            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("Fax No."; rec."Fax No.")
            {
                ToolTip = 'Specifies the value of the Fax No. field.';
                ApplicationArea = All;
            }
            field("E-Mail"; rec."E-Mail")
            {
                ToolTip = 'Specifies the value of the E-Mail field.';
                ApplicationArea = All;
            }
            field("Subject Mail"; rec."Subject Mail")
            {
                ToolTip = 'Specifies the value of the Sujet Mail field.';
                ApplicationArea = All;
            }
        }
    }
}

