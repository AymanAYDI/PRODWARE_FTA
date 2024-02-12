report 50080 "Sales - PROFORMA FTA"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FExxxx.001:PA 27/05/2015 : FE Short name
    // - Add SalesPurchPersonPhoneNo in Data Type DataItem, Data Source Integer, Name PageLoop
    //       SalesPurchPersonEMail
    //       LblRefInt
    //       LblPlannedDeliveryDate
    //       SalesLineDescription2 in Data Type DataItem, Data Source Integer, Name RoundLoop
    //       RecGItemNo2
    //       SalesLinePlannedDeliveryDate
    //       DecGNetUnitPriceExcludingVAT
    // - Add C/AL Globals Variables
    //                    Text Constants
    // - Add C/AL in RoundLoop - OnAfterGetRecord()
    // 
    // //>>MODIF HL
    // TI399519 DO.GEPO 08/01/2018 : Modify layout : change color of totalexclvat at bottom
    // 
    // ------------------------------------------------------------------------
    // 
    // //>>FTA.REPORT2018-0511
    //   RoundLoop - OnAfterGetRecord()
    //   Mise en Page (En-tête + colonnage)
    // 
    // //>>FTA.REPORT2018-0607
    //    RoundLoop - OnAfterGetRecord()
    DefaultLayout = RDLC;
    RDLCLayout = './SalesPROFORMAFTA.rdlc';

    Caption = 'Sales - PROFORMA FTA';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Quote';
            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(SalesLineVATIdentifierCaption; SalesLineVATIdentifierCaptionLbl)
            {
            }
            column(PaymentTermsDescriptionCaption; PaymentTermsDescriptionCaptionLbl)
            {
            }
            column(ShipmentMethodDescriptionCaption; ShipmentMethodDescriptionCaptionLbl)
            {
            }
            column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
            {
            }
            column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(SalesLineAllowInvoiceDiscCaption; SalesLineAllowInvoiceDiscCaptionLbl)
            {
            }
            column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
            {
            }
            column(LblRefFouNo; LblRefFouNo)
            {
            }
            column(LblRefCliNo; LblRefCliNo)
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
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(SalesCopyText; StrSubstNo(Text004, CopyText))
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
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
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
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
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
                    column(ShipmentDate_SalesHeader; Format("Sales Header"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(SalesPurchPersonPhoneNoCaption; SalesPurchPerson.FieldCaption("Phone No."))
                    {
                    }
                    column(SalesPurchPersonPhoneNo; SalesPurchPerson."Phone No.")
                    {
                    }
                    column(SalesPurchPersonEMailCaption; SalesPurchPerson.FieldCaption("E-Mail"))
                    {
                    }
                    column(SalesPurchPersonEMail; SalesPurchPerson."E-Mail")
                    {
                    }
                    column(No1_SalesHeader; "Sales Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesHeader; "Sales Header"."Your Reference")
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
                    column(PricesIncludingVAT_SalesHdr; "Sales Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption; StrSubstNo(Text005, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesHdr; Format("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
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
                    column(SalesHeaderShipmentDateCaption; SalesHeaderShipmentDateCaptionLbl)
                    {
                    }
                    column(SalesHeaderNoCaption; SalesHeaderNoCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesIncludingVAT_SalesHdrCaption; "Sales Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    {
                    }
                    column(BankCaptionLbl; BankCaptionLbl)
                    {
                    }
                    column(LblBIC; LblBIC)
                    {
                    }
                    column(LblIBAN; LblIBAN)
                    {
                    }
                    column(CompanyInfo__SWIFT_Code_; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                    }
                    column(LblVATRegistrationNo; LblVATRegistrationNo)
                    {
                    }
                    column(LblInvoicingAddress; LblInvoicingAddress)
                    {
                    }
                    column(LblSellToCustomer; LblSellToCustomer)
                    {
                    }
                    column(LblTitle; LblTitle)
                    {
                    }
                    column(LblVAT; LblVAT)
                    {
                    }
                    column(LblYourCustomerNo; LblYourCustomerNo)
                    {
                    }
                    column(LblYourReference; LblYourReference)
                    {
                    }
                    column(LblPhoneNo; LblPhoneNo)
                    {
                    }
                    column(LblFaxNo; LblFaxNo)
                    {
                    }
                    column(LblSalesperson; LblSalesperson)
                    {
                    }
                    column(LblContact; LblContact)
                    {
                    }
                    column(TxtGOurReferences; TxtGOurReferences)
                    {
                    }
                    column(SalesHeader_ExternalDocumentNo; "Sales Header"."External Document No.")
                    {
                    }
                    column(SalesHeader_PostingDate; "Sales Header"."Posting Date")
                    {
                    }
                    column(LblPAGE; LblPAGE)
                    {
                    }
                    column(LblDocumentDate; LblDocumentDate)
                    {
                    }
                    column(Cust_PhoneNo; RecGCustomer."Phone No.")
                    {
                    }
                    column(Cust_FaxNo; RecGCustomer."Fax No.")
                    {
                    }
                    column(LblTermsOfSale; LblTermsOfSale)
                    {
                    }
                    column(LblTermsOfPayment; LblTermsOfPayment)
                    {
                    }
                    column(LblCurrency; LblCurrency)
                    {
                    }
                    column(RecGPaymentMethod_Description; RecGPaymentMethod.Description)
                    {
                    }
                    column(TxtGCodeDevise; TxtGCodeDevise)
                    {
                    }
                    column(TxtGLibDevise; TxtGLibDevise)
                    {
                    }
                    column(PrepmtPmtTermsDesc; PrepmtPaymentTerms.Description)
                    {
                    }
                    column(RecGContact_Name; RecGContact.Name)
                    {
                    }
                    column(LblNo; LblNo)
                    {
                    }
                    column(LblDescription; LblDescription)
                    {
                    }
                    column(LblQuantity; LblQuantity)
                    {
                    }
                    column(LblUniOfMeasure; LblUniOfMeasure)
                    {
                    }
                    column(LblRefInt; LblRefInt)
                    {
                    }
                    column(LblPlannedDeliveryDate; LblPlannedDeliveryDate)
                    {
                    }
                    column(TxtGMailFax_1; TxtGMailFax[1])
                    {
                    }
                    column(TxtGMailFax_2; TxtGMailFax[2])
                    {
                    }
                    column(TxtGMailFax_3; TxtGMailFax[3])
                    {
                    }
                    column(CompanyInfoFormeJuridique; CompanyInfo."Forme Juridique")
                    {
                    }
                    column(CompanyInfoRCS; CompanyInfo.RCS)
                    {
                    }
                    column(CompanyInfoEcomID; CompanyInfo."ECOM ID")
                    {
                    }
                    column(DocNo; "Sales Header"."No.")
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting(Number)
                                            where(Number = filter(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }
                        column(DimensionLoop1_Number; DimensionLoop1.Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            LblTxt001: Label '%1 %2', Comment = '%1="Dimension Code" %2="Dimension Value Code"';
                            LblTxt002: Label '%1, %2 %3', Comment = '%1=DimText %2="Dimension Code" %3="Dimension Value Code"';

                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet() then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := CopyStr(DimText, 1, MaxStrLen(OldDimText));
                                if DimText = '' then
                                    DimText := StrSubstNo(LblTxt001, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(LblTxt002, DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"),
                                       "Document No." = field("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(RoundLoop; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(LineAmt_SalesLine; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(No_SalesLine; "Sales Line"."No.")
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
                        column(SalesLinePlannedDeliveryDate; Format("Sales Line"."Planned Delivery Date", 0, 1))
                        {
                        }
                        column(Quantity_SalesLine; "Sales Line".Quantity)
                        {
                        }
                        column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                        {
                        }
                        column(LineAmt1_SalesLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(DecGNetUnitPriceExcludingVAT; DecGNetUnitPriceExcludingVAT)
                        {
                        }
                        column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                        {
                        }
                        column(AllowInvoiceDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        {
                            IncludeCaption = false;
                        }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesLine; Format("Sales Line".Type))
                        {
                        }
                        column(No1_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(AllowInvoiceDisYesNo; Format("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(InvDiscountAmount_SalesLine; -SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(DiscountAmt_SalesLine; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtTxt; VATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(SalesLineLineDiscCaption; SalesLineLineDiscCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(SalesLineInvDiscAmtCaption; SalesLineInvDiscAmtCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(VATDiscountAmountCaption; VATDiscountAmountCaptionLbl)
                        {
                        }
                        column(No_SalesLineCaption; "Sales Line".FieldCaption("No."))
                        {
                        }
                        column(Desc_SalesLineCaption; "Sales Line".FieldCaption(Description))
                        {
                        }
                        column(Quantity_SalesLineCaption; "Sales Line".FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_SalesLineCaption; "Sales Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(No2_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(RefClient; RefClient)
                        {
                        }
                        column(RefFournisseur; RefFournisseur)
                        {
                        }
                        column(SalesLineDescription; SalesLineDescription)
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = filter(1 ..));
                            column(DimText_DimnLoop2; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                LblTxt001: Label '%1 %2', Comment = '%1="Dimension Code" %2="Dimension Value Code"';
                                LblTxt002: Label '%1, %2 %3', Comment = '%1=DimText %2="Dimension Code" %3="Dimension Value Code"';
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
                                    OldDimText := CopyStr(DimText, 1, MaxStrLen(OldDimText));
                                    if DimText = '' then
                                        DimText := StrSubstNo(LblTxt001, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(LblTxt002, DimText,
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
                                if not ShowInternalInfo then
                                    CurrReport.Break();

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            RecLItemCrossReference: Record "Item Reference";//"Item Cross Reference" Replaced
                        begin
                            if Number = 1 then
                                SalesLine.findFirst()
                            else
                                SalesLine.Next();
                            "Sales Line" := SalesLine;

                            if not "Sales Header"."Prices Including VAT" and
                               (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
                            then
                                SalesLine."Line Amount" := 0;

                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then
                                "Sales Line"."No." := '';

                            //>>FTA.REPORTS2018-0607
                            //default description
                            SalesLineDescription := SalesLine."Description 2";
                            //<<FTA.REPORTS2018-0607

                            //>>FExxxx.001
                            if ("Sales Line".Type = "Sales Line".Type::Item) and ("Sales Line"."No." <> '') then begin
                                RecGItem.Get("Sales Line"."No.");
                                //>>FTA.REPORTS2018-0607
                                //item description
                                SalesLineDescription := CopyStr(RecGItem.Description, 1, MaxStrLen(SalesLineDescription));
                                //<<FTA.REPORTS2018-0607

                            end else
                                RecGItem.Init();


                            Clear(DecGNetUnitPriceExcludingVAT);
                            if ("Sales Line"."Line Discount %" <> 0) and ("Sales Line".Quantity <> 0) then
                                DecGNetUnitPriceExcludingVAT := Round(("Sales Line"."Line Amount" / "Sales Line".Quantity), GLSetup."Amount Rounding Precision")
                            else
                                DecGNetUnitPriceExcludingVAT := "Sales Line"."Unit Price";

                            //<<FExxxx.001

                            //>>FTA.REPORT2018-0511
                            RefClient := '-';
                            if ("Sales Line".Type = "Sales Line".Type::Item) and ("Sales Line"."No." <> '') then begin

                                RecLItemCrossReference.Reset();
                                RecLItemCrossReference.SetRange("Item No.", SalesLine."No.");
                                RecLItemCrossReference.SetRange("Unit of Measure", SalesLine."Unit of Measure Code");
                                RecLItemCrossReference.SetRange("Reference Type", RecLItemCrossReference."Reference Type"::Customer);
                                RecLItemCrossReference.SetRange("Reference Type No.", "Sales Header"."Bill-to Customer No.");
                                if RecLItemCrossReference.findFirst() then RefClient := RecLItemCrossReference."Reference No.";
                            end;

                            RefFournisseur := RecGItem."No. 2";
                            //<<FTA.REPORT2018-0511
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DeleteALL();
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := SalesLine.FindLast();
                            while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and
                                  (SalesLine."No." = '') and (SalesLine.Quantity = 0) and
                                  (SalesLine.Amount = 0)
                            do
                                MoreLines := SalesLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SalesLine.SetRange("Line No.", 0, SalesLine."Line No.");
                            SetRange(Number, 1, SalesLine.Count);
                            CurrReport.CreateTotals(SalesLine."Line Amount", SalesLine."Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VATBase_VATAmtLine; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmt_VATAmtLine; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmount_VATAmtLine; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvDiscBaseAmt_VATAmtLine; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvoiceDiscAmt_VATAmtLine; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VAT_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_VATAmtLine; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLineVATCaption; VATAmountLineVATCaptionLbl)
                        {
                        }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        {
                        }
                        column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                        {
                        }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        {
                        }
                        column(InvoiceDiscBaseAmtCaption; InvoiceDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(InvoiceDiscAmtCaption; InvoiceDiscAmtCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if VATAmount = 0 then
                                CurrReport.Break();
                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATCtrl_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifierCtrl_VATAmtLine; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Header"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount() = 0)
                            then
                                CurrReport.Break();

                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text008 + Text009
                            else
                                VALSpecLCYHeader := Text008 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Order Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text010, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
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
                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
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
                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            //>>PW
                            /*//OLD
                            IF NOT ShowShippingAddr THEN
                              CurrReport.Break;
                            */
                            //<<PW

                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    SalesLine.DeleteALL();
                    VATAmountLine.DeleteALL();
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount();
                    VATBaseAmount := VATAmountLine.GetTotalVATBase();
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT();

                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                    CurrReport.PAGENO := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if Print then
                        SalesCountPrinted.Run("Sales Header");
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
                "Sell-to Country": Text[50];
            begin
                CurrReport.LANGUAGE := Language.GetLanguageIDOrDefault("Language Code");

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.Init();
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");

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

                if Country.Get("Sell-to Country/Region Code") then
                    "Sell-to Country" := Country.Name;
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");

                //>>PW
                /*OLD
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                  IF (ShipToAddr[i] <> CustAddr[i]) AND (ShipToAddr[i] <> '') AND (ShipToAddr[i] <> "Sell-to Country") THEN
                    ShowShippingAddr := TRUE;
                */
                //<<PW
                if Print then
                    if ArchiveDocument then
                        ArchiveManagement.StoreSalesDocument("Sales Header", false);

                Mark(true);

                //>>PW
                TxtGOurReferences := "Sell-to Customer No.";
                if "Sell-to Customer No." <> "Bill-to Customer No." then
                    TxtGOurReferences := CopyStr(TxtGOurReferences + ' / ' + "Bill-to Customer No.", 1, MaxStrLen(TxtGOurReferences));

                Clear(RecGPaymentMethod);
                if "Sales Header"."Payment Method Code" <> '' then RecGPaymentMethod.Get("Payment Method Code");

                if "Currency Code" = '' then
                    TxtGCodeDevise := GLSetup."LCY Code"
                else
                    TxtGCodeDevise := "Currency Code";

                if RecLCurrency.Get(TxtGCodeDevise) then
                    TxtGLibDevise := RecLCurrency.Description;

                if "Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init()
                else begin
                    PrepmtPaymentTerms.Get("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                end;

                if not RecGCustomer.Get("Sell-to Customer No.") then
                    RecGCustomer.Init();

                //Read Contact
                if not RecGContact.Get("Sales Header"."Sell-to Contact No.") then
                    Clear(RecGContact);

                Clear(TxtGMailFax);
                if BoolGPrintFax then begin

                    CompanyInfo.TestField(CompanyInfo."ECOM ID");
                    RecGUserSetup.Get(UserId);
                    RecGUserSetup.TestField("E-Mail");
                    TxtGMailFax[1] := 'ID:' + CompanyInfo."ECOM ID" + ' ' + '!';
                    TestField("Fax No.");
                    TxtGMailFax[2] := 'Email:' + RecGUserSetup."E-Mail" + ' ' + '!';
                    TxtGMailFax[3] := 'Fax:' + "Fax No." + ' ' + '!';

                end;

                //<<PW

            end;

            // trigger OnPostDataItem()
            // var
            //     ToDo: Record "To-do";
            //     FileManagement: Codeunit "File Management";
            // begin
            //     MarkedOnly := true;
            //     Commit();
            //     CurrReport.LANGUAGE := GLOBALLANGUAGE;
            //     if not FileManagement.IsWebClient() then
            //         if findFirst() and ToDo.WritePERMISSION then
            //             if Print and (NoOfRecords = 1) then
            //                 if Confirm(Text007) then
            //                     CreateTodo;
            // end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count();
                Print := Print or not CurrReport.PREVIEW();
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
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        Caption = 'Archive Document';
                    }
                    field(BooGPrintLogo; BooGPrintLogo)
                    {
                        Caption = 'Print Picture';
                    }
                    field(BoolGPrintFax; BoolGPrintFax)
                    {
                        Caption = 'Fax';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            //ArchiveDocument := SalesSetup."Archive Quotes";
            ArchiveDocument := SalesSetup."Archive Orders";
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.Get();
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

        if RecGUserReport.Get(UserId, 50080) then
            if RecGUserReport.Email then begin
                CompanyInfo3.Get();
                CompanyInfo3.CalcFields(Picture);
            end;
    end;

    trigger OnPreReport()
    begin
        if BoolGPrintFax then
            BooGPrintLogo := true;

        if BooGPrintLogo then begin
            CompanyInfo3.Get();
            CompanyInfo3.CalcFields(Picture);
        end;
    end;

    var
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        Country: Record "Country/Region";
        ShipmentMethod: Record "Shipment Method";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        RecGCustomer: Record Customer;
        RecGItem: Record Item;
        SalesLine: Record "Sales Line" temporary;
        CompanyInfo: Record "Company InFormation";
        CompanyInfo1: Record "Company InFormation";
        CompanyInfo2: Record "Company InFormation";
        CompanyInfo3: Record "Company InFormation";
        RecGUserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        RecGPaymentMethod: Record "Payment Method";
        VATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RecGContact: Record Contact;
        RespCenter: Record "Responsibility Center";
        RecGUserReport: Record "Report Email By User";
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        ArchiveManagement: Codeunit ArchiveManagement;
        Language: CodeUnit Language;
        ArchiveDocument: Boolean;
        BooGPrintLogo: Boolean;
        BoolGPrintFax: Boolean;
        Continue: Boolean;
        MoreLines: Boolean;
        Print: Boolean;
        ShowInternalInfo: Boolean;
        DecGNetUnitPriceExcludingVAT: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATAmountLCY: Decimal;
        VALVATBaseLCY: Decimal;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        NoOfRecords: Integer;
        OutputNo: Integer;
        AmountCaptionLbl: Label 'Amount';
        BankCaptionLbl: Label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: Label 'Account No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoEmailCaptionLbl: Label 'E-Mail';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoHomePageCaptionLbl: Label 'Home Page';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: Label 'VAT Registration No.';
        DocumentDateCaptionLbl: Label 'Document Date';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        InvoiceDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        InvoiceDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
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
        LblPlannedDeliveryDate: Label 'Planned Delivery Date';
        LblQuantity: Label 'Quantity';
        LblRefCliNo: Label 'Code client';
        LblRefFouNo: Label 'Code fournisseur';
        LblRefInt: Label 'No.';
        LblSalesperson: Label 'Salesperson';
        LblSellToCustomer: Label 'Sell-to Customer';
        LblTermsOfPayment: Label 'Terms of payment';
        LblTermsOfSale: Label 'Shipping Conditions :';
        LblTitle: Label 'Proforma';
        LblUniOfMeasure: Label 'Unit of Measure';
        LblVAT: Label 'VAT N° : ';
        LblVATRegistrationNo: Label 'VAT Registration No. :';
        LblYourCustomerNo: Label 'Your customer No.';
        LblYourReference: Label 'Your Reference';
        LineAmtCaptionLbl: Label 'Line Amount';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        PaymentTermsDescriptionCaptionLbl: Label 'Payment Terms';
        SalesHeaderNoCaptionLbl: Label 'Proforma No.';
        SalesHeaderShipmentDateCaptionLbl: Label 'Shipment Date';
        SalesLineAllowInvoiceDiscCaptionLbl: Label 'Allow Invoice Discount';
        SalesLineInvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        SalesLineLineDiscCaptionLbl: Label 'Discount %';
        SalesLineVATIdentifierCaptionLbl: Label 'VAT Identifier';
        ShipmentMethodDescriptionCaptionLbl: Label 'Shipment Method';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        SubtotalCaptionLbl: Label 'Subtotal';
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'Copy';
        Text004: Label 'Proforma %1';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        Text008: Label 'VAT Amount Specification in ';
        Text009: Label 'Local Currency';
        Text010: Label 'Exchange rate: %1/%2';
        TotalCaptionLbl: Label 'Total';
        UnitPriceCaptionLbl: Label 'Unit Price';
        VATAmountLineVATCaptionLbl: Label 'VAT %';
        VATAmountSpecificationCaptionLbl: Label 'VAT Amount Specification';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATDiscountAmountCaptionLbl: Label 'Payment Discount on VAT';
        RefClient: Text;
        RefFournisseur: Text;
        TxtGCodeDevise: Text[10];
        CopyText: Text[30];
        SalesPersonText: Text[30];
        TxtGLibDevise: Text[30];
        CompanyAddr: array[8] of Text[100];
        CustAddr: array[8] of Text[100];
        SalesLineDescription: Text[50];
        ShipToAddr: array[8] of Text[100];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        VALExchRate: Text[50];
        OldDimText: Text[75];
        ReferenceText: Text[80];
        VALSpecLCYHeader: Text[80];
        VATNoText: Text[80];
        TxtGOurReferences: Text[100];
        DimText: Text[120];
        TxtGMailFax: array[6] of Text[200];


    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        Print := PrintFrom;
    end;
}

