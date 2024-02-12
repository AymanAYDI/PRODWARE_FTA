namespace Prodware.FTA;

using Microsoft.Sales.History;
using System.Utilities;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Team;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Setup;
using Microsoft.Finance.Dimension;
using System.Globalization;
using Microsoft.Inventory.Tracking;
using Microsoft.Assembly.History;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Reports;
using Microsoft.CRM.Segment;
using Microsoft.Foundation.Address;
using Microsoft.CRM.Contact;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Shipping;
using System.Security.User;
using Microsoft.Foundation.UOM;
using Microsoft.CRM.Interaction;
report 51023 "Sales - Shipment FTA By Parcel"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/SalesShipmentFTAByParcel.rdl';

    Caption = 'Sales - Shipment FTA By Parcel';

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Shipment';
            column(No_SalesShptHeader; "No.")
            {
            }
            column(PageCaption; PageCaptionCap)
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
            column(LblInvoicingAddress; LblInvoicingAddress)
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
            column(LblDocumentDate; LblDocumentDate)
            {
            }
            column(LblSellToCustomer; LblSellToCustomer)
            {
            }
            column(LblYourReference; LblYourReference)
            {
            }
            column(LblYourOrderN; LblYourOrderN)
            {
            }
            column(LblOurReferences; LblOurReferences)
            {
            }
            column(LblSalesperson; LblSalesperson)
            {
            }
            column(LblContact; LblContact)
            {
            }
            column(BooGValued; BooGValued)
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
            column(LblShiptoAddress; LblShiptoAddress)
            {
            }
            column(TxtGInvoiceText; TxtGInvoiceText)
            {
            }
            column(LblParcelNo; LblParcelNo)
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
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(SalesShptCopyText; StrSubstNo(Text002, CopyText))
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfoVATRegtnNo; CompanyInfo."VAT Registration No.")
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
                    column(SelltoCustNo_SalesShptHeader; "Sales Shipment Header"."Sell-to Customer No.")
                    {
                    }
                    column(DocDate_SalesShptHeader; Format("Sales Shipment Header"."Document Date", 0, 4))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_SalesShptHeader; "Sales Shipment Header"."Your Reference")
                    {
                    }
                    column(OrderNo_SalesShptHeader; "Sales Shipment Header"."Order No.")
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(ShptDate_SalesShptHeader; Format("Sales Shipment Header"."Shipment Date"))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ItemTrackingAppendixCaption; ItemTrackingAppendixCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    column(SelltoCustNo_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    column(CompanyInfo__SWIFT_Code_; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                    {
                    }
                    column(SalesShipmentHeader_VATRegistrationNo; "Sales Shipment Header"."VAT Registration No.")
                    {
                    }
                    column(TxtGOurReferences; TxtGOurReferences)
                    {
                    }
                    column(SalesShipmentHeader_ExternalDocumentNo; "Sales Shipment Header"."External Document No.")
                    {
                    }
                    column(SalesShipmentHeader_PostingDate; "Sales Shipment Header"."Posting Date")
                    {
                    }
                    column(RecGCustomer_PhoneNo; RecGCustomer."Phone No.")
                    {
                    }
                    column(RecGCustomer_FaxNo; RecGCustomer."Fax No.")
                    {
                    }
                    column(RecGContact_Name; RecGContact.Name)
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
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
                    column(LblTxtHeader; LblTxtHeader)
                    {
                    }
                    column(TotalWeight_SalesShptHeader; "Sales Shipment Header"."Total weight")
                    {
                    }
                    column(TotalWeight_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Total weight"))
                    {
                    }
                    column(TotalParcels_SalesShptHeader; "Sales Shipment Header"."Total Parcels")
                    {
                    }
                    column(TotalParcels_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Total Parcels"))
                    {
                    }
                    column(ShippingAgent_SalesShptHeader; RecGShippingAgent.Name)
                    {
                    }
                    column(ShippingAgent_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Shipping Agent Code"))
                    {
                    }
                    column(TransportMethode_SalesShptHeader; "Sales Shipment Header"."Transport Method")
                    {
                    }
                    column(TransportMethode_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Transport Method"))
                    {
                    }
                    column(LblSignTransp; LblSignTransp)
                    {
                    }
                    column(LblSignClt; LblSignClt)
                    {
                    }
                    column(LblUnitCaption; LblUnit)
                    {
                    }
                    column(LblRefInt; LblRefInt)
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
                    column(LblRefFouNo; LblRefFouNo)
                    {
                    }
                    column(LblRefCliNo; LblRefCliNo)
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
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting(Number)
                                            where(Number = filter(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var

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
                                    DimText := StrSubstNo(Text022, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        Text023, DimText,
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
                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting("Document No.", "Line No.");
                        column(Description_SalesShptLine; Description)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(ShowCorrectionLines; ShowCorrectionLines)
                        {
                        }
                        column(Type_SalesShptLine; Format(Type, 0, 2))
                        {
                        }
                        column(AsmHeaderExists; AsmHeaderExists)
                        {
                        }
                        column(DocumentNo_SalesShptLine; "Document No.")
                        {
                        }
                        column(LinNo; LinNo)
                        {
                        }
                        column(Qty_SalesShptLine; Quantity)
                        {
                        }
                        column(UOM_SalesShptLine; "Unit of Measure")
                        {
                        }
                        column(No_SalesShptLine; "No.")
                        {
                        }
                        column(LineNo_SalesShptLine; "Line No.")
                        {
                        }
                        column(Description_SalesShptLineCaption; FieldCaption(Description))
                        {
                        }
                        column(Qty_SalesShptLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesShptLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(No_SalesShptLineCaption; FieldCaption("No."))
                        {
                        }
                        column(SalesShptLine_UnitPrice; "Unit Price" * (1 - "Line Discount %" / 100))
                        {
                            AutoFormatExpression = "Sales Shipment Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(UnitPrice_Caption; FieldCaption("Unit Price"))
                        {
                        }
                        column(LblPrice; LblPrice)
                        {
                        }
                        column(AmtCaption; AmtCaptionLbl)
                        {
                        }
                        column(QtyOrdered_SalesShptLine; "Qty. Ordered")
                        {
                        }
                        column(QtyOrdered_SalesShptLineCaption; LblQtyOrder)
                        {
                        }
                        column(AmtLineSalesShptLine; DecGAmtLine)
                        {
                        }
                        column(SalesLineDescription2; "Sales Shipment Line"."Description 2")
                        {
                        }
                        column(RecGItemNo2; TexGRefFou)
                        {
                        }
                        column(ItemNo2; RecGItem."No. 2")
                        {
                        }
                        column(RefClient; RefClient)
                        {
                        }
                        column(RefFournisseur; RefFournisseur)
                        {
                        }
                        column(No2_SalesLine; "Sales Shipment Line"."No.")
                        {
                        }
                        column(SalesLineDescription; SalesLineDescription)
                        {
                        }
                        column(ParcelNo; "Sales Shipment Line"."Parcel No.")
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = filter(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
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
                                        DimText := StrSubstNo(Text020, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            Text021, DimText,
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
                            end;
                        }
                        dataitem(DisplayAsmInfo; Integer)
                        {
                            DataItemTableView = sorting(Number);
                            column(PostedAsmLineItemNo; BlanksForIndent() + PostedAsmLine."No.")
                            {
                            }
                            column(PostedAsmLineDescription; BlanksForIndent() + PostedAsmLine.Description)
                            {
                            }
                            column(PostedAsmLineQuantity; PostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(PostedAsmLineUOMCode; GetUnitOfMeasureDescr(PostedAsmLine."Unit of Measure Code"))
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    PostedAsmLine.FindSet()
                                else
                                    PostedAsmLine.Next();
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not DisplayAssemblyInFormation then
                                    CurrReport.Break();
                                if not AsmHeaderExists then
                                    CurrReport.Break();

                                PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                                SetRange(Number, 1, PostedAsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            RecLItemCrossReference: Record "Item Reference";
                        begin
                            LinNo := "Line No.";
                            if not ShowCorrectionLines and Correction then
                                CurrReport.Skip();

                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");
                            if DisplayAssemblyInFormation then
                                AsmHeaderExists := AsmToShipmentExists(PostedAsmHeader);

                            DecGAmtLine := Quantity * "Unit Price" * (1 - ("Line Discount %" / 100));
                            SalesLineDescription := "Sales Shipment Line"."Description 2";

                            if "Sales Shipment Line".Type <> "Sales Shipment Line".Type::Item then
                                SalesLineDescription := "Sales Shipment Line".Description;


                            if (Type = Type::Item) and ("No." <> '') then begin
                                TexGRefFou := '';
                                RecGItem.Get("No.");
                                RecLItemCrossReference.Reset();
                                RecLItemCrossReference.SetRange("Item No.", "No.");
                                RecLItemCrossReference.SetRange("Unit of Measure", "Unit of Measure Code");
                                RecLItemCrossReference.SetRange("Reference Type", RecLItemCrossReference."Reference Type"::Customer);
                                RecLItemCrossReference.SetRange("Reference Type No.", "Sales Shipment Header"."Bill-to Customer No.");
                                if RecLItemCrossReference.FindSet() then
                                    TexGRefFou := StrSubstNo(CstG002, RecLItemCrossReference."Reference No.") + ' - ';
                                TexGRefFou += RecGItem."No. 2";
                                SalesLineDescription := RecGItem.Description;
                            end else begin
                                RecGItem.Init();
                                TexGRefFou := '';
                            end;
                            RefClient := '-';
                            if (Type = Type::Item) and ("No." <> '') then begin

                                RecLItemCrossReference.Reset();
                                RecLItemCrossReference.SetRange("Item No.", "Sales Shipment Line"."No.");
                                RecLItemCrossReference.SetRange("Unit of Measure", "Sales Shipment Line"."Unit of Measure Code");
                                RecLItemCrossReference.SetRange("Reference Type", RecLItemCrossReference."Reference Type"::Customer);
                                RecLItemCrossReference.SetRange("Reference Type No.", "Sales Shipment Header"."Bill-to Customer No.");
                                if RecLItemCrossReference.findFirst() then RefClient := RecLItemCrossReference."Reference No.";
                            end;

                            RefFournisseur := RecGItem."No. 2";
                        end;

                        trigger OnPostDataItem()
                        begin
                            if ShowLotSN then begin
                                ItemTrackingDocMgt.SetRetrieveAsmItemTracking(true);
                                TrackingSpecCount := ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer, "Sales Shipment Header"."No.",
                                    DATABASE::"Sales Shipment Header", 0);
                                ItemTrackingDocMgt.SetRetrieveAsmItemTracking(false);
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := Findlast();
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");
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
                        column(BilltoCustNo_SalesShptHeader; "Sales Shipment Header"."Bill-to Customer No.")
                        {
                        }
                        column(BilltoAddressCaption; BilltoAddressCaptionLbl)
                        {
                        }
                        column(BilltoCustNo_SalesShptHeaderCaption; "Sales Shipment Header".FieldCaption("Bill-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin

                        end;
                    }
                    dataitem(ItemTrackingLine; Integer)
                    {
                        DataItemTableView = sorting(Number);
                        column(TrackingSpecBufferNo; TrackingSpecBuffer."Item No.")
                        {
                        }
                        column(TrackingSpecBufferDesc; TrackingSpecBuffer.Description)
                        {
                        }
                        column(TrackingSpecBufferLotNo; TrackingSpecBuffer."Lot No.")
                        {
                        }
                        column(TrackingSpecBufferSerNo; TrackingSpecBuffer."Serial No.")
                        {
                        }
                        column(TrackingSpecBufferQty; TrackingSpecBuffer."Quantity (Base)")
                        {
                        }
                        column(ShowTotal; ShowTotal)
                        {
                        }
                        column(ShowGroup; ShowGroup)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(SerialNoCaption; SerialNoCaptionLbl)
                        {
                        }
                        column(LotNoCaption; LotNoCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(NoCaption; NoCaptionLbl)
                        {
                        }
                        dataitem(TotalItemTracking; Integer)
                        {
                            DataItemTableView = sorting(Number)
                                                where(Number = const(1));
                            column(Quantity1; TotalQty)
                            {
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                TrackingSpecBuffer.FindSet()
                            else
                                TrackingSpecBuffer.Next();

                            ShowTotal := false;
                            if ItemTrackingAppendix.IsStartNewGroup(TrackingSpecBuffer) then
                                ShowTotal := true;

                            ShowGroup := false;
                            if (TrackingSpecBuffer."Source Ref. No." <> OldRefNo) or
                               (TrackingSpecBuffer."Item No." <> OldNo)
                            then begin
                                OldRefNo := TrackingSpecBuffer."Source Ref. No.";
                                OldNo := TrackingSpecBuffer."Item No.";
                                TotalQty := 0;
                            end else
                                ShowGroup := true;
                            TotalQty += TrackingSpecBuffer."Quantity (Base)";
                        end;

                        trigger OnPreDataItem()
                        begin
                            if TrackingSpecCount = 0 then
                                CurrReport.Break();
                            CurrReport.NEWPAGE();
                            SetRange(Number, 1, TrackingSpecCount);
                            TrackingSpecBuffer.SetCurrentKey("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
                              "Source Prod. Order Line", "Source Ref. No.");
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        if ShowLotSN then begin
                            TrackingSpecCount := 0;
                            OldRefNo := 0;
                            ShowGroup := false;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text001;
                        OutputNo += 1;
                    end;
                    CurrReport.PAGENO := 1;
                    TotalQty := 0;           // Item Tracking
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.PREVIEW then
                        ShptCountPrinted.Run("Sales Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.LANGUAGE := Language.GetLanguageIdOrDefault("Language Code");

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
                FormatAddr.SalesShptBillTo(CustAddr, ShipToAddr, "Sales Shipment Header");

                FormatAddr.SalesShptShipTo(CustAddr, "Sales Shipment Header");
                if LogInteraction then
                    if not CurrReport.PREVIEW then
                        SegManagement.LogDocument(
                          5, "No.", 0, 0, DATABASE::Customer, "Sell-to Customer No.", "Salesperson Code",
                          "Campaign No.", "Posting Description", '');

                TxtGOurReferences := "Sell-to Customer No.";
                if "Sell-to Customer No." <> "Bill-to Customer No." then
                    TxtGOurReferences := TxtGOurReferences + ' / ' + "Bill-to Customer No.";

                if not RecGCustomer.Get("Sell-to Customer No.") then
                    Clear(RecGCustomer);

                //Read Contact
                if not RecGContact.Get("Sell-to Contact No.") then
                    Clear(RecGContact);

                if not RecGShippingAgent.Get("Shipping Agent Code") then
                    RecGShippingAgent.Init();

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
                    field("Show Correction Lines"; ShowCorrectionLines)
                    {
                        Caption = 'Show Correction Lines';
                    }
                    field(ShowLotSN; ShowLotSN)
                    {
                        Caption = 'Show Serial/Lot Number Appendix';
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInFormation)
                    {
                        Caption = 'Show Assembly Components';
                    }
                    field(Valued; BooGValued)
                    {
                        Caption = 'Valued';
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
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
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

        if RecGUserReport.Get(UserId, 51021) then
            if RecGUserReport.Email then begin
                CompanyInfo3.Get();
                CompanyInfo3.CalcFields(Picture);
            end;
        Clear(TxtGInvoiceText);
        if SalesSetup."Print Shipment Text" then
            TxtGInvoiceText := SalesSetup."Shipment Text";
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
        AsmHeaderExists := false;
    end;

    var
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company InFormation";
        CompanyInfo1: Record "Company InFormation";
        CompanyInfo2: Record "Company InFormation";
        CompanyInfo3: Record "Company InFormation";
        SalesSetup: Record "Sales & Receivables Setup";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        Language: Codeunit Language;
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        RespCenter: Record "Responsibility Center";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        ShptCountPrinted: Codeunit "Sales Shpt.-Printed";
        SegManagement: Codeunit SegManagement;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        Text000: Label 'Salesperson';
        Text001: Label 'Copy';
        Text002: Label 'Product List';
        ShowCustAddr: Boolean;
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInFormation: Boolean;
        AsmHeaderExists: Boolean;
        LinNo: Integer;
        ItemTrackingAppendixCaptionLbl: Label 'Item Tracking - Appendix';
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        ShipmentNoCaptionLbl: Label 'Shipment No.';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        DocumentDateCaptionLbl: Label 'Document Date';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        BilltoAddressCaptionLbl: Label 'Bill-to Address';
        QuantityCaptionLbl: Label 'Quantity';
        SerialNoCaptionLbl: Label 'Serial No.';
        LotNoCaptionLbl: Label 'Lot No.';
        DescriptionCaptionLbl: Label 'Description';
        NoCaptionLbl: Label 'No.';
        PageCaptionCap: Label 'Page %1 of %2';
        LblBIC: Label 'SWIFT :';
        LblIBAN: Label 'IBAN :';
        LblVATRegistrationNo: Label 'VAT Registration No. :';
        LblAPE: Label 'APE Code :';
        LblVAT: Label 'VAT N° : ';
        LblInvoicingAddress: Label 'Invoicing address';
        LblPAGE: Label 'Page';
        LblPhoneNo: Label 'Phone No.';
        LblFaxNo: Label 'Fax No.';
        LblSellToCustomer: Label 'Sell-to Customer';
        LblDocumentDate: Label 'Document date';
        LblYourOrderN: Label 'Order N°';
        LblYourReference: Label 'Your Reference';
        LblOurReferences: Label 'Your customer No.';
        LblSalesperson: Label 'Salesperson';
        LblContact: Label 'Contact';
        TxtGOurReferences: Text;
        RecGCustomer: Record Customer;
        RecGContact: Record Contact;
        BooGValued: Boolean;
        LblPrice: Label 'Unit Price';
        LblUnitOfMeasure: Label 'Unit of Measure';
        LblQuantity: Label 'Qty';
        LblDescription: Label 'Description';
        LblNo: Label 'No.';
        LblShiptoAddress: Label 'Ship-to Address';
        LblTxtHeader: Label 'Reserve of Property : the goods shipped remain our property untill fully paid. They are shipped at consignee''s risks. Deposits may be kept to cover eventual losses.';
        LblSignTransp: Label 'Visa of the Carrier :';
        LblSignClt: Label 'Validation and date of the Customer';
        LblUnit: Label 'Kg';
        TxtGInvoiceText: Text;
        AmtCaptionLbl: Label 'Amount';
        LblQtyOrder: Label 'Ordered Qty';
        DecGAmtLine: Decimal;
        LblRefInt: Label 'No.';
        RecGItem: Record Item;
        TexGRefFou: Text[250];
        CstG002: Label 'Réf. ext : %1', Comment = '%1="Reference No."';
        RecGShippingAgent: Record "Shipping Agent";
        RecGUserReport: Record "Report Email By User";
        BooGPrintLogo: Boolean;
        BoolGPrintFax: Boolean;
        RecGUserSetup: Record "User Setup";
        TxtGMailFax: array[6] of Text[200];
        RefClient: Text;
        RefFournisseur: Text;
        LblRefFouNo: Label 'Code fournisseur';
        LblRefCliNo: Label 'Code client';
        SalesLineDescription: Text[50];
        LblParcelNo: Label 'Parcel No.';
        Text020: Label '%1 %2', Comment = '%1 = DimSetEntry2."Dimension Code", 2% = DimSetEntry2."Dimension Value Code';
        Text021: Label '%1 %2  %3', Comment = '%1=DimText,2% = DimSetEntry2."Dimension Code", 3% = DimSetEntry2."Dimension Value Code"';
        Text022: Label '%1 %2', Comment = '%1 = DimSetEntry1."Dimension Code", 2% = DimSetEntry1."Dimension Value Code';
        Text023: Label '%1 %2  %3', Comment = '%1=DimText,2% = DimSetEntry1."Dimension Code", 3% = DimSetEntry1."Dimension Value Code"';

    procedure InitLogInteraction()
    var
        DocumentType: Enum "Interaction Log Entry Document Type";
    begin
        // LogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode(DocumentType::"Sales Shpt. Note") <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean; NewShowLotSN: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
        ShowLotSN := NewShowLotSN;
        DisplayAssemblyInFormation := DisplayAsmInfo;
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

