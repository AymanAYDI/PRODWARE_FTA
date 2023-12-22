namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Foundation.Shipping;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Team;
tableextension 50009 SalesHeader extends "Sales Header" //36
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            Description = 'FTA1.01';
        }
        modify("Customer Posting Group")
        {

            //Unsupported feature: Property Modification (Editable) on ""Customer Posting Group"(Field 31)".

            Description = 'NAVEASY.001 [Multi_Collectif] Propriété EDITABLE No => Yes';
        }

        //Unsupported feature: Code Insertion (VariableCollection) on ""Sell-to Customer No."(Field 2).OnValidate".

        //trigger (Variable: RecLCommentLine)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Sell-to Customer No."(Field 2).OnValidate".

        //trigger "(Field 2)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CheckCreditLimitIfLineNotInsertedYet;
        TESTFIELD(Status,Status::Open);
        IF ("Sell-to Customer No." <> xRec."Sell-to Customer No.") AND
           (xRec."Sell-to Customer No." <> '')
        THEN BEGIN
          IF ("Opportunity No." <> '') AND ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) THEN
            ERROR(
              Text062,
              FIELDCAPTION("Sell-to Customer No."),
              FIELDCAPTION("Opportunity No."),
              "Opportunity No.",
              "Document Type");
          IF HideValidationDialog OR NOT GUIALLOWED THEN
            Confirmed := TRUE
          ELSE
            Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Sell-to Customer No."));
          IF Confirmed THEN BEGIN
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            IF "Sell-to Customer No." = '' THEN BEGIN
              IF SalesLine.FINDFIRST THEN
                ERROR(
                  Text005,
                  FIELDCAPTION("Sell-to Customer No."));
              INIT;
              SalesSetup.GET;
              "No. Series" := xRec."No. Series";
              InitRecord;
              IF xRec."Shipping No." <> '' THEN BEGIN
                "Shipping No. Series" := xRec."Shipping No. Series";
                "Shipping No." := xRec."Shipping No.";
              END;
              IF xRec."Posting No." <> '' THEN BEGIN
                "Posting No. Series" := xRec."Posting No. Series";
                "Posting No." := xRec."Posting No.";
              END;
              IF xRec."Return Receipt No." <> '' THEN BEGIN
                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                "Return Receipt No." := xRec."Return Receipt No.";
              END;
              IF xRec."Prepayment No." <> '' THEN BEGIN
                "Prepayment No. Series" := xRec."Prepayment No. Series";
                "Prepayment No." := xRec."Prepayment No.";
              END;
              IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
              END;
              EXIT;
            END;
            IF "Document Type" = "Document Type"::Order THEN
              SalesLine.SETFILTER("Quantity Shipped",'<>0')
            ELSE
              IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                SalesLine.SETRANGE("Sell-to Customer No.",xRec."Sell-to Customer No.");
                SalesLine.SETFILTER("Shipment No.",'<>%1','');
              END;

            IF SalesLine.FINDFIRST THEN
              IF "Document Type" = "Document Type"::Order THEN
                SalesLine.TESTFIELD("Quantity Shipped",0)
              ELSE
                SalesLine.TESTFIELD("Shipment No.",'');
            SalesLine.SETRANGE("Shipment No.");
            SalesLine.SETRANGE("Quantity Shipped");

            IF "Document Type" = "Document Type"::Order THEN BEGIN
              SalesLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
              IF SalesLine.FIND('-') THEN
                SalesLine.TESTFIELD("Prepmt. Amt. Inv.",0);
              SalesLine.SETRANGE("Prepmt. Amt. Inv.");
            END;

            IF "Document Type" = "Document Type"::"Return Order" THEN
              SalesLine.SETFILTER("Return Qty. Received",'<>0')
            ELSE
              IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                SalesLine.SETRANGE("Sell-to Customer No.",xRec."Sell-to Customer No.");
                SalesLine.SETFILTER("Return Receipt No.",'<>%1','');
              END;

            IF SalesLine.FINDFIRST THEN
              IF "Document Type" = "Document Type"::"Return Order" THEN
                SalesLine.TESTFIELD("Return Qty. Received",0)
              ELSE
                SalesLine.TESTFIELD("Return Receipt No.",'');
            SalesLine.RESET
          END ELSE BEGIN
            Rec := xRec;
            EXIT;
          END;
        END;

        IF ("Document Type" = "Document Type"::Order) AND
           (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
        THEN BEGIN
          SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Purch. Order Line No.",'<>0');
          IF NOT SalesLine.ISEMPTY THEN
            ERROR(
              Text006,
              FIELDCAPTION("Sell-to Customer No."));
          SalesLine.RESET;
        END;

        GetCust("Sell-to Customer No.");

        Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
        Cust.TESTFIELD("Gen. Bus. Posting Group");
        "Sell-to Customer Template Code" := '';
        "Sell-to Customer Name" := Cust.Name;
        "Sell-to Customer Name 2" := Cust."Name 2";
        "Sell-to Address" := Cust.Address;
        "Sell-to Address 2" := Cust."Address 2";
        "Sell-to City" := Cust.City;
        "Sell-to Post Code" := Cust."Post Code";
        "Sell-to County" := Cust.County;
        "Sell-to Country/Region Code" := Cust."Country/Region Code";
        IF NOT SkipSellToContact THEN
          "Sell-to Contact" := Cust.Contact;
        "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
        "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
        "Tax Area Code" := Cust."Tax Area Code";
        "Tax Liable" := Cust."Tax Liable";
        "VAT Registration No." := Cust."VAT Registration No.";
        "VAT Country/Region Code" := Cust."Country/Region Code";
        "Shipping Advice" := Cust."Shipping Advice";
        "Responsibility Center" := UserSetupMgt.GetRespCenter(0,Cust."Responsibility Center");
        VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));

        IF "Sell-to Customer No." = xRec."Sell-to Customer No." THEN
          IF ShippedSalesLinesExist OR ReturnReceiptExist THEN BEGIN
            TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
            TESTFIELD("Gen. Bus. Posting Group",xRec."Gen. Bus. Posting Group");
          END;

        "Sell-to IC Partner Code" := Cust."IC Partner Code";
        "Send IC Document" := ("Sell-to IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);

        IF Cust."Bill-to Customer No." <> '' THEN
          VALIDATE("Bill-to Customer No.",Cust."Bill-to Customer No.")
        ELSE BEGIN
          IF "Bill-to Customer No." = "Sell-to Customer No." THEN
            SkipBillToContact := TRUE;
          VALIDATE("Bill-to Customer No.","Sell-to Customer No.");
          SkipBillToContact := FALSE;
        END;
        VALIDATE("Ship-to Code",'');

        GetShippingTime(FIELDNO("Sell-to Customer No."));

        IF (xRec."Sell-to Customer No." <> "Sell-to Customer No.") OR
           (xRec."Currency Code" <> "Currency Code") OR
           (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") OR
           (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
        THEN
          RecreateSalesLines(FIELDCAPTION("Sell-to Customer No."));

        IF NOT SkipSellToContact THEN
          UpdateSellToCont("Sell-to Customer No.");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #2..119
        //>>NAVEASY.001 [Parametres_DEB]
        "Transaction Type" := Cust."Transaction Type";
        "Transaction Specification" := Cust."Transaction Specification";
        "Transport Method" := Cust."Transport Method";
        "Exit Point" := Cust."Exit Point";
        Area := Cust.Area;
        "EU 3-Party Trade" := Cust."EU 3-Party Trade";
        //<<NAVEASY.001 [Parametres_DEB]

        //>>FED_20090415:PA 15/04/2009
        "Posting Description" := Cust.Name;
        //<<FED_20090415:PA 15/04/2009

        //>> 13/01/2010
        "Fax No." := Cust."Fax No.";
        "E-Mail"  := Cust."E-Mail";
        //<< 13/01/2010

        #120..161

        //>>FED_20090415:PA 15/04/2009
        IF "Sell-to Customer No." <> '' THEN
          IF NOT ("Document Type" = "Document Type"::Invoice) AND NOT ("Document Type" = "Document Type"::"Credit Memo") THEN BEGIN
            IF RecLSalesHeader.GET("Document Type","No.") THEN BEGIN
            //MESSAGE( "Sell-to Customer No.");
            RecLCommentLine.SETRANGE("Table Name",RecLCommentLine."Table Name"::Customer);
            RecLCommentLine.SETRANGE("No.","Sell-to Customer No.");
            IF RecLCommentLine.FINDFIRST THEN BEGIN
              CLEAR(FrmLCommentSheet);
              FrmLCommentSheet.SETTABLEVIEW(RecLCommentLine);
              FrmLCommentSheet.EDITABLE(FALSE);
              FrmLCommentSheet.RUN;
            END;
          END;
        END;
        //<<FED_20090415:PA 15/04/2009

        //>>PWD FTA1.01.002 FEP_VENTE_200910_EnvoiPdfFax 02/02/2010----->>>
        IF RecGContact.GET("Sell-to Contact No.") THEN
        BEGIN
           "E-Mail" := RecGContact."E-Mail";
           "Fax No." := RecGContact."Fax No.";
           "Subject Mail" := '';
        END
        ELSE
        BEGIN
           "E-Mail" := '';
           "Fax No." := '';
           "Subject Mail" := '';
        END;
        //<<PWD FTA1.01.002 FEP_VENTE_200910_EnvoiPdfFax 02/02/2010----<<<<
        */
        //end;


        //Unsupported feature: Code Modification on ""Bill-to Customer No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
        IF BilltoCustomerNoChanged THEN
          IF xRec."Bill-to Customer No." = '' THEN
            InitRecord
          ELSE BEGIN
            VALIDATE("Credit Card No.",'');
            IF HideValidationDialog OR NOT GUIALLOWED THEN
              Confirmed := TRUE
            ELSE
              Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Bill-to Customer No."));
            IF Confirmed THEN BEGIN
              SalesLine.SETRANGE("Document Type","Document Type");
              SalesLine.SETRANGE("Document No.","No.");
              IF "Document Type" = "Document Type"::Order THEN
                SalesLine.SETFILTER("Quantity Shipped",'<>0')
              ELSE
                IF "Document Type" = "Document Type"::Invoice THEN
                  SalesLine.SETFILTER("Shipment No.",'<>%1','');

              IF SalesLine.FINDFIRST THEN
                IF "Document Type" = "Document Type"::Order THEN
                  SalesLine.TESTFIELD("Quantity Shipped",0)
                ELSE
                  SalesLine.TESTFIELD("Shipment No.",'');
              SalesLine.SETRANGE("Shipment No.");
              SalesLine.SETRANGE("Quantity Shipped");

              IF "Document Type" = "Document Type"::Order THEN BEGIN
                SalesLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
                IF SalesLine.FIND('-') THEN
                  SalesLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                SalesLine.SETRANGE("Prepmt. Amt. Inv.");
              END;

              IF "Document Type" = "Document Type"::"Return Order" THEN
                SalesLine.SETFILTER("Return Qty. Received",'<>0')
              ELSE
                IF "Document Type" = "Document Type"::"Credit Memo" THEN
                  SalesLine.SETFILTER("Return Receipt No.",'<>%1','');

              IF SalesLine.FINDFIRST THEN
                IF "Document Type" = "Document Type"::"Return Order" THEN
                  SalesLine.TESTFIELD("Return Qty. Received",0)
                ELSE
                  SalesLine.TESTFIELD("Return Receipt No.",'');
              SalesLine.RESET
            END ELSE
              "Bill-to Customer No." := xRec."Bill-to Customer No.";
          END;

        GetCust("Bill-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
        Cust.TESTFIELD("Customer Posting Group");
        CheckCrLimit;
        "Bill-to Customer Template Code" := '';
        "Bill-to Name" := Cust.Name;
        "Bill-to Name 2" := Cust."Name 2";
        "Bill-to Address" := Cust.Address;
        "Bill-to Address 2" := Cust."Address 2";
        "Bill-to City" := Cust.City;
        "Bill-to Post Code" := Cust."Post Code";
        "Bill-to County" := Cust.County;
        "Bill-to Country/Region Code" := Cust."Country/Region Code";
        IF NOT SkipBillToContact THEN
          "Bill-to Contact" := Cust.Contact;
        "Payment Terms Code" := Cust."Payment Terms Code";
        "Prepmt. Payment Terms Code" := Cust."Payment Terms Code";

        IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
          "Payment Method Code" := '';
          IF PaymentTerms.GET("Payment Terms Code") THEN
            IF PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN
              "Payment Method Code" := Cust."Payment Method Code"
        END ELSE
          "Payment Method Code" := Cust."Payment Method Code";

        GLSetup.GET;
        IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN BEGIN
          "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
          "VAT Country/Region Code" := Cust."Country/Region Code";
          "VAT Registration No." := Cust."VAT Registration No.";
          "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
        END;
        "Customer Posting Group" := Cust."Customer Posting Group";
        "Currency Code" := Cust."Currency Code";
        "Customer Price Group" := Cust."Customer Price Group";
        "Prices Including VAT" := Cust."Prices Including VAT";
        "Allow Line Disc." := Cust."Allow Line Disc.";
        "Invoice Disc. Code" := Cust."Invoice Disc. Code";
        "Customer Disc. Group" := Cust."Customer Disc. Group";
        "Language Code" := Cust."Language Code";
        "Salesperson Code" := Cust."Salesperson Code";
        "Combine Shipments" := Cust."Combine Shipments";
        Reserve := Cust.Reserve;
        IF "Document Type" = "Document Type"::Order THEN
          "Prepayment %" := Cust."Prepayment %";

        IF NOT BilltoCustomerNoChanged THEN BEGIN
          IF ShippedSalesLinesExist THEN BEGIN
            TESTFIELD("Customer Disc. Group",xRec."Customer Disc. Group");
            TESTFIELD("Currency Code",xRec."Currency Code");
          END;
        END;

        CreateDim(
          DATABASE::Customer,"Bill-to Customer No.",
          DATABASE::"Salesperson/Purchaser","Salesperson Code",
          DATABASE::Campaign,"Campaign No.",
          DATABASE::"Responsibility Center","Responsibility Center",
          DATABASE::"Customer Template","Bill-to Customer Template Code");

        VALIDATE("Payment Terms Code");
        VALIDATE("Prepmt. Payment Terms Code");
        VALIDATE("Payment Method Code");
        VALIDATE("Currency Code");
        VALIDATE("Prepayment %");

        IF (xRec."Sell-to Customer No." = "Sell-to Customer No.") AND
           BilltoCustomerNoChanged
        THEN BEGIN
          RecreateSalesLines(FIELDCAPTION("Bill-to Customer No."));
          BilltoCustomerNoChanged := FALSE;
        END;
        IF NOT SkipBillToContact THEN
          UpdateBillToCont("Bill-to Customer No.");

        "Bill-to IC Partner Code" := Cust."IC Partner Code";
        "Send IC Document" := ("Bill-to IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..93

        //>>FTA1.04
        "Mobile Salesperson Code" := Cust."Mobile Salesperson Code";
        "Customer Typology" := Cust."Customer Typology";
        //<<FTA1.04

        #94..129
        */
        //end;


        //Unsupported feature: Code Modification on ""Ship-to Code"(Field 12).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ("Document Type" = "Document Type"::Order) AND
           (xRec."Ship-to Code" <> "Ship-to Code")
        THEN BEGIN
          SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Purch. Order Line No.",'<>0');
          IF NOT SalesLine.ISEMPTY THEN
            ERROR(
              Text006,
              FIELDCAPTION("Ship-to Code"));
          SalesLine.RESET;
        END;

        IF ("Document Type" <> "Document Type"::"Return Order") AND
           ("Document Type" <> "Document Type"::"Credit Memo")
        THEN
          IF "Ship-to Code" <> '' THEN BEGIN
            IF xRec."Ship-to Code" <> '' THEN
              BEGIN
              GetCust("Sell-to Customer No.");
              IF Cust."Location Code" <> '' THEN
                VALIDATE("Location Code",Cust."Location Code");
              "Tax Area Code" := Cust."Tax Area Code";
            END;
            ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
            "Ship-to Name" := ShipToAddr.Name;
            "Ship-to Name 2" := ShipToAddr."Name 2";
            "Ship-to Address" := ShipToAddr.Address;
            "Ship-to Address 2" := ShipToAddr."Address 2";
            "Ship-to City" := ShipToAddr.City;
            "Ship-to Post Code" := ShipToAddr."Post Code";
            "Ship-to County" := ShipToAddr.County;
            VALIDATE("Ship-to Country/Region Code",ShipToAddr."Country/Region Code");
            "Ship-to Contact" := ShipToAddr.Contact;
            "Shipment Method Code" := ShipToAddr."Shipment Method Code";
            IF ShipToAddr."Location Code" <> '' THEN
              VALIDATE("Location Code",ShipToAddr."Location Code");
            "Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
            "Shipping Agent Service Code" := ShipToAddr."Shipping Agent Service Code";
            IF ShipToAddr."Tax Area Code" <> '' THEN
              "Tax Area Code" := ShipToAddr."Tax Area Code";
            "Tax Liable" := ShipToAddr."Tax Liable";
          END ELSE
            IF "Sell-to Customer No." <> '' THEN BEGIN
              GetCust("Sell-to Customer No.");
              "Ship-to Name" := Cust.Name;
              "Ship-to Name 2" := Cust."Name 2";
              "Ship-to Address" := Cust.Address;
              "Ship-to Address 2" := Cust."Address 2";
              "Ship-to City" := Cust.City;
              "Ship-to Post Code" := Cust."Post Code";
              "Ship-to County" := Cust.County;
              VALIDATE("Ship-to Country/Region Code",Cust."Country/Region Code");
              "Ship-to Contact" := Cust.Contact;
              "Shipment Method Code" := Cust."Shipment Method Code";
              "Tax Area Code" := Cust."Tax Area Code";
              "Tax Liable" := Cust."Tax Liable";
              IF Cust."Location Code" <> '' THEN
                VALIDATE("Location Code",Cust."Location Code");
              "Shipping Agent Code" := Cust."Shipping Agent Code";
              "Shipping Agent Service Code" := Cust."Shipping Agent Service Code";
            END;

        GetShippingTime(FIELDNO("Ship-to Code"));

        IF (xRec."Sell-to Customer No." = "Sell-to Customer No.") AND
           (xRec."Ship-to Code" <> "Ship-to Code")
        THEN
          IF (xRec."VAT Country/Region Code" <> "VAT Country/Region Code") OR
             (xRec."Tax Area Code" <> "Tax Area Code")
          THEN
            RecreateSalesLines(FIELDCAPTION("Ship-to Code"))
          ELSE BEGIN
            IF xRec."Shipping Agent Code" <> "Shipping Agent Code" THEN
              MessageIfSalesLinesExist(FIELDCAPTION("Shipping Agent Code"));
            IF xRec."Shipping Agent Service Code" <> "Shipping Agent Service Code" THEN
              MessageIfSalesLinesExist(FIELDCAPTION("Shipping Agent Service Code"));
            IF xRec."Tax Liable" <> "Tax Liable" THEN
              VALIDATE("Tax Liable");
          END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..42
            //>>NAVEASY.001 [Parametres_DEB]
            "Transaction Type" := ShipToAddr."Transaction Type";
            "Transaction Specification" := ShipToAddr."Transaction Specification";
            "Transport Method" := ShipToAddr."Transport Method";
            "Exit Point" := ShipToAddr."Exit Point";
            Area := ShipToAddr.Area;
            "EU 3-Party Trade" := ShipToAddr."EU 3-Party Trade";
            //<<NAVEASY.001 [Parametres_DEB]


        #43..80
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Shipping Agent Code"(Field 105).OnValidate".

        //trigger (Variable: RecLPurchHeader)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Shipping Agent Code"(Field 105).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        IF xRec."Shipping Agent Code" = "Shipping Agent Code" THEN
          EXIT;

        "Shipping Agent Service Code" := '';
        GetShippingTime(FIELDNO("Shipping Agent Code"));
        UpdateSalesLines(FIELDCAPTION("Shipping Agent Code"),CurrFieldNo <> 0);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3
        //>>NAVEASY.001 [Cde_Transport] Test lors de la modification du Code transporteur
        IF "Shipping Order No."<>'' THEN
          ERROR(STRSUBSTNO(TextCdeTransp003,"Shipping Order No."));

        IF (xRec."Shipping Agent Code"<>'') AND ("Shipping Agent Code" = '') THEN
          RecLPurchHeader.TestVerifExistence("No.");

        IF ShippingAgent.GET("Shipping Agent Code") THEN
          "Shipping Agent Name" := ShippingAgent.Name
        ELSE
          "Shipping Agent Name" := '';

        //<<NAVEASY.001 [Cde_Transport] Test lors de la modification du Code transporteur
        #4..7
        */
        //end;


        //Unsupported feature: Code Modification on ""Sell-to Contact No."(Field 5052).OnValidate".

        //trigger "(Field 5052)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);

        IF ("Sell-to Contact No." <> xRec."Sell-to Contact No.") AND
           (xRec."Sell-to Contact No." <> '')
        THEN BEGIN
          IF ("Sell-to Contact No." = '') AND ("Opportunity No." <> '') THEN
            ERROR(Text049,FIELDCAPTION("Sell-to Contact No."));
          IF HideValidationDialog OR NOT GUIALLOWED THEN
            Confirmed := TRUE
          ELSE
            Confirmed := CONFIRM(Text004,FALSE,FIELDCAPTION("Sell-to Contact No."));
          IF Confirmed THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type","Document Type");
            SalesLine.SETRANGE("Document No.","No.");
            IF ("Sell-to Contact No." = '') AND ("Sell-to Customer No." = '') THEN BEGIN
              IF NOT SalesLine.ISEMPTY THEN
                ERROR(Text005,FIELDCAPTION("Sell-to Contact No."));
              INIT;
              SalesSetup.GET;
              InitRecord;
              "No. Series" := xRec."No. Series";
              IF xRec."Shipping No." <> '' THEN BEGIN
                "Shipping No. Series" := xRec."Shipping No. Series";
                "Shipping No." := xRec."Shipping No.";
              END;
              IF xRec."Posting No." <> '' THEN BEGIN
                "Posting No. Series" := xRec."Posting No. Series";
                "Posting No." := xRec."Posting No.";
              END;
              IF xRec."Return Receipt No." <> '' THEN BEGIN
                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                "Return Receipt No." := xRec."Return Receipt No.";
              END;
              IF xRec."Prepayment No." <> '' THEN BEGIN
                "Prepayment No. Series" := xRec."Prepayment No. Series";
                "Prepayment No." := xRec."Prepayment No.";
              END;
              IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
              END;
              EXIT;
            END;
            IF "Opportunity No." <> '' THEN BEGIN
              Opportunity.GET("Opportunity No.");
              IF Opportunity."Contact No." <> "Sell-to Contact No." THEN BEGIN
                MODIFY;
                Opportunity.VALIDATE("Contact No.","Sell-to Contact No.");
                Opportunity.MODIFY;
              END
            END;
          END ELSE BEGIN
            Rec := xRec;
            EXIT;
          END;
        END;

        IF ("Sell-to Customer No." <> '') AND ("Sell-to Contact No." <> '') THEN BEGIN
          Cont.GET("Sell-to Contact No.");
          ContBusinessRelation.RESET;
          ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
          ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
          ContBusinessRelation.SETRANGE("No.","Sell-to Customer No.");
          IF ContBusinessRelation.FINDFIRST THEN
            IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
              ERROR(Text038,Cont."No.",Cont.Name,"Sell-to Customer No.");
        END;

        UpdateSellToCust("Sell-to Contact No.");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..70

        //>>PWD FTA1.01.002 FEP_VENTE_200910_EnvoiPdfFax 02/02/2010----->>>
        IF RecGContact.GET("Sell-to Contact No.") THEN
        BEGIN
           "E-Mail" := RecGContact."E-Mail";
           "Fax No." := RecGContact."Fax No.";
           "Subject Mail" := '';
        END
        ELSE
        BEGIN
           "E-Mail" := '';
           "Fax No." := '';
           "Subject Mail" := '';
        END;
        //<<PWD FTA1.01.002 FEP_VENTE_200910_EnvoiPdfFax 02/02/2010----<<<<
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Requested Delivery Date"(Field 5790).OnValidate".

        //trigger (Variable: RecLSalesLine)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Requested Delivery Date"(Field 5790).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        IF "Promised Delivery Date" <> 0D THEN
          ERROR(
            Text028,
            FIELDCAPTION("Requested Delivery Date"),
            FIELDCAPTION("Promised Delivery Date"));

        IF "Requested Delivery Date" <> xRec."Requested Delivery Date" THEN
          UpdateSalesLines(FIELDCAPTION("Requested Delivery Date"),CurrFieldNo <> 0);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7
        //>>FED_20090415:PA 15/04/2009
        RecLSalesLine.SETRANGE("Document Type","Document Type");
        RecLSalesLine.SETRANGE("Document No.","No.");
        RecLSalesLine.SETFILTER("Promised Delivery Date",'>%1',"Requested Delivery Date");
        RecLSalesLine.SETRANGE(Type,RecLSalesLine.Type::Item);

        IF NOT RecLSalesLine.ISEMPTY THEN BEGIN
          RecLSalesLine.FINDSET;
          REPEAT
            RecLSalesLine.CALCFIELDS("Reserved Qty. (Base)");
            IF RecLSalesLine."Reserved Qty. (Base)" <> 0 THEN
              IF NOT CONFIRM(CstL001,FALSE) THEN
                ERROR(CstL002);
          UNTIL (RecLSalesLine.NEXT = 0) OR (RecLSalesLine."Reserved Qty. (Base)" <> 0);
        END;
        //<<FED_20090415:PA 15/04/2009


        IF "Requested Delivery Date" <> xRec."Requested Delivery Date" THEN
          UpdateSalesLines(FIELDCAPTION("Requested Delivery Date"),CurrFieldNo <> 0);

        //>>NAVEASY.001 [Cde_Tansport]
        IF "Promised Delivery Date" <> 0D THEN
          "Planned Shipment Date" := CALCDATE("Shipping Time","Promised Delivery Date")
        ELSE IF "Requested Delivery Date" <> 0D THEN
          "Planned Shipment Date" := CALCDATE("Shipping Time","Requested Delivery Date");
        //<<NAVEASY.001 [Cde_Tansport]

        //>>NDBI
        IF "Requested Delivery Date" <> 0D THEN
          VALIDATE("Order Shipment Date",CALCDATE('<-2D>',"Requested Delivery Date"));
        //<<NDBI
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Promised Delivery Date"(Field 5791).OnValidate".

        //trigger (Variable: RecLSalesLine)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Promised Delivery Date"(Field 5791).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        IF "Promised Delivery Date" <> xRec."Promised Delivery Date" THEN
          UpdateSalesLines(FIELDCAPTION("Promised Delivery Date"),CurrFieldNo <> 0);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);

        //>>FED_20090415:PA 15/04/2009
        RecLSalesLine.SETRANGE("Document Type","Document Type");
        RecLSalesLine.SETRANGE("Document No.","No.");
        RecLSalesLine.SETFILTER("Requested Delivery Date",'>%1',"Promised Delivery Date");
        RecLSalesLine.SETRANGE(Type,RecLSalesLine.Type::Item);

        IF NOT RecLSalesLine.ISEMPTY THEN BEGIN
          RecLSalesLine.FINDSET;
          REPEAT
            RecLSalesLine.CALCFIELDS("Reserved Qty. (Base)");
            IF RecLSalesLine."Reserved Qty. (Base)" <> 0 THEN
              IF NOT CONFIRM(CstL001,FALSE) THEN
                ERROR(CstL002);
          UNTIL (RecLSalesLine.NEXT = 0) OR (RecLSalesLine."Reserved Qty. (Base)" <> 0);
        END;
        //<<FED_20090415:PA 15/04/2009


        IF "Promised Delivery Date" <> xRec."Promised Delivery Date" THEN
          UpdateSalesLines(FIELDCAPTION("Promised Delivery Date"),CurrFieldNo <> 0);

        //>>NAVEASY.001 [Cde_Tansport]
        IF "Promised Delivery Date" <> 0D THEN
          "Planned Shipment Date" := CALCDATE("Shipping Time","Promised Delivery Date")
        ELSE IF "Requested Delivery Date" <> 0D THEN
          "Planned Shipment Date" := CALCDATE("Shipping Time","Requested Delivery Date");
        //<<NAVEASY.001 [Cde_Tansport]

        //>>NDBI
        IF "Promised Delivery Date" <> 0D THEN
          VALIDATE("Order Shipment Date",CALCDATE('<-2D>',"Promised Delivery Date"));
        //<<NDBI
        */
        //end;


        //Unsupported feature: Code Modification on ""Shipping Time"(Field 5792).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Status,Status::Open);
        IF "Shipping Time" <> xRec."Shipping Time" THEN
          UpdateSalesLines(FIELDCAPTION("Shipping Time"),CurrFieldNo <> 0);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3

        //>>NAVEASY.001 [Cde_Tansport]
        IF "Promised Delivery Date" <> 0D THEN
          "Planned Shipment Date" := CALCDATE("Shipping Time","Promised Delivery Date")
        ELSE IF "Requested Delivery Date" <> 0D THEN
          "Planned Shipment Date" := CALCDATE("Shipping Time","Requested Delivery Date");
        //<<NAVEASY.001 [Cde_Tansport]
        */
        //end;
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
                //>>FTA:AM  31.03.2023
                IF ("Total weight" <> 0) AND ("Total Parcels" <> 0) THEN
                    CreateShipCosts();

                IF ("Total weight" = 0) OR ("Total Parcels" = 0) THEN
                    DeleteOpenShipCostLine();
                //<<FTA:AM  31.03.2023
            end;
        }
        field(50003; "Total Parcels"; Decimal)
        {
            Caption = 'Total Parcels';
            DecimalPlaces = 0 : 2;
            Description = 'FTA1.00';

            trigger OnValidate()
            begin
                //>>FTA:AM  31.03.2023
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
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
                ContactListPage: Page "5052";
            begin
                //>> FTA1.02
                IF NOT ("Document Type" IN ["Document Type"::Quote, "Document Type"::Order]) THEN
                    EXIT;

                IF "Sell-to Customer No." <> '' THEN
                    IF Cont.GET("Sell-to Contact No.") THEN
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    ELSE BEGIN
                        ContBusinessRelation.RESET;
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SETRANGE("No.", "Sell-to Customer No.");
                        IF ContBusinessRelation.FINDFIRST THEN
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
                IF ContactListPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    // IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                    // xRec := Rec;
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
                RecLUserSetup: Record "91";
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
            // TODO table spec TableRelation = "Customer Typology";
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
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger 001--)()
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
    IF DOPaymentTransLogEntry.FINDFIRST THEN
      DOPaymentTransLogMgt.ValidateCanDeleteDocument("Payment Method Code","Document Type",FORMAT("Document Type"),"No.");

    IF NOT UserSetupMgt.CheckRespCenter(0,"Responsibility Center") THEN
      ERROR(
        Text022,
        RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter);

    IF ("Opportunity No." <> '') AND
       ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order])
    THEN
      IF Opp.GET("Opportunity No.") THEN BEGIN
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          IF NOT CONFIRM(Text040,TRUE) THEN
            ERROR(Text044);
          TempOpportunityEntry.INIT;
          TempOpportunityEntry.VALIDATE("Opportunity No.",Opp."No.");
          TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
          TempOpportunityEntry."Contact No." := Opp."Contact No.";
          TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
          TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
          TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
          TempOpportunityEntry."Action Taken" := TempOpportunityEntry."Action Taken"::Lost;
          TempOpportunityEntry.INSERT;
          TempOpportunityEntry.SETRANGE("Action Taken",TempOpportunityEntry."Action Taken"::Lost);
          PAGE.RUNMODAL(PAGE::"Close Opportunity",TempOpportunityEntry);
          IF Opp.GET("Opportunity No.") THEN
            IF Opp.Status <> Opp.Status::Lost THEN
              ERROR(Text043);
        END;
        Opp."Sales Document Type" := Opp."Sales Document Type"::" ";
        Opp."Sales Document No." := '';
        Opp.MODIFY;
        "Opportunity No." := '';
      END;

    SalesPost.DeleteHeader(
      Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,SalesInvHeaderPrepmt,SalesCrMemoHeaderPrepmt);
    VALIDATE("Applies-to ID",'');

    ApprovalMgt.DeleteApprovalEntry(DATABASE::"Sales Header","Document Type","No.");
    SalesLine.RESET;
    SalesLine.LOCKTABLE;

    WhseRequest.SETRANGE("Source Type",DATABASE::"Sales Line");
    WhseRequest.SETRANGE("Source Subtype","Document Type");
    WhseRequest.SETRANGE("Source No.","No.");
    WhseRequest.DELETEALL(TRUE);

    SalesLine.SETRANGE("Document Type","Document Type");
    SalesLine.SETRANGE("Document No.","No.");
    SalesLine.SETRANGE(Type,SalesLine.Type::"Charge (Item)");

    DeleteSalesLines;
    SalesLine.SETRANGE(Type);
    DeleteSalesLines;

    SalesCommentLine.SETRANGE("Document Type","Document Type");
    SalesCommentLine.SETRANGE("No.","No.");
    SalesCommentLine.DELETEALL;

    IF (SalesShptHeader."No." <> '') OR
       (SalesInvHeader."No." <> '') OR
       (SalesCrMemoHeader."No." <> '') OR
       (ReturnRcptHeader."No." <> '') OR
       (SalesInvHeaderPrepmt."No." <> '') OR
       (SalesCrMemoHeaderPrepmt."No." <> '')
    THEN BEGIN
      COMMIT;

      IF SalesShptHeader."No." <> '' THEN
        IF CONFIRM(
             Text000,TRUE,
             SalesShptHeader."No.")
        THEN BEGIN
          SalesShptHeader.SETRECFILTER;
          SalesShptHeader.PrintRecords(TRUE);
        END;

      IF SalesInvHeader."No." <> '' THEN
        IF CONFIRM(
             Text001,TRUE,
             SalesInvHeader."No.")
        THEN BEGIN
          SalesInvHeader.SETRECFILTER;
          SalesInvHeader.PrintRecords(TRUE);
        END;

      IF SalesCrMemoHeader."No." <> '' THEN
        IF CONFIRM(
             Text002,TRUE,
             SalesCrMemoHeader."No.")
        THEN BEGIN
          SalesCrMemoHeader.SETRECFILTER;
          SalesCrMemoHeader.PrintRecords(TRUE);
        END;

      IF ReturnRcptHeader."No." <> '' THEN
        IF CONFIRM(
             Text023,TRUE,
             ReturnRcptHeader."No.")
        THEN BEGIN
          ReturnRcptHeader.SETRECFILTER;
          ReturnRcptHeader.PrintRecords(TRUE);
        END;

      IF SalesInvHeaderPrepmt."No." <> '' THEN
        IF CONFIRM(
             Text055,TRUE,
             SalesInvHeader."No.")
        THEN BEGIN
          SalesInvHeaderPrepmt.SETRECFILTER;
          SalesInvHeaderPrepmt.PrintRecords(TRUE);
        END;

      IF SalesCrMemoHeaderPrepmt."No." <> '' THEN
        IF CONFIRM(
             Text054,TRUE,
             SalesCrMemoHeaderPrepmt."No.")
        THEN BEGIN
          SalesCrMemoHeaderPrepmt.SETRECFILTER;
          SalesCrMemoHeaderPrepmt.PrintRecords(TRUE);
        END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..124

    //>>NAVEASY.001 [Cde_Transport] Suppression d'une commande vente qui a un N° de commande d'achat transport
    //alors il faut demander s'il faut supprimer aussi la Commande d'achat transport liée
    IF "Shipping Order No."<>'' THEN
      IF CONFIRM(STRSUBSTNO(TextCdeTransp002,"Shipping Order No.")) THEN BEGIN
         IF RecLPurchHeader.GET(RecLPurchHeader."Document Type"::Order,"Shipping Order No.") THEN RecLPurchHeader.DELETE(TRUE);
      END;
    //<<NAVEASY.001 [Cde_Transport] Suppression d'une commande vente
    */
    //end;


    //Unsupported feature: Code Modification on "InitRecord(PROCEDURE 10)".

    //procedure InitRecord();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesSetup.GET;

    CASE "Document Type" OF
      "Document Type"::Quote,"Document Type"::Order:
        BEGIN
          NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Invoice Nos.");
          NoSeriesMgt.SetDefaultSeries("Shipping No. Series",SalesSetup."Posted Shipment Nos.");
          IF "Document Type" = "Document Type"::Order THEN BEGIN
            NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",SalesSetup."Posted Prepmt. Inv. Nos.");
            NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",SalesSetup."Posted Prepmt. Cr. Memo Nos.");
          END;
        END;
      "Document Type"::Invoice:
        BEGIN
          IF ("No. Series" <> '') AND
             (SalesSetup."Invoice Nos." = SalesSetup."Posted Invoice Nos.")
          THEN
            "Posting No. Series" := "No. Series"
          ELSE
            NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Invoice Nos.");
          IF SalesSetup."Shipment on Invoice" THEN
            NoSeriesMgt.SetDefaultSeries("Shipping No. Series",SalesSetup."Posted Shipment Nos.");
        END;
      "Document Type"::"Return Order":
        BEGIN
          NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Credit Memo Nos.");
          NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series",SalesSetup."Posted Return Receipt Nos.");
        END;
      "Document Type"::"Credit Memo":
        BEGIN
          IF ("No. Series" <> '') AND
             (SalesSetup."Credit Memo Nos." = SalesSetup."Posted Credit Memo Nos.")
          THEN
            "Posting No. Series" := "No. Series"
          ELSE
            NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Credit Memo Nos.");
          IF SalesSetup."Return Receipt on Credit Memo" THEN
            NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series",SalesSetup."Posted Return Receipt Nos.");
        END;
    END;

    IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote] THEN
      BEGIN
      "Shipment Date" := WORKDATE;
      "Order Date" := WORKDATE;
    END;
    IF "Document Type" = "Document Type"::"Return Order" THEN
      "Order Date" := WORKDATE;

    IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
       ("Posting Date" = 0D)
    THEN
      "Posting Date" := WORKDATE;

    IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN
      "Posting Date" := 0D;

    "Document Date" := WORKDATE;

    VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));

    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
      GLSetup.GET;
      Correction := GLSetup."Mark Cr. Memos as Corrections";
    END;

    "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

    Reserve := Reserve::Optional;

    IF InvtSetup.GET THEN
      VALIDATE("Outbound Whse. Handling Time",InvtSetup."Outbound Whse. Handling Time");

    "Responsibility Center" := UserSetupMgt.GetRespCenter(0,"Responsibility Center");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..45
      //>>TI384175 TO 15/09/2017
      "Order Shipment Date" := WORKDATE;
      //<<TI384175 TO 15/09/2017
    #46..68
    //>>TI300682
    IF "Sell-to Customer Name" <> '' THEN
      "Posting Description" := "Sell-to Customer Name";
    //<<TI300682

    #69..74
    */
    //end;


    local procedure CalcShipment(): Boolean
    var
        ShippingAgent: Record "291";
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

        //  TODO champ sepecifique LRecSalesLine.SETRANGE("Prepare", TRUE);
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
        // TODO champ specfique SalesLIne.SETRANGE("Shipping Costs", TRUE);
        SalesLIne.SETFILTER("Outstanding Quantity", '<>%1', 0);
        SalesLIne.DELETEALL(FALSE);
    end;

    local procedure InsertShipLineToOrder()

    var
        ShippingCostsCarrier: Record "50007";
        SalesLine: Record "37";
        LineNo: Integer;
    //TODO:codeunitspe  ReleaseSalesDoc: Codeunit "414":

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
                // TODO CODE UNIT SEPC  ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.Quantity := 1;
                SalesLine.VALIDATE("Unit Price", ShippingCostsCarrier."Cost Amount");
                SalesLine.MODIFY();
            END ELSE BEGIN
                // TODO CODE UNIT SEPC  ReleaseSalesDoc.PerformManualReopen(Rec);
                SalesLine.INIT();
                SalesLine."Document Type" := Rec."Document Type";
                SalesLine."Document No." := Rec."No.";
                SalesLine."Line No." := LineNo + 10000;
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine.VALIDATE("No.", ShippingCostsCarrier."Item No.");
                SalesLine.VALIDATE(Quantity, 1);
                SalesLine.VALIDATE("Unit Price", ShippingCostsCarrier."Cost Amount");
                // TODO field spec  SalesLine."Shipping Costs" := TRUE;
                SalesLine.INSERT;
            END;
        END;

    END;








    local procedure CreateShipCosts(): Boolean
    var
        ShipmentMethod: Record "10";
    begin
        //IF ("Total Weight" <>  0) AND ("Total Parcels" <> 0) THEN
        IF "Total Parcels" > 1 THEN BEGIN
            DeleteOpenShipCostLine();
            MESSAGE('2 colis et plus, veuillez ajouter manuellement les frais de port.');
            EXIT(TRUE);
        end;

        IF "Sell-to Country/Region Code" <> 'FR' THEN BEGIN
            DeleteOpenShipCostLine;
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
                            //message(' Fraco %1, Total prep %2',Rec."Franco Amount",TotalSalesLineAmountPrepare);
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





        //Unsupported feature: Property Modification (Id) on "OnDelete.DOPaymentTransLogEntry(Variable 1002)".

        //var
        //>>>> ORIGINAL VALUE:
        //OnDelete.DOPaymentTransLogEntry : 1002;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //OnDelete.DOPaymentTransLogEntry : 1100267000;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "Text062(Variable 1072)".

        //var
        //>>>> ORIGINAL VALUE:
        //Text062 : 1072;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text062 : 1100267007;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "Text063(Variable 1077)".

        //var
        //>>>> ORIGINAL VALUE:
        //Text063 : 1077;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text063 : 1100267000;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "Text064(Variable 1090)".

        //var
        //>>>> ORIGINAL VALUE:
        //Text064 : 1090;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text064 : 1100267001;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "UpdateDocumentDate(Variable 1120)".

        //var
        //>>>> ORIGINAL VALUE:
        //UpdateDocumentDate : 1120;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //UpdateDocumentDate : 1100267008;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "Text066(Variable 1095)".

        //var
        //>>>> ORIGINAL VALUE:
        //Text066 : 1095;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text066 : 1100267009;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "Text070(Variable 1096)".

        //var
        //>>>> ORIGINAL VALUE:
        //Text070 : 1096;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text070 : 1100267012;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "BilltoCustomerNoChanged(Variable 1121)".

        //var
        //>>>> ORIGINAL VALUE:
        //BilltoCustomerNoChanged : 1121;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //BilltoCustomerNoChanged : 1100267002;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "Text071(Variable 1011)".

        //var
        //>>>> ORIGINAL VALUE:
        //Text071 : 1011;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text071 : 1100267003;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "Text072(Variable 1013)".

        //var
        //>>>> ORIGINAL VALUE:
        //Text072 : 1013;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text072 : 1100267004;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "SynchronizingMsg(Variable 1026)".

        //var
        //>>>> ORIGINAL VALUE:
        //SynchronizingMsg : 1026;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //SynchronizingMsg : 1100267006;
        //Variable type has not been exported.


        //Unsupported feature: Property Modification (Id) on "ShippingAdviceErr(Variable 1029)".

        //var
        //>>>> ORIGINAL VALUE:
        //ShippingAdviceErr : 1029;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //ShippingAdviceErr : 1100267005;
        //Variable type has not been exported.

    end;

    var
        "-NAVEASY.001-": Integer;
        RecGCustomer: Record "18";
        // TODO table hadil RecGParamNavi: Record "51004";
        RecGCommentLine: Record "97";
        //TODO : page specFrmGLignesCommentaires: Page "124";
        ShippingAgent: Record "291";
        "//PWD 02/02/2010": Integer;
        RecGContact: Record "5050";


        TextCdeTransp003: Label 'You cannot modify Shipping Code agent because there is a Shipping Purchase Order linked (Order %1) !!';


        RecLSalesLine: Record "37";
        CstL001: Label 'This change can delete the reservation of the lines : do want to continue?';
        CstL002: Label 'Canceled operation';
        //TextCdeTransp002: Label 'There is a Shipping Purchase order linked (Order %1), do you want to delete this order?';
        //RecLPurchHeader: Record "38";

        "--NAVEASY.001--": Integer;
        // TextCdeTransp002: Label 'There is a Shipping Purchase order linked (Order %1), do you want to delete this order?';
        RecLPurchHeader: Record "38";




}

