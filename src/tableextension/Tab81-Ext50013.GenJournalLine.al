namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;
tableextension 50013 GenJournalLine extends "Gen. Journal Line" //81
{
    fields
    {

        //Unsupported feature: Code Modification on ""Account No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Account No." <> xRec."Account No." THEN BEGIN
          ClearAppliedAutomatically;
          VALIDATE("Job No.",'');
        END;

        IF xRec."Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"] THEN
          "IC Partner Code" := '';

        IF "Account No." = '' THEN BEGIN
          CleanLine;
          GetDerogatorySetup;
          EXIT;
        END;

        CASE "Account Type" OF
          "Account Type"::"G/L Account":
            BEGIN
              GLAcc.GET("Account No.");
              CheckGLAcc;
              IF ReplaceDescription AND (NOT GLAcc."Omit Default Descr. in Jnl.") THEN
                UpdateDescription(GLAcc.Name)
              ELSE
                IF GLAcc."Omit Default Descr. in Jnl." THEN
                  Description := '';
              IF ("Bal. Account No." = '') OR
                 ("Bal. Account Type" IN
                  ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
              THEN BEGIN
                "Posting Group" := '';
                "Salespers./Purch. Code" := '';
                "Payment Terms Code" := '';
              END;
              IF "Bal. Account No." = '' THEN
                "Currency Code" := '';
              IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
                 GenJnlBatch."Copy VAT Setup to Jnl. Lines"
              THEN BEGIN
                "Gen. Posting Type" := GLAcc."Gen. Posting Type";
                "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
                "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
              END;
              "Tax Area Code" := GLAcc."Tax Area Code";
              "Tax Liable" := GLAcc."Tax Liable";
              "Tax Group Code" := GLAcc."Tax Group Code";
              IF "Posting Date" <> 0D THEN
                IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
                  ClearPostingGroups;
            END;
          "Account Type"::Customer:
            BEGIN
              Cust.GET("Account No.");
              Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
              IF Cust."IC Partner Code" <> '' THEN BEGIN
                IF GenJnlTemplate.GET("Journal Template Name") THEN;
                IF (Cust."IC Partner Code" <> '' ) AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
                  ICPartner.CheckICPartnerIndirect(FORMAT("Account Type"),"Account No.");
                  "IC Partner Code" := Cust."IC Partner Code";
                END;
              END;
              UpdateDescription(Cust.Name);
              "Payment Method Code" := Cust."Payment Method Code";
              VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
              "Posting Group" := Cust."Customer Posting Group";
              "Salespers./Purch. Code" := Cust."Salesperson Code";
              "Payment Terms Code" := Cust."Payment Terms Code";
              VALIDATE("Bill-to/Pay-to No.","Account No.");
              VALIDATE("Sell-to/Buy-from No.","Account No.");
              IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
                "Currency Code" := Cust."Currency Code";
              ClearPostingGroups;
              IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Account No.") THEN
                IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
                     Cust."Bill-to Customer No.")
                THEN
                  ERROR('');
              VALIDATE("Payment Terms Code");
              CheckPaymentTolerance;
            END;
          "Account Type"::Vendor:
            BEGIN
              Vend.GET("Account No.");
              Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
              IF Vend."IC Partner Code" <> '' THEN BEGIN
                IF GenJnlTemplate.GET("Journal Template Name") THEN;
                IF (Vend."IC Partner Code" <> '') AND ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
                  ICPartner.CheckICPartnerIndirect(FORMAT("Account Type"),"Account No.");
                  "IC Partner Code" := Vend."IC Partner Code";
                END;
              END;
              UpdateDescription(Vend.Name);
              "Payment Method Code" := Vend."Payment Method Code";
              "Creditor No." := Vend."Creditor No.";
              VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account");
              "Posting Group" := Vend."Vendor Posting Group";
              "Salespers./Purch. Code" := Vend."Purchaser Code";
              "Payment Terms Code" := Vend."Payment Terms Code";
              VALIDATE("Bill-to/Pay-to No.","Account No.");
              VALIDATE("Sell-to/Buy-from No.","Account No.");
              IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
                "Currency Code" := Vend."Currency Code";
              ClearPostingGroups;
              IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Account No.") AND
                 NOT HideValidationDialog
              THEN
                IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
                     Vend."Pay-to Vendor No.")
                THEN
                  ERROR('');
              VALIDATE("Payment Terms Code");
              CheckPaymentTolerance;
            END;
          "Account Type"::"Bank Account":
            BEGIN
              BankAcc.GET("Account No.");
              BankAcc.TESTFIELD(Blocked,FALSE);
              IF ReplaceDescription THEN
                UpdateDescription(BankAcc.Name);
              IF ("Bal. Account No." = '') OR
                 ("Bal. Account Type" IN
                  ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
              THEN BEGIN
                "Posting Group" := '';
                "Salespers./Purch. Code" := '';
                "Payment Terms Code" := '';
              END;
              IF BankAcc."Currency Code" = '' THEN BEGIN
                IF "Bal. Account No." = '' THEN
                  "Currency Code" := '';
              END ELSE
                IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
                  BankAcc.TESTFIELD("Currency Code","Currency Code")
                ELSE
                  "Currency Code" := BankAcc."Currency Code";
              ClearPostingGroups;
            END;
          "Account Type"::"Fixed Asset":
            BEGIN
              FA.GET("Account No.");
              FA.TESTFIELD(Blocked,FALSE);
              FA.TESTFIELD(Inactive,FALSE);
              FA.TESTFIELD("Budgeted Asset",FALSE);
              UpdateDescription(FA.Description);
              IF "Depreciation Book Code" = '' THEN BEGIN
                FASetup.GET;
                "Depreciation Book Code" := FASetup."Default Depr. Book";
                IF NOT FADeprBook.GET("Account No.","Depreciation Book Code") THEN
                  "Depreciation Book Code" := '';
              END;
              IF "Depreciation Book Code" <> '' THEN BEGIN
                FADeprBook.GET("Account No.","Depreciation Book Code");
                "Posting Group" := FADeprBook."FA Posting Group";
              END;
              GetFAVATSetup;
              GetFAAddCurrExchRate;
              GetDerogatorySetup;
            END;
          "Account Type"::"IC Partner":
            BEGIN
              ICPartner.GET("Account No.");
              ICPartner.CheckICPartner;
              UpdateDescription(ICPartner.Name);
              IF ("Bal. Account No." = '') OR ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") THEN
                "Currency Code" := ICPartner."Currency Code";
              IF ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
                "Currency Code" := ICPartner."Currency Code";
              ClearPostingGroups;
              "IC Partner Code" := "Account No.";
            END;
        END;

        VALIDATE("Currency Code");
        VALIDATE("VAT Prod. Posting Group");
        UpdateLineBalance;
        UpdateSource;
        CreateDim(
          DimMgt.TypeToTableID1("Account Type"),"Account No.",
          DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
          DATABASE::Campaign,"Campaign No.");

        VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        ValidateApplyRequirements(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..30

                //>>FTA1.04
                "Mobile Salesperson Code" := '';
                //<<FTA1.04

        #31..66

              //>>FTA1.04
              "Mobile Salesperson Code" := Cust."Mobile Salesperson Code";
              //<<FTA1.04

        #67..97

               //>>FTA1.04
               "Mobile Salesperson Code" := '';
               //<<FTA1.04

        #98..125

                //>>FTA1.04
                "Mobile Salesperson Code" := '';
                //<<FTA1.04


        #126..185
        */
        //end;


        //Unsupported feature: Code Modification on ""Bal. Account No."(Field 11).OnValidate".

        //trigger  Account No()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        VALIDATE("Job No.",'');

        IF xRec."Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
                                        "Bal. Account Type"::"IC Partner"]
        THEN
          "IC Partner Code" := '';

        IF "Bal. Account No." = '' THEN BEGIN
          UpdateLineBalance;
          UpdateSource;
          CreateDim(
            DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
            DimMgt.TypeToTableID1("Account Type"),"Account No.",
            DATABASE::Job,"Job No.",
            DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
            DATABASE::Campaign,"Campaign No.");
          IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN
            "Recipient Bank Account" := '';
          IF xRec."Bal. Account No." <> '' THEN BEGIN
            ClearBalancePostingGroups;
            "Bal. Tax Area Code" := '';
            "Bal. Tax Liable" := FALSE;
            "Bal. Tax Group Code" := '';
          END;
          EXIT;
        END;

        CASE "Bal. Account Type" OF
          "Bal. Account Type"::"G/L Account":
            BEGIN
              GLAcc.GET("Bal. Account No.");
              CheckGLAcc;
              IF "Account No." = '' THEN BEGIN
                Description := GLAcc.Name;
                "Currency Code" := '';
              END;
              IF ("Account No." = '') OR
                 ("Account Type" IN
                  ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
              THEN BEGIN
                "Posting Group" := '';
                "Salespers./Purch. Code" := '';
                "Payment Terms Code" := '';
              END;
              IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
                 GenJnlBatch."Copy VAT Setup to Jnl. Lines"
              THEN BEGIN
                "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
                "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
                "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
              END;
              "Bal. Tax Area Code" := GLAcc."Tax Area Code";
              "Bal. Tax Liable" := GLAcc."Tax Liable";
              "Bal. Tax Group Code" := GLAcc."Tax Group Code";
              IF "Posting Date" <> 0D THEN
                IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
                  ClearBalancePostingGroups;
            END;
          "Bal. Account Type"::Customer:
            BEGIN
              Cust.GET("Bal. Account No.");
              Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
              IF Cust."IC Partner Code" <> '' THEN BEGIN
                IF GenJnlTemplate.GET("Journal Template Name") THEN;
                IF (Cust."IC Partner Code" <> '') AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
                  ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
                  "IC Partner Code" := Cust."IC Partner Code";
                END;
              END;

              IF "Account No." = '' THEN
                Description := Cust.Name;

              "Payment Method Code" := Cust."Payment Method Code";
              VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
              "Posting Group" := Cust."Customer Posting Group";
              "Salespers./Purch. Code" := Cust."Salesperson Code";
              "Payment Terms Code" := Cust."Payment Terms Code";
              VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
              VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
              IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
                "Currency Code" := Cust."Currency Code";
              IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
                "Currency Code" := Cust."Currency Code";
              ClearBalancePostingGroups;
              IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Bal. Account No.") THEN
                IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
                     Cust."Bill-to Customer No.")
                THEN
                  ERROR('');
              VALIDATE("Payment Terms Code");
              CheckPaymentTolerance;
            END;
          "Bal. Account Type"::Vendor:
            BEGIN
              Vend.GET("Bal. Account No.");
              Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
              IF Vend."IC Partner Code" <> '' THEN BEGIN
                IF GenJnlTemplate.GET("Journal Template Name") THEN;
                IF (Vend."IC Partner Code" <> '') AND ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
                  ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
                  "IC Partner Code" := Vend."IC Partner Code";
                END;
              END;

              IF "Account No." = '' THEN
                Description := Vend.Name;

              "Payment Method Code" := Vend."Payment Method Code";
              VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account");
              "Posting Group" := Vend."Vendor Posting Group";
              "Salespers./Purch. Code" := Vend."Purchaser Code";
              "Payment Terms Code" := Vend."Payment Terms Code";
              VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
              VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
              IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
                "Currency Code" := Vend."Currency Code";
              IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
                "Currency Code" := Vend."Currency Code";
              ClearBalancePostingGroups;
              IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Bal. Account No.") THEN
                IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
                     Vend."Pay-to Vendor No.")
                THEN
                  ERROR('');
              VALIDATE("Payment Terms Code");
              CheckPaymentTolerance;
            END;
          "Bal. Account Type"::"Bank Account":
            BEGIN
              BankAcc.GET("Bal. Account No.");
              BankAcc.TESTFIELD(Blocked,FALSE);
              IF "Account No." = '' THEN
                Description := BankAcc.Name;

              IF ("Account No." = '') OR
                 ("Account Type" IN
                  ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
              THEN BEGIN
                "Posting Group" := '';
                "Salespers./Purch. Code" := '';
                "Payment Terms Code" := '';
              END;
              IF BankAcc."Currency Code" = '' THEN BEGIN
                IF "Account No." = '' THEN
                  "Currency Code" := '';
              END ELSE
                IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
                  BankAcc.TESTFIELD("Currency Code","Currency Code")
                ELSE
                  "Currency Code" := BankAcc."Currency Code";
              ClearBalancePostingGroups;
            END;
          "Bal. Account Type"::"Fixed Asset":
            BEGIN
              FA.GET("Bal. Account No.");
              FA.TESTFIELD(Blocked,FALSE);
              FA.TESTFIELD(Inactive,FALSE);
              FA.TESTFIELD("Budgeted Asset",FALSE);
              IF "Account No." = '' THEN
                Description := FA.Description;

              IF "Depreciation Book Code" = '' THEN BEGIN
                FASetup.GET;
                "Depreciation Book Code" := FASetup."Default Depr. Book";
                IF NOT FADeprBook.GET("Bal. Account No.","Depreciation Book Code") THEN
                  "Depreciation Book Code" := '';
              END;
              IF "Depreciation Book Code" <> '' THEN BEGIN
                FADeprBook.GET("Bal. Account No.","Depreciation Book Code");
                "Posting Group" := FADeprBook."FA Posting Group";
              END;
              GetFAVATSetup;
              GetFAAddCurrExchRate;
            END;
          "Bal. Account Type"::"IC Partner":
            BEGIN
              ICPartner.GET("Bal. Account No.");
              IF "Account No." = '' THEN
                Description := ICPartner.Name;

              IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
                "Currency Code" := ICPartner."Currency Code";
              IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
                "Currency Code" := ICPartner."Currency Code";
              ClearBalancePostingGroups;
              "IC Partner Code" := "Bal. Account No.";
            END;
        END;

        VALIDATE("Currency Code");
        VALIDATE("Bal. VAT Prod. Posting Group");
        UpdateLineBalance;
        UpdateSource;
        CreateDim(
          DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
          DimMgt.TypeToTableID1("Account Type"),"Account No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
          DATABASE::Campaign,"Campaign No.");

        VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        ValidateApplyRequirements(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..42

                //>>FTA1.04
                "Mobile Salesperson Code" := '';
                //<<FTA1.04

        #43..79

              //>>FTA1.04
              "Mobile Salesperson Code" := Cust."Mobile Salesperson Code";
              //<<FTA1.04

        #80..114

               //>>FTA1.04
               "Mobile Salesperson Code" := '';
               //<<FTA1.04

        #115..143

                //>>FTA1.04
                "Mobile Salesperson Code" := '';
                //<<FTA1.04

        #144..205
        */
        //end;
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            Description = 'FTA1.04';
            TableRelation = Salesperson/Purchaser;
        }
        field(51000;"Payment Method Code2";Code[10])
        {
            Caption = 'Payment Method Code';
            Description = 'REGLEMENT 01.08.2006 COR001 [13]';
            TableRelation = "Payment Method";
        }
    }


    //Unsupported feature: Code Modification on "LookUpAppliesToDocCust(PROCEDURE 35)".

    //procedure LookUpAppliesToDocCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CLEAR(CustLedgEntry);
        CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
        IF AccNo <> '' THEN
          CustLedgEntry.SETRANGE("Customer No.",AccNo);
        CustLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF CustLedgEntry.ISEMPTY THEN BEGIN
            CustLedgEntry.SETRANGE("Document Type");
            CustLedgEntry.SETRANGE("Document No.");
          END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE("Document Type");
        END;
        IF Amount <> 0 THEN BEGIN
          CustLedgEntry.SETRANGE(Positive,Amount < 0);
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE(Positive);
        END;
        ApplyCustEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
        ApplyCustEntries.SETRECORD(CustLedgEntry);
        ApplyCustEntries.LOOKUPMODE(TRUE);
        IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ApplyCustEntries.GETRECORD(CustLedgEntry);
          IF AccNo = '' THEN BEGIN
            AccNo := CustLedgEntry."Customer No.";
            IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN
              VALIDATE("Bal. Account No.",AccNo)
            ELSE
              VALIDATE("Account No.",AccNo);
          END;
          IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
            IF Amount = 0 THEN BEGIN
              FromCurrencyCode := GetShowCurrencyCode("Currency Code");
              ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
              IF NOT
                 CONFIRM(
                   Text003,TRUE,FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,ToCurrencyCode)
              THEN
                ERROR(Text005);
              VALIDATE("Currency Code",CustLedgEntry."Currency Code");
            END ELSE
              GenJnlApply.CheckAgainstApplnCurrency(
                "Currency Code",CustLedgEntry."Currency Code",
                GenJnlLine."Account Type"::Customer,TRUE);
          IF Amount = 0 THEN BEGIN
            CustLedgEntry.CALCFIELDS("Remaining Amount");
            IF CustLedgEntry."Amount to Apply" <> 0 THEN BEGIN
              IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec,CustLedgEntry,0,FALSE) THEN BEGIN
                IF ABS(CustLedgEntry."Amount to Apply") >=
                   ABS(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                THEN
                  Amount := -(CustLedgEntry."Remaining Amount" -
                              CustLedgEntry."Remaining Pmt. Disc. Possible")
                ELSE
                  Amount := -CustLedgEntry."Amount to Apply";
              END ELSE
                Amount := -CustLedgEntry."Amount to Apply";
            END ELSE BEGIN
              IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec,CustLedgEntry,0,FALSE) THEN
                Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
              ELSE
                Amount := -CustLedgEntry."Remaining Amount";
            END;
            IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor] THEN
              Amount := -Amount;
            VALIDATE(Amount);
          END;
          "Applies-to Doc. Type" := CustLedgEntry."Document Type";
          "Applies-to Doc. No." := CustLedgEntry."Document No.";
          "Applies-to ID" := '';
        END;
        GetCreditCard;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..81
          //>>NAVEASY.001 [Multi_Collectif]
          "Posting Group" := CustLedgEntry."Customer Posting Group";
          //<<NAVEASY.001 [Multi_Collectif]
        END;
        GetCreditCard;
        */
    //end;


    //Unsupported feature: Code Modification on "LookUpAppliesToDocVend(PROCEDURE 36)".

    //procedure LookUpAppliesToDocVend();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CLEAR(VendLedgEntry);
        VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
        IF AccNo <> '' THEN
          VendLedgEntry.SETRANGE("Vendor No.",AccNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF VendLedgEntry.ISEMPTY THEN BEGIN
            VendLedgEntry.SETRANGE("Document Type");
            VendLedgEntry.SETRANGE("Document No.");
          END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Document Type");
        END;
        IF  "Applies-to Doc. No." <> ''THEN BEGIN
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Document No.");
        END;
        IF Amount <> 0 THEN BEGIN
          VendLedgEntry.SETRANGE(Positive,Amount < 0);
          IF VendLedgEntry.ISEMPTY THEN;
          VendLedgEntry.SETRANGE(Positive);
        END;
        ApplyVendEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.LOOKUPMODE(TRUE);
        IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ApplyVendEntries.GETRECORD(VendLedgEntry);
          IF AccNo = '' THEN BEGIN
            AccNo := VendLedgEntry."Vendor No.";
            IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN
              VALIDATE("Bal. Account No.",AccNo)
            ELSE
              VALIDATE("Account No.",AccNo);
          END;
          IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
            IF Amount = 0 THEN BEGIN
              FromCurrencyCode := GetShowCurrencyCode("Currency Code");
              ToCurrencyCode := GetShowCurrencyCode(VendLedgEntry."Currency Code");
              IF NOT
                 CONFIRM(
                   Text003,TRUE,FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,ToCurrencyCode)
              THEN
                ERROR(Text005);
              VALIDATE("Currency Code",VendLedgEntry."Currency Code");
            END ELSE
              GenJnlApply.CheckAgainstApplnCurrency(
                "Currency Code",VendLedgEntry."Currency Code",GenJnlLine."Account Type"::Vendor,TRUE);
          IF Amount = 0 THEN BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            IF VendLedgEntry."Amount to Apply" <> 0 THEN BEGIN
              IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(Rec,VendLedgEntry,0,FALSE) THEN BEGIN
                IF ABS(VendLedgEntry."Amount to Apply") >=
                   ABS(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                THEN
                  Amount := -(VendLedgEntry."Remaining Amount" -
                              VendLedgEntry."Remaining Pmt. Disc. Possible")
                ELSE
                  Amount := -VendLedgEntry."Amount to Apply";
              END ELSE
                Amount := -VendLedgEntry."Amount to Apply";
            END ELSE BEGIN
              IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(Rec,VendLedgEntry,0,FALSE) THEN
                Amount := -(VendLedgEntry."Remaining Amount" -
                            VendLedgEntry."Remaining Pmt. Disc. Possible")
              ELSE
                Amount := -VendLedgEntry."Remaining Amount";
            END;
            IF "Bal. Account Type" IN
               ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]
            THEN
              Amount := -Amount;
            VALIDATE(Amount);
          END;
          "Applies-to Doc. Type" := VendLedgEntry."Document Type";
          "Applies-to Doc. No." := VendLedgEntry."Document No.";
          "Applies-to ID" := '';
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..88
          //>>NAVEASY.001 [Multi_Collectif]
          "Posting Group" := VendLedgEntry."Vendor Posting Group";
          //<<NAVEASY.001 [Multi_Collectif]
        END;
        */
    //end;
}

