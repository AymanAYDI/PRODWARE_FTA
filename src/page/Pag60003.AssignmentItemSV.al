namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Ledger;
using Microsoft.Finance.Consolidation;
using Microsoft.Inventory.Item;
using Microsoft.Assembly.Document;
using Microsoft.Inventory.BOM;
using Microsoft.Purchases.Document;
page 60003 "Assignment ItemSV"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Kit Build up or remove into pieces
    //                              - Creation  g

    Caption = 'Assignment Item';
    DataCaptionExpression = StrSubstNo('%1 %2 %3 %4 %5', Format(Rec."Document Type"), Rec."Document No.", Rec.Type, Rec."No.", Rec.Description);
    PaGetype = Card;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            field(Quantity; Rec.Quantity)
            {
                Editable = false;
                ToolTip = 'Specifies the value of the Quantity field.';
            }
            field("Reserved Quantity"; Rec."Reserved Quantity")
            {
                Editable = false;
                ToolTip = 'Specifies the value of the Reserved Quantity field.';
            }
            field(DecGDisposalQtyKit; DecGDisposalQtyKit)
            {
                Caption = 'Quantity to built up ';
                DecimalPlaces = 0 : 5;
                Editable = false;
                ToolTip = 'Specifies the value of the Quantity to built up  field.';
            }
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
                    RecLItemLedgerEntry.Reset();
                    //ReclItemLedgerEntry.SetRange(Type,Type::Item);
                    RecLItemLedgerEntry.SetRange("Item No.", Rec."No.");
                    if Rec."Location Code" <> '' then
                        RecLItemLedgerEntry.SetFilter("Location Code", Rec."Location Code");
                    RecLItemLedgerEntry.SetRange(Open, true);
                    RecLItemLedgerEntry.SetFilter("Drop Shipment", Format(false));
                    PAGE.RunModal(Page::"Item Ledger Entries", RecLItemLedgerEntry);
                end;
            }
            field(DecGDisposalQtyPurchOrder; DecGDisposalQtyPurchOrder)
            {
                Caption = 'Purchase not Reserved';
                DecimalPlaces = 0 : 5;
                Editable = false;
                ToolTip = 'Specifies the value of the Purchase not Reserved field.';
                trigger OnLookup(var Text: Text): Boolean
                begin
                    RecGPurchLine.Reset();
                    RecGPurchLine.SetRange(Type, Rec.Type::Item);
                    RecGPurchLine.SetRange("No.", Rec."No.");
                    if Rec."Location Code" <> '' then
                        RecGPurchLine.SetFilter("Location Code", Rec."Location Code");
                    if Rec."Shipment Date" <> 0D then
                        RecGPurchLine.SetFilter("Promised Receipt Date", '..%1', Rec."Shipment Date");
                    RecGPurchLine.SetFilter("Drop Shipment", Format(false));
                    PAGE.RunModal(Page::"Purchase Lines", RecGPurchLine);
                end;
            }
            field(EcrQtyKit; DecGQtyKit)
            {
                Caption = 'Quantity to affect';
                DecimalPlaces = 0 : 5;
                ToolTip = 'Specifies the value of the Quantity to affect field.';
                trigger OnValidate()
                begin
                    FctCalcQtyKit();
                    FctCalcTotal();
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
            field(EcrAssKit; BooGAssemblyKit)
            {
                Caption = 'Mono and multilevel Assembly';
                ToolTip = 'Specifies the value of the Mono and multilevel Assembly field.';
                trigger OnValidate()
                begin
                    FctCalcQtyKit();
                    FctCalcTotal();
                end;
            }
            field(BooGAssignOnStock; BooGAssignOnStock)
            {
                Caption = 'Assignment on stock';
                ToolTip = 'Specifies the value of the Assignment on stock field.';
                trigger OnValidate()
                begin
                    FctCalcTotal();
                end;
            }
            field(BooGAssignOnOrder; BooGAssignOnOrder)
            {
                Caption = 'Assignment on order purchase';
                ToolTip = 'Specifies the value of the Assignment on order purchase field.';
                trigger OnValidate()
                begin
                    BooGAssignOnOrderOnPush();
                end;
            }
            field(BooGRemainder; BooGRemainder)
            {
                Caption = 'Remainder Generation';
                Editable = false;
                ToolTip = 'Specifies the value of the Remainder Generation field.';
                trigger OnValidate()
                begin
                    FctCalcTotal();
                end;
            }
            field(DecGTotal; DecGTotal)
            {
                Caption = 'Quantity to affect';
                DecimalPlaces = 0 : 5;
                Editable = false;
                Style = Strong;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the Quantity to affect field.';
            }
            label(Field)
            {
                CaptionClass = Text19028226;
                Style = Strong;
                StyleExpr = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowComponents)
            {
                Caption = 'Components';
                Image = Components;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Components action.';
                trigger OnAction()
                var
                    TempKitSalesLine: Record "Assembly Line"; //901  OLD// Record "25000";
                    RecLSalesLine: Record "Sales Line";
                    AssignmentItem: Page "Assignment Item";
                begin
                    //DecGxrecQuantityBase := "Quantity (Base)";
                    RecLSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                    RecLSalesLine."Quantity (Base)" := Rec."Quantity (Base)" / Rec.Quantity * DecGQtyKit;
                    RecLSalesLine."Outstanding Qty. (Base)" := Rec."Outstanding Qty. (Base)" / Rec.Quantity * DecGQtyKit;
                    AssignmentItem.UpdateKitSales(RecLSalesLine, TempKitSalesLine);
                    Rec.FctShowKitLinesFTA();
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
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Privacy Statement";
                ToolTip = 'Executes the Unbuild action.';
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupCancel then
            LookupCancelOnPush();
        if CloseAction = Action::LookupOK then
            LookupOKOnPush();
    end;

    var
        RecGSalesLine: Record "Sales Line";
        RecGItem: Record "Item";
        TempKitSalesLine: Record "Assembly Line" temporary;
        KitComp: Record "BOM Component";
        RecGPurchLine: Record "Purchase Line";
        KitSalesLine: Record "Assembly Line";
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

    procedure FctButtonOK()
    var
        RecLSalesLine: Record "Sales Line";
        IntLLineNo: Integer;
        RemainingQtyToReserveBase: Decimal;
    begin
        FctCalcTotal();
        if DecGTotal > Rec.Quantity then
            Error(CstG014, DecGTotal, Rec.Quantity);
        BooGLineToBeCreate := false;

        //Assignment on stock,mono and multilevel Assembly,Disassembling,Assignment on order purchase,Remainder Generation
        if BooGAssemblyKit and (DecGQtyKit <> 0) then begin
            //IF DecGQtyKit > DecGDisposalQtyKit THEN
            //  Error(CstG001,DecGQtyKit,CstG011,DecGDisposalQtyKit);
            if DecGQtyKit > Rec.Quantity then
                Error(CstG002, DecGQtyKit, CstG011, Rec.Quantity);
            Rec.FctReserveOnKit(Rec, DecGQtyKit);
            BooGLineToBeCreate := true;
        end;
        if BooGAssignOnStock and (DecGQtyStock <> 0) then begin
            if DecGQtyStock > DecGDisposalQtyStock then
                Error(CstG001, DecGQtyStock, CstG010, DecGDisposalQtyStock);
            if DecGQtyStock > Rec.Quantity then
                Error(CstG002, DecGQtyStock, CstG010, Rec.Quantity);
            if BooGLineToBeCreate then begin
                Rec.FctCreateSalesLine(Rec, DecGQtyStock, IntLLineNo);
                if RecLSalesLine.Get(Rec."Document Type", Rec."Document No.", IntLLineNo) then
                    Rec.FctReserveOnStock(RecLSalesLine, DecGQtyStock, RemainingQtyToReserveBase);
            end else begin
                KitSalesLine.SetRange("Document Type", Rec."Document Type");
                KitSalesLine.SetRange("Document No.", Rec."Document No.");
                //KitSalesLine.SetRange("Document Line No.", Rec."Line No."); //TODO->Can't Find Field 
                KitSalesLine.DeleteALL();
                Rec.FctReserveOnStock(Rec, DecGQtyStock, RemainingQtyToReserveBase);
            end;
            BooGLineToBeCreate := true;
        end;
        if BooGAssignOnOrder and (DecGQtyPurchOrder <> 0) then begin
            if DecGQtyPurchOrder > DecGDisposalQtyPurchOrder then
                Error(CstG001, DecGQtyPurchOrder, CstG012, DecGDisposalQtyPurchOrder);
            if DecGQtyPurchOrder > Rec.Quantity then
                Error(CstG002, DecGQtyPurchOrder, CstG012, Rec.Quantity);
            if BooGLineToBeCreate then begin
                Rec.FctCreateSalesLine(Rec, DecGQtyPurchOrder, IntLLineNo);
                if RecLSalesLine.Get(Rec."Document Type", Rec."Document No.", IntLLineNo) then
                    Rec.FctReserveOnPurchLine(RecLSalesLine, DecGQtyPurchOrder);
            end else begin
                KitSalesLine.SetRange("Document Type", Rec."Document Type");
                KitSalesLine.SetRange("Document No.", Rec."Document No.");
                // KitSalesLine.SetRange("Document Line No.", Rec."Line No.");//TODO->Can't Find Field
                KitSalesLine.DeleteALL();
                Rec.FctReserveOnPurchLine(Rec, DecGQtyPurchOrder);
            end;
            BooGLineToBeCreate := true;
        end;
        if DecGQtyRemainder > 0 then begin
            if DecGQtyRemainder > Rec.Quantity then
                Error(CstG001, DecGQtyRemainder, CstG013, Rec.Quantity);
            if DecGQtyRemainder > Rec.Quantity then
                Error(CstG002, DecGQtyRemainder, CstG013, Rec.Quantity);
            if BooGLineToBeCreate then
                Rec.FctCreateSalesLine(Rec, DecGQtyRemainder, IntLLineNo)
            else begin
                KitSalesLine.SetRange("Document Type", Rec."Document Type");
                KitSalesLine.SetRange("Document No.", Rec."Document No.");
                // KitSalesLine.SetRange("Document Line No.", Rec."Line No.");//TODO->Can't Find Field
                KitSalesLine.DeleteALL();
                // "Build Kit" := false;//TODO->Can't Find
                Rec."Preparation Type" := Rec."Preparation Type"::Remainder;
                Rec.Modify();
            end;


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
        TempKitSalesLine: Record "Assembly Line"; //901  OLD// Record "25000";       
        RecLSalesLine: Record "Sales Line";
        AssignmentItem: Page "Assignment Item";

    begin
        if DecGQtyKit <> 0 then begin
            BooGAssemblyKit := true;
            RecLSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
            RecLSalesLine."Quantity (Base)" := Rec."Quantity (Base)" / Rec.Quantity * DecGQtyKit;
            RecLSalesLine."Outstanding Qty. (Base)" := Rec."Outstanding Qty. (Base)" / Rec.Quantity * DecGQtyKit;
            AssignmentItem.UpdateKitSales(RecLSalesLine, TempKitSalesLine);
        end else
            BooGAssemblyKit := false;
    end;

    local procedure BooGAssignOnOrderOnPush()
    begin
        FctCalcTotal();
    end;

    local procedure LookupOKOnPush()
    begin
        FctButtonOK();
        CurrPage.Close();
    end;

    local procedure LookupCancelOnPush()
    var
        CstL001: Label 'Process cancelled';
    begin
        KitSalesLine.SetRange("Document Type", Rec."Document Type");
        KitSalesLine.SetRange("Document No.", Rec."Document No.");
        // KitSalesLine.SetRange("Document Line No.", Rec."Line No.");//TODO->Can't Find Field
        KitSalesLine.DeleteALL();
        // "Build Kit" := false;//TODO->Can't Find
        //Message(Format(DecGxQuantity));
        Rec."Preparation Type" := OptGxPreparationType;
        Rec.Validate(Quantity, DecGxQuantity);
        Rec.Modify();
        Message(CstL001);
        CurrPage.Close();
    end;
}

