namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.BOM;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item.Substitution;
using Microsoft.Inventory.Item;
pageextension 50070 "AssembletoOrderLines" extends "Assemble-to-Order Lines" //914
{
    layout
    {
        addfirst(Group)
        {
            field("Line No."; rec."Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Level No."; rec."Level No.")
            {
                ApplicationArea = All;
                StyleExpr = TxTGStyle;
            }
            field(Kit; rec.Kit)
            {
                ApplicationArea = All;
            }
            field("Kit Action"; rec."Kit Action")
            {
                ApplicationArea = All;
                StyleExpr = TxTGStyle;
                trigger OnValidate()
                var
                    RecLATOLink: Record 904;
                    BoolEndLoop: Boolean;
                    IntLDocumentLineNo: Integer;
                    IntLLineNo: Integer;
                begin
                    CurrPage.SaveRecord();
                    IntLDocumentLineNo := rec."Line No.";
                    IntLLineNo := rec."Line No.";
                    case rec."Kit Action" of
                        rec."Kit Action"::Assembly:

                            if RecLATOLink.Get(rec."Document Type", rec."Document No.") then begin
                                KitLine.Get(RecLATOLink."Document Type", RecLATOLink."Document No.", RecLATOLink."Document Line No.");
                                FTA_Functions.FctRefreshTempSubKitSalesFTA(Rec, false);
                            end;


                        rec."Kit Action"::Disassembly:

                            if RecLATOLink.Get(rec."Document Type", rec."Document No.") then begin
                                KitLine.Get(RecLATOLink."Document Type", RecLATOLink."Document No.", RecLATOLink."Document Line No.");
                                FTA_Functions.FctRefreshTempSubKitSalesFTA(Rec, false);
                            end;

                    end;
                    BoolEndLoop := false;
                    if rec.FindSet() then
                        repeat
                            if IntLLineNo = rec."Line No." then
                                BoolEndLoop := true;
                        until (rec.Next() = 0) or (BoolEndLoop = true);
                    rec.Next(-1);
                    CurrPage.Update();
                end;
            }
        }
        addafter(Type)
        {
            field("Substitution Available"; rec."Substitution Available")
            {
                ToolTip = 'Specifies if a substitute is available for the item on the assembly order line.';
                ApplicationArea = All;
            }
            field("Originally Ordered No."; rec."Originally Ordered No.")
            {
                Editable = false;
            }
            field("Originally Ordered Var. Code"; rec."Originally Ordered Var. Code")
            {
                Visible = false;
            }
        }
        addafter("Location Code")
        {
            field(Inventory; GetItemInventory())
            {
                Caption = 'Inventory';
                DecimalPlaces = 0 : 5;
                Editable = false;
                ToolTip = 'Specifies the value of the Inventory field.';
                ApplicationArea = All;
            }
            field(Avaibility; rec."Avaibility no reserved")
            {
                Caption = 'Avaibility';
                StyleExpr = TxTGStyle;
            }
            field("Disponibilité sur achat"; GetAvailbilityPurchase())
            {
                Caption = 'Disponibilité sur achat';
                DecimalPlaces = 0 : 2;
                ToolTip = 'Specifies the value of the Disponibilité sur achat field.';
                ApplicationArea = All;
                trigger OnLookup(var myText: Text): Boolean
                begin
                    LookUpAvailPurchase();
                end;
            }
            field("Disponibilité date récéption confirmée"; GetAvailbilityPurchaseDate())
            {
                Caption = 'Disponibilité date récéption confirmée';
                Editable = false;
                ToolTip = 'Specifies the value of the Disponibilité date récéption confirmée field.';
                ApplicationArea = All;
            }
            field("Disponibilité quantité non affectées"; GetAvailbilityPurchaseQty())
            {
                Caption = 'Disponibilité quantité non affectées';
                DecimalPlaces = 0 : 2;
                Editable = false;
                ToolTip = 'Specifies the value of the Disponibilité quantité non affectées field.';
                ApplicationArea = All;
                trigger OnLookup(var myText: Text): Boolean
                begin
                    LookUpAvailPurchase();
                end;
            }
        }
        addafter(Quantity)
        {
            field("Remaining Quantity"; rec."Remaining Quantity")
            {
                StyleExpr = TxTGStyle;
                ToolTip = 'Specifies the value of the Remaining Quantity field.';
                ApplicationArea = All;
            }
        }
        addafter("Cost Amount")
        {
            field("Kit Qty Available by Assembly"; rec."Kit Qty Available by Assembly")
            {
                StyleExpr = TxTGStyle;
            }
            field("x Quantity per"; rec."x Quantity per")
            {
            }
        }
        Modify(Type)
        {
            StyleExpr = TxTGStyle;
        }
        Modify("No.")
        {
            StyleExpr = TxTGStyle;
        }
        Modify(Description)
        {
            StyleExpr = TxTGStyle;
        }
        Modify("Description 2")
        {
            StyleExpr = TxTGStyle;
        }
        Modify("Variant Code")
        {
            StyleExpr = TxTGStyle;
        }
        Modify("Quantity per")
        {
            StyleExpr = TxTGStyle;
        }
        Modify("Unit of Measure Code")
        {
            StyleExpr = TxTGStyle;
        }
        Modify(Quantity)
        {
            Caption = 'Total Qty';
            StyleExpr = TxTGStyle;
        }
        Modify("Reserved Quantity")
        {
            StyleExpr = TxTGStyle;
        }
    }
    actions
    {
        Modify("&Reserve")
        {
            trigger OnBeforeAction()
            begin
                rec.FctSetBooResaAssFTA(true);
            end;
        }
        addafter("&Reserve")
        {
            action("Modifier réservation achat sur stock")
            {
                Promoted = true;
                Image = LineReserve;
                PromotedCategory = Process;
                ToolTip = 'Executes the Modifier réservation achat sur stock action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AssemblyLine: Record "Assembly Line";
                    EntrySummary: Record "Entry Summary" temporary;
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    RecL337: Record "Reservation Entry";
                    RecL337b: Record "Reservation Entry";
                    ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
                    ReservMgt: Codeunit "Reservation Management";
                    Reservation: Page Reservation;
                    FullAutoReservation: Boolean;
                    QtyToReserve: Decimal;
                begin
                    AssemblyLine.CopyFilters(Rec);
                    if AssemblyLine.findFirst() then
                        repeat
                            RecL337.SetRange("Source Type", DATABASE::"Assembly Line");
                            RecL337.SetRange("Source Subtype", AssemblyLine."Document Type");
                            RecL337.SetRange("Source ID", AssemblyLine."Document No.");
                            RecL337.SetRange("Source Ref. No.", AssemblyLine."Line No.");
                            RecL337.SetRange("Reservation Status", RecL337."Reservation Status"::Reservation);
                            if RecL337.FindSet() then
                                repeat
                                    QtyToReserve := 0;

                                    RecL337b.SetRange("Entry No.", RecL337."Entry No.");
                                    RecL337b.SetFilter("Source Type", '<>901');
                                    if RecL337b.FindSet() then
                                        if RecL337b."Source Type" = DATABASE::"Purchase Line" then begin
                                            ItemLedgerEntry.SetRange("Item No.", AssemblyLine."No.");
                                            ItemLedgerEntry.SetRange("Variant Code", AssemblyLine."Variant Code");
                                            ItemLedgerEntry.SetRange("Location Code", AssemblyLine."Location Code");
                                            ItemLedgerEntry.SetRange("Drop Shipment", false);
                                            ItemLedgerEntry.SetRange(Open, true);
                                            ItemLedgerEntry.SetRange(Positive, true);
                                            ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
                                            if ItemLedgerEntry.FindSet() then
                                                repeat
                                                    ItemLedgerEntry.CalcFields("Reserved Quantity");
                                                    QtyToReserve += ItemLedgerEntry."Remaining Quantity" - ItemLedgerEntry."Reserved Quantity";
                                                until ItemLedgerEntry.Next() = 0;

                                            if QtyToReserve >= AssemblyLine.Quantity then begin

                                                Clear(ReservEngineMgt);
                                                ReservEngineMgt.CancelReservation(RecL337b);

                                                Clear(ReservMgt);
                                                ReservMgt.SetReservSource(AssemblyLine);
                                                ReservMgt.AutoReserve(FullAutoReservation, '', AssemblyLine."Due Date", AssemblyLine."Remaining Quantity", AssemblyLine."Remaining Quantity (Base)");
                                            end;
                                        end;
                                until (RecL337.Next() = 0);
                        until AssemblyLine.Next() = 0;
                end;
            }
        }
        addafter("Select Item Substitution")
        {
            action("Get All Item Substitution List")
            {
                Image = SelectItemSubstitution;
                ToolTip = 'Executes the Get All Item Substitution List action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AssemblyLineRec: Record "Assembly Line";
                    ItemSubstMgt: Codeunit FTA_Functions;
                begin
                    Clear(AssemblyLineRec);
                    CurrPage.SetSelectionFilter(AssemblyLineRec);
                    if AssemblyLineRec.findFirst() then
                        repeat
                            ItemSubstMgt.ExplodeItemAssemblySubst(AssemblyLineRec, false, false);
                        until AssemblyLineRec.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Get All Available Item Substitution List")
            {
                Image = SelectItemSubstitution;
                ToolTip = 'Executes the Get All Available Item Substitution List action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AssemblyLineRec: Record "Assembly Line";
                    ItemSubstMgt: Codeunit FTA_Functions;
                begin
                    Clear(AssemblyLineRec);
                    CurrPage.SetSelectionFilter(AssemblyLineRec);
                    if AssemblyLineRec.findFirst() then
                        repeat
                            ItemSubstMgt.ExplodeItemAssemblySubst(AssemblyLineRec, true, false);
                        until AssemblyLineRec.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Remplace And Reserve All Available Item Substitution List")
            {
                Image = SelectItemSubstitution;
                ToolTip = 'Executes the Remplace And Reserve All Available Item Substitution List action.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    AssemblyLineRec: Record "Assembly Line";
                    ItemSubstMgt: Codeunit FTA_Functions;
                begin
                    Clear(AssemblyLineRec);
                    CurrPage.SetSelectionFilter(AssemblyLineRec);
                    if AssemblyLineRec.findFirst() then
                        repeat
                            ItemSubstMgt.ExplodeItemAssemblySubst(AssemblyLineRec, true, true);
                        until AssemblyLineRec.Next() = 0;
                    CurrPage.Update();
                end;
            }
        }
        addafter("Explode BOM")
        {
            action("Explode and Reserve BOM")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = ExplodeBOM;
                trigger OnAction()
                begin
                    Rec.Validate(rec."Kit Action", rec."Kit Action"::Disassembly);
                    Rec.Modify();
                    FTA_Functions.FctRefreshTempSubKitSalesFTA(Rec, true);
                    CurrPage.Update();
                end;
            }
        }
        addafter("Item &Tracking Lines")
        {
            action("Where-Used")
            {
                RunObject = Page "Where-Used List";
                RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                Image = "Where-Used";
                ToolTip = 'Executes the Where-Used action.';
                ApplicationArea = All;
            }
        }
    }
    var
        KitLine: Record "Sales Line";
        RecGKitSalesLine: Record "Assembly Line";
        FTA_Functions: Codeunit FTA_Functions;
        BooGAvailWithoutCurrentLine: Boolean;
        DateFilter: Date;
        DecGQtyKit: Decimal;
        IntGColor: Integer;
        TxTGStyle: Text;

    procedure FctSearchColor();
    var
        RecL337: Record "Reservation Entry";
        RecL337b: Record "Reservation Entry";
    begin
        rec.CalcFields(rec."Reserved Quantity");
        IntGColor := 0;
        if (rec."Reserved Quantity" < rec."Remaining Quantity") then
            IntGColor := 0
        else begin
            RecL337.SetRange("Source Type", DATABASE::"Assembly Line");
            RecL337.SetRange("Source Subtype", rec."Document Type");
            RecL337.SetRange("Source ID", rec."Document No.");
            RecL337.SetRange("Source Ref. No.", rec."Line No.");
            RecL337.SetRange("Reservation Status", RecL337."Reservation Status"::Reservation);
            if RecL337.FindSet() then
                repeat
                    RecL337b.SetRange("Entry No.", RecL337."Entry No.");
                    RecL337b.SetFilter("Source Type", '<>901');
                    if RecL337b.FindSet() then
                        case IntGColor of
                            0:
                                begin
                                    if RecL337b."Source Type" = DATABASE::"Item Ledger Entry" then
                                        IntGColor := 1;
                                    if RecL337b."Source Type" = DATABASE::"Purchase Line" then
                                        IntGColor := 2;
                                end;
                            1:
                                if RecL337b."Source Type" = DATABASE::"Purchase Line" then
                                    IntGColor := 2;
                        end;
                until (RecL337.Next() = 0) or (IntGColor = 2);
        end;

        TxTGStyle := '';
        if (rec."Level No." <> 0) then
            TxTGStyle := 'Strong';
        if IntGColor = 1 then
            TxTGStyle := 'Favorable';
        if IntGColor = 2 then
            TxTGStyle := 'Attention';
    end;

    procedure FctSetParm(BooPAvailWithoutCurrentLine: Boolean);
    begin
        BooGAvailWithoutCurrentLine := BooPAvailWithoutCurrentLine;
    end;

    procedure FctSetDate(pDateFilter: Date);
    begin
        DateFilter := pDateFilter;
    end;

    local procedure GetAvailbilityPurchase(): Decimal;
    var
        PurchaseLine: Record "Purchase Line";
        AvailibilityQty: Decimal;

    begin
        AvailibilityQty := 0;

        PurchaseLine.Reset();
        PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", rec."No.");
        PurchaseLine.SetFilter("Expected Receipt Date", '<=%1', DateFilter);
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.CalcFields("Reserved Quantity");
                AvailibilityQty += PurchaseLine."Outstanding Quantity" - PurchaseLine."Reserved Quantity";
            until PurchaseLine.Next() = 0;


        exit(AvailibilityQty);
    end;

    local procedure LookUpAvailPurchase();
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLines: Page "Purchase Lines";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", rec."No.");
        PurchaseLine.SetFilter("Expected Receipt Date", '<=%1', DateFilter);
        PurchaseLines.SetTableView(PurchaseLine);
        PurchaseLines.RunModal();
    end;

    local procedure GetAvailbilityPurchaseQty(): Decimal;
    var
        PurchaseLine: Record "Purchase Line";
        AvailibilityQty: Decimal;
    begin
        AvailibilityQty := 0;

        PurchaseLine.Reset();
        PurchaseLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date", "Promised Receipt Date");
        PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", rec."No.");
        PurchaseLine.SetFilter("Promised Receipt Date", '<>%1', 0D);
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.CalcFields("Reserved Quantity");
                AvailibilityQty := PurchaseLine."Outstanding Quantity" - PurchaseLine."Reserved Quantity";
                if AvailibilityQty >= Rec.Quantity then
                    exit(AvailibilityQty);
            until PurchaseLine.Next() = 0;

        exit(AvailibilityQty);
    end;

    local procedure GetAvailbilityPurchaseDate(): Date;
    var
        PurchaseLine: Record "Purchase Line";
        AvailibilityQty: Decimal;
    begin
        AvailibilityQty := 0;

        PurchaseLine.Reset();
        PurchaseLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date", "Promised Receipt Date");
        PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", rec."No.");
        PurchaseLine.SetFilter("Promised Receipt Date", '<>%1', 0D);
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.CalcFields("Reserved Quantity");
                AvailibilityQty := PurchaseLine."Outstanding Quantity" - PurchaseLine."Reserved Quantity";
                if AvailibilityQty >= Rec.Quantity then
                    exit(PurchaseLine."Promised Receipt Date");
            until PurchaseLine.Next() = 0;

        exit(0D);
    end;

    local procedure GetItemInventory(): Decimal;
    var
        Item: Record Item;
    begin
        if Item.Get(rec."No.") then begin
            Item.CalcFields(Inventory);
            exit(Item.Inventory);
        end;

        exit(0);
    end;

    trigger OnAfterGetRecord()
    var
        RecLItem: Record Item;
    begin
        if rec.Type = rec.Type::Item then
            if RecLItem.Get(rec."No.") then begin
                if rec."Location Code" <> '' then
                    RecLItem.SetFilter("Location Filter", rec."Location Code");
                RecLItem.CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
                if not BooGAvailWithoutCurrentLine then
                    rec."Avaibility no reserved" := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + RecLItem."Qty. on Asm. Component")
                               + RecLItem."Reserved Qty. on Purch. Orders"
                else begin
                    DecGQtyKit := 0;
                    RecGKitSalesLine.SetRange("Document Type", RecGKitSalesLine."Document Type"::Order);
                    RecGKitSalesLine.SetRange(Type, RecGKitSalesLine.Type::Item);
                    RecGKitSalesLine.SetRange("No.", rec."No.");
                    RecGKitSalesLine.SetFilter("Remaining Quantity (Base)", '<>0');
                    if not RecGKitSalesLine.IsEmpty then begin
                        RecGKitSalesLine.FindSet();
                        repeat
                            if (RecGKitSalesLine."Document No." <> rec."Document No.") or (RecGKitSalesLine."Line No." <> rec."Line No.") then
                                DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
                        until RecGKitSalesLine.Next() = 0;
                    end;
                    rec."Avaibility no reserved" := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + DecGQtyKit) + RecLItem."Reserved Qty. on Purch. Orders";
                end;

            end;
        FctSearchColor();
    end;


}
