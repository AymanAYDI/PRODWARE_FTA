namespace Prodware.FTA;
page 51026 "Shipping agent prices"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>EASY1.00
    // NAVEASY:NI 20/06/2008 [Cde_Transport]
    //                           - Create Form
    // 
    // ------------------------------------------------------------------------

    Caption = 'Shipping Agent Price';
    PageType = List;
    SourceTable = "Shipping Agent Price";

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                field("Shipping Agent"; Rec."Shipping Agent")
                {
                    ToolTip = 'Specifies the value of the Shipping Agent field.';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.';
                }
                field("Departement Code"; Rec."Departement Code")
                {
                    ToolTip = 'Specifies the value of the Departement Code field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("Pallet Nb"; Rec."Pallet Nb")
                {
                    ToolTip = 'Specifies the value of the Pallet Nb field.';
                }
                field("Beginning Date"; Rec."Beginning Date")
                {
                    ToolTip = 'Specifies the value of the Beginning Date field.';
                }
                field(Price; Rec.Price)
                {
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
            }
        }
    }

    actions
    {
    }
}

