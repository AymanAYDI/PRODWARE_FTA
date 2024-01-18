namespace Prodware.FTA;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.Posting;
reportextension 50005 "BatchPostPurchaseOrders" extends "Batch Post Purchase Orders" //496
{
    dataset
    {
        modify("Purchase Header")
        {
            RequestFilterFields = "No.", Status, "Order Type";
            CalcFields = "Order Type";
            trigger OnAfterAfterGetRecord()
            var
                RecGPurchHeader: Record "Purchase Header";
                RecGPurchLine: Record "Purchase Line";
                CuGPurchPost: Codeunit "Purch.-Post";
                CuGReleasePurchaseDoc: Codeunit "Release Purchase Document";
                PurchaseBatchPostMgt: Codeunit "Purchase Batch Post Mgt.";
                BooGARefermer: Boolean;
                CodGNumDoc: Code[20];
                CodGNumDocMarchandise: Code[20];
                DecGQty: Decimal;
            begin
                CodGNumDoc := "Purchase Header"."Shipping Order No.";
                CodGNumDocMarchandise := "Purchase Header"."No.";

                if ("Purchase Header"."Document Type" = "Purchase Header"."Document Type"::Order) and
                   ("Purchase Header".Receive) and
                   (CodGNumDoc <> '') then
                    if (RecGPurchHeader.GET(RecGPurchHeader."Document Type"::Order, CodGNumDoc)) then begin
                        RecGPurchHeader.CALCFIELDS("Order Type");
                        if (RecGPurchHeader."Order Type" = RecGPurchHeader."Order Type"::Transport) then begin

                            //Cas 1 : 1 Cde achat transport li‚e … 1 seule Cde achat marchandise
                            if (RecGPurchHeader."Initial Order No." <> '') and
                               (RecGPurchHeader."Initial Order Type" <> RecGPurchHeader."Initial Order Type"::" ") then begin
                                RecGPurchHeader.Receive := true;
                                CLEAR(CuGPurchPost);
                                // CuGPurchPost.SetPostingDate(ReplacePostingDate, ReplaceDocumentDate, PostingDateReq);
                                // CuGPurchPost.RUN(RecGPurchHeader); //TODO : verifier
                                PurchaseBatchPostMgt.RunBatch(RecGPurchHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, false, true);
                            end;

                            //Cas 2 : 1 Cde achat transport li‚e … n Cdes achat marchandise
                            BooGARefermer := false;
                            if (RecGPurchHeader."Initial Order No." = '') and
                               (RecGPurchHeader."Initial Order Type" = RecGPurchHeader."Initial Order Type"::" ") then begin

                                //Si la cde achat transport est lanc‚e, on r‚ouvre la cde
                                if RecGPurchHeader.Status = RecGPurchHeader.Status::Released then begin
                                    BooGARefermer := true;
                                    CuGReleasePurchaseDoc.Reopen(RecGPurchHeader);
                                end;

                                //Modification des lignes de la cde achat transport pour ne recevoir que la ligne achat li‚e … la cde achat marchandise
                                RecGPurchLine.RESET();
                                RecGPurchLine.SETRANGE("Document Type", RecGPurchHeader."Document Type");
                                RecGPurchLine.SETRANGE("Document No.", RecGPurchHeader."No.");
                                if RecGPurchLine.FINDSET(true) then
                                    repeat
                                        if RecGPurchLine."Initial Order No." = CodGNumDocMarchandise then begin
                                            DecGQty := RecGPurchLine.Quantity;
                                            RecGPurchLine.VALIDATE(Quantity, DecGQty);             //on valide la Qt‚ … recevoir pour la ligne achat li‚e
                                        end;

                                        if RecGPurchLine."Initial Order No." <> CodGNumDocMarchandise then
                                            RecGPurchLine.VALIDATE("Qty. to Receive", 0);          //on met … 0 la Qt‚ … recevoir pr les autres lignes

                                        RecGPurchLine.MODIFY();
                                    until RecGPurchLine.NEXT() = 0;

                                //Si la cde achat transport ‚tait lanc‚e, on referme la cde
                                if BooGARefermer then
                                    CuGReleasePurchaseDoc.RUN(RecGPurchHeader);

                                //On lance la r‚ception de la cde achat transport
                                RecGPurchHeader.Receive := true;
                                CLEAR(CuGPurchPost);
                                PurchaseBatchPostMgt.RunBatch(RecGPurchHeader, ReplacePostingDate, PostingDateReq, ReplaceDocumentDate, CalcInvDisc, false, true);
                                // CuGPurchPost.SetPostingDate(ReplacePostingDate, ReplaceDocumentDate, PostingDateReq);
                                // CuGPurchPost.RUN(RecGPurchHeader);//TODO : verifier

                            end;  //Fin Cas 2
                        end;
                    end;
            end;
        }
    }
}
