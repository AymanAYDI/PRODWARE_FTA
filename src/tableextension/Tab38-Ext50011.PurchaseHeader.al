namespace Prodware.FTA;

using Microsoft.Purchases.Document;
using Microsoft.Foundation.Shipping;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Document;
using Microsoft.CRM.Contact;
tableextension 50011 PurchaseHeader extends "Purchase Header" //38
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                if RecGContact.GET("Buy-from Contact No.") then begin
                    "E-Mail" := RecGContact."E-Mail";
                    "Fax No." := RecGContact."Fax No.";
                    "Subject Mail" := '';
                end
                else begin
                    "E-Mail" := '';
                    "Fax No." := '';
                    "Subject Mail" := '';
                end;
            end;
        }
        modify("Buy-from Contact No.")
        {
            trigger OnAfterValidate()
            begin
                if RecGContact.GET("Buy-from Contact No.") then begin
                    "E-Mail" := RecGContact."E-Mail";
                    "Fax No." := RecGContact."Fax No.";
                    "Subject Mail" := '';
                end
                else begin
                    "E-Mail" := '';
                    "Fax No." := '';
                    "Subject Mail" := '';
                end;
            end;
        }
        modify("Requested Receipt Date")
        {
            trigger OnBeforeValidate()
            var
                "**FTA1.00": Integer;
                RecLPurchLine: Record "Purchase Line";
                CstL001: label 'This change can delete the reservation of the lines : do want to continue?';
                CstL002: label 'Canceled operation';
            begin
                RecLPurchLine.SETRANGE("Document Type", "Document Type");
                RecLPurchLine.SETRANGE("Document No.", "No.");
                RecLPurchLine.SETFILTER("Expected Receipt Date", '<%1', "Requested Receipt Date");
                RecLPurchLine.SETRANGE(Type, RecLPurchLine.Type::Item);

                if not RecLPurchLine.ISEMPTY() then begin
                    RecLPurchLine.FINDSET();
                    repeat
                        RecLPurchLine.CALCFIELDS("Reserved Qty. (Base)");
                        if RecLPurchLine."Reserved Qty. (Base)" <> 0 then
                            if not CONFIRM(CstL001, false) then
                                ERROR(CstL002);
                    until (RecLPurchLine.NEXT() = 0) or (RecLPurchLine."Reserved Qty. (Base)" <> 0);
                end;
            end;

            trigger OnAfterValidate()
            begin
                if "Promised Receipt Date" <> 0D then
                    "Planned Receipt Date" := CALCDATE("Lead Time Calculation", "Promised Receipt Date")
                else
                    if "Requested Receipt Date" <> 0D then
                        "Planned Receipt Date" := CALCDATE("Lead Time Calculation", "Requested Receipt Date");
            end;
        }
        modify("Lead Time Calculation")
        {
            trigger OnAfterValidate()
            begin
                if "Promised Receipt Date" <> 0D then
                    "Planned Receipt Date" := CALCDATE("Lead Time Calculation", "Promised Receipt Date")
                else
                    if "Requested Receipt Date" <> 0D then
                        "Planned Receipt Date" := CALCDATE("Lead Time Calculation", "Requested Receipt Date");
            end;
        }
        field(50005; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(50006; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(50007; "Subject Mail"; Text[50])
        {
            Caption = 'Sujet Mail';
        }
        field(50030; "Confirmed AR Order"; Boolean)
        {
            Caption = 'Commande AR confirmée';
        }
        field(51011; "Shipping Agent Name"; Text[50])
        {
            Caption = 'Shipping Agent Name';
        }
        field(51012; "Shipping Order No."; Code[20])
        {
            Caption = 'Shipping Order No.';
            Editable = false;
        }
        field(51023; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            var
                RecLPurchHeader: Record "Purchase Header";
                TextCdeTransp003: Label 'You cannot modify Shipping Code agent because there is a Shipping Purchase Order linked (Order %1) !!';
            begin
                TESTFIELD(Status, Status::Open);
                if xRec."Shipping Agent Code" = "Shipping Agent Code" then
                    exit;
                if "Shipping Order No." <> '' then
                    error(StrSubstNo(TextCdeTransp003, "Shipping Order No."));
                if (xRec."Shipping Agent Code" <> '') and ("Shipping Agent Code" = '') then
                    RecLPurchHeader.TestVerifExistence("No.");

                if ShippingAgent.Get("Shipping Agent Code") then
                    "Shipping Agent Name" := ShippingAgent.Name
                else
                    "Shipping Agent Name" := '';

            end;
        }
        field(51025; "Planned Receipt Date"; Date)
        {
            Caption = 'Planned Receipt Date';
        }
        field(51028; "Order Type"; enum "Order Type")
        {
            CalcFormula = lookup(Vendor."Vendor Type" where("No." = field("Buy-from Vendor No.")));
            Caption = 'Order Type';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51029; "Initial Order No."; Code[20])
        {
            Caption = 'Initial Order No.';
        }
        field(51030; "Nb Total Pallets"; Decimal)
        {
            Caption = 'Nbre Palettes totales';
        }
        field(51031; "Initial Order Type"; enum "Initial Order Type")
        {
            Caption = 'Initial Order Type';
        }
    }
    keys
    {
        key(Key50000; "No.")
        {
        }
        key(Key50001; "Shipping Agent Code")
        {
        }
    }
    trigger OnBeforeDelete()
    var
        "--NAVEASY.001--": Integer;
        RecLSalesHeader: Record "Sales Header";
        RecLPurchHeader: Record "Purchase Header";
        TextCdeTransp002: Label 'There is a Shipping Purchase order linked (Order %1), do you want to delete this order?';
    begin
        PurchLine.SetRange("Document Type", "Document Type");
        PurchLine.SetRange("Document No.", "No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        if not PurchLine.IsEmpty then
            PurchLine.FindSet();
        repeat
            PurchLine.CALCFIELDS("Reserved Quantity");
            PurchLine.TESTFIELD("Reserved Quantity", 0);
        until PurchLine.NEXT() = 0;
    end;

    trigger OnAfterDelete()
    begin
        CALCFIELDS("Order Type");
        if "Order Type" = "Order Type"::Transport then
            if "Initial Order No." <> '' then
                case "Initial Order Type" of
                    "Initial Order Type"::Sale:
                        if RecLSalesHeader.Get(RecLSalesHeader."Document Type"::Order, "Initial Order No.") then begin
                            RecLSalesHeader.Validate("Shipping Order No.", '');
                            RecLSalesHeader.MODIFY();
                        end;
                    "Initial Order Type"::Purchase:
                        if RecLPurchHeader.Get(RecLSalesHeader."Document Type"::Order, "Initial Order No.") then begin
                            RecLPurchHeader.Validate("Shipping Order No.", '');
                            RecLPurchHeader.MODIFY();
                        end;
                end;
        if "Order Type" <> "Order Type"::Transport then
            if "Shipping Order No." <> '' then
                if CONFIRM(StrSubstNo(TextCdeTransp002, "Shipping Order No.")) then
                    if RecLPurchHeader.Get(RecLPurchHeader."Document Type"::Order, "Shipping Order No.") then RecLPurchHeader.Delete(true);
    end;

    procedure CreatePurchaseTransport(CodLNumVendor: Code[20]; CodLInitialOrder: Code[20]; DecLPrice: Decimal; CodLCurrency: Code[10]; DateLRequested: Date; DateLPromised: Date; DateLPlanned: Date; OptLTypeInitialOrder: Option " ",Sale,Purchase) CodLTransportOrder: Code[20]
    var
        RecLPurchHead: Record "Purchase Header";
        CuLReleasePurchaseDoc: codeunit "Release Purchase Document";
    begin
        TestVerifExistence(CodLInitialOrder);
        PurchSetup.Get();
        PurchSetup.TESTFIELD("Charge (Item) used for Transp.");
        CodLTransportOrder := CreatePurchHeadTransport(CodLNumVendor, CodLInitialOrder, CodLCurrency, OptLTypeInitialOrder);
        CreatePurchLineTransport(CodLTransportOrder, CodLNumVendor, DecLPrice, DateLRequested, DateLPromised, DateLPlanned);
        if RecLPurchHead.Get(RecLPurchHead."Document Type"::Order, CodLTransportOrder) then
            CuLReleasePurchaseDoc.Run(RecLPurchHead);

        exit(CodLTransportOrder);
    end;

    procedure TestVerifExistence(CodLInitialOrder: Code[20])
    var
        RecLPurchHead: Record "Purchase Header";
        TextCdeTransp001: Label 'There is a Transport Purchase order linked to this document.\ Impossible to modify or to create another Transport Purchase order !!';
    begin
        RecLPurchHead.Reset();
        RecLPurchHead.SetRange(RecLPurchHead."Document Type", RecLPurchHead."Document Type"::Order);
        RecLPurchHead.SetRange("Initial Order No.", CodLInitialOrder);
        if RecLPurchHead.FindFirst() then Error(TextCdeTransp001);
    end;

    procedure CreatePurchHeadTransport(CodLNumVendor: Code[20]; CodLInitialOrder: Code[20]; CodLCurrency: Code[10]; OptLTypeInitialOrder: Enum "Initial Order Type"): Code[20]
    var
        RecLPurchHead: Record "Purchase Header";
    begin
        RecLPurchHead.Init();
        RecLPurchHead."Document Type" := RecLPurchHead."Document Type"::Order;
        RecLPurchHead.Validate("Buy-from Vendor No.", CodLNumVendor);
        RecLPurchHead.Validate("Initial Order No.", CodLInitialOrder);
        RecLPurchHead.Validate("Posting Date", WORKDATE());
        RecLPurchHead.Validate("Currency Code", CodLCurrency);
        RecLPurchHead."Initial Order Type" := OptLTypeInitialOrder;

        RecLPurchHead.Insert(true);
        exit(RecLPurchHead."No.");
    end;

    procedure CreatePurchLineTransport(CodLNumOrder: Code[20]; CodLNumVendor: Code[20]; DecLPrice: Decimal; DateLRequested: Date; DateLPromised: Date; DateLPlanned: Date)
    var
        RecLPurchLine: Record "Purchase Line";
    begin
        RecLPurchLine.Init();
        RecLPurchLine."Document Type" := RecLPurchLine."Document Type"::Order;
        RecLPurchLine.Validate("Document No.", CodLNumOrder);
        RecLPurchLine.Validate("Line No.", 10000);
        RecLPurchLine.Validate("Buy-from Vendor No.", CodLNumVendor);
        RecLPurchLine.Validate(Type, RecLPurchLine.Type::"Charge (Item)");
        RecLPurchLine.Validate("No.", PurchSetup."Charge (Item) used for Transp.");
        RecLPurchLine.Validate(Quantity, 1);
        RecLPurchLine.Validate("Direct Unit Cost", DecLPrice);
        RecLPurchLine.Validate("Requested Receipt Date", DateLRequested);
        RecLPurchLine.Validate("Promised Receipt Date", DateLPromised);
        RecLPurchLine.Validate("Planned Receipt Date", DateLPlanned);
        RecLPurchLine.Insert(true);
    end;

    var
        RecLSalesHeader: Record "Sales Header";
        RecLPurchHeader: Record "Purchase Header";
        TextCdeTransp002: Label 'There is a Shipping Purchase order linked (Order %1), do you want to delete this order?';
        ShippingAgent: Record "Shipping Agent";
        RecGContact: Record Contact;
}

