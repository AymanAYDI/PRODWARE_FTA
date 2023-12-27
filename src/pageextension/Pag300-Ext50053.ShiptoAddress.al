
namespace Prodware.FTA;

using Microsoft.Sales.Customer;

pageextension 50053 ShiptoAddress extends "Ship-to Address" //300
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:NI 20/06/2008 [Parametres_DEB]
    //                    - ADD new Tab "International"
    // 
    // ------------------------------------------------------------------------

    layout
    {
        addafter("Customer No.")
        {
            group(International)
            {
                Caption = 'International';
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Exit Point"; Rec."Exit Point")
                {
                }
                field("Area"; Rec.Area)
                {
                }
            }
        }
    }
}

