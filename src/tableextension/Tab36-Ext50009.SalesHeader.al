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
                        if RecLSalesHeader.Get("Document Type", "No.") then begin
                            //Message( "Sell-to Customer No.");
                            RecLCommentLine.SetRange("Table Name", RecLCommentLine."Table Name"::Customer);
                            RecLCommentLine.SetRange("No.", "Sell-to Customer No.");
                            if RecLCommentLine.findFirst() then
                                Clear(FrmLCommentSheet);
                            FrmLCommentSheet.SetTableView(RecLCommentLine);
                            FrmLCommentSheet.Editable(false);
                            FrmLCommentSheet.Run();

                        end;

                        if RecGContact.Get("Sell-to Contact No.") then begin
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
                if RecGContact.Get("Sell-to Contact No.") then begin
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


            Description = 'NAVEASY.001 [Multi_Collectif] Propriété Editable No => Yes';
        }
        modify("Promised Delivery Date")
        {
            trigger OnAfterValidate()
            begin



                if "Promised Delivery Date" <> 0D then
                    "Planned Shipment Date" := CalcDate("Shipping Time", "Promised Delivery Date")
                else
                    if "Requested Delivery Date" <> 0D then
                        "Planned Shipment Date" := CalcDate("Shipping Time", "Requested Delivery Date");

                if "Promised Delivery Date" <> 0D then
                    Validate("Order Shipment Date", CalcDate('<-2D>', "Promised Delivery Date"));

            end;

        }
        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            begin


                if "Promised Delivery Date" <> 0D then
                    "Planned Shipment Date" := CalcDate("Shipping Time", "Promised Delivery Date")
                else
                    if "Requested Delivery Date" <> 0D then
                        "Planned Shipment Date" := CalcDate("Shipping Time", "Requested Delivery Date");



                if "Requested Delivery Date" <> 0D then
                    Validate("Order Shipment Date", CalcDate('<-2D>', "Requested Delivery Date"));




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
                    if Cont.Get("Sell-to Contact No.") then
                        Cont.SetRange("Company No.", Cont."Company No.")
                    else begin
                        ContBusinessRelation.Reset();
                        ContBusinessRelation.SetCurrentKey("Link to Table", "No.");
                        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SetRange("No.", "Sell-to Customer No.");
                        if ContBusinessRelation.findFirst() then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SetRange("No.", '');
                    end;
                if "Sell-to Contact No." <> '' then
                    if Cont.Get("Sell-to Contact No.") then;


                ContactListPage.SetTableView(Cont);
                ContactListPage.SetRecord(Cont);
                ContactListPage.LookupMode(true);
                ContactListPage.Editable(false);
                if ContactListPage.RunModal() = ACTION::LookupOK then begin
                    // IF PAGE.RunModal(0,Cont) = ACTION::LookupOK THEN BEGIN
                    // xRec := Rec;
                    ContactListPage.GetRecord(Cont);
                    Validate("E-Mail", Cont."E-Mail");
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
                RecLUserSetup.Get(UserId);
                RecLUserSetup.TestField("Allowed To Modify Cust Dispute");
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
        if ShippingAgent.Get("Shipping Agent Code") then
            case ShippingAgent."Shipping Costs" of
                ShippingAgent."Shipping Costs"::" ":
                    begin
                        DeleteOpenShipCostLine();
                        Message('Pas de frais de port et d''emballage.');
                        exit(true);
                    end;
                ShippingAgent."Shipping Costs"::Manual:
                    begin
                        DeleteOpenShipCostLine();
                        Message('Veuillez ajouter manuellement les frais de port.');
                        exit(true);
                    end;
                ShippingAgent."Shipping Costs"::"Pick-up":
                    begin
                        DeleteOpenShipCostLine();
                        Message('Enlèvement, ajout des frais d''emballage.');
                        exit(true);
                    end;
                ShippingAgent."Shipping Costs"::Automatic:
                    begin
                        if "Total weight" >= 30 then
                            DeleteOpenShipCostLine();
                        Message('Poids dépassé. Ajouter un colis ou changer de transporteur.');
                        exit(true);
                    end else
                            InsertShipLineToOrder();
            end;
    end;

    local procedure TotalSalesLineAmountPrepare(): Decimal
    var
        LRecSalesLine: Record "Sales Line";

    begin


        LRecSalesLine.Reset();
        LRecSalesLine.SetRange("Document Type", Rec."Document Type");
        LRecSalesLine.SetRange("Document No.", Rec."No.");

        LRecSalesLine.SetRange("Prepare", true);
        LRecSalesLine.CalcSums(Amount);
        exit(LRecSalesLine.Amount);
    end;


    local procedure DeleteOpenShipCostLine()
    var
        SalesLIne: Record "Sales line";
    begin
        SalesLIne.Reset();
        SalesLIne.SetRange("Document Type", Rec."Document Type");
        SalesLIne.SetRange("Document No.", Rec."No.");
        SalesLIne.SetRange("Shipping Costs", true);
        SalesLIne.SetFilter("Outstanding Quantity", '<>%1', 0);
        SalesLIne.DeleteALL(false);
    end;

    local procedure InsertShipLineToOrder()

    var
        SalesLine: Record "Sales Line";
        ShippingCostsCarrier: Record "Shipping Costs Carrier";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        LineNo: Integer;

    begin

        ShippingCostsCarrier.Reset();
        ShippingCostsCarrier.SetRange("Shipping Agent Code", Rec."Shipping Agent Code");
        ShippingCostsCarrier.SetFilter("Min. Weight", '<=%1', Rec."Total weight");
        ShippingCostsCarrier.SetFilter("Max. Weight", '>=%1', Rec."Total weight");
        if ShippingCostsCarrier.findFirst() then begin
            if Confirm('Une ligne de frais de port va être ajoutée. Voulez-vous continuer ?', true, true) then
                SalesLine.Reset();
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange("Document No.", Rec."No.");
            if SalesLine.FindLast() then
                LineNo := SalesLine."Line No."
            else
                LineNo := 0;

            ShippingCostsCarrier.TestField("Item No.");

            SalesLine.SetRange("No.", ShippingCostsCarrier."Item No.");
            SalesLine.SetFilter("Outstanding Quantity", '<>%1', 0);
            if SalesLine.findFirst() then begin
                ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.Quantity := 1;
                SalesLine.Validate("Unit Price", ShippingCostsCarrier."Cost Amount");
                SalesLine.Modify();
            end else begin
                ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.Init();
                SalesLine."Document Type" := Rec."Document Type";
                SalesLine."Document No." := Rec."No.";
                SalesLine."Line No." := LineNo + 10000;
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine.Validate("No.", ShippingCostsCarrier."Item No.");
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Unit Price", ShippingCostsCarrier."Cost Amount");
                SalesLine."Shipping Costs" := true;
                SalesLine.Insert();
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
            Message('2 colis et plus, veuillez ajouter manuellement les frais de port.');
            exit(true);
        end;

        if "Sell-to Country/Region Code" <> 'FR' then begin
            DeleteOpenShipCostLine();
            Message('Livraison à l''etrangé, veuillez ajouter manuellement les frais de port.');
            exit(true);
        end;

        if "Shipment Method Code" <> '' then
            if ShipmentMethod.Get("Shipment Method Code") then
                case ShipmentMethod."Shipping Costs" of
                    ShipmentMethod."Shipping Costs"::" ":
                        begin
                            DeleteOpenShipCostLine();
                            Message('Pas de frais de port et d''emballage.');
                            exit(true);
                            TotalSalesLineAmountPrepare()
                        end;
                    ShipmentMethod."Shipping Costs"::Manual:
                        begin
                            DeleteOpenShipCostLine();
                            Message('Veuillez ajouter manuellement les frais de port.');
                            exit(true);
                        end;
                    ShipmentMethod."Shipping Costs"::Franco:
                        begin
                            Rec.CalcFields("Franco Amount");

                            if (TotalSalesLineAmountPrepare() > Rec."Franco Amount") and
                            (TotalSalesLineAmountPrepare() = Rec."Franco Amount")
                             then begin
                                DeleteOpenShipCostLine();
                                Message('Franco dépassé, pas de frais de port et d''emballage');
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
        TextCdeTransp002: label 'ENU=There is a Shipping Purchase order linked (Order %1), do you want to Delete this order?;FRA=Il existe une commande d''achat tranport li‚e (Commande %1), voulez-vous supprimer cette commande?';
    begin

        if "Shipping Order No." <> '' then
            if Confirm(StrSubstNo(TextCdeTransp002, "Shipping Order No.")) then
                if RecLPurchHeader.Get(RecLPurchHeader."Document Type"::Order, "Shipping Order No.") then RecLPurchHeader.Delete(true);

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


        CstL001: Label 'This change can Delete the reservation of the lines : do want to continue?';
        CstL002: Label 'Canceled operation';


        TextCdeTransp003: Label 'You cannot Modify Shipping Code agent because there is a Shipping Purchase Order linked (Order %1) !!';










}

