namespace Prodware.FTA;

using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;
pageextension 50040 "PostedPurchaseInvoice" extends "Posted Purchase Invoice" //138
{
    layout
    {
        addafter("Quote No.")
        {
            field("Order Type"; rec."Order Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Type field.';
            }
        }
        addafter("Ship-to City")
        {
            field("Shipping Agent Code"; rec."Shipping Agent Code")
            {
                editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Agent Code field.';
            }
            field("Shipping Agent Name"; rec."Shipping Agent Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Agent Name field.';
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
                    ApplicationArea = All;
                    ToolTip = 'Executes the Voir Commande d''achat transport action.';
                    trigger OnAction()
                    var
                        RecLPurchHeader: Record "Purchase Header";
                        RecLInvoicePurchHeader: Record "Purch. Inv. Header";
                        FormLPurchaseOrder: Page "Purchase Order";
                        FormLInvoicePurchHeader: Page "Posted Purchase Invoice";
                        TextCdeTransport001: Label 'There is no Shipping Purchase Order.';
                    begin
                        if rec."shipping order no." <> '' then begin
                            reclpurchheader.Reset();
                            reclpurchheader.SetRange("document type", reclpurchheader."document type"::order);
                            reclpurchheader.SetRange("no.", rec."shipping order no.");
                            if reclpurchheader.findFirst() then begin
                                reclpurchheader.filtergroup(2);
                                formlpurchaseorder.SetTableView(reclpurchheader);
                                formlpurchaseorder.RunModal();
                            end
                            else begin
                                reclinvoicepurchheader.Reset();
                                reclinvoicepurchheader.SetCurrentKey("order no.");
                                reclinvoicepurchheader.SetRange("order no.", rec."shipping order no.");
                                if reclinvoicepurchheader.findFirst() then begin
                                    reclinvoicepurchheader.filtergroup(2);
                                    formlinvoicepurchheader.SetTableView(reclinvoicepurchheader);
                                    formlinvoicepurchheader.RunModal();
                                end
                                else
                                    Error(textcdetransport001);
                            end;
                        end
                        else
                            Error(textcdetransport001);
                    end;
                }
            }
        }
    }
}
