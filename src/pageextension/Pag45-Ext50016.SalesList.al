namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
pageextension 50016 SalesList extends "Sales List" //45
{
    layout
    {
        addfirst("Control1")
        {
            field("Order Date"; rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date when the order was created.';
            }
        }
        addafter("No.")
        {
            field(GTel; GTel)
            {
                Caption = 'No Tel°phone ';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No Tel°phone  field.';
            }
        }
        addafter("External Document No.")
        {
            field("Your Reference"; rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s reference. The content will be printed on sales documents.';
            }
        }
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

    var
        GTel: Text[30];
        GCust: Record Customer;


    trigger OnAfterGetRecord()
    begin
        GTel := '';
        if GCust.GET(rec."Sell-to Customer No.") then
            GTel := GCust."Phone No.";
    end;
}

