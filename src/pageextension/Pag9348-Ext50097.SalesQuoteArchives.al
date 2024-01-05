namespace Prodware.FTA;

using Microsoft.Sales.Archive;

pageextension 50097 SalesQuoteArchives extends "Sales Quote Archives" //9348
{


    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; Rec."Mobile Salesperson Code")
            {
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
                ApplicationArea = All;
            }
        }

    }
}