namespace Prodware.FTA;

using Microsoft.Sales.Document;
pageextension 50016 SalesList extends "Sales List" //45
{
    layout
    {
        addfirst("Control1")
        {
            field("Order Date"; rec."Order Date")
            {
            }
        }
        addafter("No.")
        {
            field(GTel; GTel)
            {
                Caption = 'No Tel°phone ';
            }
        }
        addafter("External Document No.")
        {
            field("Your Reference"; rec."Your Reference")
            {
            }
        }
        addafter("Salesperson Code")
        {
            // field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            // {
            //     Visible = false;
            // }
        }
    }

    var
        GTel: Text[30];
        GCust: Record 18;


    trigger OnAfterGetRecord()
    begin
        GTel := '';
        if GCust.GET(rec."Sell-to Customer No.") then
            GTel := GCust."Phone No.";
    end;
}

