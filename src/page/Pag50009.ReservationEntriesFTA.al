namespace Prodware.FTA;

using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Requisition;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Manufacturing.Document;
using Microsoft.Inventory.Planning;
using Microsoft.Service.Document;
using Microsoft.Inventory.Transfer;
using Microsoft.Assembly.Document;
page 50009 "Reservation Entries FTA"
{
    Caption = 'Reservation Entries';
    //DataCaptionExpression = TextCaption;//TODO
    DeleteAllowed = false;
    InsertAllowed = false;
    PaGetype = ListPart;
    SourceTable = "Reservation Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Repeater)
            {
                field("Reservation Status"; Rec."Reservation Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Reservation Status field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shipment Date field.';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ToolTip = 'Specifies the value of the Quantity (Base) field.';
                    trigger OnValidate()
                    begin
                        ReservEngineMgt.ModifyReservEntry(xRec, Rec."Quantity (Base)", Rec.Description, false);
                        QuantityBaseOnAfterValidate();
                    end;
                }
                field(ReservEngineMgtCreateForText; ReservEngineMgt.CreateForText(Rec))
                {
                    Caption = 'Reserved For';
                    Editable = false;
                    ToolTip = 'Specifies the value of the ReservEngineMgt field.';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupReservedFor();
                    end;
                }
                field(ReservEngineMgtCreateFromText; ReservEngineMgt.CreateFromText(Rec))
                {
                    Caption = 'Reserved From';
                    Editable = false;
                    ToolTip = 'Specifies the value of the ReservEngineMgt field.';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupReservedFrom();
                    end;
                }
                field(Description; Rec.Description)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Source Type field.';
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Source Subtype field.';
                }
                field("Source ID"; Rec."Source ID")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Source ID field.';
                }
                field("Source Batch Name"; Rec."Source Batch Name")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Source Batch Name field.';
                }
                field("Source Ref. No."; Rec."Source Ref. No.")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Source Ref. No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Transferred from Entry No."; Rec."Transferred from Entry No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Transferred from Entry No. field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnModifyRecord(): Boolean
    begin
        ReservEngineMgt.ModifyReservEntry(xRec, Rec."Quantity (Base)", Rec.Description, true);
        exit(false);
    end;

    var

        SalesLine: Record "Sales Line";
        ReqLine: Record "Requisition Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        ServiceInvLine: Record "Service Line";
        TransLine: Record "Transfer Line";
        //ReservEntry: Record "Reservation Entry";
        KitSalesLine: Record "Assembly Line";
        AssembletoOrderLink: Record "Assemble-to-Order Link";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";


    procedure LookupReservedFor()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Get(Rec."Entry No.", false);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReservedFrom()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Get(Rec."Entry No.", true);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReserved(ReservEntry: Record "Reservation Entry")
    begin
        with ReservEntry do
            case "Source Type" of
                DATABASE::"Sales Line":
                    begin
                        SalesLine.Reset();
                        SalesLine.SetRange("Document Type", "Source Subtype");
                        SalesLine.SetRange("Document No.", "Source ID");
                        SalesLine.SetRange("Line No.", "Source Ref. No.");
                        PAGE.RunModal(PAGE::"Sales Lines", SalesLine);
                    end;
                DATABASE::"Requisition Line":
                    begin
                        ReqLine.Reset();
                        ReqLine.SetRange("Worksheet Template Name", "Source ID");
                        ReqLine.SetRange("Journal Batch Name", "Source Batch Name");
                        ReqLine.SetRange("Line No.", "Source Ref. No.");
                        PAGE.RunModal(PAGE::"Requisition Lines", ReqLine);
                    end;
                DATABASE::"Purchase Line":
                    begin
                        PurchLine.Reset();
                        PurchLine.SetRange("Document Type", "Source Subtype");
                        PurchLine.SetRange("Document No.", "Source ID");
                        PurchLine.SetRange("Line No.", "Source Ref. No.");
                        PAGE.RunModal(PAGE::"Purchase Lines", PurchLine);
                    end;
                DATABASE::"Item Journal Line":
                    begin
                        ItemJnlLine.Reset();
                        ItemJnlLine.SetRange("Journal Template Name", "Source ID");
                        ItemJnlLine.SetRange("Journal Batch Name", "Source Batch Name");
                        ItemJnlLine.SetRange("Line No.", "Source Ref. No.");
                        ItemJnlLine.SetRange("Entry Type", "Source Subtype");
                        PAGE.RunModal(PAGE::"Item Journal Lines", ItemJnlLine);
                    end;
                //>>MIG NAV 2015 : Not Supported
                /*
                DATABASE::"BOM Journal Line":
                  BEGIN
                    BOMJnlLine.Reset;
                    BOMJnlLine.SetRange("Journal Template Name","Source ID");
                    BOMJnlLine.SetRange("Journal Batch Name","Source Batch Name");
                    BOMJnlLine.SetRange("Line No.","Source Ref. No.");
                    PAGE.RunModal(PAGE::"BOM Journal Lines",BOMJnlLine);
                  END;
                */
                //<<MIG NAV 2015 : Not Supported
                DATABASE::"Item Ledger Entry":
                    begin
                        ItemLedgEntry.Reset();
                        ItemLedgEntry.SetRange("Entry No.", "Source Ref. No.");
                        PAGE.RunModal(0, ItemLedgEntry);
                    end;
                DATABASE::"Prod. Order Line":
                    begin
                        ProdOrderLine.Reset();
                        ProdOrderLine.SetRange(Status, "Source Subtype");
                        ProdOrderLine.SetRange("Prod. Order No.", "Source ID");
                        ProdOrderLine.SetRange("Line No.", "Source Prod. Order Line");
                        PAGE.RunModal(0, ProdOrderLine);
                    end;
                DATABASE::"Prod. Order Component":
                    begin
                        ProdOrderComp.Reset();
                        ProdOrderComp.SetRange(Status, "Source Subtype");
                        ProdOrderComp.SetRange("Prod. Order No.", "Source ID");
                        ProdOrderComp.SetRange("Prod. Order Line No.", "Source Prod. Order Line");
                        ProdOrderComp.SetRange("Line No.", "Source Ref. No.");
                        PAGE.RunModal(0, ProdOrderComp);
                    end;
                DATABASE::"Planning Component":
                    begin
                        PlanningComponent.Reset();
                        PlanningComponent.SetRange("Worksheet Template Name", "Source ID");
                        PlanningComponent.SetRange("Worksheet Batch Name", "Source Batch Name");
                        PlanningComponent.SetRange("Worksheet Line No.", "Source Prod. Order Line");
                        PlanningComponent.SetRange("Line No.", "Source Ref. No.");
                        PAGE.RunModal(0, PlanningComponent);
                    end;
                DATABASE::"Transfer Line":
                    begin
                        TransLine.Reset();
                        TransLine.SetRange("Document No.", "Source ID");
                        TransLine.SetRange("Line No.", "Source Ref. No.");
                        TransLine.SetRange("Derived From Line No.", "Source Prod. Order Line");
                        PAGE.RunModal(0, TransLine);
                    end;
                DATABASE::"Service Line":
                    begin
                        ServiceInvLine.SetRange("Document Type", "Source Subtype");
                        ServiceInvLine.SetRange("Document No.", "Source ID");
                        ServiceInvLine.SetRange("Line No.", "Source Ref. No.");
                        PAGE.RunModal(0, ServiceInvLine);
                    end;
                DATABASE::"Assembly Line":

                    if AssembletoOrderLink.Get("Source Subtype", "Source ID") then begin
                        KitSalesLine.Reset();
                        KitSalesLine.SetRange("Document Type", AssembletoOrderLink."Document Type");
                        KitSalesLine.SetRange("Document No.", "Source ID");
                        KitSalesLine.SetRange("Line No.", "Source Ref. No.");
                        PAGE.RunModal(0, KitSalesLine);

                    end;

            end;

    end;

    local procedure QuantityBaseOnAfterValidate()
    begin
        CurrPage.Update();
    end;
}

