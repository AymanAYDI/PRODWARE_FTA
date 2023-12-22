tableextension 50058 ProductionBOMLine extends "Production BOM Line" //99000772
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

