namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Inventory.BOM;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Substitution;
using Microsoft.Inventory.Tracking;
tableextension 50089 AssemblyLine extends "Assembly Line"//901
{
    fields
    {

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if "No." <> xRec."No." then begin
                    "Originally Ordered No." := '';
                    "Originally Ordered Var. Code" := '';
                end;
                if Type = Type::Item then
                    RecLItem.SETFILTER("Location Filter", "Location Code");
                if RecLItem.GET("No.") then
                    "Vendor No." := RecLItem."Vendor No.";
                RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
                DecGQtyKit := 0;
                RecGKitSalesLine.SETRANGE("Document Type", RecGKitSalesLine."Document Type"::Order);
                RecGKitSalesLine.SETRANGE(Type, RecGKitSalesLine.Type::Item);
                RecGKitSalesLine.SETRANGE("No.", "No.");
                RecGKitSalesLine.SETFILTER("Remaining Quantity (Base)", '<>0');


                if not RecGKitSalesLine.ISEMPTY then begin
                    RecGKitSalesLine.FINDSET();
                    repeat
                        if RecGAssemLink.GET(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.") then
                            if (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") or (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") then
                                DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
                    until RecGKitSalesLine.NEXT() = 0;
                end;
                "Avaibility no reserved" := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + DecGQtyKit)
                                                                                        + RecLItem."Reserved Qty. on Purch. Orders";
                RecLItem.CALCFIELDS("Assembly BOM");
                if RecLItem."Assembly BOM" then
                    "Kit Qty Available by Assembly" := 0
                else begin
                    "Kit Qty Available by Assembly" := 0;
                    BoolFirstRead := false;
                    RecLProductionBOMLine.RESET();
                    RecLProductionBOMLine.SETRANGE("Parent Item No.", RecLItem."No.");
                    if RecLProductionBOMLine.FINDSET() then
                        repeat
                            if (RecLProductionBOMLine.Type = RecLProductionBOMLine.Type::Item) then
                                if RecLItem.GET(RecLProductionBOMLine."No.") then begin
                                    RecLItem.SETFILTER("Location Filter", "Location Code");
                                    RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
                                    DecGQtyKit := 0;
                                    RecGKitSalesLine.SETRANGE("Document Type", RecGKitSalesLine."Document Type"::Order);
                                    RecGKitSalesLine.SETRANGE(Type, RecGKitSalesLine.Type::Item);
                                    RecGKitSalesLine.SETRANGE("No.", "No.");
                                    RecGKitSalesLine.SETFILTER(RecGKitSalesLine."Remaining Quantity (Base)", '<>0');
                                    RecGAssemLink.GET(RecGKitSalesLine."Document Type", RecGKitSalesLine."Document No.");
                                    if not RecGKitSalesLine.ISEMPTY then begin
                                        RecGKitSalesLine.FINDSET();
                                        repeat
                                            if (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") or (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") then
                                                DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
                                        until RecGKitSalesLine.NEXT() = 0;
                                    end;
                                    DecLAvailibityNoReserved := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + DecGQtyKit) +
                                       RecLItem."Reserved Qty. on Purch. Orders";

                                    if not BoolFirstRead then
                                        "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<')
                                    else
                                        if ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<') < "Kit Qty Available by Assembly" then
                                            "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per", 1, '<');
                                    BoolFirstRead := true;
                                end;
                        until RecLProductionBOMLine.NEXT() = 0;
                end;
            end;
        }
        field(50000; "Kit BOM No."; Code[20])
        {
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

            FieldClass = FlowField;
            CalcFormula = exist("BOM Component" where("Parent Item No." = field("No.")));
            Caption = 'Kit';
            Editable = false;

        }
        field(50010; "Sell-to Customer No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Sell-to Customer No." where("Document Type" = field("Document Type"),
                                                                           "Document No." = field("Document No.")));
            Caption = 'Sell-to Customer No.';
            Editable = false;

        }
        field(50011; "Sell-to Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            Editable = false;

        }
        field(50012; "Selected for Order"; Boolean)
        {
            Caption = 'Selected for Order';

            trigger OnValidate()
            begin
                if "Selected for Order" and ("Qty to be Ordered" = 0) then begin
                    CALCFIELDS("Reserved Quantity");
                    "Qty to be Ordered" := "Remaining Quantity" - "Reserved Quantity";
                end;
                if not "Selected for Order" then
                    "Qty to be Ordered" := 0;
            end;
        }
        field(50013; "Qty to be Ordered"; Decimal)
        {
            Caption = 'Qty to be Ordered';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if ("Qty to be Ordered" <> 0) then begin
                    CALCFIELDS("Reserved Quantity");
                    if "Qty to be Ordered" > "Remaining Quantity" - "Reserved Quantity" then;
                end;
            end;
        }
        field(50014; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(50016; "Requested Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Requested Delivery Date" where("Document Type" = field("Document Type"),
                                                                               "Document No." = field("Document No.")));
            Caption = 'Requested Delivery Date';
            Editable = false;

        }
        field(50017; "Promised Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Promised Delivery Date" where("Document Type" = field("Document Type"),
                                                                             "Document No." = field("Document No.")));
            Caption = 'Promised Delivery Date';
            Editable = false;

        }
        field(50020; "Qty Not Assign FTA"; Decimal)
        {
            Caption = 'Qty. to Assign FTA';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50023; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
        }
        field(50024; "Inventory Value Zero"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Inventory Value Zero" where("No." = field("No.")));
            Caption = 'Inventory Value Zero';

        }
        field(50030; "Item No. 2"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."No. 2" where("No." = field("No.")));
            Caption = 'Item No. 2';
            Editable = false;

        }
        field(50031; "Internal field"; Boolean)
        {
            Caption = 'Internal field';
            Editable = false;
        }
        field(50032; "Preparation Type"; enum "Preparation Type")
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Preparation Type" where("Document Type" = field("Document Type"),
                                                                      "Document No." = field("Document No.")));
            Caption = 'Preparation Type';


        }
        field(50033; "x Outstanding Quantity"; Decimal)
        {
            Caption = 'x Outstanding Quantity';
            Editable = false;
        }
        field(50034; "x Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'x Outstanding Qty. (Base)';
            Editable = false;
        }
        field(50043; "Originally Ordered No."; Code[20])
        {
            AccessByPermission = TableData "Item Substitution" = R;
            Caption = 'Originally Ordered No.';
            TableRelation = if (Type = const(Item)) Item;
        }
        field(50044; "Originally Ordered Var. Code"; Code[10])
        {
            AccessByPermission = TableData "Item Substitution" = R;
            Caption = 'Originally Ordered Var. Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("Originally Ordered No."));
        }
        field(50045; "Level  NO."; integer)

        {
            Caption = 'Level No.';
        }
    }




    keys
    {
        //TODO : cannot be used for filds standard et spe
        // key(key50000;Type,"No.";SumIndexFields = "x Outstanding Quantity")
        // {

        // }
        // key(key50000; "Vendor No.","No.", "Location Code")
        // {

        // }
        key(Key50; "Remaining Quantity")
        {
        }
        key(Key60; "Document Type", "Document No.", Type, "Quantity per")
        {
        }
    }

    procedure FctSelectRecForOrder(var RecPKitSalesLine: Record 901)
    begin
        with RecPKitSalesLine do begin
            RESET();
            SETCURRENTKEY("Document Type", "Document No.", Type, "Quantity per");
            SETFILTER("Document Type", '%1', "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETFILTER("Quantity per", '<>0');

            if FINDSET() then
                repeat
                    CALCFIELDS("Reserved Qty. (Base)");
                    if "Remaining Quantity (Base)" > "Reserved Qty. (Base)" then begin
                        "Internal field" := true;
                        if ("Qty to be Ordered" = 0) and "Selected for Order" then
                            VALIDATE("Selected for Order", true);
                    end else
                        "Internal field" := false;
                    MODIFY();
                until NEXT() = 0;
            SETRANGE("Internal field", true);
        end;
    end;

    procedure FCtAutoReserveFTA()
    var
        ReservMgt: Codeunit "Reservation Management";
        FTAFunctions: Codeunit FTA_Functions;
        FullAutoReservation: Boolean;
        Text001: Label 'Automatic reservation is not possible.\Do you want to reserve items manually?';
    // todo a verifier
    begin
        if Type <> Type::Item then
            exit;

        TESTFIELD("No.");

        //IF Reserve <> Reserve::Always THEN
        //  EXIT;

        if "Remaining Quantity (Base)" <> 0 then begin
            if "Quantity per" <> 0 then
                TESTFIELD("Due Date");
            //TODO verifier,remplacer SetAssemblyLine par SetSourceForAssemblyLine & dupliquer SetSourceForAssemblyLine dans FTA functions
            FTAFunctions.SetSourceForAssemblyLine();
            // if BooGResaAssFTA then
            //     ReservMgt.FctSetBooResaAssFTA(true);
            ReservMgt.AutoReserve(FullAutoReservation, '', "Due Date", "Remaining Quantity", "Remaining Quantity (Base)");
            FIND();
            if not FullAutoReservation and (CurrFieldNo <> 0) then
                if CONFIRM(Text001, true) then begin
                    COMMIT();
                    ShowReservation();
                    FIND();
                end;
        end;
    end;

    procedure FctSelectRecForOrder2(var recKitLine: Record 901)
    begin
        with recKitLine do begin
            SETCURRENTKEY("Document Type", "Document No.", Type, "Quantity per");
            SETFILTER("Document Type", '%1', "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETFILTER("Quantity per", '<>0');
            SETFILTER("Remaining Quantity", '<>0');
            if FINDFIRST() then
                repeat
                    CALCFIELDS("Reserved Qty. (Base)");
                    if "Remaining Quantity (Base)" > "Reserved Qty. (Base)" then begin
                        "Internal field" := true;
                        if ("Qty to be Ordered" = 0) and "Selected for Order" then
                            VALIDATE("Selected for Order", true);
                    end else
                        "Internal field" := false;
                    MODIFY();
                until NEXT() = 0;
            SETRANGE("Internal field", true);
        end;
    end;

    procedure ExplodeAndReserveAssemblyList()
    var
        AssemblyLineManagement: Codeunit 905;
        FTAFunctions: Codeunit FTA_Functions;
    begin

        FTAFunctions.SetAutoReserve();
        AssemblyLineManagement.ExplodeAsmList(Rec);
    end;

    procedure ExplodeItemSubList(AvailableOnly: Boolean)
    var
        FTAFunctions: Codeunit FTA_Functions;

    begin

        FTAFunctions.ExplodeItemAssemblySubst(Rec, AvailableOnly, false);
    end;

    procedure FctSetBooResaAssFTA(BooPResaAssFTA: Boolean)
    begin
        BooGResaAssFTA := BooPResaAssFTA;
    end;

    trigger OnAfterModify()
    begin
        IntGNumber := FIELDNO("Internal field");
        if (IntGNumber <> 50031) and
           (IntGNumber <> 50013) and
           (IntGNumber <> 50014) then begin

        end;

    end;

    var
        IntGNumber: Integer;
        RecLItem: Record Item;
        RecLProductionBOMLine: Record 90;
        BoolFirstRead: Boolean;
        DecLAvailibityNoReserved: Decimal;
        DecGQtyKit: Decimal;
        RecGKitSalesLine: Record 901;
        RecGAssemLink: Record 904;
        BooGResaAssFTA: Boolean;


    // todo 106 _ 107 a ahouter linge
}

