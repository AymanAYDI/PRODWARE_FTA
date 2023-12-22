page 50009 "Reservation Entries FTA"
{
    Caption = 'Reservation Entries';
    //DataCaptionExpression = TextCaption;//TODO
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Reservation Entry";

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
                        ReservEngineMgt.ModifyReservEntry(xRec, Rec."Quantity (Base)", Rec.Description, FALSE);
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
        ReservEngineMgt.ModifyReservEntry(xRec, Rec."Quantity (Base)", Rec.Description, TRUE);
        EXIT(FALSE);
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
        ReservEntry: Record "Reservation Entry";
        KitSalesLine: Record "Assembly Line";
        AssembletoOrderLink: Record "Assemble-to-Order Link";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";


    procedure LookupReservedFor()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.GET(Rec."Entry No.", FALSE);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReservedFrom()
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.GET(Rec."Entry No.", TRUE);
        LookupReserved(ReservEntry);
    end;


    procedure LookupReserved(ReservEntry: Record "Reservation Entry")
    begin
        WITH ReservEntry DO
            CASE "Source Type" OF
                DATABASE::"Sales Line":
                    BEGIN
                        SalesLine.RESET();
                        SalesLine.SETRANGE("Document Type", "Source Subtype");
                        SalesLine.SETRANGE("Document No.", "Source ID");
                        SalesLine.SETRANGE("Line No.", "Source Ref. No.");
                        PAGE.RUNMODAL(PAGE::"Sales Lines", SalesLine);
                    END;
                DATABASE::"Requisition Line":
                    BEGIN
                        ReqLine.RESET();
                        ReqLine.SETRANGE("Worksheet Template Name", "Source ID");
                        ReqLine.SETRANGE("Journal Batch Name", "Source Batch Name");
                        ReqLine.SETRANGE("Line No.", "Source Ref. No.");
                        PAGE.RUNMODAL(PAGE::"Requisition Lines", ReqLine);
                    END;
                DATABASE::"Purchase Line":
                    BEGIN
                        PurchLine.RESET();
                        PurchLine.SETRANGE("Document Type", "Source Subtype");
                        PurchLine.SETRANGE("Document No.", "Source ID");
                        PurchLine.SETRANGE("Line No.", "Source Ref. No.");
                        PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                    END;
                DATABASE::"Item Journal Line":
                    BEGIN
                        ItemJnlLine.RESET();
                        ItemJnlLine.SETRANGE("Journal Template Name", "Source ID");
                        ItemJnlLine.SETRANGE("Journal Batch Name", "Source Batch Name");
                        ItemJnlLine.SETRANGE("Line No.", "Source Ref. No.");
                        ItemJnlLine.SETRANGE("Entry Type", "Source Subtype");
                        PAGE.RUNMODAL(PAGE::"Item Journal Lines", ItemJnlLine);
                    END;
                //>>MIG NAV 2015 : Not Supported
                /*
                DATABASE::"BOM Journal Line":
                  BEGIN
                    BOMJnlLine.RESET;
                    BOMJnlLine.SETRANGE("Journal Template Name","Source ID");
                    BOMJnlLine.SETRANGE("Journal Batch Name","Source Batch Name");
                    BOMJnlLine.SETRANGE("Line No.","Source Ref. No.");
                    PAGE.RUNMODAL(PAGE::"BOM Journal Lines",BOMJnlLine);
                  END;
                */
                //<<MIG NAV 2015 : Not Supported
                DATABASE::"Item Ledger Entry":
                    BEGIN
                        ItemLedgEntry.RESET();
                        ItemLedgEntry.SETRANGE("Entry No.", "Source Ref. No.");
                        PAGE.RUNMODAL(0, ItemLedgEntry);
                    END;
                DATABASE::"Prod. Order Line":
                    BEGIN
                        ProdOrderLine.RESET();
                        ProdOrderLine.SETRANGE(Status, "Source Subtype");
                        ProdOrderLine.SETRANGE("Prod. Order No.", "Source ID");
                        ProdOrderLine.SETRANGE("Line No.", "Source Prod. Order Line");
                        PAGE.RUNMODAL(0, ProdOrderLine);
                    END;
                DATABASE::"Prod. Order Component":
                    BEGIN
                        ProdOrderComp.RESET();
                        ProdOrderComp.SETRANGE(Status, "Source Subtype");
                        ProdOrderComp.SETRANGE("Prod. Order No.", "Source ID");
                        ProdOrderComp.SETRANGE("Prod. Order Line No.", "Source Prod. Order Line");
                        ProdOrderComp.SETRANGE("Line No.", "Source Ref. No.");
                        PAGE.RUNMODAL(0, ProdOrderComp);
                    END;
                DATABASE::"Planning Component":
                    BEGIN
                        PlanningComponent.RESET();
                        PlanningComponent.SETRANGE("Worksheet Template Name", "Source ID");
                        PlanningComponent.SETRANGE("Worksheet Batch Name", "Source Batch Name");
                        PlanningComponent.SETRANGE("Worksheet Line No.", "Source Prod. Order Line");
                        PlanningComponent.SETRANGE("Line No.", "Source Ref. No.");
                        PAGE.RUNMODAL(0, PlanningComponent);
                    END;
                DATABASE::"Transfer Line":
                    BEGIN
                        TransLine.RESET();
                        TransLine.SETRANGE("Document No.", "Source ID");
                        TransLine.SETRANGE("Line No.", "Source Ref. No.");
                        TransLine.SETRANGE("Derived From Line No.", "Source Prod. Order Line");
                        PAGE.RUNMODAL(0, TransLine);
                    END;
                DATABASE::"Service Line":
                    BEGIN
                        ServiceInvLine.SETRANGE("Document Type", "Source Subtype");
                        ServiceInvLine.SETRANGE("Document No.", "Source ID");
                        ServiceInvLine.SETRANGE("Line No.", "Source Ref. No.");
                        PAGE.RUNMODAL(0, ServiceInvLine);
                    END;
                DATABASE::"Assembly Line":

                    IF AssembletoOrderLink.GET("Source Subtype", "Source ID") THEN BEGIN
                        KitSalesLine.RESET();
                        KitSalesLine.SETRANGE("Document Type", AssembletoOrderLink."Document Type");
                        KitSalesLine.SETRANGE("Document No.", "Source ID");
                        KitSalesLine.SETRANGE("Line No.", "Source Ref. No.");
                        PAGE.RUNMODAL(0, KitSalesLine);

                    END;

            END;

    end;

    local procedure QuantityBaseOnAfterValidate()
    begin
        CurrPage.UPDATE();
    end;
}

