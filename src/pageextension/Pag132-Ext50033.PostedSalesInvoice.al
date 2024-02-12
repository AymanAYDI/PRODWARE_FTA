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
                        RecLInvoicePurchHeader: Record "Purch. Inv. Header";
                        RecLPurchHeader: Record "Purchase Header";
                        PgeLInvoicePurchHeader: Page "Posted Purchase Invoice";
                        PgeLPurchaseOrder: Page "Purchase Order";
                        TextCdeTransport001: Label 'Il n''y a pas de Commande d''achat Transport.';
                    begin
                        if rec."Shipping Order No." <> '' then begin
                            RecLPurchHeader.Reset();
                            RecLPurchHeader.SetRange("Document Type", RecLPurchHeader."Document Type"::Order);
                            RecLPurchHeader.SetRange("No.", rec."Shipping Order No.");
                            if RecLPurchHeader.findFirst() then begin //Commande achat
                                RecLPurchHeader.FILTERGROUP(2);
                                PgeLPurchaseOrder.SetTableView(RecLPurchHeader);
                                PgeLPurchaseOrder.RunModal();
                            end
                            else begin //Facture achat
                                RecLInvoicePurchHeader.Reset();
                                RecLInvoicePurchHeader.SetCurrentKey("Order No.");
                                RecLInvoicePurchHeader.SetRange("Order No.", rec."Shipping Order No.");
                                if RecLInvoicePurchHeader.findFirst() then begin
                                    RecLInvoicePurchHeader.FILTERGROUP(2);
                                    PgeLInvoicePurchHeader.SetTableView(RecLInvoicePurchHeader);
                                    PgeLInvoicePurchHeader.RunModal();
                                end
                                else
                                    Error(TextCdeTransport001);
                            end;
                        end
                        else
                            Error(TextCdeTransport001);
                    end;
                }

            }
        }


    }





}