namespace Prodware.FTA;

using Microsoft.Sales.Document;

pageextension 50096 SalesOrderList extends "Sales Order List" //9305
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
        addafter("Job Queue Status")
        {
            field("Customer Dispute"; Rec."Customer Dispute")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Dispute field.';
            }
            field("Auto AR Blocked"; Rec."Auto AR Blocked")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Auto AR Blocked field.';
            }
        }
    }

}
