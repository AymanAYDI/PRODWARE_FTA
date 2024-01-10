namespace Prodware.FTA;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Foundation.Reporting;
pageextension 50020 PurchaseOrder extends "Purchase Order" //50
{
    layout
    {
        moveafter("Buy-from Contact No."; "Requested Receipt Date")
        moveafter("Requested Receipt Date"; "Promised Receipt Date")
        addafter("Promised Receipt Date")
        {
            field("Fax No."; Rec."Fax No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Fax No. field.';
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the E-Mail field.';
            }
            field("Subject Mail"; Rec."Subject Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sujet Mail field.';
            }
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        addafter("VAT Bus. Posting Group")
        {
            field("Vendor. Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor Cr. Memo No.")
        {
            group(Groupe)
            {
                caption = 'Transport';
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Name"; Rec."Shipping Agent Name")
                {
                    ApplicationArea = All;
                }
                field("Shipping Order No."; Rec."Shipping Order No.")
                {
                    ApplicationArea = All;
                }
            }
            group("Commande Vente")
            {
                caption = 'Initial Sale';
                field("Initial Order Type"; Rec."Initial Order Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    actions
    {
        addafter("Post and Print Prepmt. Cr. Mem&o")
        {
            group(Shipping)
            {
                Caption = 'Shipping';
                action("Suggest Shipping agent")
                {
                    Caption = 'Suggest Shipping agent';

                    trigger OnAction()
                    var
                        RecLShippingPrice: Record "Shipping Agent Price";
                        PgeLShippingPrice: Page "Shipping agent prices";
                        DecLPrice: Decimal;
                        CodLCurrency: Code[10];
                        OptLTypeInitialOrder: Option " ",Sale,Purchase;
                        TextCdeTransport002: Label 'Shipping Purchase order %1 has been created.';
                        TextCdeTransport003: Label 'Order type cannot be "Transport" for Purchase header %1.';
                    begin

                        if Rec."Order Type" in [Rec."Order Type"::Transport] then ERROR(STRSUBSTNO(TextCdeTransport003, Rec."No."));

                        Rec."Shipping Agent Code" := '';  //ne pas mettre le Modify s'il n'y a pas de création de cde achat transport

                        //Recherche Tarif transporteur pour affichage de la page
                        RecLShippingPrice.RESET();
                        RecLShippingPrice.SETRANGE("Country Code", Rec."Ship-to Country/Region Code");
                        RecLShippingPrice.SETRANGE("Departement Code", COPYSTR(Rec."Ship-to Post Code", 1, 2));
                        RecLShippingPrice.SETRANGE("Pallet Nb", Rec."Nb Total Pallets");
                        RecLShippingPrice.SETFILTER("Beginning Date", '..%1', Rec."Posting Date");
                        if RecLShippingPrice.FINDSET() then
                            //RecLShippingPrice.CALCFIELDS(Status);
                            //RecLShippingPrice.SETFILTER(Status,'%1|%2',RecLShippingPrice.Status::"Referencing in progress",
                            //                                           RecLShippingPrice.Status::Referred);
                            RecLShippingPrice.SETCURRENTKEY("Currency Code", Price);
                        RecLShippingPrice.FILTERGROUP(2);
                        PgeLShippingPrice.SETTABLEVIEW(RecLShippingPrice);


                        //IF FORM.RUNMODAL(50026,RecLShippingPrice,RecLShippingPrice."Shipping Agent")=ACTION::LookupOK THEN BEGIN
                        if PAGE.RUNMODAL(Page::"Shipping agent prices", RecLShippingPrice, RecLShippingPrice."Shipping Agent") = ACTION::LookupOK then begin
                            Rec.VALIDATE("Shipping Agent Code", RecLShippingPrice."Shipping Agent");
                            DecLPrice := RecLShippingPrice.Price;
                            CodLCurrency := RecLShippingPrice."Currency Code";
                        end;

                        //Si un Tarif / Transporteur est sélectionné alors Création de la Cde d'achat transport
                        if Rec."Shipping Agent Code" <> '' then begin
                            Rec."Shipping Order No." := Rec.CreatePurchaseTransport(Rec."Shipping Agent Code", Rec."No.", DecLPrice, CodLCurrency, Rec."Requested Receipt Date",
                                                                            Rec."Promised Receipt Date", Rec."Planned Receipt Date", OptLTypeInitialOrder::Purchase);

                            Rec.MODIFY();
                            MESSAGE(STRSUBSTNO(TextCdeTransport002, Rec."Shipping Order No."));
                        end;
                    end;
                }
                action("Voir Commande d'achat transport")
                {
                    Caption = 'Voir Commande d''achat transport';

                    trigger OnAction()
                    var
                        RecLPurchHeader: Record "Purchase Header";
                        RecLInvoicePurchHeader: Record "Purch. Inv. Header";
                        PgeLPurchaseOrder: Page "Purchase Order";
                        PgeLInvoicePurchHeader: Page "Posted Purchase Invoice";
                        TextCdeTransport001: Label 'There is no Shipping Purchase Order.';
                    begin

                        if Rec."Shipping Order No." <> '' then begin
                            RecLPurchHeader.RESET();
                            RecLPurchHeader.SETRANGE("Document Type", RecLPurchHeader."Document Type"::Order);
                            RecLPurchHeader.SETRANGE("No.", Rec."Shipping Order No.");
                            if RecLPurchHeader.FINDFIRST() then begin //Commande achat
                                RecLPurchHeader.FILTERGROUP(2);
                                PgeLPurchaseOrder.SETTABLEVIEW(RecLPurchHeader);
                                PgeLPurchaseOrder.RUNMODAL();
                            end
                            else begin //Facture achat
                                RecLInvoicePurchHeader.RESET();
                                RecLInvoicePurchHeader.SETCURRENTKEY("Order No.");
                                RecLInvoicePurchHeader.SETRANGE("Order No.", Rec."Shipping Order No.");
                                if RecLInvoicePurchHeader.FINDFIRST() then begin
                                    RecLInvoicePurchHeader.FILTERGROUP(2);
                                    PgeLInvoicePurchHeader.SETTABLEVIEW(RecLInvoicePurchHeader);
                                    PgeLInvoicePurchHeader.RUNMODAL();
                                end
                                else
                                    ERROR(TextCdeTransport001);
                            end;
                        end
                        else
                            ERROR(TextCdeTransport001);
                    end;
                }
                action("Voir Commande Vente / Achat initiale")
                {
                    Caption = 'Voir Commande Vente / Achat initiale';

                    trigger OnAction()
                    var
                        RecLPurchHeader: Record "Purchase Header";
                        RecLInvoiceHeader: Record "Sales Invoice Header";
                        RecLSaleHeader: Record "Sales Header";
                        RecLInvoicePurchHeader: Record "Purch. Inv. Header";
                        PgeLSaleOrder: Page "Sales Order";
                        PgeLPurchaseOrder: Page "Purchase Order";
                        PgeLInvoiceHeader: Page "Posted Sales Invoice";
                        PgeLInvoicePurchHeader: Page "Posted Purchase Invoice";
                        TextCdeTransport004: Label 'There is no Linked Sale Order.';
                        TextCdeTransport005: Label 'There is no Linked Purchase Order.';
                        TextCdeTransport006: Label 'There is no Linked Sale / Purchase Order.';
                    begin

                        if (Rec."Initial Order No." <> '') and (Rec."Initial Order Type" <> Rec."Initial Order Type"::" ") then
                            case Rec."Initial Order Type" of
                                Rec."Initial Order Type"::Sale:
                                    begin //Commande vente
                                        RecLSaleHeader.RESET();
                                        RecLSaleHeader.SETRANGE("Document Type", RecLSaleHeader."Document Type"::Order);
                                        RecLSaleHeader.SETRANGE("No.", Rec."Initial Order No.");
                                        if RecLSaleHeader.FINDFIRST() then begin
                                            RecLSaleHeader.FILTERGROUP(2);
                                            PgeLSaleOrder.SETTABLEVIEW(RecLSaleHeader);
                                            PgeLSaleOrder.RUNMODAL();
                                        end else begin //Facture vente
                                            RecLInvoiceHeader.RESET();
                                            RecLInvoiceHeader.SETCURRENTKEY("Order No.");
                                            RecLInvoiceHeader.SETRANGE("Order No.", Rec."Initial Order No.");
                                            if RecLInvoiceHeader.FINDFIRST() then begin
                                                RecLInvoiceHeader.FILTERGROUP(2);
                                                PgeLInvoiceHeader.SETTABLEVIEW(RecLInvoiceHeader);
                                                PgeLInvoiceHeader.RUNMODAL();
                                            end else
                                                ERROR(TextCdeTransport004);
                                        end;
                                    end;

                                Rec."Initial Order Type"::Purchase:
                                    begin //Commande achat
                                        RecLPurchHeader.RESET();
                                        RecLPurchHeader.SETRANGE("Document Type", RecLPurchHeader."Document Type"::Order);
                                        RecLPurchHeader.SETRANGE("No.", Rec."Initial Order No.");
                                        if RecLPurchHeader.FINDFIRST() then begin
                                            RecLPurchHeader.FILTERGROUP(2);
                                            PgeLPurchaseOrder.SETTABLEVIEW(RecLPurchHeader);
                                            PgeLPurchaseOrder.RUNMODAL();
                                        end
                                        else begin //Facture achat
                                            RecLInvoicePurchHeader.RESET();
                                            RecLInvoicePurchHeader.SETCURRENTKEY("Order No.");
                                            RecLInvoicePurchHeader.SETRANGE("Order No.", Rec."Initial Order No.");
                                            if RecLInvoicePurchHeader.FINDFIRST() then begin
                                                RecLInvoicePurchHeader.FILTERGROUP(2);
                                                PgeLInvoicePurchHeader.SETTABLEVIEW(RecLInvoicePurchHeader);
                                                PgeLInvoicePurchHeader.RUNMODAL();
                                            end
                                            else
                                                ERROR(TextCdeTransport005);
                                        end;
                                    end;
                            end else
                            ERROR(TextCdeTransport006);
                    end;
                }
            }
        }

        addafter("&Print")
        {
            action("Email ")
            {
                Caption = 'Email ';
                Ellipsis = true;
                Image = Email;

                trigger OnAction()
                var
                    DocPrint: Codeunit "FTA_Functions";
                begin
                    DocPrint.EmailPurchHeader(Rec);
                end;
            }
        }
    }
}



