namespace Prodware.FTA;

using Microsoft.Sales.Customer;
using Microsoft.Sales.History;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Inventory.Location;
using Microsoft.Finance.Dimension;
using Microsoft.Sales.Pricing;
using Microsoft.Projects.Project.Job;
using Microsoft.Utilities;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Inventory.Intrastat;
using Microsoft.Finance.SalesTax;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Document;
using Microsoft.Warehouse.Structure;
using Microsoft.Foundation.UOM;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Foundation.AuditCodes;
table 60111 "Sales Shipment Liness"
{
    Caption = 'Sales Shipment Line';
    LookupPageID = "Posted Sales Shipment Lines";
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Value Entry" = r;

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Shipment Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; enum "SalesShipmentLinessType")
        {
            Caption = 'Type';
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account" else
            if (Type = const(Item)) Item else
            if (Type = const(Resource)) Resource else
            if (Type = const("Fixed Asset")) "Fixed Asset" else
            if (Type = const("Charge (Item)")) "Item Charge";
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(8; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = if (Type = const(Item)) "Inventory Posting Group" else
            if (Type = const("Fixed Asset")) "FA Posting Group";
        }
        field(10; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(34; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
        }
        field(38; "Appl.-to Item Entry"; Integer)
        {
            Caption = 'Appl.-to Item Entry';
        }
        field(39; "Item Shpt. Entry No."; Integer)
        {
            Caption = 'Item Shpt. Entry No.';
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(42; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(45; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(52; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(58; "Qty. Shipped Not Invoiced"; Decimal)
        {
            Caption = 'Qty. Shipped Not Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(65; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(66; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(71; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(72; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
        }
        field(73; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
        }
        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(78; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(79; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(80; "Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            TableRelation = "Sales Shipment Line"."Line No." where("Document No." = field("Document No."));
        }
        field(81; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(82; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(83; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(87; "Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(89; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(91; "Currency Code"; Code[10])
        {
            CalcFormula = lookup("Sales Shipment Header"."Currency Code" where("No." = field("Document No.")));
            Caption = 'Currency Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(97; "Blanket Order No."; Code[20])
        {
            Caption = 'Blanket Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const("Blanket Order"));
        }
        field(98; "Blanket Order Line No."; Integer)
        {
            Caption = 'Blanket Order Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = const("Blanket Order"), "Document No." = field("Blanket Order No."));
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100; "Unit Cost"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(131; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Editable = false;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(1002; "Job Contract Entry No."; Integer)
        {
            Caption = 'Job Contract Entry No.';
            Editable = false;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"), "Item Filter" = field("No."), "Variant Filter" = field("Variant Code"));
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No.")) else
            "Unit of Measure";
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5461; "Qty. Invoiced (Base)"; Decimal)
        {
            Caption = 'Qty. Invoiced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5600; "FA Posting Date"; Date)
        {
            Caption = 'FA Posting Date';
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5605; "Depr. until FA Posting Date"; Boolean)
        {
            Caption = 'Depr. until FA Posting Date';
        }
        field(5612; "Duplicate in Depreciation Book"; Code[10])
        {
            Caption = 'Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";
        }
        field(5613; "Use Duplication List"; Boolean)
        {
            Caption = 'Use Duplication List';
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5705; "Cross-Reference No."; Code[20])
        {
            Caption = 'Cross-Reference No.';
        }
        field(5706; "Unit of Measure (Cross Ref.)"; Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5707; "Cross-Reference Type"; Enum "Cross-ReferenceType")
        {
            Caption = 'Cross-Reference Type';
        }
        field(5708; "Cross-Reference Type No."; Code[30])
        {
            Caption = 'Cross-Reference Type No.';
        }
        field(5709; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = if (Type = const(Item)) "Item Category";
        }
        field(5710; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
        }
        field(5711; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5712; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            //TODO: Table Product Group removed 
            // TableRelation = "Product Group".Code WHERE ("Item Category Code"=FIELD("Item Category Code"));
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            Editable = false;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            Editable = false;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(5794; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
            Editable = false;
        }
        field(5795; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';
            Editable = false;
        }
        field(5811; "Appl.-from Item Entry"; Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;
        }
        field(5812; "Item Charge Base Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            Caption = 'Item Charge Base Amount';
        }
        field(5817; Correction; Boolean)
        {
            Caption = 'Correction';
            Editable = false;
        }
        field(6608; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(25000; "Kit Item"; Boolean)
        {
            Caption = 'Kit Item';
        }
        field(25001; "Build Kit"; Boolean)
        {
            Caption = 'Build Kit';
        }
        field(51000; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordered';
            Description = 'NAVEASY.001 [Gestion_Reliquat] Ajout du champ';
        }
        field(51001; "Qty Shipped on Order"; Decimal)
        {
            Caption = 'Qty Shipped on Order';
            Description = 'NAVEASY.001 [Gestion_Reliquat] Ajout du champ';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Order No.", "Order Line No.")
        {
        }
        key(Key3; "Blanket Order No.", "Blanket Order Line No.")
        {
        }
        key(Key4; "Item Shpt. Entry No.")
        {
        }
        key(Key5; "Sell-to Customer No.")
        {
        }
        key(Key6; "Bill-to Customer No.")
        {
        }
        key(Key7; "Shortcut Dimension 1 Code", "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServItem: Record "Service Item";
        SalesDocLineComments: Record "Sales Comment Line";
    begin
        //TODO: DeletePostedDocDim not found in codeunit DimMgt
        // DimMgt.DeletePostedDocDim(DATABASE::"Sales Shipment Line", "Document No.", "Line No.");

        ServItem.RESET();
        ServItem.SETCURRENTKEY("Sales/Serv. Shpt. Document No.", "Sales/Serv. Shpt. Line No.");
        ServItem.SETRANGE("Sales/Serv. Shpt. Document No.", "Document No.");
        ServItem.SETRANGE("Sales/Serv. Shpt. Line No.", "Line No.");
        ServItem.SETRANGE("Shipment Type", ServItem."Shipment Type"::Sales);
        if ServItem.FIND('-') then
            repeat
                ServItem.VALIDATE("Sales/Serv. Shpt. Document No.", '');
                ServItem.VALIDATE("Sales/Serv. Shpt. Line No.", 0);
                ServItem.MODIFY(true);
            until ServItem.NEXT() = 0;

        SalesDocLineComments.SETRANGE("Document Type", SalesDocLineComments."Document Type"::Shipment);
        SalesDocLineComments.SETRANGE("No.", "Document No.");
        SalesDocLineComments.SETRANGE("Document Line No.", "Line No.");
        if not SalesDocLineComments.ISEMPTY then
            SalesDocLineComments.DELETEALL();
    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";
        DimMgt: codeunit DimensionManagement;

    procedure GetCurrencyCode(): Code[10]
    begin
        if "Document No." = SalesShptHeader."No." then
            exit(SalesShptHeader."Currency Code");
        if SalesShptHeader.GET("Document No.") then
            exit(SalesShptHeader."Currency Code");
        exit('');
    end;

    procedure GetSalesInvLines(var TempSalesInvLine: Record "Sales Invoice Line" temporary)
    var
        SalesInvLine: Record "Sales Invoice Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        TempSalesInvLine.RESET();
        TempSalesInvLine.DELETEALL();

        if Type <> Type::Item then
            exit;

        FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
        ItemLedgEntry.SETFILTER("Invoiced Quantity", '<>0');
        if ItemLedgEntry.FINDSET() then begin
            ValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
            ValueEntry.SETRANGE("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
            ValueEntry.SETFILTER("Invoiced Quantity", '<>0');
            repeat
                ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                if ValueEntry.FINDSET() then
                    repeat
                        if ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" then
                            if SalesInvLine.GET(ValueEntry."Document No.", ValueEntry."Document Line No.") then begin
                                TempSalesInvLine.INIT();
                                TempSalesInvLine := SalesInvLine;
                                if TempSalesInvLine.INSERT() then;
                            end;
                    until ValueEntry.NEXT() = 0;
            until ItemLedgEntry.NEXT() = 0;
        end;
    end;

    procedure FilterPstdDocLnItemLedgEntries(var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        ItemLedgEntry.RESET();
        ItemLedgEntry.SETCURRENTKEY("Document No.");
        ItemLedgEntry.SETRANGE("Document No.", "Document No.");
        ItemLedgEntry.SETRANGE("Document Type", ItemLedgEntry."Document Type"::"Sales Shipment");
        ItemLedgEntry.SETRANGE("Document Line No.", "Line No.");
    end;

}

