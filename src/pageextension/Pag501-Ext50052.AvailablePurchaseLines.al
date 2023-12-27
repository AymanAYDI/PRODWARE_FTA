namespace Prodware.FTA;

using Microsoft.Purchases.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Requisition;
using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Planning;
using Microsoft.Inventory.Transfer;
using Microsoft.Service.Document;
using Microsoft.Projects.Project.Planning;
using Microsoft.Assembly.Document;

pageextension 50052 AvailablePurchaseLines extends "Available - Purchase Lines" //501
{
    // ----------------------------------
    // Prodware - www.prodware.fr
    // ----------------------------------
    // 
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Kit Build up or remove into pieces
    //                   - Add Function ReservLine
    //                   - Add Function ReservLine2
    // 
    // //>>MODIF HL
    // TI418426 DO.GEPO 08/06/2018 : MODIFY Function UpdateReservFrom and UpdateReservMgt
    // 
    // //>>NDBI
    // LALE.PA 05/10/2021 cf REQ-07040-V7Y7J4 - REQ-09111-R5M4G6
    //             Add C/AL Global BooGResaFTA, BooGResaAssFTA
    //             Add Function FctSetBooResaFTA, FctSetBooResaAssFTA
    //             Add C/AL Code in trigger OnOpenPage()
    // 
    // ------------------------------------------------------------------------

    actions
    {
        modify(Reserve)
        {
            Visible = false;
        }
        addbefore(CancelReservation)
        {
            action("Reserve ")
            {
                Caption = '&Reserve';
                Image = Reserve;

                trigger OnAction()
                begin
                    ReservEntry.LOCKTABLE();
                    UpdateReservMgt();
                    //TODO
                    // ReservMgt.PurchLineUpdateValues(Rec, QtyToReserve, QtyToReserveBase, QtyReservedThisLine, QtyReservedThisLineBase);
                    Rec.GetReservationQty(QtyReservedThisLine, QtyReservedThisLineBase, QtyToReserve, QtyToReserveBase);
                    ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
                    ReservMgt.CopySign(NewQtyReservedThisLineBase, QtyToReserveBase);
                    ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
                    IF NewQtyReservedThisLineBase <> 0 THEN
                        IF ABS(NewQtyReservedThisLineBase) > ABS(QtyToReserveBase) THEN
                            CreateReservation(QtyToReserve, QtyToReserveBase)
                        ELSE
                            CreateReservation(NewQtyReservedThisLine, NewQtyReservedThisLineBase)
                    ELSE
                        ERROR(Text000);
                    //>>NDBI
                    SalesLine."Preparation Type" := SalesLine."Preparation Type"::Purchase;
                    //SalesLine.MODIFY;
                    IF SalesLine.MODIFY() THEN;
                    //<<NDBI
                end;
                //InitTrackingSpecification
            }
        }
    }

    trigger OnOpenPage()
    begin
        ReservEntry.TESTFIELD("Source Type");

        Rec.SETRANGE("Document Type", CurrentSubType);
        Rec.SETRANGE(Type, Rec.Type::Item);
        Rec.SETRANGE("No.", ReservEntry."Item No.");
        Rec.SETRANGE("Variant Code", ReservEntry."Variant Code");
        Rec.SETRANGE("Job No.", '');
        Rec.SETRANGE("Drop Shipment", FALSE);
        Rec.SETRANGE("Location Code", ReservEntry."Location Code");

        Rec.SETFILTER("Expected Receipt Date", ReservMgt.GetAvailabilityFilter(ReservEntry."Shipment Date"));

        //<<NDBI
        IF BooGResaFTA OR BooGResaAssFTA THEN
            Rec.SETFILTER("Promised Receipt Date", '<>%1', 0D);
        //<<NDBI

        CASE CurrentSubType OF
            0, 1, 2, 4:
                IF ReservMgt.IsPositive() THEN
                    Rec.SETFILTER("Quantity (Base)", '>0')
                ELSE
                    Rec.SETFILTER("Quantity (Base)", '<0');
            3, 5:
                IF ReservMgt.IsPositive() THEN
                    Rec.SETFILTER("Quantity (Base)", '<0')
                ELSE
                    Rec.SETFILTER("Quantity (Base)", '>0');
        END;
    end;

    var
        Text000: Label 'Fully reserved.';
        Text001: Label 'Do you want to cancel the reservation?';
        Text003: Label 'Available Quantity is %1.';
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        PurchHeader: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        TransLine: Record "Transfer Line";
        ServiceInvLine: Record "Service Line";
        JobPlanningLine: Record "Job Planning Line";
        AssemblyLine: Record "Assembly Line";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
        AssemblyHeaderReserve: Codeunit "Assembly Header-Reserve";
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReservePlanningComponent: Codeunit "Plng. Component-Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        ReserveServiceInvLine: Codeunit "Service Line-Reserve";
        JobPlanningLineReserve: Codeunit "Job Planning Line-Reserve";
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        QtyReservedThisLine: Decimal;
        QtyReservedThisLineBase: Decimal;
        NewQtyReservedThisLine: Decimal;
        NewQtyReservedThisLineBase: Decimal;
        CaptionText: Text[80];
        Direction: Option Outbound,Inbound;
        CurrentSubType: Option;
        BooGResaFTA: Boolean;
        BooGResaAssFTA: Boolean;


    procedure SetSalesLine(var CurrentSalesLine: Record "Sales Line"; CurrentReservEntry: Record "Reservation Entry")
    begin
        CurrentSalesLine.TESTFIELD(Type, CurrentSalesLine.Type::Item);
        SalesLine := CurrentSalesLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);

        ReservMgt.SetSalesLine(SalesLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveSalesLine.FilterReservFor(ReservEntry, SalesLine);
        CaptionText := ReserveSalesLine.Caption(SalesLine);
    end;


    procedure SetReqLine(var CurrentReqLine: Record "246"; CurrentReservEntry: Record "337")
    begin
        ReqLine := CurrentReqLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetReqLine(ReqLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveReqLine.FilterReservFor(ReservEntry, ReqLine);
        CaptionText := ReserveReqLine.Caption(ReqLine);
    end;


    procedure SetPurchLine(var CurrentPurchLine: Record "39"; CurrentReservEntry: Record "337")
    begin
        CurrentPurchLine.TESTFIELD(Type, CurrentPurchLine.Type::Item);
        PurchLine := CurrentPurchLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetPurchLine(PurchLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReservePurchLine.FilterReservFor(ReservEntry, PurchLine);
        CaptionText := ReservePurchLine.Caption(PurchLine);
    end;


    procedure SetProdOrderLine(var CurrentProdOrderLine: Record "5406"; CurrentReservEntry: Record "337")
    begin
        ProdOrderLine := CurrentProdOrderLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetProdOrderLine(ProdOrderLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveProdOrderLine.FilterReservFor(ReservEntry, ProdOrderLine);
        CaptionText := ReserveProdOrderLine.Caption(ProdOrderLine);
    end;


    procedure SetProdOrderComponent(var CurrentProdOrderComp: Record "5407"; CurrentReservEntry: Record "337")
    begin
        ProdOrderComp := CurrentProdOrderComp;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetProdOrderComponent(ProdOrderComp);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveProdOrderComp.FilterReservFor(ReservEntry, ProdOrderComp);
        CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
    end;


    procedure SetPlanningComponent(var CurrentPlanningComponent: Record "99000829"; CurrentReservEntry: Record "337")
    begin
        PlanningComponent := CurrentPlanningComponent;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetPlanningComponent(PlanningComponent);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReservePlanningComponent.FilterReservFor(ReservEntry, PlanningComponent);
        CaptionText := ReservePlanningComponent.Caption(PlanningComponent);
    end;


    procedure SetTransferLine(var CurrentTransLine: Record "5741"; CurrentReservEntry: Record "337"; CurrDirection: Option Outbound,Inbound)
    begin
        TransLine := CurrentTransLine;
        ReservEntry := CurrentReservEntry;
        Direction := CurrDirection;

        CLEAR(ReservMgt);
        ReservMgt.SetTransferLine(TransLine, Direction);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveTransLine.FilterReservFor(ReservEntry, TransLine, Direction);
        CaptionText := ReserveTransLine.Caption(TransLine);
    end;


    // procedure SetServiceInvLine(var CurrentServiceInvLine: Record "5902"; CurrentReservEntry: Record "337")
    // begin
    //     CurrentServiceInvLine.TESTFIELD(Type, CurrentServiceInvLine.Type::Item);
    //     ServiceInvLine := CurrentServiceInvLine;
    //     ReservEntry := CurrentReservEntry;

    //     CLEAR(ReservMgt);
    //     ReservMgt.SetServLine(ServiceInvLine);
    //     ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
    //     ReserveServiceInvLine.FilterReservFor(ReservEntry, ServiceInvLine);
    //     CaptionText := ReserveServiceInvLine.Caption(ServiceInvLine);
    // end;


    procedure SetJobPlanningLine(var CurrentJobPlanningLine: Record "1003"; CurrentReservEntry: Record "337")
    begin
        CurrentJobPlanningLine.TESTFIELD(Type, CurrentJobPlanningLine.Type::Item);
        JobPlanningLine := CurrentJobPlanningLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetJobPlanningLine(JobPlanningLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        JobPlanningLineReserve.FilterReservFor(ReservEntry, JobPlanningLine);
        CaptionText := JobPlanningLineReserve.Caption(JobPlanningLine);
    end;


    procedure CreateReservation(ReservedQuantity: Decimal; ReserveQuantityBase: Decimal)
    var
        TrackingSpecification: Record "336";
    begin
        Rec.CALCFIELDS("Reserved Qty. (Base)");
        IF (ABS(Rec."Outstanding Qty. (Base)") - ABS(Rec."Reserved Qty. (Base)")) < ReserveQuantityBase THEN
            ERROR(Text003, ABS(Rec."Outstanding Qty. (Base)") - Rec."Reserved Qty. (Base)");

        Rec.TESTFIELD("Job No.", '');
        Rec.TESTFIELD("Drop Shipment", FALSE);
        Rec.TESTFIELD("No.", ReservEntry."Item No.");
        Rec.TESTFIELD("Variant Code", ReservEntry."Variant Code");
        Rec.TESTFIELD("Location Code", ReservEntry."Location Code");

        UpdateReservMgt();
        TrackingSpecification.InitTrackingSpecification(DATABASE::"Purchase Line", Rec."Document Type", Rec."Document No.", '', 0, Rec."Line No.", Rec."Variant Code", Rec."Location Code", Rec."Qty. per Unit of Measure");
        CreateReservation(ReservedQuantity, ReserveQuantityBase);
        UpdateReservFrom();
    end;


    procedure UpdateReservFrom()
    begin
        SetSource(SourceRecRef, ReservEntry, ReservEntry.GetTransferDirection());
    end;



    procedure UpdateReservMgt()
    begin
        CLEAR(ReservMgt);
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                ReservMgt.SetSalesLine(SalesLine);
            DATABASE::"Requisition Line":
                ReservMgt.SetReqLine(ReqLine);
            DATABASE::"Purchase Line":
                ReservMgt.SetPurchLine(PurchLine);
            DATABASE::"Prod. Order Line":
                ReservMgt.SetProdOrderLine(ProdOrderLine);
            DATABASE::"Prod. Order Component":
                ReservMgt.SetProdOrderComponent(ProdOrderComp);
            DATABASE::"Planning Component":
                ReservMgt.SetPlanningComponent(PlanningComponent);
            DATABASE::"Transfer Line":
                ReservMgt.SetTransferLine(TransLine, ReservEntry."Source Subtype");
            DATABASE::"Service Line":
                ReservMgt.SetServLine(ServiceInvLine);
            DATABASE::"Job Planning Line":
                ReservMgt.SetJobPlanningLine(JobPlanningLine);
            //>>TI418426
            DATABASE::"Assembly Line":
                ReservMgt.SetAssemblyLine(AssemblyLine)
        //<<TI418426
        END;
    end;


    procedure ReservedThisLine(): Decimal
    begin
        ReservEntry2.RESET();
        IF ReservEntry."Source Type" = DATABASE::"Transfer Line" THEN
            ReservEntry."Source Subtype" := Direction;
        ReservePurchLine.FilterReservFor(ReservEntry2, Rec);
        ReservEntry2.SETRANGE("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
        EXIT(ReservMgt.MarkReservConnection(ReservEntry2, ReservEntry));
    end;


    procedure SetCurrentSubType(SubType: Option)
    begin
        CurrentSubType := SubType;
    end;


    procedure SetAssemblyLine(var CurrentAsmLine: Record "901"; CurrentReservEntry: Record "337")
    begin
        CurrentAsmLine.TESTFIELD(Type, CurrentAsmLine.Type::Item);
        AssemblyLine := CurrentAsmLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetAssemblyLine(AssemblyLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        AssemblyLineReserve.FilterReservFor(ReservEntry, AssemblyLine);
        CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
    end;


    procedure SetAssemblyHeader(var CurrentAsmHeader: Record "900"; CurrentReservEntry: Record "337")
    begin
        AssemblyHeader := CurrentAsmHeader;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetAssemblyHeader(AssemblyHeader);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        AssemblyHeaderReserve.FilterReservFor(ReservEntry, AssemblyHeader);
        CaptionText := AssemblyHeaderReserve.Caption(AssemblyHeader);
    end;



    procedure ReservLine()
    var
        DecLRemainingQty: Decimal;
        DecLRemainingQtyBase: Decimal;
    begin

        ReservEntry.LOCKTABLE();
        UpdateReservMgt();
        //ReservMgt.PurchLineUpdateValues(Rec, QtyToReserve, QtyToReserveBase, QtyReservedThisLine, QtyReservedThisLineBase);
        Rec.GetReservationQty(QtyReservedThisLine, QtyReservedThisLineBase, QtyToReserve, QtyToReserveBase);
        //>>MIG NAV 2015 : Not supported
        //NewQtyReservedThisLine := ReservMgt.CalculateRemainingQty(DecLRemainingQty,DecLRemainingQtyBase);
        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
        //<<MIG NAV 2015 : Not supported

        ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
        IF NewQtyReservedThisLine <> 0 THEN
            IF ABS(NewQtyReservedThisLine) > ABS(QtyToReserve) THEN
                CreateReservation(QtyToReserve, QtyToReserveBase)
            ELSE
                CreateReservation(NewQtyReservedThisLine, NewQtyReservedThisLineBase)
        ELSE
            ERROR(Text000);
    end;


    procedure ReservLine2()
    begin

        ReservEntry.LOCKTABLE();
        UpdateReservMgt();
        //ReservMgt.PurchLineUpdateValues(Rec, QtyToReserve, QtyToReserveBase, QtyReservedThisLine, QtyReservedThisLineBase);
        Rec.GetReservationQty(QtyReservedThisLine, QtyReservedThisLineBase, QtyToReserve, QtyToReserveBase);
        //>>MIG NAV 2015 : Not supported
        //NewQtyReservedThisLine := ReservMgt.CalculateRemainingQty;
        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
        //<<MIG NAV 2015 : Not supported
        ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
        IF NewQtyReservedThisLine <> 0 THEN
            IF ABS(NewQtyReservedThisLine) > ABS(QtyToReserve) THEN
                CreateReservation(QtyToReserve, QtyToReserveBase)
            ELSE
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

