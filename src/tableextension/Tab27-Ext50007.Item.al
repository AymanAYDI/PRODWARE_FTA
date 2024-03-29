namespace Prodware.FTA;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;
using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Setup;
using Microsoft.Finance.GeneralLedger.Setup;
using System.Security.AccessControl;
using Microsoft.Purchases.Pricing;
using Microsoft.Sales.Pricing;
using Microsoft.Sales.Setup;
using Microsoft.Purchases.History;
using Microsoft.Manufacturing.ProductionBOM;
using System.IO;
using Microsoft.Inventory.BOM;
using Microsoft.Foundation.UOM;
using Microsoft.Integration.Dataverse;
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
                RecLPurchPrice: Record "Purchase Price";
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TestField("Vendor No.");
                    TestField("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.findFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Modify(true);
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
                RecLSalesLineDisc: Record "Sales Line Discount";
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
                                                                            "Shipment Date" = field("Date Filter"),
                                                                            "Preparation Type" = const(Stock)));
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
                RecLSalesLineDisc: Record "Sales Line Discount";
                RecLSalesReceiveSetup: Record "Sales & Receivables Setup";
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
                        else

                            if RecLSalesReceiveSetup."Discount All Item" <> '' then begin
                                RecLSalesLineDisc.Reset();
                                RecLSalesLineDisc.SetRange(Type, RecLSalesLineDisc.Type::"Item Disc. Group");
                                RecLSalesLineDisc.SetRange(Code, RecLSalesReceiveSetup."Discount All Item");
                                RecLSalesLineDisc.SetRange("Sales Type", RecLSalesLineDisc."Sales Type"::Customer);
                                RecLSalesLineDisc.SetRange("Sales Code", "Customer Code");
                                if RecLSalesLineDisc.FindSet() then
                                    if RecLSalesLineDisc."Line Discount %" <> 0 then
                                        "Unit Price net" := "Unit Price net" * (1 - (RecLSalesLineDisc."Line Discount %" / 100));
                            end;

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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            TableRelation = "Work Time";
        }
        field(50018; "Item Machining Time"; Integer)
        {
            BlankZero = true;
            Caption = 'Temps d''usinage';
            TableRelation = "Work Time";
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
                RecLPurchPrice: Record "Purchase Price";
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TestField("Vendor No.");
                    TestField("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.findFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Modify(true);
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
                RecLPurchPrice: Record "Purchase Price";
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TestField("Vendor No.");
                    TestField("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.findFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Modify(true);
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
                RecLPurchPrice: Record "Purchase Price";
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TestField("Vendor No.");
                    TestField("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.findFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Modify(true);
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
                RecLPurchPrice: Record "Purchase Price";
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TestField("Vendor No.");
                    TestField("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.findFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Modify(true);
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
                RecLPurchPrice: Record "Purchase Price";
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TestField("Vendor No.");
                    TestField("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.findFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Modify(true);
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
                RecLPurchPrice: Record "Purchase Price";
            begin
                if ("Item Base" = "Item Base"::Transitory) then begin
                    TestField("Vendor No.");
                    TestField("Base Unit of Measure");
                    RecLPurchPrice.SetRange("Item No.", "No.");
                    RecLPurchPrice.SetRange("Vendor No.", "Vendor No.");
                    RecLPurchPrice.SetRange("Unit of Measure Code", "Base Unit of Measure");
                    if RecLPurchPrice.findFirst() then begin
                        RecLPurchPrice.Validate("Direct Unit Cost", "Purchase Price Base");
                        RecLPurchPrice.Modify(true);
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
            TableRelation = User."User Name";
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Search Description", "Inventory")
        {

        }
    }
    procedure FctCalcPurchasePriceFTA(var RecPItem: Record Item)
    var
        ItemProductionCost: Record "Item Production Cost";
        RecLProductionBOMLine: Record "Production BOM Line";
        RecLPurchLineDisc: Record "Purchase Line Discount";
        RecLPurchPrice: Record "Purchase Price";
        BooLQtyFound: Boolean;
        BooLRecOK: Boolean;
        DecLCost: Decimal;
        DecLDisc: Decimal;
        DecLQty: Decimal;

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
                    if (RecLPurchPrice."Starting Date" <> 0D) and (WorkDate() < RecLPurchPrice."Starting Date") then
                        BooLRecOK := false;
                    if (RecLPurchPrice."Ending Date" <> 0D) and (WorkDate() > RecLPurchPrice."Ending Date") then
                        BooLRecOK := false;
                    if (BooLRecOK = true) and (RecLPurchPrice."Minimum Quantity" <= DecLQty) then begin
                        DecLQty := RecLPurchPrice."Minimum Quantity";
                        DecLCost := RecLPurchPrice."Direct Unit Cost";
                    end;
                until RecLPurchPrice.Next() = 0;
            RecLPurchLineDisc.Reset();
            RecLPurchLineDisc.SetRange("Item No.", "No.");
            RecLPurchLineDisc.SetRange("Vendor No.", "Vendor No.");
            if RecLPurchLineDisc.FindSet() then
                repeat
                    BooLRecOK := true;
                    if ("Purch. Unit of Measure" <> RecLPurchLineDisc."Unit of Measure Code") and
                         (RecLPurchLineDisc."Unit of Measure Code" <> '') then
                        BooLRecOK := false;
                    if (RecLPurchLineDisc."Starting Date" <> 0D) and (WorkDate() < RecLPurchLineDisc."Starting Date") then
                        BooLRecOK := false;
                    if (RecLPurchLineDisc."Ending Date" <> 0D) and (WorkDate() > RecLPurchLineDisc."Ending Date") then
                        BooLRecOK := false;
                    if (BooLRecOK = true) and (RecLPurchLineDisc."Minimum Quantity" <= DecLQty) or
                       (BooLRecOK = true) and (DecLQty = 0) and (RecLPurchLineDisc."Minimum Quantity" = 1) then
                        DecLDisc := RecLPurchLineDisc."Line Discount %";

                until RecLPurchLineDisc.Next() = 0;

            if DecLDisc <> 0 then
                "Purchase Price Base" := Round(DecLCost * (1 - (DecLDisc / 100)), 0.01)
            else
                "Purchase Price Base" := DecLCost;
            ItemProductionCost.Reset();
            ItemProductionCost.SetRange("Item No.", "No.");
            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 0);
            if ItemProductionCost.findFirst() then
                "Purchase Price Base 1" := ItemProductionCost."Unit Cost";

            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 2);
            if ItemProductionCost.findFirst() then
                "Purchase Price Base 2" := ItemProductionCost."Unit Cost";

            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 5);
            if ItemProductionCost.findFirst() then
                "Purchase Price Base 5" := ItemProductionCost."Unit Cost";

            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 10);
            if ItemProductionCost.findFirst() then
                "Purchase Price Base 10" := ItemProductionCost."Unit Cost";

            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 25);
            if ItemProductionCost.findFirst() then
                "Purchase Price Base 25" := ItemProductionCost."Unit Cost";

            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty");
            ItemProductionCost.SetRange(ItemProductionCost."Sales Min Qty", 50);
            if ItemProductionCost.findFirst() then
                "Purchase Price Base 50" := ItemProductionCost."Unit Cost";

            Validate("Margin in %");
        end;
    end;

    procedure FctCalcKitPriceFTA(var RecPItem: Record Item; var BooPMonoLevel: Boolean)
    var
        RecLItem: Record Item;
    begin
        RecPItem.CalcFields(RecPItem."Assembly BOM");
        if not RecPItem."Assembly BOM" then begin
            RecPItem."Kit - Sales Price" := 0;
            exit;
        end;
        RollUpPriceFTA(RecPItem, BooPMonoLevel);
        RecPItem.Modify();
    end;

    procedure FctCreateFromTemplate()
    var
        InvtSetup: Record "Inventory Setup";
        RecLItemUnitofMeasure: Record "Item Unit of Measure";
        RecLTemplateHeader: Record "Config. Template Header";
        RecLTemplateLine: Record "Config. Template Line";
        CduLTemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
    begin
        if "Item Base" = "Item Base"::Transitory then begin
            GetInvtSetup();
            // if not RecItem.HasInvtSetup then begin
            //     InventorySetup.Get();
            //     HasInvtSetup := true;
            // end;
            RecRef.GetTable(Rec);
            InvtSetup.TestField("Template Item Transitory Code");
            RecLTemplateHeader.Get(InvtSetup."Template Item Transitory Code");
            RecLTemplateLine.SetRange("Data Template Code", InvtSetup."Template Item Transitory Code");
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
        if "Item Base" = "Item Base"::"Transitory Kit" then begin
            GetInvtSetup();
            RecRef.GetTable(Rec);
            InvtSetup.TestField("Template Item Trans. Kit Code");
            RecLTemplateHeader.Get(InvtSetup."Template Item Trans. Kit Code");
            RecLTemplateLine.SetRange("Data Template Code", InvtSetup."Template Item Trans. Kit Code");
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
            InvtSetup.TestField(InvtSetup."Template Item Bored block Code");
            RecLTemplateHeader.Get(InvtSetup."Template Item Bored block Code");
            RecLTemplateLine.SetRange("Data Template Code", InvtSetup."Template Item Bored block Code");
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

    procedure FctBOM(var RecPItem: Record Item)
    var
        RecLBOMComponent: Record "BOM Component";
        FrmLKitBOM: Page "Assembly BOM";
        CstL001: Label 'This item does not have a BOM, do you want to create one?';
    begin
        RecPItem.CalcFields("Assembly BOM");
        if not RecPItem."Assembly BOM" then
            if not Confirm(CstL001, true) then
                exit;

        Clear(FrmLKitBOM);
        RecLBOMComponent.FILTERGROUP(2);
        RecLBOMComponent.SetRange("Parent Item No.", RecPItem."No.");
        RecLBOMComponent.FILTERGROUP(0);
        FrmLKitBOM.SetTableView(RecLBOMComponent);
        FrmLKitBOM.Run();

    end;

    procedure FctCalcSalesPriceFTA(var RecPItem: Record Item)
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

    local procedure RollUpPriceFTA(var RecPItem: Record Item; var BooPMonoLevel: Boolean)
    var
        GLSetup: Record "General Ledger Setup";
        RecLItem: Record Item;
        RecLProductionBOMLine: Record "BOM Component";
        DecLComponentPrice: Decimal;
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
                        RecLItem.Modify();
                        if (RecLItem."Replenishment System" = RecLItem."Replenishment System"::Assembly) and
                            (not BooPMonoLevel) then begin
                            RollUpPriceFTA(RecLItem, BooPMonoLevel);
                            RecLItem.Modify();
                        end;
                        if (RecLItem."Kit - Sales Price" <> 0) and
                            (not BooPMonoLevel) then
                            DecLComponentPrice += RecLItem."Kit - Sales Price" * RecLProductionBOMLine."Quantity per"
                        else
                            DecLComponentPrice += RecLItem."Unit Price" * RecLProductionBOMLine."Quantity per";
                    end;
            until RecLProductionBOMLine.Next() = 0;
        GLSetup.Get();
        DecLComponentPrice := Round(DecLComponentPrice, GLSetup."Unit-Amount Rounding Precision");
        RecPItem."Kit - Sales Price" := DecLComponentPrice;
        RecPItem.Modify();
    end;

    //TODO -> Verifier
    procedure GetInvtSetup()
    begin
        if not HasInvtSetup then begin
            InventorySetup.Get();
            HasInvtSetup := true;
        end;
    end;

    procedure UpdateItemUnitGroup()
    var
#if not CLEAN21
#pragma warning disable AL0432
#endif
        UnitGroup: Record "Unit Group";
#if not CLEAN21
#pragma warning restore AL0432
#endif
        CRMIntegrationManagement: Codeunit FTA_Functions;
    begin
        if CRMIntegrationManagement.IsIntegrationEnabled() then begin
            UnitGroup.SetRange("Source Id", Rec.SystemId);
            UnitGroup.SetRange("Source Type", UnitGroup."Source Type"::Item);
            if UnitGroup.IsEmpty() then begin
                UnitGroup.Init();
                UnitGroup."Source Id" := Rec.SystemId;
                UnitGroup."Source No." := Rec."No.";
                UnitGroup."Source Type" := UnitGroup."Source Type"::Item;
                UnitGroup.Insert();
            end;
        end
    end;


    var
        InventorySetup: Record "Inventory Setup";
        HasInvtSetup: Boolean;




}

