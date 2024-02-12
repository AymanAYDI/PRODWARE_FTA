
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
    // actions
    // {
    //     modify("Reserve from Current Line")
    //     {
    //         trigger On()
    //         var
    //             myInt: Integer;
    //         begin

    //         end;
    //     }
    //     modify(CancelReservationCurrentLine)
    //     {
    //         Visible = false;
    //     }
    //     addafter("Reserve from Current Line")
    //     {
    //         action("Reserve from Current Line fta")
    //         {
    //             ApplicationArea = Reservation;
    //             Caption = '&Reserve from Current Line';
    //             Image = LineReserve;
    //             Scope = Repeater;
    //             ToolTip = 'Open the view of quantities available to reserve and select which to reserve.';

    //             trigger OnAction()
    //             var
    //                 RemainingQtyToReserveBase: Decimal;
    //                 QtyReservedBefore: Decimal;
    //                 RemainingQtyToReserve: Decimal;
    //             begin
    //                 RemainingQtyToReserveBase := QtyToReserveBase - QtyReservedBase;
    //                 if RemainingQtyToReserveBase = 0 then
    //                     Error(Text000);
    //                 QtyReservedBefore := QtyReservedBase;
    //                 if HandleItemTracking then
    //                     ReservMgt.SetItemTrackingHandling(2);
    //                 RemainingQtyToReserve := QtyToReserve - QtyReserved;
    //                 ReservMgt.AutoReserveOneLine(
    //                   Rec."Entry No.", RemainingQtyToReserve, RemainingQtyToReserveBase, ReservEntry.Description,
    //                   ReservEntry."Shipment Date");
    //                 UpdateReservFrom();
    //                 if QtyReservedBefore = QtyReservedBase then
    //                     Error(Text002);
    //             end;
    //         }
    //     }

    //     addafter(CancelReservationCurrentLine)
    //     {
    //           action(CancelReservationCurrentLinefta)
    //             {
    //                 AccessByPermission = TableData Item = R;
    //                 ApplicationArea = Reservation;
    //                 Caption = '&Cancel Reservation from Current Line';
    //                 Image = Cancel;
    //                 ToolTip = 'Cancel the selected reservation entry.';
    //                 Scope = Repeater;
    //                 trigger OnAction()
    //                 var
    //                     ReservEntry3: Record "Reservation Entry";
    //                     RecordsFound: Boolean;
    //                 begin
    //                     if not Confirm(Text003, false, Rec."Summary Type") then
    //                         exit;
    //                     Clear(ReservEntry2);
    //                     ReservEntry2 := ReservEntry;
    //                     ReservEntry2.SetPointerFilter();
    //                     ReservEntry2.SetRange("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
    //                     ReservEntry2.SetRange("Disallow Cancellation", false);
    //                     if ReservEntry2.FindSet() then
    //                         repeat
    //                             ReservEntry3.Get(ReservEntry2."Entry No.", not ReservEntry2.Positive);
    //                             if RelatesToSummEntry(ReservEntry3, Rec) then begin
    //                                 ReservEngineMgt.CancelReservation(ReservEntry2);
    //                                 RecordsFound := true;
    //                             end;
    //                         until ReservEntry2.Next() = 0;

    //                     if RecordsFound then
    //                         UpdateReservFrom()
    //                     else
    //                         Error(Text005);

    //                     OnAfterCancelReservationCurrentLine(ReservEntry);
    //                 end;
    //             }
    //     }
    // }
    // TODO ReservEntry variable global 
    procedure GetReservEntry(var RecPReservEntry: Record "Reservation Entry")
    begin
        RecPReservEntry := globalReservEntry;
    end;

    procedure SetReservEntryFTA(ReservEntry: Record "Reservation Entry")
    begin
        globalReservEntry := ReservEntry;
    end;

    procedure FctSetBooResaFTA(BooPResaFTA: Boolean)
    begin
        BooGResaFTA := BooPResaFTA;
    end;

    procedure FctSetBooResaASSFTA(BooPResaAssFTA: Boolean)
    begin
        BooGResaAssFTA := BooPResaAssFTA;
    end;

    procedure ReturnRec(var pRec: Record "Entry Summary");
    begin
        pRec := Rec;
    end;

    var
        RecGItem: Record Item;
        globalReservEntry: Record "Reservation Entry";
        BooGResaFTA: Boolean;
        BooGResaAssFTA: Boolean;
        CstG001: Label 'FRéservation impossible à partir de cet écran.\Revenir sur l''écran "Choix du type de préparation" pour faire la réservation !';

}

