namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Journal;
using Microsoft.Purchases.Document;
using Microsoft.Assembly.Document;
using Microsoft.Inventory.Item;
page 50003 "Assignment Item"
{

    Caption = 'Assignment Item';
    DataCaptionExpression = STRSUBSTNO(Text0001, FORMAT(Rec."Document Type"), Rec."Document No.", Rec.Type, Rec."No.", Rec.Description);
    PageType = NavigatePage;
    SourceTable = "Sales Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(Quantity; Rec.Quantity)
            {
                Editable = false;
                ToolTip = 'Specifies the quantity of the sales order line.';
            }
            field("Reserved Quantity"; Rec."Reserved Quantity")
            {
                Editable = false;
                ToolTip = 'Specifies how many units of the item on the line have been reserved.';
            }
            label("Quantity to affect")
            {
                Caption = 'Quantity to affect';
                Editable = false;
                Style = Strong;
                StyleExpr = true;
            }
            grid(Columns)
            {
                Editable = BooGEditableKit;
                GridLayout = Columns;
                field(DecGDisposalQtyKit; DecGDisposalQtyKit)
                {
                    Caption = 'Quantity to built up ';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity to built up  field.';
                }
                field(EcrQtyKit; DecGQtyKit)
                {
                    Caption = 'Quantity to affect';
                    DecimalPlaces = 0 : 5;
                    Editable = BooGEditableKit;
                    ToolTip = 'Specifies the value of the Quantity to affect field.';
                    trigger OnValidate()
                    var
                    //RecLSalesLine: Record "Sales Line";
                    begin
                        if DecGQtyKit <> 0 then
                            BooGAssemblyKit := true
                        else
                            BooGAssemblyKit := false;
                        FctCalcQtyKit();
                        FctCalcTotal();
                    end;
                }
                field(EcrAssKit; BooGAssemblyKit)
                {
                    Editable = BooGEditableKit;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        FctCalcQtyKit();
                        FctCalcTotal();
                    end;
                }
            }
            grid(Columns2)
            {
                GridLayout = Columns;
                field(DecGDisposalQtyStock; DecGDisposalQtyStock)
                {
                    Caption = 'Stock not reserved';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Stock not reserved field.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        RecLItemLedgerEntry: Record "Item Ledger Entry";
                        FrmLItemLedgerEntries: Page "Item Ledger Entries";
                    begin
                        RecLItemLedgerEntry.RESET();
                        //ReclItemLedgerEntry.SETRANGE(Type,Type::Item);
                        RecLItemLedgerEntry.SETRANGE("Item No.", Rec."No.");
                        if Rec."Location Code" <> '' then
                            RecLItemLedgerEntry.SETFILTER("Location Code", Rec."Location Code");
                        RecLItemLedgerEntry.SETRANGE(Open, true);
                        RecLItemLedgerEntry.SETFILTER("Drop Shipment", FORMAT(false));
                        PAGE.RUNMODAL(Page::"Item Ledger Entries", RecLItemLedgerEntry);
                    end;
                }
                field(DecGQtyStock; DecGQtyStock)
                {
                    Caption = 'Quantity to affect';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the value of the Quantity to affect field.';
                    trigger OnValidate()
                    begin
                        if DecGQtyStock <> 0 then
                            BooGAssignOnStock := true
                        else
                            BooGAssignOnStock := false;
                        FctCalcTotal();
                    end;
                }
                field(BooGAssignOnStock; BooGAssignOnStock)
                {
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        FctCalcTotal();
                    end;
                }
            }
            grid(Columns3)
            {
                GridLayout = Columns;
                field(DecGDisposalQtyPurchOrder; DecGDisposalQtyPurchOrder)
                {
                    Caption = 'Purchase not Reserved';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Purchase not Reserved field.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                    //SalesLineSV: Record "Sales LineSV";
                    begin
                        RecGPurchLine.RESET();
                        RecGPurchLine.SETRANGE(Type, Rec.Type::Item);
                        RecGPurchLine.SETRANGE("No.", Rec."No.");
                        if Rec."Location Code" <> '' then
                            RecGPurchLine.SETFILTER("Location Code", Rec."Location Code");
                        if Rec."Shipment Date" <> 0D then
                            RecGPurchLine.SETFILTER("Promised Receipt Date", '..%1', Rec."Shipment Date");

                        //>>NDBI
                        RecGPurchLine.SETFILTER("Promised Receipt Date", '<>%1', 0D);
                        //<<NDBI

                        RecGPurchLine.SETFILTER("Drop Shipment", FORMAT(false));
                        //>>JEPE 27052019
                        //OLD PAGE.RUNMODAL(518,RecGPurchLine);
                        Rec.FctDeleteReservation();
                        COMMIT();

                        //>>NDBI
                        Rec.FctSetBooResaFTA(true);
                        //<<NDBI

                        Rec.ShowReservation();
                        SalesLineSV."Preparation Type" := SalesLineSV."Preparation Type"::Purchase;
                        Rec.MODIFY(false);
                        //<<JEPE 27052019
                    end;
                }
                field(DecGQtyPurchOrder; DecGQtyPurchOrder)
                {
                    Caption = 'Quantity to affect';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the value of the Quantity to affect field.';
                    trigger OnValidate()
                    begin
                        if DecGQtyPurchOrder <> 0 then
                            BooGAssignOnOrder := true
                        else
                            BooGAssignOnOrder := false;
                        FctCalcTotal();
                    end;
                }
                field(BooGAssignOnOrder; BooGAssignOnOrder)
                {
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        BooGAssignOnOrderOnPush();
                    end;
                }
            }
            grid(Columns4)
            {
                GridLayout = Columns;
                field(DecGQtyRemainder; DecGQtyRemainder)
                {
                    Caption = 'Quantity to affect';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Quantity to affect field.';
                    trigger OnValidate()
                    begin
                        FctCalcTotal();
                    end;
                }
                field(BooGRemainder; BooGRemainder)
                {
                    Editable = false;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        FctCalcTotal();
                    end;
                }
            }
            field(DecGTotal; DecGTotal)
            {
                Caption = 'Total';
                DecimalPlaces = 0 : 5;
                Editable = false;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the Total field.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowComponents)
            {
                Caption = 'Kit';
                Image = AssemblyOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = BooGVisibleKit;
                ToolTip = 'Executes the Kit action.';
                trigger OnAction()
                var
                    RecLSalesLine: Record "Sales Line";
                begin
                    //DecGxrecQuantityBase := "Quantity (Base)";
                    RecLSalesLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                    RecLSalesLine."Quantity (Base)" := Rec."Quantity (Base)" / Rec.Quantity * DecGQtyKit;
                    RecLSalesLine."Outstanding Qty. (Base)" := Rec."Outstanding Qty. (Base)" / Rec.Quantity * DecGQtyKit;

                    //>>MIG NAV 2015 : Update OLD Code
                    //KitManagement.UpdateKitSales(RecLSalesLine,TempKitSalesLine);
                    UpdateKitSales(RecLSalesLine, TempKitSalesLine);
                    //<<MIG NAV 2015 : Update OLD Code

                    Rec.FctShowKitLinesFTA();
                    if TempKitSalesLine.FINDFIRST() then;
                    //MESSAGE(TempKitSalesLine."No.");
                    //"Quantity (Base)" := DecGxrecQuantityBase;
                    //Rec.Quantity := DecGxrecQuantity;
                    //KitManagement.UpdateKitSales(Rec,TempKitSalesLine);
                    BooGShowComponents := false;
                    //OptGChoice := OptGChoice::"mono and multilevel Assembly";
                    BooGAssemblyKit := true;
                end;
            }
            action(Unbuild)
            {
                Caption = 'Unbuild';
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Unbuild action.';
                trigger OnAction()
                begin
                    //>>MIG NAV 2015 : Not supported
                    //PAGE.RUNMODAL(PAGE::"BOM Journal");
                    PAGE.RUNMODAL(PAGE::"Item Journal");
                    //<<MIG NAV 2015 : Not supported
                    FctCalcInformation();
                    CurrPage.UPDATE(false);
                end;
            }
            action(OK)
            {
                Caption = 'OK';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the OK action.';
                trigger OnAction()
                begin
                    LookupOKOnPush()
                end;
            }
            action(Cancel)
            {
                Caption = 'Cancel';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel action.';
                trigger OnAction()
                begin
                    LookupCancelOnPush()
                end;
            }
        }
    }

    var
        SalesLineSV: Record "Sales LineSV";
        RecGSalesLine: Record "Sales Line";
        RecGItem: Record "Item";
        DecGQtyStock: Decimal;
        DecGQtyKit: Decimal;
        DecGQtyPurchOrder: Decimal;
        DecGQtyRemainder: Decimal;
        DecGTotal: Decimal;
        BooGAssignOnStock: Boolean;
        BooGAssignOnOrder: Boolean;
        BooGAssemblyKit: Boolean;
        BooGRemainder: Boolean;
        DecGDisposalQtyStock: Decimal;
        DecGDisposalQtyKit: Decimal;
        DecGDisposalQtyPurchOrder: Decimal;
        RecGPurchLine: Record "Purchase Line";
        CstG001: Label 'Quantity %1 %2 greater from the disposal quantity %3. Please correct tha data.';
        CstG002: Label 'Quantity %1 %2 greater from the quantity %3. Please correct tha data.';
        CstG010: Label 'Assignment on stock';
        CstG011: Label 'Mono and multilevel Assembly';
        CstG012: Label 'Assignment on order purchase';
        CstG013: Label 'Remainder Generation';
        BooGShowComponents: Boolean;
        DecGxrecQuantityBase: Decimal;
        CstG014: Label 'The affected quantity %1 are greater than the ordered quantity %2. ';
        BooGLineToBeCreate: Boolean;
        DecGxQuantity: Decimal;
        OptGxPreparationType: Option " ",Stock,Assembly,Purchase,Remainder;
        Text19028226: Label 'Total';
        DecGRemainingQtyBase: Decimal;
        BooGVisibleKit: Boolean;
        BooGEditableKit: Boolean;
        TempKitSalesLine: Record "Assembly Line" temporary;
        Text0001: Label '%1 %2 %3 %4 %5', Comment = '%1="Document Type" ,%2="Document No." ,%3=Type ,%4="No." ,%5=Description';

    procedure FctGetParm(RecPSaleLine: Record "Sales Line"; var DecPxQuantity: Decimal; var OptPxPreparationType: Option " ",Stock,Assembly,Purchase,Remainder)
    begin
        RecGSalesLine := RecPSaleLine;
        DecGxQuantity := DecPxQuantity;
        OptGxPreparationType := OptPxPreparationType;
        //MESSAGE(FORMAT(DecGxQuantity));

        Rec := RecGSalesLine;
        FctCalcInformation();
    end;


    procedure FctCalcInformation()
    var
        RecLAssembletoOrderLink: Record "Assemble-to-Order Link";
        RecLAsmHeader: Record "Assembly Header";
        RecLAsmLine: Record "Assembly Line";
        TempLAsmLine: Record "Assembly Line" temporary;
        SalesLineSV: Record "Sales LineSV";
        AssLineMgt: Codeunit "Assembly Line Management";
    begin
        RecGItem.RESET();
        if Rec."Location Code" <> '' then
            RecGItem.SETFILTER("Location Filter", Rec."Location Code");
        if Rec."Shipment Date" <> 0D then
            RecGItem.SETFILTER("Date Filter", '..%1', Rec."Shipment Date");
        RecGItem.SETFILTER("Drop Shipment Filter", FORMAT(false));
        RecGItem.GET(Rec."No.");
        //>>MIG NAV 2015 : Update OLD Code
        //IF RecGItem."Kit BOM No." = '' THEN
        RecGItem.CALCFIELDS("Assembly BOM");
        if not RecGItem."Assembly BOM" then begin
            BooGVisibleKit := false;
            BooGEditableKit := false;
        end else begin
            BooGVisibleKit := true;
            BooGEditableKit := true;

            Rec.VALIDATE(Rec."Qty. to Assemble to Order", Rec.Quantity);

        end;
        //<<MIG NAV 2015 : Update OLD Code
        //>>NDBI
        //RecGItem.CALCFIELDS(Inventory,"Reserved Qty. on Inventory","Qty. on Purch. Order","Reserved Qty. on Purch. Orders");
        RecGItem.CALCFIELDS(Inventory, "Reserved Qty. on Inventory", "Qty. on Purch. Order", "Reserved Qty. on Purch. Orders", "Qty. on Purch. Order Confirmed");
        DecGDisposalQtyStock := RecGItem.Inventory - RecGItem."Reserved Qty. on Inventory";

        //DecGDisposalQtyPurchOrder := RecGItem."Qty. on Purch. Order" - RecGItem."Reserved Qty. on Purch. Orders" ;
        DecGDisposalQtyPurchOrder := RecGItem."Qty. on Purch. Order Confirmed" - RecGItem."Reserved Qty. on Purch. Orders";
        //<<NDBI
        //KIT
        TempKitSalesLine.DELETEALL();
        CLEAR(DecGDisposalQtyKit);

        //>>MIG NAV 2015 : Not supported
        //CheckKitItemAvail.SalesLineShowWarning(Rec,TempKitSalesLine);
        //DecGDisposalQtyKit := CheckKitItemAvail.FctCountKitDisposalToBuild;}
        TempLAsmLine.DELETEALL();
        RecLAssembletoOrderLink.RESET();
        RecLAssembletoOrderLink.SETRANGE("Document Type", Rec."Document Type");
        RecLAssembletoOrderLink.SETRANGE("Document No.", Rec."Document No.");
        RecLAssembletoOrderLink.SETRANGE("Document Line No.", Rec."Line No.");
        if RecLAssembletoOrderLink.FINDFIRST() then
            if RecLAsmHeader.GET(RecLAssembletoOrderLink."Assembly Document Type", RecLAssembletoOrderLink."Assembly Document No.") then begin
                RecLAsmLine.SETRANGE("Document Type", RecLAsmHeader."Document Type");
                RecLAsmLine.SETRANGE("Document No.", RecLAsmHeader."No.");
                if RecLAsmLine.FINDSET() then begin
                    repeat
                        TempLAsmLine.INIT();
                        TempLAsmLine.COPY(RecLAsmLine);
                        TempLAsmLine.INSERT();
                    until RecLAsmLine.NEXT() = 0;
                    DecGDisposalQtyKit := AssLineMgt.FctCountKitDisposalToBuild(RecLAsmHeader, TempLAsmLine);
                    //TODO -> FctCountKitDisposalToBuild Specifique
                end;
            end;


        //<<MIG NAV 2015 : Not supported

        if DecGDisposalQtyStock < Rec.Quantity then
            DecGQtyStock := DecGDisposalQtyStock
        else
            DecGQtyStock := Rec.Quantity;
        if DecGDisposalQtyPurchOrder < Rec.Quantity then
            DecGQtyPurchOrder := DecGDisposalQtyPurchOrder
        else
            DecGQtyPurchOrder := Rec.Quantity;
        if DecGDisposalQtyKit < Rec.Quantity then
            DecGQtyKit := DecGDisposalQtyKit
        else
            DecGQtyKit := Rec.Quantity;
        DecGQtyRemainder := Rec.Quantity;

        if DecGQtyStock = Rec.Quantity then
            BooGAssignOnStock := true;
        if SalesLineSV."Item Base" = SalesLineSV."Item Base"::"Transitory Kit" then begin
            BooGAssemblyKit := true;
            DecGQtyKit := Rec.Quantity;
            FctCalcQtyKit();
        end;
        FctCalcTotal();
    end;


    procedure FctButtonOK()
    var
        RecLSalesLine: Record "Sales Line";
        SalesLineSV: record "Sales LineSV";
        RecLATOLink: Record "Assemble-to-Order Link";
        SalesLine: Record "Sales Line";
        IntLLineNo: Integer;

    begin
        CurrPage.SAVERECORD();

        Rec.FctDeleteReservation();
        FctCalcTotal();
        if DecGTotal > Rec.Quantity then
            ERROR(CstG014, DecGTotal, Rec.Quantity);
        BooGLineToBeCreate := false;

        //Assignment on stock,mono and multilevel Assembly,Disassembling,Assignment on order purchase,Remainder Generation
        if BooGAssemblyKit and (DecGQtyKit <> 0) then begin
            //IF DecGQtyKit > DecGDisposalQtyKit THEN
            //  ERROR(CstG001,DecGQtyKit,CstG011,DecGDisposalQtyKit);
            if DecGQtyKit > Rec.Quantity then
                ERROR(CstG002, DecGQtyKit, CstG011, Rec.Quantity);

            //>>NDBI
            Rec.FctSetBooResaAssFTA(true);
            //<<NDBI

            FctCalcQtyKit();
            Rec.FctReserveOnKit(Rec, DecGQtyKit);
            BooGLineToBeCreate := true;
        end;
        if BooGAssignOnStock and (DecGQtyStock <> 0) then begin

            if DecGQtyStock > DecGDisposalQtyStock then
                ERROR(CstG001, DecGQtyStock, CstG010, DecGDisposalQtyStock);
            if DecGQtyStock > Rec.Quantity then
                ERROR(CstG002, DecGQtyStock, CstG010, Rec.Quantity);
            if BooGLineToBeCreate then begin
                Rec.FctCreateSalesLine(Rec, DecGQtyStock, IntLLineNo);
                if RecLSalesLine.GET(Rec."Document Type", Rec."Document No.", IntLLineNo) then
                    DecGRemainingQtyBase := DecGQtyStock * RecLSalesLine."Qty. per Unit of Measure";
                Rec.FctReserveOnStock(RecLSalesLine, DecGQtyStock, DecGRemainingQtyBase);
            end else begin
                //>>MIG NAV 2015 : Update OLD Code
                RecLATOLink.RESET();
                RecLATOLink.SETCURRENTKEY(Type, "Document Type", "Document No.", "Document Line No.");
                RecLATOLink.SETRANGE(Type, RecLATOLink.Type::Sale);
                RecLATOLink.SETRANGE("Document Type", Rec."Document Type");
                RecLATOLink.SETRANGE("Document No.", Rec."Document No.");
                RecLATOLink.SETRANGE("Document Line No.", Rec."Line No.");
                if (RecLATOLink.FINDFIRST()) and (Rec.Type = Rec.Type::Item) then
                    RecLATOLink.DeleteAsmFromSalesLine(Rec);

                /*
                KitSalesLine.SETRANGE("Document Type","Document Type");
                KitSalesLine.SETRANGE("Document No.","Document No.");
                KitSalesLine.SETRANGE("Document Line No.","Line No.");
                KitSalesLine.DELETEALL(TRUE);
                */
                Rec.VALIDATE(Rec."Qty. to Assemble to Order", 0);
                //<<MIG NAV 2015 : Update OLD Code
                DecGRemainingQtyBase := DecGQtyStock * RecLSalesLine."Qty. per Unit of Measure";
                Rec.FctReserveOnStock(Rec, DecGQtyStock, DecGRemainingQtyBase);
            end;
            BooGLineToBeCreate := true;
        end;
        if BooGAssignOnOrder and (DecGQtyPurchOrder <> 0) then begin
            if DecGQtyPurchOrder > DecGDisposalQtyPurchOrder then
                ERROR(CstG001, DecGQtyPurchOrder, CstG012, DecGDisposalQtyPurchOrder);
            if DecGQtyPurchOrder > Rec.Quantity then
                ERROR(CstG002, DecGQtyPurchOrder, CstG012, Rec.Quantity);
            //>>NDBI
            Rec.FctSetBooResaFTA(true);
            //<<NDBI
            if BooGLineToBeCreate then begin
                Rec.FctCreateSalesLine(Rec, DecGQtyPurchOrder, IntLLineNo);
                if RecLSalesLine.GET(Rec."Document Type", Rec."Document No.", IntLLineNo) then
                    SalesLine.FctReserveOnPurchLine(RecLSalesLine, DecGQtyPurchOrder);
            end else begin
                //>>MIG NAV 2015 : Update OLD Code
                RecLATOLink.RESET();
                RecLATOLink.SETCURRENTKEY(Type, "Document Type", "Document No.", "Document Line No.");
                RecLATOLink.SETRANGE(Type, RecLATOLink.Type::Sale);
                RecLATOLink.SETRANGE("Document Type", Rec."Document Type");
                RecLATOLink.SETRANGE("Document No.", Rec."Document No.");
                RecLATOLink.SETRANGE("Document Line No.", Rec."Line No.");
                if (RecLATOLink.FINDFIRST()) and (Rec.Type = Rec.Type::Item) then
                    RecLATOLink.DeleteAsmFromSalesLine(Rec);

                /*
                KitSalesLine.SETRANGE("Document Type","Document Type");
                KitSalesLine.SETRANGE("Document No.","Document No.");
                KitSalesLine.SETRANGE("Document Line No.","Line No.");
                KitSalesLine.DELETEALL(TRUE);
                */
                Rec.VALIDATE(Rec."Qty. to Assemble to Order", 0);
                //<<MIG NAV 2015 : Update OLD Code
                Rec.FctReserveOnPurchLine(Rec, DecGQtyPurchOrder);
            end;
            BooGLineToBeCreate := true;
        end;
        //DecGQtyRemainder := Quantity - (DecGQtyStock+DecGQtyKit+DecGQtyPurchOrder);
        if DecGQtyRemainder > 0 then begin
            if DecGQtyRemainder > Rec.Quantity then
                ERROR(CstG001, DecGQtyRemainder, CstG013, Rec.Quantity);
            if DecGQtyRemainder > Rec.Quantity then
                ERROR(CstG002, DecGQtyRemainder, CstG013, Rec.Quantity);
            if BooGLineToBeCreate then
                Rec.FctCreateSalesLine(Rec, DecGQtyRemainder, IntLLineNo)
            else begin
                //>>MIG NAV 2015 : Update OLD Code
                RecLATOLink.RESET();
                RecLATOLink.SETCURRENTKEY(Type, "Document Type", "Document No.", "Document Line No.");
                RecLATOLink.SETRANGE(Type, RecLATOLink.Type::Sale);
                RecLATOLink.SETRANGE("Document Type", Rec."Document Type");
                RecLATOLink.SETRANGE("Document No.", Rec."Document No.");
                RecLATOLink.SETRANGE("Document Line No.", Rec."Line No.");
                if (RecLATOLink.FINDFIRST()) and (Rec.Type = Rec.Type::Item) then
                    RecLATOLink.DeleteAsmFromSalesLine(Rec);

                /*
                KitSalesLine.SETRANGE("Document Type","Document Type");
                KitSalesLine.SETRANGE("Document No.","Document No.");
                KitSalesLine.SETRANGE("Document Line No.","Line No.");
                KitSalesLine.DELETEALL(TRUE);
                "Build Kit":= FALSE;
                */
                Rec.VALIDATE(Rec."Qty. to Assemble to Order", 0);
                //<<MIG NAV 2015 : Update OLD Code
                SalesLineSV."Preparation Type" := SalesLineSV."Preparation Type"::Remainder;
                Rec.MODIFY();
            end;

            CurrPage.UPDATE();
        end;

    end;


    procedure FctCalcTotal()
    begin
        DecGTotal := 0;
        if BooGAssignOnStock then
            DecGTotal += DecGQtyStock;
        if BooGAssemblyKit then
            DecGTotal += DecGQtyKit;
        if BooGAssignOnOrder then
            DecGTotal += DecGQtyPurchOrder;
        if DecGTotal < Rec.Quantity then begin
            DecGQtyRemainder := Rec.Quantity - DecGTotal;
            BooGRemainder := true;
        end else begin
            DecGQtyRemainder := 0;
            BooGRemainder := false;
        end;
        if BooGRemainder then
            DecGTotal += DecGQtyRemainder;
    end;


    procedure FctCalcQtyKit()
    var
        RecLSalesLine: Record "Sales Line";
        RecLATOLink: Record "Assemble-to-Order Link";
    begin
        if DecGQtyKit <> 0 then begin

            //  BooGAssemblyKit := TRUE;
            RecLSalesLine.GET(Rec."Document Type", Rec."Document No.", Rec."Line No.");
            RecLSalesLine."Quantity (Base)" := Rec."Quantity (Base)" / Rec.Quantity * DecGQtyKit;
            RecLSalesLine."Outstanding Qty. (Base)" := Rec."Outstanding Qty. (Base)" / Rec.Quantity * DecGQtyKit;

            //ADD PAMO

            //>>MIG NAV 2015 : Update OLD Code
            RecLATOLink.RESET();
            RecLATOLink.SETCURRENTKEY(Type, "Document Type", "Document No.", "Document Line No.");
            RecLATOLink.SETRANGE(Type, RecLATOLink.Type::Sale);
            RecLATOLink.SETRANGE("Document Type", Rec."Document Type");
            RecLATOLink.SETRANGE("Document No.", Rec."Document No.");
            RecLATOLink.SETRANGE("Document Line No.", Rec."Line No.");
            if RecLATOLink.FINDFIRST() then begin
                TempKitSalesLine.SETRANGE("Document Type", RecLATOLink."Assembly Document Type");
                TempKitSalesLine.SETRANGE("Document No.", RecLATOLink."Assembly Document No.");

                //TempKitSalesLine.SETRANGE("Document Type",RecLSalesLine."Document Type");
                //TempKitSalesLine.SETRANGE("Document No.",RecLSalesLine."Document No.");
                //TempKitSalesLine.SETRANGE("Document Line No.",RecLSalesLine."Line No.");
                //ADD PAMO
                //>>TI040889.001
                UpdateKitSales(RecLSalesLine, TempKitSalesLine);

                //KitManagement.UpdateKitSales(RecLSalesLine,TempKitSalesLine);
                //<<TI040889.001
            end;


        end
        // ELSE
        //  BooGAssemblyKit := FALSE;
    end;



    procedure UpdateKitSales(SalesLine: Record "Sales Line"; var TempKitSalesLine: Record "Assembly Line")
    var
        RecLATOLink: Record "Assemble-to-Order Link";
    begin
        with TempKitSalesLine do
            if FINDSET() then
                repeat
                    //>>MIG NAV 2015 : Update OLD Code
                    if RecLATOLink.GET("Document Type", "Document No.") then
                        //PAMO
                        //IF ("Document Type" = SalesLine."Document Type") AND
                        //   ("Document No." = SalesLine."Document No.") AND
                        //   ("Document Line No." = SalesLine."Line No.") THEN BEGIN
                        //PAMO
                        if (RecLATOLink."Document Type" = SalesLine."Document Type") and
                           (RecLATOLink."Document No." = SalesLine."Document No.") and
                           (RecLATOLink."Document Line No." = SalesLine."Line No.") then begin
                            //<<MIG NAV 2015 : Update OLD Code

                            Rec."Shipment Date" := SalesLine."Shipment Date";
                            "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                            "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                            case Type of
                                Type::Item, Type::Resource:
                                    //BEGIN
                                    //OLD "Extended Quantity" := "Quantity per" * SalesLine."Quantity (Base)";
                                    //OLD "Extended Quantity (Base)" := "Quantity per (Base)" * SalesLine."Quantity (Base)";
                                    Rec."Outstanding Quantity" := "Quantity per" * SalesLine."Outstanding Qty. (Base)";
                            //OLD "Outstanding Qty. (Base)" := "Quantity per (Base)" * SalesLine."Outstanding Qty. (Base)";
                            //END;
                            //OLD
                            /*Type::"Setup Resource":
                            BEGIN
                              "Extended Quantity" := "Quantity per";
                              "Extended Quantity (Base)" := "Quantity per (Base)";
                                "Outstanding Quantity" := "Quantity per";
                              "Outstanding Qty. (Base)" := "Quantity per (Base)";
                             END;*/
                            end;
                            //OLD "Quantity Shipped (Base)" := "Extended Quantity (Base)" - "Outstanding Qty. (Base)";
                            MODIFY();
                        end;
                until NEXT() = 0;
    end;

    local procedure BooGAssignOnOrderOnPush()
    begin
        FctCalcTotal();
    end;

    local procedure LookupOKOnPush()
    begin
        FctButtonOK();
        CurrPage.CLOSE();
    end;

    local procedure LookupCancelOnPush()
    var
        RecLATOLink: Record "Assemble-to-Order Link";
        CstL001: Label 'Process cancelled';
        CstL002: Label 'Delete of this line.';

    begin
        if (OptGxPreparationType <> OptGxPreparationType::" ") then begin
            if (OptGxPreparationType <> OptGxPreparationType::Assembly) then begin
                //>>MIG NAV 2015 : Update OLD Code
                RecLATOLink.RESET();
                RecLATOLink.SETCURRENTKEY(Type, "Document Type", "Document No.", "Document Line No.");
                RecLATOLink.SETRANGE(Type, RecLATOLink.Type::Sale);
                RecLATOLink.SETRANGE("Document Type", Rec."Document Type");
                RecLATOLink.SETRANGE("Document No.", Rec."Document No.");
                RecLATOLink.SETRANGE("Document Line No.", Rec."Line No.");
                if (RecLATOLink.FINDFIRST()) and (Rec.Type = Rec.Type::Item) then
                    RecLATOLink.DeleteAsmFromSalesLine(Rec);

                /*
                KitSalesLine.SETRANGE("Document Type","Document Type");
                KitSalesLine.SETRANGE("Document No.","Document No.");
                KitSalesLine.SETRANGE("Document Line No.","Line No.");
                KitSalesLine.DELETEALL(TRUE);
                "Build Kit" := FALSE;
                */
                Rec.VALIDATE(Rec."Qty. to Assemble to Order", 0);
                //<<MIG NAV 2015 : Update OLD Code
            end;
            //MESSAGE(FORMAT(DecGxQuantity));
            Rec."Preparation Type" := OptGxPreparationType;
            Rec.VALIDATE(Quantity, DecGxQuantity);
            Rec.MODIFY();
            MESSAGE(CstL001);
        end else begin
            Rec.DELETE(true);
            MESSAGE(CstL002);
        end;
        CurrPage.CLOSE();

    end;
}

