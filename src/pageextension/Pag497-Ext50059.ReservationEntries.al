namespace Prodware.FTA;

using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;
using Microsoft.Assembly.Document;

pageextension 50059 "ReservationEntries" extends "Reservation Entries" //497
{
    layout
    {
        addafter("ReservEngineMgt.CreateForText(Rec)")
        {
            field("TxtGDescription"; "TxtGDescription")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the TxtGDescription field.';
                Caption = 'Sales Order For Assembly';
            }
            field("CustomerName"; "CustomerName")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name field.';
                Caption = 'Nom client';
                Editable = false;
            }
            field(RequestedDeliveryDate; RequestedDeliveryDate)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested Delivery Date field.';
                Caption = 'Requested Delivery Date';
                Editable = false;
            }
        }
    }
    var
        RecGAtoLink: Record "Assemble-to-Order Link";
        RecGReservEntry: Record "Reservation Entry";
        TxtGDescription: Text;
        RequestedDeliveryDate: Date;
        CustomerName: Text;

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        if RecGReservEntry.GET(RecGReservEntry."Entry No.", false) then begin
            if RecGReservEntry."Source Type" = 901 then begin
                if not RecGAtoLink.GET(RecGReservEntry."Source Subtype", RecGReservEntry."Source ID") then
                    RecGAtoLink.INIT();
                TxtGDescription := FORMAT(RecGAtoLink."Document Type") + ' ' + RecGAtoLink."Document No.";
                if SalesHeader.GET(RecGAtoLink."Document Type", RecGAtoLink."Document No.") then begin
                    CustomerName := SalesHeader."Sell-to Customer Name";
                    RequestedDeliveryDate := SalesHeader."Requested Delivery Date";
                end;

            end else begin
                TxtGDescription := '';
                if SalesHeader.GET(RecGReservEntry."Source Subtype", RecGReservEntry."Source ID") then
                    CustomerName := SalesHeader."Sell-to Customer Name";
            end;
        end else
            TxtGDescription := '';
    end;
}
