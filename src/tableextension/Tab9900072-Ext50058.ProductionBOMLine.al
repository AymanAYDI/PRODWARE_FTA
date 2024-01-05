namespace Prodware.FTA;

using Microsoft.Manufacturing.ProductionBOM;
tableextension 50058 ProductionBOMLine extends "Production BOM Line" //9900072
{
    fields
    {
        field(50000; Kit; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Production BOM Header" WHERE("No." = FIELD("No.")));
            Caption = 'Kit';

            Editable = false;

        }
    }
}

