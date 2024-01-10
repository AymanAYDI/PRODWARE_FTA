namespace Prodware.FTA;

using Microsoft.Manufacturing.ProductionBOM;
tableextension 50058 ProductionBOMLine extends "Production BOM Line" //9900072
{
    fields
    {
        field(50000; Kit; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Production BOM Header" where("No." = field("No.")));
            Caption = 'Kit';

            Editable = false;

        }
    }
}

