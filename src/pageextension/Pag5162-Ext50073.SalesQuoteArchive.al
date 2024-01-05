namespace prodware.fta;

using Microsoft.Sales.Archive;

pageextension 50073 "SalesQuoteArchive" extends "Sales Quote Archive" //5162
{
    layout
    {
        addafter("Sell-to City")
        {
            field("Cause filing"; rec."Cause filing")
            {
            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
            }
        }
    }

}
