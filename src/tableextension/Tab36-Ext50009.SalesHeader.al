namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Team;
using Microsoft.Foundation.Comment;
using Microsoft.Purchases.Document;
using Microsoft.CRM.Contact;
using Microsoft.CRM.BusinessRelation;
using System.Security.User;
tableextension 50009 SalesHeader extends "Sales Header" //36
{
    fields
    {
        // modify("Sell-to Customer No.")   
        // {
        //     Description = 'FTA1.01';
        //     trigger OnAfterValidate()
        //     var
        //         RecLCommentLine: Record "Comment Line";
        //         FrmLCommentSheet: Page "Comment Sheet";
        //         RecLSalesHeader: Record "Sales Header";
        //     begin
        //         //>>FED_20090415:PA 15/04/2009
        //         IF "Sell-to Customer No." <> '' THEN
        //             IF NOT ("Document Type" = "Document Type"::Invoice) AND NOT ("Document Type" = "Document Type"::"Credit Memo") THEN BEGIN
        //                 IF RecLSalesHeader.GET("Document Type", "No.") THEN BEGIN
        //                     //MESSAGE( "Sell-to Customer No.");
        //                     RecLCommentLine.SETRANGE("Table Name", RecLCommentLine."Table Name"::Customer);
        //                     RecLCommentLine.SETRANGE("No.", "Sell-to Customer No.");
        //                     IF RecLCommentLine.FINDFIRST() THEN
        //                         CLEAR(FrmLCommentSheet);
        //                     FrmLCommentSheet.SETTABLEVIEW(RecLCommentLine);
        //                     FrmLCommentSheet.EDITABLE(FALSE);
        //                     FrmLCommentSheet.RUN();

        //                 END;

        //                 IF RecGContact.GET("Sell-to Contact No.") THEN BEGIN
        //                     "E-Mail" := RecGContact."E-Mail";
        //                     "Fax No." := RecGContact."Fax No.";
        //                     "Subject Mail" := '';
        //                 END
        //                 ELSE BEGIN
        //                     "E-Mail" := '';
        //                     "Fax No." := '';
        //                     "Subject Mail" := '';
        //                 END;
        //             end;

        //     end;
        // }
        modify("Sell-to Contact No.")

        {
            trigger OnAfterValidate()
            var
                RecGContact: Record 5050;
            begin
                IF RecGContact.GET("Sell-to Contact No.") THEN BEGIN
                    "E-Mail" := RecGContact."E-Mail";
                    "Fax No." := RecGContact."Fax No.";
                    "Subject Mail" := '';
                END
                ELSE BEGIN
                    "E-Mail" := '';
                    "Fax No." := '';
                    "Subject Mail" := '';
                END;

            end;



        }
        modify("Customer Posting Group")
        {


            Description = 'NAVEASY.001 [Multi_Collectif] Propriété EDITABLE No => Yes';
        }
        modify("Promised Delivery Date")
        {
            trigger OnAfterValidate()
            begin



                IF "Promised Delivery Date" <> 0D THEN
                    "Planned Shipment Date" := CALCDATE("Shipping Time", "Promised Delivery Date")
                ELSE
                    IF "Requested Delivery Date" <> 0D THEN
                        "Planned Shipment Date" := CALCDATE("Shipping Time", "Requested Delivery Date");

                IF "Promised Delivery Date" <> 0D THEN
                    VALIDATE("Order Shipment Date", CALCDATE('<-2D>', "Promised Delivery Date"));

            end;

        }
        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            begin


                IF "Promised Delivery Date" <> 0D THEN
                    "Planned Shipment Date" := CALCDATE("Shipping Time", "Promised Delivery Date")
                ELSE
                    IF "Requested Delivery Date" <> 0D THEN
                        "Planned Shipment Date" := CALCDATE("Shipping Time", "Requested Delivery Date");



                IF "Requested Delivery Date" <> 0D THEN
                    VALIDATE("Order Shipment Date", CALCDATE('<-2D>', "Requested Delivery Date"));




            end;
        }

        field(50000; "Franco Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."Franco Amount" WHERE("No." = FIELD("Sell-to Customer No.")));
            Caption = 'Franco Amount';

            Editable = false;

        }
        field(50001; "Desc. Shipment Method"; Text[50])
        {
            CalcFormula = Lookup("Shipment Method".Description WHERE(Code = FIELD("Shipment Method Code")));
            Caption = 'Shipment Method Desc.';
            Description = 'FTA1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Total weight"; Decimal)
        {
            Caption = 'Total weight';
            DecimalPlaces = 0 : 2;
            Description = 'FTA1.00';

            trigger OnValidate()
            begin

                IF ("Total weight" <> 0) AND ("Total Parcels" <> 0) THEN
                    CreateShipCosts();

                IF ("Total weight" = 0) OR ("Total Parcels" = 0) THEN
                    DeleteOpenShipCostLine();

            end;
        }
        field(50003; "Total Parcels"; Decimal)
        {
            Caption = 'Total Parcels';
            DecimalPlaces = 0 : 2;
            Description = 'FTA1.00';

            trigger OnValidate()
            begin

                IF ("Total weight" <> 0) AND ("Total Parcels" <> 0) THEN
                    CreateShipCosts();

                if ("Total weight" = 0) OR ("Total Parcels" = 0) THEN
                    DeleteOpenShipCostLine();
                //<<FTA:AM  31.03.2023
            end;
        }
        field(50005; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            Description = 'FTA1.01';
        }
        field(50006; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            Description = 'FTA1.01';

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
                ContactListPage: Page "Contact List";
            begin

                IF NOT ("Document Type" IN ["Document Type"::Quote, "Document Type"::Order]) THEN
                    EXIT;

                IF "Sell-to Customer No." <> '' THEN
                    IF Cont.GET("Sell-to Contact No.") THEN
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    ELSE BEGIN
                        ContBusinessRelation.RESET();
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SETRANGE("No.", "Sell-to Customer No.");
                        IF ContBusinessRelation.FINDFIRST() THEN
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.")
                        ELSE
                            Cont.SETRANGE("No.", '');
                    END;
                IF "Sell-to Contact No." <> '' THEN
                    IF Cont.GET("Sell-to Contact No.") THEN;


                ContactListPage.SETTABLEVIEW(Cont);
                ContactListPage.SETRECORD(Cont);
                ContactListPage.LOOKUPMODE(TRUE);
                ContactListPage.EDITABLE(FALSE);
                IF ContactListPage.RUNMODAL() = ACTION::LookupOK THEN BEGIN

                    ContactListPage.GETRECORD(Cont);
                    VALIDATE("E-Mail", Cont."E-Mail");
                END;
            end;
        }
        field(50007; "Subject Mail"; Text[50])
        {
            Caption = 'Sujet Mail';
            Description = 'FTA1.01';
        }
        field(50008; "Order Shipment Date"; Date)
        {
            Caption = 'Order Shipment Date';
            Description = 'TI384175';
        }
        field(50010; "Customer India Product"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."India Product" WHERE("No." = FIELD("Sell-to Customer No.")));
            Caption = 'Customer India Product';
            Description = 'TI448733';
            Editable = false;

        }
        field(50011; "Customer Dispute"; Boolean)
        {
            Caption = 'Customer Dispute';
            Description = 'NDBI';

            trigger OnValidate()
            var
                RecLUserSetup: Record "User Setup";
            begin
                RecLUserSetup.GET(USERID);
                RecLUserSetup.TESTFIELD("Allowed To Modify Cust Dispute");
            end;
        }
        field(50012; Preparer; Text[30])
        {
            Caption = 'Preparer';
            Description = 'NDBI';
            TableRelation = "Workshop Person";
        }
        field(50013; Assembler; Text[30])
        {
            Caption = 'Assembler';
            Description = 'NDBI';
            TableRelation = "Workshop Person";
        }
        field(50014; Packer; Text[30])
        {
            Caption = 'Packer';
            Description = 'NDBI';
            TableRelation = "Workshop Person";
        }
        field(50015; "Auto AR Blocked"; Boolean)
        {
            Caption = 'Auto AR Blocked';
            Description = 'NDBI';
        }
        field(50021; "Customer Typology"; Code[20])
        {
            Caption = 'Customer Typology';
            Description = 'FTA1.04';
            TableRelation = "Customer Typology";
        }
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';

            TableRelation = "Salesperson/Purchaser";
        }
        field(50030; "Show Comment AR"; Option)
        {
            Caption = 'Afficher commentaires AR';
            OptionCaption = 'Non,Oui';
            OptionMembers = No,Yes;
        }
        field(50031; "Workshop File"; Option)
        {
            Caption = 'Dossier à l''atelier';
            OptionCaption = 'Non,Oui';
            OptionMembers = No,Yes;
        }
        field(50032; "Equipment Loans"; Boolean)
        {
            Caption = 'Prêt matériel';
        }
        field(51000; "Cause filing"; Option)
        {
            Caption = 'Cause filing';
            Description = 'NAVEASY.001 [Archivage_Devis] Ajout du champ';
            OptionCaption = 'No proceeded,Deleted,Change in Order';
            OptionMembers = "No proceeded",Deleted,"Change in Order";
        }
        field(51008; "Shipping Agent Name"; Text[50])
        {
            CalcFormula = Lookup("Shipping Agent".Name WHERE(Code = FIELD("Shipping Agent Code")));
            Caption = 'Shipping Agent Name';
            Description = 'NAVEASY.001 [Cde_Transport] Ajout du champ';
            FieldClass = FlowField;
        }
        field(51009; "Shipping Order No."; Code[20])
        {
            Caption = 'Shipping Order No.';
            Description = 'NAVEASY.001 [Cde_Transport] Ajout du champ';
            Editable = false;
        }
        field(51021; "Planned Shipment Date"; Date)
        {
            Caption = 'Planned Shipment Date';
            Description = 'NAVEASY.001 [Cde_Transport] Ajout du champ';
        }
        field(51030; "Nb Total Pallets"; Decimal)
        {
            Caption = 'Nbre Palettes totales';
            Description = 'NAVEASY.001 [Cde_Transport] Ajout du champ';
        }
    }
    keys
    {
        key(Key14; "Shipping Agent Code")
        {
        }
        key(Key15; "Document Type", "Bill-to Customer No.", "Combine Shipments", "Currency Code")
        {
        }
        key(Key16; "No.")
        {
        }

    }




    local procedure CalcShipment(): Boolean
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        IF ShippingAgent.GET("Shipping Agent Code") THEN
            CASE ShippingAgent."Shipping Costs" OF
                ShippingAgent."Shipping Costs"::" ":
                    BEGIN
                        DeleteOpenShipCostLine();
                        MESSAGE('Pas de frais de port et d''emballage.');
                        EXIT(TRUE);
                    END;
                ShippingAgent."Shipping Costs"::Manual:
                    BEGIN
                        DeleteOpenShipCostLine();
                        MESSAGE('Veuillez ajouter manuellement les frais de port.');
                        EXIT(TRUE);
                    END;
                ShippingAgent."Shipping Costs"::"Pick-up":
                    BEGIN
                        DeleteOpenShipCostLine();
                        MESSAGE('Enlèvement, ajout des frais d''emballage.');
                        EXIT(TRUE);
                    END;
                ShippingAgent."Shipping Costs"::Automatic:
                    BEGIN
                        IF "Total weight" >= 30 THEN
                            DeleteOpenShipCostLine();
                        MESSAGE('Poids dépassé. Ajouter un colis ou changer de transporteur.');
                        EXIT(TRUE);
                    END ELSE
                            InsertShipLineToOrder();
            END;
    END;

    local procedure TotalSalesLineAmountPrepare(): Decimal
    var
        LRecSalesLine: Record "Sales Line";
        TotAmount: Decimal;
    begin
        TotAmount := 0;

        LRecSalesLine.RESET();
        LRecSalesLine.SETRANGE("Document Type", Rec."Document Type");
        LRecSalesLine.SETRANGE("Document No.", Rec."No.");

        LRecSalesLine.SETRANGE("Prepare", TRUE);
        LRecSalesLine.CALCSUMS(Amount);
        EXIT(LRecSalesLine.Amount);
    end;


    local procedure DeleteOpenShipCostLine()
    var
        SalesLIne: Record "Sales line";
    begin
        SalesLIne.RESET();
        SalesLIne.SETRANGE("Document Type", Rec."Document Type");
        SalesLIne.SETRANGE("Document No.", Rec."No.");
        SalesLIne.SETRANGE("Shipping Costs", TRUE);
        SalesLIne.SETFILTER("Outstanding Quantity", '<>%1', 0);
        SalesLIne.DELETEALL(FALSE);
    end;

    local procedure InsertShipLineToOrder()

    var
        ShippingCostsCarrier: Record "Shipping Costs Carrier";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
        ReleaseSalesDoc: Codeunit "Release Sales Document";

    begin

        ShippingCostsCarrier.RESET();
        ShippingCostsCarrier.SETRANGE("Shipping Agent Code", Rec."Shipping Agent Code");
        ShippingCostsCarrier.SETFILTER("Min. Weight", '<=%1', Rec."Total weight");
        ShippingCostsCarrier.SETFILTER("Max. Weight", '>=%1', Rec."Total weight");
        IF ShippingCostsCarrier.FINDFIRST() THEN BEGIN
            IF CONFIRM('Une ligne de frais de port va être ajoutée. Voulez-vous continuer ?', TRUE, TRUE) THEN
                SalesLine.RESET();
            SalesLine.SETRANGE("Document Type", Rec."Document Type");
            SalesLine.SETRANGE("Document No.", Rec."No.");
            IF SalesLine.FINDLAST() THEN
                LineNo := SalesLine."Line No."
            ELSE
                LineNo := 0;

            ShippingCostsCarrier.TESTFIELD("Item No.");

            SalesLine.SETRANGE("No.", ShippingCostsCarrier."Item No.");
            SalesLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
            IF SalesLine.FINDFIRST THEN BEGIN
                ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.Quantity := 1;
                SalesLine.VALIDATE("Unit Price", ShippingCostsCarrier."Cost Amount");
                SalesLine.MODIFY();
            END ELSE BEGIN
                ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.INIT();
                SalesLine."Document Type" := Rec."Document Type";
                SalesLine."Document No." := Rec."No.";
                SalesLine."Line No." := LineNo + 10000;
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine.VALIDATE("No.", ShippingCostsCarrier."Item No.");
                SalesLine.VALIDATE(Quantity, 1);
                SalesLine.VALIDATE("Unit Price", ShippingCostsCarrier."Cost Amount");
                SalesLine."Shipping Costs" := TRUE;
                SalesLine.INSERT();
            END;
        END;

    END;








    local procedure CreateShipCosts(): Boolean
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        IF ("Total Weight" <> 0) AND ("Total Parcels" <> 0) THEN
            IF "Total Parcels" > 1 THEN BEGIN
                DeleteOpenShipCostLine();
                MESSAGE('2 colis et plus, veuillez ajouter manuellement les frais de port.');
                EXIT(TRUE);
            end;

        IF "Sell-to Country/Region Code" <> 'FR' THEN BEGIN
            DeleteOpenShipCostLine();
            MESSAGE('Livraison à l''etrangé, veuillez ajouter manuellement les frais de port.');
            EXIT(TRUE);
        END;

        IF "Shipment Method Code" <> '' THEN
            IF ShipmentMethod.GET("Shipment Method Code") THEN
                CASE ShipmentMethod."Shipping Costs" OF
                    ShipmentMethod."Shipping Costs"::" ":
                        BEGIN
                            DeleteOpenShipCostLine();
                            MESSAGE('Pas de frais de port et d''emballage.');
                            EXIT(TRUE);
                            TotalSalesLineAmountPrepare()
                        END;
                    ShipmentMethod."Shipping Costs"::Manual:
                        BEGIN
                            DeleteOpenShipCostLine();
                            MESSAGE('Veuillez ajouter manuellement les frais de port.');
                            EXIT(TRUE);
                        END;
                    ShipmentMethod."Shipping Costs"::Franco:
                        begin
                            Rec.CALCFIELDS("Franco Amount");

                            if (TotalSalesLineAmountPrepare() > Rec."Franco Amount") and
                            (TotalSalesLineAmountPrepare() = Rec."Franco Amount")
                             then BEGIN
                                DeleteOpenShipCostLine();
                                MESSAGE('Franco dépassé, pas de frais de port et d''emballage');
                                EXIT(TRUE);
                            END ELSE
                                CalcShipment();
                        END;
                    ShipmentMethod."Shipping Costs"::Automatic:

                        CalcShipment();


                    else
                        EXIT(TRUE);

                end;





    end;

    trigger OnDelete()
    var
        //"--NAVEASY.001  Integer ;
        TextCdeTransp002: label 'ENU=There is a Shipping Purchase order linked (Order %1), do you want to delete this order?;FRA=Il existe une commande d''achat tranport li‚e (Commande %1), voulez-vous supprimer cette commande?';
        RecLPurchHeader: Record "Purchase Header";
    begin

        IF "Shipping Order No." <> '' THEN
            IF CONFIRM(STRSUBSTNO(TextCdeTransp002, "Shipping Order No.")) THEN
                IF RecLPurchHeader.GET(RecLPurchHeader."Document Type"::Order, "Shipping Order No.") THEN RecLPurchHeader.DELETE(TRUE);

    end;

    var
        "-NAVEASY.001-": Integer;
        RecGCustomer: Record Customer;
        RecGParamNavi: Record "NavEasy Setup";
        RecGCommentLine: Record "Comment Line";
        specFrmGLignesCommentaires: Page "Comment Sheet";
        ShippingAgent: Record "Shipping Agent";
        "//PWD 02/02/2010": Integer;
        RecGContact: Record Contact;


        TextCdeTransp003: Label 'You cannot modify Shipping Code agent because there is a Shipping Purchase Order linked (Order %1) !!';


        RecLSalesLine: Record "Sales Line";
        CstL001: Label 'This change can delete the reservation of the lines : do want to continue?';
        CstL002: Label 'Canceled operation';

        "--NAVEASY.001--": Integer;

        RecLPurchHeader: Record "Purchase Header";










}

