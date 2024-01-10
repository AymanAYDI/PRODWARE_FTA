namespace Prodware.FTA;

using Microsoft.Sales.History;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;
pageextension 50033 "PostedSalesInvoice" extends "Posted Sales Invoice" //132
{

    layout
    {
        addafter("Document Date")
        {
            field("Fax No."; Rec."Fax No.")
            {
                ToolTip = 'Fax No.';
                ApplicationArea = All;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ToolTip = 'E-Mail';
                ApplicationArea = All;
            }
            field("Subject Mail"; Rec."Subject Mail")
            {
                ToolTip = 'Subject Mail';
                ApplicationArea = All;
            }


        }
        addafter("Bill-to Contact No.")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ToolTip = 'Gen. Bus. Posting Group';
                ApplicationArea = All;
            }

        }
        addafter("Ship-to Post Code")
        {
            field("Shipping Agent Name"; Rec."Shipping Agent Name")
            {
                ToolTip = 'Shipping Agent Name';
                ApplicationArea = All;
            }
            field("Shipping Order No."; Rec."Shipping Order No.")
            {
                ToolTip = 'Shipping Order No.';
                ApplicationArea = All;
            }


        }
    }
    actions
    {
        addafter("&Navigate")
        {
            group(shipping)
            {
                action("Voir Commande d'achat transport")
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the Voir Commande d''achat transport action.';
                    trigger OnAction()

                    var
                        RecLPurchHeader: Record "Purchase Header";
                        PgeLPurchaseOrder: Page "Purchase Order";
                        RecLInvoicePurchHeader: Record "Purch. Inv. Header";
                        PgeLInvoicePurchHeader: Page "Posted Purchase Invoice";
                        TextCdeTransport001: Label 'FRA=Il n''y a pas de Commande d''achat Transport.';
                        "Sales Invoice Header": Record "Sales Invoice Header";
                    begin


                        if rec."Shipping Order No." <> '' then begin
                            RecLPurchHeader.RESET();
                            RecLPurchHeader.SETRANGE("Document Type", RecLPurchHeader."Document Type"::Order);
                            RecLPurchHeader.SETRANGE("No.", rec."Shipping Order No.");
                            if RecLPurchHeader.FINDFIRST() then begin //Commande achat
                                RecLPurchHeader.FILTERGROUP(2);
                                PgeLPurchaseOrder.SETTABLEVIEW(RecLPurchHeader);
                                PgeLPurchaseOrder.RUNMODAL();
                            end
                            else begin //Facture achat
                                RecLInvoicePurchHeader.RESET();
                                RecLInvoicePurchHeader.SETCURRENTKEY("Order No.");
                                RecLInvoicePurchHeader.SETRANGE("Order No.", rec."Shipping Order No.");
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

            }
        }


    }





}