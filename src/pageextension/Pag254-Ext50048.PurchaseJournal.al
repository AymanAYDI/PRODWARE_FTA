namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50048 PurchaseJournal extends "Purchase Journal" //254
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:NI 20/06/2008 [Multi_Collectif]
    // - Add field "Posting Group"
    // ------------------------------------------------------------------------

    layout
    {
        addafter(Description)
        {
            field("Posting Group "; Rec."Posting Group")
            {
            }
        }
        moveafter("ShortcutDimCode8"; "Reason Code")
    }
}

