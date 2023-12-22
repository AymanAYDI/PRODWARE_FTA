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

            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; Rec."Mobile Salesperson Code")
            {
                Visible = false;
            }
            field("Customer Typology"; Rec."Customer Typology")
            {

            }
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
    }
}
