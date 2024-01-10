
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
            CalcFormula = exist("BOM Component" where("Parent Item No." = field("No.")));
            Caption = 'Kit';
            Description = 'FTA1.00';
            Editable = false;

        }
        field(50010; "Sell-to Customer No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Sell-to Customer No." where("Document Type" = field("Document Type"),
                                                                           "Document No." = field("Document No.")));
            Caption = 'Sell-to Customer No.';
            Description = 'FTA1.00';
            Editable = false;

        }
        field(50011; "Sell-to Customer Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            Description = 'FTA1.00';
            Editable = false;

        }
        field(50012; "Selected for Order"; Boolean)
        {
            Caption = 'Selected for Order';
            Description = 'FTA1.00';

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
            Description = 'FTA1.00';

            trigger OnValidate()
            var
                CstL001: Label 'The quantity to be ordered %1 is greater to the need %2';
            begin
                if ("Qty to be Ordered" <> 0) then begin
                    CALCFIELDS("Reserved Quantity");
                    if "Qty to be Ordered" > "Remaining Quantity" - "Reserved Quantity" then;
                    //ERROR(CstL001,"Qty to be Ordered","Outstanding Quantity" - "Reserved Quantity");
                end;
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
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Requested Delivery Date" where("Document Type" = field("Document Type"),
                                                                               "Document No." = field("Document No.")));
            Caption = 'Requested Delivery Date';
            Description = 'FTA1.00';
            Editable = false;

        }
        field(50017; "Promised Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Promised Delivery Date" where("Document Type" = field("Document Type"),
                                                                             "Document No." = field("Document No.")));
            Caption = 'Promised Delivery Date';
            Description = 'FTA1.00';
            Editable = false;

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
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Inventory Value Zero" where("No." = field("No.")));
            Caption = 'enu=Inventory Value Zero;fra=Exclure évaluation stock';
            Description = 'FTA1.00';

        }
        field(50030; "Item No. 2"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."No. 2" where("No." = field("No.")));
            Caption = 'Item No. 2';
            Description = 'FTA1.00';
            Editable = false;

        }
        field(50031; "Internal field"; Boolean)
        {
            Caption = 'Internal field';
            Description = 'FTA1.00';
            Editable = false;
        }
        field(50032; "Preparation Type"; enum "Preparation Type")
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Preparation Type" where("Document Type" = field("Document Type"),
                                                                      "Document No." = field("Document No.")));
            Caption = 'Preparation Type';
            Description = 'FTA1.00';


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
            TableRelation = if (Type = const(Item)) Item;
        }
        field(50044; "Originally Ordered Var. Code"; Code[10])
        {
            AccessByPermission = TableData "Item Substitution" = R;
            Caption = 'Originally Ordered Var. Code';
            Description = 'FTA1.02';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("Originally Ordered No."));
        }
        field(50045; "Level  NO."; integer)

        {
            CaptionML = ENU = 'Level No.';
            Description = 'FTA1.00 ';

        }
    }




    keys
    {

        key(Key800; "Vendor No.")
        {
        }
        key(key900; "No.", "Location Code")
        {

        }
        key(Key50; "Remaining Quantity")
        {
        }
        key(Key60; "Document Type", "Document No.", Type, "Quantity per")
        {
        }
    }




    procedure "--FTA1.00"()
    begin
    end;

    procedure FctSelectRecForOrder(var RecPKitSalesLine: Record "901")
    begin
        with RecPKitSalesLine do begin
            RESET();
            SETCURRENTKEY("Document Type", "Document No.", Type, "Quantity per");
            SETFILTER("Document Type", '%1', "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETFILTER("Quantity per", '<>0');

            if FINDSET then
                repeat
                    CALCFIELDS("Reserved Qty. (Base)");
                    if "Remaining Quantity (Base)" > "Reserved Qty. (Base)" then begin
                        "Internal field" := true;
                        if ("Qty to be Ordered" = 0) and "Selected for Order" then
                            VALIDATE("Selected for Order", true);
                    end else
                        "Internal field" := false;
                    MODIFY();
                until NEXT = 0;
            SETRANGE("Internal field", true);
        end;
    end;

    procedure FCtAutoReserveFTA()
    var
        ReservMgt: Codeunit "Reservation Management";
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

            ReservMgt.SetAssemblyLine(Rec);
            // ReservMgt.FctSetBooResaAssFTA(TRUE);  
            // TODO deux fonction a trouver
            //verifuir reservMGT
            ReservMgt.AutoReserve(FullAutoReservation, '', "Due Date", "Remaining Quantity", "Remaining Quantity (Base)");
            FIND;
            if not FullAutoReservation and (CurrFieldNo <> 0) then
                if CONFIRM(Text001, true) then begin
                    COMMIT();
                    ShowReservation();
                    FIND();
                end;
        end;
    end;

    procedure FctSelectRecForOrder2(var recKitLine: Record "901")
    begin
        with recKitLine do begin
            SETCURRENTKEY("Document Type", "Document No.", Type, "Quantity per");
            SETFILTER("Document Type", '%1', "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETFILTER("Quantity per", '<>0');
            SETFILTER("Remaining Quantity", '<>0');
            if FINDFIRST then
                repeat
                    CALCFIELDS("Reserved Qty. (Base)");
                    if "Remaining Quantity (Base)" > "Reserved Qty. (Base)" then begin
                        "Internal field" := true;
                        if ("Qty to be Ordered" = 0) and "Selected for Order" then
                            VALIDATE("Selected for Order", true);
                    end else
                        "Internal field" := false;
                    MODIFY;
                until NEXT = 0;
            SETRANGE("Internal field", true);
        end;
    end;

    procedure ExplodeAndReserveAssemblyList()
    var
        AssemblyLineManagement: Codeunit "905";
    begin

        // AssemblyLineManagement.SetAutoReserve; 
        // todo fonction spec
        AssemblyLineManagement.ExplodeAsmList(Rec);
    end;

    procedure ExplodeItemSubList(AvailableOnly: Boolean)
    var
        AssemblyLineManagement: Codeunit "905";
    begin

        //TODO ItemSubstMgt.ExplodeItemAssemblySubst(Rec, AvailableOnly, FALSE);
    end;

    local procedure "----- NDBI -----"()
    begin
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
        "**FTA1.00": Integer;
        IntGNumber: Integer;
        "--FTA": Integer;
        RecLItem: Record Item;
        RecLProductionBOMLine: Record "90";
        BoolFirstRead: Boolean;
        DecLAvailibityNoReserved: Decimal;
        DecGQtyKit: Decimal;
        RecGKitSalesLine: Record "901";
        RecGAssemLink: Record "904";
        "---- NDBI ----": Integer;
        BooGResaAssFTA: Boolean;


    // todo 106 _ 107 a ahouter linge
}

