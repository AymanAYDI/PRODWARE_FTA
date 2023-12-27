
namespace Prodware.FTA;

using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Journal;

pageextension 50051 RecurringGeneralJournal extends "Recurring General Journal" //283
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
            field("Posting Group "; Rec."Posting Group")
            {
            }

        }
    }
}

