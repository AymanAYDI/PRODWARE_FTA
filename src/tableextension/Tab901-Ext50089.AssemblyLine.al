
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

        //Unsupported feature: Code Modification on ""No."(Field 11).OnValidate".

        //trigger "(Field 11)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Consumed Quantity",0);
        CALCFIELDS("Reserved Quantity");
        WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
        IF "No." <> '' THEN
          CheckItemAvailable(FIELDNO("No."));
        VerifyReservationChange(Rec,xRec);
        TestStatusOpen;

        IF "No." <> xRec."No." THEN BEGIN
          "Variant Code" := '';
          InitResourceUsageType;
        END;

        IF "No." = '' THEN
          INIT
        ELSE BEGIN
          GetHeader;
          "Due Date" := AssemblyHeader."Starting Date";
          CASE Type OF
            Type::Item:
              BEGIN
                "Location Code" := AssemblyHeader."Location Code";
                GetItemResource;
                Item.TESTFIELD("Inventory Posting Group");
                "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                "Inventory Posting Group" := Item."Inventory Posting Group";
                GetDefaultBin;
                Description := Item.Description;
                "Description 2" := Item."Description 2";
                "Unit Cost" := GetUnitCost;
                VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                CreateDim(DATABASE::Item,"No.",AssemblyHeader."Dimension Set ID");
                Reserve := Item.Reserve;
                VALIDATE(Quantity);
                VALIDATE("Quantity to Consume",
                  MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
              END;
            Type::Resource:
              BEGIN
                GetItemResource;
                Resource.TESTFIELD("Gen. Prod. Posting Group");
                "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
                "Inventory Posting Group" := '';
                Description := Resource.Name;
                "Description 2" := Resource."Name 2";
                "Unit Cost" := GetUnitCost;
                VALIDATE("Unit of Measure Code",Resource."Base Unit of Measure");
                CreateDim(DATABASE::Resource,"No.",AssemblyHeader."Dimension Set ID");
                VALIDATE(Quantity);
                VALIDATE("Quantity to Consume",
                  MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
              END;
          END
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..10
          "Originally Ordered No." := '';
          "Originally Ordered Var. Code" := '';
        #11..54


        //>>FED_20090415:PA 15/04/2009
        IF Type = Type::Item THEN
          RecLItem.SETFILTER("Location Filter","Location Code");
        IF RecLItem.GET("No.") THEN
        BEGIN
        "Vendor No." := RecLItem."Vendor No.";
        //RecLItem.SETRANGE("Date Filter","Shipment Date");


        //>>FED_20090415:PA 15/04/2009
        {RecLItem.CALCFIELDS(Inventory,"Reserved Qty. on Inventory");
        "Avaibility no reserved" := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";          }
        RecLItem.CALCFIELDS(Inventory,"Qty. on Sales Order","Qty. on Asm. Component","Reserved Qty. on Purch. Orders");
        DecGQtyKit := 0;
        RecGKitSalesLine.SETRANGE("Document Type",RecGKitSalesLine."Document Type"::Order);
        RecGKitSalesLine.SETRANGE(Type,RecGKitSalesLine.Type::Item);
        RecGKitSalesLine.SETRANGE("No.","No.");
        RecGKitSalesLine.SETFILTER("Remaining Quantity (Base)",'<>0');


        IF NOT RecGKitSalesLine.ISEMPTY THEN BEGIN
          RecGKitSalesLine.FINDSET;
          REPEAT

            //>>MIG NAV 2015 : Upgrade Old Code
            IF  RecGAssemLink.GET(RecGKitSalesLine."Document Type",RecGKitSalesLine."Document No.") THEN
            //<<MIG NAV 2015 : Upgrade Old Code

            //>>MIG NAV 2015 : Upgrade Old Code
            //OLD IF (RecGKitSalesLine."Document No." <> xKitSalesLine."Document No.") OR
            //OLD      (RecGKitSalesLine."Line No." <> xKitSalesLine."Document Line No.") THEN
            IF (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") OR (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") THEN
            //<<MIG NAV 2015 : Upgrade Old Code
               DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
          UNTIL RecGKitSalesLine.NEXT = 0;
        END;

        "Avaibility no reserved" := RecLItem.Inventory -(RecLItem."Qty. on Sales Order" + DecGQtyKit)
                                    + RecLItem."Reserved Qty. on Purch. Orders";
        //<<FED_20090415:PA 15/04/2009

        //>>MIG NAV 2015 : Upgrade Old Code
        //OLD IF RecLItem."Kit BOM No." = '' THEN
        RecLItem.CALCFIELDS("Assembly BOM");
        IF RecLItem."Assembly BOM" THEN
          "Kit Qty Available by Assembly" := 0
        ELSE BEGIN
          "Kit Qty Available by Assembly" := 0;
          BoolFirstRead := FALSE;
          RecLProductionBOMLine.RESET;
          RecLProductionBOMLine.SETRANGE("Parent Item No.",RecLItem."No.");
          IF RecLProductionBOMLine.FINDSET THEN
            REPEAT
            IF (RecLProductionBOMLine.Type = RecLProductionBOMLine.Type::Item) THEN
              IF RecLItem.GET(RecLProductionBOMLine."No.") THEN
                BEGIN
                //PAMO RecLItem.SETRANGE("Date Filter","Shipment Date");
                RecLItem.SETFILTER("Location Filter","Location Code");
                //>>FED_20090415:PA 15/04/2009
                {RecLItem.CALCFIELDS(Inventory,"Reserved Qty. on Inventory");
                DecLAvailibityNoReserved := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";      }
                RecLItem.CALCFIELDS(Inventory,"Qty. on Sales Order","Qty. on Asm. Component","Reserved Qty. on Purch. Orders");
                DecGQtyKit := 0;
                RecGKitSalesLine.SETRANGE("Document Type",RecGKitSalesLine."Document Type"::Order);
                RecGKitSalesLine.SETRANGE(Type,RecGKitSalesLine.Type::Item);
                RecGKitSalesLine.SETRANGE("No.","No.");
                RecGKitSalesLine.SETFILTER(RecGKitSalesLine."Remaining Quantity (Base)",'<>0');

                //>>MIG NAV 2015 : Upgrade Old Code
                RecGAssemLink.GET(RecGKitSalesLine."Document Type",RecGKitSalesLine."Document No.");
                //<<MIG NAV 2015 : Upgrade Old Code

                IF NOT RecGKitSalesLine.ISEMPTY THEN BEGIN
                  RecGKitSalesLine.FINDSET;
                  REPEAT
                    //>>MIG NAV 2015 : Upgrade Old Code
                    //OLD IF (RecGKitSalesLine."Document No." <> xKitSalesLine."Document No.") OR
                    //OLD      (RecGKitSalesLine."Line No." <> xKitSalesLine."Document Line No.") THEN
                    IF (RecGKitSalesLine."Document No." <> RecGAssemLink."Document No.") OR (RecGKitSalesLine."Line No." <> RecGAssemLink."Document Line No.") THEN
                    //<<MIG NAV 2015 : Upgrade Old Code
                      DecGQtyKit += RecGKitSalesLine."Remaining Quantity (Base)";
                  UNTIL RecGKitSalesLine.NEXT = 0;
                END;

                DecLAvailibityNoReserved := RecLItem.Inventory -(RecLItem."Qty. on Sales Order" + DecGQtyKit) +
                                            RecLItem."Reserved Qty. on Purch. Orders";
                //<<FED_20090415:PA 15/04/2009

                IF NOT BoolFirstRead THEN
                  "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per",1,'<')
                ELSE
                  IF ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per",1,'<') < "Kit Qty Available by Assembly" THEN
                    "Kit Qty Available by Assembly" := ROUND(DecLAvailibityNoReserved / RecLProductionBOMLine."Quantity per",1,'<');
                BoolFirstRead := TRUE;
                END;
            UNTIL RecLProductionBOMLine.NEXT = 0;
         END;
        END;
        //<<FED_20090415:PA 15/04/2009
        */
        //end;
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
        field(50032; "Preparation Type"; enum option)
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


    //     field (50045;  ;"Kit BOM No." ; code [20]    )   
    // {
    //  CaptionML=[ENU=Kit BOM No.;
    //                   FRA=Nomenclature Nø];
    //       Description=FTA1.00;
    //     ditable=No }
    // }


        // { 50001;  ;Level No.           ;Integer       ;CaptionML=[ENU=Level No.;
        //                                                           FRA=Nø Niveau];
        //                                                Description=FTA1.00 }
        // { 50002;  ;Kit Action          ;Option        ;OnValidate=VAR
        //                                                             CstL001@1100288000 : TextConst 'ENU=%1 impossible;FRA=%1 impossible';
        //                                                           BEGIN
        //                                                             CASE "Kit Action" OF
        //                                                               "Kit Action"::Assembly:
        //                                                               BEGIN
        //                                                                 IF "Quantity per" <> 0 THEN
        //                                                                   ERROR(CstL001,FORMAT("Kit Action"));
        //                                                               END;
        //                                                               "Kit Action"::Disassembly:
        //                                                               BEGIN
        //                                                               IF "x Quantity per" <> 0 THEN
        //                                                                   ERROR(CstL001,FORMAT("Kit Action"));
        //                                                               END;
        //                                                             END;
        //                                                           END;

        //                                                CaptionML=[ENU=Kit Action;
        //                                                           FRA=Action sur Nomenclature];
        //                                                OptionCaptionML=[ENU=" ,Assembly,Disassembly";
        //                                                                 FRA=" ,Montage,Dmontage"];
        //                                                OptionString=[ ,Assembly,Disassembly];
        //                                                Description=FTA1.00 }
        // { 50003;  ;x Quantity per      ;Decimal       ;CaptionML=[ENU=Origin Quantity per;
        //                                                           FRA=Origine Quantit par];
        //                                                DecimalPlaces=0:5;
        //                                                MinValue=0;
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50004;  ;Avaibility no reserved;Decimal     ;CaptionML=[ENU=Avaibility;
        //                                                           FRA=Disponibilit];
        //                                                DecimalPlaces=0:5;
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50005;  ;x Quantity per (Base);Decimal      ;CaptionML=[ENU=Origin Quantity per (Base);
        //                                                           FRA=Origine Quantit par (base)];
        //                                                DecimalPlaces=0:5;
        //                                                MinValue=0;
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50006;  ;Kit Qty Available by Assembly;Decimal;
        //                                                CaptionML=[ENU=Kit Qty Available by Assembly;
        //                                                           FRA=Kit Qt possible Monter];
        //                                                DecimalPlaces=0:5;
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50007;  ;x Extended Quantity ;Decimal       ;CaptionML=[ENU=x Extended Quantity;
        //                                                           FRA=x Quantit tendue];
        //                                                DecimalPlaces=0:5;
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50008;  ;x Extended Quantity (Base);Decimal ;CaptionML=[ENU=x Extended Quantity (Base);
        //                                                           FRA=x Quantit tendue (base)];
        //                                                DecimalPlaces=0:5;
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50009;  ;Kit                 ;Boolean       ;FieldClass=FlowField;
        //                                                CalcFormula=Exist("BOM Component" WHERE (Parent Item No.=FIELD(No.)));
        //                                                CaptionML=[ENU=Kit;
        //                                                           FRA=Ensemble];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50010;  ;Sell-to Customer No.;Code20        ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup("Sales Line"."Sell-to Customer No." WHERE (Document Type=FIELD(Document Type),
        //                                                                                                              Document No.=FIELD(Document No.)));
        //                                                CaptionML=[ENU=Sell-to Customer No.;
        //                                                           FRA=Nø donneur dordre];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50011;  ;Sell-to Customer Name;Text50       ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup(Customer.Name WHERE (No.=FIELD(Sell-to Customer No.)));
        //                                                CaptionML=[ENU=Sell-to Customer Name;
        //                                                           FRA=Nom donneur dordre];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50012;  ;Selected for Order  ;Boolean       ;OnValidate=BEGIN
        //                                                             IF "Selected for Order" AND ("Qty to be Ordered" = 0) THEN BEGIN
        //                                                               CALCFIELDS("Reserved Quantity");
        //                                                               "Qty to be Ordered" := "Remaining Quantity" - "Reserved Quantity";
        //                                                             END;
        //                                                             IF NOT "Selected for Order" THEN
        //                                                               "Qty to be Ordered" := 0;
        //                                                           END;

        //                                                CaptionML=[ENU=Selected for Order;
        //                                                           FRA=Selectionne pour commande];
        //                                                Description=FTA1.00 }
        // { 50013;  ;Qty to be Ordered   ;Decimal       ;OnValidate=VAR
        //                                                             CstL001@1100295000 : TextConst 'ENU=The quantity to be ordered %1 is greater to the need %2;FRA=La quantit‚ … commander %1 est sup‚rieure au besoin qui est %2';
        //                                                           BEGIN
        //                                                             IF ("Qty to be Ordered" <> 0) THEN BEGIN
        //                                                               CALCFIELDS("Reserved Quantity");
        //                                                               IF "Qty to be Ordered" > "Remaining Quantity" - "Reserved Quantity" THEN;
        //                                                                 //ERROR(CstL001,"Qty to be Ordered","Outstanding Quantity" - "Reserved Quantity");
        //                                                             END;
        //                                                           END;

        //                                                CaptionML=[ENU=Qty to be Ordered;
        //                                                           FRA=Qt … commander];
        //                                                DecimalPlaces=0:5;
        //                                                Description=FTA1.00 }
        // { 50014;  ;Vendor No.          ;Code20        ;TableRelation=Vendor;
        //                                                CaptionML=[ENU=Vendor No.;
        //                                                           FRA=Nø fournisseur article];
        //                                                Description=FTA1.00 }
        // { 50016;  ;Requested Delivery Date;Date       ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup("Sales Line"."Requested Delivery Date" WHERE (Document Type=FIELD(Document Type),
        //                                                                                                                 Document No.=FIELD(Document No.)));
        //                                                CaptionML=[ENU=Requested Delivery Date;
        //                                                           FRA=Date livraison demande];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50017;  ;Promised Delivery Date;Date        ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup("Sales Line"."Promised Delivery Date" WHERE (Document Type=FIELD(Document Type),
        //                                                                                                                Document No.=FIELD(Document No.)));
        //                                                CaptionML=[ENU=Promised Delivery Date;
        //                                                           FRA=Date livraison confirme];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50020;  ;Qty Not Assign FTA  ;Decimal       ;CaptionML=[ENU=Qty. to Assign FTA;
        //                                                           FRA=Qt affecter FTA];
        //                                                DecimalPlaces=0:5;
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50023;  ;Requested Receipt Date;Date        ;CaptionML=[ENU=Requested Receipt Date;
        //                                                           FRA=Date rception demande];
        //                                                Description=FTA1.00 }
        // { 50024;  ;Inventory Value Zero;Boolean       ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup(Item."Inventory Value Zero" WHERE (No.=FIELD(No.)));
        //                                                CaptionML=[FRA="enu=Inventory Value Zero;fra=Exclure ‚valuation stock"];
        //                                                Description=FTA1.00 }
        // { 50030;  ;Item No. 2          ;Code20        ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup(Item."No. 2" WHERE (No.=FIELD(No.)));
        //                                                CaptionML=[ENU=Item No. 2;
        //                                                           FRA=Article Nø 2];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50031;  ;Internal field      ;Boolean       ;CaptionML=[ENU=Internal field;
        //                                                           FRA=Champ interne];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50032;  ;Preparation Type    ;Option        ;FieldClass=FlowField;
        //                                                CalcFormula=Lookup("Sales Line"."Preparation Type" WHERE (Document Type=FIELD(Document Type),
        //                                                                                                          Document No.=FIELD(Document No.)));
        //                                                CaptionML=[ENU=Preparation Type;
        //                                                           FRA=Type prparation];
        //                                                OptionCaptionML=[ENU=" ,Stock,Assembly,Purchase,Remaider";
        //                                                                 FRA=" ,Stock,Montage,Achat,Reliquat"];
        //                                                OptionString=[ ,Stock,Assembly,Purchase,Remainder];
        //                                                Description=FTA1.00 }
        // { 50033;  ;x Outstanding Quantity;Decimal     ;CaptionML=[ENU=x Outstanding Quantity;
        //                                                           FRA=x Quantit restante];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50034;  ;x Outstanding Qty. (Base);Decimal  ;CaptionML=[ENU=x Outstanding Qty. (Base);
        //                                                           FRA=x Quantit ouverte (base)];
        //                                                Description=FTA1.00;
        //                                                Editable=No }
        // { 50043;  ;Originally Ordered No.;Code20      ;TableRelation=IF (Type=CONST(Item)) Item;
        //                                                AccessByPermission=TableData 5715=R;
        //                                                CaptionML=[ENU=Originally Ordered No.;
        //                                                           FRA=Nø article substitu];
        //                                                Description=FTA1.02 }
        // { 50044;  ;Originally Ordered Var. Code;Code10;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(Originally Ordered No.));
        //                                                AccessByPermission=TableData 5715=R;
        //                                                CaptionML=[ENU=Originally Ordered Var. Code;
        //                                                           FRA=Code variante substitu];
        //                                                Description=FTA1.02 
    
        //Unsupported feature: Property Insertion (SumIndexFields) on ""Type,No."(Key)".
keys
    {

        key(Key800; "Vendor No.")
        {
        }
        key (key900;"No.","Location Code")
        {

        }
        key (Key50; "Remaining Quantity")
        {
        }
        key(Key60; "Document Type", "Document No.", Type, "Quantity per")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
    VerifyReservationChange(Rec,xRec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
    VerifyReservationChange(Rec,xRec);
    //>>FED_20090415:PA 15/04/2009
    IntGNumber := FIELDNO("Internal field");
    IF (IntGNumber <> 50031) AND
       (IntGNumber <> 50013) AND
       (IntGNumber <> 50014) THEN BEGIN
    //<<FED_20090415:PA 15/04/2009
     //>>FED_20090415:PA 15/04/2009
      END;
    */
    //end;


    //Unsupported feature: Code Modification on "ShowReservation(PROCEDURE 8)".

    //procedure ShowReservation();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Type = Type::Item THEN BEGIN
      TESTFIELD("No.");
      TESTFIELD(Reserve);
      CLEAR(Reservation);
      Reservation.SetAssemblyLine(Rec);
      Reservation.RUNMODAL;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    //>>NDBI
      IF BooGResaAssFTA THEN
        Reservation.FctSetBooResaASSFTA(TRUE);
    //<<NDBI

    #5..7
    */
    //end;


    //Unsupported feature: Code Modification on "CalcAvailQuantities(PROCEDURE 24)".

    //procedure CalcAvailQuantities();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetItemFilter(Item);
    AvailableInventory := AvailableToPromise.CalcAvailableInventory(Item);
    ScheduledReceipt := AvailableToPromise.CalcScheduledReceipt(Item);
    ReservedReceipt := AvailableToPromise.CalcReservedReceipt(Item);
    ReservedRequirement := AvailableToPromise.CalcReservedRequirement(Item);
    GrossRequirement := AvailableToPromise.CalcGrossRequirement(Item);

    CompanyInfo.GET;
    LookaheadDateFormula := CompanyInfo."Check-Avail. Period Calc.";
    IF FORMAT(LookaheadDateFormula) <> '' THEN BEGIN
      AvailabilityDate := Item.GETRANGEMAX("Date Filter");
      PeriodType := CompanyInfo."Check-Avail. Time Bucket";

      GrossRequirement :=
        GrossRequirement +
        AvailableToPromise.CalculateLookahead(
          Item,PeriodType,
          AvailabilityDate + 1,
          AvailableToPromise.AdjustedEndingDate(CALCDATE(LookaheadDateFormula,AvailabilityDate),PeriodType));
    END;

    IF OrderLineExists(OldAssemblyLine) THEN
      GrossRequirement := GrossRequirement - OldAssemblyLine."Remaining Quantity (Base)"
    ELSE
      OldAssemblyLine.INIT;

    EarliestDate :=
      GetEarliestAvailDate(
        CompanyInfo,"Remaining Quantity (Base)",
        OldAssemblyLine."Remaining Quantity (Base)",OldAssemblyLine."Due Date");

    ExpectedInventory :=
      CalcExpectedInventory(AvailableInventory,ScheduledReceipt - ReservedReceipt,GrossRequirement - ReservedRequirement);

    AvailableInventory := CalcQtyFromBase(AvailableInventory);
    GrossRequirement := CalcQtyFromBase(GrossRequirement);
    ScheduledReceipt := CalcQtyFromBase(ScheduledReceipt);
    ExpectedInventory := CalcQtyFromBase(ExpectedInventory);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SetItemFilter(Item);
    AvailableInventory := AvailableToPromise.CalcAvailableInventory(Item);
    //>>APA
    //ScheduledReceipt := AvailableToPromise.CalcScheduledReceipt(Item);
    //<<APA
    #4..38
    */
    //end;

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
                    MODIFY;
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

                  
                ReservMgt.AutoReserve(FullAutoReservation, '', "Due Date", "Remaining Quantity", "Remaining Quantity (Base)");
                FIND;
                IF NOT FullAutoReservation AND (CurrFieldNo <> 0) THEN
                    IF CONFIRM(Text001, TRUE) THEN BEGIN
                        COMMIT();
                        ShowReservation();
                        FIND;
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
        //>>FTA1.02
        // AssemblyLineManagement.SetAutoReserve; 
        // todo fonction spec
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

