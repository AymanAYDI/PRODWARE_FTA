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
        //todo: verifier 
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                RecLCommentLine: Record "Comment Line";
                FrmLCommentSheet: Page "Comment Sheet";
                RecLSalesHeader: Record "Sales Header";
            begin
                //>>FED_20090415:PA 15/04/2009
                if "Sell-to Customer No." <> '' then
                    if not ("Document Type" = "Document Type"::Invoice) and not ("Document Type" = "Document Type"::"Credit Memo") then begin
                        if RecLSalesHeader.GET("Document Type", "No.") then begin
                            //MESSAGE( "Sell-to Customer No.");
                            RecLCommentLine.SETRANGE("Table Name", RecLCommentLine."Table Name"::Customer);
                            RecLCommentLine.SETRANGE("No.", "Sell-to Customer No.");
                            if RecLCommentLine.FINDFIRST() then
                                CLEAR(FrmLCommentSheet);
                            FrmLCommentSheet.SETTABLEVIEW(RecLCommentLine);
                            FrmLCommentSheet.EDITABLE(false);
                            FrmLCommentSheet.RUN();

                        end;

                        if RecGContact.GET("Sell-to Contact No.") then begin
                            "E-Mail" := RecGContact."E-Mail";
                            "Fax No." := RecGContact."Fax No.";
                            "Subject Mail" := '';
                        end
                        else begin
                            "E-Mail" := '';
                            "Fax No." := '';
                            "Subject Mail" := '';
                        end;
                    end;

            end;
        }
        modify("Sell-to Contact No.")

        {
            trigger OnAfterValidate()
            var
                RecGContact: Record Contact;
            begin
                if RecGContact.GET("Sell-to Contact No.") then begin
                    "E-Mail" := RecGContact."E-Mail";
                    "Fax No." := RecGContact."Fax No.";
                    "Subject Mail" := '';
                end
                else begin
                    "E-Mail" := '';
                    "Fax No." := '';
                    "Subject Mail" := '';
                end;

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



                if "Promised Delivery Date" <> 0D then
                    "Planned Shipment Date" := CALCDATE("Shipping Time", "Promised Delivery Date")
                else
                    if "Requested Delivery Date" <> 0D then
                        "Planned Shipment Date" := CALCDATE("Shipping Time", "Requested Delivery Date");

                if "Promised Delivery Date" <> 0D then
                    VALIDATE("Order Shipment Date", CALCDATE('<-2D>', "Promised Delivery Date"));

            end;

        }
        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            begin


                if "Promised Delivery Date" <> 0D then
                    "Planned Shipment Date" := CALCDATE("Shipping Time", "Promised Delivery Date")
                else
                    if "Requested Delivery Date" <> 0D then
                        "Planned Shipment Date" := CALCDATE("Shipping Time", "Requested Delivery Date");



                if "Requested Delivery Date" <> 0D then
                    VALIDATE("Order Shipment Date", CALCDATE('<-2D>', "Requested Delivery Date"));




            end;
        }

        field(50000; "Franco Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Franco Amount" where("No." = field("Sell-to Customer No.")));
            Caption = 'Franco Amount';

            Editable = false;

        }
        field(50001; "Desc. Shipment Method"; Text[100])
        {
            CalcFormula = lookup("Shipment Method".Description where(Code = field("Shipment Method Code")));
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

                if ("Total weight" <> 0) and ("Total Parcels" <> 0) then
                    CreateShipCosts();

                if ("Total weight" = 0) or ("Total Parcels" = 0) then
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

                if ("Total weight" <> 0) and ("Total Parcels" <> 0) then
                    CreateShipCosts();

                if ("Total weight" = 0) or ("Total Parcels" = 0) then
                    DeleteOpenShipCostLine();

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

                if not ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) then
                    exit;

                if "Sell-to Customer No." <> '' then
                    if Cont.GET("Sell-to Contact No.") then
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    else begin
                        ContBusinessRelation.RESET();
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SETRANGE("No.", "Sell-to Customer No.");
                        if ContBusinessRelation.FINDFIRST() then
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SETRANGE("No.", '');
                    end;
                if "Sell-to Contact No." <> '' then
                    if Cont.GET("Sell-to Contact No.") then;


                ContactListPage.SETTABLEVIEW(Cont);
                ContactListPage.SETRECORD(Cont);
                ContactListPage.LOOKUPMODE(true);
                ContactListPage.EDITABLE(false);
                if ContactListPage.RUNMODAL() = ACTION::LookupOK then begin
                    // IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                    // xRec := Rec;
                    ContactListPage.GETRECORD(Cont);
                    VALIDATE("E-Mail", Cont."E-Mail");
                end;
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
            CalcFormula = lookup(Customer."India Product" where("No." = field("Sell-to Customer No.")));
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
            CalcFormula = lookup("Shipping Agent".Name where(Code = field("Shipping Agent Code")));
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

    begin
        if ShippingAgent.GET("Shipping Agent Code") then
            case ShippingAgent."Shipping Costs" of
                ShippingAgent."Shipping Costs"::" ":
                    begin
                        DeleteOpenShipCostLine();
                        MESSAGE('Pas de frais de port et d''emballage.');
                        exit(true);
                    end;
                ShippingAgent."Shipping Costs"::Manual:
                    begin
                        DeleteOpenShipCostLine();
                        MESSAGE('Veuillez ajouter manuellement les frais de port.');
                        exit(true);
                    end;
                ShippingAgent."Shipping Costs"::"Pick-up":
                    begin
                        DeleteOpenShipCostLine();
                        MESSAGE('Enlèvement, ajout des frais d''emballage.');
                        exit(true);
                    end;
                ShippingAgent."Shipping Costs"::Automatic:
                    begin
                        if "Total weight" >= 30 then
                            DeleteOpenShipCostLine();
                        MESSAGE('Poids dépassé. Ajouter un colis ou changer de transporteur.');
                        exit(true);
                    end else
                            InsertShipLineToOrder();
            end;
    end;

    local procedure TotalSalesLineAmountPrepare(): Decimal
    var
        LRecSalesLine: Record "Sales Line";

    begin


        LRecSalesLine.RESET();
        LRecSalesLine.SETRANGE("Document Type", Rec."Document Type");
        LRecSalesLine.SETRANGE("Document No.", Rec."No.");

        LRecSalesLine.SETRANGE("Prepare", true);
        LRecSalesLine.CALCSUMS(Amount);
        exit(LRecSalesLine.Amount);
    end;


    local procedure DeleteOpenShipCostLine()
    var
        SalesLIne: Record "Sales line";
    begin
        SalesLIne.RESET();
        SalesLIne.SETRANGE("Document Type", Rec."Document Type");
        SalesLIne.SETRANGE("Document No.", Rec."No.");
        SalesLIne.SETRANGE("Shipping Costs", true);
        SalesLIne.SETFILTER("Outstanding Quantity", '<>%1', 0);
        SalesLIne.DELETEALL(false);
    end;

    local procedure InsertShipLineToOrder()

    var
        SalesLine: Record "Sales Line";
        ShippingCostsCarrier: Record "Shipping Costs Carrier";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        LineNo: Integer;

    begin

        ShippingCostsCarrier.RESET();
        ShippingCostsCarrier.SETRANGE("Shipping Agent Code", Rec."Shipping Agent Code");
        ShippingCostsCarrier.SETFILTER("Min. Weight", '<=%1', Rec."Total weight");
        ShippingCostsCarrier.SETFILTER("Max. Weight", '>=%1', Rec."Total weight");
        if ShippingCostsCarrier.FINDFIRST() then begin
            if CONFIRM('Une ligne de frais de port va être ajoutée. Voulez-vous continuer ?', true, true) then
                SalesLine.RESET();
            SalesLine.SETRANGE("Document Type", Rec."Document Type");
            SalesLine.SETRANGE("Document No.", Rec."No.");
            if SalesLine.FINDLAST() then
                LineNo := SalesLine."Line No."
            else
                LineNo := 0;

            ShippingCostsCarrier.TESTFIELD("Item No.");

            SalesLine.SETRANGE("No.", ShippingCostsCarrier."Item No.");
            SalesLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
            if SalesLine.FINDFIRST() then begin
                ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.Quantity := 1;
                SalesLine.VALIDATE("Unit Price", ShippingCostsCarrier."Cost Amount");
                SalesLine.MODIFY();
            end else begin
                ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.INIT();
                SalesLine."Document Type" := Rec."Document Type";
                SalesLine."Document No." := Rec."No.";
                SalesLine."Line No." := LineNo + 10000;
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine.VALIDATE("No.", ShippingCostsCarrier."Item No.");
                SalesLine.VALIDATE(Quantity, 1);
                SalesLine.VALIDATE("Unit Price", ShippingCostsCarrier."Cost Amount");
                SalesLine."Shipping Costs" := true;
                SalesLine.INSERT();
            end;
        end;

    end;








    local procedure CreateShipCosts(): Boolean
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        //IF ("Total Weight" <>  0) AND ("Total Parcels" <> 0) THEN
        if "Total Parcels" > 1 then begin
            DeleteOpenShipCostLine();
            MESSAGE('2 colis et plus, veuillez ajouter manuellement les frais de port.');
            exit(true);
        end;

        if "Sell-to Country/Region Code" <> 'FR' then begin
            DeleteOpenShipCostLine();
            MESSAGE('Livraison à l''etrangé, veuillez ajouter manuellement les frais de port.');
            exit(true);
        end;

        if "Shipment Method Code" <> '' then
            if ShipmentMethod.GET("Shipment Method Code") then
                case ShipmentMethod."Shipping Costs" of
                    ShipmentMethod."Shipping Costs"::" ":
                        begin
                            DeleteOpenShipCostLine();
                            MESSAGE('Pas de frais de port et d''emballage.');
                            exit(true);
                            TotalSalesLineAmountPrepare()
                        end;
                    ShipmentMethod."Shipping Costs"::Manual:
                        begin
                            DeleteOpenShipCostLine();
                            MESSAGE('Veuillez ajouter manuellement les frais de port.');
                            exit(true);
                        end;
                    ShipmentMethod."Shipping Costs"::Franco:
                        begin
                            Rec.CALCFIELDS("Franco Amount");

                            if (TotalSalesLineAmountPrepare() > Rec."Franco Amount") and
                            (TotalSalesLineAmountPrepare() = Rec."Franco Amount")
                             then begin
                                DeleteOpenShipCostLine();
                                MESSAGE('Franco dépassé, pas de frais de port et d''emballage');
                                exit(true);
                            end else
                                CalcShipment();
                        end;
                    ShipmentMethod."Shipping Costs"::Automatic:

                        CalcShipment();


                    else
                        exit(true);

                end;





    end;

    trigger OnDelete()
    var
        RecLPurchHeader: Record "Purchase Header";
        //"--NAVEASY.001  Integer ;
        TextCdeTransp002: label 'ENU=There is a Shipping Purchase order linked (Order %1), do you want to delete this order?;FRA=Il existe une commande d''achat tranport li‚e (Commande %1), voulez-vous supprimer cette commande?';
    begin

        if "Shipping Order No." <> '' then
            if CONFIRM(STRSUBSTNO(TextCdeTransp002, "Shipping Order No.")) then
                if RecLPurchHeader.GET(RecLPurchHeader."Document Type"::Order, "Shipping Order No.") then RecLPurchHeader.DELETE(true);

    end;

    var
        RecGCommentLine: Record "Comment Line";
        RecGContact: Record Contact;
        RecGCustomer: Record Customer;
        RecGParamNavi: Record "NavEasy Setup";

        RecLPurchHeader: Record "Purchase Header";


        RecLSalesLine: Record "Sales Line";
        ShippingAgent: Record "Shipping Agent";
        specFrmGLignesCommentaires: Page "Comment Sheet";


        CstL001: Label 'This change can delete the reservation of the lines : do want to continue?';
        CstL002: Label 'Canceled operation';


        TextCdeTransp003: Label 'You cannot modify Shipping Code agent because there is a Shipping Purchase Order linked (Order %1) !!';










}

