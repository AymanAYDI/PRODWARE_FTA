namespace Prodware.FTA;

using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
pageextension 10878 AvailableItemLedgEntries extends "Available - Item Ledg. Entries"//504
{
    var
        NewQtyReservedThisLineBase: Decimal;


    procedure "--FTA1.00"()
    begin
    end;

    procedure ReservLine()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";

        ReservMgt: Codeunit "Reservation Management";

        AvailableItemLedgEntries: Page "Available - Item Ledg. Entries";
    begin
        ReservEntry.LOCKTABLE();
        UpdateReservMgt();
        ItemLedgerEntry.GetReservationQty(QtyReserved, QtyToReserve); //TODO

        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);


        if MaxQtyDefined and (ABS(MaxQtyToReserve) < ABS(NewQtyReservedThisLine)) then
            NewQtyReservedThisLine := MaxQtyToReserve;

        ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
        if NewQtyReservedThisLine <> 0 then begin
            if ABS(NewQtyReservedThisLine) > ABS(QtyToReserve) then begin
                CreateReservation(QtyToReserve);
                MaxQtyToReserve := MaxQtyToReserve - QtyToReserve;
            end else begin
                AvailableItemLedgEntries.CreateReservation(NewQtyReservedThisLine);
                MaxQtyToReserve := MaxQtyToReserve - NewQtyReservedThisLine;
            end;
            if MaxQtyToReserve < 0 then
                MaxQtyToReserve := 0;
        end else
            ERROR(Text000);
    end;

    PROCEDURE CreateReservation(VAR ReserveQuantity: Decimal);
    VAR

        "Item Ledger Entry": Record "Item Ledger Entry";
        TrackingSpecification: Record "Tracking Specification";
    BEGIN
        "Item Ledger Entry".TESTFIELD("Drop Shipment", FALSE);
        "Item Ledger Entry".TESTFIELD("Item No.", ReservEntry."Item No.");
        "Item Ledger Entry".TESTFIELD("Variant Code", ReservEntry."Variant Code");
        "Item Ledger Entry".TESTFIELD("Location Code", ReservEntry."Location Code");

        IF TotalAvailQty < 0 THEN BEGIN
            ReserveQuantity := 0;
            EXIT;
        END;

        IF TotalAvailQty < ReserveQuantity THEN
            ReserveQuantity := TotalAvailQty;
        TotalAvailQty := TotalAvailQty - ReserveQuantity;

        IF (TotalAvailQty = 0) AND
           (ReserveQuantity = 0) AND
           (QtyToReserve <> 0)
        THEN
            ERROR(Text002);

        UpdateReservMgt();
        TrackingSpecification.InitTrackingSpecification(
          DATABASE::"Item Ledger Entry", 0, '', '', 0, "Item Ledger Entry"."Entry No.",
          "Item Ledger Entry"."Variant Code", "Item Ledger Entry"."Location Code", "Item Ledger Entry"."Qty. per Unit of Measure");
        ReservMgt.CreateReservation(
          ReservEntry.Description, 0D, 0, ReserveQuantity, TrackingSpecification);
        UpdateReservFrom();
    END;

    local procedure UpdateReservMgt()
    var
        ReservMgt: Codeunit "Reservation Management";
    begin
        Clear(ReservMgt);
        ReservMgt.SetReservSource(SourceRecRef, ReservEntry.GetTransferDirection());
        ReservMgt.SetTrackingFromReservEntry(ReservEntry);


    end;

    local procedure UpdateReservFrom()
    begin
        SetSource(SourceRecRef, ReservEntry, ReservEntry.GetTransferDirection());

    end;


    var
        ReservMgt: Codeunit "Reservation Management";
        NewQtyReservedThisLine: Decimal;
        Text002: label 'ENU=Reservation cannot be carried out because the available quantity is already allocated in a warehouse.;FRA=La r‚servation ne peut pas ˆtre effectu‚e car la quantit‚ disponible a d‚j… ‚t‚ affect‚e … un entrep“t.';
        Text000: label 'ENU=Fully reserved.;FRA=Tous les articles sont rservs.';

}



