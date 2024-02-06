namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Purchases.Posting;
using Microsoft.Purchases.Document;
reportextension 50296 "BatchPostSalesOrders" extends "Batch Post Sales Orders" //296
{
    dataset
    {
        modify("Sales Header")
        {
            RequestFilterFields = "No.", Status, "Combine Shipments", "Posting Date";
            //TODO-> Verif
            // trigger OnAfterAfterGetRecord()
            // begin
            //     if IsApprovedForPostingBatch() then
            //         if SalesPost.RUN("Sales Header") then begin
            //             CounterOK := CounterOK + 1;
            //             if MARKEDONLY then
            //                 MARK(false);

            //             //>>NAVEASY.001 [Cde_Transport] la Cde vente est livr‚e et est li‚e … une cde achat transport
            //             //alors il y a validation en R‚ception de la cde achat transport

            //             //R‚cup‚ration du Nø cde achat transport
            //             CodGNumDoc := "Sales Header"."Shipping Order No.";

            //             if ("Sales Header"."Document Type" = "Sales Header"."Document Type"::Order) and
            //                ("Sales Header".Ship) and
            //                (CodGNumDoc <> '') then
            //                 if (RecGPurchHeader.GET(RecGPurchHeader."Document Type"::Order, CodGNumDoc)) then begin
            //                     RecGPurchHeader.CALCFIELDS("Order Type");
            //                     if (RecGPurchHeader."Order Type" = RecGPurchHeader."Order Type"::Transport) then begin
            //                         RecGPurchHeader.Receive := true;
            //                         CLEAR(CuGPurchPost);
            //                         CuGPurchPost.SetPostingDate(ReplacePostingDate, ReplaceDocumentDate, PostingDateReq);
            //                         CuGPurchPost.RUN(RecGPurchHeader);
            //                     end;
            //                 end;
            //             //<<NAVEASY.001 [Cde_Transport] la Cde vente est livr‚e et est li‚e … une cde achat transport

            //         end;
            // end;
        }
    }
    var
        RecGPurchHeader: Record "Purchase Header";
        CuGPurchPost: Codeunit "Purch.-Post";
        CodGNumDoc: Code[20];

}
