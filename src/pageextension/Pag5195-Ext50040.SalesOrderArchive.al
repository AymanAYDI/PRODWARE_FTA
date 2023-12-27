
namespace Prodware.FTA;

using Microsoft.Sales.Archive;


pageextension 50040 "SalesOrderArchive" extends "Sales Order Archive"//5195
{
    layout
    {
        addafter("Sell-to Contact")
        {
            field("Your Reference"; rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Your Reference".';
            }
        }
        addbefore("Campaign No.")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'Mobile Salesperson Code';
            }
        }
    }
}



