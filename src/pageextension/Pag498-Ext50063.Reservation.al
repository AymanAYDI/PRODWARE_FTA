
namespace prodware.fta;

using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Item;

pageextension 50063 Reservation extends Reservation //498
{
    layout
    {
        addafter("ReservEntry.""Shipment Date""")
        {
            field(ItemDecsription; RecGItem.Description + '  ' + RecGItem."Description 2")
            {
                Caption = 'ItemDescription';
                ToolTip = 'Specifies the value of the Description + ''  '' + RecGItem.Description 2 field.';
                ApplicationArea = All;
            }
            field("No. 2"; RecGItem."No. 2")
            {
                ToolTip = 'Specifies the value of the No. 2 field.';
                ApplicationArea = All;
            }
        }
    }
    // TODO ReservEntry declared on standard 
    // PROCEDURE GetReservEntry(VAR RecPReservEntry : Record "Reservation Entry");
    // BEGIN
    //     RecPReservEntry := ReservEntry;
    // END;
    PROCEDURE FctSetBooResaFTA(BooPResaFTA: Boolean);
    BEGIN
        BooGResaFTA := BooPResaFTA;
    END;

    PROCEDURE FctSetBooResaASSFTA(BooPResaAssFTA: Boolean);
    BEGIN
        BooGResaAssFTA := BooPResaAssFTA;
    END;

    PROCEDURE ReturnRec(VAR pRec: Record "Entry Summary");
    BEGIN
        pRec := Rec;
    END;

    var
        RecGItem: Record Item;
        BooGResaFTA: Boolean;
        BooGResaAssFTA: Boolean;
        CstG001: Label 'FRéservation impossible à partir de cet écran.\Revenir sur l''écran "Choix du type de préparation" pour faire la réservation !';
}
