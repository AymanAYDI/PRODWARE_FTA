namespace Prodware.FTA;

using Microsoft.Inventory.Ledger;
pageextension 50019 "AvailableItemLedgEntries" extends "Available - Item Ledg. Entries"
{

    PROCEDURE ReservLine();
    var
        ReservMgt: Codeunit "99000845";

    BEGIN

    //     ReservEntry.LOCKTABLE();
    //     //todo a verifier  UpdateReservMgt;
    //     ReservMgt.ItemLedgEntryUpdateValues(Rec, QtyToReserve, QtyReservedThisLine);
    //     //>>MIG NAV 2015 : Not supported
    //     //NewQtyReservedThisLine := ReservMgt.CalculateRemainingQty;
    //     ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
    //     //<<MIG NAV 2015 : Not supported

//     IF MaxQtyDefined AND (ABS(MaxQtyToReserve) < ABS(NewQtyReservedThisLine)) THEN
//         NewQtyReservedThisLine := MaxQtyToReserve;

//     ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
//     IF NewQtyReservedThisLine <> 0 THEN BEGIN
//         IF ABS(NewQtyReservedThisLine) > ABS(QtyToReserve) THEN BEGIN
//             CreateReservation(QtyToReserve);
//             MaxQtyToReserve := MaxQtyToReserve - QtyToReserve;
//         END ELSE BEGIN
//             CreateReservation(NewQtyReservedThisLine);
//             MaxQtyToReserve := MaxQtyToReserve - NewQtyReservedThisLine;
//         END;
//         IF MaxQtyToReserve < 0 THEN
//             MaxQtyToReserve := 0;
//     END ELSE
//         ERROR(Text000);
// END;

// local procedure UpdateReservMgt()
// begin
//     Clear(ReservMgt);
//     ReservMgt.SetReservSource(SourceRecRef, ReservEntry.GetTransferDirection());
//     ReservMgt.SetTrackingFromReservEntry(ReservEntry);

//     OnAfterUpdateReservMgt(ReservEntry);
// end;

//}
