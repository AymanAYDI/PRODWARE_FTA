namespace Prodware.FTA;

using Microsoft.Sales.Reports;
using Microsoft.Sales.Customer;
using Microsoft.Assembly.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Document;
reportextension 50002 "SalesReservationAvail" extends "Sales Reservation Avail." //209
{
    RDLCLayout = './src/reportextension/rdlc/SalesReservationAvail.rdl';
    dataset
    {
        //TODO : Migration trigger OnAfterGetRecord()
        modify("Sales Line")
        { //TODO -> A verifier

        }
        add("Sales Line")
        {
            column(StrsubstnoDocTypeDocNo1; STRSUBSTNO(Text001, "Document Type", "Document No.", CustomerCard.Name))
            {

            }
            //Inversed Column ""StrsubstnoDocTypeDocNo1"" with ""StrsubstnoDocTypeDocNo"
            column("Preparation_Type_FORMAT"; FORMAT("Preparation Type"))
            {

            }
            column("DecGDisposalQtyStock"; DecGDisposalQtyStock)
            {
                DecimalPlaces = 0 : 5;
            }
            column("TypePrepaCaption"; TypePrepaCaptionLBL)
            {
            }
            column("LocationCaption"; LocationCaptionlbl)
            {
            }
        }
    }
    requestpage
    {
        //TODO : variable global
        // trigger OnOpenPage()
        // begin
        //     ShowSalesLines := ShowSalesLines::true;
        // end;
    }
    var
        CustomerCard: Record Customer;
        DecGQtyReserv: Decimal;
        TypePrepaCaptionLBL: Label 'Preparation Type';
        LocationCaptionlbl: Label 'Location Inventory';
        DecGDisposalQtyStock: Decimal;
        Text001: Label '%1 %2 - %3', Comment = '%1="Document Type",%2="Document No.",%3=Name';
        BooGPurchase: Boolean;
        BooGNegativeAvailable: Boolean;

    procedure FctctrlKitReserv(SalesLine: Record 37) BooLOK: Boolean;
    var
        RecLKitSalesLine: Record 901;
        RecL337: Record 337;
        RecL337b: Record 337;
        RecLAssemblyOrderLink: Record 904;
    begin
        BooLOK := false;
        BooGPurchase := false;
        BooGNegativeAvailable := false;

        //
        RecLAssemblyOrderLink.SETRANGE("Document Type", SalesLine."Document Type");
        RecLAssemblyOrderLink.SETRANGE("Document No.", SalesLine."Document No.");
        //RecLKitSalesLine.SETRANGE("Document Type",SalesLine."Document Type");
        //RecLKitSalesLine.SETRANGE("Document No.",SalesLine."Document No.");
        //IF RecLAssemblyOrderLink.GET(RecLKitSalesLine."Document Type",RecLKitSalesLine."Document No.") THEN;
        RecLAssemblyOrderLink.SETRANGE("Document Line No.", SalesLine."Line No.");
        if not RecLAssemblyOrderLink.FINDFIRST() then
            RecLAssemblyOrderLink.INIT();

        RecLKitSalesLine.SETRANGE("Document Type", RecLAssemblyOrderLink."Assembly Document Type");
        RecLKitSalesLine.SETRANGE("Document No.", RecLAssemblyOrderLink."Assembly Document No.");

        RecLKitSalesLine.SETRANGE(Type, RecLKitSalesLine.Type::Item);
        RecLKitSalesLine.SETFILTER("Remaining Quantity", '<>0');

        if not RecLKitSalesLine.ISEMPTY then begin
            BooLOK := true;
            RecLKitSalesLine.FINDSET();
            repeat
                DecGQtyReserv := 0;
                RecLKitSalesLine.CALCFIELDS("Reserved Quantity");
                if (RecLKitSalesLine."Reserved Quantity" < RecLKitSalesLine."Remaining Quantity (Base)") then
                    BooLOK := false
                else
                    if (RecLKitSalesLine."Reserved Quantity" <> 0) then begin
                        RecL337.SETRANGE("Source Type", DATABASE::"Assembly Line");
                        RecL337.SETRANGE("Source Subtype", RecLKitSalesLine."Document Type");
                        RecL337.SETRANGE("Source Subtype", RecLKitSalesLine."Document Type");
                        RecL337.SETRANGE("Source ID", RecLKitSalesLine."Document No.");

                        //<<MIG NAV 2015 : Not supported
                        //RecL337.SETRANGE("Source Prod. Order Line",RecLAssemblyOrderLink."Document Line No.");
                        //>>MIG NAV 2015 : Not supported
                        RecL337.SETRANGE("Source Ref. No.", RecLKitSalesLine."Line No.");
                        RecL337.SETRANGE("Reservation Status", RecL337."Reservation Status"::Reservation);
                        if RecL337.FINDSET() then
                            repeat
                                RecL337b.SETRANGE("Entry No.", RecL337."Entry No.");
                                RecL337b.SETFILTER("Source Type", '<>901');
                                if RecL337b.FINDSET() then
                                    if RecL337b."Source Type" <> DATABASE::"Item Ledger Entry" then
                                        BooLOK := false;
                                if RecL337b."Source Type" = DATABASE::"Purchase Line" then
                                    BooGPurchase := true;
                                DecGQtyReserv += RecL337b."Quantity (Base)";
                            until (RecL337.NEXT() = 0) or (BooLOK = false);
                    end;

                if not BooGPurchase and (DecGQtyReserv < RecLKitSalesLine."Remaining Quantity (Base)") then
                    if FctCkeckAvailableItem(RecLKitSalesLine, RecLKitSalesLine."Remaining Quantity (Base)" - DecGQtyReserv) then
                        BooLOK := true
                    else
                        BooLOK := false;

            until (RecLKitSalesLine.NEXT() = 0) or not BooLOK;
        end;
    end;

    procedure FctCkeckAvailableItem(RecPKitSalesLine: Record 901; DecPQty: Decimal) BooLOK: Boolean;
    var
        RecLItem: Record 27;
        DecLDisposalQtyStock: Decimal;
        DecLAvailable: Decimal;
    begin
        RecLItem.GET(RecPKitSalesLine."No.");
        RecLItem.CALCFIELDS(Inventory, "Reserved Qty. on Inventory",
                            "Qty. on Sales Order", "Reserved Qty. on Purch. Orders");
        DecLDisposalQtyStock := RecLItem.Inventory - (RecLItem."Reserved Qty. on Inventory");
        DecLAvailable := RecLItem.Inventory - (RecLItem."Qty. on Sales Order")
                     + RecLItem."Reserved Qty. on Purch. Orders";

        //IF (DecPQty = RecPKitSalesLine."Outstanding Qty. (Base)") then begin
        if DecLDisposalQtyStock >= DecPQty then begin
            if DecLAvailable < 0 then begin
                BooGNegativeAvailable := true; //Verif dispo
                BooLOK := false;
            end else
                BooLOK := true;
        end else
            BooLOK := false;
        //end else begin

        //end;

        //IF DecLDisposalQtyStock >= DecPQty THEN
        //  BooLOK :=TRUE;
        //IF (DecPQty = RecPKitSalesLine."Outstanding Qty. (Base)") AND (DecLDisposalQtyStock < 0) THEN
        //  BooGNegativeAvailable := TRUE;
    end;
}


