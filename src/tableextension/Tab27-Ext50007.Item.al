namespace Prodware.FTA;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Setup;
tableextension 50007 Item extends Item //27
{
    fields
    {
        modify("Item Disc. Group")
        {
            trigger OnAfterValidate()
            begin
                Validate("Unit Price net");
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            var
                CstL001: Label 'Please enter before this opeartion the The purchase price';
            begin
                Validate("Margin in %");
                if "Purchase Price Base" = 0 then
                    Error(CstL001);
                if "Indirect Cost %" <> 0 then
                    "Multiplying Coefficient" := Round("Unit Price" / "Purchase Price Base" * (1 + "Indirect Cost %" / 100), 0.00001)
                else
                    "Multiplying Coefficient" := Round("Unit Price" / "Purchase Price Base", 0.00001);
            end;
        }
        modify("Indirect Cost %")
        {
            trigger OnAfterValidate()
            begin
                FctCalcSalesPriceFTA(Rec);
            end;
        }
        field(50000; "Purchase Price Base"; Decimal)
        {
            Caption = 'Purchase Price Base';

            trigger OnValidate()
            var
                RecLPurchPrice: Record 7012;
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TESTFIELD("Vendor No.");
                    TESTFIELD("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.FindFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.MODIFY(true);
                    end else begin
                        RecLPurchPrice.Init();
                        RecLPurchPrice.Validate("Item No.", "No.");
                        RecLPurchPrice.Validate("Vendor No.", "Vendor No.");
                        RecLPurchPrice.Validate("Unit of Measure Code", "Base Unit of Measure");
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Insert(true);
                    end;
                end;
            end;
        }
        field(50001; "Item Base"; Enum ItemBase)
        {
            Caption = 'Item Base';
            trigger OnValidate()
            var
                CstL001: Label 'You can not change an Transitory item to an Transitory Kit item';
                CstL002: Label 'You can not change an Transitory Kit item to an Transitory item';
            begin
                if ("Item Base" = "Item Base"::"Transitory Kit") and (xRec."Item Base" = "Item Base"::Transitory) then
                    Error(CstL001);
                if ("Item Base" = "Item Base"::Transitory) and (xRec."Item Base" = "Item Base"::"Transitory Kit") then
                    Error(CstL002);

                if "Item Base" = "Item Base"::"Transitory Kit" then
                    "Replenishment System" := "Replenishment System"::Assembly;
            end;
        }
        field(50002; "Multiplying Coefficient"; Decimal)
        {
            Caption = 'Multiplying Coefficient';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                FctCalcSalesPriceFTA(Rec);
            end;
        }
        field(50003; "Margin in %"; Decimal)
        {
            Caption = 'Margin in %';
            trigger OnValidate()
            var
                RecLSalesLineDisc: Record 7004;
                DecGUnitPrice: Decimal;
            begin
                DecGUnitPrice := "Unit Price";
                if "Unit Price" <> 0 then begin
                    RecLSalesLineDisc.Reset();
                    RecLSalesLineDisc.SetRange(Type, RecLSalesLineDisc.Type::Item);
                    RecLSalesLineDisc.SetRange(Code, "No.");
                    RecLSalesLineDisc.SetRange("Sales Type", RecLSalesLineDisc."Sales Type"::"All Customers");
                    if RecLSalesLineDisc.FindSet() then
                        if RecLSalesLineDisc."Line Discount %" <> 0 then
                            DecGUnitPrice := DecGUnitPrice * (1 - (RecLSalesLineDisc."Line Discount %" / 100));
                    "Margin in %" := 100 * (DecGUnitPrice - "Purchase Price Base") / DecGUnitPrice
                end else
                    "Margin in %" := 0;
                Validate("Unit Price net");
            end;
        }
        field(50004; "Kit - Sales Price"; Decimal)
        {
            Caption = 'Kit - Sales Price';
        }
        field(50005; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                Validate("Unit Price net");
            end;
        }
        field(50006; "Qty. stock on Sales Order"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                            Type = const(Item),
                                                                            "No." = field("No."),
                                                                            "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Drop Shipment" = field("Drop Shipment Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            //TODO::Field SPE  Sales line
            //"Preparation Type" = CONST(Stock)));
            Caption = 'Qty. Stock on Sales Order';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Margin net in %"; Decimal)
        {
            Caption = 'Net Margin in %';
            Editable = false;
        }
        field(50008; "Unit Price net"; Decimal)
        {
            Caption = 'Unit Net Price';
            Editable = false;
            trigger OnValidate()
            var
                RecLSalesLineDisc: Record 7004;
                RecLSalesReceiveSetup: Record 311;
                DecGUnitPrice: Decimal;

            begin
                "Unit Price net" := "Unit Price";
                RecLSalesReceiveSetup.Get();
                if ("Unit Price" <> 0) then begin
                    if ("Item Disc. Group" <> '') then
                        RecLSalesLineDisc.Reset();
                    RecLSalesLineDisc.SetRange(Type, RecLSalesLineDisc.Type::"Item Disc. Group");
                    RecLSalesLineDisc.SetRange(Code, "Item Disc. Group");
                    RecLSalesLineDisc.SetRange("Sales Type", RecLSalesLineDisc."Sales Type"::Customer);
                    RecLSalesLineDisc.SetRange("Sales Code", "Customer Code");
                    if RecLSalesLineDisc.FindSet() then
                        if RecLSalesLineDisc."Line Discount %" <> 0 then
                            "Unit Price net" := "Unit Price net" * (1 - (RecLSalesLineDisc."Line Discount %" / 100))
                    //TODO: field spe table SalesReceiveSetup not migrated yet
                    //else

                    // if RecLSalesReceiveSetup."Discount All Item" <> '' then begin
                    //     RecLSalesLineDisc.Reset();
                    //     RecLSalesLineDisc.SetRange(Type, RecLSalesLineDisc.Type::"Item Disc. Group");
                    //     RecLSalesLineDisc.SetRange(Code, RecLSalesReceiveSetup."Discount All Item");
                    //     RecLSalesLineDisc.SetRange("Sales Type", RecLSalesLineDisc."Sales Type"::Customer);
                    //     RecLSalesLineDisc.SetRange("Sales Code", "Customer Code");
                    //     if RecLSalesLineDisc.FindSet() then
                    //         if RecLSalesLineDisc."Line Discount %" <> 0 then
                    //             "Unit Price net" := "Unit Price net" * (1 - (RecLSalesLineDisc."Line Discount %" / 100));
                    // end;

                end;
                if "Unit Price net" <> 0 then
                    "Margin net in %" := 100 * ("Unit Price net" - "Purchase Price Base") / "Unit Price net"
                else
                    "Margin net in %" := 0;
            end;
        }
        field(50009; "Qty. on Sales Quote"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Quote),
                                                                            Type = const("Item"),
                                                                            "No." = field("No."),
                                                                            "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Drop Shipment" = field("Drop Shipment Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Qty. on Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Pdf Url"; Text[250])
        {
            Caption = 'Pdf Url';
        }
        field(50011; "Send To Web"; Boolean)
        {
            Caption = 'Send To Web';
        }
        field(50012; "Assembly time"; Text[30])
        {
            Caption = 'Temps de montage';
        }
        field(50013; Weight; Text[30])
        {
            Caption = 'Poids';
        }
        field(50014; "Storage type"; Text[30])
        {
            Caption = 'Type stockage';
        }
        field(50015; "Quote Associated"; Boolean)
        {
            Caption = 'Quote Associated';
            Editable = false;
        }
        field(50016; "Qty. on Purch. Order Confirmed"; Decimal)
        {
            AccessByPermission = TableData 120 = R;
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                               Type = const(Item),
                                                                               "No." = field("No."),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Location Code" = field("Location Filter"),
                                                                               "Drop Shipment" = field("Drop Shipment Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Expected Receipt Date" = field("Date Filter"),
                                                                               "Promised Receipt Date" = filter(<> '')));
            Caption = 'Qty. on Purch. Order Confirmed';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "Item Work Time"; Integer)
        {
            BlankZero = true;
            Caption = 'Temps de montage';
            //TODO: Table SPE NOT Migrated yet
            //TableRelation = "Work Time";
        }
        field(50018; "Item Machining Time"; Integer)
        {
            BlankZero = true;
            Caption = 'Temps d''usinage';
            //TODO: Table SPE NOT Migrated yet
            //TableRelation = "Work Time";
        }
        field(50019; "Default Prepared Sales Lines"; Boolean)
        {
            Caption = 'Préparé automatiquement lignes vente';
        }
        field(50020; "Purchase Price Base 1"; Decimal)
        {
            Caption = 'Purchase Price Base';
            trigger OnValidate()
            var
                RecLPurchPrice: Record 7012;
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TESTFIELD("Vendor No.");
                    TESTFIELD("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.FindFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.MODIFY(true);
                    end else begin
                        RecLPurchPrice.Init();
                        RecLPurchPrice.Validate("Item No.", "No.");
                        RecLPurchPrice.Validate("Vendor No.", "Vendor No.");
                        RecLPurchPrice.Validate("Unit of Measure Code", "Base Unit of Measure");
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Insert(true);
                    end;
                end;
            end;
        }
        field(50021; "Purchase Price Base 2"; Decimal)
        {
            Caption = 'Purchase Price Base';
            trigger OnValidate()
            var
                RecLPurchPrice: Record 7012;
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TESTFIELD("Vendor No.");
                    TESTFIELD("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.FindFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.MODIFY(true);
                    end else begin
                        RecLPurchPrice.Init();
                        RecLPurchPrice.Validate("Item No.", "No.");
                        RecLPurchPrice.Validate("Vendor No.", "Vendor No.");
                        RecLPurchPrice.Validate("Unit of Measure Code", "Base Unit of Measure");
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Insert(true);
                    end;
                end;
            end;
        }
        field(50022; "Purchase Price Base 10"; Decimal)
        {
            Caption = 'Purchase Price Base';
            trigger OnValidate()
            var
                RecLPurchPrice: Record 7012;
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TESTFIELD("Vendor No.");
                    TESTFIELD("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.FindFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.MODIFY(true);
                    end else begin
                        RecLPurchPrice.Init();
                        RecLPurchPrice.Validate("Item No.", "No.");
                        RecLPurchPrice.Validate("Vendor No.", "Vendor No.");
                        RecLPurchPrice.Validate("Unit of Measure Code", "Base Unit of Measure");
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Insert(true);
                    end;
                end;
            end;
        }
        field(50023; "Purchase Price Base 25"; Decimal)
        {
            Caption = 'Purchase Price Base';
            trigger OnValidate()
            var
                RecLPurchPrice: Record 7012;
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TESTFIELD("Vendor No.");
                    TESTFIELD("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.FindFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.MODIFY(true);
                    end else begin
                        RecLPurchPrice.Init();
                        RecLPurchPrice.Validate("Item No.", "No.");
                        RecLPurchPrice.Validate("Vendor No.", "Vendor No.");
                        RecLPurchPrice.Validate("Unit of Measure Code", "Base Unit of Measure");
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Insert(true);
                    end;
                end;
            end;
        }
        field(50024; "Purchase Price Base 50"; Decimal)
        {
            Caption = 'Purchase Price Base';
            trigger OnValidate()
            var
                RecLPurchPrice: Record 7012;
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TESTFIELD("Vendor No.");
                    TESTFIELD("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.FindFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.MODIFY(true);
                    end else begin
                        RecLPurchPrice.Init();
                        RecLPurchPrice.Validate("Item No.", "No.");
                        RecLPurchPrice.Validate("Vendor No.", "Vendor No.");
                        RecLPurchPrice.Validate("Unit of Measure Code", "Base Unit of Measure");
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Insert(true);
                    end;
                end;
            end;
        }
        field(50025; "Purchase Price Base 5"; Decimal)
        {
            Caption = 'Purchase Price Base';
            trigger OnValidate()
            var
                RecLPurchPrice: Record 7012;
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TESTFIELD("Vendor No.");
                    TESTFIELD("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.FindFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.MODIFY(true);
                    end else begin
                        RecLPurchPrice.Init();
                        RecLPurchPrice.Validate("Item No.", "No.");
                        RecLPurchPrice.Validate("Vendor No.", "Vendor No.");
                        RecLPurchPrice.Validate("Unit of Measure Code", "Base Unit of Measure");
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Insert(true);
                    end;
                end;
            end;
        }
        field(51000; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(51001; User; Code[50])
        {
            Caption = 'User';
            Description = 'NAVEASY.001 [Champs_Suppl] Ajout du champ';
            //TODO: TABLE SPE not migrated yet
            // TableRelation = User."User Name";
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Search Description", "Inventory")
        {

        }
    }
    local procedure FctCalcPurchasePriceFTA(var RecPItem: Record 27)
    var
        RecLPurchPrice: Record 7012;
        RecLPurchLineDisc: Record 7014;
        RecLProductionBOMLine: Record 99000772;
        //TODO: Table SPE not migrated yet
        //ItemProductionCost: Record 50006;
        DecLQty: Decimal;
        BooLQtyFound: Boolean;
        DecLCost: Decimal;
        BooLRecOK: Boolean;
        DecLDisc: Decimal;

    begin
        with RecPItem do begin
            DecLQty := 999999;
            BooLQtyFound := false;
            DecLCost := 0;
            RecLPurchPrice.Reset();
            RecLPurchPrice.SetRange("Item No.", "No.");
            RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
            if RecLPurchPrice.FindSet() then
                repeat
                    BooLRecOK := true;
                    if ("Purch. Unit of Measure" <> RecLPurchPrice."Unit of Measure Code") and
                         (RecLPurchPrice."Unit of Measure Code" <> '') then
                        BooLRecOK := false;
                    if (RecLPurchPrice."Starting Date" <> 0D) and (WORKDATE() < RecLPurchPrice."Starting Date") then
                        BooLRecOK := false;
                    if (RecLPurchPrice."Ending Date" <> 0D) and (WORKDATE() > RecLPurchPrice."Ending Date") then
                        BooLRecOK := false;
                    if (BooLRecOK = true) and (RecLPurchPrice."Minimum Quantity" <= DecLQty) then begin
                        DecLQty := RecLPurchPrice."Minimum Quantity";
                        DecLCost := RecLPurchPrice."Direct Unit Cost";
                    end;
                until RecLPurchPrice.NEXT() = 0;
            RecLPurchLineDisc.Reset();
            RecLPurchLineDisc.SetRange("Item No.", "No.");
            RecLPurchLineDisc.SetRange("Vendor No.", "Vendor No.");
            if RecLPurchLineDisc.FindSet() then
                repeat
                    BooLRecOK := true;
                    if ("Purch. Unit of Measure" <> RecLPurchLineDisc."Unit of Measure Code") and
                         (RecLPurchLineDisc."Unit of Measure Code" <> '') then
                        BooLRecOK := false;
                    if (RecLPurchLineDisc."Starting Date" <> 0D) and (WORKDATE() < RecLPurchLineDisc."Starting Date") then
                        BooLRecOK := false;
                    if (RecLPurchLineDisc."Ending Date" <> 0D) and (WORKDATE() > RecLPurchLineDisc."Ending Date") then
                        BooLRecOK := false;
                    if (BooLRecOK = true) and (RecLPurchLineDisc."Minimum Quantity" <= DecLQty) or
                       (BooLRecOK = true) and (DecLQty = 0) and (RecLPurchLineDisc."Minimum Quantity" = 1) then
                        DecLDisc := RecLPurchLineDisc."Line Discount %";

                until RecLPurchLineDisc.NEXT() = 0;

            if DecLDisc <> 0 then
                "Purchase Price Base" := Round(DecLCost * (1 - (DecLDisc / 100)), 0.01)
            else
                "Purchase Price Base" := DecLCost;
            //TODO: instance for Table SPE not migrated
            // ItemProductionCost.Reset;
            // ItemProductionCost.SetRange("Item No.", "No.");
            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 0);
            // if ItemProductionCost.FindFirst then
            //     "Purchase Price Base 1" := ItemProductionCost."Unit Cost";

            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 2);
            // if ItemProductionCost.FindFirst then
            //     "Purchase Price Base 2" := ItemProductionCost."Unit Cost";

            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 5);
            // if ItemProductionCost.FindFirst then
            //     "Purchase Price Base 5" := ItemProductionCost."Unit Cost";

            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 10);
            // if ItemProductionCost.FindFirst then
            //     "Purchase Price Base 10" := ItemProductionCost."Unit Cost";

            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 25);
            // if ItemProductionCost.FindFirst then
            //     "Purchase Price Base 25" := ItemProductionCost."Unit Cost";

            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            // ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 50);
            // if ItemProductionCost.FindFirst then
            //     "Purchase Price Base 50" := ItemProductionCost."Unit Cost";

            Validate("Margin in %");
        end;
    end;

    local procedure GetInvtSetup()
    begin
        if not HasInvtSetup then begin
            InvtSetup.Get;
            HasInvtSetup := true;
        end;
    end;

    local procedure FctCalcKitPriceFTA(var RecPItem: Record 27; var BooPMonoLevel: Boolean)
    var
        RecLItem: Record 27;
    begin
        RecPItem.CALCFIELDS(RecPItem."Assembly BOM");
        if not RecPItem."Assembly BOM" then begin
            RecPItem."Kit - Sales Price" := 0;
            exit;
        end;
        RollUpPriceFTA(RecPItem, BooPMonoLevel);
        RecPItem.MODIFY();
    end;

    local procedure FctCreateFromTemplate()
    var
        "**FTA1.00": Integer;
        CduLTemplateMgt: Codeunit 8612;
        RecRef: RecordRef;
        RecLTemplateHeader: Record 8618;
        RecLTemplateLine: Record 8619;
        RecLItemUnitofMeasure: Record 5404;
    begin
        if "Item Base" = "Item Base"::Transitory then begin
            GetInvtSetup();
            RecRef.GetTable(Rec);
            //TODO: table Inventory setup not migrated yet 
            // InvtSetup.TESTFIELD("Template Item Transitory Code");
            // RecLTemplateHeader.Get(InvtSetup."Template Item Transitory Code");
            // RecLTemplateLine.SetRange("Data Template Code", InvtSetup."Template Item Transitory Code");
            RecLTemplateLine.SetRange("Field ID", 8);
            if RecLTemplateLine.FindSet() then begin
                if not RecLItemUnitofMeasure.Get("No.", RecLTemplateLine."Default Value") then begin
                    RecLItemUnitofMeasure.Init();
                    RecLItemUnitofMeasure.Validate("Item No.", "No.");
                    RecLItemUnitofMeasure.Validate(Code, RecLTemplateLine."Default Value");
                    RecLItemUnitofMeasure.Insert(true);
                end;
            end;
            CduLTemplateMgt.UpdateRecord(RecLTemplateHeader, RecRef);
        end;
        if "Item Base" = "Item Base"::"Transitory Kit" then begin
            GetInvtSetup;
            RecRef.GetTable(Rec);
            //TODO: table Inventory setup not migrated yet 
            // InvtSetup.TESTFIELD("Template Item Trans. Kit Code");
            // RecLTemplateHeader.Get(InvtSetup."Template Item Trans. Kit Code");
            // RecLTemplateLine.SetRange("Data Template Code", InvtSetup."Template Item Trans. Kit Code");
            RecLTemplateLine.SetRange("Field ID", 8);
            if RecLTemplateLine.FindSet() then
                if not RecLItemUnitofMeasure.Get("No.", RecLTemplateLine."Default Value") then begin
                    RecLItemUnitofMeasure.Init();
                    RecLItemUnitofMeasure.Validate("Item No.", "No.");
                    RecLItemUnitofMeasure.Validate(Code, RecLTemplateLine."Default Value");
                    RecLItemUnitofMeasure.Insert(true);
                end;
            CduLTemplateMgt.UpdateRecord(RecLTemplateHeader, RecRef);
        end;
        if "Item Base" = "Item Base"::"Bored blocks" then begin
            GetInvtSetup();
            RecRef.GetTable(Rec);
            //TODO: table Inventory setup not migrated yet 
            // InvtSetup.TESTFIELD(InvtSetup."Template Item Bored block Code");
            // RecLTemplateHeader.Get(InvtSetup."Template Item Bored block Code");
            // RecLTemplateLine.SetRange("Data Template Code", InvtSetup."Template Item Bored block Code");
            RecLTemplateLine.SetRange("Field ID", 8);
            if RecLTemplateLine.FindSet() then
                if not RecLItemUnitofMeasure.Get("No.", RecLTemplateLine."Default Value") then begin
                    RecLItemUnitofMeasure.Init();
                    RecLItemUnitofMeasure.Validate("Item No.", "No.");
                    RecLItemUnitofMeasure.Validate(Code, RecLTemplateLine."Default Value");
                    RecLItemUnitofMeasure.Insert(true);
                end;
            CduLTemplateMgt.UpdateRecord(RecLTemplateHeader, RecRef);
        end;
    end;

    local procedure FctBOM(var RecPItem: Record 27)
    var
        "**FTA1.00": Integer;
        RecLProdBOMHeader: Record 99000771;
        CstL001: Label 'This item does not have a BOM, do you want to create one?';
        FrmLKitBOM: Page 36;
        RecLBOMComponent: Record 90;
    begin
        RecPItem.CALCFIELDS("Assembly BOM");
        if not RecPItem."Assembly BOM" then
            if not CONFIRM(CstL001, true) then
                exit;

        Clear(FrmLKitBOM);
        RecLBOMComponent.FILTERGROUP(2);
        RecLBOMComponent.SetRange("Parent Item No.", RecPItem."No.");
        RecLBOMComponent.FILTERGROUP(0);
        FrmLKitBOM.SetTableView(RecLBOMComponent);
        FrmLKitBOM.Run();

    end;

    local procedure FctCalcSalesPriceFTA(var RecPItem: Record 27)
    var
        RecLPurchPrice: Record 7012;
        RecLPurchLineDisc: Record 7014;
        DecLQty: Decimal;
        BooLQtyFound: Boolean;
        DecLCost: Decimal;
        BooLRecOK: Boolean;
        DecLDisc: Decimal;
        RecLProductionBOMLine: Record 99000772;
    begin
        with RecPItem do begin

            if "Multiplying Coefficient" = 0 then
                "Multiplying Coefficient" := 1;
            if "Indirect Cost %" <> 0 then
                "Unit Price" := Round("Purchase Price Base" * (1 + "Indirect Cost %" / 100) * "Multiplying Coefficient", 0.01)
            else
                "Unit Price" := Round("Purchase Price Base" * "Multiplying Coefficient", 0.01);

            Validate("Margin in %");
        end;
    end;

    local procedure RollUpPriceFTA(var RecPItem: Record 27; var BooPMonoLevel: Boolean)
    var
        RecLProductionBOMLine: Record 90;
        DecLComponentPrice: Decimal;
        RecLItem: Record 27;
    begin
        DecLComponentPrice := 0;
        RecLProductionBOMLine.Reset();
        RecLProductionBOMLine.SetRange("Parent Item No.", RecPItem."No.");
        if RecLProductionBOMLine.FindSet() then
            repeat
                if (RecLProductionBOMLine.Type = RecLProductionBOMLine.Type::Item) then
                    if RecLItem.Get(RecLProductionBOMLine."No.") then begin
                        FctCalcPurchasePriceFTA(RecLItem);
                        FctCalcSalesPriceFTA(RecLItem);
                        RecLItem.MODIFY();
                        if (RecLItem."Replenishment System" = RecLItem."Replenishment System"::Assembly) and
                            (not BooPMonoLevel) then begin
                            RollUpPriceFTA(RecLItem, BooPMonoLevel);
                            RecLItem.MODIFY();
                        end;
                        if (RecLItem."Kit - Sales Price" <> 0) and
                            (not BooPMonoLevel) then
                            DecLComponentPrice += RecLItem."Kit - Sales Price" * RecLProductionBOMLine."Quantity per"
                        else
                            DecLComponentPrice += RecLItem."Unit Price" * RecLProductionBOMLine."Quantity per";
                    end;
            until RecLProductionBOMLine.NEXT() = 0;
        GLSetup.Get();
        DecLComponentPrice := Round(DecLComponentPrice, GLSetup."Unit-Amount Rounding Precision");
        RecPItem."Kit - Sales Price" := DecLComponentPrice;
        RecPItem.MODIFY();
    end;

    var
        CduLTemplateMgt: Codeunit 8612;
        CstL001: Label 'Please enter before this opeartion the The purchase price.';
        "**FTA1.00": Integer;
        RecRef: RecordRef;
        RecLTemplateHeader: Record 8618;
        OptLItemBase: Option Standard,Transitory,"Transitory Kit";
        toto1: Text[30];
        RecLItem: Record 27;
        InvtSetup: Record 313;
        HasInvtSetup: Boolean;
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

}

