namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Utilities;
using Microsoft.Inventory.Tracking;
using Microsoft.Assembly.Document;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.BOM;
using Microsoft.Inventory.Location;
using Microsoft.Warehouse.Activity;
using Microsoft.Foundation.NoSeries;
using Microsoft.Purchases.Setup;
tableextension 50010 SalesLine extends "Sales Line" //37
{
    fields
    {
        modify("No.")
        {
            //TODO: ValidateTableRelation cannot be customized
            //ValidateTableRelation=false;
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true),
            "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(true)) "G/L Account"
            else
            if (Type = const(Item), "Item Base" = const(Standard)) Item where("Quote Associated" = filter(false))
            else
            if (Type = const(Item), "Item Base" = const(Transitory)) Item where("Quote Associated" = filter(false))
            else
            if (Type = const(Item), "Item Base" = const("Transitory Kit")) Item where("Quote Associated" = filter(false))
            else
            if (Type = const(Item), "Item Base" = const("Bored blocks")) Item where("Quote Associated" = filter(false))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge";
            trigger OnBeforeValidate()
            begin
                FctTestNo();
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                RecLItem: Record Item;
            begin
                RecLItem.CALCFIELDS("Assembly BOM");
                if (Quantity <> 0) and (xRec.Quantity = 0) and (RecLItem."Assembly BOM") then
                    if ("Document Type" in
                       ["Document Type"::Quote, "Document Type"::Order, "Document Type"::Invoice, "Document Type"::"Blanket Order"])
                    then
                        if not BooGParmFromCompileBL then
                            VALIDATE("Qty. to Assemble to Order", Quantity);
                if Type = Type::Item then begin
                    RecLItem.GET("No.");
                    "Item Work Time" := RecLItem."Item Work Time" * Quantity;
                    "Item Machining Time" := RecLItem."Item Machining Time" * Quantity;
                end;
            end;
        }
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Margin %");
                if "Line Discount %" <> 0 then
                    VALIDATE("Unit Price Discounted", ROUND(ROUND("Unit Price", Currency."Amount Rounding Precision") *
                                                          (1 - ("Line Discount %" / 100)), Currency."Amount Rounding Precision"))
                else
                    VALIDATE("Unit Price Discounted", "Unit Price");
            end;
        }
        modify("Line Amount")
        {
            trigger OnAfterValidate()
            begin
                if "Line Amount" <> 0 then
                    VALIDATE("Unit Price Discounted", ROUND("Line Amount" / Quantity, 0.01))
                else
                    VALIDATE("Unit Price Discounted", 0);
            end;
        }
        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            var
                NewShipmentDate: Date;
            begin
                if "Promised Delivery Date" <> 0D then
                    "Planned Shipment Date" := CALCDATE("Shipping Time", "Promised Delivery Date")
                else
                    if "Requested Delivery Date" <> 0D then
                        "Planned Shipment Date" := CALCDATE("Shipping Time", "Requested Delivery Date");
                if "Requested Delivery Date" <> 0D then begin
                    NewShipmentDate := CALCDATE('<-2D>', "Requested Delivery Date");
                    "Shipment Date" := NewShipmentDate;
                    UpdateAssembleOrderLink(NewShipmentDate);
                end
                else begin
                    "Shipment Date" := 0D;
                    UpdateAssembleOrderLink(0D);
                end;
            end;
        }
        modify("Promised Delivery Date")
        {
            trigger OnAfterValidate()
            var
                NewShipmentDate: Date;
            begin
                if "Promised Delivery Date" <> 0D then
                    "Planned Shipment Date" := CALCDATE("Shipping Time", "Promised Delivery Date")
                else
                    if "Requested Delivery Date" <> 0D then
                        "Planned Shipment Date" := CALCDATE("Shipping Time", "Requested Delivery Date");
                if "Promised Delivery Date" <> 0D then begin
                    NewShipmentDate := CALCDATE('<-2D>', "Promised Delivery Date");
                    "Shipment Date" := NewShipmentDate;
                    UpdateAssembleOrderLink(NewShipmentDate);
                end
                else begin
                    NewShipmentDate := CALCDATE('<-2D>', "Requested Delivery Date");
                    "Shipment Date" := NewShipmentDate;
                    UpdateAssembleOrderLink(NewShipmentDate);
                end;
            end;
        }
        field(50000; "Preparation Type"; Enum "Preparation Type")
        {
            Caption = 'Preparation Type';
        }
        field(50001; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
            trigger OnValidate()
            var
                RecLItem: Record Item;
                DecGUnitPrice: Decimal;
            begin
                "Margin %" := 0;
                if Type = Type::Item then begin
                    RecLItem.Get("No.");
                    if "Unit Price" <> 0 then begin
                        DecGUnitPrice := "Unit Price";
                        if "Line Discount %" <> 0 then
                            DecGUnitPrice := DecGUnitPrice * (1 - ("Line Discount %" / 100));
                        "Margin %" := 100 * (DecGUnitPrice - "Purchase Price Base") / DecGUnitPrice;
                    end;
                end;
            end;
        }
        field(50002; "Item Base"; enum ItemBase)
        {
            Caption = 'Item Base';
            trigger OnValidate()
            begin
                if (Type = Type::Item) and ("No." <> '') and ("Item Base" <> xRec."Item Base") then
                    FctTestNo();
            end;
        }
        field(50003; "Item No.2"; Code[20])
        {
            CalcFormula = lookup(Item."No. 2" where("No." = field("No.")));
            Caption = 'No. 2 (item)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Order Date"; Date)
        {
            CalcFormula = lookup("Sales Header"."Order Date" where("Document Type" = field("Document Type"),
                                                                    "Sell-to Customer No." = field("Sell-to Customer No."),
                                                                   "No." = field("Document No.")));
            Caption = 'Order Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Item Lead Time Calculation"; DateFormula)
        {
            CalcFormula = lookup(Item."Lead Time Calculation" where("No." = field("No.")));
            Caption = 'Item Lead Time Calculation';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Qty to be Ordered"; Decimal)
        {
            Caption = 'Qty to be Ordered';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                if ("Qty to be Ordered" <> 0) then
                    CALCFIELDS("Reserved Quantity");
            end;
        }
        field(50008; "Kit Qty To Build Up"; Decimal)
        {
            Caption = 'Kit Qty To Build Up';
            DecimalPlaces = 0 : 5;
        }
        field(50009; "Selected for Order"; Boolean)
        {
            Caption = 'Selected for Order';
            InitValue = false;

            trigger OnValidate()
            begin
                if "Selected for Order" and ("Qty to be Ordered" = 0) then begin
                    CALCFIELDS("Reserved Quantity");
                    "Qty to be Ordered" := "Outstanding Quantity" - "Reserved Quantity";
                end;
                if not "Selected for Order" then
                    "Qty to be Ordered" := 0;
                if "Selected for Order" then
                    "Internal field" := true
                else
                    "Internal field" := false;
            end;
        }
        field(50010; "Order Shipment  Date"; Date)
        {
            CalcFormula = lookup("Sales Header"."Order Shipment Date" where("Document Type" = field("Document Type"),
                                                                            "No." = field("Document No.")));
            Caption = 'Order Shipment  Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Item Vendor No."; Code[20])
        {
            Caption = 'Item Vendor No.';
            TableRelation = Vendor;
        }
        field(50015; "Quote Associated"; Boolean)
        {
            CalcFormula = exist(Item where("No." = field("No."),
                                            "Quote Associated" = filter(true)));
            Caption = 'Quote Associated';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50020; "Qty Not Assign FTA"; Decimal)
        {
            Caption = 'Qty. to Assign FTA';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50021; "Internal field"; Boolean)
        {
            Caption = 'Internal field';
            Editable = false;
        }
        field(50022; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(50023; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
        }
        field(50024; "Inventory Value Zero"; Boolean)
        {
            CalcFormula = lookup(Item."Inventory Value Zero" where("No." = field("No.")));
            Caption = 'Inventory Value Zero';
            FieldClass = FlowField;
        }
        field(50030; "Item No. 2"; Code[20])
        {
            CalcFormula = lookup(Item."No. 2" where("No." = field("No.")));
            Caption = 'Item No. 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50031; "Purchase Price Base"; Decimal)
        {
            Caption = 'Purchase Price Base';
            trigger OnValidate()
            begin
                Validate("Margin %");
            end;
        }
        field(50032; "Unit Price Discounted"; Decimal)
        {
            Caption = 'Unit Price Discounted';
            Editable = false;
        }
        field(50040; "Item Work Time"; Integer)
        {
            BlankZero = true;
            Caption = 'Temps de montage';
            Editable = false;
            TableRelation = "Work Time";
        }
        field(50041; Prepare; Boolean)
        {
            Caption = 'Préparé';
            trigger OnValidate()
            var
                TextLCst001: Label 'Quantité restante de doit pas être 0.';
            begin
                if "Outstanding Quantity" = 0 then
                    Error(TextLCst001);
            end;
        }
        field(50042; "Item Machining Time"; Integer)
        {
            BlankZero = true;
            Caption = 'Temps d''usinage';
            Editable = false;
            TableRelation = "Work Time";
        }
        field(50043; "Start Date"; Date)
        {
            Caption = 'Date départ';
        }
        field(50044; "Parcel No."; Integer)
        {
            Caption = 'Parcel No.';
        }
        field(50045; "Shipping Costs"; Boolean)
        {
        }
        field(51000; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordered';
        }
        field(51001; "Qty Shipped on Order"; Decimal)
        {
            Caption = 'Qty Shipped on Order';
        }
    }
    keys
    {
        key(Key50001; "Shortcut Dimension 1 Code", "Document No.")
        {
        }
        key(Key50003; Type, "No.")
        {
            SumIndexFields = "Outstanding Quantity";
        }
    }
    trigger OnAfterInsert()
    begin
        GetSalesHeader();
        "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
    end;

    trigger OnAfterDelete()
    begin
        Commit();
    end;

    procedure FctReserveOnStock(RecPSalesLine: Record "Sales Line"; DecPQtyToReserv: Decimal; var RemainingQtyToReserveBase: Decimal)
    var
        RecLEntrySummary: Record "Entry Summary" temporary;
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLLocation: Record Location;
        RecLReservEntry: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
        CduLCreatePick: Codeunit "Create Pick";
        ReservMgt: Codeunit "Reservation Management";
        FrmLAvailableItemLedgEntries: page "Available - Item Ledg. Entries";
        Reservation: Page Reservation;
        DecLOriginQuantity: Decimal;
        DecLWorkQty: Decimal;
        "**PAMO": Integer;
    begin
        if (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or (DecPQtyToReserv = 0) then
            exit;

        if (RecPSalesLine."Document Type" in [RecPSalesLine."Document Type"::Quote, RecPSalesLine."Document Type"::"Credit Memo",
            RecPSalesLine."Document Type"::"Blanket Order", RecPSalesLine."Document Type"::"Return Order"]) or
           (RecPSalesLine."Shipment Date" = 0D) or
           (RecPSalesLine."Drop Shipment") or
           (RecPSalesLine."Location Code" = '') or
           (RecPSalesLine."No." = '') or
           (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or
           (RecPSalesLine.Quantity = 0) then
            exit;

        RecPSalesLine.CALCFIELDS("Reserved Quantity");
        if RecPSalesLine.Quantity = RecPSalesLine."Reserved Quantity" then
            exit;

        RecLSalesLine := RecPSalesLine;
        RecLSalesLine.TESTFIELD(Type, Type::Item);
        RecLSalesLine.TESTFIELD("No.");
        Clear(Reservation);
        Reservation.SetReservSource(RecLSalesLine);
        ReservMgt.SetReservSource(RecLSalesLine);
        // Reservation.SetSalesLine(RecLSalesLine);
        // ReservMgt.SetSalesLine(RecLSalesLine);
        ReservMgt.AutoReserveOneLine(
          1, DecPQtyToReserv, RemainingQtyToReserveBase, RecLReservEntry.Description,
          RecLReservEntry."Shipment Date");
        RecLSalesLine.SetHideValidationDialog(true);

        DecLOriginQuantity := RecLSalesLine.Quantity;
        RecLSalesLine.CALCFIELDS(RecLSalesLine."Reserved Quantity");
        if RecLSalesLine."Reserved Quantity" <> DecLOriginQuantity then
            RecLSalesLine.Validate(Quantity, RecLSalesLine."Reserved Quantity");
        RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Stock;
        Validate("Qty. to Assemble to Order", 0);
        RecLSalesLine.MODIFY();
        if Type = Type::Item then
            ATOLink.DeleteAsmFromSalesLine(Rec);
        RecLSalesLine.SetHideValidationDialog(false);
    end;

    procedure FctReserveOnPurchLine(RecPSalesLine: Record "Sales Line"; DecPQtyToReserv: Decimal)
    var
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLLocation: Record Location;
        RecLPurchLine: Record "Purchase Line";
        RecLReservEntry: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
        CduLCreatePick: Codeunit "Create Pick";
        FTAFunctions: Codeunit FTA_Functions;
        FrmLAvailableItemLedgEntries: page "Available - Item Ledg. Entries";
        FrmLAvailablePurchLines: Page "Available - Purchase Lines";
        DecLOriginQuantity: Decimal;
        DecLQuantityRes: Decimal;
        DecLWorkQty: Decimal;
        DecPQtyToReservBase: Decimal;
    begin
        if (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or (DecPQtyToReserv = 0) then
            exit;
        if (RecPSalesLine."Document Type" in [RecPSalesLine."Document Type"::Quote, RecPSalesLine."Document Type"::"Credit Memo",
            RecPSalesLine."Document Type"::"Blanket Order", RecPSalesLine."Document Type"::"Return Order"]) or
           (RecPSalesLine."Shipment Date" = 0D) or
           (RecPSalesLine."Drop Shipment") or
           (RecPSalesLine."Location Code" = '') or
           (RecPSalesLine."No." = '') or
           (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or
           (RecPSalesLine.Quantity = 0) then
            exit;

        RecPSalesLine.CALCFIELDS("Reserved Quantity");
        if RecPSalesLine.Quantity = RecPSalesLine."Reserved Quantity" then
            exit;

        RecLSalesLine := RecPSalesLine;
        RecLSalesLine.TESTFIELD(Type, Type::Item);
        RecLSalesLine.TESTFIELD("No.");
        Clear(Reservation);
        Reservation.SetReservSource(RecLSalesLine);
        // Reservation.SetSalesLine(RecLSalesLine);
        Reservation.GetReservEntry(RecLReservEntry);
        DecPQtyToReservBase := DecPQtyToReserv * RecPSalesLine."Qty. per Unit of Measure";
        ReservMgt.SetReservSource(RecLSalesLine);
        //ReservMgt.SetSalesLine(RecLSalesLine);
        //TODO: codeunit Reservation management not migrated yet
        // if BooGResaFTA then
        //     ReservMgt.FctSetBooResaFTA(true);
        ReservMgt.AutoReserveOneLine(
          12, DecPQtyToReserv, DecPQtyToReservBase, RecLReservEntry.Description,
          RecLReservEntry."Shipment Date");

        RecLSalesLine.SetHideValidationDialog(true);

        DecLOriginQuantity := RecLSalesLine.Quantity;
        RecLSalesLine.CALCFIELDS(RecLSalesLine."Reserved Quantity");
        if RecLSalesLine."Reserved Quantity" <> DecLOriginQuantity then
            RecLSalesLine.Validate(Quantity, RecLSalesLine."Reserved Quantity");
        RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Purchase;
        Validate("Qty. to Assemble to Order", 0);

        RecLSalesLine.MODIFY();

        if Type = Type::Item then
            ATOLink.DeleteAsmFromSalesLine(Rec);
        RecLSalesLine.SetHideValidationDialog(false);

    end;

    procedure FctReserveOnKit(RecPSalesLine: Record "Sales Line"; DecPQtyToReserv: Decimal)
    var
        RecLEntrySummary: Record "Entry Summary" temporary;
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLLocation: Record Location;
        RecLReservEntry: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
        CduLCreatePick: Codeunit "Create Pick";
        ReservMgt: Codeunit "Reservation Management";
        FrmLAvailableItemLedgEntries: page "Available - Item Ledg. Entries";
        DecLLineDisc: Decimal;
        DecLOriginQuantity: Decimal;
        DecLWorkQty: Decimal;
        "**PAMO": Integer;
    begin
        if (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or (DecPQtyToReserv = 0) then
            exit;

        if (RecPSalesLine."Document Type" in [RecPSalesLine."Document Type"::Quote, RecPSalesLine."Document Type"::"Credit Memo",
            RecPSalesLine."Document Type"::"Blanket Order", RecPSalesLine."Document Type"::"Return Order"]) or
           (RecPSalesLine."Shipment Date" = 0D) or
           (RecPSalesLine."Drop Shipment") or
           (RecPSalesLine."Location Code" = '') or
           (RecPSalesLine."No." = '') or
           (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or
           (RecPSalesLine.Quantity = 0) then
            exit;

        RecPSalesLine.CALCFIELDS("Reserved Quantity");
        if RecPSalesLine.Quantity = RecPSalesLine."Reserved Quantity" then
            exit;

        RecLSalesLine := RecPSalesLine;

        if not Item.Get("No.") then
            Clear(Item);

        RecLSalesLine.SetHideValidationDialog(true);

        DecLOriginQuantity := RecLSalesLine.Quantity;

        DecLLineDisc := "Line Discount %";
        RecLSalesLine.Validate(Quantity, DecPQtyToReserv);
        if DecLLineDisc <> 0 then
            RecLSalesLine.Validate("Line Discount %", DecLLineDisc);
        RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Assembly;

        RecLSalesLine.MODIFY();

        Item.CALCFIELDS("Assembly BOM");
        if Item."Assembly BOM" = false then
            exit;
        FctKitAutoReserveFTA(RecLSalesLine);

        RecLSalesLine.SetHideValidationDialog(false);

    end;

    procedure FctNotReserv(RecPSalesLine: Record "Sales Line"; DecPQtyToReserv: Decimal)
    var
        RecLEntrySummary: Record "Entry Summary" temporary;
        RecLItemLedgerEntry: Record "Item Ledger Entry";
        RecLLocation: Record Location;
        RecLReservEntry: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
        CduLCreatePick: Codeunit "Create Pick";
        ReservMgt: Codeunit "Reservation Management";
        FrmLAvailableItemLedgEntries: page "Available - Item Ledg. Entries";
        DecLOriginQuantity: Decimal;
        DecLWorkQty: Decimal;
        "**PAMO": Integer;
    begin
        if (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or (DecPQtyToReserv = 0) then
            exit;

        if (RecPSalesLine."Document Type" in [RecPSalesLine."Document Type"::Quote, RecPSalesLine."Document Type"::"Credit Memo",
            RecPSalesLine."Document Type"::"Blanket Order", RecPSalesLine."Document Type"::"Return Order"]) or
           (RecPSalesLine."Shipment Date" = 0D) or
           (RecPSalesLine."Drop Shipment") or
           (RecPSalesLine."Location Code" = '') or
           (RecPSalesLine."No." = '') or
           (RecPSalesLine.Type <> RecPSalesLine.Type::Item) or
           (RecPSalesLine.Quantity = 0) then
            exit;

        RecPSalesLine.CALCFIELDS("Reserved Quantity");
        if RecPSalesLine.Quantity = RecPSalesLine."Reserved Quantity" then
            exit;

        RecLSalesLine := RecPSalesLine;

        if not Item.Get("No.") then
            Clear(Item);

        RecLSalesLine.SetHideValidationDialog(true);

        RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Remainder;

        Validate("Qty. to Assemble to Order", 0);

        RecLSalesLine.MODIFY();

        if Type = Type::Item then
            ATOLink.DeleteAsmFromSalesLine(Rec);

        RecLSalesLine.SetHideValidationDialog(false);
    end;

    procedure FctCreateSalesLine(var RecPSalesLine: Record "Sales Line"; DecPWorkQty: Decimal; var IntPLineNo: Integer)
    var
        RecLSalesLine2: Record "Sales Line";
        RecLSalesLine: Record "Sales Line";
        BooLOk: Boolean;
    begin
        RecLSalesLine.Init();
        RecLSalesLine.TRANSFERFIELDS(RecPSalesLine);
        RecLSalesLine2.SetRange("Document Type", RecPSalesLine."Document Type");
        RecLSalesLine2.SetRange("Document No.", RecPSalesLine."Document No.");
        RecLSalesLine2.SetRange("Attached to Line No.", RecPSalesLine."Line No.");
        if RecLSalesLine2.FindLast() then
            IntPLineNo := RecLSalesLine2."Line No." + 5
        else
            IntPLineNo := RecPSalesLine."Line No." + 5;

        RecLSalesLine2.Reset();
        repeat
            if not RecLSalesLine2.Get(RecPSalesLine."Document Type", RecPSalesLine."Document No.", IntPLineNo) then
                BooLOk := true
            else
                IntPLineNo += 5;
        until BooLOk = true;
        RecLSalesLine."Line No." := IntPLineNo;

        RecLSalesLine.Insert();

        Validate("Qty. to Assemble to Order", 0);

        RecLSalesLine.Validate(Type, RecPSalesLine.Type);
        RecLSalesLine."Item Base" := RecPSalesLine."Item Base";
        RecLSalesLine.Validate("No.", RecPSalesLine."No.");

        Validate("Qty. to Assemble to Order", 0);

        RecLSalesLine.Validate("Location Code", RecPSalesLine."Location Code");
        RecLSalesLine.Validate(Quantity, DecPWorkQty);

        Validate("Qty. to Assemble to Order", 0);

        RecLSalesLine.Validate("Preparation Type", "Preparation Type"::Remainder);
        RecLSalesLine."Item Reference No." := RecLSalesLine."Item Reference No.";
        //RecLSalesLine."Cross-Reference No." := RecLSalesLine."Cross-Reference No.";
        RecLSalesLine.Description := RecLSalesLine.Description;
        RecLSalesLine."Description 2" := RecLSalesLine."Description 2";
        RecLSalesLine."Item Base" := RecPSalesLine."Item Base";

        RecLSalesLine.MODIFY(true);
    end;

    procedure FctDeleteReservation()
    var
        ReservEntry2: Record "Reservation Entry";
        ReservEntry3: Record "Reservation Entry";
    begin

        if Type <> Type::Item then
            exit;

        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, true);
        Rec.SetReservationFilters(ReservEntry);
        //ReserveSalesLine.FilterReservFor(ReservEntry, Rec);


        if ReservEntry.Find('-') then
            repeat
                Clear(ReservEntry2);
                ReservEntry2 := ReservEntry;
                ReservEntry2.SetPointerFilter();
                //ReservMgt.SetPointerFilter(ReservEntry2);
                ReservEntry2.SetRange("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
                if ReservEntry2.Find('-') then
                    repeat
                        ReservEntry3.Get(ReservEntry2."Entry No.", not ReservEntry2.Positive);
                        "FTA_Functions".CloseReservEntry2(ReservEntry2);
                    // ReservEngineMgt.CloseReservEntry2(ReservEntry2);
                    until ReservEntry2.NEXT() = 0;
            until ReservEntry.NEXT() = 0;

        MODIFY();
    end;

    procedure FctShowKitLinesFTA()
    var
        KitSalesLine: Record "Assembly Line";
        KitSalesLines: page "Assemble-to-Order Lines";
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        if FctGetATOLinkToSalesLine(Rec) then begin
            KitSalesLine.SetRange("Document Type", RecGATOLinkToSalesLine."Assembly Document Type");
            KitSalesLine.SetRange("Document No.", RecGATOLinkToSalesLine."Assembly Document No.");
            KitSalesLines.SetTableView(KitSalesLine);
            KitSalesLines.FctSetParm(true);
            KitSalesLines.Run();
        end;
    end;

    procedure FctCalcQtyToSetOn()
    var
        KitSalesLine: Record "Assembly Line";
        BooLFirstRec: Boolean;
    begin
        "Kit Qty To Build Up" := 0;
        if not FctIsBuildKit(Rec) then
            exit;

        if FctGetATOLinkToSalesLine(Rec) then begin
            KitSalesLine.SetRange("Document Type", RecGATOLinkToSalesLine."Assembly Document Type");
            KitSalesLine.SetRange("Document No.", RecGATOLinkToSalesLine."Assembly Document No.");
            BooLFirstRec := false;
            if KitSalesLine.FindSet() then
                repeat
                    if not BooLFirstRec then begin
                        "Kit Qty To Build Up" := KitSalesLine."Reserved Quantity" - KitSalesLine."Quantity per";
                        BooLFirstRec := true;
                    end else
                        if (KitSalesLine."Reserved Quantity" - KitSalesLine."Quantity per") < "Kit Qty To Build Up" then
                            "Kit Qty To Build Up" := KitSalesLine."Reserved Quantity" - KitSalesLine."Quantity per";
                until KitSalesLine.NEXT() = 0;

        end;
    end;

    procedure FctTestNo()
    var
        RecLFixedAsset: Record "Fixed Asset";
        RecLGLAcc: Record "G/L Account";
        RecLItem: Record Item;
        RecLItemCharge: Record "Item Charge";
        RecLRes: Record Resource;
        RecLStandardText: Record "Standard Text";
        FrmTransitoryItem: page "50005";
        FrmTransitoryKitItem: Page "50010";
        PagBoredBlocksItemCard: page "50017";
        BooLItemNoFound: Boolean;
        CstL001: Label 'Do you want to create the %1 item %2? ';
        CstL002: Label 'Process cancelled';
        CstL003: Label 'Item No. %1 does not exist.';
        CstL004: Label 'G/L account %1 does not exist.';
        CstL005: Label 'Resource %1 does not exist.';
        CstL006: Label 'Item Charge %1 does not exist.';
        CstL007: Label 'Fixed asset %1 does not exist.';
        CstL010: Label 'Item No. %1 created.';
    begin
        case Type of
            Type::" ":
                RecLStandardText.Get("No.");
            Type::"G/L Account":
                if not RecLGLAcc.Get("No.") then begin
                    RecLGLAcc.SetFilter("Search Name", StrSubstNo('%1%2', UPPERCASE("No."), '*'));
                    if RecLGLAcc.FindSet() then
                        "No." := RecLGLAcc."No."
                    else
                        Error(CstL004, "No.");
                end;
            Type::Resource:
                if not RecLRes.Get("No.") then begin
                    RecLRes.SetFilter("Search Name", StrSubstNo('%1%2', UPPERCASE("No."), '*'));
                    if RecLGLAcc.FindSet() then
                        "No." := RecLRes."No."
                    else
                        Error(CstL005, "No.");
                end;
            Type::"Fixed Asset":
                if not RecLFixedAsset.Get("No.") then begin
                    RecLFixedAsset.SetFilter("Search Description", StrSubstNo('%1%2', UPPERCASE("No."), '*'));
                    if RecLFixedAsset.FindSet() then
                        "No." := RecLFixedAsset."No."
                    else
                        Error(CstL007, "No.");
                end;
            Type::"Charge (Item)":
                if not RecLItemCharge.Get("No.") then begin
                    RecLItemCharge.SetFilter("Search Description", StrSubstNo('%1%2', UPPERCASE("No."), '*'));
                    if RecLItemCharge.FindSet() then
                        "No." := RecLItem."No."
                    else
                        Error(CstL006, "No.");
                end;
            Type::Item:
                begin
                    RecLItem.Reset();
                    case "Item Base" of
                        "Item Base"::Standard:
                            RecLItem.SetRange("Item Base", RecLItem."Item Base"::Standard);
                        "Item Base"::Transitory:
                            RecLItem.SetRange("Item Base", RecLItem."Item Base"::Transitory);
                        "Item Base"::"Transitory Kit":
                            RecLItem.SetRange("Item Base", RecLItem."Item Base"::"Transitory Kit");
                        "Item Base"::"Bored blocks":
                            RecLItem.SetRange("Item Base", RecLItem."Item Base"::"Bored blocks");
                    end;
                    RecLItem.SetRange("No.", "No.");
                    BooLItemNoFound := false;
                    if RecLItem.FindSet() then
                        repeat
                            if ("Item Base" = RecLItem."Item Base") then begin
                                BooLItemNoFound := true;
                                "No." := RecLItem."No."
                            end;
                        until (RecLItem.NEXT() = 0) or (BooLItemNoFound = true);
                    RecLItem.SetRange("No.");
                    if not BooLItemNoFound then begin
                        RecLItem.SetFilter("Search Description", StrSubstNo('%1%2', UPPERCASE("No."), '*'));
                        if RecLItem.FindSet() then
                            repeat
                                if ("Item Base" = RecLItem."Item Base") then begin
                                    BooLItemNoFound := true;
                                    "No." := RecLItem."No."
                                end;
                            until (RecLItem.NEXT() = 0) or (BooLItemNoFound = true);
                    end;
                    if not BooLItemNoFound then
                        case "Item Base" of
                            "Item Base"::Standard:
                                Error(CstL003, "No.");
                            "Item Base"::Transitory:
                                begin
                                    if not CONFIRM(StrSubstNo(CstL001, "Item Base", "No."), false) then
                                        Error(CstL002);
                                    RecLItem.Init();
                                    RecLItem."Item Base" := "Item Base"::Transitory;
                                    RecLItem.Insert(true);
                                    RecLItem.Validate(Description, "No.");
                                    GetSalesHeader();
                                    RecLItem.Validate("Customer Code", SalesHeader."Sell-to Customer No.");
                                    RecLItem.MODIFY(true);
                                    "No." := RecLItem."No.";
                                    Commit();
                                    Clear(FrmTransitoryItem);
                                    RecLItem.Reset();
                                    RecLItem.SetRange("No.", RecLItem."No.");
                                    FrmTransitoryItem.SetTableView(RecLItem);
                                    FrmTransitoryItem.RunModal();
                                end;
                            "Item Base"::"Transitory Kit":
                                begin
                                    if not CONFIRM(StrSubstNo(CstL001, "Item Base", "No.")) then
                                        Error(CstL002);
                                    RecLItem.Init();
                                    RecLItem."Item Base" := "Item Base"::"Transitory Kit";
                                    RecLItem."Replenishment System" := RecLItem."Replenishment System"::Assembly;
                                    RecLItem.Insert(true);
                                    RecLItem.Validate(Description, "No.");
                                    GetSalesHeader();
                                    RecLItem.Validate("Customer Code", SalesHeader."Sell-to Customer No.");
                                    if "Document Type" = "Document Type"::Quote then
                                        RecLItem."Quote Associated" := true;
                                    RecLItem.MODIFY(true);
                                    Commit();
                                    Clear(FrmTransitoryKitItem);
                                    RecLItem.Reset();
                                    RecLItem.SetRange("No.", RecLItem."No.");
                                    FrmTransitoryKitItem.SetTableView(RecLItem);
                                    FrmTransitoryKitItem.RunModal();
                                    "No." := RecLItem."No.";
                                end;
                            "Item Base"::"Bored blocks":
                                begin
                                    if not CONFIRM(StrSubstNo(CstL001, "Item Base", "No.")) then
                                        Error(CstL002);
                                    RecLItem.Init();
                                    RecLItem."Item Base" := "Item Base"::"Bored blocks";
                                    RecLItem."Replenishment System" := RecLItem."Replenishment System"::Assembly;
                                    RecLItem.Insert(true);
                                    RecLItem.Validate(Description, "No.");
                                    GetSalesHeader();
                                    RecLItem.Validate("Customer Code", SalesHeader."Sell-to Customer No.");
                                    if "Document Type" = "Document Type"::Quote then
                                        RecLItem."Quote Associated" := true;
                                    RecLItem.MODIFY(true);
                                    Commit();
                                    Clear(PagBoredBlocksItemCard);
                                    RecLItem.Reset();
                                    RecLItem.SetRange("No.", RecLItem."No.");
                                    PagBoredBlocksItemCard.SetTableView(RecLItem);
                                    PagBoredBlocksItemCard.RunModal();
                                    "No." := RecLItem."No.";
                                end;

                        end;
                end;
        end;

    end;

    procedure FctSelectRecForOrder(var RecPSalesLine: Record "Sales Line")
    begin
        RecPSalesLine.Reset();

        RecPSalesLine.SetCurrentKey("Document Type", Type, "Outstanding Quantity", "Internal field", "Vendor No.", "No.", "Location Code");

        RecPSalesLine.SetFilter("Document Type", '%1|%2', RecPSalesLine."Document Type"::Order, RecPSalesLine."Document Type"::Invoice);
        RecPSalesLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecPSalesLine.SetFilter("Outstanding Quantity", '<>0');
        if RecPSalesLine.FindFirst() then
            repeat
                RecPSalesLine.CALCFIELDS("Reserved Qty. (Base)");
                if (RecPSalesLine."Outstanding Qty. (Base)" > RecPSalesLine."Reserved Qty. (Base)") and (RecPSalesLine."Qty. to Assemble to Order" = 0) then begin
                    RecPSalesLine."Internal field" := true;
                    if (RecPSalesLine."Qty to be Ordered" = 0) and
                       (RecPSalesLine."Selected for Order" = true) then
                        RecPSalesLine.Validate("Selected for Order", true);
                end else
                    RecPSalesLine."Internal field" := false;
                RecPSalesLine.MODIFY();
            until RecPSalesLine.NEXT() = 0;
        RecPSalesLine.SetRange("Internal field", true);
    end;

    procedure FctCreatePurchaseOrderHeader(CodPVendorNo: Code[20])
    var
        RecLPurchLine: Record "Purchase Line";
        RecLPurchPayablesSetup: Record "Purchases & Payables Setup";
        NoSeriesManagement: codeunit NoSeriesManagement;
    begin
        RecLPurchPayablesSetup.Get();

        RecGPurchHeader.Init();
        RecGPurchHeader."No." := '';
        RecGPurchHeader.SetHideValidationDialog(true);
        RecGPurchHeader.Validate("Document Type", RecGPurchHeader."Document Type"::Order);
        RecGPurchHeader.Validate(Status, RecGPurchHeader.Status::Open);
        RecGPurchHeader.Status := RecGPurchHeader.Status::Open;
        RecGPurchHeader.Validate("Posting Date", WORKDATE());
        RecGPurchHeader.Validate("Buy-from Vendor No.", CodPVendorNo);
        RecGPurchHeader.Insert(true);
        RecGPurchHeader.Validate("Order Date", WORKDATE());
        RecGPurchHeader.Validate("Shortcut Dimension 1 Code");
        RecGPurchHeader.Validate("Shortcut Dimension 2 Code");
        RecGPurchHeader.MODIFY();
    end;

    procedure FctCreatePurchaseOrderLine(var RecPSalesLine: Record "Sales Line"; var CodPDocNo: Code[20])
    var
        RecLPurchLine2: Record "Purchase Line";
        RecLPurchLine: Record "Purchase Line";
        RecLReservEntry: Record "Reservation Entry";
        RecLSalesLine: Record "Sales Line";
        CodLxItemNo: Code[20];
        CodLxLocationCode: Code[20];
        CodLxVendorNo: Code[20];
        DecLQtyToReserve: Decimal;
        DecLQtyToReserveBase: Decimal;
        IntLLineNo: Integer;
        CstL001: Label '%1 Purchase Order(s).';
    begin
        IntGCountOrder := 0;
        CodLxVendorNo := '';
        RecLSalesLine.SetCurrentKey("Vendor No.", "No.", "Location Code");
        RecLSalesLine.COPYFILTERS(RecPSalesLine);
        RecLSalesLine.SetRange("Selected for Order", true);
        RecLSalesLine.SetRange("Internal field", true);
        RecLSalesLine.SetFilter("Qty to be Ordered", '<>0');
        if RecPSalesLine.GETFILTER("Vendor No.") <> '' then
            RecLSalesLine.SetFilter("Vendor No.", RecPSalesLine.GETFILTER("Vendor No."))
        else
            RecLSalesLine.SetFilter("Vendor No.", '<>%1', '');
        if RecLSalesLine.FindSet() then
            repeat
                if RecLSalesLine."Vendor No." <> CodLxVendorNo then begin
                    FctAddKitLines(RecGPurchHeader."No.", CodLxVendorNo);
                    FctCreatePurchaseOrderHeader(RecLSalesLine."Vendor No.");
                    IntGCountOrder += 1;
                end;
                if (RecLSalesLine."Vendor No." <> CodLxVendorNo) or
                   (RecLSalesLine."No." <> CodLxItemNo) or
                   (RecLSalesLine."Location Code" <> CodLxLocationCode) then begin
                    RecLPurchLine.Init();
                    RecLPurchLine."Document Type" := RecGPurchHeader."Document Type";
                    RecLPurchLine."Document No." := RecGPurchHeader."No.";
                    RecLPurchLine2.SetRange("Document Type", RecLPurchLine."Document Type"::Order);
                    RecLPurchLine2.SetRange("Document No.", RecGPurchHeader."No.");
                    if RecLPurchLine2.FindLast() then
                        IntLLineNo := RecLPurchLine2."Line No." + 10000
                    else
                        IntLLineNo := 10000;
                    RecLPurchLine."Line No." := IntLLineNo;
                    RecLPurchLine.Validate(Type, RecLPurchLine.Type::Item);
                    RecLPurchLine.Validate("No.", RecLSalesLine."No.");
                    RecLPurchLine.Validate("Location Code", RecLSalesLine."Location Code");
                    if (RecLSalesLine."Requested Receipt Date" <> 0D) then begin
                        RecLPurchLine.Validate("Date from Req. Delivery Date", true);
                        if (RecLPurchLine."Requested Receipt Date" = 0D) or
                          (RecLPurchLine."Requested Receipt Date" > RecLSalesLine."Requested Receipt Date") then
                            RecLPurchLine.Validate("Requested Receipt Date", RecLSalesLine."Requested Receipt Date");
                    end else
                        if (RecLPurchLine."Date from Req. Delivery Date" = false) then
                            if (RecLPurchLine."Requested Receipt Date" = 0D) or
                              (RecLPurchLine."Requested Receipt Date" > RecLSalesLine."Requested Delivery Date") then
                                RecLPurchLine.Validate("Requested Receipt Date", RecLSalesLine."Requested Delivery Date");

                    RecLPurchLine.Insert();
                end;
                RecLPurchLine.Validate(Quantity, RecLPurchLine.Quantity + RecLSalesLine."Qty to be Ordered");

                if (RecLSalesLine."Requested Receipt Date" <> 0D) then begin
                    RecLPurchLine.Validate("Date from Req. Delivery Date", true);
                    if (RecLPurchLine."Requested Receipt Date" = 0D) or
                      (RecLPurchLine."Requested Receipt Date" > RecLSalesLine."Requested Receipt Date") then
                        RecLPurchLine.Validate("Requested Receipt Date", RecLSalesLine."Requested Receipt Date");
                end else
                    if (RecLPurchLine."Date from Req. Delivery Date" = false) then
                        if (RecLPurchLine."Requested Receipt Date" = 0D) or
                          (RecLPurchLine."Requested Receipt Date" > RecLSalesLine."Requested Delivery Date") then
                            RecLPurchLine.Validate("Requested Receipt Date", RecLSalesLine."Requested Delivery Date");
                RecLPurchLine.MODIFY();
                RecLSalesLine.CALCFIELDS("Reserved Quantity");
                if ((RecLSalesLine."Outstanding Quantity" - RecLSalesLine."Reserved Quantity") <= RecLSalesLine."Qty to be Ordered") then
                    DecLQtyToReserve := RecLSalesLine."Outstanding Quantity" - RecLSalesLine."Reserved Quantity"
                else
                    DecLQtyToReserve := RecLSalesLine."Qty to be Ordered";
                DecLQtyToReserveBase := DecLQtyToReserve * RecPSalesLine."Qty. per Unit of Measure";

                Clear(Reservation);
                Reservation.SetReservSource(RecLSalesLine);
                // Reservation.SetSalesLine(RecLSalesLine);
                Reservation.GetReservEntry(RecLReservEntry);
                ReservMgt.SetReservSource(RecLSalesLine);
                // ReservMgt.SetSalesLine(RecLSalesLine);
                if RecLPurchLine."Requested Receipt Date" <> 0D then
                    ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Requested Receipt Date")
                else
                    if RecLPurchLine."Expected Receipt Date" <> 0D then
                        ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Expected Receipt Date")
                    else
                        ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLReservEntry."Shipment Date");
                RecLSalesLine.Validate("Selected for Order", false);
                RecLSalesLine.CALCFIELDS("Reserved Quantity");
                if RecLSalesLine."Reserved Quantity" = RecLSalesLine."Outstanding Quantity" then
                    RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Purchase;
                RecLSalesLine.MODIFY();
                CodLxVendorNo := RecLSalesLine."Vendor No.";
                CodLxItemNo := RecLSalesLine."No.";
                CodLxLocationCode := RecLSalesLine."Location Code";
            until RecLSalesLine.NEXT() = 0;

        FctAddKitLines(RecGPurchHeader."No.", CodLxVendorNo);

        FctAddKitLinesAndHeader(RecPSalesLine);
        if IntGCountOrder = 1 then
            CodPDocNo := RecGPurchHeader."No.";

        Message(CstL001, IntGCountOrder);
    end;

    procedure FctAddKitLines(var CodPDocNo: Code[20]; var CodPVendor: Code[20])
    var
        RecLPurchLine2: Record "Purchase Line";
        RecLPurchLine: Record "Purchase Line";
        RecLReservEntry: Record "Reservation Entry";
        CodLxItemNo: Code[20];
        CodLxLocationCode: Code[20];
        CodLxVendorNo: Code[20];
        DecLQtyToReserve: Decimal;
        DecLQtyToReserveBase: Decimal;
        IntLLineNo: Integer;
    begin
        if CodPDocNo = '' then
            exit;
        RecLPurchLine.SetRange("Document Type", RecLPurchLine."Document Type"::Order);
        RecLPurchLine.SetRange("Document No.", CodPDocNo);
        RecLPurchLine.SetRange(Type, RecLPurchLine.Type::Item);
        RecGKitSalesLine.SetCurrentKey("Vendor No.", "No.", "Location Code");
        RecGKitSalesLine.SetRange(Type, RecGKitSalesLine.Type::Item);
        RecGKitSalesLine.SetRange("Vendor No.", RecGPurchHeader."Buy-from Vendor No.");
        RecGKitSalesLine.SetRange("Selected for Order", true);
        RecGKitSalesLine.SetRange("Internal field", true);

        if RecLPurchLine.FindSet() then
            repeat
                RecGKitSalesLine.SetRange("No.", RecLPurchLine."No.");
                if not RecGKitSalesLine.IsEmpty then begin
                    RecGKitSalesLine.FindSet();
                    repeat
                        RecLPurchLine.Validate(Quantity, RecLPurchLine.Quantity + RecGKitSalesLine."Qty to be Ordered");
                        if (RecGKitSalesLine."Requested Receipt Date" <> 0D) then begin
                            RecLPurchLine.Validate("Date from Req. Delivery Date", true);
                            if (RecLPurchLine."Requested Receipt Date" = 0D) or
                              (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Receipt Date") then
                                RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Receipt Date");
                        end else
                            if (RecLPurchLine."Date from Req. Delivery Date" = false) then
                                if (RecLPurchLine."Requested Receipt Date" = 0D) or
                                  (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Delivery Date") then
                                    RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Delivery Date");
                        RecLPurchLine.MODIFY();
                        RecGKitSalesLine.CALCFIELDS("Reserved Quantity");
                        if ((RecGKitSalesLine."Remaining Quantity" - RecGKitSalesLine."Reserved Quantity") <=
                                 RecGKitSalesLine."Qty to be Ordered") then
                            DecLQtyToReserve := RecGKitSalesLine."Remaining Quantity" - RecGKitSalesLine."Reserved Quantity"
                        else
                            DecLQtyToReserve := RecGKitSalesLine."Qty to be Ordered";

                        DecLQtyToReserveBase := DecLQtyToReserve * RecGKitSalesLine."Qty. per Unit of Measure";
                        RecGKitSalesLine."Selected for Order" := false;
                        RecGKitSalesLine.MODIFY();
                        Clear(Reservation);
                        Reservation.SetReservSource(RecGKitSalesLine);
                        // Reservation.SetAssemblyLine(RecGKitSalesLine);
                        Reservation.GetReservEntry(RecLReservEntry);
                        ReservMgt.SetReservSource(RecGKitSalesLine);
                        // ReservMgt.SetAssemblyLine(RecGKitSalesLine);
                        if RecLPurchLine."Requested Receipt Date" <> 0D then
                            ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Requested Receipt Date")
                        else
                            if RecLPurchLine."Expected Receipt Date" <> 0D then
                                ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Expected Receipt Date")
                            else
                                ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLReservEntry."Shipment Date");
                        if RecAssemlyOrder.Get(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.") then;
                        FctMAJPreparationType(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.", RecAssemlyOrder."Document Line No.");
                    until RecGKitSalesLine.NEXT() = 0;
                end;
            until RecLPurchLine.NEXT() = 0;
        CodLxItemNo := '';
        CodLxLocationCode := '';
        RecGKitSalesLine.SetRange("No.");
        if not RecGKitSalesLine.IsEmpty() then begin
            RecGKitSalesLine.FindSet();
            repeat
                if (RecGKitSalesLine."No." <> CodLxItemNo) or
                   (RecGKitSalesLine."Location Code" <> CodLxLocationCode) then begin
                    RecLPurchLine.Init();
                    RecLPurchLine."Document Type" := RecGPurchHeader."Document Type";
                    RecLPurchLine."Document No." := RecGPurchHeader."No.";
                    RecLPurchLine2.SetRange("Document Type", RecLPurchLine."Document Type"::Order);
                    RecLPurchLine2.SetRange("Document No.", CodPDocNo);
                    if RecLPurchLine2.FindLast() then
                        IntLLineNo := RecLPurchLine2."Line No." + 10000
                    else
                        IntLLineNo := 10000;
                    RecLPurchLine."Line No." := IntLLineNo;
                    RecLPurchLine.Validate(Type, RecLPurchLine.Type::Item);
                    RecLPurchLine.Validate("No.", RecGKitSalesLine."No.");
                    RecLPurchLine.Validate("Location Code", RecGKitSalesLine."Location Code");
                    if (RecGKitSalesLine."Requested Receipt Date" <> 0D) then begin
                        RecLPurchLine.Validate("Date from Req. Delivery Date", true);
                        if (RecLPurchLine."Requested Receipt Date" = 0D) or
                          (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Receipt Date") then
                            RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Receipt Date");
                    end else
                        if (RecLPurchLine."Date from Req. Delivery Date" = false) then
                            if (RecLPurchLine."Requested Receipt Date" = 0D) or
                              (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Delivery Date") then
                                RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Delivery Date");

                    RecLPurchLine.Insert();
                end;
                RecLPurchLine.Validate(Quantity, RecLPurchLine.Quantity + RecGKitSalesLine."Qty to be Ordered");
                if (RecGKitSalesLine."Requested Receipt Date" <> 0D) then begin
                    RecLPurchLine.Validate("Date from Req. Delivery Date", true);
                    if (RecLPurchLine."Requested Receipt Date" = 0D) or
                      (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Receipt Date") then
                        RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Receipt Date");
                end else
                    if (RecLPurchLine."Date from Req. Delivery Date" = false) then
                        if (RecLPurchLine."Requested Receipt Date" = 0D) or
                          (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Delivery Date") then
                            RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Delivery Date");
                RecLPurchLine.MODIFY();
                RecGKitSalesLine.CALCFIELDS("Reserved Quantity");
                if ((RecGKitSalesLine."Remaining Quantity" - RecGKitSalesLine."Reserved Quantity") <=
                         RecGKitSalesLine."Qty to be Ordered") then
                    DecLQtyToReserve := RecGKitSalesLine."Remaining Quantity" - RecGKitSalesLine."Reserved Quantity"
                else
                    DecLQtyToReserve := RecGKitSalesLine."Qty to be Ordered";

                DecLQtyToReserveBase := DecLQtyToReserve * RecGKitSalesLine."Qty. per Unit of Measure";
                RecGKitSalesLine.Validate("Selected for Order", false);
                RecGKitSalesLine.MODIFY();
                Clear(Reservation);
                Reservation.SetReservSource(RecGKitSalesLine);
                // Reservation.SetAssemblyLine(RecGKitSalesLine);
                Reservation.GetReservEntry(RecLReservEntry);
                ReservMgt.SetReservSource(RecGKitSalesLine);
                // ReservMgt.SetAssemblyLine(RecGKitSalesLine);
                if RecLPurchLine."Requested Receipt Date" <> 0D then
                    ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Requested Receipt Date")
                else
                    if RecLPurchLine."Expected Receipt Date" <> 0D then
                        ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Expected Receipt Date")
                    else
                        ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLReservEntry."Shipment Date");
                RecAssemlyOrder.Get(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.");
                FctMAJPreparationType(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.", RecAssemlyOrder."Document Line No.");
                CodLxItemNo := RecGKitSalesLine."No.";
                CodLxLocationCode := RecGKitSalesLine."Location Code";
            until RecGKitSalesLine.NEXT() = 0;
        end;
    end;

    procedure FctAddKitLinesAndHeader(var RecPSalesLine: Record "Sales Line")
    var
        RecLPurchLine2: Record "Purchase Line";
        RecLPurchLine: Record "Purchase Line";
        RecLReservEntry: Record "Reservation Entry";
        CodLxItemNo: Code[20];
        CodLxLocationCode: Code[20];
        CodLxVendorNo: Code[20];
        DecLQtyToReserve: Decimal;
        DecLQtyToReserveBase: Decimal;
        IntLLineNo: Integer;
    begin
        RecGKitSalesLine.SetCurrentKey("Vendor No.", "No.", "Location Code");
        RecGKitSalesLine.SetRange(Type, RecGKitSalesLine.Type::Item);
        RecGKitSalesLine.SetRange("Selected for Order", true);
        if RecPSalesLine.GETFILTER("Vendor No.") <> '' then
            RecGKitSalesLine.SetFilter("Vendor No.", RecPSalesLine.GETFILTER("Vendor No."))
        else
            RecGKitSalesLine.SetFilter("Vendor No.", '<>%1', '');
        RecGKitSalesLine.SetRange("Internal field", true);
        CodLxVendorNo := '';
        CodLxItemNo := '';
        CodLxLocationCode := '';
        if not RecGKitSalesLine.IsEmpty then begin
            RecGKitSalesLine.FindSet();
            repeat
                if (RecGKitSalesLine."Vendor No." <> CodLxVendorNo) then begin
                    FctCreatePurchaseOrderHeader(RecGKitSalesLine."Vendor No.");
                    IntGCountOrder += 1;
                end;
                if (RecGKitSalesLine."Vendor No." <> CodLxVendorNo) or
                   (RecGKitSalesLine."No." <> CodLxItemNo) or
                   (RecGKitSalesLine."Location Code" <> CodLxLocationCode) then begin
                    RecLPurchLine.Init();
                    RecLPurchLine."Document Type" := RecGPurchHeader."Document Type";
                    RecLPurchLine."Document No." := RecGPurchHeader."No.";
                    RecLPurchLine2.SetRange("Document Type", RecLPurchLine."Document Type"::Order);
                    RecLPurchLine2.SetRange("Document No.", RecGPurchHeader."No.");
                    if RecLPurchLine2.FindLast() then
                        IntLLineNo := RecLPurchLine2."Line No." + 10000
                    else
                        IntLLineNo := 10000;
                    RecLPurchLine."Line No." := IntLLineNo;
                    RecLPurchLine.Validate(Type, RecLPurchLine.Type::Item);
                    RecLPurchLine.Validate("No.", RecGKitSalesLine."No.");
                    RecLPurchLine.Validate("Location Code", RecGKitSalesLine."Location Code");
                    if (RecGKitSalesLine."Requested Receipt Date" <> 0D) then begin
                        RecLPurchLine.Validate("Date from Req. Delivery Date", true);
                        if (RecLPurchLine."Requested Receipt Date" = 0D) or
                          (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Receipt Date") then
                            RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Receipt Date");
                    end else
                        if (RecLPurchLine."Date from Req. Delivery Date" = false) then
                            if (RecLPurchLine."Requested Receipt Date" = 0D) or
                              (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Delivery Date") then
                                RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Delivery Date");

                    RecLPurchLine.Insert();
                end;
                RecLPurchLine.Validate(Quantity, RecLPurchLine.Quantity + RecGKitSalesLine."Qty to be Ordered");
                if (RecGKitSalesLine."Requested Receipt Date" <> 0D) then begin
                    RecLPurchLine.Validate("Date from Req. Delivery Date", true);
                    if (RecLPurchLine."Requested Receipt Date" = 0D) or
                      (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Receipt Date") then
                        RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Receipt Date");
                end else
                    if (RecLPurchLine."Date from Req. Delivery Date" = false) then
                        if (RecLPurchLine."Requested Receipt Date" = 0D) or
                          (RecLPurchLine."Requested Receipt Date" > RecGKitSalesLine."Requested Delivery Date") then
                            RecLPurchLine.Validate("Requested Receipt Date", RecGKitSalesLine."Requested Delivery Date");
                RecLPurchLine.MODIFY();
                RecGKitSalesLine.CALCFIELDS("Reserved Quantity");

                if ((RecGKitSalesLine."Remaining Quantity" - RecGKitSalesLine."Reserved Quantity") <=
                         RecGKitSalesLine."Qty to be Ordered") then
                    DecLQtyToReserve := RecGKitSalesLine."Remaining Quantity" - RecGKitSalesLine."Reserved Quantity"
                else
                    DecLQtyToReserve := RecGKitSalesLine."Qty to be Ordered";

                DecLQtyToReserveBase := DecLQtyToReserve * RecGKitSalesLine."Qty. per Unit of Measure";

                RecGKitSalesLine."Selected for Order" := false;
                RecGKitSalesLine.MODIFY();
                Clear(Reservation);
                Reservation.SetReservSource(RecGKitSalesLine);
                // Reservation.SetAssemblyLine(RecGKitSalesLine);
                Reservation.GetReservEntry(RecLReservEntry);
                ReservMgt.SetReservSource(RecGKitSalesLine);
                // ReservMgt.SetAssemblyLine(RecGKitSalesLine);
                if RecLPurchLine."Requested Receipt Date" <> 0D then
                    ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Requested Receipt Date")
                else
                    if RecLPurchLine."Expected Receipt Date" <> 0D then
                        ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLPurchLine."Expected Receipt Date")
                    else
                        ReservMgt.AutoReserveOneLine(12, DecLQtyToReserve, DecLQtyToReserveBase, RecLReservEntry.Description, RecLReservEntry."Shipment Date");
                RecAssemlyOrder.Get(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.");
                FctMAJPreparationType(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.", RecAssemlyOrder."Document Line No.");
                CodLxItemNo := RecGKitSalesLine."No.";
                CodLxLocationCode := RecGKitSalesLine."Location Code";
                CodLxVendorNo := RecGKitSalesLine."Vendor No.";
            until RecGKitSalesLine.NEXT() = 0;
        end;
    end;

    procedure FctMAJPreparationType(OptPDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; CodPDocNo: Code[20]; IntPLineNo: Integer)
    var
        RecLKitSalesLine: Record "Assembly Line";
        RecLSalesLine: Record "Sales Line";
        BooLOK: Boolean;
    begin
        if not RecLSalesLine.Get(OptPDocType, CodPDocNo, IntPLineNo) then
            exit;

        if (RecLSalesLine."Preparation Type" = RecLSalesLine."Preparation Type"::Purchase) then
            exit;
        if (RecLSalesLine."Preparation Type" = RecLSalesLine."Preparation Type"::Assembly) then
            exit;

        RecLKitSalesLine.SetRange("Document Type", OptPDocType);
        RecLKitSalesLine.SetRange("Document No.", CodPDocNo);
        RecLKitSalesLine.SetRange("Line No.", IntPLineNo);
        RecLKitSalesLine.SetRange(Type, RecLKitSalesLine.Type::Item);
        BooLOK := true;
        if not RecLKitSalesLine.IsEmpty then begin
            RecLKitSalesLine.FindSet();
            repeat
                RecLKitSalesLine.CALCFIELDS("Reserved Quantity");
                if (RecLKitSalesLine."Reserved Quantity" < RecLKitSalesLine."Remaining Quantity") then
                    BooLOK := false;
            until (RecLKitSalesLine.NEXT() = 0) or (BooLOK = false);
        end;
        if BooLOK = true then begin
            RecLSalesLine."Preparation Type" := RecLSalesLine."Preparation Type"::Purchase;
            RecLSalesLine.MODIFY();
        end;
    end;

    procedure FctctrlKitReservation(RecPSalesLine: Record "Sales Line") BooLOK: Boolean
    var
        RecL337: Record "Reservation Entry";
        RecL337b: Record "Reservation Entry";
        RecLATOLink: Record "Assemble-to-Order Link";
        RecLKitSalesLine: Record "Assembly Line";
    begin
        BooLOK := false;
        RecPSalesLine.CALCFIELDS("Reserved Quantity");
        if (RecPSalesLine."Reserved Quantity" <> 0)
          and (RecPSalesLine."Qty. to Assemble to Order" = 0)
          then begin
            if (RecPSalesLine."Reserved Quantity" = RecPSalesLine."Outstanding Quantity") then begin
                BooLOK := true;
                RecL337.SetRange("Source Type", DATABASE::"Sales Line");
                RecL337.SetRange("Source Subtype", RecPSalesLine."Document Type");
                RecL337.SetRange("Source ID", RecPSalesLine."Document No.");
                RecL337.SetRange("Source Ref. No.", RecPSalesLine."Line No.");
                RecL337.SetRange("Reservation Status", RecL337."Reservation Status"::Reservation);
                if RecL337.FindSet() then
                    repeat
                        RecL337b.SetRange("Entry No.", RecL337."Entry No.");
                        RecL337b.SetFilter("Source Type", '<>37');
                        if RecL337b.FindSet() then
                            if RecL337b."Source Type" <> DATABASE::"Item Ledger Entry" then
                                BooLOK := false;
                    until (RecL337.NEXT() = 0) or (BooLOK = false);
            end;
        end else begin
            if FctGetATOLinkToSalesLine(RecPSalesLine) then
                RecLKitSalesLine.SetRange("Document Type", RecGATOLinkToSalesLine."Assembly Document Type");
            RecLKitSalesLine.SetRange("Document No.", RecGATOLinkToSalesLine."Assembly Document No.");
            RecLKitSalesLine.SetRange(Type, RecLKitSalesLine.Type::Item);
            RecLKitSalesLine.SetFilter("Remaining Quantity", '<>0');
            RecLKitSalesLine.SetFilter(Quantity, '<>0');

            if not RecLKitSalesLine.IsEmpty then begin
                BooLOK := true;
                RecLKitSalesLine.FindSet();
                repeat
                    RecLKitSalesLine.CALCFIELDS("Reserved Quantity");
                    if (RecLKitSalesLine."Reserved Quantity" < RecLKitSalesLine."Remaining Quantity (Base)") then
                        BooLOK := false
                    else
                        if (RecLKitSalesLine."Reserved Quantity" <> 0) then begin
                            RecL337.SetRange("Source Type", DATABASE::"Assembly Line");
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
                                until (RecL337.NEXT() = 0) or (BooLOK = false);
                        end;
                until (RecLKitSalesLine.NEXT() = 0) or not BooLOK;
            end;
        end;
    end;

    procedure FctParmFromCompileBL()
    begin
        BooGParmFromCompileBL := true;
    end;

    local procedure FctIsBuildKit(RecPSalesLine: Record "Sales Line"): Boolean
    var
        RecLAssembletoOrderLink: Record "Assemble-to-Order Link";
        RecLSalesLine: Record "Sales Line";
    begin
        RecLAssembletoOrderLink.Reset();
        RecLAssembletoOrderLink.SetRange("Document Type", RecPSalesLine."Document Type");
        RecLAssembletoOrderLink.SetRange("Document No.", RecPSalesLine."Document No.");
        RecLAssembletoOrderLink.SetRange("Document Line No.", RecPSalesLine."Line No.");
        exit(not (RecLAssembletoOrderLink.IsEmpty()));
    end;

    local procedure FctGetATOLinkToSalesLine(RecPSalesLine: Record "Sales Line"): Boolean
    begin
        RecGATOLinkToSalesLine.Reset();
        RecGATOLinkToSalesLine.SetCurrentKey(Type, "Document Type", "Document No.", "Document Line No.");
        RecGATOLinkToSalesLine.SetRange(Type, RecGATOLinkToSalesLine.Type::Sale);
        RecGATOLinkToSalesLine.SetRange("Document Type", RecPSalesLine."Document Type");
        RecGATOLinkToSalesLine.SetRange("Document No.", RecPSalesLine."Document No.");
        RecGATOLinkToSalesLine.SetRange("Document Line No.", RecPSalesLine."Line No.");
        exit(RecGATOLinkToSalesLine.FindFirst());
    end;

    local procedure FctKitAutoReserveFTA(RecPSalesLine: Record "Sales Line")
    var
        RecLAssemblyLine: Record "Assembly Line";
    begin
        if FctGetATOLinkToSalesLine(RecPSalesLine) then begin
            RecLAssemblyLine.Reset();
            RecLAssemblyLine.SetRange("Document Type", RecGATOLinkToSalesLine."Assembly Document Type");
            RecLAssemblyLine.SetRange("Document No.", RecGATOLinkToSalesLine."Assembly Document No.");
            if not RecLAssemblyLine.IsEmpty then begin
                RecLAssemblyLine.FindSet();
                repeat
                    if BooGResaAssFTA then
                        RecLAssemblyLine.FctSetBooResaAssFTA(true);
                    RecLAssemblyLine.FctAutoReserveFTA();
                until RecLAssemblyLine.NEXT() = 0;
            end;
        end;
    end;

    procedure FctSelectRecForOrder2(var recsalesL: Record "Sales Line")
    begin
        with recsalesL do begin
            SetCurrentKey("Document Type", Type, "Outstanding Quantity", "Internal field", "Vendor No.", "No.", "Location Code");
            SetRange("Document Type", "Document Type"::Order);
            SetRange(Type, Type::Item);
            SetFilter("Outstanding Quantity", '<>0');
            if FindFirst() then
                repeat
                    CALCFIELDS("Reserved Qty. (Base)");
                    if ("Outstanding Qty. (Base)" > "Reserved Qty. (Base)") and ("Qty. to Assemble to Order" = 0) then begin
                        "Internal field" := true;
                        if ("Qty to be Ordered" = 0) and ("Selected for Order" = true) then
                            Validate("Selected for Order", true);
                    end else
                        "Internal field" := false;
                    MODIFY();
                until NEXT() = 0;
            SetRange("Internal field", true);
        end;
    end;

    procedure FctSelectRecForOrder3(var RecPSalesLine: Record "Sales Line")
    begin
        RecPSalesLine.CLEARMARKS();

        RecPSalesLine.Reset();
        RecPSalesLine.SetCurrentKey("Document Type", Type, "Outstanding Quantity", "Internal field", "Vendor No.", "No.", "Location Code");
        RecPSalesLine.SetRange("Document Type", "Document Type"::Order);
        RecPSalesLine.SetRange(Type, RecPSalesLine.Type::Item);
        RecPSalesLine.SetFilter("Outstanding Quantity", '<>0');
        if RecPSalesLine.FindFirst() then
            repeat
                RecPSalesLine.CALCFIELDS("Reserved Qty. (Base)");
                if (RecPSalesLine."Outstanding Qty. (Base)" > RecPSalesLine."Reserved Qty. (Base)") and (RecPSalesLine."Qty. to Assemble to Order" = 0) then begin
                    RecPSalesLine.MARK(true);
                    if (RecPSalesLine."Qty to be Ordered" = 0) and
                       (RecPSalesLine."Selected for Order" = true) then
                        RecPSalesLine.Validate("Selected for Order", true);
                end else
                    RecPSalesLine.MARK(false);
                RecPSalesLine.MODIFY();
            until RecPSalesLine.NEXT() = 0;
        RecPSalesLine.MARKEDONLY(true);
    end;

    procedure FctSetBooResaFTA(BooPResaFTA: Boolean)
    begin
        BooGResaFTA := BooPResaFTA;
    end;

    procedure FctSetBooResaAssFTA(BooPResaAssFTA: Boolean)
    begin
        BooGResaAssFTA := BooPResaAssFTA;
    end;

    local procedure ShowBomComponentAlert(ItemNo: Code[20])
    var
        BOMComponent: Record "BOM Component";
        TxtCst001: Label 'Presence of labor or paint in the bill of materials.';
    begin
        BOMComponent.SetRange("Parent Item No.", ItemNo);
        BOMComponent.SetFilter("No.", '%1|%2', '9912', 'MO');
        if not BOMComponent.IsEmpty then
            Message(TxtCst001);
    end;

    local procedure UpdateAssembleOrderLink(pDate: Date)
    var
        AssembletoOrderLink: Record "Assemble-to-Order Link";
        AssemblyHeader: Record "Assembly Header";
    begin
        AssembletoOrderLink.SetRange("Document Type", AssembletoOrderLink."Document Type"::Order);
        AssembletoOrderLink.SetRange("Document No.", Rec."Document No.");
        AssembletoOrderLink.SetRange("Document Line No.", Rec."Line No.");
        if AssembletoOrderLink.FindSet() then
            if AssemblyHeader.Get(AssembletoOrderLink."Assembly Document Type", AssembletoOrderLink."Assembly Document No.") then begin
                AssemblyHeader."Starting Date" := pDate;
                AssemblyHeader."Ending Date" := pDate;
                AssemblyHeader."Due Date" := pDate;
                AssemblyHeader.MODIFY(false);
            end;
    end;

    procedure UpdatePurchaseBasePrice()
    begin
        if Item.Get("No.") then begin
            if ("Item Base" = "Item Base"::"Bored blocks") and (Quantity <> 0) then
                if Quantity < 2 then
                    "Purchase Price Base" := Item."Purchase Price Base" + Item."Purchase Price Base 1";
            if (Quantity >= 2) and (Quantity < 5) then
                "Purchase Price Base" := Item."Purchase Price Base" + Item."Purchase Price Base 2";
            if (Quantity >= 5) and (Quantity < 10) then
                "Purchase Price Base" := Item."Purchase Price Base" + Item."Purchase Price Base 5";
            if (Quantity >= 10) and (Quantity < 25) then
                "Purchase Price Base" := Item."Purchase Price Base" + Item."Purchase Price Base 10";
            if (Quantity >= 25) and (Quantity < 50) then
                "Purchase Price Base" := Item."Purchase Price Base" + Item."Purchase Price Base 25";
            if Quantity >= 50 then
                "Purchase Price Base" := Item."Purchase Price Base" + Item."Purchase Price Base 50";
        end;
    end;

    var
        ATOLink: Record "Assemble-to-Order Link";
        Currency: Record Currency;
        Item: Record Item;
        RecAssemlyOrder: Record "Assemble-to-Order Link";
        RecGATOLinkToSalesLine: Record "Assemble-to-Order Link";
        RecGKitSalesLine: Record "Assembly Line";
        RecGPurchHeader: Record "Purchase Header";
        ReservEntry: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        "FTA_Functions": Codeunit "FTA_Functions";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservMgt: Codeunit "Reservation Management";
        Reservation: Page Reservation;
        BooGParmFromCompileBL: Boolean;
        BooGResaAssFTA: Boolean;
        BooGResaFTA: Boolean;
        IntGCountOrder: Integer;
}

