
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
    RDLCLayout = './src/report/rdl/PreparatorydeliveryFTA.rdl';

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
            column(LblType; "Sales Line".FieldCaption(Type))
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
            // column(LblCrossReference; "Sales Line".FieldCaption("Cross-Reference No."))
            // {
            // }      
            //todo removed
            column(LblShipmentDate; "Sales Line".FieldCaption("Shipment Date"))
            {
            }
            column(LblPrepaType; "Sales Line".FieldCaption("Preparation Type"))
            {
            }
            column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
            {
            }
            column(Preparer; "Sales Header".FieldCaption(Preparer))
            {
            }
            column(Assembler; "Sales Header".FieldCaption(Assembler))
            {
            }
            column(Packer; "Sales Header".FieldCaption(Packer))
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
                    column(OrderConfirmCopyCaption; StrSubstNo(CstG005, "Sales Header"."No."))
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
                    column(DocDate_SalesHeader; Format("Sales Header"."Document Date"))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShptDate_SalesHeader; Format("Sales Header"."Shipment Date"))
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
                    column(PricesInclVATYesNo_SalesHeader; Format("Sales Header"."Prices Including VAT"))
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
                    column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesHeaderCaption; "Sales Header".FieldCaption("Prices Including VAT"))
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
                    column(SalesPurchPersonPhoneNoCaption; "Sales Header".FieldCaption("Promised Delivery Date"))
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
                        column(Type_SalesLine; Format("Sales Line".Type))
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
                        column(SalesLinePlannedDeliveryDate; Format("Sales Line"."Shipment Date", 0, 1))
                        {
                        }
                        column(SalesLinePreparationType; Format("Preparation Type"))
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
                        column(Desc_SalesLineCaption; "Sales Line".FieldCaption(Description))
                        {
                        }
                        column(No2_SalesLineCaption; "Sales Line".FieldCaption("No."))
                        {
                        }
                        column(Qty_SalesLineCaption; "Sales Line".FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesLineCaption; "Sales Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesLineCaption; "Sales Line".FieldCaption("VAT Identifier"))
                        {
                        }
                        column(AsmLineHeader; StrSubstNo(CstG004, Format("Sales Line"."Outstanding Quantity"), "Sales Line".Description, "Sales Line"."Description 2"))
                        {
                        }
                        column(AsmLineLevelCaption; AsmLine.FieldCaption("Level No."))
                        {
                        }
                        column(AsmLineQtyPerCaption; AsmLine.FieldCaption("Quantity per"))
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
                                    if not DimSetEntry2.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break();

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem("Extended Text Line"; "Extended Text Line")
                        {
                            DataItemLink = "No." = field("No.");
                            DataItemTableView = sorting("Table Name", "No.", "Language Code", "Text No.", "Line No.");
                            column(ExtendedLine_Text; "Extended Text Line".Text)
                            {
                            }
                            column(ExtendedLine_TextCaption; "Extended Text Line".FieldCaption(Text))
                            {
                            }
                            column(ExtendedLine_LineNo; "Extended Text Line"."Line No.")
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                //<<FTA.EXTENDEDTEXT
                                SetRange("Extended Text Line"."Table Name", "Extended Text Line"."Table Name"::Item);
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
                                    AsmLine.FindSet()
                                else
                                    AsmLine.Next();



                                if (AsmLine.Type = AsmLine.Type::Item) and (AsmLine."No." <> '') then begin
                                    RecGItem2.Get(AsmLine."No.");

                                end else begin
                                    RecGItem2.Init();
                                end;


                                Clear(TxtGAsmCommentLine);
                                RecGCommentLine.SetRange("Table Name", RecGCommentLine."Table Name"::Item);
                                RecGCommentLine.SetRange("No.", AsmLine."No.");
                                if RecGCommentLine.findFirst() then begin
                                    repeat
                                        TxtGAsmCommentLine += Format(Enter) + RecGCommentLine.Comment;
                                    until RecGCommentLine.Next() = 0;
                                    TxtGAsmCommentLine := CopyStr(TxtGAsmCommentLine, 2, StrLen(TxtGAsmCommentLine));
                                end;


                            end;

                            trigger OnPreDataItem()
                            begin
                                if not AsmInfoExistsForLine then
                                    CurrReport.Break();
                                AsmLine.SetRange("Document Type", AsmHeader."Document Type");
                                AsmLine.SetRange("Document No.", AsmHeader."No.");
                                SetRange(Number, 1, AsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin

                            AsmInfoExistsForLine := AsmToOrderExists(AsmHeader);


                            if ("Sales Line".Type = "Sales Line".Type::Item) and ("Sales Line"."No." <> '') then begin
                                RecGItem.Get("Sales Line"."No.");
                            end else begin
                                RecGItem.Init();
                            end;

                            BooGAdditionalInfoVisible := false;

                            if ("Sales Line".Type = "Sales Line".Type::Item) and ("Sales Line"."No." <> '') then begin
                                if RecGItem."Automatic Ext. Texts" then
                                    BooGAdditionalInfoVisible := true;
                            end;


                            Clear(TxtGCommentLine);
                            RecGCommentLine.SetRange("Table Name", RecGCommentLine."Table Name"::Item);
                            RecGCommentLine.SetRange("No.", "No.");
                            if RecGCommentLine.findFirst() then begin
                                repeat
                                    TxtGCommentLine += Format(Enter) + RecGCommentLine.Comment;
                                until RecGCommentLine.Next() = 0;
                                TxtGCommentLine := CopyStr(TxtGCommentLine, 2, StrLen(TxtGCommentLine));
                            end;

                            if Type = Type::Item then begin
                                EVALUATE(IntGPreparationType, Format("Sales Line"."Preparation Type", 0, '<Number>'));
                                CodGShelfNo := RecGItem."Shelf No.";
                            end;

                            //<<NDBI
                        end;

                        trigger OnPreDataItem()
                        begin
                            Enter := 10;


                            SetRange("Sales Line".Prepare, true);
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
                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Sell-to Customer No."))
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
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecLCurrency: Record Currency;
                "-PW-": Integer;
            begin
                CompanyInfo.Get();
                CurrReport.LANGUAGE := Language.GetLanguageIdOrDefault("Language Code");

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);


                if "Salesperson Code" = '' then begin
                    Clear(SalesPurchPerson);
                    SalesPersonText := '';
                end else begin

                    if SalesPurchPerson.Get("Salesperson Code") then
                        SalesPersonText := Text000
                    else
                        SalesPersonText := '';

                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");


                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init()
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                FormatAddr.SalesHeaderShipTo(CustAddr, ShipToAddr, "Sales Header");

                RecGCustomer.Get("Sell-to Customer No.");

                if not RecGContact.Get("Sales Header"."Sell-to Contact No.") then
                    Clear(RecGContact);


                //Clear(RecGPaymentMethod) ;
                //IF "Sales Header"."Payment Method Code" <> '' THEN RecGPaymentMethod.Get("Payment Method Code");

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
                        Caption = 'Show Internal InFormation';
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
        GLSetup.Get();

        SalesSetup.Get();

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get();
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get();
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get();
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    var
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        RecGCommentLine: Record "Comment Line";
        CompanyInfo: Record "Company InFormation";
        CompanyInfo1: Record "Company InFormation";
        CompanyInfo2: Record "Company InFormation";
        CompanyInfo3: Record "Company InFormation";
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
        Text003: Label 'Copy';
        Text004: Label 'Work Order \Order No. %2 from %2.';
        UnitPriceCaptionLbl: Label 'Unit Price';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        CopyText: Text[30];
        SalesPersonText: Text[30];
        CompanyAddr: array[8] of Text[100];
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        OldDimText: Text[75];
        ReferenceText: Text[80];
        VATNoText: Text[80];
        TxtGOurReferences: Text[100];
        DimText: Text[120];
        TxtGAsmCommentLine: Text[1024];
        TxtGCommentLine: Text[1024];


    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
    end;

    procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;


    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;
}

