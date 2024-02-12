report 51019 "Sales - Credit Memo FTA"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SalesCreditMemoFTA.rdlc';

    Caption = 'Sales - Credit Memo FTA';
    Permissions = TableData "Sales Shipment Buffer" = rimd;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';
            column(No_SalesCrMemoHeader; "No.")
            {
            }
            column(VATAmtLineVATCptn; VATAmtLineVATCptnLbl)
            {
            }
            column(VATAmtLineVATBaseCptn; VATAmtLineVATBaseCptnLbl)
            {
            }
            column(VATAmtLineVATAmtCptn; VATAmtLineVATAmtCptnLbl)
            {
            }
            column(VATAmtLineVATIdentifierCptn; VATAmtLineVATIdentifierCptnLbl)
            {
            }
            column(TotalCptn; TotalCptnLbl)
            {
            }
            column(SalesCrMemoLineDiscCaption; SalesCrMemoLineDiscCaptionLbl)
            {
            }
            column(LblInvoicingAddress; LblInvoicingAddress)
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
            column(LblShipToAddress; LblShipToAddress)
            {
            }
            column(LblYourCustomerN; LblYourCustomerN)
            {
            }
            column(LblYourReference; LblYourReference)
            {
            }
            column(LblOurReferences; LblOurReferences)
            {
            }
            column(LblPAGE; LblPAGE)
            {
            }
            column(LblDocumentDate; LblDocumentDate)
            {
            }
            column(LblBuyerBank; LblBuyerBank)
            {
            }
            column(LblSalesperson; LblSalesperson)
            {
            }
            column(LblPhoneNo; LblPhoneNo)
            {
            }
            column(LblFaxNo; LblFaxNo)
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
            column(LblContact; LblContact)
            {
            }
            column(LblVATId; LblVATId)
            {
            }
            column(LblSellToCustomer; LblSellToCustomer)
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
            column(ShiptoAddressCptn; ShiptoAddressCptnLbl)
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
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(DocCptnCopyTxt; StrSubstNo(DocumentCaption(), CopyText))
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
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostDate_SalesCrMemoHeader; Format("Sales Cr.Memo Header"."Posting Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."VAT Registration No.")
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(AppliedToText; AppliedToText)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_SalesCrMemoHeader; "Sales Cr.Memo Header"."Your Reference")
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
                    column(DocDt_SalesCrMemoHeader; Format("Sales Cr.Memo Header"."Document Date", 0, 4))
                    {
                    }
                    column(PriceInclVAT_SalesCrMemoHeader; "Sales Cr.Memo Header"."Prices Including VAT")
                    {
                    }
                    column(ReturnOrderNoText; ReturnOrderNoText)
                    {
                    }
                    column(ReturnOrdNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Return Order No.")
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo; Format("Sales Cr.Memo Header"."Prices Including VAT"))
                    {
                    }
                    column(VATBaseDiscPrc_SalesCrMemoLine; "Sales Cr.Memo Header"."VAT Base Discount %")
                    {
                    }
                    column(CompanyInfoPhoneNoCptn; CompanyInfoPhoneNoCptnLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCptn; CompanyInfoVATRegNoCptnLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCptn; CompanyInfoGiroNoCptnLbl)
                    {
                    }
                    column(CompanyInfoBankNameCptn; CompanyInfoBankNameCptnLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCptn; CompanyInfoBankAccNoCptnLbl)
                    {
                    }
                    column(No1_SalesCrMemoHeaderCptn; No1_SalesCrMemoHeaderCptnLbl)
                    {
                    }
                    column(SalesCrMemoHeaderPostDtCptn; SalesCrMemoHeaderPostDtCptnLbl)
                    {
                    }
                    column(DocumentDate; DocumentDateLbl)
                    {
                    }
                    column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
                    {
                    }
                    column(CompanyINfoEmailCaption; CompanyINfoEmailCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PriceInclVAT_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(CompanyInfo__SWIFT_Code_; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                    }
                    column(SalesInvoiceHeader_ExternalDocumentNo; "Sales Cr.Memo Header"."External Document No.")
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
                    column(TxtGOurRef; TxtGOurRef)
                    {
                    }
                    column(RecGPaymentMethod_Description; RecGPaymentMethod.Description)
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(TxtGCodeDevise; TxtGCodeDevise)
                    {
                    }
                    column(TxtGLibDevise; TxtGLibDevise)
                    {
                    }
                    column(TxtAmountTTC_HT; TxtAmountTTC_HT)
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
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = sorting(Number)
                                            where(Number = filter(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1Num; Number)
                        {
                        }
                        column(HeaderDimCptn; HeaderDimCptnLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            Lbltxt001: Label '%1 %2', Comment = '%1="Dimension Code" %2="Dimension Value Code"';
                            Lbltxt002: Label '%1, %2 %3', Comment = '%1=DimText %2="Dimension Code" %3="Dimension Value Code"';
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
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo(Lbltxt001, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(Lbltxt002, DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
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
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Cr.Memo Header";
                        DataItemTableView = sorting("Document No.", "Line No.");
                        column(LineAmt_SalesCrMemoLine; "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesCrMemoLine; Description)
                        {
                        }
                        column(No_SalesCrMemoLine; "No.")
                        {
                        }
                        column(Qty_SalesCrMemoLine; Quantity)
                        {
                        }
                        column(UOM_SalesCrMemoLine; "Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesCrMemoLine; "Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(Disc_SalesCrMemoLine; "Line Discount %")
                        {
                        }
                        column(VATIdentif_SalesCrMemoLine; "VAT Identifier")
                        {
                        }
                        column(PostedReceiptDate; Format(PostedReceiptDate))
                        {
                        }
                        column(Type_SalesCrMemoLine; Format(Type))
                        {
                        }
                        column(NNCTotalLineAmt; NNC_TotalLineAmount)
                        {
                        }
                        column(NNCTotalAmtInclVat; NNC_TotalAmountInclVat)
                        {
                        }
                        column(NNCTotalInvDiscAmt_SalesCrMemoLine; NNC_TotalInvDiscAmount)
                        {
                        }
                        column(NNCTotalAmt; NNC_TotalAmount)
                        {
                        }
                        column(InvDiscAmt_SalesCrMemoLine; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(Amt_SalesCrMemoLine; Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATAmtLineVATAmtTxt; TempVATAmountLine.VATAmountText())
                        {
                        }
                        column(LineAmtInvDiscAmt_SalesCrMemoLine; -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT"))
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineNo_SalesCrMemoLine; "Line No.")
                        {
                        }
                        column(UnitPriceCptn; UnitPriceCptnLbl)
                        {
                        }
                        column(AmountCptn; AmountCptnLbl)
                        {
                        }
                        column(PostedReceiptDateCptn; PostedReceiptDateCptnLbl)
                        {
                        }
                        column(InvDiscAmt_SalesCrMemoLineCptn; InvDiscAmt_SalesCrMemoLineCptnLbl)
                        {
                        }
                        column(SubtotalCptn; SubtotalCptnLbl)
                        {
                        }
                        column(LineAmtInvDiscAmt_SalesCrMemoLineCptn; LineAmtInvDiscAmt_SalesCrMemoLineCptnLbl)
                        {
                        }
                        column(Desc_SalesCrMemoLineCaption; FieldCaption(Description))
                        {
                        }
                        column(No_SalesCrMemoLineCaption; FieldCaption("No."))
                        {
                        }
                        column(Qty_SalesCrMemoLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesCrMemoLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdentif_SalesCrMemoLineCaption; FieldCaption("VAT Identifier"))
                        {
                        }
                        column(SalesLineDescription2; "Sales Cr.Memo Line"."Description 2")
                        {
                        }
                        column(RecGItemNo2; TexGRefFou)
                        {
                        }
                        column(SalesLinePlannedDeliveryDate; Format("Sales Cr.Memo Line"."Shipment Date", 0, 1))
                        {
                        }
                        column(DecGNetUnitPriceExcludingVAT; DecGNetUnitPriceExcludingVAT)
                        {
                            AutoFormatExpression = GetCurrencyCode();
                        }
                        column(RefClient; RefClient)
                        {
                        }
                        column(RefFournisseur; RefFournisseur)
                        {
                        }
                        column(No2_SalesLine; "No.")
                        {
                        }
                        column(SalesLineDescription; SalesLineDescription)
                        {
                        }
                        dataitem("Sales Shipment Buffer"; Integer)
                        {
                            DataItemTableView = sorting(Number);

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    TempSalesShipmentBuffer.findFirst()
                                else
                                    TempSalesShipmentBuffer.Next();
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange(Number, 1, TempSalesShipmentBuffer.Count);
                            end;
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = filter(1 ..));
                            column(DimText_DimensionLoop2; DimText)
                            {
                            }
                            column(LineDimCptn; LineDimCptnLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                Lbltxt001: Label '%1 %2', Comment = '%1="Dimension Code" %2="Dimension Value Code"';
                                Lbltxt002: Label '%1, %2 %3', Comment = '%1=DimText %2="Dimension Code" %3="Dimension Value Code"';
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.findFirst() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := CopyStr(DimText, 1, MaxStrLen(OldDimText));
                                    if DimText = '' then
                                        DimText := StrSubstNo(Lbltxt001, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(Lbltxt002, DimText,
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

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Cr.Memo Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            RecLItemCrossReference: Record "Item Reference";
                        begin
                            NNC_TotalLineAmount += "Line Amount";
                            NNC_TotalAmountInclVat += "Amount Including VAT";
                            NNC_TotalInvDiscAmount += "Inv. Discount Amount";
                            NNC_TotalAmount += Amount;

                            TempSalesShipmentBuffer.DeleteALL();
                            PostedReceiptDate := 0D;
                            if Quantity <> 0 then
                                PostedReceiptDate := FindPostedShipmentDate();

                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                                "No." := '';

                            TempVATAmountLine.Init();
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


                            //>>FTA.REPORTS2018-0607
                            //default description
                            SalesLineDescription := "Sales Cr.Memo Line"."Description 2";
                            //<<FTA.REPORTS2018-0607


                            //>>FExxxx.001
                            if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item) and ("Sales Cr.Memo Line"."No." <> '') then begin
                                RecGItem.Get("Sales Cr.Memo Line"."No.");
                                TexGRefFou := '';
                                RecGItem.Get("No.");
                                RecLItemCrossReference.Reset();
                                RecLItemCrossReference.SetRange("Item No.", "No.");
                                RecLItemCrossReference.SetRange("Unit of Measure", "Unit of Measure Code");
                                RecLItemCrossReference.SetRange("Reference Type", RecLItemCrossReference."Reference Type"::Customer);
                                RecLItemCrossReference.SetRange("Reference Type No.", "Sales Cr.Memo Header"."Bill-to Customer No.");
                                if RecLItemCrossReference.FindSet() then
                                    TexGRefFou := StrSubstNo(CstG002, RecLItemCrossReference."Reference No.") + ' - ';
                                TexGRefFou += RecGItem."No. 2";
                                //>>FTA.REPORTS2018-0607
                                //item description
                                SalesLineDescription := RecGItem.Description;
                                //<<FTA.REPORTS2018-0607


                            end else begin
                                RecGItem.Init();
                                TexGRefFou := '';

                            end;

                            Clear(DecGNetUnitPriceExcludingVAT);
                            if ("Sales Cr.Memo Line"."Line Discount %" <> 0) and ("Sales Cr.Memo Line".Quantity <> 0) then
                                DecGNetUnitPriceExcludingVAT := Round(("Sales Cr.Memo Line"."Line Amount" / "Sales Cr.Memo Line".Quantity), GLSetup."Amount Rounding Precision")
                            else
                                DecGNetUnitPriceExcludingVAT := "Sales Cr.Memo Line"."Unit Price";
                            //<<FExxxx.001

                            //>>FTA.REPORT2018-0411
                            RefClient := '-';
                            if ("Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::Item) and ("Sales Cr.Memo Line"."No." <> '') then begin

                                RecLItemCrossReference.Reset();
                                RecLItemCrossReference.SetRange("Item No.", "Sales Cr.Memo Line"."No.");
                                RecLItemCrossReference.SetRange("Unit of Measure", "Sales Cr.Memo Line"."Unit of Measure Code");
                                RecLItemCrossReference.SetRange("Reference Type", RecLItemCrossReference."Reference Type"::Customer);
                                RecLItemCrossReference.SetRange("Reference Type No.", "Sales Cr.Memo Header"."Bill-to Customer No.");
                                if RecLItemCrossReference.findFirst() then RefClient := RecLItemCrossReference."Reference No.";
                            end;

                            RefFournisseur := RecGItem."No. 2";
                            //<<FTA.REPORT2018-0411
                        end;

                        trigger OnPreDataItem()
                        begin
                            TempVATAmountLine.DeleteALL();
                            TempSalesShipmentBuffer.Reset();
                            TempSalesShipmentBuffer.DeleteALL();
                            FirstValueEntryNo := 0;
                            MoreLines := FindLast();
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");
                            CurrReport.CreateTotals(Amount, "Amount Including VAT", "Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VATAmtLineVATBase; TempVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; TempVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; TempVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; TempVATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvoiceDiscAmt; TempVATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT; TempVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; TempVATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmtSpecificationCptn; VATAmtSpecificationCptnLbl)
                        {
                        }
                        column(VATAmtLineInvDiscBaseAmtCptn; VATAmtLineInvDiscBaseAmtCptnLbl)
                        {
                        }
                        column(VATAmtLineLineAmtCptn; VATAmtLineLineAmtCptnLbl)
                        {
                        }
                        column(VATAmtLineInvoiceDiscAmtCptn; VATAmtLineInvoiceDiscAmtCptnLbl)
                        {
                        }
                        column(VATCounter_Number; Number)
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
                            if not VATClause.Get(TempVATAmountLine."VAT Clause Code") then
                                CurrReport.Skip();
                            VATClause.TranslateDescription("Sales Cr.Memo Header"."Language Code");
                            //<<TDL_TVA.001
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, TempVATAmountLine.Count);
                            CurrReport.CreateTotals(TempVATAmountLine."Line Amount", TempVATAmountLine."Inv. Disc. Base Amount",
                              TempVATAmountLine."Invoice Discount Amount", TempVATAmountLine."VAT Base", TempVATAmountLine."VAT Amount");
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
                            AutoFormatExpression = "Sales Cr.Memo Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption1; VATClausesCap)
                        {
                        }
                        column(VATClauseVATIdentifierCaption; VATAmtLineVATIdentifierCptnLbl)
                        {
                        }
                        column(VATClauseVATAmtCaption; VATAmtLineVATAmtCptnLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLine.GetLine(Number);
                            //>>TDL_TVA.001
                            //IF NOT VATClause.Get(VATAmountLine."VAT Clause Code") THEN
                            //  CurrReport.Skip;
                            //VATClause.TranslateDescription("Sales Cr.Memo Header"."Language Code");
                            //<<TDL_TVA.001
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(VATClause);
                            SetRange(Number, 1, TempVATAmountLine.Count);
                            CurrReport.CreateTotals(TempVATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPercent; TempVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_VATCounterLCY; TempVATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              TempVATAmountLine.GetBaseLCY(
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                            VALVATAmountLCY :=
                              TempVATAmountLine.GetAmountLCY(
                                "Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code",
                                "Sales Cr.Memo Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Cr.Memo Header"."Currency Code" = '')
                            then
                                CurrReport.Break();

                            SetRange(Number, 1, TempVATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text008 + Text009
                            else
                                VALSpecLCYHeader := Text008 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Cr.Memo Header"."Posting Date", "Sales Cr.Memo Header"."Currency Code", 1);
                            CalculatedExchRate := Round(1 / "Sales Cr.Memo Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text010, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
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
                        column(SelltoCustNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Sell-to Customer No.")
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
                        column(SelltoCustNo_SalesCrMemoHeaderCaption; "Sales Cr.Memo Header".FieldCaption("Sell-to Customer No."))
                        {
                        }
                        column(Total2_Number; Number)
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
                begin
                    CurrReport.PAGENO := 1;
                    if Number > 1 then begin
                        //CopyText := Text004;
                        CopyText := '';
                        OutputNo += 1;
                    end;

                    NNC_TotalLineAmount := 0;
                    NNC_TotalAmountInclVat := 0;
                    NNC_TotalInvDiscAmount := 0;
                    NNC_TotalAmount := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.PREVIEW then
                        SalesCrMemoCountPrinted.Run("Sales Cr.Memo Header");
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
            begin
                CurrReport.LANGUAGE := CULanguage.GetLanguageIDOrDefault("Language Code");

                CompanyInfo.Get();

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if "Return Order No." = '' then
                    ReturnOrderNoText := ''
                else
                    ReturnOrderNoText := FieldCaption("Return Order No.");
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
                    TotalExclVATText := StrSubstNo(Text007, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text007, "Currency Code");
                end;
                FormatAddr.SalesCrMemoBillTo(CustAddr, "Sales Cr.Memo Header");
                if "Applies-to Doc. No." = '' then
                    AppliedToText := ''
                else
                    AppliedToText := StrSubstNo(Text003, "Applies-to Doc. Type", "Applies-to Doc. No.");

                FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, "Sales Cr.Memo Header");
                //>>PW
                /*OLD
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                  IF ShipToAddr[i] <> CustAddr[i] THEN
                    ShowShippingAddr := TRUE;
                */
                //<<PW
                if LogInteraction then
                    if not CurrReport.PREVIEW then
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(
                              6, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        else
                            SegManagement.LogDocument(
                              6, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');

                //>>PW
                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                //Read Contact
                if not RecGContact.Get("Sell-to Contact No.") then
                    Clear(RecGContact);

                TxtGOurRef := "Sell-to Customer No.";
                if "Sell-to Customer No." <> "Bill-to Customer No." then
                    TxtGOurRef := TxtGOurRef + ' / ' + "Bill-to Customer No.";

                Clear(RecGPaymentMethod);
                if "Payment Method Code" <> '' then RecGPaymentMethod.Get("Payment Method Code");

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init()
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Currency Code" = '' then
                    TxtGCodeDevise := GLSetup."LCY Code"
                else
                    TxtGCodeDevise := "Currency Code";

                if RecLCurrency.Get(TxtGCodeDevise) then
                    TxtGLibDevise := RecLCurrency.Description;

                if "Prices Including VAT" then
                    TxtAmountTTC_HT := 'TTC'
                else
                    TxtAmountTTC_HT := 'HT';

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
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
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

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        var
            DocumentType: Enum "Interaction Log Entry Document Type";
        begin
            // LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
            LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Sales Cr. Memo") <> '';
            LogInteractionEnable := LogInteraction;
        end;
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

        if RecGUserReport.Get(UserId, 51019) then
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

        if not CurrReport.USEREQUESTPAGE then
            InitLogInteraction();
    end;

    var
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        Cust: Record Customer;
        RecGItem: Record Item;
        CompanyInfo: Record "Company InFormation";
        CompanyInfo1: Record "Company InFormation";
        CompanyInfo2: Record "Company InFormation";
        CompanyInfo3: Record "Company InFormation";
        RecGUserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        RecGPaymentMethod: Record "Payment Method";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        VATClause: Record "VAT Clause";
        RecGContact: Record Contact;
        RespCenter: Record "Responsibility Center";
        TempSalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        RecGUserReport: Record "Report Email By User";
        SalesCrMemoCountPrinted: Codeunit "Sales Cr. Memo-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CULanguage: Codeunit Language;
        BooGPrintLogo: Boolean;
        BoolGPrintFax: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        PostedReceiptDate: Date;
        CalculatedExchRate: Decimal;
        DecGNetUnitPriceExcludingVAT: Decimal;
        NNC_TotalAmount: Decimal;
        NNC_TotalAmountInclVat: Decimal;
        NNC_TotalInvDiscAmount: Decimal;
        NNC_TotalLineAmount: Decimal;
        VALVATAmountLCY: Decimal;
        VALVATBaseLCY: Decimal;
        FirstValueEntryNo: Integer;
        NextEntryNo: Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        AmountCptnLbl: Label 'Amount';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyINfoEmailCaptionLbl: Label 'E-Mail';
        CompanyInfoGiroNoCptnLbl: Label 'Giro No.';
        CompanyInfoHomePageCaptionLbl: Label 'Home Page';
        CompanyInfoPhoneNoCptnLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: Label 'VAT Reg. No.';
        CstG002: Label 'Réf. ext : %1';
        DocumentDateLbl: Label 'Document Date';
        HeaderDimCptnLbl: Label 'Header Dimensions';
        InvDiscAmt_SalesCrMemoLineCptnLbl: Label 'Invoice Discount Amount';
        LblAPE: Label 'APE Code :';
        LblBIC: Label 'SWIFT :';
        LblBuyerBank: Label 'Buyer''s bank';
        LblContact: Label 'Contact';
        LblCurrency: Label 'Currency';
        LblDescription: Label 'Description';
        LblDocumentDate: Label 'Document date';
        LblFaxNo: Label 'Fax No.';
        LblIBAN: Label 'IBAN :';
        LblInvoicingAddress: Label 'Invoicing address';
        LblNo: Label 'No.';
        LblOurReferences: Label 'Our references';
        LblPAGE: Label 'Page';
        LblPhoneNo: Label 'Phone No.';
        LblPlannedDeliveryDate: Label 'Shipment Date';
        LblQuantity: Label 'Quantity';
        LblRefCliNo: Label 'Code client';
        LblRefFouNo: Label 'Code fournisseur';
        LblRefInt: Label 'No.';
        LblSalesperson: Label 'Salesperson';
        LblSellToCustomer: Label 'Sell-to Customer';
        LblShipToAddress: Label 'Ship-to Address';
        LblTermsOfPayment: Label 'Terms of payment';
        LblTermsOfSale: Label 'Shipping Conditions :';
        LblUnitOfMeasure: Label 'Unit of Measure';
        LblVAT: Label 'VAT N° : ';
        LblVATClauses: Label 'VAT clauses';
        LblVATId: Label 'VAT';
        LblVATRegistrationNo: Label 'VAT Registration No. :';
        LblYourCustomerN: Label 'Your customer N°';
        LblYourReference: Label 'Your Reference';
        LineAmtInvDiscAmt_SalesCrMemoLineCptnLbl: Label 'Payment Discount on VAT';
        LineDimCptnLbl: Label 'Line Dimensions';
        No1_SalesCrMemoHeaderCptnLbl: Label 'Credit Memo No.';
        PageCaptionCap: Label 'Page %1 of %2';
        PostedReceiptDateCptnLbl: Label 'Return Receipt Date';
        SalesCrMemoHeaderPostDtCptnLbl: Label 'Posting Date';
        SalesCrMemoLineDiscCaptionLbl: Label 'Discount %';
        ShiptoAddressCptnLbl: Label 'Ship-to Address';
        SubtotalCptnLbl: Label 'Subtotal';
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label '(Applies to %1 %2)';
        Text005: Label 'Credit Memo %1';
        Text007: Label 'Total %1 Excl. VAT';
        Text008: Label 'VAT Amount Specification in ';
        Text009: Label 'Local Currency';
        Text010: Label 'Exchange rate: %1/%2';
        Text011: Label 'Sales - Prepmt. Credit Memo %1';
        TotalCptnLbl: Label 'Total';
        UnitPriceCptnLbl: Label 'Unit Price';
        VATAmtLineInvDiscBaseAmtCptnLbl: Label 'Invoice Discount Base Amount';
        VATAmtLineInvoiceDiscAmtCptnLbl: Label 'Invoice Discount Amount';
        VATAmtLineLineAmtCptnLbl: Label 'Line Amount';
        VATAmtLineVATAmtCptnLbl: Label 'VAT Amount';
        VATAmtLineVATBaseCptnLbl: Label 'VAT Base';
        VATAmtLineVATCptnLbl: Label 'VAT %';
        VATAmtLineVATIdentifierCptnLbl: Label 'VAT Identifier';
        VATAmtSpecificationCptnLbl: Label 'VAT Amount Specification';
        VATClausesCap: Label 'VAT Clause';
        RefClient: Text;
        RefFournisseur: Text;
        TxtAmountTTC_HT: Text[3];
        TxtGCodeDevise: Text[10];
        CopyText: Text[30];
        SalesPersonText: Text[30];
        TxtGLibDevise: Text[30];
        AppliedToText: Text[40];
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
        ReturnOrderNoText: Text[80];
        VALSpecLCYHeader: Text[80];
        VATNoText: Text[80];
        TxtGOurRef: Text[100];
        DimText: Text[120];
        TxtGMailFax: array[6] of Text[200];
        TexGRefFou: Text[250];


    procedure InitLogInteraction()
    var
        DocumentType: Enum "Interaction Log Entry Document Type";
    begin
        // LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Sales Cr. Memo") <> '';

    end;


    procedure FindPostedShipmentDate(): Date
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        TempSalesShipmentBuffer2: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Cr.Memo Line"."Return Receipt No." <> '' then
            if ReturnReceiptHeader.Get("Sales Cr.Memo Line"."Return Receipt No.") then
                exit(ReturnReceiptHeader."Posting Date");
        if "Sales Cr.Memo Header"."Return Order No." = '' then
            exit("Sales Cr.Memo Header"."Posting Date");

        case "Sales Cr.Memo Line".Type of
            "Sales Cr.Memo Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::"G/L Account", "Sales Cr.Memo Line".Type::Resource,
          "Sales Cr.Memo Line".Type::"Charge (Item)", "Sales Cr.Memo Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Cr.Memo Line");
            "Sales Cr.Memo Line".Type::" ":
                exit(0D);
        end;

        TempSalesShipmentBuffer.Reset();
        TempSalesShipmentBuffer.SetRange("Document No.", "Sales Cr.Memo Line"."Document No.");
        TempSalesShipmentBuffer.SetRange("Line No.", "Sales Cr.Memo Line"."Line No.");

        if TempSalesShipmentBuffer.findFirst() then begin
            TempSalesShipmentBuffer2 := TempSalesShipmentBuffer;
            if TempSalesShipmentBuffer.Next() = 0 then begin
                TempSalesShipmentBuffer.Get(
                  TempSalesShipmentBuffer2."Document No.", TempSalesShipmentBuffer2."Line No.", TempSalesShipmentBuffer2."Entry No.");
                TempSalesShipmentBuffer.Delete();
                exit(TempSalesShipmentBuffer2."Posting Date");
            end;
            TempSalesShipmentBuffer.CalcSums(Quantity);
            if TempSalesShipmentBuffer.Quantity <> "Sales Cr.Memo Line".Quantity then begin
                TempSalesShipmentBuffer.DeleteALL();
                exit("Sales Cr.Memo Header"."Posting Date");
            end;
        end else
            exit("Sales Cr.Memo Header"."Posting Date");
    end;


    procedure GenerateBufferFromValueEntry(SalesCrMemoLine2: Record "Sales Cr.Memo Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := SalesCrMemoLine2."Quantity (Base)";
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesCrMemoLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Cr.Memo Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.findFirst() then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesCrMemoLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesCrMemoLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesCrMemoLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity - ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;


    procedure GenerateBufferFromShipment(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine2: Record "Sales Cr.Memo Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
        Quantity: Decimal;
        TotalQuantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesCrMemoHeader.SetCurrentKey("Return Order No.");
        SalesCrMemoHeader.SetFilter("No.", '..%1', "Sales Cr.Memo Header"."No.");
        SalesCrMemoHeader.SetRange("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        if SalesCrMemoHeader.findFirst() then
            repeat
                SalesCrMemoLine2.SetRange("Document No.", SalesCrMemoHeader."No.");
                SalesCrMemoLine2.SetRange("Line No.", SalesCrMemoLine."Line No.");
                SalesCrMemoLine2.SetRange(Type, SalesCrMemoLine.Type);
                SalesCrMemoLine2.SetRange("No.", SalesCrMemoLine."No.");
                SalesCrMemoLine2.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
                if SalesCrMemoLine2.findFirst() then
                    repeat
                        TotalQuantity := TotalQuantity + SalesCrMemoLine2.Quantity;
                    until SalesCrMemoLine2.Next() = 0;
            until SalesCrMemoHeader.Next() = 0;

        ReturnReceiptLine.SetCurrentKey("Return Order No.", "Return Order Line No.");
        ReturnReceiptLine.SetRange("Return Order No.", "Sales Cr.Memo Header"."Return Order No.");
        ReturnReceiptLine.SetRange("Return Order Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange("Line No.", SalesCrMemoLine."Line No.");
        ReturnReceiptLine.SetRange(Type, SalesCrMemoLine.Type);
        ReturnReceiptLine.SetRange("No.", SalesCrMemoLine."No.");
        ReturnReceiptLine.SetRange("Unit of Measure Code", SalesCrMemoLine."Unit of Measure Code");
        ReturnReceiptLine.SetFilter(Quantity, '<>%1', 0);

        if ReturnReceiptLine.findFirst() then
            repeat
                if "Sales Cr.Memo Header"."Get Return Receipt Used" then
                    CorrectShipment(ReturnReceiptLine);
                if Abs(ReturnReceiptLine.Quantity) <= Abs(TotalQuantity - SalesCrMemoLine.Quantity) then
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity
                else begin
                    if Abs(ReturnReceiptLine.Quantity) > Abs(TotalQuantity) then
                        ReturnReceiptLine.Quantity := TotalQuantity;
                    Quantity :=
                      ReturnReceiptLine.Quantity - (TotalQuantity - SalesCrMemoLine.Quantity);

                    SalesCrMemoLine.Quantity := SalesCrMemoLine.Quantity - Quantity;
                    TotalQuantity := TotalQuantity - ReturnReceiptLine.Quantity;

                    if ReturnReceiptHeader.Get(ReturnReceiptLine."Document No.") then
                        AddBufferEntry(
                          SalesCrMemoLine,
                          -Quantity,
                          ReturnReceiptHeader."Posting Date");
                end;
            until (ReturnReceiptLine.Next() = 0) or (TotalQuantity = 0);
    end;


    procedure CorrectShipment(var ReturnReceiptLine: Record "Return Receipt Line")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.SetCurrentKey("Return Receipt No.", "Return Receipt Line No.");
        SalesCrMemoLine.SetRange("Return Receipt No.", ReturnReceiptLine."Document No.");
        SalesCrMemoLine.SetRange("Return Receipt Line No.", ReturnReceiptLine."Line No.");
        if SalesCrMemoLine.findFirst() then
            repeat
                ReturnReceiptLine.Quantity := ReturnReceiptLine.Quantity - SalesCrMemoLine.Quantity;
            until SalesCrMemoLine.Next() = 0;
    end;


    procedure AddBufferEntry(SalesCrMemoLine: Record "Sales Cr.Memo Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        TempSalesShipmentBuffer.SetRange("Document No.", SalesCrMemoLine."Document No.");
        TempSalesShipmentBuffer.SetRange("Line No.", SalesCrMemoLine."Line No.");
        TempSalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if TempSalesShipmentBuffer.findFirst() then begin
            TempSalesShipmentBuffer.Quantity := TempSalesShipmentBuffer.Quantity - QtyOnShipment;
            TempSalesShipmentBuffer.Modify();
            exit;
        end;

        with TempSalesShipmentBuffer do begin
            Init();
            "Document No." := SalesCrMemoLine."Document No.";
            "Line No." := SalesCrMemoLine."Line No.";
            "Entry No." := NextEntryNo;
            Type := SalesCrMemoLine.Type;
            "No." := SalesCrMemoLine."No.";
            Quantity := -QtyOnShipment;
            "Posting Date" := PostingDate;
            Insert();
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        if "Sales Cr.Memo Header"."Prepayment Credit Memo" then
            exit(Text011);
        exit(Text005);
    end;


    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;
}

