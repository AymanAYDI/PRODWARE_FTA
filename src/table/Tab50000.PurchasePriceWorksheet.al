namespace Prodware.FTA;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Finance.Currency;
using Microsoft.Purchases.Pricing;
table 50000 "Purchase Price Worksheet"
{
    Caption = 'Purchase Price Worksheet';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                if "Item No." <> xRec."Item No." then begin
                    "Unit of Measure Code" := '';
                    "Variant Code" := '';
                end;
            end;
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if Vend.Get("Vendor No.") then
                    "Currency Code" := Vend."Currency Code";
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            var
                Text000: Label '%1 ne peut pas être postérieur(e) à %2';
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" <> 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));
            end;
        }
        field(5; "Current Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Current Unit Cost';
            Editable = false;
            MinValue = 0;
        }
        field(6; "New Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'New Unit Price';
            MinValue = 0;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                Validate("Starting Date");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(50000; "Item Description"; Text[50])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Item No. 2"; Code[20])
        {
            CalcFormula = lookup(Item."No. 2" where("No." = field("Item No.")));
            Caption = 'No. 2';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Starting Date", "Ending Date", "Vendor No.", "Currency Code", "Item No.", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Starting Date", "Ending Date", "Vendor No.", "Currency Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    begin
        TestField("Item No.");
    end;

    procedure CalcCurrentPrice(var PriceAlreadyExists: Boolean)
    var
        PurchPrice: Record "Purchase Price";
    begin
        PurchPrice.SetRange("Item No.", "Item No.");
        PurchPrice.SetRange("Currency Code", "Currency Code");
        PurchPrice.SetRange("Unit of Measure Code", "Unit of Measure Code");
        PurchPrice.SetRange("Starting Date", 0D, "Starting Date");
        PurchPrice.SetRange("Minimum Quantity", 0, "Minimum Quantity");
        PurchPrice.SetRange("Variant Code", "Variant Code");
        if PurchPrice.FindLast() then begin
            "Current Unit Cost" := PurchPrice."Direct Unit Cost";
            PriceAlreadyExists := PurchPrice."Starting Date" = "Starting Date";
        end else begin
            "Current Unit Cost" := 0;
            PriceAlreadyExists := false;
        end;
    end;
}

