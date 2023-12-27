
namespace Prodware.FTA;

using Microsoft.Inventory.Journal;

pageextension 50052 RecurringItemJnl extends "Recurring Item Jnl." //286
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>NDBI
    // LALE.PA 17/12/2020 cf TDD_FTA_Modification_Taille_du_champ_N°Emplacement_dans_Table_Article_V0 - Conception personnalisations_BaseInstallée V2 suite TI514723 (P26959_004)
    //         Add Field "Shelf No."
    //         Add C/AL Code in trigger Item No. - OnValidate()
    // 
    // ------------------------------------------------------------------------

    layout
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.CALCFIELDS("Shelf No.");
            end;

        }
        addafter(Description)
        {
            field("Shelf No."; Rec."Shelf No.")
            {
            }
        }
    }
}

