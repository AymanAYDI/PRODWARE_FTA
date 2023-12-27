namespace Prodware.FTA;

using Microsoft.Sales.Customer;
pageextension 50006 "CustomerList" extends "Customer List" //22
{
    layout
    {
        addafter("Name")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Balance field.';
            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; Rec."Mobile Salesperson Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
            field("Customer Typology"; Rec."Customer Typology")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Typology field.';
            }
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
    }
}
