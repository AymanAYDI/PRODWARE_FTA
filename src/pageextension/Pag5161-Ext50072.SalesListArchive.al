namespace prodware.fta;

using Microsoft.Sales.Archive;

pageextension 50072 "SalesListArchive" extends "Sales List Archive" //5161
{
    layout
    {

        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
        }

    }
}
