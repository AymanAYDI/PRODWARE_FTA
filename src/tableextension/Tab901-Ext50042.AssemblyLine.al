namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Sales.Document;
using Microsoft.Inventory.BOM;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;

tableextension 50042 AssemblyLine extends "Assembly Line" //901
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Kit Build up or remove into pieces
    //                            - Add field Kit BOM No.,Component Line No.,Action,x Quantity per,Avaibility,x Quantity per (Base)
    //                            - Add code in InitCompLine() function
    //                            //- Change PK from Document Type,Document No.,Document Line No.,Line No.
    //                            //            to   Document Type,Document No.,Document Line No.,Line No.,Component Line No.
    //                            - Add field 50000 Kit
    //                            - code in OnInsert
    //                            - Add Key Vendor No.,No.,Location Code
    //                            - Add field Requested Receipt Date
    //                            - Add field "Preparation Type"
    //                            - Add field "Inventory value zero"
    //                            - Add field "x Outstanding Quantity"
    //                            - Add field "x Outstanding Qty. (Base)"
    // 
    // //>>MODIF HL
    // TI040889.001 DO.ALMI 18/05/2011  : Add new key Type,No.
    // 
    // //>>MODIF HL
    // TI302489 DO.GEPO 15/12/2015 : create new function FctSelectRecForOrder2
    // 
    // //>>FTA1.02 New function
    // 
    // //>>NDBI
    // LALE.PA 05/10/2021 cf REQ-07040-V7Y7J4 - REQ-09111-R5M4G6
    //         Add C/AL Global BooGResaAssFTA
    //         Add Function FctSetBooResaAssFTA
    //         Add C/AL Code in triggers FctAutoReserveFTA
    //                                   ShowReservation
    // 
    // ------------------------------------------------------------------------

    Caption = 'Assembly Line';
    DrillDownPageID = "Assembly Lines";
    LookupPageID = "Assembly Lines";

    fields
    {
        // field(11; "No."; Code[20])
        // {
        //     Caption = 'No.';
        //     TableRelation = IF (Type = CONST(Item)) Item WHERE(Type = CONST(Inventory))
        //     ELSE
        //     IF (Type = CONST(Resource)) Resource;

        //     trigger OnValidate()
        //     begin
        //         TESTFIELD("Consumed Quantity", 0);
        //         CALCFIELDS("Reserved Quantity");
        //         WhseValidateSourceLine.AssemblyLineVerifyChange(Rec, xRec);
        //         IF "No." <> '' THEN
        //             CheckItemAvailable(FIELDNO("No."));
        //         VerifyReservationChange(Rec, xRec);
        //         TestStatusOpen();

        //         IF "No." <> xRec."No." THEN BEGIN
        //             "Variant Code" := '';
        //             "Originally Ordered No." := '';
        //             "Originally Ordered Var. Code" := '';
        //             InitResourceUsageType();
        //         END;

        //         IF "No." = '' THEN
        //             INIT()
        //         ELSE BEGIN
        //             GetHeader();
        //             "Due Date" := AssemblyHeader."Starting Date";
        //             CASE Type OF
        //                 Type::Item:
        //                     BEGIN
        //                         "Location Code" := AssemblyHeader."Location Code";
        //                         GetItemResource();
        //                         Item.TESTFIELD("Inventory Posting Group");
        //                         "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        //                         "Inventory Posting Group" := Item."Inventory Posting Group";
        //                         GetDefaultBin();
        //                         Description := Item.Description;
        //                         "Description 2" := Item."Description 2";
        //                         "Unit Cost" := GetUnitCost();
        //                         VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");
        //                         CreateDim(DATABASE::Item, "No.", AssemblyHeader."Dimension Set ID");
        //                         Reserve := Item.Reserve;
        //                         VALIDATE(Quantity);
        //                         VALIDATE("Quantity to Consume",
        //                           MinValue(MaxQtyToConsume(), CalcQuantity("Quantity per", AssemblyHeader."Quantity to Assemble")));
        //                     END;
        //                 Type::Resource:
        //                     BEGIN
        //                         GetItemResource();
        //                         Resource.TESTFIELD("Gen. Prod. Posting Group");
        //                         "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        //                         "Inventory Posting Group" := '';
        //                         Description := Resource.Name;
        //                         "Description 2" := Resource."Name 2";
        //                         "Unit Cost" := GetUnitCost();
        //                         VALIDATE("Unit of Measure Code", Resource."Base Unit of Measure");
        //                         CreateDim(DATABASE::Resource, "No.", AssemblyHeader."Dimension Set ID");
        //                         VALIDATE(Quantity);
        //                         VALIDATE("Quantity to Consume",
        //                           MinValue(MaxQtyToConsume(), CalcQuantity("Quantity per", AssemblyHeader."Quantity to Assemble")));
        //                     END;
        //             END
        //         END;


        //         //>>FED_20090415:PA 15/04/2009
        //         IF Type = Type::Item THEN
        //             RecLItem.SETFILTER("Location Filter", "Location Code");
        //         IF RecLItem.GET("No.") THEN BEGIN
        //             "Vendor No." := RecLItem."Vendor No.";
        //             //RecLItem.SETRANGE("Date Filter","Shipment Date");


        //             //>>FED_20090415:PA 15/04/2009
        //             /*RecLItem.CALCFIELDS(Inventory,"Reserved Qty. on Inventory");
        //             "Avaibility no reserved" := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";          */
        //             RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
        //             DecGQtyKit := 0;
        //             RecGKitSalesLine.SETRANGE("Document Type", RecGKitSalesLine."Document Type"::Order);
        //             RecGKitSalesLine.SETRANGE(Type, RecGKitSalesLine.Type::Item);
        //             RecGKitSalesLine.SETRANGE("No.", "No.");
        //             RecGKitSalesLine.SETFILTER("Remaining Quantity (Base)", '<>0');


        //             IF NOT RecGKitSalesLine.ISEMPTY THEN BEGIN
        //                 RecGKitSalesLine.FINDSET();
        //                 REPEAT

        //                     //>>MIG NAV 2015 : Upgrade Old Code
        //                     IF RecGAssemLink.GET(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.") THEN
        //                         //<<MIG NAV 2015 : Upgrade Old Code

        //                         //>>MIG NAV 2015 : Upgrade Old Code
        //                         //OLD IF (RecGKitSalesLine."Document No." <> xKitSalesLine."Document No.") OR
        //                         //OLD      (RecGKitSalesLine."Line No." <> xKitSalesLine."Document Line No.") THEN
        //                         IF (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") OR (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") THEN
        //                             //<<MIG NAV 2015 : Upgrade Old Code
        //                             DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
        //                 UNTIL RecGKitSalesLine.NEXT() = 0;
        //             END;

        //             "Avaibility no reserved" := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + DecGQtyKit)
        //                                         + RecLItem."Reserved Qty. on Purch. Orders";
        //             //<<FED_20090415:PA 15/04/2009

        //             //>>MIG NAV 2015 : Upgrade Old Code
        //             //OLD IF RecLItem."Kit BOM No." = '' THEN
        //             RecLItem.CALCFIELDS("Assembly BOM");
        //             IF RecLItem."Assembly BOM" THEN
        //                 "Kit Qty Available by Assembly" := 0
        //             ELSE BEGIN
        //                 "Kit Qty Available by Assembly" := 0;
        //                 BoolFirstRead := FALSE;
        //                 RecLProductionBOMLine.RESET();
        //                 RecLProductionBOMLine.SETRANGE("Parent Item No.", RecLItem."No.");
        //                 IF RecLProductionBOMLine.FINDSET() THEN
        //                     REPEAT
        //                         IF (RecLProductionBOMLine.Type = RecLProductionBOMLine.Type::Item) THEN
        //                             IF RecLItem.GET(RecLProductionBOMLine."No.") THEN BEGIN
        //                                 //PAMO RecLItem.SETRANGE("Date Filter","Shipment Date");
        //                                 RecLItem.SETFILTER("Location Filter", "Location Code");
        //                                 //>>FED_20090415:PA 15/04/2009
        //                                 /*RecLItem.CALCFIELDS(Inventory,"Reserved Qty. on Inventory");
        //                                 DecLAvailibityNoReserved := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";      */
        //                                 RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
        //                                 DecGQtyKit := 0;
        //                                 RecGKitSalesLine.SETRANGE("Document Type", RecGKitSalesLine."Document Type"::Order);
        //                                 RecGKitSalesLine.SETRANGE(Type, RecGKitSalesLine.Type::Item);
        //                                 RecGKitSalesLine.SETRANGE("No.", "No.");
        //                                 RecGKitSalesLine.SETFILTER(RecGKitSalesLine."Remaining Quantity (Base)", '<>0');

        //                                 //>>MIG NAV 2015 : Upgrade Old Code
        //                                 RecGAssemLink.GET(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.");
        //                                 //<<MIG NAV 2015 : Upgrade Old Code

        //                                 IF NOT RecGKitSalesLine.ISEMPTY THEN BEGIN
        //                                     RecGKitSalesLine.FINDSET();
        //                                     REPEAT
        //                                         //>>MIG NAV 2015 : Upgrade Old Code
        //                                         //OLD IF (RecGKitSalesLine."Document No." <> xKitSalesLine."Document No.") OR
        //                                         //OLD      (RecGKitSalesLine."Line No." <> xKitSalesLine."Document Line No.") THEN
        //                                         IF (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") OR (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") THEN
        //                                             //<<MIG NAV 2015 : Upgrade Old Code
        //                                             DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
        //                                     UNTIL RecGKitSalesLine.NEXT() = 0;
        //                                 END;

        //                                 DecLAvailibityNoReserved := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + DecGQtyKit) +
        //                                                             RecLItem."Reserved Qty. on Purch. Orders";
        //                                 //<<FED_20090415:PA 15/04/2009

        //                                 IF NOT BoolFirstRead THEN
        //                                     "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<')
        //                                 ELSE
        //                                     IF ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<') < "Kit Qty Available by Assembly" THEN
        //                                         "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<');
        //                                 BoolFirstRead := TRUE;
        //                             END;
        //                     UNTIL RecLProductionBOMLine.NEXT() = 0;
        //             END;
        //         END;
        //         //<<FED_20090415:PA 15/04/2009

        //     end;
        // }
        field(50000; "Kit BOM No."; Code[20])
        {
            Caption = 'Kit BOM No.';
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50001; "Level No."; Integer)
        {
            Caption = 'Level No.';
            Description = 'FTA1.00';
        }
        field(50002; "Kit Action"; Option)
        {
            Caption = 'Kit Action';
            Description = 'FTA1.00';
            OptionCaption = ' ,Assembly,Disassembly';
            OptionMembers = " ",Assembly,Disassembly;

            trigger OnValidate()
            var
                CstL001: Label '%1 impossible';
            begin
                CASE "Kit Action" OF
                    "Kit Action"::Assembly:
                        BEGIN
                            IF "Quantity per" <> 0 THEN
                                ERROR(CstL001, FORMAT("Kit Action"));
                        END;
                    "Kit Action"::Disassembly:
                        BEGIN
                            IF "x Quantity per" <> 0 THEN
                                ERROR(CstL001, FORMAT("Kit Action"));
                        END;
                END;
            end;
        }
        field(50003; "x Quantity per"; Decimal)
        {
            Caption = 'Origin Quantity per';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';
            Editable = false;
            MinValue = 0;
        }
        field(50004; "Avaibility no reserved"; Decimal)
        {
            Caption = 'Avaibility';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50005; "x Quantity per (Base)"; Decimal)
        {
            Caption = 'Origin Quantity per (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';
            Editable = false;
            MinValue = 0;
        }
        field(50006; "Kit Qty Available by Assembly"; Decimal)
        {
            Caption = 'Kit Qty Available by Assembly';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50007; "x Extended Quantity"; Decimal)
        {
            Caption = 'x Extended Quantity';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50008; "x Extended Quantity (Base)"; Decimal)
        {
            Caption = 'x Extended Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50009; Kit; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("BOM Component" WHERE("Parent Item No." = FIELD("No.")));
            Caption = 'Kit';
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50010; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = Lookup("Sales Line"."Sell-to Customer No." WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("Document No.")));
            Caption = 'Sell-to Customer No.';
            Description = 'FTA1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Sell-to Customer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            Description = 'FTA1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Selected for Order"; Boolean)
        {
            Caption = 'Selected for Order';
            Description = 'FTA1.00';

            trigger OnValidate()
            begin
                IF "Selected for Order" AND ("Qty to be Ordered" = 0) THEN BEGIN
                    CALCFIELDS("Reserved Quantity");
                    "Qty to be Ordered" := "Remaining Quantity" - "Reserved Quantity";
                END;
                IF NOT "Selected for Order" THEN
                    "Qty to be Ordered" := 0;
            end;
        }
        field(50013; "Qty to be Ordered"; Decimal)
        {
            Caption = 'Qty to be Ordered';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';

            trigger OnValidate()
            var
                CstL001: Label 'The quantity to be ordered %1 is greater to the need %2';
            begin
                IF ("Qty to be Ordered" <> 0) THEN BEGIN
                    CALCFIELDS("Reserved Quantity");
                    IF "Qty to be Ordered" > "Remaining Quantity" - "Reserved Quantity" THEN;
                    //ERROR(CstL001,"Qty to be Ordered","Outstanding Quantity" - "Reserved Quantity");
                END;
            end;
        }
        field(50014; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Description = 'FTA1.00';
            TableRelation = Vendor;
        }
        field(50016; "Requested Delivery Date"; Date)
        {
            CalcFormula = Lookup("Sales Line"."Requested Delivery Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                               "Document No." = FIELD("Document No.")));
            Caption = 'Requested Delivery Date';
            Description = 'FTA1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "Promised Delivery Date"; Date)
        {
            CalcFormula = Lookup("Sales Line"."Promised Delivery Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                              "Document No." = FIELD("Document No.")));
            Caption = 'Promised Delivery Date';
            Description = 'FTA1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50020; "Qty Not Assign FTA"; Decimal)
        {
            Caption = 'Qty. to Assign FTA';
            DecimalPlaces = 0 : 5;
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50023; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
            Description = 'FTA1.00';
        }
        field(50024; "Inventory Value Zero"; Boolean)
        {
            CalcFormula = Lookup(Item."Inventory Value Zero" WHERE("No." = FIELD("No.")));
            Caption = 'enu=Inventory Value Zero;fra=Exclure évaluation stock';
            Description = 'FTA1.00';
            FieldClass = FlowField;
        }
        field(50030; "Item No. 2"; Code[20])
        {
            CalcFormula = Lookup(Item."No. 2" WHERE("No." = FIELD("No.")));
            Caption = 'Item No. 2';
            Description = 'FTA1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50031; "Internal field"; Boolean)
        {
            Caption = 'Internal field';
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50032; "Preparation Type"; Option)
        {
            CalcFormula = Lookup("Sales Line"."Preparation Type" WHERE("Document Type" = FIELD("Document Type"),
                                                                        "Document No." = FIELD("Document No.")));
            Caption = 'Preparation Type';
            Description = 'FTA1.00';
            FieldClass = FlowField;
            OptionCaption = ' ,Stock,Assembly,Purchase,Remaider';
            OptionMembers = " ",Stock,Assembly,Purchase,Remainder;
        }
        field(50033; "x Outstanding Quantity"; Decimal)
        {
            Caption = 'x Outstanding Quantity';
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50034; "x Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'x Outstanding Qty. (Base)';
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50043; "Originally Ordered No."; Code[20])
        {
            AccessByPermission = TableData "Item Substitution" = R;
            Caption = 'Originally Ordered No.';
            Description = 'FTA1.02';
            TableRelation = IF (Type = CONST(Item)) Item;
        }
        field(50044; "Originally Ordered Var. Code"; Code[10])
        {
            AccessByPermission = TableData "Item Substitution" = R;
            Caption = 'Originally Ordered Var. Code';
            Description = 'FTA1.02';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("Originally Ordered No."));
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.", Type, "Location Code")
        {
            SumIndexFields = "Cost Amount", Quantity;
        }
        key(Key3; "Document Type", Type, "No.", "Variant Code", "Location Code", "Due Date")
        {
            SumIndexFields = "Remaining Quantity (Base)", "Qty. Picked (Base)", "Consumed Quantity (Base)";
        }
        key(Key4; Type, "No.")
        {
            SumIndexFields = "x Outstanding Quantity";
        }
        key(Key5; "Vendor No.", "No.", "Location Code")
        {
        }
        key(Key6; "Remaining Quantity")
        {
        }
        key(Key7; "Document Type", "Document No.", Type, "Quantity per")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        WhseAssemblyRelease: Codeunit "904";
        AssemblyLineReserve: Codeunit "926";
    begin
        TestStatusOpen();
        WhseValidateSourceLine.AssemblyLineDelete(Rec);
        WhseAssemblyRelease.DeleteLine(Rec);
        AssemblyLineReserve.DeleteLine(Rec);
        CALCFIELDS("Reserved Qty. (Base)");
        TESTFIELD("Reserved Qty. (Base)", 0);
    end;

    trigger OnInsert()
    begin
        TestStatusOpen();
        VerifyReservationQuantity(Rec, xRec);
    end;

    trigger OnModify()
    begin
        WhseValidateSourceLine.AssemblyLineVerifyChange(Rec, xRec);
        VerifyReservationChange(Rec, xRec);
        //>>FED_20090415:PA 15/04/2009
        IntGNumber := FIELDNO("Internal field");
        IF (IntGNumber <> 50031) AND
           (IntGNumber <> 50013) AND
           (IntGNumber <> 50014) THEN BEGIN
            //<<FED_20090415:PA 15/04/2009
            //>>FED_20090415:PA 15/04/2009
        END;
    end;

    trigger OnRename()
    begin
        ERROR(Text002, TABLECAPTION);
    end;

    var
        Item: Record "27";
        Resource: Record "156";
        Text001: Label 'Automatic reservation is not possible.\Do you want to reserve items manually?';
        Text002: Label 'You cannot rename an %1.';
        Text003: Label '%1 cannot be higher than the %2, which is %3.';
        Text029: Label 'must be positive', Comment = 'starts with "Quantity"';
        Text042: Label 'When posting the Applied to Ledger Entry, %1 will be opened first.';
        Text99000002: Label 'You cannot change %1 when %2 is ''%3''.';
        AssemblyHeader: Record "900";
        StockkeepingUnit: Record "5700";
        GLSetup: Record "98";
        ItemSubstMgt: Codeunit "5701";
        WhseValidateSourceLine: Codeunit "5777";
        AssemblyLineReserve: Codeunit "926";
        GLSetupRead: Boolean;
        StatusCheckSuspended: Boolean;
        TestReservationDateConflict: Boolean;
        SkipVerificationsThatChangeDatabase: Boolean;
        Text049: Label '%1 cannot be later than %2 because the %3 is set to %4.';
        Text050: Label 'Due Date %1 is before work date %2.';
        "**FTA1.00": Integer;
        IntGNumber: Integer;
        "--FTA": Integer;
        RecLItem: Record "27";
        RecLProductionBOMLine: Record "90";
        BoolFirstRead: Boolean;
        DecLAvailibityNoReserved: Decimal;
        DecGQtyKit: Decimal;
        RecGKitSalesLine: Record "901";
        RecGAssemLink: Record "904";
        "---- NDBI ----": Integer;
        BooGResaAssFTA: Boolean;


    procedure Refresh(NewQuantity: Decimal)
    begin
        VALIDATE(Quantity, NewQuantity);
    end;


    procedure FindLine(OrderType: Option Quote,"Assembly Order",,,"Blanket Order"; OrderNo: Code[20]; LineType: Option " ",Item,Resource; Number: Code[20]): Boolean
    begin
        SETRANGE("Document Type", OrderType);
        SETRANGE("Document No.", OrderNo);
        SETRANGE(Type, LineType);
        SETRANGE("No.", Number);
        EXIT(FINDFIRST());
    end;


    procedure InitRemainingQty()
    begin
        "Remaining Quantity" := MaxValue(Quantity - "Consumed Quantity", 0);
        "Remaining Quantity (Base)" := MaxValue("Quantity (Base)" - "Consumed Quantity (Base)", 0);
    end;


    procedure InitQtyToConsume()
    begin
        GetHeader();
        "Quantity to Consume" :=
          MinValue(MaxQtyToConsume(), CalcQuantity("Quantity per", AssemblyHeader."Quantity to Assemble"));
        "Quantity to Consume (Base)" :=
          MinValue(
            MaxQtyToConsumeBase(),
            CalcBaseQty(CalcQuantity("Quantity per", AssemblyHeader."Quantity to Assemble (Base)")));
    end;


    procedure MaxQtyToConsume(): Decimal
    begin
        EXIT("Remaining Quantity");
    end;


    procedure MaxQtyToConsumeBase(): Decimal
    begin
        EXIT("Remaining Quantity (Base)");
    end;


    procedure GetCurrencyCode(): Code[10]
    begin
        GetGLSetup();
        EXIT(GLSetup."Additional Reporting Currency");
    end;

    local procedure GetSKU(): Boolean
    begin
        IF Type = Type::Item THEN
            IF (StockkeepingUnit."Location Code" = "Location Code") AND
               (StockkeepingUnit."Item No." = "No.") AND
               (StockkeepingUnit."Variant Code" = "Variant Code")
            THEN
                EXIT(TRUE);
        IF StockkeepingUnit.GET("Location Code", "No.", "Variant Code") THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure GetUnitCost(): Decimal
    var
        UnitCost: Decimal;
    begin
        GetItemResource();

        CASE Type OF
            Type::Item:
                IF GetSKU() THEN
                    UnitCost := StockkeepingUnit."Unit Cost" * "Qty. per Unit of Measure"
                ELSE
                    UnitCost := Item."Unit Cost" * "Qty. per Unit of Measure";
            Type::Resource:
                UnitCost := Resource."Unit Cost" * "Qty. per Unit of Measure";
        END;

        EXIT(RoundUnitAmount(UnitCost));
    end;

    local procedure CalcCostAmount(Qty: Decimal; UnitCost: Decimal): Decimal
    begin
        EXIT(ROUND(Qty * UnitCost));
    end;

    local procedure RoundUnitAmount(UnitAmount: Decimal): Decimal
    begin
        GetGLSetup();

        EXIT(ROUND(UnitAmount, GLSetup."Unit-Amount Rounding Precision"));
    end;


    procedure ShowReservation()
    var
        Reservation: Page Reservation;
    begin
        IF Type = Type::Item THEN BEGIN
            TESTFIELD("No.");
            TESTFIELD(Reserve);
            CLEAR(Reservation);
            //>>NDBI
            IF BooGResaAssFTA THEN
                Reservation.FctSetBooResaASSFTA(true);
            //<<NDBI

            Reservation.SetAssemblyLine(Rec);
            Reservation.RUNMODAL();
        END;
    end;


    procedure ShowReservationEntries(Modal: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        IF Type = Type::Item THEN BEGIN
            TESTFIELD("No.");
            ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, TRUE);
            AssemblyLineReserve.FilterReservFor(ReservEntry, Rec);
            IF Modal THEN
                PAGE.RUNMODAL(PAGE::"Reservation Entries", ReservEntry)
            ELSE
                PAGE.RUN(PAGE::"Reservation Entries", ReservEntry);
        END;
    end;


    procedure UpdateAvailWarning(): Boolean
    var
        ItemCheckAvail: Codeunit "311";
    begin
        "Avail. Warning" := FALSE;
        IF Type = Type::Item THEN
            "Avail. Warning" := ItemCheckAvail.AsmOrderLineShowWarning(Rec);
        EXIT("Avail. Warning");
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    var
        AssemblySetup: Record "905";
        ItemCheckAvail: Codeunit "311";
    begin
        IF NOT UpdateAvailWarning() THEN
            EXIT;

        IF "Document Type" <> "Document Type"::Order THEN
            EXIT;

        AssemblySetup.GET();
        IF NOT AssemblySetup."Stockout Warning" THEN
            EXIT;

        IF Reserve = Reserve::Always THEN
            EXIT;

        IF (CalledByFieldNo = CurrFieldNo) OR
           ((CalledByFieldNo = FIELDNO("No.")) AND (CurrFieldNo <> 0)) OR
           ((CalledByFieldNo = FIELDNO(Quantity)) AND (CurrFieldNo = FIELDNO("Quantity per")))
        THEN
            IF ItemCheckAvail.AssemblyLineCheck(Rec) THEN
                ItemCheckAvail.RaiseUpdateInterruptedError();
    end;


    procedure ShowAvailabilityWarning()
    var
        ItemCheckAvail: Codeunit "311";
    begin
        TESTFIELD(Type, Type::Item);

        IF "Due Date" = 0D THEN BEGIN
            GetHeader();
            IF AssemblyHeader."Due Date" <> 0D THEN
                VALIDATE("Due Date", AssemblyHeader."Due Date")
            ELSE
                VALIDATE("Due Date", WORKDATE());
        END;

        ItemCheckAvail.AssemblyLineCheck(Rec);
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    var
        UOMMgt: Codeunit "5402";
    begin
        EXIT(UOMMgt.CalcBaseQty(Qty, "Qty. per Unit of Measure"));
    end;

    local procedure CalcQtyFromBase(QtyBase: Decimal): Decimal
    var
        UOMMgt: Codeunit "5402";
    begin
        EXIT(UOMMgt.CalcQtyFromBase(QtyBase, "Qty. per Unit of Measure"));
    end;


    procedure IsInbound(): Boolean
    begin
        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Quote, "Document Type"::"Blanket Order"] THEN
            EXIT("Quantity (Base)" < 0);

        EXIT(FALSE);
    end;


    procedure OpenItemTrackingLines()
    var
        AssemblyLineReserve: Codeunit "926";
    begin
        TESTFIELD(Type, Type::Item);
        TESTFIELD("No.");
        TESTFIELD("Quantity (Base)");
        AssemblyLineReserve.CallItemTracking(Rec);
    end;

    local procedure GetItemResource()
    begin
        IF Type = Type::Item THEN
            IF Item."No." <> "No." THEN
                Item.GET("No.");
        IF Type = Type::Resource THEN
            IF Resource."No." <> "No." THEN
                Resource.GET("No.");
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET();
            GLSetupRead := TRUE
        END
    end;

    local procedure GetLocation(var Location: Record "14"; LocationCode: Code[10])
    begin
        IF LocationCode = '' THEN
            CLEAR(Location)
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    end;


    procedure AutoReserve()
    var
        ReservMgt: Codeunit "99000845";
        FullAutoReservation: Boolean;
    begin
        IF Type <> Type::Item THEN
            EXIT;

        TESTFIELD("No.");
        IF Reserve <> Reserve::Always THEN
            EXIT;

        IF "Remaining Quantity (Base)" <> 0 THEN BEGIN
            TESTFIELD("Due Date");
            ReservMgt.SetAssemblyLine(Rec);
            ReservMgt.AutoReserve(FullAutoReservation, '', "Due Date", "Remaining Quantity", "Remaining Quantity (Base)");
            FIND();
            IF NOT FullAutoReservation AND (CurrFieldNo <> 0) THEN
                IF CONFIRM(Text001, TRUE) THEN BEGIN
                    COMMIT();
                    ShowReservation();
                    FIND();
                END;
        END;
    end;


    procedure ReservationStatus(): Integer
    var
        Status: Option " ",Partial,Complete;
    begin
        IF (Reserve = Reserve::Never) OR ("Remaining Quantity" = 0) THEN
            EXIT(Status::" ");

        CALCFIELDS("Reserved Quantity");
        IF "Reserved Quantity" = 0 THEN BEGIN
            IF Reserve = Reserve::Always THEN
                EXIT(Status::Partial);
            EXIT(Status::" ");
        END;

        IF "Reserved Quantity" < "Remaining Quantity" THEN
            EXIT(Status::Partial);

        EXIT(Status::Complete);
    end;


    procedure SetTestReservationDateConflict(NewTestReservationDateConflict: Boolean)
    begin
        TestReservationDateConflict := NewTestReservationDateConflict;
    end;


    procedure GetHeader()
    begin
        IF (AssemblyHeader."No." <> "Document No.") AND ("Document No." <> '') THEN
            AssemblyHeader.GET("Document Type", "Document No.");
    end;


    procedure ShowDimensions()
    var
        DimMgt: Codeunit "408";
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Document Type", "Document No.", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; HeaderDimensionSetID: Integer)
    var
        SourceCodeSetup: Record "242";
        AssemblySetup: Record "905";
        DimMgt: Codeunit "408";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        DimensionSetIDArr: array[10] of Integer;
    begin
        IF SkipVerificationsThatChangeDatabase THEN
            EXIT;
        SourceCodeSetup.GET();

        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        AssemblySetup.GET();
        CASE AssemblySetup."Copy Component Dimensions from" OF
            AssemblySetup."Copy Component Dimensions from"::"Order Header":
                BEGIN
                    DimensionSetIDArr[1] :=
                      DimMgt.GetDefaultDimID(
                        TableID, No, SourceCodeSetup.Assembly,
                        "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                        0, 0);
                    DimensionSetIDArr[2] := HeaderDimensionSetID;
                END;
            AssemblySetup."Copy Component Dimensions from"::"Item/Resource Card":
                BEGIN
                    DimensionSetIDArr[2] :=
                      DimMgt.GetDefaultDimID(
                        TableID, No, SourceCodeSetup.Assembly,
                        "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                        0, 0);
                    DimensionSetIDArr[1] := HeaderDimensionSetID;
                END;
        END;

        "Dimension Set ID" :=
          DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure UpdateDim(NewHeaderSetID: Integer; OldHeaderSetID: Integer)
    var
        DimMgt: Codeunit "408";
    begin
        "Dimension Set ID" := DimMgt.GetDeltaDimSetID("Dimension Set ID", NewHeaderSetID, OldHeaderSetID);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit "408";
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit "408";
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    var
        DimMgt: Codeunit "408";
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure TypeToID(Type: Option " ",Item,Resource): Integer
    begin
        CASE Type OF
            Type::" ":
                EXIT(0);
            Type::Item:
                EXIT(DATABASE::Item);
            Type::Resource:
                EXIT(DATABASE::Resource);
        END;
    end;


    procedure ShowItemSub()
    begin
        ItemSubstMgt.ItemAssemblySubstGet(Rec);
    end;


    procedure ShowAssemblyList()
    var
        BomComponent: Record "90";
    begin
        TESTFIELD(Type, Type::Item);
        BomComponent.SETRANGE("Parent Item No.", "No.");
        PAGE.RUN(PAGE::"Assembly BOM", BomComponent);
    end;


    procedure ExplodeAssemblyList()
    var
        AssemblyLineManagement: Codeunit "905";
    begin
        AssemblyLineManagement.ExplodeAsmList(Rec);
    end;


    procedure CalcQuantityPer(Qty: Decimal): Decimal
    begin
        GetHeader();
        AssemblyHeader.TESTFIELD(Quantity);

        IF FixedUsage() THEN
            EXIT(Qty);

        EXIT(Qty / AssemblyHeader.Quantity);
    end;


    procedure CalcQuantityFromBOM(LineType: Option; QtyPer: Decimal; HeaderQty: Decimal; HeaderQtyPerUOM: Decimal; LineResourceUsageType: Option): Decimal
    begin
        IF FixedUsage2(LineType, LineResourceUsageType) THEN
            EXIT(QtyPer);

        EXIT(QtyPer * HeaderQty * HeaderQtyPerUOM);
    end;


    procedure CalcQuantity(LineQtyPer: Decimal; HeaderQty: Decimal): Decimal
    begin
        EXIT(CalcQuantityFromBOM(Type, LineQtyPer, HeaderQty, 1, "Resource Usage Type"));
    end;


    procedure FilterLinesWithItemToPlan(var Item: Record "27"; DocumentType: Option)
    begin
        RESET();
        SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "Location Code");
        SETRANGE("Document Type", DocumentType);
        SETRANGE(Type, Type::Item);
        SETRANGE("No.", Item."No.");
        SETFILTER("Variant Code", Item.GETFILTER("Variant Filter"));
        SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
        SETFILTER("Due Date", Item.GETFILTER("Date Filter"));
        SETFILTER("Shortcut Dimension 1 Code", Item.GETFILTER("Global Dimension 1 Filter"));
        SETFILTER("Shortcut Dimension 2 Code", Item.GETFILTER("Global Dimension 2 Filter"));
        SETFILTER("Remaining Quantity (Base)", '<>0');
    end;


    procedure FindLinesWithItemToPlan(var Item: Record "27"; DocumentType: Option): Boolean
    begin
        FilterLinesWithItemToPlan(Item, DocumentType);
        EXIT(FIND('-'));
    end;


    procedure LinesWithItemToPlanExist(var Item: Record "27"; DocumentType: Option): Boolean
    begin
        FilterLinesWithItemToPlan(Item, DocumentType);
        EXIT(NOT ISEMPTY);
    end;

    local procedure GetEarliestAvailDate(CompanyInfo: Record "79"; GrossRequirement: Decimal; ExcludeQty: Decimal; ExcludeDate: Date): Date
    var
        AvailableToPromise: Codeunit "5790";
        QtyAvailable: Decimal;
    begin
        GetItemResource();
        SetItemFilter(Item);

        EXIT(
          AvailableToPromise.EarliestAvailabilityDate(
            Item,
            GrossRequirement,
            "Due Date",
            ExcludeQty,
            ExcludeDate,
            QtyAvailable,
            CompanyInfo."Check-Avail. Time Bucket",
            CompanyInfo."Check-Avail. Period Calc."));
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "32";
        AsmLine3: Record "901";
    begin
        ItemLedgEntry.SETRANGE("Item No.", "No.");
        ItemLedgEntry.SETRANGE("Location Code", "Location Code");
        ItemLedgEntry.SETRANGE("Variant Code", "Variant Code");

        IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN BEGIN
            ItemLedgEntry.SETCURRENTKEY("Item No.", Open);
            ItemLedgEntry.SETRANGE(Positive, TRUE);
            ItemLedgEntry.SETRANGE(Open, TRUE);
        END ELSE BEGIN
            ItemLedgEntry.SETCURRENTKEY("Item No.", Positive);
            ItemLedgEntry.SETRANGE(Positive, FALSE);
            ItemLedgEntry.SETFILTER("Shipped Qty. Not Returned", '<0');
        END;
        IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries", ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
            AsmLine3 := Rec;
            IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN
                AsmLine3.VALIDATE("Appl.-to Item Entry", ItemLedgEntry."Entry No.")
            ELSE
                AsmLine3.VALIDATE("Appl.-from Item Entry", ItemLedgEntry."Entry No.");
            Rec := AsmLine3;
        END;
    end;


    procedure SetItemFilter(var Item: Record "27")
    begin
        IF Type = Type::Item THEN BEGIN
            Item.GET("No.");
            IF "Due Date" = 0D THEN
                "Due Date" := WORKDATE();
            Item.SETRANGE("Date Filter", 0D, "Due Date");
            Item.SETRANGE("Location Filter", "Location Code");
            Item.SETRANGE("Variant Filter", "Variant Code");
        END;
    end;

    local procedure CalcAvailQuantities(var Item: Record "27"; var GrossRequirement: Decimal; var ScheduledReceipt: Decimal; var ExpectedInventory: Decimal; var AvailableInventory: Decimal; var EarliestDate: Date)
    var
        OldAssemblyLine: Record "901";
        CompanyInfo: Record "79";
        AvailableToPromise: Codeunit "5790";
        AvailabilityDate: Date;
        ReservedReceipt: Decimal;
        ReservedRequirement: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        LookaheadDateFormula: DateFormula;
    begin
        SetItemFilter(Item);
        AvailableInventory := AvailableToPromise.CalcAvailableInventory(Item);
        //>>APA
        //ScheduledReceipt := AvailableToPromise.CalcScheduledReceipt(Item);
        //<<APA
        ReservedReceipt := AvailableToPromise.CalcReservedReceipt(Item);
        ReservedRequirement := AvailableToPromise.CalcReservedRequirement(Item);
        GrossRequirement := AvailableToPromise.CalcGrossRequirement(Item);

        CompanyInfo.GET();
        LookaheadDateFormula := CompanyInfo."Check-Avail. Period Calc.";
        IF FORMAT(LookaheadDateFormula) <> '' THEN BEGIN
            AvailabilityDate := Item.GETRANGEMAX("Date Filter");
            PeriodType := CompanyInfo."Check-Avail. Time Bucket";

            GrossRequirement :=
              GrossRequirement +
              AvailableToPromise.CalculateLookahead(
                Item, PeriodType,
                AvailabilityDate + 1,
                AvailableToPromise.AdjustedEndingDate(CALCDATE(LookaheadDateFormula, AvailabilityDate), PeriodType));
        END;

        IF OrderLineExists(OldAssemblyLine) THEN
            GrossRequirement := GrossRequirement - OldAssemblyLine."Remaining Quantity (Base)"
        ELSE
            OldAssemblyLine.INIT();

        EarliestDate :=
          GetEarliestAvailDate(
            CompanyInfo, "Remaining Quantity (Base)",
            OldAssemblyLine."Remaining Quantity (Base)", OldAssemblyLine."Due Date");

        ExpectedInventory :=
          CalcExpectedInventory(AvailableInventory, ScheduledReceipt - ReservedReceipt, GrossRequirement - ReservedRequirement);

        AvailableInventory := CalcQtyFromBase(AvailableInventory);
        GrossRequirement := CalcQtyFromBase(GrossRequirement);
        ScheduledReceipt := CalcQtyFromBase(ScheduledReceipt);
        ExpectedInventory := CalcQtyFromBase(ExpectedInventory);
    end;

    local procedure CalcExpectedInventory(Inventory: Decimal; ScheduledReceipt: Decimal; GrossRequirement: Decimal): Decimal
    begin
        EXIT(Inventory + ScheduledReceipt - GrossRequirement);
    end;


    procedure CalcAvailToAssemble(AssemblyHeader: Record "900"; var Item: Record "27"; var GrossRequirement: Decimal; var ScheduledReceipt: Decimal; var ExpectedInventory: Decimal; var AvailableInventory: Decimal; var EarliestDate: Date; var AbleToAssemble: Decimal)
    var
        UOMMgt: Codeunit "5402";
    begin
        TESTFIELD("Quantity per");

        CalcAvailQuantities(
          Item,
          GrossRequirement,
          ScheduledReceipt,
          ExpectedInventory,
          AvailableInventory,
          EarliestDate);

        IF ExpectedInventory < "Remaining Quantity (Base)" THEN BEGIN
            IF ExpectedInventory < 0 THEN
                AbleToAssemble := 0
            ELSE
                AbleToAssemble := ROUND(ExpectedInventory / "Quantity per", UOMMgt.QtyRndPrecision(), '<')
        END ELSE BEGIN
            AbleToAssemble := AssemblyHeader."Remaining Quantity";
            EarliestDate := 0D;
        END;
    end;

    local procedure MaxValue(Value: Decimal; Value2: Decimal): Decimal
    begin
        IF Value < Value2 THEN
            EXIT(Value2);

        EXIT(Value);
    end;

    local procedure MinValue(Value: Decimal; Value2: Decimal): Decimal
    begin
        IF Value < Value2 THEN
            EXIT(Value);

        EXIT(Value2);
    end;

    local procedure RoundQty(var Qty: Decimal)
    var
        UOMMgt: Codeunit "5402";
    begin
        Qty := UOMMgt.RoundQty(Qty);
    end;


    procedure FixedUsage(): Boolean
    begin
        EXIT(FixedUsage2(Type, "Resource Usage Type"));
    end;

    local procedure FixedUsage2(LineType: Option; LineResourceUsageType: Option): Boolean
    begin
        IF (LineType = Type::Resource) AND (LineResourceUsageType = "Resource Usage Type"::Fixed) THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;


    procedure ResourceUsageTypeFromBOM(BOMComponent: Record "90"): Integer
    begin
        IF BOMComponent.Type = BOMComponent.Type::Resource THEN
            CASE BOMComponent."Resource Usage Type" OF
                BOMComponent."Resource Usage Type"::Direct:
                    EXIT("Resource Usage Type"::Direct);
                BOMComponent."Resource Usage Type"::Fixed:
                    EXIT("Resource Usage Type"::Fixed);
            END;

        EXIT("Resource Usage Type"::" ");
    end;

    local procedure InitResourceUsageType()
    begin
        CASE Type OF
            Type::" ", Type::Item:
                "Resource Usage Type" := "Resource Usage Type"::" ";
            Type::Resource:
                "Resource Usage Type" := "Resource Usage Type"::Direct;
        END;
    end;


    procedure SignedXX(Value: Decimal): Decimal
    begin
        CASE "Document Type" OF
            "Document Type"::Quote,
          "Document Type"::Order,
          "Document Type"::"Blanket Order":
                EXIT(-Value);
        END;
    end;


    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "6500";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Assembly Line", "Document Type", "Document No.", '', 0, "Line No."));
    end;

    local procedure CheckBin()
    var
        BinContent: Record "7302";
        Bin: Record "7354";
        Location: Record "14";
    begin
        IF "Bin Code" <> '' THEN BEGIN
            GetLocation(Location, "Location Code");
            IF NOT Location."Directed Put-away and Pick" THEN
                EXIT;

            IF BinContent.GET(
                 "Location Code", "Bin Code",
                 "No.", "Variant Code", "Unit of Measure Code")
            THEN
                BinContent.CheckWhseClass(FALSE)
            ELSE BEGIN
                Bin.GET("Location Code", "Bin Code");
                Bin.CheckWhseClass("No.", FALSE);
            END;
        END;
    end;


    procedure GetDefaultBin()
    begin
        TESTFIELD(Type, Type::Item);
        IF (Quantity * xRec.Quantity > 0) AND
           ("No." = xRec."No.") AND
           ("Location Code" = xRec."Location Code") AND
           ("Variant Code" = xRec."Variant Code")
        THEN
            EXIT;

        VALIDATE("Bin Code", FindBin());
    end;


    procedure FindBin() NewBinCode: Code[20]
    var
        Location: Record "14";
        WMSManagement: Codeunit "7302";
    begin
        IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
            GetLocation(Location, "Location Code");
            NewBinCode := Location."To-Assembly Bin Code";
            IF NewBinCode <> '' THEN
                EXIT;

            IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
                WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", NewBinCode);
        END;
    end;

    local procedure TestStatusOpen()
    begin
        IF StatusCheckSuspended THEN
            EXIT;
        GetHeader();
        IF Type IN [Type::Item, Type::Resource] THEN
            AssemblyHeader.TESTFIELD(Status, AssemblyHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure CompletelyPicked(): Boolean
    var
        Location: Record "14";
    begin
        TESTFIELD(Type, Type::Item);
        GetLocation(Location, "Location Code");
        IF Location."Require Shipment" THEN
            EXIT("Qty. Picked (Base)" - "Consumed Quantity (Base)" >= "Remaining Quantity (Base)");
        EXIT("Qty. Picked (Base)" - "Consumed Quantity (Base)" >= "Quantity to Consume (Base)");
    end;


    procedure CalcQtyToPick(): Decimal
    begin
        CALCFIELDS("Pick Qty.");
        EXIT("Remaining Quantity" - (CalcQtyPickedNotConsumed() + "Pick Qty."));
    end;


    procedure CalcQtyToPickBase(): Decimal
    begin
        CALCFIELDS("Pick Qty. (Base)");
        EXIT("Remaining Quantity (Base)" - (CalcQtyPickedNotConsumedBase() + "Pick Qty. (Base)"));
    end;


    procedure CalcQtyPickedNotConsumed(): Decimal
    begin
        EXIT("Qty. Picked" - "Consumed Quantity");
    end;


    procedure CalcQtyPickedNotConsumedBase(): Decimal
    begin
        EXIT("Qty. Picked (Base)" - "Consumed Quantity (Base)");
    end;


    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record "27";
    begin
        IF Type <> Type::Item THEN
            EXIT(FALSE);

        IF NOT Item2.GET(ItemNo) THEN
            EXIT(FALSE);
        EXIT(TRUE);
    end;


    procedure ShowTracking()
    var
        OrderTracking: Page "99000822";
    begin
        OrderTracking.SetAsmLine(Rec);
        OrderTracking.RUNMODAL();
    end;

    local procedure OrderLineExists(var AssemblyLine: Record "901"): Boolean
    begin
        EXIT(
          ("Document Type" = "Document Type"::Order) AND
          AssemblyLine.GET("Document Type", "Document No.", "Line No.") AND
          (AssemblyLine.Type = Type) AND
          (AssemblyLine."No." = "No.") AND
          (AssemblyLine."Location Code" = "Location Code") AND
          (AssemblyLine."Variant Code" = "Variant Code") AND
          (AssemblyLine."Bin Code" = "Bin Code"));
    end;


    procedure VerifyReservationQuantity(var NewAsmLine: Record "901"; var OldAsmLine: Record "901")
    begin
        IF SkipVerificationsThatChangeDatabase THEN
            EXIT;
        AssemblyLineReserve.VerifyQuantity(NewAsmLine, OldAsmLine);
    end;


    procedure VerifyReservationChange(var NewAsmLine: Record "901"; var OldAsmLine: Record "901")
    begin
        IF SkipVerificationsThatChangeDatabase THEN
            EXIT;
        AssemblyLineReserve.VerifyChange(NewAsmLine, OldAsmLine);
    end;


    procedure VerifyReservationDateConflict(NewAsmLine: Record "901")
    var
        ReservationCheckDateConfl: Codeunit "99000815";
    begin
        IF SkipVerificationsThatChangeDatabase THEN
            EXIT;
        ReservationCheckDateConfl.AssemblyLineCheck(NewAsmLine, (CurrFieldNo <> 0) OR TestReservationDateConflict);
    end;


    procedure SetSkipVerificationsThatChangeDatabase(State: Boolean)
    begin
        SkipVerificationsThatChangeDatabase := State;
    end;


    procedure ValidateDueDate(AsmHeader: Record "900"; NewDueDate: Date; ShowDueDateBeforeWorkDateMsg: Boolean)
    var
        MaxDate: Date;
    begin
        "Due Date" := NewDueDate;
        TestStatusOpen();

        MaxDate := LatestPossibleDueDate(AsmHeader."Starting Date");
        IF "Due Date" > MaxDate THEN
            ERROR(Text049, FIELDCAPTION("Due Date"), MaxDate, AsmHeader.FIELDCAPTION("Starting Date"), AsmHeader."Starting Date");

        IF (xRec."Due Date" <> "Due Date") AND (Quantity <> 0) THEN
            VerifyReservationDateConflict(Rec);

        CheckItemAvailable(FIELDNO("Due Date"));
        WhseValidateSourceLine.AssemblyLineVerifyChange(Rec, xRec);

        IF ("Due Date" < WORKDATE()) AND ShowDueDateBeforeWorkDateMsg THEN
            MESSAGE(Text050, "Due Date", WORKDATE());
    end;


    procedure ValidateLeadTimeOffset(AsmHeader: Record "900"; NewLeadTimeOffset: DateFormula; ShowDueDateBeforeWorkDateMsg: Boolean)
    var
        ZeroDF: DateFormula;
    begin
        "Lead-Time Offset" := NewLeadTimeOffset;
        TestStatusOpen();

        IF Type <> Type::Item THEN
            TESTFIELD("Lead-Time Offset", ZeroDF);
        ValidateDueDate(AsmHeader, LatestPossibleDueDate(AsmHeader."Starting Date"), ShowDueDateBeforeWorkDateMsg);
    end;

    local procedure LatestPossibleDueDate(HeaderStartingDate: Date): Date
    begin
        EXIT(HeaderStartingDate - (CALCDATE("Lead-Time Offset", WORKDATE()) - WORKDATE()));
    end;


    procedure "--FTA1.00"()
    begin
    end;


    procedure FctSelectRecForOrder(var RecPKitSalesLine: Record "901")
    begin
        WITH RecPKitSalesLine DO BEGIN
            RESET();
            SETCURRENTKEY("Document Type", "Document No.", Type, "Quantity per");
            SETFILTER("Document Type", '%1', "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETFILTER("Quantity per", '<>0');

            IF FINDSET() THEN
                REPEAT
                    CALCFIELDS("Reserved Qty. (Base)");
                    IF "Remaining Quantity (Base)" > "Reserved Qty. (Base)" THEN BEGIN
                        "Internal field" := TRUE;
                        IF ("Qty to be Ordered" = 0) AND "Selected for Order" THEN
                            VALIDATE("Selected for Order", TRUE);
                    END ELSE
                        "Internal field" := FALSE;
                    MODIFY();
                UNTIL NEXT() = 0;
            SETRANGE("Internal field", TRUE);
        END;
    end;


    procedure FctAutoReserveFTA()
    var
        ReservMgt: Codeunit "99000845";
        FullAutoReservation: Boolean;
    begin
        IF Type <> Type::Item THEN
            EXIT;

        TESTFIELD("No.");

        //IF Reserve <> Reserve::Always THEN
        //  EXIT;

        IF "Remaining Quantity (Base)" <> 0 THEN BEGIN
            IF "Quantity per" <> 0 THEN BEGIN
                TESTFIELD("Due Date");

                ReservMgt.SetAssemblyLine(Rec);

                //>>NDBI
                IF BooGResaAssFTA THEN
                    ReservMgt.FctSetBooResaAssFTA(TRUE);
                //<<NDBI

                ReservMgt.AutoReserve(FullAutoReservation, '', "Due Date", "Remaining Quantity", "Remaining Quantity (Base)");
                FIND();
                IF NOT FullAutoReservation AND (CurrFieldNo <> 0) THEN
                    IF CONFIRM(Text001, TRUE) THEN BEGIN
                        COMMIT();
                        ShowReservation();
                        FIND();
                    END;
            END;
        END;
    end;

    local procedure "------support optimisation ---------"()
    begin
    end;


    procedure FctSelectRecForOrder2(var recKitLine: Record "901")
    begin
        WITH recKitLine DO BEGIN
            SETCURRENTKEY("Document Type", "Document No.", Type, "Quantity per");
            SETFILTER("Document Type", '%1', "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETFILTER("Quantity per", '<>0');
            SETFILTER("Remaining Quantity", '<>0');
            IF FINDFIRST() THEN
                REPEAT
                    CALCFIELDS("Reserved Qty. (Base)");
                    IF "Remaining Quantity (Base)" > "Reserved Qty. (Base)" THEN BEGIN
                        "Internal field" := TRUE;
                        IF ("Qty to be Ordered" = 0) AND "Selected for Order" THEN
                            VALIDATE("Selected for Order", TRUE);
                    END ELSE
                        "Internal field" := FALSE;
                    MODIFY();
                UNTIL NEXT() = 0;
            SETRANGE("Internal field", TRUE);
        END;
    end;


    procedure ExplodeAndReserveAssemblyList()
    var
        AssemblyLineManagement: Codeunit "905";
    begin
        //>>FTA1.02
        AssemblyLineManagement.SetAutoReserve;
        AssemblyLineManagement.ExplodeAsmList(Rec);
    end;


    procedure ExplodeItemSubList(AvailableOnly: Boolean)
    var
        AssemblyLineManagement: Codeunit "905";
    begin
        //>>FTA1.02
        ItemSubstMgt.ExplodeItemAssemblySubst(Rec, AvailableOnly, FALSE);
    end;

    local procedure "----- NDBI -----"()
    begin
    end;


    procedure FctSetBooResaAssFTA(BooPResaAssFTA: Boolean)
    begin
        BooGResaAssFTA := BooPResaAssFTA;
    end;
}

