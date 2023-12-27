namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Ledger;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.BOM;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item.Substitution;
pageextension 50044 "AssembletoOrderLines" extends "Assemble-to-Order Lines" //914
{
    layout
    {
        //TODO : table assembly line not migrated yet
        // addfirst(Group)
        // {
        //     field("Line No."; rec."Line No.")
        //     {
        //         ApplicationArea = All;
        //         Editable = false;
        //     }
        //     field("Level No."; rec."Level No.")
        //     {
        //         ApplicationArea = All;
        //         StyleExpr = TxTGStyle;
        //     }
        //     field(Kit; rec.Kit)
        //     {
        //         ApplicationArea = All;
        //     }
        //     field("Kit Action"; rec."Kit Action")
        //     {
        //         ApplicationArea = All;
        //         StyleExpr = TxTGStyle;
        //         trigger OnValidate()
        //         var
        //             IntLDocumentLineNo: Integer;
        //             IntLLineNo: Integer;
        //             BoolEndLoop: Boolean;
        //             RecLATOLink: Record 904;
        //         begin
        //             CurrPage.SAVERECORD();
        //             IntLDocumentLineNo := "Line No.";
        //             IntLLineNo := "Line No.";
        //             case "Kit Action" of
        //                 "Kit Action"::Assembly:
        //                     begin
        //                         if RecLATOLink.GET("Document Type", "Document No.") then begin
        //                             KitLine.GET(RecLATOLink."Document Type", RecLATOLink."Document No.", RecLATOLink."Document Line No.");
        //                             AsmLinMgt.FctRefreshTempSubKitSalesFTA(Rec);
        //                         end;
        //                     end;

        //                 "Kit Action"::Disassembly:
        //                     begin
        //                         if RecLATOLink.GET("Document Type", "Document No.") then begin
        //                             KitLine.GET(RecLATOLink."Document Type", RecLATOLink."Document No.", RecLATOLink."Document Line No.");
        //                             AsmLinMgt.FctRefreshTempSubKitSalesFTA(Rec);
        //                         end;
        //                     end;
        //             end;
        //             BoolEndLoop := false;
        //             if FINDSET then
        //                 repeat
        //                     if IntLLineNo = "Line No." then
        //                         BoolEndLoop := true;
        //                 until (NEXT = 0) or (BoolEndLoop = true);
        //             NEXT(-1);
        //             CurrPage.UPDATE();
        //         end;
        //     }
        // }
        addafter(Type)
        {
            field("Substitution Available"; rec."Substitution Available")
            {

            }
            //TODO : TABLE ASSEMBLY LINE 
            // field("Originally Ordered No."; rec."Originally Ordered No.")
            // {
            //     Editable = false;
            // }
            // field("Originally Ordered Var. Code"; rec."Originally Ordered Var. Code")
            // {
            //     Visible = false;
            // }
        }
        addafter("Location Code")
        {
            field(Inventory; GetItemInventory())
            {
                Caption = 'Inventory';
                DecimalPlaces = 0 : 5;
                Editable = false;
            }
            // field(Avaibility; rec."Avaibility no reserved")
            // {
            //     Caption = 'Avaibility';
            //     StyleExpr = TxTGStyle;
            // }
            field("Disponibilité sur achat"; GetAvailbilityPurchase())
            {
                Caption = 'Disponibilité sur achat';
                DecimalPlaces = 0 : 2;
                // TODO->A verifier
                trigger OnLookup(var myText: Text): Boolean
                begin
                    LookUpAvailPurchase();
                end;
            }
            field("Disponibilité date récéption confirmée"; GetAvailbilityPurchaseDate())
            {
                Caption = 'Disponibilité date récéption confirmée';
                Editable = false;
            }
            field("Disponibilité quantité non affectées"; GetAvailbilityPurchaseQty())
            {
                Caption = 'Disponibilité quantité non affectées';
                DecimalPlaces = 0 : 2;
                Editable = false;
                // TODO->A verifier
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
            }
        }
        // addafter("Cost Amount")
        // {
        //     field("Kit Qty Available by Assembly"; rec."Kit Qty Available by Assembly")
        //     {
        //         StyleExpr = TxTGStyle;
        //     }
        //     field("x Quantity per"; rec."x Quantity per")
        //     {
        //     }
        // }
        modify(Type)
        {
            StyleExpr = TxTGStyle;
        }
        modify("No.")
        {
            StyleExpr = TxTGStyle;
        }
        modify(Description)
        {
            StyleExpr = TxTGStyle;
        }
        modify("Description 2")
        {
            StyleExpr = TxTGStyle;
        }
        modify("Variant Code")
        {
            StyleExpr = TxTGStyle;
        }
        modify("Quantity per")
        {
            StyleExpr = TxTGStyle;
        }
        modify("Unit of Measure Code")
        {
            StyleExpr = TxTGStyle;
        }
        modify(Quantity)
        {
            Caption = 'Total Qty';
            StyleExpr = TxTGStyle;
        }
        modify("Reserved Quantity")
        {
            StyleExpr = TxTGStyle;
        }
    }
    actions
    {
        addafter("&Reserve")
        {
            action("Modifier réservation achat sur stock")
            {
                Promoted = true;
                Image = LineReserve;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    RecL337: Record "Reservation Entry";
                    RecL337b: Record "Reservation Entry";
                    EntrySummary: Record "Entry Summary" temporary;
                    AssemblyLine: Record "Assembly Line";
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
                    ReservMgt: Codeunit "Reservation Management";
                    Reservation: Page Reservation;
                    FullAutoReservation: Boolean;
                    QtyToReserve: Decimal;
                begin
                    AssemblyLine.COPYFILTERS(Rec);
                    if AssemblyLine.FINDFIRST() then
                        repeat
                            RecL337.SETRANGE("Source Type", DATABASE::"Assembly Line");
                            RecL337.SETRANGE("Source Subtype", AssemblyLine."Document Type");
                            RecL337.SETRANGE("Source ID", AssemblyLine."Document No.");
                            RecL337.SETRANGE("Source Ref. No.", AssemblyLine."Line No.");
                            RecL337.SETRANGE("Reservation Status", RecL337."Reservation Status"::Reservation);
                            if RecL337.FINDSET() then
                                repeat
                                    QtyToReserve := 0;

                                    RecL337b.SETRANGE("Entry No.", RecL337."Entry No.");
                                    RecL337b.SETFILTER("Source Type", '<>901');
                                    if RecL337b.FINDSET() then
                                        if RecL337b."Source Type" = DATABASE::"Purchase Line" then begin
                                            ItemLedgerEntry.SETRANGE("Item No.", AssemblyLine."No.");
                                            ItemLedgerEntry.SETRANGE("Variant Code", AssemblyLine."Variant Code");
                                            ItemLedgerEntry.SETRANGE("Location Code", AssemblyLine."Location Code");
                                            ItemLedgerEntry.SETRANGE("Drop Shipment", false);
                                            ItemLedgerEntry.SETRANGE(Open, true);
                                            ItemLedgerEntry.SETRANGE(Positive, true);
                                            ItemLedgerEntry.SETFILTER("Remaining Quantity", '>%1', 0);
                                            if ItemLedgerEntry.FINDSET() then
                                                repeat
                                                    ItemLedgerEntry.CALCFIELDS("Reserved Quantity");
                                                    QtyToReserve += ItemLedgerEntry."Remaining Quantity" - ItemLedgerEntry."Reserved Quantity";
                                                until ItemLedgerEntry.NEXT() = 0;

                                            if QtyToReserve >= AssemblyLine.Quantity then begin

                                                CLEAR(ReservEngineMgt);
                                                ReservEngineMgt.CancelReservation(RecL337b);

                                                CLEAR(ReservMgt);
                                                //TODO : procedure replaced by SetSourceForAssemblyLine but it is local
                                                //ReservMgt.SetAssemblyLine(AssemblyLine);
                                                ReservMgt.AutoReserve(FullAutoReservation, '', AssemblyLine."Due Date", AssemblyLine."Remaining Quantity", AssemblyLine."Remaining Quantity (Base)");
                                            end;
                                        end;
                                until (RecL337.NEXT() = 0);
                        until AssemblyLine.NEXT() = 0;
                end;
            }
        }
        addafter("Select Item Substitution")
        {
            action("Get All Item Substitution List")
            {
                Image = SelectItemSubstitution;
                trigger OnAction()
                var
                    ItemSubstMgt: Codeunit "Item Subst.";
                    AssemblyLineRec: Record "Assembly Line";
                begin
                    CLEAR(AssemblyLineRec);
                    CurrPage.SETSELECTIONFILTER(AssemblyLineRec);
                    if AssemblyLineRec.FindFirst() then
                        repeat
                        //TODO : codeunit not migrated yet
                        //ItemSubstMgt.ExplodeItemAssemblySubst(AssemblyLineRec, false, false);
                        until AssemblyLineRec.NEXT() = 0;
                    CurrPage.UPDATE();
                end;
            }
            action("Get All Available Item Substitution List")
            {
                Image = SelectItemSubstitution;
                trigger OnAction()
                var
                    ItemSubstMgt: Codeunit "Item Subst.";
                    AssemblyLineRec: Record "Assembly Line";
                begin
                    CLEAR(AssemblyLineRec);
                    CurrPage.SETSELECTIONFILTER(AssemblyLineRec);
                    if AssemblyLineRec.FindFirst() then
                        repeat
                        //TODO : codeunit not migrated yet
                        //ItemSubstMgt.ExplodeItemAssemblySubst(AssemblyLineRec, true, false);
                        until AssemblyLineRec.NEXT() = 0;
                    CurrPage.UPDATE();
                end;
            }
            action("Remplace And Reserve All Available Item Substitution List")
            {
                Image = SelectItemSubstitution;
                trigger OnAction()
                var
                    ItemSubstMgt: Codeunit "Item Subst.";
                    AssemblyLineRec: Record "Assembly Line";
                begin
                    CLEAR(AssemblyLineRec);
                    CurrPage.SETSELECTIONFILTER(AssemblyLineRec);
                    if AssemblyLineRec.FindFirst() then
                        repeat
                        //TODO : codeunit not migrated yet
                        //ItemSubstMgt.ExplodeItemAssemblySubst(AssemblyLineRec, true, true);
                        until AssemblyLineRec.NEXT() = 0;
                    CurrPage.UPDATE();
                end;
            }
        }
        addafter("Explode BOM")
        {
            // action("Explode and Reserve BOM")
            // {
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     Image = ExplodeBOM;
            //     trigger OnAction()
            //     var
            //         IntLDocumentLineNo: Integer;
            //         IntLLineNo: Integer;
            //         BoolEndLoop: Boolean;
            //         RecLATOLink: Record 904;
            //     begin
            //         VALIDATE(rec."Kit Action", rec."Kit Action"::Disassembly);
            //         MODIFY();
            //         AsmLinMgt.SetAutoReserve;
            //         AsmLinMgt.FctRefreshTempSubKitSalesFTA(Rec);
            //         CurrPage.UPDATE();
            //     end;
            // }
        }
        addafter("Item &Tracking Lines")
        {
            action("Where-Used")
            {
                RunObject = Page "Where-Used List";
                RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                Image = "Where-Used";
            }
        }
    }
    var
        KitLine: Record "Sales Line";
        IntGColor: Integer;
        BooGAvailWithoutCurrentLine: Boolean;
        DecGQtyKit: Decimal;
        RecGKitSalesLine: Record "Assembly Line";
        TxTGStyle: Text;
        AsmLinMgt: Codeunit "Assembly Line Management";
        DateFilter: Date;

    procedure FctSearchColor();
    var
        RecL337: Record 337;
        RecL337b: Record 337;
        RecLATOLink: Record 904;
    begin
        rec.CALCFIELDS(rec."Reserved Quantity");
        IntGColor := 0;
        if (rec."Reserved Quantity" < rec."Remaining Quantity") then
            IntGColor := 0
        else begin
            RecL337.SETRANGE("Source Type", DATABASE::"Assembly Line");
            RecL337.SETRANGE("Source Subtype", rec."Document Type");
            RecL337.SETRANGE("Source ID", rec."Document No.");
            RecL337.SETRANGE("Source Ref. No.", rec."Line No.");
            RecL337.SETRANGE("Reservation Status", RecL337."Reservation Status"::Reservation);
            if RecL337.FINDSET() then
                repeat
                    RecL337b.SETRANGE("Entry No.", RecL337."Entry No.");
                    RecL337b.SETFILTER("Source Type", '<>901');
                    if RecL337b.FINDSET() then
                        case IntGColor of
                            0:
                                begin
                                    if RecL337b."Source Type" = DATABASE::"Item Ledger Entry" then
                                        IntGColor := 1;
                                    if RecL337b."Source Type" = DATABASE::"Purchase Line" then
                                        IntGColor := 2;
                                end;
                            1:
                                begin
                                    if RecL337b."Source Type" = DATABASE::"Purchase Line" then
                                        IntGColor := 2;
                                end;
                        end;
                until (RecL337.NEXT() = 0) or (IntGColor = 2);
        end;

        TxTGStyle := '';
        // if ("Level No." <> 0) then
        //     TxTGStyle := 'Strong';
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
        AvailibilityQty: Decimal;
        PurchaseLine: Record 39;
    begin
        AvailibilityQty := 0;

        PurchaseLine.RESET();
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("No.", rec."No.");
        PurchaseLine.SETFILTER("Expected Receipt Date", '<=%1', DateFilter);
        if PurchaseLine.FINDSET() then
            repeat
                PurchaseLine.CALCFIELDS("Reserved Quantity");
                AvailibilityQty += PurchaseLine."Outstanding Quantity" - PurchaseLine."Reserved Quantity";
            until PurchaseLine.NEXT() = 0;


        exit(AvailibilityQty);
    end;

    LOCAL PROCEDURE LookUpAvailPurchase();
    VAR
        PurchaseLines: Page 518;
        PurchaseLine: Record 39;
    BEGIN
        PurchaseLine.RESET();
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("No.", rec."No.");
        PurchaseLine.SETFILTER("Expected Receipt Date", '<=%1', DateFilter);
        PurchaseLines.SETTABLEVIEW(PurchaseLine);
        PurchaseLines.RUNMODAL();
    END;

    LOCAL PROCEDURE GetAvailbilityPurchaseQty(): Decimal;
    VAR
        AvailibilityQty: Decimal;
        PurchaseLine: Record 39;
    BEGIN
        AvailibilityQty := 0;

        PurchaseLine.RESET();
        PurchaseLine.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date", "Promised Receipt Date");
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("No.", rec."No.");
        PurchaseLine.SETFILTER("Promised Receipt Date", '<>%1', 0D);
        IF PurchaseLine.FINDSET() THEN
            REPEAT
                PurchaseLine.CALCFIELDS("Reserved Quantity");
                AvailibilityQty := PurchaseLine."Outstanding Quantity" - PurchaseLine."Reserved Quantity";
                IF AvailibilityQty >= Rec.Quantity THEN
                    EXIT(AvailibilityQty);
            UNTIL PurchaseLine.NEXT() = 0;

        EXIT(AvailibilityQty);
    END;

    LOCAL PROCEDURE GetAvailbilityPurchaseDate(): Date;
    VAR
        AvailibilityQty: Decimal;
        PurchaseLine: Record 39;
    BEGIN
        AvailibilityQty := 0;

        PurchaseLine.RESET();
        PurchaseLine.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date", "Promised Receipt Date");
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("No.", rec."No.");
        PurchaseLine.SETFILTER("Promised Receipt Date", '<>%1', 0D);
        IF PurchaseLine.FINDSET() THEN
            REPEAT
                PurchaseLine.CALCFIELDS("Reserved Quantity");
                AvailibilityQty := PurchaseLine."Outstanding Quantity" - PurchaseLine."Reserved Quantity";
                IF AvailibilityQty >= Rec.Quantity THEN
                    EXIT(PurchaseLine."Promised Receipt Date");
            UNTIL PurchaseLine.NEXT() = 0;

        EXIT(0D);
    END;

    LOCAL PROCEDURE GetItemInventory(): Decimal;
    VAR
        Item: Record 27;
    BEGIN
        IF Item.GET(rec."No.") THEN BEGIN
            Item.CALCFIELDS(Inventory);
            EXIT(Item.Inventory);
        END;

        EXIT(0);
    END;
}
