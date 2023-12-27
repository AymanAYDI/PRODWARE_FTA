namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50047 SalesJournal extends "Sales Journal" //253
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:NI 20/06/2008 [Multi_Collectif]
    //                         - Add field "Posting Group"
    // ------------------------------------------------------------------------

    layout
    {
        addafter(Description)
        {
            field(" Posting Group"; Rec."Posting Group")
            {
            }
        }
        moveafter(" Posting Group"; "Due Date")

    }
}

