namespace Prodware.FTA;

using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Shipping;
using Microsoft.Inventory.Intrastat;
using System.Security.AccessControl;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;
tableextension 50005 Vendor extends Vendor //23
{
    fields
    {
        field(51000; "Creation Date"; Date)
        {
            Caption = 'Creation Date';

            Editable = false;
        }
        field(51001; User; Code[20])
        {
            Caption = 'User';

            Editable = false;
            TableRelation = User;
        }
        field(51004; Status; enum "status")

        {
            Caption = 'Statut';

            InitValue = "No Referred";

        }
        field(51005; "Vendor Type"; enum "vendor type")
        {
            Caption = 'Vendor Type';



            trigger OnValidate()
            var
                RecLShippingAgent: Record "Shipping Agent";
                RecLSalesHeader: Record "Sales Header";
                RecLPurchHeader: Record "Purchase Header";
                TextCdeTransp001: Label 'You cannot modify Vendor type because there is Sales Header with the Shipping agent code %1 !!';
                TextCdeTransp002: Label 'You cannot modify Vendor type because there is Purchase Header with the Shipping agent code %1 !!';
            begin
                if "Vendor Type" = "Vendor Type"::Transport then
                    if not RecLShippingAgent.GET("No.") then begin
                        RecLShippingAgent.INIT();
                        RecLShippingAgent.Code := "No."[20];
                        RecLShippingAgent.Name := Name[20];
                        RecLShippingAgent."Internet Address" := "Home Page";
                        RecLShippingAgent.INSERT(true);
                        VALIDATE("Shipping Agent Code", RecLShippingAgent.Code);
                        MODIFY();
                    end else begin
                        RecLShippingAgent.Name := Name[20];
                        RecLShippingAgent."Internet Address" := "Home Page";
                        RecLShippingAgent.MODIFY();
                    end;
                if (xRec."Vendor Type" = xRec."Vendor Type"::Transport) and ("Vendor Type" <> "Vendor Type"::Transport) then begin

                    //Verification dans les commandes ventes
                    RecLSalesHeader.RESET();
                    RecLSalesHeader.SETCURRENTKEY("Shipping Agent Code");
                    RecLSalesHeader.SETRANGE("Shipping Agent Code", "No.");
                    if RecLSalesHeader.FINDFIRST() then begin
                        "Vendor Type" := "Vendor Type"::Transport;
                        MODIFY();
                        ERROR(STRSUBSTNO(TextCdeTransp001, "No."));
                    end;
                    //Verification dans les commandes achats
                    RecLPurchHeader.RESET();
                    RecLPurchHeader.SETCURRENTKEY("Shipping Agent Code");
                    RecLPurchHeader.SETRANGE("Shipping Agent Code", "No.");
                    if RecLPurchHeader.FINDFIRST() then begin
                        "Vendor Type" := "Vendor Type"::Transport;
                        MODIFY();
                        ERROR(STRSUBSTNO(TextCdeTransp002, "No."));
                    end;

                    //Suppression du code transporteur
                    if RecLShippingAgent.GET("No.") then
                        if RecLShippingAgent.DELETE() then
                            VALIDATE("Shipping Agent Code", '');
                    MODIFY();
                end;
            end;

        }
        field(51100; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type Code';
            Description = 'NAVEASY.001 [Parametres_DEB] Ajout du champ';
            TableRelation = "Transaction Type";
        }
        field(51101; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification Code';
            Description = 'NAVEASY.001 [Parametres_DEB] Ajout du champ';
            TableRelation = "Transaction Specification";
        }
        field(51102; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method Code';
            Description = 'NAVEASY.001 [Parametres_DEB] Ajout du champ';
            TableRelation = "Transport Method";
        }
        field(51103; "Entry Point"; Code[10])
        {
            Caption = 'Entry/Exit Point Code';
            Description = 'NAVEASY.001 [Parametres_DEB] Ajout du champ';
            TableRelation = "Entry/Exit Point";
        }
        field(51104; "Area"; Code[10])
        {
            Caption = 'Area Code';
            Description = 'NAVEASY.001 [Parametres_DEB] Ajout du champ';
            TableRelation = Area;
        }
    }
    //TODO : Not sure , A verifier. 
    trigger OnAfterDelete()
    var
        ShippingAgent: Record "Shipping Agent";
        RecLSalesHeader: Record "Sales Header";
        RecLPurchHeader: Record "Purchase Header";
    begin
        if ("Vendor Type" = "Vendor Type"::Transport) then begin

            //Verification dans les commandes ventes
            RecLSalesHeader.RESET();
            RecLSalesHeader.SETCURRENTKEY("Shipping Agent Code");
            RecLSalesHeader.SETRANGE("Shipping Agent Code", "No.");
            if RecLSalesHeader.FINDFIRST() then
                ERROR(STRSUBSTNO(TextCdeTransp001, "No."));
        end;
        //Verification dans les commandes achats
        RecLPurchHeader.RESET();
        RecLPurchHeader.SETCURRENTKEY("Shipping Agent Code");
        RecLPurchHeader.SETRANGE(RecLPurchHeader."Shipping Agent Code", "No.");
        if RecLPurchHeader.FINDFIRST() then
            ERROR(STRSUBSTNO(TextCdeTransp002, "No."));
        ;

        //Suppression du code transporteur
        if ShippingAgent.GET("No.") then ShippingAgent.DELETE();
    end;

    trigger OnAfterRename()
    var
        RecLShippingAgent: Record "Shipping Agent";
    begin
        if "Vendor Type" = "Vendor Type"::Transport then
            if RecLShippingAgent.GET(xRec."No.") then
                RecLShippingAgent.RENAME("No.");
    end;

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin

        "Creation Date" := WORKDATE();
        User := USERID();
        PurchSetup.GET();
        "Transaction Type" := PurchSetup."Transaction Type";
        "Transaction Specification" := PurchSetup."Transaction Specification";
        "Transport Method" := PurchSetup."Transport Method";
        "Entry Point" := PurchSetup."Entry  Point";
        Area := PurchSetup.Area;
    end;

    //TODO:: Verif
    trigger OnAfterModify()
    var
        RecLShippingAgent: Record "Shipping Agent";
    begin
        if (Name <> xRec.Name) or
      ("Home Page" <> xRec."Home Page") then
            if "Vendor Type" = "Vendor Type"::Transport then
                if RecLShippingAgent.GET("No.") then begin
                    RecLShippingAgent.Name := Name[20];
                    RecLShippingAgent."Internet Address" := "Home Page";
                    RecLShippingAgent.MODIFY();
                end;

    end;

    var

        RecLShippingAgent: Record "Shipping Agent";


        TextCdeTransp001: Label 'You cannot modify Vendor type because there is Sales Header with the Shipping agent code %1 !!';
        TextCdeTransp002: Label 'You cannot modify Vendor type because there is Purchase Header with the Shipping agent code %1 !!';


}

