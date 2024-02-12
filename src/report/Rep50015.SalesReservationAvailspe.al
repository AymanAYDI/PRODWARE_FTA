namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.UOM;
using Microsoft.Assembly.Document;
using Microsoft.Purchases.Document;
report 50015 "Sales Reservation Avail.spe" //dupliquer de 209
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/SalesReservationAvail.rdl';
    ApplicationArea = All;
    Caption = 'Sales Reservation Avail.';
    UsageCategory = ReportsAndAnalysis;
    // todo : change CALL in menusuite 1010
    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where(Type = const(Item));
            RequestFilterFields = "Document Type", "Document No.", "No.", "Location Code", "Outstanding Quantity", "Shipment Date";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(StrSubstNoDocTypeDocNo; StrSubstNo('%1 %2 - 3%', "Document Type", "Document No.", CustomerCard.Name))
            {
            }
            column(StrSubstNoDocTypeDocNo1; StrSubstNo('%1 %2', "Document Type", "Document No."))
            {
            }
            column(ShowSalesLineGrHeader2; ShowSalesLineGrHeader2)
            {
            }
            column(No_SalesLine; "No.")
            {
                IncludeCaption = true;
            }
            column(Description_SalesLine; Description)
            {
                IncludeCaption = true;
            }
            column(ShpmtDt__SalesLine; Format("Shipment Date"))
            {
            }
            column(Preparation_Type_Format; Format("Preparation Type"))
            {

            }
            column(Reserve__SalesLine; Reserve)
            {
                IncludeCaption = true;
            }
            column(OutstdngQtyBase_SalesLine; "Outstanding Qty. (Base)")
            {
                IncludeCaption = true;
            }
            column(ResrvdQtyBase_SalesLine; "Reserved Qty. (Base)")
            {
                IncludeCaption = true;
            }
            column(LineStatus; LineStatus)
            {
                OptionCaption = ' ,Shipped,Full Shipment,Partial Shipment,No Shipment';
            }
            column(DecGDisposalQtyStock; DecGDisposalQtyStock)
            {
                DecimalPlaces = 0 : 5;
            }
            column(LineReceiptDate; Format(LineReceiptDate))
            {
            }
            column(LineQuantityOnHand; LineQuantityOnHand)
            {
                DecimalPlaces = 0 : 5;
            }
            column(ShowSalesLineBody; ShowSalesLines)
            {
            }
            column(DocumentReceiptDate; Format(DocumentReceiptDate))
            {
            }
            column(DocumentStatus; DocumentStatus)
            {
                OptionCaption = ' ,Shipped,Full Shipment,Partial Shipment,No Shipment';
            }
            column(ShipmentDt_SalesHeader; Format(SalesHeader."Shipment Date"))
            {
            }
            column(Reserve_SalesHeader; StrSubstNo('%1', SalesHeader.Reserve))
            {
            }
            column(DocType__SalesLine; "Document Type")
            {
            }
            column(DoctNo_SalesLine; "Document No.")
            {
            }
            column(LineNo_SalesLine; "Line No.")
            {
            }
            column(SalesResrvtnAvalbtyCaption; SalesResrvtnAvalbtyCaptionLbl)
            {
            }
            column(CurrRepPageNoCaption; CurrRepPageNoCaptionLbl)
            {
            }
            column(SalesLineShpmtDtCaption; SalesLineShpmtDtCaptionLbl)
            {
            }
            column(LineReceiptDateCaption; LineReceiptDateCaptionLbl)
            {
            }
            column(LineStatusCaption; LineStatusCaptionLbl)
            {
            }
            column(LineQuantityOnHandCaption; LineQuantityOnHandCaptionLbl)
            {
            }
            column("TypePrepaCaption"; TypePrepaCaptionLBL)
            {
            }
            column("LocationCaption"; LocationCaptionlbl)
            {
            }
            dataitem("Reservation Entry"; "Reservation Entry")
            {
                DataItemLink = "Source ID" = field("Document No."), "Source Ref. No." = field("Line No.");
                DataItemTableView = sorting("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Reservation Status", "Shipment Date", "Expected Receipt Date") where("Reservation Status" = const(Reservation), "Source Type" = const(37), "Source Batch Name" = const(''), "Source Prod. Order Line" = const(0));
                column(ReservText; ReservText)
                {
                }
                column(ShowReservDate; Format(ShowReservDate))
                {
                }
                column(Qty_ReservationEntry; Quantity)
                {
                }
                column(EntryQuantityOnHand; EntryQuantityOnHand)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(ShowResEntryBody; ShowReservationEntries)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Source Type" = DATABASE::"Item Ledger Entry" then
                        ShowReservDate := 0D
                    else
                        ShowReservDate := "Expected Receipt Date";
                    ReservText := ReservEngineMgt.CreateFromText("Reservation Entry");

                    if "Source Type" <> DATABASE::"Item Ledger Entry" then begin
                        if "Expected Receipt Date" > DocumentReceiptDate then
                            DocumentReceiptDate := "Expected Receipt Date";
                        EntryQuantityOnHand := 0;
                    end else
                        EntryQuantityOnHand := Quantity;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Source Subtype", "Sales Line"."Document Type");
                end;
            }

            trigger OnAfterGetRecord()
            var
                Location: Record Location;
                RecL337: Record "Reservation Entry";
                RecL337b: Record "Reservation Entry";
                BooLOK: Boolean;
                QtyToReserve: Decimal;
                QtyToReserveBase: Decimal;
            begin
                if Reserve <> Reserve::Never then begin
                    LineReceiptDate := 0D;
                    LineQuantityOnHand := 0;
                    if "Outstanding Qty. (Base)" = 0 then
                        LineStatus := LineStatus::Shipped
                    else begin
                        SalesLineReserve.ReservQuantity("Sales Line", QtyToReserve, QtyToReserveBase);
                        if QtyToReserveBase > 0 then begin
                            ReservEntry.InitSortingAndFilters(true);
                            SetReservationFilters(ReservEntry);
                            if ReservEntry.FindSet() then
                                repeat
                                    ReservEntryFrom.Reset();
                                    ReservEntryFrom.Get(ReservEntry."Entry No.", not ReservEntry.Positive);
                                    if ReservEntryFrom."Source Type" = DATABASE::"Item Ledger Entry" then
                                        LineQuantityOnHand := LineQuantityOnHand + ReservEntryFrom.Quantity;
                                until ReservEntry.Next() = 0;
                            if FctctrlKitReserv("Sales Line") then
                                LineStatus := LineStatus::"Full Shipment"
                            else
                                if BooGPurchase then
                                    LineStatus := LineStatus::"Reserve on Purchase";
                            if BooGNegativeAvailable then
                                LineStatus := LineStatus::"Check Available";
                            CalcFields("Reserved Qty. (Base)");
                            if ("Outstanding Qty. (Base)" = LineQuantityOnHand) and ("Outstanding Qty. (Base)" <> 0) then begin
                                BooLOK := true;
                                RecL337.SetRange("Source Type", DATABASE::"Sales Line");
                                RecL337.SetRange("Source Subtype", "Document Type");
                                RecL337.SetRange("Source ID", "Document No.");
                                RecL337.SetRange("Source Ref. No.", "Line No.");
                                RecL337.SetRange("Reservation Status", RecL337."Reservation Status"::Reservation);
                                if RecL337.FindSet() then
                                    repeat
                                        RecL337b.SetRange("Entry No.", RecL337."Entry No.");
                                        RecL337b.SetFilter("Source Type", '<>%1', DATABASE::"Sales Line");
                                        if RecL337b.FindSet() then
                                            if RecL337b."Source Type" <> DATABASE::"Item Ledger Entry" then
                                                BooLOK := false;
                                    until (RecL337.Next() = 0) or (BooLOK = false);
                                if BooLOK = true then
                                    LineStatus := LineStatus::"Full Shipment";
                            end
                            // end;
                            else
                                if LineQuantityOnHand = 0 then
                                    // LineStatus := LineStatus::"No Shipment"
                                    if FctctrlKitReserv("Sales Line") then
                                        LineStatus := LineStatus::"Full Shipment"
                                    else
                                        LineStatus := LineStatus::"No Shipment"
                                else
                                    if "Reserved Qty. (Base)" = 0 then begin
                                        LineStatus := LineStatus::"No Shipment";

                                        //>>FED_20090415:PA
                                        if FctctrlKitReserv("Sales Line") then
                                            LineStatus := LineStatus::"Full Shipment"
                                        else
                                            if BooGPurchase then
                                                LineStatus := LineStatus::"Reserve on Purchase";
                                        if BooGNegativeAvailable then
                                            LineStatus := LineStatus::"Check Available";
                                    end
                                    else
                                        LineStatus := LineStatus::"Partial Shipment";

                        end else
                            LineStatus := LineStatus::"Full Shipment";
                    end;
                end else begin
                    LineReceiptDate := 0D;
                    SalesLineReserve.ReservQuantity("Sales Line", QtyToReserve, QtyToReserveBase);
                    LineQuantityOnHand := QtyToReserveBase;
                    if "Outstanding Qty. (Base)" = 0 then
                        LineStatus := LineStatus::Shipped
                    else
                        LineStatus := LineStatus::"Full Shipment";
                end;

                if ModifyQtyToShip and ("Document Type" = "Document Type"::Order) and
                   ("Qty. to Ship (Base)" <> LineQuantityOnHand)
                then begin
                    if "Location Code" <> '' then
                        Location.Get("Location Code");

                    if not Location."Directed Put-away and Pick" then begin
                        if "Qty. per Unit of Measure" = 0 then
                            "Qty. per Unit of Measure" := 1;
                        Validate("Qty. to Ship",
                          Round(LineQuantityOnHand / "Qty. per Unit of Measure", UOMMgt.QtyRndPrecision()));
                        Modify();
                    end;
                end;

                if ClearDocumentStatus then begin
                    DocumentReceiptDate := 0D;
                    DocumentStatus := DocumentStatus::" ";
                    ClearDocumentStatus := false;
                    SalesHeader.Get("Document Type", "Document No.");
                end;

                if LineReceiptDate > DocumentReceiptDate then
                    DocumentReceiptDate := LineReceiptDate;

                case DocumentStatus of
                    DocumentStatus::" ":
                        DocumentStatus := LineStatus;
                    DocumentStatus::Shipped:
                        case LineStatus of
                            LineStatus::Shipped:
                                DocumentStatus := DocumentStatus::Shipped;
                            LineStatus::"Full Shipment",
                          LineStatus::"Partial Shipment":
                                DocumentStatus := DocumentStatus::"Partial Shipment";
                            LineStatus::"No Shipment":
                                DocumentStatus := DocumentStatus::"No Shipment";
                        end;
                    DocumentStatus::"Full Shipment":
                        case LineStatus of
                            LineStatus::Shipped,
                          LineStatus::"Full Shipment":
                                DocumentStatus := DocumentStatus::"Full Shipment";
                            LineStatus::"Partial Shipment",
                          LineStatus::"No Shipment":
                                DocumentStatus := DocumentStatus::"Partial Shipment";
                        end;
                    DocumentStatus::"Partial Shipment":
                        DocumentStatus := DocumentStatus::"Partial Shipment";
                    DocumentStatus::"No Shipment":
                        case LineStatus of
                            LineStatus::Shipped,
                          LineStatus::"No Shipment":
                                DocumentStatus := DocumentStatus::"No Shipment";
                            LineStatus::"Full Shipment",
                          LineStatus::"Partial Shipment":
                                DocumentStatus := DocumentStatus::"Partial Shipment";
                        end;
                end;

                ShowSalesLineGrHeader2 := false;
                if ((OldDocumentType <> "Document Type") or
                    (OldDocumentNo <> "Document No."))
                then
                    if ShowSalesLines then
                        ShowSalesLineGrHeader2 := true;

                OldDocumentNo := "Document No.";
                OldDocumentType := "Document Type";

                TempSalesLines := "Sales Line";
                ClearDocumentStatus := true;

                if TempSalesLines.Next() <> 0 then
                    ClearDocumentStatus := (TempSalesLines."Document No." <> OldDocumentNo) or (TempSalesLines."Document Type" <> OldDocumentType);
                if "No." <> '' then begin
                    RecGItem.Reset();
                    if "Location Code" <> '' then
                        RecGItem.SetFilter("Location Filter", "Location Code");
                    if "Shipment Date" <> 0D then
                        RecGItem.SetFilter("Date Filter", '..%1', "Shipment Date");
                    RecGItem.SetFilter("Drop Shipment Filter", Format(false));
                    RecGItem.Get("No.");
                    RecGItem.CalcFields(Inventory, "Reserved Qty. on Inventory", "Qty. on Purch. Order", "Reserved Qty. on Purch. Orders");
                    DecGDisposalQtyStock := RecGItem.Inventory - RecGItem."Reserved Qty. on Inventory";
                end;
                //<<FED_20090415:PA 15/04/2009
                if not CustomerCard.Get("Sales Line"."Sell-to Customer No.") then;
            end;

            trigger OnPreDataItem()
            begin
                ClearDocumentStatus := true;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowSalesLines; ShowSalesLines)
                    {
                        ApplicationArea = Reservation;
                        Caption = 'Show Sales Lines';
                        ToolTip = 'Specifies if you want the report to include a line for each sales line. If you do not place a check mark in the check box, the report will include one line for each document.';

                        trigger OnValidate()
                        begin
                            if not ShowSalesLines then
                                ShowReservationEntries := false;
                        end;
                    }
                    field(ShowReservationEntries; ShowReservationEntries)
                    {
                        ApplicationArea = Reservation;
                        Caption = 'Show Reservation Entries';
                        ToolTip = 'Specifies if you want the report to include reservation entries. The reservation entry will be printed below the line for which the items have been reserved. You can only use this option if you have also placed a check mark in the Show Sales Lines check box.';

                        trigger OnValidate()
                        begin
                            if ShowReservationEntries and not ShowSalesLines then
                                Error(Text000);
                        end;
                    }
                    field(ModifyQuantityToShip; ModifyQtyToShip)
                    {
                        ApplicationArea = Reservation;
                        Caption = 'Modify Qty. to Ship in Order Lines';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want the program to enter the quantity that is available for shipment in the Qty. to Ship field on the sales lines.';
                    }
                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        begin
            ShowSalesLines := true;
        end;

    }

    labels
    {
    }

    var
        CustomerCard: Record Customer;
        RecGItem: Record Item;
        ReservEntry: Record "Reservation Entry";
        ReservEntryFrom: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        TempSalesLines: Record "Sales Line";
        ReservEngineMgt: codeunit "Reservation Engine Mgt.";
        SalesLineReserve: codeunit "Sales Line-Reserve";
        UOMMgt: codeunit "Unit of Measure Management";
        BooGNegativeAvailable: Boolean;
        BooGPurchase: Boolean;
        ClearDocumentStatus: Boolean;
        ModifyQtyToShip: Boolean;
        ShowReservationEntries: Boolean;
        ShowSalesLineGrHeader2: Boolean;
        ShowSalesLines: Boolean;
        OldDocumentNo: Code[20];
        DocumentReceiptDate: Date;
        LineReceiptDate: Date;
        ShowReservDate: Date;
        DecGDisposalQtyStock: Decimal;
        DecGQtyReserv: Decimal;
        EntryQuantityOnHand: Decimal;
        LineQuantityOnHand: Decimal;
        IntGColor: Integer;
        OldDocumentType: enum "Sales Line Type";
        DocumentStatus: Option " ",Shipped,"Full Shipment","Partial Shipment","No Shipment";
        LineStatus: Option " ",Shipped,"Full Shipment","Partial Shipment","No Shipment","Check Available","Reserve on Purchase";
        ReservText: Text[80];
        CurrRepPageNoCaptionLbl: Label 'Page';
        LineQuantityOnHandCaptionLbl: Label 'Quantity on Hand (Base)';
        LineReceiptDateCaptionLbl: Label 'Expected Receipt Date';
        LineStatusCaptionLbl: Label 'Shipment Status';
        LocationCaptionlbl: Label 'Location Inventory';
        SalesLineShpmtDtCaptionLbl: Label 'Shipment Date';
        SalesResrvtnAvalbtyCaptionLbl: Label 'Sales Reservation Availability';
        Text000: Label 'Sales lines must be shown.';
        TypePrepaCaptionLBL: Label 'Preparation Type';


    procedure InitializeRequest(NewShowSalesLines: Boolean; NewShowReservationEntries: Boolean; NewModifyQtyToShip: Boolean)
    begin
        ShowSalesLines := NewShowSalesLines;
        ShowReservationEntries := NewShowReservationEntries;
        ModifyQtyToShip := NewModifyQtyToShip;
    end;

    procedure FctctrlKitReserv(SalesLine: Record "Sales Line") BooLOK: Boolean;
    var
        RecL337: Record "Reservation Entry";
        RecL337b: Record "Reservation Entry";
        RecLAssemblyOrderLink: Record "Assemble-to-Order Link";
        RecLKitSalesLine: Record "Assembly Line";
    begin
        BooLOK := false;
        BooGPurchase := false;
        BooGNegativeAvailable := false;

        RecLAssemblyOrderLink.SetRange("Document Type", SalesLine."Document Type");
        RecLAssemblyOrderLink.SetRange("Document No.", SalesLine."Document No.");
        RecLAssemblyOrderLink.SetRange("Document Line No.", SalesLine."Line No.");
        if not RecLAssemblyOrderLink.findFirst() then
            RecLAssemblyOrderLink.Init();

        RecLKitSalesLine.SetRange("Document Type", RecLAssemblyOrderLink."Assembly Document Type");
        RecLKitSalesLine.SetRange("Document No.", RecLAssemblyOrderLink."Assembly Document No.");

        RecLKitSalesLine.SetRange(Type, RecLKitSalesLine.Type::Item);
        RecLKitSalesLine.SetFilter("Remaining Quantity", '<>0');

        if not RecLKitSalesLine.IsEmpty then begin
            BooLOK := true;
            RecLKitSalesLine.FindSet();
            repeat
                DecGQtyReserv := 0;
                RecLKitSalesLine.CalcFields("Reserved Quantity");
                if (RecLKitSalesLine."Reserved Quantity" < RecLKitSalesLine."Remaining Quantity (Base)") then
                    BooLOK := false
                else
                    if (RecLKitSalesLine."Reserved Quantity" <> 0) then begin
                        RecL337.SetRange("Source Type", DATABASE::"Assembly Line");
                        RecL337.SetRange("Source Subtype", RecLKitSalesLine."Document Type");
                        RecL337.SetRange("Source Subtype", RecLKitSalesLine."Document Type");
                        RecL337.SetRange("Source ID", RecLKitSalesLine."Document No.");
                        RecL337.SetRange("Source Ref. No.", RecLKitSalesLine."Line No.");
                        RecL337.SetRange("Reservation Status", RecL337."Reservation Status"::Reservation);
                        if RecL337.FindSet() then
                            repeat
                                RecL337b.SetRange("Entry No.", RecL337."Entry No.");
                                RecL337b.SetFilter("Source Type", '<>901');
                                if RecL337b.FindSet() then
                                    if RecL337b."Source Type" <> DATABASE::"Item Ledger Entry" then
                                        BooLOK := false;
                                if RecL337b."Source Type" = DATABASE::"Purchase Line" then
                                    BooGPurchase := true;
                                DecGQtyReserv += RecL337b."Quantity (Base)";
                            until (RecL337.Next() = 0) or (BooLOK = false);
                    end;

                if not BooGPurchase and (DecGQtyReserv < RecLKitSalesLine."Remaining Quantity (Base)") then
                    if FctCkeckAvailableItem(RecLKitSalesLine, RecLKitSalesLine."Remaining Quantity (Base)" - DecGQtyReserv) then
                        BooLOK := true
                    else
                        BooLOK := false;

            until (RecLKitSalesLine.Next() = 0) or not BooLOK;
        end;
    end;

    procedure FctCkeckAvailableItem(RecPKitSalesLine: Record "Assembly Line"; DecPQty: Decimal) BooLOK: Boolean;
    var
        RecLItem: Record Item;
        DecLAvailable: Decimal;
        DecLDisposalQtyStock: Decimal;
    begin
        RecLItem.Get(RecPKitSalesLine."No.");
        RecLItem.CalcFields(Inventory, "Reserved Qty. on Inventory",
                            "Qty. on Sales Order", "Reserved Qty. on Purch. Orders");
        DecLDisposalQtyStock := RecLItem.Inventory - (RecLItem."Reserved Qty. on Inventory");
        DecLAvailable := RecLItem.Inventory - (RecLItem."Qty. on Sales Order")
                     + RecLItem."Reserved Qty. on Purch. Orders";
        if DecLDisposalQtyStock >= DecPQty then begin
            if DecLAvailable < 0 then begin
                BooGNegativeAvailable := true; //Verif dispo
                BooLOK := false;
            end else
                BooLOK := true;
        end else
            BooLOK := false;
    end;
}
