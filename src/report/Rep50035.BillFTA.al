report 50035 "Bill FTA"
{

    DefaultLayout = RDLC;
    RDLCLayout = './BillFTA.rdlc';

    Caption = 'Bill';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemLinkReference = "Sales Invoice Header";
            RequestFilterFields = "No.", "Bill-to Customer No.", "Payment Method Code", "Due Date", "Posting Date";
            RequestFilterHeading = 'Facture';
            column(Operation; Operation)
            {
            }
            column(PaymtHeader__No__; "No.")
            {
            }
            column(CompanyAddr_1_; CompanyAddr[1])
            {
            }
            column(CompanyAddr_2_; CompanyAddr[2])
            {
            }
            column(CompanyAddr_3_; CompanyAddr[3])
            {
            }
            column(CompanyAddr_4_; CompanyAddr[4])
            {
            }
            column(CompanyAddr_5_; CompanyAddr[5])
            {
            }
            column(CompanyAddr_6_; CompanyAddr[6])
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(FORMAT_PostingDate_0_4_; FORMAT(PostingDate, 0, 4))
            {
            }
            column(PrintCurrencyCode; PrintCurrencyCode())
            {
            }
            column(PaymtHeader__Bank_Branch_No__; CustBankAcc_Grc."Bank Branch No.")
            {
            }
            column(PaymtHeader__Agency_Code_; CustBankAcc_Grc."Agency Code")
            {
            }
            column(PaymtHeader__Bank_Account_No__; CustBankAcc_Grc."Bank Account No.")
            {
            }
            column(OutputNo; OutputNo)
            {
            }
            column(StatementAmount; StatementAmount)
            {
                AutoFormatExpression = ExtrCurrencyCode();
                AutoFormatType = 1;
            }
            column(Vendor_Name; "Bill-to Name")
            {
            }
            column(PrintCurrencyCode_Control1120061; PrintCurrencyCode())
            {
            }
            column(Payment_Line__Due_Date_; FORMAT("Due Date"))
            {
            }
            column(Payment_Line__No__; "No.")
            {
            }
            column(Payment_Line__Account_No__; "Bill-to Customer No.")
            {
            }
            column(Payment_Line__Bank_Branch_No__; CustBankAcc_Grc."Bank Branch No.")
            {
            }
            column(Payment_Line__Agency_Code_; CustBankAcc_Grc."Agency Code")
            {
            }
            column(Payment_Line__Bank_Account_No__; CustBankAcc_Grc."Bank Account No.")
            {
            }
            column(Payment_Line__SWIFT_Code_; CustBankAcc_Grc."SWIFT Code")
            {
            }
            column(Payment_Line_IBAN; CustBankAcc_Grc.IBAN)
            {
            }
            column(Payment_Line_Line_No_; "No.")
            {
            }
            column(All_amounts_are_in_company_currencyCaption; All_amounts_are_in_company_currencyCaptionLbl)
            {
            }
            column(Vendor_NameCaption; Vendor_NameCaptionLbl)
            {
            }
            column(Payment_Line__Account_No__Caption; FIELDCAPTION("Bill-to Customer No."))
            {
            }
            column(Payment_Line__Bank_Branch_No__Caption; Bank_Branch_No__CaptionLbl)
            {
            }
            column(Payment_Line__Agency_Code_Caption; Agency_Code_CaptionLbl)
            {
            }
            column(Payment_Line__Bank_Account_No__Caption; Bank_Account_No__CaptionLbl)
            {
            }
            column(VendAdr_1; VendAdr[1])
            {
            }
            column(VendAdr_2; VendAdr[2])
            {
            }
            column(VendAdr_3; VendAdr[3])
            {
            }
            column(VendAdr_4; VendAdr[4])
            {
            }
            column(VendAdr_5; VendAdr[5])
            {
            }
            column(VendAdr_6; VendAdr[6])
            {
            }
            column(VendAdr_7; VendAdr[7])
            {
            }
            column(VendAdr_8; VendAdr[8])
            {
            }
            column(IssueCity; IssueCity)
            {
            }
            column(FORMAT_IssueDate; FORMAT(IssueDate))
            {
            }
            column(ValueMontantPourControle; '****' + FORMAT("Amount Including VAT", 0, '<Precision,2:><Standard Format,0>'))
            {
            }
            column(FORMAT_PostingDate; FORMAT(PostingDate))
            {
            }
            column(FORMAT_DueDate; FORMAT("Due Date"))
            {
            }
            column(AmountText; AmountText)
            {
            }
            column(BankAccountName; CustBankAcc_Grc.Name)
            {
            }
            column(BankCity; CustBankAcc_Grc.City)
            {
            }
            column(BankBranchNo; CustBankAcc_Grc."Bank Branch No.")
            {
            }
            column(AgencyCode; CustBankAcc_Grc."Agency Code")
            {
            }
            column(BankAccountNo; CustBankAcc_Grc."Bank Account No.")
            {
            }
            column(RIBKey; CONVERTSTR(FORMAT(CustBankAcc_Grc."RIB Key", 2), ' ', '0'))
            {
            }
            column(CstTxt001; CstTxt001)
            {
            }

            trigger OnAfterGetRecord()
            var
                VendorPaymentAddr: Record "Payment Address";
                FormatAddress: Codeunit "Format Address";
            begin
                Customer.GET("Bill-to Customer No.");


                CustBankAcc_Grc.SETRANGE("Customer No.", "Sales Invoice Header"."Bill-to Customer No.");
                if not CustBankAcc_Grc.FINDFIRST() then
                    CustBankAcc_Grc.INIT();


                StatementAmount := Amount;
                StatementAmount := ABS(Amount);

                Amount := -Amount;

                //>>SOBI

                FormatAddress.SalesInvBillTo(CompanyAddr, "Sales Invoice Header");

                VendorPaymentAddr.INIT();

                PostingDate := "Posting Date";


                GLSetup.GET();

                if IssueDate = 0D then
                    IssueDate := WORKDATE();


                if "Currency Code" = '' then
                    AmountText := Text001 + ' Eur'
                else
                    AmountText := Text001 + ' ' + "Currency Code";

                DecGTotalAmount += StatementAmount;
                //<<SOBI
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(StatementAmount);

                CompanyInfo.GET();
                FormatAddress.Company(VendAdr, CompanyInfo);
                //>>SOBI
                IssueCity := CompanyInfo.City;
                //<<SOBI
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        MmeMr = 'Ladies and Gentlemen,';
        Nous_vous_prions_de_trouver_ci_dessous_etc = 'We ask you to herewith find a promissory note in payment of invoices following :';
        Nous_vous_prions_d_agreer_etc = 'Please accept, dear Vendor, our best regards.';
        Le_service_comptabilite_FIRST = 'The accounting department FIRST';
        Contre_cette_LETTRE_DE_CHANGE = 'Against this BILL';
        stipulee_SANS_FRAIS = 'noted as NO CHARGES';
        veuillez_payer_la_somme_indiquee = 'please pay the indicated sum';
        ci_dessous_a_l_ordre_de = 'below for order of :';
        LCR = 'Bill Only';
        A = 'TO';
        a_ = 'to';
        LE = 'ON';
        Le_ = 'The';
        MONTANT_POUR_CONTROLE = 'AMOUNT FOR CONTROL';
        DATE_DE_CREATION = 'CREATION DATE';
        ECHEANCE = 'DUE DATE';
        REF_TIRE = 'DRAWEE REF.';
        Valeur_en = 'Value in :';
        RIB_DU_TIRE = 'DRAWEE R.I.B.';
        DOMICILIATION = 'DOMICILIATION';
        NOM_et = 'NAME and';
        ADRESSE = 'ADDRESS';
        du_TIRE = 'of DRAWEE';
        Droit_de_timbre_et_signature = 'Stamp Allow and Signature';
        ACCEPTATION_ou_AVAL = 'ACCEPTANCE or ENDORSMENT';
        ne_rien_inscrire_au_dessous_de_cette_ligne = 'ne rien inscrire au-dessous de cette ligne';
        dont_le_detail_est_en = 'All amounts are in company currency';
        Tel = 'Phone :';
        Fax = 'Fax :';
        NoCompte = 'Account No :';
        DateComptabilisation = 'Posting date';
        NoDocExterne = 'External doc No.';
        NoDocument = 'Document No.';
        DateEcheance = 'Due date';
        Montant = 'Amount';
        CodeEtabli = 'Code établi';
        CodeGuichet = 'code guichet';
        CleRIB = 'RIB Key';
        Accepte = 'Validate';
        PROSPA_SAS_Le_Directeur = 'PROSPA SAS Director';
    }

    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        CustBankAcc_Grc: Record "Customer Bank Account";
        GLSetup: Record "General Ledger Setup";
        FormatAddress: Codeunit "Format Address";
        IssueDate: Date;
        PostingDate: Date;
        DecGTotalAmount: Decimal;
        StatementAmount: Decimal;
        OutputNo: Integer;
        Agency_Code_CaptionLbl: Label 'Agency Code';
        All_amounts_are_in_company_currencyCaptionLbl: Label 'All amounts are in company currency';
        Bank_Account_No__CaptionLbl: Label 'Bank Account No.';
        Bank_Branch_No__CaptionLbl: Label 'Bank Branch No.';
        CstTxt001: Label 'Stamp Allow and Signature';
        Text001: Label 'Amount';
        Vendor_NameCaptionLbl: Label 'Name';
        AmountText: Text[30];
        IssueCity: Text[30];
        CompanyAddr: array[8] of Text[100];
        VendAdr: array[8] of Text[100];
        Operation: Text[80];


    procedure ExtrCurrencyCode(): Code[10]
    begin
        exit("Sales Invoice Header"."Currency Code");
    end;


    procedure PrintCurrencyCode(): Code[10]
    begin
        if ("Sales Invoice Header"."Currency Code" = '') then begin
            GLSetup.GET();
            exit(GLSetup."LCY Code");
        end;
        exit("Sales Invoice Header"."Currency Code");
    end;
}

