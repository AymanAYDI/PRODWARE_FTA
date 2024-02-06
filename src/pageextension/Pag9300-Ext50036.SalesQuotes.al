pageextension 50036 "SalesQuotes" extends "Sales Quotes"//9300
{
    layout
    {

        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; Rec."Mobile Salesperson Code")
            {
                ToolTip = 'Mobile Salesperson Code.';
                ApplicationArea = All;
            }
            field("Customer Typology"; Rec."Customer Typology")
            {
                ToolTip = '"Customer Typology"';
                ApplicationArea = All;
            }
        }
    }
}