namespace Prodware.FTA;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;
pageextension 50027 "PostedPurchaseInvoice" extends "Posted Purchase Invoice" //138
{
    layout
    {
        addafter("Quote No.")
        {
            field("Order Type"; rec."Order Type")
            {

            }
        }
        addafter("Ship-to City")
        {
            field("Shipping Agent Code"; rec."Shipping Agent Code")
            {
                editable = false;
            }
            field("Shipping Agent Name"; rec."Shipping Agent Name")
            {
            }
        }
    }
    actions
    {
        addbefore("&Invoice")
        {
            group(Shipping)
            {
                action("Voir Commande d'achat transport")
                {
                    trigger OnAction()
                    var
                        RecLPurchHeader: Record "Purchase Header";
                        RecLInvoicePurchHeader: Record "Purch. Inv. Header";
                        FormLPurchaseOrder: Page "Purchase Order";
                        FormLInvoicePurchHeader: Page "Posted Purchase Invoice";
                        TextCdeTransport001: Label 'There is no Shipping Purchase Order.';
                    begin
                        if rec."shipping order no." <> '' then begin
                            reclpurchheader.reset();
                            reclpurchheader.setrange("document type", reclpurchheader."document type"::order);
                            reclpurchheader.setrange("no.", rec."shipping order no.");
                            if reclpurchheader.findfirst() then begin
                                reclpurchheader.filtergroup(2);
                                formlpurchaseorder.settableview(reclpurchheader);
                                formlpurchaseorder.runmodal();
                            end
                            else begin
                                reclinvoicepurchheader.reset();
                                reclinvoicepurchheader.setcurrentkey("order no.");
                                reclinvoicepurchheader.setrange("order no.", rec."shipping order no.");
                                if reclinvoicepurchheader.findfirst() then begin
                                    reclinvoicepurchheader.filtergroup(2);
                                    formlinvoicepurchheader.settableview(reclinvoicepurchheader);
                                    formlinvoicepurchheader.runmodal();
                                end
                                else
                                    error(textcdetransport001);
                            end;
                        end
                        else
                            error(textcdetransport001);
                    end;
                }
            }
        }
    }
}
