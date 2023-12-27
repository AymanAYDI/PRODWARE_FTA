namespace Prodware.FTA;

using Microsoft.Foundation.UOM;
pageextension 50043 "UnitsofMeasure" extends "Units of Measure" //209
{
    layout
    {
        addafter(Description)
        {
            field("Unit to be printed"; rec."Unit to be printed")
            {
                ToolTip = 'Specifies the value of the Unit to be printed field.';
                ApplicationArea = All;
            }
        }
    }
}
