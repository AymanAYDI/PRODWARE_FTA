
namespace Prodware.FTA;

using Microsoft.Sales.Document;
using System.Utilities;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.Shipping;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Setup;
using Microsoft.Finance.Dimension;
using System.Globalization;
using Microsoft.Inventory.Location;
using Microsoft.Assembly.Document;
using Microsoft.Foundation.Address;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Contact;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Comment;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Posting;
using Microsoft.Finance.Currency;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Foundation.UOM;
using Microsoft.CRM.Team;

report 50011 "Preparatory delivery FTA"
{

    DefaultLayout = RDLC;
    RDLCLayout = './PreparatorydeliveryFTA.rdlc';

    Caption = 'Work Order';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            CalcFields = "Shipping Agent Name";
            DataItemTableView = sorting("Document Type", "No.")
                                where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            {
            }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(LblBIC; LblBIC)
            {
            }
            column(LblIBAN; LblIBAN)
            {
            }
            column(LblVATRegistrationNo; LblVATRegistrationNo)
            {
            }
            column(LblAPE; LblAPE)
            {
            }
            column(LblVAT; LblVAT)
            {
            }
            column(LblPAGE; LblPAGE)
            {
            }
            column(LblPhoneNo; LblPhoneNo)
            {
            }
            column(LblFaxNo; LblFaxNo)
            {
            }
            column(LblYourReference; LblYourReference)
            {
            }
            column(LblOurReferences; LblOurReferences)
            {
            }
            column(LblDocumentDate; LblDocumentDate)
            {
            }
            column(LblTermsOfSale; LblTermsOfSale)
            {
            }
            column(LblUnitOfMeasure; LblUnitOfMeasure)
            {
            }
            column(LblType; "Sales Line".FIELDCAPTION(Type))
            {
            }
            column(LblQuantity; LblQuantity)
            {
            }
            column(LblDescription; LblDescription)
            {
            }
            column(LblNo; LblNo)
            {
            }
            // column(LblCrossReference; "Sales Line".FIELDCAPTION("Cross-Reference No."))
            // {
            // }      
            //todo removed
            column(LblShipmentDate; "Sales Line".FIELDCAPTION("Shipment Date"))
            {
            }
            column(LblPrepaType; "Sales Line".FIELDCAPTION("Preparation Type"))
            {
            }
            column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
            {
            }
            column(Preparer; "Sales Header".FIELDCAPTION(Preparer))
            {
            }
            column(Assembler; "Sales Header".FIELDCAPTION(Assembler))
            {
            }
            column(Packer; "Sales Header".FIELDCAPTION(Packer))
            {
            }
            column(LblCustomerCode; LblCustomerCode)
            {
            }
            column(LblCustomerNb; LblCustomerNb)
            {
            }
            column(BillToCustomerNo; "Sales Header"."Bill-to Customer No.")
            {
            }
            column(LblWeight; LblWeight)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number)
                                        where(Number = const(1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(OrderConfirmCopyCaption; STRSUBSTNO(CstG005, "Sales Header"."No."))
                    {
                    }
                    column(PintedDateDaption; CstG006)
                    {
                    }
                    column(Today; TODAY)
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhNo; CompanyInfo."Phone No.")
                    {
                        IncludeCaption = false;
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocDate_SalesHeader; FORMAT("Sales Header"."Document Date"))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShptDate_SalesHeader; FORMAT("Sales Header"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPersons.Name) //todo a verifier
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(SalesOrderReference_SalesHeader; "Sales Header"."Your Reference")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PmntTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(ShptMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PricesInclVATYesNo_SalesHeader; FORMAT("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankCaption; BankCaptionLbl)
                    {
                    }
                    column(AccountNoCaption; AccountNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionCap)
                    {
                    }
                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(CompanyInfo__SWIFT_Code_; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                    }
                    column(SalesHeader_ExternalDocumentNo; "Sales Header"."External Document No.")
                    {
                    }
                    column(Cust_Email; RecGCustomer."E-Mail")
                    {
                    }
                    column(Cust_FaxNo; RecGCustomer."Fax No.")
                    {
                    }
                    column(RecGContact_Name; ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                    {
                    }
                    column(TxtGOurReferences; TxtGOurReferences)
                    {
                    }
                    column(SalesHeader_PostingDate; "Sales Header"."Posting Date")
                    {
                    }
                    column(SalesPurchPersonPhoneNoCaption; "Sales Header".FIELDCAPTION("Promised Delivery Date"))
                    {
                    }
                    column(SalesPurchPersonPhoneNo; "Sales Header"."Promised Delivery Date")
                    {
                    }
                    column(SalesPurchPersonEMailCaption; CstG007)
                    {
                    }
                    column(SalesPurchPersonEMail; "Sales Header"."Shipping Agent Name")
                    {
                    }
                    column(LblRefInt; LblRefInt)
                    {
                    }
                    column(LblPlannedDeliveryDate; LblPlannedDeliveryDate)
                    {
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"),
                                       "Document No." = field("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                            where("Attached to Line No." = filter(0));
                        column(SalesLineAmt; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Type_SalesLine; FORMAT("Sales Line".Type))
                        {
                        }
                        column(Desc_SalesLine; "Sales Line".Description)
                        {
                        }
                        column(SalesLineDescription2; "Sales Line"."Description 2")
                        {
                        }
                        column(RecGItemNo2; RecGItem."No. 2")
                        {
                        }
                        column(No2_SalesLine; "Sales Line"."No.")
                        {
                        }
                        // column(SalesLineCrossReference; "Cross-Reference No.")
                        // {
                        // } //todo a verifier champs removed
                        column(Qty_SalesLine; "Sales Line"."Outstanding Quantity")
                        {
                        }
                        column(SalesLinePlannedDeliveryDate; FORMAT("Sales Line"."Shipment Date", 0, 1))
                        {
                        }
                        column(SalesLinePreparationType; FORMAT("Preparation Type"))
                        {
                        }
                        column(SalesLinePreparationTypeRange; IntGPreparationType)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(UOM_SalesLine; "Sales Line"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineAmt_SalesLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(No_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        {
                        }
                        column(Desc_SalesLineCaption; "Sales Line".FIELDCAPTION(Description))
                        {
                        }
                        column(No2_SalesLineCaption; "Sales Line".FIELDCAPTION("No."))
                        {
                        }
                        column(Qty_SalesLineCaption; "Sales Line".FIELDCAPTION(Quantity))
                        {
                        }
                        column(UOM_SalesLineCaption; "Sales Line".FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesLineCaption; "Sales Line".FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        column(AsmLineHeader; STRSUBSTNO(CstG004, FORMAT("Sales Line"."Outstanding Quantity"), "Sales Line".Description, "Sales Line"."Description 2"))
                        {
                        }
                        column(AsmLineLevelCaption; AsmLine.FIELDCAPTION("Level No."))
                        {
                        }
                        column(AsmLineQtyPerCaption; AsmLine.FIELDCAPTION("Quantity per"))
                        {
                        }
                        column(AsmLineQuantityCaption; LblQuantityAsm)
                        {
                        }
                        column(AsmLineQtyUseCaption; LblQtyUse)
                        {
                        }
                        column(CommentItem; TxtGCommentLine)
                        {
                        }
                        column(ShelfNo; CodGShelfNo)
                        {
                        }
                        column(ShelfNoCaption; LblShelfNo)
                        {
                        }
                        column(BooGAdditionalInfoVisible; BooGAdditionalInfoVisible)
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = filter(1 ..));
                            column(DimText2; DimText)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FINDSET() then
                                        CurrReport.BREAK();
                                end else
                                    if not Continue then
                                        CurrReport.BREAK();

                                CLEAR(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if STRLEN(DimText) > MAXSTRLEN(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.NEXT() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.BREAK();

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem("Extended Text Line"; "Extended Text Line")
                        {
                            DataItemLink = "No." = field("No.");
                            DataItemTableView = sorting("Table Name", "No.", "Language Code", "Text No.", "Line No.");
                            column(ExtendedLine_Text; "Extended Text Line".Text)
                            {
                            }
                            column(ExtendedLine_TextCaption; "Extended Text Line".FIELDCAPTION(Text))
                            {
                            }
                            column(ExtendedLine_LineNo; "Extended Text Line"."Line No.")
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                //<<FTA.EXTENDEDTEXT
                                SETRANGE("Extended Text Line"."Table Name", "Extended Text Line"."Table Name"::Item);
                                //>>FTA.EXTENDEDTEXT
                            end;
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = sorting(Number);
                            column(AsmLineLevel; AsmLine."Level No.")
                            {
                            }
                            column(AsmLineType; AsmLine.Type)
                            {
                            }
                            column(AsmLineNo; BlanksForIndent() + AsmLine."No.")
                            {
                            }
                            column(AsmLineDescription; AsmLine.Description)
                            {
                            }
                            column(AsmLineQtyPer; AsmLine."Quantity per")
                            {
                            }
                            column(AsmLineQuantity; AsmLine."Remaining Quantity")
                            {
                            }
                            column(AsmLineUOMText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            {
                            }
                            column(AsmLineDescription2; AsmLine."Description 2")
                            {
                            }
                            column(AsmRecGItemNo2; RecGItem2."No. 2")
                            {
                            }
                            column(AsmLineShelfNo2; RecGItem2."Shelf No.")
                            {
                            }
                            column(TxtGAsmCommentLine; TxtGAsmCommentLine)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    AsmLine.FINDSET()
                                else
                                    AsmLine.NEXT();



                                if (AsmLine.Type = AsmLine.Type::Item) and (AsmLine."No." <> '') then begin
                                    RecGItem2.GET(AsmLine."No.");

                                end else begin
                                    RecGItem2.INIT();
                                end;


                                CLEAR(TxtGAsmCommentLine);
                                RecGCommentLine.SETRANGE("Table Name", RecGCommentLine."Table Name"::Item);
                                RecGCommentLine.SETRANGE("No.", AsmLine."No.");
                                if RecGCommentLine.FINDFIRST() then begin
                                    repeat
                                        TxtGAsmCommentLine += FORMAT(Enter) + RecGCommentLine.Comment;
                                    until RecGCommentLine.NEXT() = 0;
                                    TxtGAsmCommentLine := COPYSTR(TxtGAsmCommentLine, 2, STRLEN(TxtGAsmCommentLine));
                                end;


                            end;

                            trigger OnPreDataItem()
                            begin
                                if not AsmInfoExistsForLine then
                                    CurrReport.BREAK();
                                AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                SETRANGE(Number, 1, AsmLine.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin

                            AsmInfoExistsForLine := AsmToOrderExists(AsmHeader);


                            if ("Sales Line".Type = "Sales Line".Type::Item) and ("Sales Line"."No." <> '') then begin
                                RecGItem.GET("Sales Line"."No.");
                            end else begin
                                RecGItem.INIT();
                            end;

                            BooGAdditionalInfoVisible := false;

                            if ("Sales Line".Type = "Sales Line".Type::Item) and ("Sales Line"."No." <> '') then begin
                                if RecGItem."Automatic Ext. Texts" then
                                    BooGAdditionalInfoVisible := true;
                            end;


                            CLEAR(TxtGCommentLine);
                            RecGCommentLine.SETRANGE("Table Name", RecGCommentLine."Table Name"::Item);
                            RecGCommentLine.SETRANGE("No.", "No.");
                            if RecGCommentLine.FINDFIRST() then begin
                                repeat
                                    TxtGCommentLine += FORMAT(Enter) + RecGCommentLine.Comment;
                                until RecGCommentLine.NEXT() = 0;
                                TxtGCommentLine := COPYSTR(TxtGCommentLine, 2, STRLEN(TxtGCommentLine));
                            end;

                            if Type = Type::Item then begin
                                EVALUATE(IntGPreparationType, FORMAT("Sales Line"."Preparation Type", 0, '<Number>'));
                                CodGShelfNo := RecGItem."Shelf No.";
                            end;

                            //<<NDBI
                        end;

                        trigger OnPreDataItem()
                        begin
                            Enter := 10;


                            SETRANGE("Sales Line".Prepare, true);
                        end;
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            where(Number = const(1));
                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }
                        column(Total2Number; Number)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtSalesLine: Record "Sales Line" temporary;
                    TempSalesLine: Record "Sales Line" temporary;
                    SalesPost: Codeunit "Sales-Post";
                begin

                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                    CurrReport.PAGENO := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecLCurrency: Record Currency;
                "-PW-": Integer;
            begin
                CompanyInfo.GET();
                CurrReport.LANGUAGE := Language.GetLanguageIdOrDefault("Language Code");

                if RespCenter.GET("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);


                if "Salesperson Code" = '' then begin
                    CLEAR(SalesPurchPerson);
                    SalesPersonText := '';
                end else begin

                    if SalesPurchPerson.GET("Salesperson Code") then
                        SalesPersonText := Text000
                    else
                        SalesPersonText := '';

                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FIELDCAPTION("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FIELDCAPTION("VAT Registration No.");


                if "Payment Terms Code" = '' then
                    PaymentTerms.INIT()
                else begin
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.INIT()
                else begin
                    ShipmentMethod.GET("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                FormatAddr.SalesHeaderShipTo(CustAddr, ShipToAddr, "Sales Header");

                RecGCustomer.GET("Sell-to Customer No.");

                if not RecGContact.GET("Sales Header"."Sell-to Contact No.") then
                    CLEAR(RecGContact);


                //CLEAR(RecGPaymentMethod) ;
                //IF "Sales Header"."Payment Method Code" <> '' THEN RecGPaymentMethod.GET("Payment Method Code");

                TxtGOurReferences := "Sell-to Customer No.";
                if "Sell-to Customer No." <> "Bill-to Customer No." then
                    TxtGOurReferences := TxtGOurReferences + ' / ' + "Bill-to Customer No.";
            end;

            trigger OnPreDataItem()
            begin
                AsmInfoExistsForLine := false;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET();

        SalesSetup.GET();

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.GET();
                    CompanyInfo3.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.GET();
                    CompanyInfo1.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.GET();
                    CompanyInfo2.CALCFIELDS(Picture);
                end;
        end;
    end;

    var
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        RecGCommentLine: Record "Comment Line";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        RecGContact: Record Contact;
        RecGCustomer: Record Customer;
        DimSetEntry2: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        RecGItem: Record Item;
        RecGItem2: Record Item;
        RecGPaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Payment Terms";
        RespCenter: Record "Responsibility Center";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPurchPersons: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        DimMgt: Codeunit DimensionManagement;
        FormatAddr: Codeunit "Format Address";
        Language: Codeunit Language;
        AsmInfoExistsForLine: Boolean;
        [InDataSet]
        BooGAdditionalInfoVisible: Boolean;
        Continue: Boolean;
        ShowInternalInfo: Boolean;
        Enter: Char;
        CodGShelfNo: Code[20];
        "----- NDBI -----": Integer;
        "- FTA1.00 -": Integer;
        "-PW-": Integer;
        i: Integer;
        IntGPreparationType: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        AccountNoCaptionLbl: Label 'Account No.';
        AmountCaptionLbl: Label 'Amount';
        BankCaptionLbl: Label 'Bank';

        CstG001: Label ' with a capital of ';
        CstG002: Label 'Work Order';
        CstG003: Label 'Order No. %2 from %2.';
        CstG004: Label 'Kit Quantity %1 to setup';
        CstG005: Label 'Work Order \Order No. %1';
        CstG006: Label 'Printed Date';
        CstG007: Label 'Transporter';
        DescriptionCaptionLbl: Label 'Description';
        DocumentDateCaptionLbl: Label 'Document Date';
        EmailCaptionLbl: Label 'E-Mail';
        GiroNoCaptionLbl: Label 'Giro No.';
        HomePageCaptionCap: Label 'Home Page';
        LblAPE: Label 'APE Code :';
        LblBIC: Label 'SWIFT :';
        LblContact: Label 'Contact';
        LblCustomerCode: Label 'Customer code';
        LblCustomerNb: Label 'Customer No.';
        LblDescription: Label 'Vendor code';
        LblDocumentDate: Label 'Document date';
        LblFaxNo: Label 'Fax No.';
        LblIBAN: Label 'IBAN :';
        LblInvoicingAddress: Label 'Invoicing address';
        LblNo: Label 'Description';
        LblOurReferences: Label 'Your customer No.';
        LblPAGE: Label 'Page';
        LblPhoneNo: Label 'Phone No.';
        LblPlannedDeliveryDate: Label 'Planned Delivery Date';
        LblQtyUse: Label 'Quantity Used';
        LblQuantity: Label 'Quantity to prepare';
        LblQuantityAsm: Label 'Quantity Totol';

        LblRefInt: Label 'NAV code';
        LblSalesperson: Label 'Salesperson';
        LblShelfNo: Label 'Shelf No';
        LblTermsOfPayment: Label 'Terms of payment';
        LblTermsOfSale: Label 'Shipping Conditions :';
        LblUnitOfMeasure: Label 'Unit of Measure';
        LblVAT: Label 'VAT N° : ';
        LblVATRegistrationNo: Label 'VAT Registration No. :';
        LblWeight: Label 'Weight';
        LblYourReference: Label 'Your Reference';
        LineDimCaptionLbl: Label 'Line Dimensions';
        OrderNoCaptionLbl: Label 'Order No.';
        PageCaptionCap: Label 'Page %1 of %2';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        PhoneNoCaptionLbl: Label 'Phone No.';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        Text000: Label 'Salesperson:';
        Text003: Label 'COPY';
        Text004: Label 'Work Order \Order No. %2 from %2.';
        UnitPriceCaptionLbl: Label 'Unit Price';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        CopyText: Text[30];
        SalesPersonText: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        OldDimText: Text[75];
        ReferenceText: Text[80];
        VATNoText: Text[80];
        TxtGOurReferences: Text[100];
        DimText: Text[120];
        TxtGAsmCommentLine: Text[1024];
        TxtGCommentLine: Text[1024];

    [Scope('Internal')]
    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
    end;

    procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.GET(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;


    procedure BlanksForIndent(): Text[10]
    begin
        exit(PADSTR('', 2, ' '));
    end;
}

