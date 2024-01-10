report 90002 "Service - Invoice PW" //8044280
{
    DefaultLayout = RDLC;
    RDLCLayout = './ServiceInvoicePW.rdlc';

    Caption = 'Service - Invoice';
    Permissions = TableData "Sales Shipment Buffer" = rimd;

    dataset
    {
        dataitem("Service Invoice Header"; "Service Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Service Invoice';
            column(No_ServiceInvHeader; "No.")
            {
            }
            column(InvDiscountAmountCaption; InvDiscountAmountCaptionLbl)
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
            column(LblYourCustomerN; LblYourCustomerN)
            {
            }
            column(LblYourReference; LblYourReference)
            {
            }
            column(LblYourOrderN; LblYourOrderN)
            {
            }
            column(LblDocumentDate; LblDocumentDate)
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
            column(LblContact; LblContact)
            {
            }
            column(LblSalesperson; LblSalesperson)
            {
            }
            column(LblVATClauses; LblVATClauses)
            {
            }
            column(LblTermsOfSale; LblTermsOfSale)
            {
            }
            column(LblCurrency; LblCurrency)
            {
            }
            column(LblTermsOfPayment; LblTermsOfPayment)
            {
            }
            column(LblUnitOfMeasure; LblUnitOfMeasure)
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
            column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
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
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(ReportTitleCopyText; STRSUBSTNO(Text004, CopyText))
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
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
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
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BillToCustNo_ServInvHeader; "Service Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(BillToCustNo_ServInvHeaderCaption; "Service Invoice Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PostingDate_ServInvHeader; FORMAT("Service Invoice Header"."Posting Date"))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_ServInvHeader; "Service Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_ServInvHeader; FORMAT("Service Invoice Header"."Due Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_ServiceInvHeader; "Service Invoice Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YorRef_ServInvHeader; "Service Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(OrderNo_ServInvHeader; "Service Invoice Header"."Order No.")
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
                    column(DocDate_ServInvHeader; FORMAT("Service Invoice Header"."Document Date", 0, 4))
                    {
                    }
                    column(PricesInclVAT_ServInvHeader; "Service Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(PricesInclVAT_ServInvHeaderCaption; "Service Invoice Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(PageCaption; STRSUBSTNO(Text005, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVAT1_ServInvHeader; FORMAT("Service Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoFaxNoCaption; CompanyInfoFaxNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegistrationNoCaption; CompanyInfoVATRegistrationNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
                    {
                    }
                    column(AmountCaption; AmountCaptionLbl)
                    {
                    }
                    column(ServiceInvoiceHeaderDueDateCaption; ServiceInvoiceHeaderDueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(ServiceInvoiceHeaderPostingDateCaption; ServiceInvoiceHeaderPostingDateCaptionLbl)
                    {
                    }
                    column(CompanyInfo__SWIFT_Code_; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                    }
                    column(CompanyInfoEMail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(LblInvoicingAddress; LblInvoicingAddress)
                    {
                    }
                    column(LblSellToCustomer; LblSellToCustomer)
                    {
                    }
                    column(Cust_PhoneNo; Cust."Phone No.")
                    {
                    }
                    column(Cust_FaxNo; Cust."Fax No.")
                    {
                    }
                    column(RecGContact_Name; RecGContact.Name)
                    {
                    }
                    column(TxtGCodeDevise; TxtGCodeDevise)
                    {
                    }
                    column(TxtGLibDevise; TxtGLibDevise)
                    {
                    }
                    column(RecGPaymentMethod_Description; RecGPaymentMethod.Description)
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(PaymentTermsDescriptionCaption; PaymentTermsDescriptionCaptionLbl)
                    {
                    }
                    column(ServiceInvoiceHeader_Description; "Service Invoice Header".Description)
                    {
                    }
                    column(RecGContact_PhoneNo; RecGContact."Phone No.")
                    {
                    }
                    column(RecGContact_FaxNo; RecGContact."Fax No.")
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Service Invoice Header";
                        DataItemTableView = sorting(Number);
                        column(DimText; DimText)
                        {
                        }
                        column(Number_IntegerLine; Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            DimText := DimTxtArr[Number];
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.BREAK();
                            FindDimTxt("Service Invoice Header"."Dimension Set ID");
                            SETRANGE(Number, 1, DimTxtArrLength);
                        end;
                    }
                    dataitem("Service Invoice Line"; "Service Invoice Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Service Invoice Header";
                        DataItemTableView = sorting("Document No.", "Line No.");
                        column(TypeInt; TypeInt)
                        {
                        }
                        column(BaseDisc_ServInvHeader; "Service Invoice Header"."VAT Base Discount %")
                        {
                        }
                        column(TotalLineAmount; TotalLineAmount)
                        {
                        }
                        column(TotalAmount; TotalAmount)
                        {
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                        }
                        column(TotalInvDiscAmount; TotalInvDiscAmount)
                        {
                        }
                        column(LineNo_ServInvLine; "Line No.")
                        {
                        }
                        column(LineAmt_ServInvLine; "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Description_ServInvLine; Description)
                        {
                        }
                        column(No_ServInvLine; "No.")
                        {
                        }
                        column(Quantity_ServInvLine; Quantity)
                        {
                        }
                        column(UOM_ServInvLine; "Unit of Measure")
                        {
                        }
                        column(No_ServInvLineCaption; FIELDCAPTION("No."))
                        {
                        }
                        column(Description_ServInvLineCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(Quantity_ServInvLineCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(UOM_ServInvLineCaption; FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(UnitPrice_ServInvLine; "Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(LineDisc_ServInvLine; "Line Discount %")
                        {
                        }
                        column(VATIdentifier_ServInvLine; "VAT Identifier")
                        {
                        }
                        column(VATIdentifier_ServInvLineCaption; FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        column(PostedShipmentDate; FORMAT(PostedShipmentDate))
                        {
                        }
                        column(InvDiscountAmount; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(Amount_ServInvLine; Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(AmtInclVATAmount; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(AmtInclVAT_ServInvLine; "Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; TempVATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(LineAmtInvDiscAmtAmtInclVAT; -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT"))
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(ServiceInvoiceLineLineDiscountCaption; ServiceInvoiceLineLineDiscountCaptionLbl)
                        {
                        }
                        column(PostedShipmentDateCaption; PostedShipmentDateCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(LineAmountInvDiscountAmountAmountIncludingVATCaption; LineAmountInvDiscountAmountAmountIncludingVATCaptionLbl)
                        {
                        }
                        dataitem("Service Shipment Buffer"; Integer)
                        {
                            DataItemTableView = sorting(Number);
                            column(ServShptBufferPostingDate; FORMAT(TempServiceShipmentBuffer."Posting Date"))
                            {
                            }
                            column(ServShptBufferQuantity; TempServiceShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShipmentCaption; ShipmentCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    TempServiceShipmentBuffer.FINDFIRST()
                                else
                                    TempServiceShipmentBuffer.NEXT();
                            end;

                            trigger OnPreDataItem()
                            begin
                                TempServiceShipmentBuffer.SETRANGE("Document No.", "Service Invoice Line"."Document No.");
                                TempServiceShipmentBuffer.SETRANGE("Line No.", "Service Invoice Line"."Line No.");

                                SETRANGE(Number, 1, TempServiceShipmentBuffer.COUNT);
                            end;
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number);
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number <= DimTxtArrLength then
                                    DimText := DimTxtArr[Number]
                                else
                                    DimText := FORMAT("Service Invoice Line".Type) + ' ' + AccNo;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.BREAK();

                                FindDimTxt("Service Invoice Line"."Dimension Set ID");
                                if IsServiceContractLine then
                                    SETRANGE(Number, 1, DimTxtArrLength + 1)
                                else
                                    SETRANGE(Number, 1, DimTxtArrLength);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PostedShipmentDate := 0D;
                            if Quantity <> 0 then
                                PostedShipmentDate := FindPostedShipmentDate();

                            IsServiceContractLine := (Type = Type::"G/L Account") and ("Service Item No." <> '') and ("Contract No." <> '');
                            if IsServiceContractLine then begin
                                AccNo := "No.";
                                "No." := "Service Item No.";
                            end;

                            TempVATAmountLine.INIT();
                            TempVATAmountLine."VAT Identifier" := "VAT Identifier";
                            TempVATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            TempVATAmountLine."Tax Group Code" := "Tax Group Code";
                            TempVATAmountLine."VAT %" := "VAT %";
                            TempVATAmountLine."VAT Base" := Amount;
                            TempVATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            TempVATAmountLine."Line Amount" := "Line Amount";
                            if "Allow Invoice Disc." then
                                TempVATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            TempVATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            TempVATAmountLine."VAT Clause Code" := "VAT Clause Code";
                            TempVATAmountLine.InsertLine();

                            TotalLineAmount += "Line Amount";
                            TotalAmount += Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalInvDiscAmount += "Inv. Discount Amount";
                            TypeInt := Type;
                        end;

                        trigger OnPreDataItem()
                        begin
                            TempVATAmountLine.DELETEALL();
                            TempServiceShipmentBuffer.RESET();
                            TempServiceShipmentBuffer.DELETEALL();
                            FirstValueEntryNo := 0;
                            MoreLines := FINDLAST();
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                                MoreLines := NEXT(-1) <> 0;
                            if not MoreLines then
                                CurrReport.BREAK();
                            SETRANGE("Line No.", 0, "Line No.");
                            // CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount");

                            TotalLineAmount := 0;
                            TotalAmount := 0;
                            TotalAmountInclVAT := 0;
                            TotalInvDiscAmount := 0;
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VATAmtLineVATBase; TempVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmount; TempVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmount; TempVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; TempVATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmount; TempVATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; TempVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; TempVATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLineVATCaption; VATAmountLineVATCaptionLbl)
                        {
                        }
                        column(VATAmountLineVATBaseControl108Caption; VATAmountLineVATBaseControl108CaptionLbl)
                        {
                        }
                        column(VATAmountLineVATAmountControl109Caption; VATAmountLineVATAmountControl109CaptionLbl)
                        {
                        }
                        column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                        {
                        }
                        column(VATAmountLineVATIdentifierCaption; VATAmountLineVATIdentifierCaptionLbl)
                        {
                        }
                        column(VATAmountLineInvDiscBaseAmountControl141Caption; VATAmountLineInvDiscBaseAmountControl141CaptionLbl)
                        {
                        }
                        column(VATAmountLineLineAmountControl140Caption; VATAmountLineLineAmountControl140CaptionLbl)
                        {
                        }
                        column(VATAmountLineVATBaseControl116Caption; VATAmountLineVATBaseControl116CaptionLbl)
                        {
                        }
                        column(VATClauseDescription; VATClause.Description)
                        {
                        }
                        column(VATClauseDescription2; VATClause."Description 2")
                        {
                        }
                        column(VATClausesCaption; VATClausesCap)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLine.GetLine(Number);
                            //>>TDL_TVA.001
                            if not VATClause.GET(TempVATAmountLine."VAT Clause Code") then
                                CurrReport.SKIP();
                            VATClause.TranslateDescription("Service Invoice Header"."Language Code");
                            //<<TDL_TVA.001
                        end;

                        trigger OnPreDataItem()
                        begin
                            //>>TDL_TVA.001
                            //IF VATAmountLine.GetTotalVATAmount = 0 THEN
                            //  CurrReport.BREAK;
                            //<<TDL_TVA.001
                            SETRANGE(Number, 1, TempVATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(
                            //   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                            //   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATClauseEntryCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VATClauseVATIdentifier; TempVATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATClauseCode; TempVATAmountLine."VAT Clause Code")
                        {
                        }
                        column(VATClauseDescription3; VATClause.Description)
                        {
                        }
                        column(VATClauseDescription4; VATClause."Description 2")
                        {
                        }
                        column(VATClauseAmount; TempVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption1; VATClausesCap)
                        {
                        }
                        column(VATClauseVATIdentifierCaption; VATAmountLineVATIdentifierCaptionLbl)
                        {
                        }
                        column(VATClauseVATAmtCaption; VATAmountLineVATAmountControl109CaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLine.GetLine(Number);
                            //>>TDL_TVA.001
                            //IF NOT VATClause.GET(VATAmountLine."VAT Clause Code") THEN
                            //  CurrReport.SKIP;
                            //VATClause.TranslateDescription("Service Invoice Header"."Language Code");
                            //<<TDL_TVA.001
                        end;

                        trigger OnPreDataItem()
                        begin
                            CLEAR(VATClause);
                            SETRANGE(Number, 1, TempVATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            where(Number = const(1));
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            where(Number = const(1));
                        column(CustNo_ServInvHeader; "Service Invoice Header"."Customer No.")
                        {
                        }
                        column(CustNo_ServInvHeaderCaption; "Service Invoice Header".FIELDCAPTION("Customer No."))
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(Total2_Number; Total2.Number)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            //>>PW
                            /*OLD
                            IF NOT ShowShippingAddr THEN
                              CurrReport.BREAK;
                            */
                            //>>PW

                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                    // CurrReport.PAGENO := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.PREVIEW then
                        ServiceInvCountPrinted.RUN("Service Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecLCurrency: Record Currency;
            begin
                CurrReport.LANGUAGE := CULanguage.GetLanguageIDOrDefault("Language Code");

                if RespCenter.GET("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                if "Order No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := FIELDCAPTION("Order No.");
                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.INIT();
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.GET("Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FIELDCAPTION("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FIELDCAPTION("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TESTFIELD("LCY Code");
                    TotalText := STRSUBSTNO(Text001, GLSetup."LCY Code");
                    TotalInclVATText := STRSUBSTNO(Text002, GLSetup."LCY Code");
                    TotalExclVATText := STRSUBSTNO(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := STRSUBSTNO(Text001, "Currency Code");
                    TotalInclVATText := STRSUBSTNO(Text002, "Currency Code");
                    TotalExclVATText := STRSUBSTNO(Text006, "Currency Code");
                end;
                FormatAddr.ServiceInvBillTo(CustAddr, "Service Invoice Header");
                Cust.GET("Bill-to Customer No.");

                if "Payment Terms Code" = '' then
                    PaymentTerms.INIT()
                else
                    PaymentTerms.GET("Payment Terms Code");

                FormatAddr.ServiceInvShipTo(ShipToAddr, CustAddr, "Service Invoice Header");

                //>>PW
                /*//OLD
                ShowShippingAddr := "Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                  IF ShipToAddr[i] <> CustAddr[i] THEN
                    ShowShippingAddr := TRUE;
                */

                TxtGOurReferences := "Customer No.";
                if "Customer No." <> "Bill-to Customer No." then
                    TxtGOurReferences := TxtGOurReferences + ' / ' + "Bill-to Customer No.";

                if not RecGContact.GET("Contact No.") then
                    CLEAR(RecGContact);

                CLEAR(RecGPaymentMethod);
                if "Payment Method Code" <> '' then RecGPaymentMethod.GET("Payment Method Code");

                if "Currency Code" = '' then
                    TxtGCodeDevise := GLSetup."LCY Code"
                else
                    TxtGCodeDevise := "Currency Code";

                if RecLCurrency.GET(TxtGCodeDevise) then
                    TxtGLibDevise := RecLCurrency.Description;

                //<<PW

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
        CompanyInfo.GET();
        ServiceSetup.GET();

        case ServiceSetup."Logo Position on Documents" of
            ServiceSetup."Logo Position on Documents"::"No Logo":
                ;
            ServiceSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.GET();
                    CompanyInfo3.CALCFIELDS(Picture);
                end;
            ServiceSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.GET();
                    CompanyInfo1.CALCFIELDS(Picture);
                end;
            ServiceSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.GET();
                    CompanyInfo2.CALCFIELDS(Picture);
                end;
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        RecGContact: Record Contact;
        Cust: Record Customer;
        DimSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";
        RecGPaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        RespCenter: Record "Responsibility Center";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ServiceSetup: Record "Service Mgt. Setup";
        TempServiceShipmentBuffer: Record "Service Shipment Buffer" temporary;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        VATClause: Record "VAT Clause";
        FormatAddr: Codeunit "Format Address";
        CULanguage: Codeunit Language;
        ServiceInvCountPrinted: Codeunit "Service Inv.-Printed";
        IsServiceContractLine: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        AccNo: Code[20];
        PostedShipmentDate: Date;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalLineAmount: Decimal;
        DimTxtArrLength: Integer;
        FirstValueEntryNo: Integer;
        NextEntryNo: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        TypeInt: Integer;
        AmountCaptionLbl: Label 'Amount';
        CompanyInfoBankAccountNoCaptionLbl: Label 'Account No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoFaxNoCaptionLbl: Label 'Fax No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegistrationNoCaptionLbl: Label 'VAT Reg. No.';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        InvDiscountAmountCaptionLbl: Label 'Invoice Discount Amount';
        InvoiceNoCaptionLbl: Label 'Invoice No.';
        LblAPE: Label 'APE Code :';
        LblBIC: Label 'SWIFT :';
        LblContact: Label 'Contact';
        LblCurrency: Label 'Currency';
        LblDescription: Label 'Description';
        LblDocumentDate: Label 'Document date';
        LblFaxNo: Label 'Fax No.';
        LblIBAN: Label 'IBAN :';
        LblInvoicingAddress: Label 'Invoicing address';
        LblNo: Label 'No.';
        LblPAGE: Label 'Page';
        LblPhoneNo: Label 'Phone No.';
        LblQuantity: Label 'Quantity';
        LblSalesperson: Label 'Salesperson';
        LblSellToCustomer: Label 'Sell-to Customer';
        LblTermsOfPayment: Label 'Terms of payment';
        LblTermsOfSale: Label 'Terms of sale :';
        LblUnitOfMeasure: Label 'Unit of Measure';
        LblVAT: Label 'VAT N° : ';
        LblVATClauses: Label 'VAT clauses';
        LblVATRegistrationNo: Label 'VAT Registration No. :';
        LblYourCustomerN: Label 'Your customer N°';
        LblYourOrderN: Label 'Order N°';
        LblYourReference: Label 'Your Reference';
        LineAmountInvDiscountAmountAmountIncludingVATCaptionLbl: Label 'Payment Discount on VAT';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        PaymentTermsDescriptionCaptionLbl: Label 'Payment Terms';
        PostedShipmentDateCaptionLbl: Label 'Posted Shipment Date';
        ServiceInvoiceHeaderDueDateCaptionLbl: Label 'Due Date';
        ServiceInvoiceHeaderPostingDateCaptionLbl: Label 'Posting Date';
        ServiceInvoiceLineLineDiscountCaptionLbl: Label 'Disc. %';
        ShipmentCaptionLbl: Label 'Shipment';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        SubtotalCaptionLbl: Label 'Subtotal';
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label 'Service - Invoice %1';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        UnitPriceCaptionLbl: Label 'Unit Price';
        VATAmountLineInvDiscBaseAmountControl141CaptionLbl: Label 'Inv. Disc. Base Amount';
        VATAmountLineLineAmountControl140CaptionLbl: Label 'Line Amount';
        VATAmountLineVATAmountControl109CaptionLbl: Label 'VAT Amount';
        VATAmountLineVATBaseControl108CaptionLbl: Label 'VAT Base';
        VATAmountLineVATBaseControl116CaptionLbl: Label 'Total';
        VATAmountLineVATCaptionLbl: Label 'VAT %';
        VATAmountLineVATIdentifierCaptionLbl: Label 'VAT Identifier';
        VATAmountSpecificationCaptionLbl: Label 'VAT Amount Specification';
        VATClausesCap: Label 'VAT Clause';
        TxtGCodeDevise: Text[10];
        CopyText: Text[30];
        SalesPersonText: Text[30];
        TxtGLibDevise: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        DimTxtArr: array[500] of Text[50];
        ShipToAddr: array[8] of Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        OrderNoText: Text[80];
        ReferenceText: Text[80];
        VATNoText: Text[80];
        TxtGOurReferences: Text[100];
        DimText: Text[120];


    procedure FindPostedShipmentDate(): Date
    var
        TempServiceShipmentBuffer2: Record "Service Shipment Buffer" temporary;
        ServiceShipmentHeader: Record "Service Shipment Header";
    begin
        NextEntryNo := 1;
        if "Service Invoice Line"."Shipment No." <> '' then
            if ServiceShipmentHeader.GET("Service Invoice Line"."Shipment No.") then
                exit(ServiceShipmentHeader."Posting Date");

        if "Service Invoice Header"."Order No." = '' then
            exit("Service Invoice Header"."Posting Date");

        case "Service Invoice Line".Type of
            "Service Invoice Line".Type::Item:
                GenerateBufferFromValueEntry("Service Invoice Line");
            "Service Invoice Line".Type::"G/L Account", "Service Invoice Line".Type::Resource,
          "Service Invoice Line".Type::Cost:
                GenerateBufferFromShipment("Service Invoice Line");
            "Service Invoice Line".Type::" ":
                exit(0D);
        end;

        TempServiceShipmentBuffer.RESET();
        TempServiceShipmentBuffer.SETRANGE("Document No.", "Service Invoice Line"."Document No.");
        TempServiceShipmentBuffer.SETRANGE("Line No.", "Service Invoice Line"."Line No.");
        if TempServiceShipmentBuffer.FINDFIRST() then begin
            TempServiceShipmentBuffer2 := TempServiceShipmentBuffer;
            if TempServiceShipmentBuffer.NEXT() = 0 then begin
                TempServiceShipmentBuffer.GET(
                  TempServiceShipmentBuffer2."Document No.", TempServiceShipmentBuffer2."Line No.", TempServiceShipmentBuffer2."Entry No.");
                TempServiceShipmentBuffer.DELETE();
                exit(TempServiceShipmentBuffer2."Posting Date");
            end;
            TempServiceShipmentBuffer.CALCSUMS(Quantity);
            if TempServiceShipmentBuffer.Quantity <> "Service Invoice Line".Quantity then begin
                TempServiceShipmentBuffer.DELETEALL();
                exit("Service Invoice Header"."Posting Date");
            end;
        end else
            exit("Service Invoice Header"."Posting Date");
    end;


    procedure GenerateBufferFromValueEntry(ServiceInvoiceLine2: Record "Service Invoice Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := ServiceInvoiceLine2."Quantity (Base)";
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.", ServiceInvoiceLine2."Document No.");
        ValueEntry.SETRANGE("Posting Date", "Service Invoice Header"."Posting Date");
        ValueEntry.SETRANGE("Item Charge No.", '');
        ValueEntry.SETFILTER("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.FINDSET() then
            repeat
                if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then begin
                    if ServiceInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / ServiceInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      ServiceInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.NEXT() = 0) or (TotalQuantity = 0);
    end;


    procedure GenerateBufferFromShipment(ServiceInvoiceLine: Record "Service Invoice Line")
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceInvoiceLine2: Record "Service Invoice Line";
        ServiceShipmentHeader: Record "Service Shipment Header";
        ServiceShipmentLine: Record "Service Shipment Line";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := 0;
        ServiceInvoiceHeader.SETCURRENTKEY("Order No.");
        ServiceInvoiceHeader.SETFILTER("No.", '..%1', "Service Invoice Header"."No.");
        ServiceInvoiceHeader.SETRANGE("Order No.", "Service Invoice Header"."Order No.");
        if ServiceInvoiceHeader.FINDSET() then
            repeat
                ServiceInvoiceLine2.SETRANGE("Document No.", ServiceInvoiceHeader."No.");
                ServiceInvoiceLine2.SETRANGE("Line No.", ServiceInvoiceLine."Line No.");
                ServiceInvoiceLine2.SETRANGE(Type, ServiceInvoiceLine.Type);
                ServiceInvoiceLine2.SETRANGE("No.", ServiceInvoiceLine."No.");
                ServiceInvoiceLine2.SETRANGE("Unit of Measure Code", ServiceInvoiceLine."Unit of Measure Code");
                if ServiceInvoiceLine2.FINDSET() then
                    repeat
                        TotalQuantity := TotalQuantity + ServiceInvoiceLine2.Quantity;
                    until ServiceInvoiceLine2.NEXT() = 0;
            until ServiceInvoiceHeader.NEXT() = 0;

        ServiceShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        ServiceShipmentLine.SETRANGE("Order No.", "Service Invoice Header"."Order No.");
        ServiceShipmentLine.SETRANGE("Order Line No.", ServiceInvoiceLine."Line No.");
        ServiceShipmentLine.SETRANGE("Line No.", ServiceInvoiceLine."Line No.");
        ServiceShipmentLine.SETRANGE(Type, ServiceInvoiceLine.Type);
        ServiceShipmentLine.SETRANGE("No.", ServiceInvoiceLine."No.");
        ServiceShipmentLine.SETRANGE("Unit of Measure Code", ServiceInvoiceLine."Unit of Measure Code");
        ServiceShipmentLine.SETFILTER(Quantity, '<>%1', 0);

        if ServiceShipmentLine.FINDSET() then
            repeat
                if ABS(ServiceShipmentLine.Quantity) <= ABS(TotalQuantity - ServiceInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - ServiceShipmentLine.Quantity
                else begin
                    if ABS(ServiceShipmentLine.Quantity) > ABS(TotalQuantity) then
                        ServiceShipmentLine.Quantity := TotalQuantity;
                    Quantity :=
                      ServiceShipmentLine.Quantity - (TotalQuantity - ServiceInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - ServiceShipmentLine.Quantity;
                    ServiceInvoiceLine.Quantity := ServiceInvoiceLine.Quantity - Quantity;

                    if ServiceShipmentHeader.GET(ServiceShipmentLine."Document No.") then
                        AddBufferEntry(
                          ServiceInvoiceLine,
                          Quantity,
                          ServiceShipmentHeader."Posting Date");
                end;
            until (ServiceShipmentLine.NEXT() = 0) or (TotalQuantity = 0);
    end;


    procedure AddBufferEntry(ServiceInvoiceLine: Record "Service Invoice Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        TempServiceShipmentBuffer.SETRANGE("Document No.", ServiceInvoiceLine."Document No.");
        TempServiceShipmentBuffer.SETRANGE("Line No.", ServiceInvoiceLine."Line No.");
        TempServiceShipmentBuffer.SETRANGE("Posting Date", PostingDate);
        if TempServiceShipmentBuffer.FINDFIRST() then begin
            TempServiceShipmentBuffer.Quantity := TempServiceShipmentBuffer.Quantity + QtyOnShipment;
            TempServiceShipmentBuffer.MODIFY();
            exit;
        end;

        with TempServiceShipmentBuffer do begin
            "Document No." := ServiceInvoiceLine."Document No.";
            "Line No." := ServiceInvoiceLine."Line No.";
            "Entry No." := NextEntryNo;
            Type := ServiceInvoiceLine.Type;
            "No." := ServiceInvoiceLine."No.";
            Quantity := QtyOnShipment;
            "Posting Date" := PostingDate;
            INSERT();
            NextEntryNo := NextEntryNo + 1
        end;
    end;


    procedure FindDimTxt(DimSetID: Integer)
    var
        StartNewLine: Boolean;
        i: Integer;
        Separation: Text[5];
        TxtToAdd: Text[120];
    begin
        DimSetEntry.SETRANGE("Dimension Set ID", DimSetID);
        DimTxtArrLength := 0;
        for i := 1 to ARRAYLEN(DimTxtArr) do
            DimTxtArr[i] := '';
        if not DimSetEntry.FINDSET() then
            exit;
        Separation := '; ';
        repeat
            TxtToAdd := DimSetEntry."Dimension Code" + ' - ' + DimSetEntry."Dimension Value Code";
            if DimTxtArrLength = 0 then
                StartNewLine := true
            else
                StartNewLine := STRLEN(DimTxtArr[DimTxtArrLength]) + STRLEN(Separation) + STRLEN(TxtToAdd) > MAXSTRLEN(DimTxtArr[1]);
            if StartNewLine then begin
                DimTxtArrLength += 1;
                DimTxtArr[DimTxtArrLength] := CopyStr(TxtToAdd, 1, 50);
            end else
                DimTxtArr[DimTxtArrLength] := DimTxtArr[DimTxtArrLength] + Separation + TxtToAdd;
        until DimSetEntry.NEXT() = 0;
    end;
}

