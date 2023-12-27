namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50047 PaymentJournal extends "Payment Journal" //256
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:MA 25/06/2008 [Multi_Collectif]
    //                         - Add field "Posting Group"
    // ------------------------------------------------------------------------

    layout
    {
        addafter(Description)
        {
            field("Posting Group "; Rec."Posting Group")
            {
            }

        }
    }
}

