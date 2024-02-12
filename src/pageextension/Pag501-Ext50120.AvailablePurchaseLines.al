namespace Prodware.FTA;

using Microsoft.Purchases.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;

pageextension 50120 AvailablePurchaseLines extends "Available - Purchase Lines" //501
{

    actions
    {

        modify(Reserve)
        {
            trigger OnAfterAction()
            begin
                SalesLine.Get();
                //>>NDBI
                SalesLine."Preparation Type" := SalesLine."Preparation Type"::Purchase;
                //SalesLine.Modify;
                if SalesLine.Modify() then;
                //<<NDBI //TODO-> A Verifier
            end;
        }
    }

    trigger OnOpenPage()
    begin
        if BooGResaFTA or BooGResaAssFTA then
            Rec.SetFilter("Promised Receipt Date", '<>%1', 0D);
    end;


    var
        ReservEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        ReservMgt: Codeunit "Reservation Management";
        SourceRecRef: RecordRef;
        BooGResaFTA: Boolean;
        BooGResaAssFTA: Boolean;
        QtyReservedThisLine: Decimal;
        QtyReservedThisLineBase: Decimal;
        NewQtyReservedThisLine: Decimal;
        NewQtyReservedThisLineBase: Decimal;
        Text000: Label 'Fully reserved.';
        Text003: Label 'Available Quantity is %1.';


    procedure ReservLine()
    begin
        ReservEntry.LockTable();
        //UpdateReservMgt();
        Clear(ReservMgt);
        ReservMgt.SetReservSource(SourceRecRef, ReservEntry.GetTransferDirection());
        //ReservMgt.PurchLineUpdateValues(Rec, QtyToReserve, QtyToReserveBase, QtyReservedThisLine, QtyReservedThisLineBase);
        Rec.GetReservationQty(QtyReservedThisLine, QtyReservedThisLineBase, QtyToReserve, QtyToReserveBase);
        //>>MIG NAV 2015 : Not supported
        //NewQtyReservedThisLine := ReservMgt.CalculateRemainingQty(DecLRemainingQty,DecLRemainingQtyBase);
        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
        //<<MIG NAV 2015 : Not supported

        ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
        if NewQtyReservedThisLine <> 0 then
            if Abs(NewQtyReservedThisLine) > Abs(QtyToReserve) then
                CreateReservation(QtyToReserve, QtyToReserveBase)
            else
                CreateReservation(NewQtyReservedThisLine, NewQtyReservedThisLineBase)
        else
            Error(Text000);
    end;


    procedure CreateReservation(ReservedQuantity: Decimal; ReserveQuantityBase: Decimal)
    var
        TrackingSpecification: Record "Tracking Specification";
        IsHandled: Boolean;

    begin
        Rec.CalcFields("Reserved Qty. (Base)");
        if (Abs(Rec."Outstanding Qty. (Base)") - Abs(Rec."Reserved Qty. (Base)")) < ReserveQuantityBase then
            Error(Text003, Abs(Rec."Outstanding Qty. (Base)") - Rec."Reserved Qty. (Base)");

        IsHandled := false;
        if not IsHandled then begin
            Rec.TestField("Job No.", '');
            Rec.TestField("Drop Shipment", false);
            Rec.TestField("No.", ReservEntry."Item No.");
            Rec.TestField("Variant Code", ReservEntry."Variant Code");
            Rec.TestField("Location Code", ReservEntry."Location Code");
        end;

        //UpdateReservMgt();
        Clear(ReservMgt);
        ReservMgt.SetReservSource(SourceRecRef, ReservEntry.GetTransferDirection());
        TrackingSpecification.InitTrackingSpecification(
          DATABASE::"Purchase Line", Rec."Document Type".AsInteger(), Rec."Document No.", '', 0, Rec."Line No.",
          Rec."Variant Code", Rec."Location Code", Rec."Qty. per Unit of Measure");
        ReservMgt.CreateReservation(
          ReservEntry.Description, Rec."Expected Receipt Date", ReservedQuantity, ReserveQuantityBase, TrackingSpecification);
        //UpdateReservFrom();
        SetSource(SourceRecRef, ReservEntry, ReservEntry.GetTransferDirection());
    end;

    procedure ReservLine2()
    begin
        ReservEntry.LockTable();
        //UpdateReservMgt;
        Clear(ReservMgt);
        ReservMgt.SetReservSource(SourceRecRef, ReservEntry.GetTransferDirection());
        //ReservMgt.PurchLineUpdateValues(Rec, QtyToReserve, QtyToReserveBase, QtyReservedThisLine, QtyReservedThisLineBase);
        Rec.GetReservationQty(QtyReservedThisLine, QtyReservedThisLineBase, QtyToReserve, QtyToReserveBase);
        //>>MIG NAV 2015 : Not supported
        //NewQtyReservedThisLine := ReservMgt.CalculateRemainingQty;
        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
        //<<MIG NAV 2015 : Not supported
        ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
        if NewQtyReservedThisLine <> 0 then
            if Abs(NewQtyReservedThisLine) > Abs(QtyToReserve) then
                CreateReservation(QtyToReserve, QtyToReserveBase)
            else
                CreateReservation(NewQtyReservedThisLine, NewQtyReservedThisLine);
    end;

    procedure FctSetBooResaFTA(BooPResaFTA: Boolean)
    begin
        BooGResaFTA := BooPResaFTA;
    end;

    procedure FctSetBooResaAssFTA(BooPResaAssFTA: Boolean)
    begin
        BooGResaAssFTA := BooPResaAssFTA;
    end;
}

