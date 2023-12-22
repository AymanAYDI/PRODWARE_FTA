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
                RecLShippingAgent: Record 291;
                RecLSalesHeader: Record 36;
                RecLPurchHeader: Record 38;
                TextCdeTransp001: Label 'You cannot modify Vendor type because there is Sales Header with the Shipping agent code %1 !!';
                TextCdeTransp002: Label 'You cannot modify Vendor type because there is Purchase Header with the Shipping agent code %1 !!';
            begin
                //>>NAVEASY.001 [Cde_Transport] Création du "Code transporteur" = "N° fournisseur"
                // quand "Type fournisseur" = Transport
                IF "Vendor Type" = "Vendor Type"::Transport THEN
                    IF NOT RecLShippingAgent.GET("No.") THEN BEGIN
                        RecLShippingAgent.INIT();
                        RecLShippingAgent.Code := "No."[20];
                        RecLShippingAgent.Name := Name[20];
                        RecLShippingAgent."Internet Address" := "Home Page";
                        RecLShippingAgent.INSERT(TRUE);
                        VALIDATE("Shipping Agent Code", RecLShippingAgent.Code);
                        MODIFY();
                    END ELSE BEGIN
                        RecLShippingAgent.Name := Name[20];
                        RecLShippingAgent."Internet Address" := "Home Page";
                        RecLShippingAgent.MODIFY();
                    END;
                //<<NAVEASY.001 [Cde_Transport] Création du "Code transporteur" = "N° fournisseur"

                //>>NAVEASY.001 [Cde_Transport] Suppression du "Code transporteur" dans table Shipping agent
                // quand type fournisseur passe de Transport à une autre option
                IF (xRec."Vendor Type" = xRec."Vendor Type"::Transport) AND ("Vendor Type" <> "Vendor Type"::Transport) THEN BEGIN

                    //Verification dans les commandes ventes
                    RecLSalesHeader.RESET();
                    RecLSalesHeader.SETCURRENTKEY("Shipping Agent Code");
                    RecLSalesHeader.SETRANGE("Shipping Agent Code", "No.");
                    IF RecLSalesHeader.FINDFIRST() THEN BEGIN
                        "Vendor Type" := "Vendor Type"::Transport;
                        MODIFY();
                        ERROR(STRSUBSTNO(TextCdeTransp001, "No."));
                    END;
                    //Verification dans les commandes achats
                    RecLPurchHeader.RESET();
                    RecLPurchHeader.SETCURRENTKEY("Shipping Agent Code");
                    RecLPurchHeader.SETRANGE("Shipping Agent Code", "No.");
                    IF RecLPurchHeader.FINDFIRST() THEN BEGIN
                        "Vendor Type" := "Vendor Type"::Transport;
                        MODIFY();
                        ERROR(STRSUBSTNO(TextCdeTransp002, "No."));
                    END;

                    //Suppression du code transporteur
                    IF RecLShippingAgent.GET("No.") THEN
                        IF RecLShippingAgent.DELETE() THEN
                            VALIDATE("Shipping Agent Code", '');
                    MODIFY();
                END;
            END;
            //<<NAVEASY.001 [Cde_Transport] Suppression du "Code transporteur" dans table Shipping agent

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
        IF ("Vendor Type" = "Vendor Type"::Transport) THEN BEGIN

            //Verification dans les commandes ventes
            RecLSalesHeader.RESET();
            RecLSalesHeader.SETCURRENTKEY("Shipping Agent Code");
            RecLSalesHeader.SETRANGE("Shipping Agent Code", "No.");
            IF RecLSalesHeader.FINDFIRST() THEN
                ERROR(STRSUBSTNO(TextCdeTransp001, "No."));
        END;
        //Verification dans les commandes achats
        RecLPurchHeader.RESET();
        RecLPurchHeader.SETCURRENTKEY("Shipping Agent Code");
        RecLPurchHeader.SETRANGE(RecLPurchHeader."Shipping Agent Code", "No.");
        IF RecLPurchHeader.FINDFIRST() THEN
            ERROR(STRSUBSTNO(TextCdeTransp002, "No."));
        ;

        //Suppression du code transporteur
        IF ShippingAgent.GET("No.") THEN ShippingAgent.DELETE();
    end;

    trigger OnAfterRename()
    var
        RecLShippingAgent: Record "Shipping Agent";
    begin
        //>>NAVEASY.001 [Cde_Transport] Modification du Code transporteur quand le Fournisseur est renomm‚
        IF "Vendor Type" = "Vendor Type"::Transport THEN
            IF RecLShippingAgent.GET(xRec."No.") THEN
                RecLShippingAgent.RENAME("No.");
        //<<NAVEASY.001 [Cde_Transport] Modification du Code transporteur quand le Fournisseur est renomm‚
    end;

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin

        "Creation Date" := WORKDATE();
        User := USERID();
        //<<NAVEASY.001 [Champs_Suppl] Ajout de code pour alimenter les champs créés

        //>>NAVEASY.001 [Parametres_DEB]
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
        IF (Name <> xRec.Name) OR
      ("Home Page" <> xRec."Home Page") THEN
            IF "Vendor Type" = "Vendor Type"::Transport THEN
                IF RecLShippingAgent.GET("No.") THEN BEGIN
                    RecLShippingAgent.Name := Name[20];
                    RecLShippingAgent."Internet Address" := "Home Page";
                    RecLShippingAgent.MODIFY();
                END;

    end;



    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger 001-)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    MoveEntries.MoveVendorEntries(Rec);

    CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Vendor);
    CommentLine.SETRANGE("No.","No.");
    CommentLine.DELETEALL;

    VendBankAcc.SETRANGE("Vendor No.","No.");
    VendBankAcc.DELETEALL;

    OrderAddr.SETRANGE("Vendor No.","No.");
    OrderAddr.DELETEALL;

    ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
    ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
    ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
    ItemCrossReference.DELETEALL;

    PurchOrderLine.SETCURRENTKEY("Document Type","Pay-to Vendor No.");
    PurchOrderLine.SETFILTER(
      "Document Type",'%1|%2',
      PurchOrderLine."Document Type"::Order,
      PurchOrderLine."Document Type"::"Return Order");
    PurchOrderLine.SETRANGE("Pay-to Vendor No.","No.");
    IF PurchOrderLine.FINDFIRST THEN
      ERROR(
        Text000,
        TABLECAPTION,"No.",
        PurchOrderLine."Document Type");

    PurchOrderLine.SETRANGE("Pay-to Vendor No.");
    PurchOrderLine.SETRANGE("Buy-from Vendor No.","No.");
    IF PurchOrderLine.FINDFIRST THEN
      ERROR(
        Text000,
        TABLECAPTION,"No.");

    UpdateContFromVend.OnDelete(Rec);

    DimMgt.DeleteDefaultDim(DATABASE::Vendor,"No.");

    ServiceItem.SETRANGE("Vendor No.","No.");
    ServiceItem.MODIFYALL("Vendor No.",'');

    ItemVendor.SETRANGE("Vendor No.","No.");
    ItemVendor.DELETEALL(TRUE);

    IF NOT SocialListeningSearchTopic.ISEMPTY THEN BEGIN
      SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Vendor,"No.");
      SocialListeningSearchTopic.DELETEALL;
    END;

    PurchPrice.SETCURRENTKEY("Vendor No.");
    PurchPrice.SETRANGE("Vendor No.","No.");
    PurchPrice.DELETEALL(TRUE);

    PurchLineDiscount.SETCURRENTKEY("Vendor No.");
    PurchLineDiscount.SETRANGE("Vendor No.","No.");
    PurchLineDiscount.DELETEALL(TRUE);

    PurchPrepmtPct.SETCURRENTKEY("Vendor No.");
    PurchPrepmtPct.SETRANGE("Vendor No.","No.");
    PurchPrepmtPct.DELETEALL(TRUE);

    VATRegistrationLogMgt.DeleteVendorLog(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..63
    //>>NAVEASY.001 [Cde_Transport] Suppression du Code transporteur quand le Fournisseur est supprimé
    IF ("Vendor Type" = "Vendor Type"::Transport) THEN BEGIN

       //Verification dans les commandes ventes
       RecLSalesHeader.RESET;
       RecLSalesHeader.SETCURRENTKEY("Shipping Agent Code");
       RecLSalesHeader.SETRANGE("Shipping Agent Code","No.");
       IF RecLSalesHeader.FINDFIRST THEN BEGIN
          ERROR(STRSUBSTNO(TextCdeTransp001,"No."));
       END;
       //Verification dans les commandes achats
       RecLPurchHeader.RESET;
       RecLPurchHeader.SETCURRENTKEY("Shipping Agent Code");
       RecLPurchHeader.SETRANGE(RecLPurchHeader."Shipping Agent Code","No.");
       IF RecLPurchHeader.FINDFIRST THEN BEGIN
          ERROR(STRSUBSTNO(TextCdeTransp002,"No."));
       END;

       //Suppression du code transporteur
       IF RecLShippingAgent.GET("No.") THEN RecLShippingAgent.DELETE;
    END;

    //<<NAVEASY.001 [Cde_Transport] Suppression du Code transporteur quand le Fournisseur est supprimé
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "No." = '' THEN BEGIN
      PurchSetup.GET;
      PurchSetup.TESTFIELD("Vendor Nos.");
      NoSeriesMgt.InitSeries(PurchSetup."Vendor Nos.",xRec."No. Series",0D,"No.","No. Series");
    END;
    IF "Invoice Disc. Code" = '' THEN
      "Invoice Disc. Code" := "No.";

    IF NOT InsertFromContact THEN
      UpdateContFromVend.OnInsert(Rec);

    DimMgt.UpdateDefaultDim(
      DATABASE::Vendor,"No.",
      "Global Dimension 1 Code","Global Dimension 2 Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14

    //>>NAVEASY.001 [Champs_Suppl] Ajout de code pour alimenter les champs créés
    "Creation Date" := WORKDATE;
    User := USERID;
    //<<NAVEASY.001 [Champs_Suppl] Ajout de code pour alimenter les champs créés

    //>>NAVEASY.001 [Parametres_DEB]
    PurchSetup.GET;
    "Transaction Type" := PurchSetup."Transaction Type";
    "Transaction Specification" := PurchSetup."Transaction Specification";
    "Transport Method" := PurchSetup."Transport Method";
    "Entry Point" := PurchSetup."Entry  Point";
    Area := PurchSetup.Area;
    //<<NAVEASY.001 [Parametres_DEB]
    */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnModify".

    //trigger 001-)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Last Date Modified" := TODAY;

    IF (Name <> xRec.Name) OR
       ("Search Name" <> xRec."Search Name") OR
       ("Name 2" <> xRec."Name 2") OR
       (Address <> xRec.Address) OR
       ("Address 2" <> xRec."Address 2") OR
       (City <> xRec.City) OR
       ("Phone No." <> xRec."Phone No.") OR
       ("Telex No." <> xRec."Telex No.") OR
       ("Territory Code" <> xRec."Territory Code") OR
       ("Currency Code" <> xRec."Currency Code") OR
       ("Language Code" <> xRec."Language Code") OR
       ("Purchaser Code" <> xRec."Purchaser Code") OR
       ("Country/Region Code" <> xRec."Country/Region Code") OR
       ("Fax No." <> xRec."Fax No.") OR
       ("Telex Answer Back" <> xRec."Telex Answer Back") OR
       ("VAT Registration No." <> xRec."VAT Registration No.") OR
       ("Post Code" <> xRec."Post Code") OR
       (County <> xRec.County) OR
       ("E-Mail" <> xRec."E-Mail") OR
       ("Home Page" <> xRec."Home Page")
    THEN BEGIN
      MODIFY;
      UpdateContFromVend.OnModify(Rec);
      FIND;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..27
    //>>NAVEASY.001 [Cde_Transport] Modification du Nom du transporteur quand le Nom Fournisseur est modifié
    IF (Name <> xRec.Name) OR
       ("Home Page" <> xRec."Home Page") THEN
       IF "Vendor Type" =  "Vendor Type"::Transport THEN
         IF RecLShippingAgent.GET("No.") THEN BEGIN
           RecLShippingAgent.Name:= Name;
           RecLShippingAgent."Internet Address":="Home Page";
           RecLShippingAgent.MODIFY;
         END;
    //<<NAVEASY.001 [Cde_Transport] Modification du Nom du transporteur quand le Nom Fournisseur est modifié
    */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnRename".

    //trigger 001-)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Last Date Modified" := TODAY;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Last Date Modified" := TODAY;

    //>>NAVEASY.001 [Cde_Transport] Modification du Code transporteur quand le Fournisseur est renommé
    IF "Vendor Type" =  "Vendor Type"::Transport THEN
       IF RecLShippingAgent.GET(xRec."No.") THEN
          RecLShippingAgent.RENAME("No.");
    //<<NAVEASY.001 [Cde_Transport] Modification du Code transporteur quand le Fournisseur est renommé
    */
    //end;


    //Unsupported feature: Property Modification (Id) on "OnDelete.SocialListeningSearchTopic(Variable 1005)".

    //var
    //>>>> ORIGINAL VALUE:
    //OnDelete.SocialListeningSearchTopic : 1005;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //OnDelete.SocialListeningSearchTopic : 1100267000;
    //Variable type has not been exported.

    var

        RecLShippingAgent: Record "Shipping Agent";


        TextCdeTransp001: Label 'You cannot modify Vendor type because there is Sales Header with the Shipping agent code %1 !!';
        TextCdeTransp002: Label 'You cannot modify Vendor type because there is Purchase Header with the Shipping agent code %1 !!';


}

