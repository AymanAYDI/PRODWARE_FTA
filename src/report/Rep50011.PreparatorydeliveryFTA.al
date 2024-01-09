
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
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Order));
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
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
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
                        DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                            WHERE("Attached to Line No." = FILTER(0));
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
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText2; DimText)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET() THEN
                                        CurrReport.BREAK();
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK();

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.BREAK();

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem("Extended Text Line"; "Extended Text Line")
                        {
                            DataItemLink = "No." = FIELD("No.");
                            DataItemTableView = SORTING("Table Name", "No.", "Language Code", "Text No.", "Line No.");
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
                            DataItemTableView = SORTING(Number);
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
                                IF Number = 1 THEN
                                    AsmLine.FINDSET()
                                ELSE
                                    AsmLine.NEXT();



                                IF (AsmLine.Type = AsmLine.Type::Item) AND (AsmLine."No." <> '') THEN BEGIN
                                    RecGItem2.GET(AsmLine."No.");

                                END ELSE BEGIN
                                    RecGItem2.INIT();
                                END;


                                CLEAR(TxtGAsmCommentLine);
                                RecGCommentLine.SETRANGE("Table Name", RecGCommentLine."Table Name"::Item);
                                RecGCommentLine.SETRANGE("No.", AsmLine."No.");
                                IF RecGCommentLine.FINDFIRST() THEN BEGIN
                                    REPEAT
                                        TxtGAsmCommentLine += FORMAT(Enter) + RecGCommentLine.Comment;
                                    UNTIL RecGCommentLine.NEXT() = 0;
                                    TxtGAsmCommentLine := COPYSTR(TxtGAsmCommentLine, 2, STRLEN(TxtGAsmCommentLine));
                                END;


                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT AsmInfoExistsForLine THEN
                                    CurrReport.BREAK();
                                AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                SETRANGE(Number, 1, AsmLine.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin

                            AsmInfoExistsForLine := AsmToOrderExists(AsmHeader);


                            IF ("Sales Line".Type = "Sales Line".Type::Item) AND ("Sales Line"."No." <> '') THEN BEGIN
                                RecGItem.GET("Sales Line"."No.");
                            END ELSE BEGIN
                                RecGItem.INIT();
                            END;

                            BooGAdditionalInfoVisible := FALSE;

                            IF ("Sales Line".Type = "Sales Line".Type::Item) AND ("Sales Line"."No." <> '') THEN BEGIN
                                IF RecGItem."Automatic Ext. Texts" THEN
                                    BooGAdditionalInfoVisible := TRUE;
                            END;


                            CLEAR(TxtGCommentLine);
                            RecGCommentLine.SETRANGE("Table Name", RecGCommentLine."Table Name"::Item);
                            RecGCommentLine.SETRANGE("No.", "No.");
                            IF RecGCommentLine.FINDFIRST() THEN BEGIN
                                REPEAT
                                    TxtGCommentLine += FORMAT(Enter) + RecGCommentLine.Comment;
                                UNTIL RecGCommentLine.NEXT() = 0;
                                TxtGCommentLine := COPYSTR(TxtGCommentLine, 2, STRLEN(TxtGCommentLine));
                            END;

                            IF Type = Type::Item THEN BEGIN
                                EVALUATE(IntGPreparationType, FORMAT("Sales Line"."Preparation Type", 0, '<Number>'));
                                CodGShelfNo := RecGItem."Shelf No.";
                            END;

                            //<<NDBI
                        end;

                        trigger OnPreDataItem()
                        begin
                            Enter := 10;


                            SETRANGE("Sales Line".Prepare, TRUE);
                        end;
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
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
                    SalesPost: Codeunit "Sales-Post";
                    TempSalesLine: Record "Sales Line" temporary;
                begin

                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
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
                "-PW-": Integer;
                RecLCurrency: Record Currency;
            begin
                CompanyInfo.GET();
                CurrReport.LANGUAGE := Language.GetLanguageIdOrDefault("Language Code");

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                    FormatAddr.Company(CompanyAddr, CompanyInfo);


                IF "Salesperson Code" = '' THEN BEGIN
                    CLEAR(SalesPurchPerson);
                    SalesPersonText := '';
                END ELSE BEGIN

                    IF SalesPurchPerson.GET("Salesperson Code") THEN
                        SalesPersonText := Text000
                    ELSE
                        SalesPersonText := '';

                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                    VATNoText := ''
                ELSE
                    VATNoText := FIELDCAPTION("VAT Registration No.");


                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT()
                ELSE BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                END;

                IF "Shipment Method Code" = '' THEN
                    ShipmentMethod.INIT()
                ELSE BEGIN
                    ShipmentMethod.GET("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                END;

                FormatAddr.SalesHeaderShipTo(CustAddr, ShipToAddr, "Sales Header");

                RecGCustomer.GET("Sell-to Customer No.");

                IF NOT RecGContact.GET("Sales Header"."Sell-to Contact No.") THEN
                    CLEAR(RecGContact);


                //CLEAR(RecGPaymentMethod) ;
                //IF "Sales Header"."Payment Method Code" <> '' THEN RecGPaymentMethod.GET("Payment Method Code");

                TxtGOurReferences := "Sell-to Customer No.";
                IF "Sell-to Customer No." <> "Bill-to Customer No." THEN
                    TxtGOurReferences := TxtGOurReferences + ' / ' + "Bill-to Customer No.";
            end;

            trigger OnPreDataItem()
            begin
                AsmInfoExistsForLine := FALSE;
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

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET();
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET();
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET();
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;
    end;

    var
        Text000: Label 'Salesperson:';
        Text003: Label 'COPY';
        Text004: Label 'Work Order \Order No. %2 from %2.';
        PageCaptionCap: Label 'Page %1 of %2';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Payment Terms";
        SalesPurchPersons: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Codeunit Language;
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        FormatAddr: Codeunit "Format Address";
        DimMgt: Codeunit DimensionManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        Continue: Boolean;
        i: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        OutputNo: Integer;
        AsmInfoExistsForLine: Boolean;
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankCaptionLbl: Label 'Bank';
        AccountNoCaptionLbl: Label 'Account No.';
        OrderNoCaptionLbl: Label 'Order No.';
        HomePageCaptionCap: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        LineDimCaptionLbl: Label 'Line Dimensions';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        DescriptionCaptionLbl: Label 'Description';
        PhoneNoCaptionLbl: Label 'Phone No.';
        AmountCaptionLbl: Label 'Amount';
        UnitPriceCaptionLbl: Label 'Unit Price';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        DocumentDateCaptionLbl: Label 'Document Date';

        CstG001: Label ' with a capital of ';
        "-PW-": Integer;
        RecGCustomer: Record Customer;
        RecGContact: Record Contact;
        RecGPaymentMethod: Record "Payment Method";
        TxtGOurReferences: Text[100];
        LblBIC: Label 'SWIFT :';
        LblIBAN: Label 'IBAN :';
        LblVATRegistrationNo: Label 'VAT Registration No. :';
        LblAPE: Label 'APE Code :';
        LblVAT: Label 'VAT N° : ';
        LblInvoicingAddress: Label 'Invoicing address';
        LblPAGE: Label 'Page';
        LblPhoneNo: Label 'Phone No.';
        LblFaxNo: Label 'Fax No.';
        LblYourReference: Label 'Your Reference';
        LblSalesperson: Label 'Salesperson';
        LblDocumentDate: Label 'Document date';
        LblTermsOfSale: Label 'Shipping Conditions :';
        LblTermsOfPayment: Label 'Terms of payment';
        LblContact: Label 'Contact';
        LblOurReferences: Label 'Your customer No.';
        LblUnitOfMeasure: Label 'Unit of Measure';
        LblQuantity: Label 'Quantity to prepare';
        LblDescription: Label 'Vendor code';
        LblNo: Label 'Description';
        "- FTA1.00 -": Integer;
        RecGItem: Record Item;

        LblRefInt: Label 'NAV code';
        LblPlannedDeliveryDate: Label 'Planned Delivery Date';
        CstG002: Label 'Work Order';
        CstG003: Label 'Order No. %2 from %2.';
        LblQuantityAsm: Label 'Quantity Totol';
        LblQtyUse: Label 'Quantity Used';
        CstG004: Label 'Kit Quantity %1 to setup';
        RecGItem2: Record Item;
        RecGCommentLine: Record "Comment Line";
        TxtGCommentLine: Text[1024];
        Enter: Char;
        LblShelfNo: Label 'Shelf No';
        CstG005: Label 'Work Order \Order No. %1';
        CstG006: Label 'Printed Date';
        CstG007: Label 'Transporter';
        LblCustomerCode: Label 'Customer code';
        "----- NDBI -----": Integer;
        TxtGAsmCommentLine: Text[1024];
        IntGPreparationType: Integer;
        CodGShelfNo: Code[20];
        LblCustomerNb: Label 'Customer No.';
        LblWeight: Label 'Weight';
        [InDataSet]
        BooGAdditionalInfoVisible: Boolean;

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
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;


    procedure BlanksForIndent(): Text[10]
    begin
        EXIT(PADSTR('', 2, ' '));
    end;
}

