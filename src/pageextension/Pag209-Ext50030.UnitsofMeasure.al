namespace Prodware.FTA;

using Microsoft.Foundation.UOM;
pageextension 50030 "UnitsofMeasure" extends "Units of Measure" //209
{
    layout
    {
        addafter(Description)
        {
            field("Unit to be printed"; rec."Unit to be printed")
            {
            }
        }
    }
}
