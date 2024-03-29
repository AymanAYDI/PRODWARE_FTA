namespace Prodware.FTA;

using Microsoft.Purchases.Document;
using Microsoft.Utilities;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Inventory.Item;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Purchases.Pricing;
tableextension 50061 PurchaseLine extends "Purchase Line" //39
{
    fields
    {
        modify("No.")
        {
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account"),
                                     "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true),
                                                                                          "Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if (Type = const("G/L Account"),
                                                                                                   "System-Created Entry" = const(true)) "G/L Account"
            else
            if (Type = const(Item)) Item where("Quote Associated" = filter(false))
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge";
        }
        modify("Promised Receipt Date")
        {
            trigger OnAfterValidate()
            begin
                SetArOrderConfirmed();
            end;
        }
        field(50000; "Date from Req. Delivery Date"; Boolean)
        {
            Caption = 'Date from Req. Delivery Date';
        }
        field(51000; "Initial Order No."; Code[20])
        {
            Caption = 'Initial Order No.';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order),
                                                         "Order Type" = filter(<> Transport),
                                                         "Shipping Order No." = filter(''));

            trigger OnValidate()
            var
                RecLPurchHeader: Record "Purchase Header";
                RecLPurchHeader2: Record "Purchase Header";
                RecLPurchHeader3: Record "Purchase Header";
                CuLReleasePurchDoc: codeunit "Release Purchase Document";
                BooLARefermer: Boolean;
                TextCdeTransp001: Label 'You cannot select a Purchase Order because Order is already linked to %1 Order No. %2.';
                BooLARefermer2: Boolean;
            begin
                TestStatusOpen();
                if RecLPurchHeader2.Get("Document Type", "Document No.") then
                    if (RecLPurchHeader2."Initial Order No." <> '') and
                       (RecLPurchHeader2."Initial Order Type" <> RecLPurchHeader2."Initial Order Type"::" ") then
                        Error(StrSubstNo(TextCdeTransp001, RecLPurchHeader2."Initial Order Type", RecLPurchHeader2."Initial Order No."));
                TestField("Qty. Rcd. Not Invoiced", 0);
                TestField("Quantity Received", 0);
                TestField("Receipt No.", '');

                TestField("Return Qty. Shipped Not Invd.", 0);
                TestField("Return Qty. Shipped", 0);
                TestField("Return Shipment No.", '');
                BooLARefermer := false;
                BooLARefermer2 := false;

                if RecLPurchHeader.Get(RecLPurchHeader."Document Type"::Order, "Initial Order No.") then begin
                    if RecLPurchHeader.Status = RecLPurchHeader.Status::Released then begin
                        CuLReleasePurchDoc.Reopen(RecLPurchHeader);
                        BooLARefermer := true;
                    end;
                    RecLPurchHeader.Validate("Shipping Agent Code", "Buy-from Vendor No.");
                    RecLPurchHeader.Validate("Shipping Order No.", "Document No.");
                    RecLPurchHeader.Modify();
                    if (xRec."Initial Order No." <> '') then begin
                        if RecLPurchHeader3.Get(RecLPurchHeader3."Document Type"::Order, xRec."Initial Order No.") then begin
                            if RecLPurchHeader3.Status = RecLPurchHeader3.Status::Released then begin
                                CuLReleasePurchDoc.Reopen(RecLPurchHeader3);
                                BooLARefermer2 := true;
                            end;
                            RecLPurchHeader3."Shipping Agent Code" := '';
                            RecLPurchHeader3."Shipping Agent Name" := '';
                            RecLPurchHeader3."Shipping Order No." := '';

                            RecLPurchHeader3.Modify();
                        end;
                    end;
                end
                else
                    if (xRec."Initial Order No." <> '') and ("Initial Order No." = '') then begin
                        if RecLPurchHeader.Get(RecLPurchHeader."Document Type"::Order, xRec."Initial Order No.") then begin
                            if RecLPurchHeader.Status = RecLPurchHeader.Status::Released then begin
                                CuLReleasePurchDoc.Reopen(RecLPurchHeader);
                                BooLARefermer := true;
                            end;
                            RecLPurchHeader."Shipping Agent Code" := '';
                            RecLPurchHeader."Shipping Agent Name" := '';
                            RecLPurchHeader."Shipping Order No." := '';

                            RecLPurchHeader.Modify();
                        end;
                    end;
                if BooLARefermer then
                    CuLReleasePurchDoc.Run(RecLPurchHeader);
                if BooLARefermer2 then
                    CuLReleasePurchDoc.Run(RecLPurchHeader3);
            end;
        }
    }
    keys
    {
        key(Key50000; "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date", "Promised Receipt Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)";
        }
    }
    local procedure SetArOrderConfirmed()
    var
        RecLPurchaseLine: Record "Purchase Line";
        RecLPurchaseHeader: Record "Purchase Header";
    begin
        if ("Promised Receipt Date" <> xRec."Promised Receipt Date") and (Rec."Promised Receipt Date" <> 0D) then begin
            RecLPurchaseHeader.Get("Document Type", "Document No.");

            RecLPurchaseLine.Reset();
            RecLPurchaseLine.SetRange("Document Type", "Document Type");
            RecLPurchaseLine.SetRange("Document No.", "Document No.");
            RecLPurchaseLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
            RecLPurchaseLine.SetRange("Promised Receipt Date", 0D);
            RecLPurchaseLine.SetFilter(Quantity, '<>%1', 0);
            if not RecLPurchaseLine.IsEmpty then
                RecLPurchaseHeader."Confirmed AR Order" := false
            else
                RecLPurchaseHeader."Confirmed AR Order" := true;
            RecLPurchaseHeader.Modify(false);
        end else begin
            RecLPurchaseHeader.Get("Document Type", "Document No.");
            RecLPurchaseHeader."Confirmed AR Order" := false;
            RecLPurchaseHeader.Modify(false);
        end;
    end;

    procedure CheckPriceMinQtyExist(VendorNo: Code[20])
    var
        PurchasePrice: Record "Purchase Price";
        TxtCstMinPriceExist: Label 'There is a minimum quantity for the purchase price.';
    begin
        PurchasePrice.Reset();
        PurchasePrice.SetRange("Item No.", "No.");
        PurchasePrice.SetRange("Vendor No.", VendorNo);
        PurchasePrice.SetFilter("Minimum Quantity", '>%1', 0);
        if not PurchasePrice.IsEmpty() then
            Message(TxtCstMinPriceExist);
    end;
}

