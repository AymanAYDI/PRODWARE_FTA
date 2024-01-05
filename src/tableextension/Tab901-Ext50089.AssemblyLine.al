
namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Inventory.BOM;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
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
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Sell-to Customer No." WHERE("Document Type" = FIELD("Document Type"),
                                                                           "Document No." = FIELD("Document No.")));
            Caption = 'Sell-to Customer No.';
            Description = 'FTA1.00';
            Editable = false;

        }
        field(50011; "Sell-to Customer Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sell-to Customer No.")));
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
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Requested Delivery Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                               "Document No." = FIELD("Document No.")));
            Caption = 'Requested Delivery Date';
            Description = 'FTA1.00';
            Editable = false;

        }
        field(50017; "Promised Delivery Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Promised Delivery Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                             "Document No." = FIELD("Document No.")));
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
            CalcFormula = Lookup(Item."Inventory Value Zero" WHERE("No." = FIELD("No.")));
            Caption = 'enu=Inventory Value Zero;fra=Exclure évaluation stock';
            Description = 'FTA1.00';

        }
        field(50030; "Item No. 2"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."No. 2" WHERE("No." = FIELD("No.")));
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
            CalcFormula = Lookup("Sales Line"."Preparation Type" WHERE("Document Type" = FIELD("Document Type"),
                                                                      "Document No." = FIELD("Document No.")));
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
            AccessByPermission = TableData 5715 = R;
            Caption = 'Originally Ordered No.';
            Description = 'FTA1.02';
            TableRelation = IF (Type = CONST(Item)) Item;
        }
        field(50044; "Originally Ordered Var. Code"; Code[10])
        {
            AccessByPermission = TableData 5715 = R;
            Caption = 'Originally Ordered Var. Code';
            Description = 'FTA1.02';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("Originally Ordered No."));
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
        WITH RecPKitSalesLine DO BEGIN
            RESET;
            SETCURRENTKEY("Document Type", "Document No.", Type, "Quantity per");
            SETFILTER("Document Type", '%1', "Document Type"::Order);
            SETRANGE(Type, Type::Item);
            SETFILTER("Quantity per", '<>0');

            IF FINDSET THEN
                REPEAT
                    CALCFIELDS("Reserved Qty. (Base)");
                    IF "Remaining Quantity (Base)" > "Reserved Qty. (Base)" THEN BEGIN
                        "Internal field" := TRUE;
                        IF ("Qty to be Ordered" = 0) AND "Selected for Order" THEN
                            VALIDATE("Selected for Order", TRUE);
                    END ELSE
                        "Internal field" := FALSE;
                    MODIFY();
                UNTIL NEXT = 0;
            SETRANGE("Internal field", TRUE);
        END;
    end;

    procedure FCtAutoReserveFTA()
    var
        ReservMgt: Codeunit 99000845;
        FullAutoReservation: Boolean;
        Text001: Label 'Automatic reservation is not possible.\Do you want to reserve items manually?';
    // todo a verifier
    begin
        IF Type <> Type::Item THEN
            EXIT;

        TESTFIELD("No.");

        //IF Reserve <> Reserve::Always THEN
        //  EXIT;

        IF "Remaining Quantity (Base)" <> 0 THEN BEGIN
            IF "Quantity per" <> 0 THEN BEGIN
                TESTFIELD("Due Date");

                // ReservMgt.SetAssemblyLine(Rec);


                // ReservMgt.FctSetBooResaAssFTA(TRUE);  
                // TODO deux fonction a trouver
                //verifuir reservMGT


                ReservMgt.AutoReserve(FullAutoReservation, '', "Due Date", "Remaining Quantity", "Remaining Quantity (Base)");
                FIND;
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
            IF FINDFIRST THEN
                REPEAT
                    CALCFIELDS("Reserved Qty. (Base)");
                    IF "Remaining Quantity (Base)" > "Reserved Qty. (Base)" THEN BEGIN
                        "Internal field" := TRUE;
                        IF ("Qty to be Ordered" = 0) AND "Selected for Order" THEN
                            VALIDATE("Selected for Order", TRUE);
                    END ELSE
                        "Internal field" := FALSE;
                    MODIFY;
                UNTIL NEXT = 0;
            SETRANGE("Internal field", TRUE);
        END;
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
        IF (IntGNumber <> 50031) AND
           (IntGNumber <> 50013) AND
           (IntGNumber <> 50014) THEN BEGIN

        END;

    end;

    var
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


    // todo 106 _ 107 a ahouter linge
}

