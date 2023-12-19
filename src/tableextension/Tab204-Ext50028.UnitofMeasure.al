namespace Prodware.FTA;

using Microsoft.Foundation.UOM;
tableextension 50028 UnitofMeasure extends "Unit of Measure" //204
{
    fields
    {
        modify(Description)
        {
            Caption = 'Description';
        }
        field(50000; "Unit to be printed"; Text[10])
        {
            Caption = 'Unit to be printed';
        }
    }
}

