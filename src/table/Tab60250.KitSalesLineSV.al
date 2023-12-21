namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Inventory.Location;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Tracking;
using Microsoft.Finance.Dimension;
using Microsoft.Warehouse.Structure;
using Microsoft.Warehouse.Activity;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Inventory.Availability;
using Microsoft.Warehouse.Request;
table 60250 "Kit Sales LineSV"
{
    Caption = 'Kit Sales Line';
    //TODO: Page 25010 NOT found
    // DrillDownPageID = 25010;
    // LookupPageID = 25010;
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; enum "Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." where("Document Type" = field("Document Type"));
        }
        field(3; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = field("Document Type"), "Document No." = field("Document No."));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; enum Type)
        {
            Caption = 'Type';

            trigger OnValidate()
            begin
                TESTFIELD("Extended Quantity", 0);
                xKitSalesLine := Rec;
                INIT();
                Type := xKitSalesLine.Type;
                InitCompLine();
                CompLine.VALIDATE(Type);
                xKitSalesLine := Rec;
                INIT();
                Type := xKitSalesLine.Type;
            end;
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Item)) Item else
            if (Type = filter(Resource | "Setup Resource")) Resource;

            trigger OnValidate()
            var
                RecLItem: Record Item;
            begin
                TESTFIELD("Extended Quantity", 0);
                ;

                CheckItemAvailable();

                xKitSalesLine := Rec;
                INIT();
                Type := xKitSalesLine.Type;
                "No." := xKitSalesLine."No.";
                if "No." = '' then
                    exit;
                InitCompLine();
                CompLine.VALIDATE("No.");
                Description := CompLine.Description;
                "Description 2" := CompLine."Description 2";
                "Shipment Date" := CompLine."Shipment Date";
                "Shortcut Dimension 1 Code" := CompLine."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := CompLine."Shortcut Dimension 2 Code";
                Reserve := CompLine.Reserve;
                "Unit of Measure Code" := CompLine."Unit of Measure Code";
                "Unit of Measure" := CompLine."Unit of Measure";
                "Qty. per Unit of Measure" := CompLine."Qty. per Unit of Measure";
                "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                "Unit Cost" := CompLine."Unit Cost";
                VALIDATE("Unit Price", CompLine."Unit Price");
                "Location Code" := KitLine."Location Code";
                if Type = Type::Item then begin
                    CompLine."Location Code" := KitLine."Location Code";
                    CompLine.VALIDATE("Variant Code");
                    "Bin Code" := CompLine."Bin Code";
                end;
                if Type = Type::Item then
                    if RecLItem.GET("No.") then begin
                        RecLItem.SETRANGE("Date Filter", "Shipment Date");
                        RecLItem.SETFILTER("Location Filter", "Location Code");
                        RecLItem.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
                        "Avaibility no reserved" := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";
                        //TODO: "Kit BOM No." not found in item
                        // IF RecLItem."Kit BOM No." = '' THEN
                        //     "Kit Qty Available by Assembly" := 0
                        // ELSE BEGIN
                        //     "Kit Qty Available by Assembly" := 0;
                        //     BoolFirstRead := FALSE;
                        //     RecLProductionBOMLine.RESET();
                        //     //TODO: "Kit BOM No." not found in item
                        //     RecLProductionBOMLine.SETRANGE("Production BOM No.", RecLItem."Kit BOM No.");
                        //     IF RecLProductionBOMLine.FINDSET() THEN
                        //         REPEAT
                        //             IF (RecLProductionBOMLine.Type = RecLProductionBOMLine.Type::Item) THEN
                        //                 IF RecLItem.GET(RecLProductionBOMLine."No.") THEN BEGIN
                        //                     RecLItem.SETRANGE("Date Filter", "Shipment Date");
                        //                     RecLItem.SETFILTER("Location Filter", "Location Code");
                        //                     RecLItem.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
                        //                     DecLAvailibityNoReserved := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";

                        //                     IF NOT BoolFirstRead THEN
                        //                         "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<')
                        //                     ELSE
                        //                         IF ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<') < "Kit Qty Available by Assembly" THEN
                        //                             "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<');
                        //                     BoolFirstRead := TRUE;
                        //                 END;
                        //         UNTIL RecLProductionBOMLine.NEXT = 0;
                        // END;
                    end;
            end;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(9; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));

            trigger OnValidate()
            begin
                TESTFIELD("Extended Quantity", 0);
                ;

                if xRec."Variant Code" <> "Variant Code" then begin
                    TestKitLine();
                    "Applies-to Entry" := 0;
                end;

                if Reserve <> Reserve::Always then
                    CheckItemAvailable();

                InitCompLine();
                CompLine.VALIDATE("Variant Code", "Variant Code");
                Description := CompLine.Description;
                "Description 2" := CompLine."Description 2";
                "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                "Unit Cost" := CompLine."Unit Cost";
                VALIDATE("Unit Price", CompLine."Unit Price");
                "Bin Code" := CompLine."Bin Code";
            end;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No.")) else
            if (Type = filter(Resource | "Setup Resource")) "Resource Unit of Measure".Code where("Resource No." = field("No.")) else
            "Unit of Measure";

            trigger OnValidate()
            begin
                "Applies-to Entry" := 0;
                InitCompLine();
                CompLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                "Unit of Measure" := CompLine."Unit of Measure";
                "Qty. per Unit of Measure" := CompLine."Qty. per Unit of Measure";
                "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                "Unit Cost" := CompLine."Unit Cost";
                "Unit Price" := CompLine."Unit Price";
                VALIDATE("Quantity per");
            end;
        }
        field(12; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
        }
        field(13; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(14; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TESTFIELD("No.");
                if "Quantity per" < 0 then
                    FIELDERROR("Quantity per", Text25001);
                "Quantity per (Base)" := ROUND("Quantity per" * "Qty. per Unit of Measure", 0.00001);
                "Applies-to Entry" := 0;

                InitCompLine();
                case Type of
                    Type::Item, Type::Resource:
                        begin
                            "Extended Quantity" := "Quantity per" * KitLine."Quantity (Base)";
                            "Extended Quantity (Base)" := "Quantity per (Base)" * KitLine."Quantity (Base)";
                            "Outstanding Quantity" := "Quantity per" * KitLine."Outstanding Qty. (Base)";
                            "Outstanding Qty. (Base)" := "Quantity per (Base)" * KitLine."Outstanding Qty. (Base)";
                        end;
                    Type::"Setup Resource":
                        begin
                            "Extended Quantity" := "Quantity per";
                            "Extended Quantity (Base)" := "Quantity per (Base)";
                            "Outstanding Quantity" := "Quantity per";
                            "Outstanding Qty. (Base)" := "Quantity per (Base)";
                        end;
                end;
                if Reserve <> Reserve::Always then
                    CheckItemAvailable();
                CompLine."Unit of Measure Code" := "Unit of Measure Code";
                CompLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
                CompLine."Unit Price" := "Unit Price";
                CompLine.VALIDATE(Quantity, "Extended Quantity");
                VALIDATE("Unit Price", CompLine."Unit Price");
                //TODO: ReserveKitSalesLine Codeunit not found
                //TODO: KitSalesLineVerifyChange DE Codeunit WhseValidateSourceLine Codeunit not found
                // IF Type = Type::Item THEN
                //   IF (xRec."Extended Quantity" <> "Extended Quantity") OR (xRec."Extended Quantity (Base)" <> "Extended Quantity (Base)") THEN
                // BEGIN
                //     ReserveKitSalesLine.VerifyQuantity(Rec,xRec);
                //WhseValidateSourceLine.KitSalesLineVerifyChange(Rec,xRec);
                //   END;
            end;
        }
        field(15; "Quantity per (Base)"; Decimal)
        {
            Caption = 'Quantity per (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(16; "Extended Quantity"; Decimal)
        {
            Caption = 'Extended Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(17; "Extended Quantity (Base)"; Decimal)
        {
            Caption = 'Extended Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(18; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(19; "Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(20; "Reserved Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - sum("Reservation Entry".Quantity where("Source ID" = field("Document No."), "Source Ref. No." = field("Line No."), "Source Type" = const(25000), "Source Subtype" = field("Document Type"), "Source Prod. Order Line" = field("Document Line No."), "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(21; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Source ID" = field("Document No."), "Source Ref. No." = field("Line No."), "Source Type" = const(25000), "Source Subtype" = field("Document Type"), "Source Prod. Order Line" = field("Document Line No."), "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; Reserve; enum "Reserve Method")
        {
            Caption = 'Reserve';

            trigger OnValidate()
            begin
                if Reserve <> Reserve::Never then begin
                    TESTFIELD(Type, Type::Item);
                    TESTFIELD("No.");
                end;
                CALCFIELDS("Reserved Qty. (Base)");
                if (Reserve = Reserve::Never) and ("Reserved Qty. (Base)" > 0) then
                    TESTFIELD("Reserved Qty. (Base)", 0);

                if xRec.Reserve = Reserve::Always then begin
                    Item.GET("No.");
                    if Item.Reserve = Item.Reserve::Always then
                        TESTFIELD(Reserve, Reserve::Always);
                end;
            end;
        }
        field(23; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            Editable = false;

            trigger OnValidate()
            var
                CheckDateConflict: codeunit 99000815;
            begin
                //TODO : KitSalesLineCheck NOT FOUND IN CODEUNIT CheckDateConflict
                // IF ("Extended Quantity" <> 0) AND
                //    (Reserve <> Reserve::Never)
                // THEN
                //   CheckDateConflict.KitSalesLineCheck(Rec,FALSE);
            end;
        }
        field(26; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(28; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';

            trigger OnLookup()
            begin
                SelectItemEntry();
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record 32;
            begin
                if "Applies-to Entry" <> 0 then begin
                    ItemLedgEntry.GET("Applies-to Entry");
                    ItemLedgEntry.TESTFIELD("Location Code", "Location Code");
                    ItemLedgEntry.TESTFIELD("Variant Code", "Variant Code");

                    TESTFIELD(Type, Type::Item);
                    TESTFIELD("Extended Quantity");
                    InitCompLine();
                    CompLine.Quantity := "Extended Quantity";
                    CompLine.VALIDATE("Appl.-to Item Entry", "Applies-to Entry");
                    ItemLedgEntry.GET("Applies-to Entry");

                    "Unit Cost (LCY)" := CompLine."Unit Cost (LCY)";
                    "Unit Cost" := CompLine."Unit Cost";
                end;
            end;
        }
        field(29; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = if (Type = const(Item)) "Bin Content"."Bin Code" where("Location Code" = field("Location Code"), "Item No." = field("No."), "Variant Code" = field("Variant Code"));

            trigger OnValidate()
            begin
                if xRec."Bin Code" <> "Bin Code" then
                    TestKitLine();
                InitCompLine();
                CompLine."Variant Code" := "Variant Code";
                CompLine.VALIDATE("Bin Code", "Bin Code");
            end;
        }
        field(30; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';

            trigger OnValidate()
            begin
                if (CurrFieldNo = FIELDNO("Unit Cost (LCY)")) and
                   (Type = Type::Item) and ("No." <> '') then begin
                    Item.GET("No.");
                    if Item."Costing Method" = Item."Costing Method"::Standard then
                        ERROR(
                          Text25000,
                          FIELDCAPTION("Unit Cost"), Item.FIELDCAPTION("Costing Method"), Item."Costing Method")
                end;
                InitCompLine();
                CompLine.VALIDATE("Unit Cost (LCY)", "Unit Cost (LCY)");
                "Unit Cost" := CompLine."Unit Cost";
            end;
        }
        field(31; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(32; "Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                TESTFIELD(Type);
                //TODO: CODEUNIT 25000 NOT FOUND
                // IF (CurrFieldNo <> 0) AND
                //    ("Quantity per" <> 0) AND
                //    (("Unit Price" <> xRec."Unit Price") OR
                //     ("Quantity per" <> xRec."Quantity per"))
                // THEN
                //     KitManagement.RollUpPrice(Rec, 1);
            end;
        }
        field(33; "Pick Qty."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Activity Line"."Qty. Outstanding" where("Activity Type" = filter(<> "Put-away"),
            "Source Type" = const(25000), "Source Subtype" = field("Document Type"), "Source No." = field("Document No."), "Source Line No." = field("Document Line No."),
            "Source Subline No." = field("Line No."), "Unit of Measure Code" = field("Unit of Measure Code"), "Action Type" = filter('' | Place), "Original Breakbulk" = const(false), "Breakbulk No." = const(0)));
            Caption = 'Pick Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(34; "Pick Qty. (Base)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Activity Line"."Qty. Outstanding (Base)" where("Activity Type" = filter(<> "Put-away"), "Source Type" = const(25000), "Source Subtype" = field("Document Type"), "Source No." = field("Document No."),
            "Source Line No." = field("Document Line No."), "Source Subline No." = field("Line No."), "Unit of Measure Code" = field("Unit of Measure Code"), "Action Type" = filter('' | Place), "Original Breakbulk" = const(false), "Breakbulk No." = const(0)));
            Caption = 'Pick Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(35; "Qty. Picked"; Decimal)
        {
            Caption = 'Qty. Picked';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(36; "Qty. Picked (Base)"; Decimal)
        {
            Caption = 'Qty. Picked (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(37; "Completely Picked"; Boolean)
        {
            Caption = 'Completely Picked';
            Editable = false;
        }
        field(38; "Quantity Shipped (Base)"; Decimal)
        {
            Caption = 'Quantity Shipped (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50000; "Kit BOM No."; Code[20])
        {
            //TODO : "Kit BOM No." NOT FOUND
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Item."Kit BOM No." WHERE("No." = FIELD("No.")));
            Caption = 'Kit BOM No.';
            Editable = false;

        }
        field(50001; "Level No."; Integer)
        {
            Caption = 'Level No.';
        }
        field(50002; "Kit Action"; enum "Kit Action")
        {
            Caption = 'Kit Action';
            trigger OnValidate()
            var
                CstL001: Label '%1 impossible';
            begin
                case "Kit Action" of
                    "Kit Action"::Assembly:
                        if "Quantity per" <> 0 then
                            ERROR(CstL001, FORMAT("Kit Action"));
                    "Kit Action"::Disassembly:
                        if "x Quantity per" <> 0 then
                            ERROR(CstL001, FORMAT("Kit Action"));
                end;
            end;
        }
        field(50003; "x Quantity per"; Decimal)
        {
            Caption = 'Origin Quantity per';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(50004; "Avaibility no reserved"; Decimal)
        {
            Caption = 'Avaibility';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50005; "x Quantity per (Base)"; Decimal)
        {
            Caption = 'Origin Quantity per (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(50006; "Kit Qty Available by Assembly"; Decimal)
        {
            Caption = 'Kit Qty Available by Assembly';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50007; "x Extended Quantity"; Decimal)
        {
            Caption = 'x Extended Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50008; "x Extended Quantity (Base)"; Decimal)
        {
            Caption = 'x Extended Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50009; Kit; Boolean)
        {
            CalcFormula = exist("Production BOM Header" where("No." = field("No.")));
            Caption = 'Kit';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", Type, "No.", "Variant Code", "Location Code", "Shipment Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)", "Quantity Shipped (Base)", "Qty. Picked (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: codeunit "Capable To Promise";
    begin
        GetKitLine();
        TestStatusOpen();
        if not QtyShippedCheckSuspend then
            KitLine.TESTFIELD("Quantity Shipped", 0);
        //TODO: CODEUNIT 25000 NOT FOUND 
        // IF NOT SkipPricing THEN
        //   KitManagement.RollUpPrice(Rec,2);

        if ("Extended Quantity" <> 0) and ItemExists("No.") then begin
            //TODO: ReserveKitSalesLine Codeunit not found
            //ReserveKitSalesLine.DeleteLine(Rec);
            CALCFIELDS("Reserved Qty. (Base)");
            TESTFIELD("Reserved Qty. (Base)", 0);
            //TODO: KitSalesLineDelete  not found
            //WhseValidateSourceLine.KitSalesLineDelete(Rec);
        end;
        //TODO: no overload for method RemoveReqLines 
        //CapableToPromise.RemoveReqLines("Document No.","Document Line No.","Line No.",0,false);
    end;

    trigger OnInsert()
    begin
        TestStatusOpen();
        GetKitLine();
        //TODO: Build Kit not found
        //KitLine.TESTFIELD("Build Kit",TRUE);
        //TODO: codeunit KitManagement not found
        //KitManagement.RollUpPrice(Rec,3);
        //TODO: ReserveKitSalesLine Codeunit not found
        // IF "Extended Quantity" <> 0 THEN
        //   ReserveKitSalesLine.VerifyQuantity(Rec,xRec);
    end;

    trigger OnModify()
    begin
        TestStatusOpen();
        //TODO: codeunit KitManagement not found
        // KitManagement.RollUpPrice(Rec,1);
        //TODO: ReserveKitSalesLine Codeunit not found
        // IF ("Extended Quantity" <> 0) AND ItemExists(xRec."No.") THEN
        //   ReserveKitSalesLine.VerifyChange(Rec,xRec);
    end;

    trigger OnRename()
    begin
        ERROR(Text001, TABLECAPTION);
    end;

    procedure GetCurrencyCode(): Code[10]
    var
        SalesHeader: Record 36;
    begin
        if ("Document Type" = SalesHeader."Document Type") and
           ("Document No." = SalesHeader."No.")
        then
            exit(SalesHeader."Currency Code");
        if SalesHeader.GET("Document Type", "Document No.") then
            exit(SalesHeader."Currency Code");
        exit('');
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        SalesHeader: Record "36";
    begin
        if not SalesHeader.GET("Document Type", "Document No.") then begin
            SalesHeader."No." := '';
            SalesHeader.INIT();
        end;
        if SalesHeader."Prices Including VAT" then
            exit('2,1,' + GetFieldCaption(FieldNumber))
        else
            exit('2,0,' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record 2000000041;
    begin
        //TODO: "Kit Sales Line" not found
        //Field.GET(DATABASE::"Kit Sales Line", FieldNumber);
        exit(Field."Field Caption");
    end;

    procedure GetKitLine()
    begin
        if UseKitLine2 then
            KitLine := KitLine2
        else begin
            TESTFIELD("Document No.");
            if ("Document Type" <> KitLine."Document Type") or
               ("Document No." <> KitLine."Document No.") or
               ("Document Line No." <> KitLine."Line No.")
            then
                KitLine.GET("Document Type", "Document No.", "Document Line No.");
        end;
    end;

    procedure TestKitLine()
    begin
        GetKitLine();
        KitLine.TESTFIELD("Qty. Shipped Not Invoiced", 0);
        KitLine.TESTFIELD("Shipment No.", '');
        KitLine.TESTFIELD("Return Qty. Rcd. Not Invd.", 0);
        KitLine.TESTFIELD("Return Receipt No.", '');
    end;

    local procedure InitCompLine()
    var
        RecLItem: Record 27;
    begin
        GetKitLine();

        KitLine.TESTFIELD("Quantity Shipped", 0);
        CompLine := KitLine;
        CompLine."Line No." := 0;
        case Type of
            Type::" ":
                CompLine.Type := CompLine.Type::" ";
            Type::Item:
                CompLine.Type := CompLine.Type::Item;
            Type::Resource, Type::"Setup Resource":
                CompLine.Type := CompLine.Type::Resource;
        end;

        if Type = Type::Item then
            if RecLItem.GET("No.") then
                CompLine."Item Base" := RecLItem."Item Base";

        CompLine."No." := "No.";
        CompLine."Shipment Date" := "Shipment Date";
        CompLine."Variant Code" := "Variant Code";
        CompLine."Unit of Measure Code" := "Unit of Measure Code";
        CompLine.Quantity := 0;
        CompLine."Unit Price" := "Unit Price";
        //TODO: "Build Kit" not found
        // CompLine."Build Kit" := FALSE;
        CompLine.SetHideValidationDialog(true);

    end;

    local procedure SelectItemEntry()
    var
        ItemLedgEntry: Record 32;
        KitSalesLine2: Record "Kit Sales LineSV";
    begin
        ItemLedgEntry.SETCURRENTKEY("Item No.", Open);
        ItemLedgEntry.SETRANGE("Item No.", "No.");
        if "Location Code" <> '' then
            ItemLedgEntry.SETRANGE("Location Code", "Location Code");
        ItemLedgEntry.SETRANGE("Variant Code", "Variant Code");
        ItemLedgEntry.SETRANGE(Positive, true);
        ItemLedgEntry.SETRANGE(Open, true);

        if Page.RUNMODAL(38, ItemLedgEntry) = ACTION::LookupOK then begin
            KitSalesLine2 := Rec;
            KitSalesLine2.VALIDATE("Applies-to Entry", ItemLedgEntry."Entry No.");
            if Reserve <> Reserve::Always then
                CheckItemAvailable();
            Rec := KitSalesLine2;
        end;
    end;

    local procedure CheckItemAvailable()
    var
        SalesHeader: Record 36;
        ItemCheckAvail: codeunit "Item-Check Avail.";
    begin
        if "Shipment Date" = 0D then begin
            SalesHeader.GET("Document Type", "Document No.");
            if SalesHeader."Shipment Date" <> 0D then
                "Shipment Date" := SalesHeader."Shipment Date"
            else
                "Shipment Date" := WORKDATE();
        end;
        //TODO: CodeUnit ItemCheckAvail not migrated yet
        // IF (CurrFieldNo <> 0) AND GUIALLOWED AND
        //    ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) AND
        //    (Type = Type::Item) AND ("No." <> '') AND
        //    ("Outstanding Quantity" > 0)
        // THEN

        //     ItemCheckAvail.KitSalesLineCheck2(Rec);
    end;

    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record Item;
    begin
        if Type = Type::Item then
            if not Item2.GET(ItemNo) then
                exit(false);
        exit(true);
    end;

    local procedure TestStatusOpen()
    var
        SalesHeader: Record "Sales Header";
    begin
        if StatusCheckSuspended then
            exit;
        TESTFIELD("Document No.");
        if ("Document Type" <> SalesHeader."Document Type") or ("Document No." <> SalesHeader."No.") then
            SalesHeader.GET("Document Type", "Document No.");
        SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);
    end;

    var
        KitLine: Record "Sales Line";
        KitLine2: Record "Sales Line";
        CompLine: Record "Sales Line";
        xKitSalesLine: Record 60250;
        Text001: Label 'You cannot rename a %1.';
        Text25000: Label 'You cannot change %1 when %2 is %3.';
        Item: Record Item;
        //TODO: CodeUnit not found
        // KitManagement: codeunit 25000;
        // ReserveKitSalesLine: codeunit 25001;
        WhseValidateSourceLine: codeunit "Whse. Validate Source Line";
        UseKitLine2: Boolean;
        Text25001: Label 'must be positive';
        SkipPricing: Boolean;
        QtyShippedCheckSuspend: Boolean;
        StatusCheckSuspended: Boolean;
        Reservation: Page Reservation;
}

