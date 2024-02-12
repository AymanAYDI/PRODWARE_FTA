namespace Prodware.FTA;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
tableextension 50024 SalesInvoiceLine extends "Sales Invoice Line" //113
{
    fields
    {
        field(50002; "Item Base"; enum ItemBase)
        {
            Caption = 'Item Base';
        }
        field(50010; "Item No. 2"; Code[20])
        {
            CalcFormula = lookup(Item."No. 2" where("No." = field("No.")));
            Caption = 'Item No. 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Item Description 2"; Text[50])
        {
            CalcFormula = lookup(Item."Description 2" where("No." = field("No.")));
            Caption = 'Item Description 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Item Statistics Group"; Integer)
        {
            CalcFormula = lookup(Item."Statistics Group" where("No." = field("No.")));
            Caption = 'Item Statistics Group';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Item Vendor No."; Code[20])
        {
            CalcFormula = lookup(Item."Vendor No." where("No." = field("No.")));
            Caption = 'Item Vendor No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "Item Category Code 2"; Code[20])
        {
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("No.")));
            Caption = 'Item Category Code 2';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(50016; "Item Product Group Code"; Code[10])
        // {
        //     //TODO: FIELD Product Group Code removed from item a verifier
        //     //CalcFormula = lookup(Item."Product Group Code" where ("No."=field("No.")));
        //     Caption = 'Item Product Group Code';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(50016; "Parent Category Code"; Code[20])
        {
            Caption = 'Item Parent Category Code';
            Editable = false;
        }
        field(50041; Prepare; Boolean)
        {
            Caption = 'Préparé';
        }
        field(50044; "Parcel No."; Integer)
        {
            Caption = 'Parcel No.';
        }
        field(51000; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordered';
        }
        field(51001; "Qty Shipped on Order"; Decimal)
        {
            Caption = 'Qty Shipped on Order';
        }
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            var
                ItemCat: Record "Item Category";
            begin
                ItemCat.Get("Item Category Code");
                Rec."Parent Category Code" := ItemCat."Parent Category";
                Rec.Modify();  //TODO : verifier ,c'est pour remplacer product group
            end;
        }
    }


}

