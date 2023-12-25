namespace Prodware.FTA;
page 50021 "Customer Typology List"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>FTA1.04
    // REIMS 10/02/2017: Customer Typology on Customer Card and Sales Quote

    Caption = 'Customer Typology List';
    PageType = List;
    SourceTable = "Customer Typology";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions
    {
    }
}

