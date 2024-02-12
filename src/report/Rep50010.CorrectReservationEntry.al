namespace Prodware.FTA;

using Microsoft.Inventory.Tracking;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;
using Microsoft.Assembly.Document;
report 50010 "Correct Reservation Entry"
{
    Caption = 'Correct Reservation Entry';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Reservation Entry"; "Reservation Entry")
        {
            DataItemTableView = sorting("Entry No.", Positive);
            RequestFilterFields = "Entry No.", Positive;

            trigger OnAfterGetRecord()
            begin
                if ("Source Type" = 37) then
                    if not RecGSalesHeader.Get("Source Subtype", "Source ID") then begin
                        RecG337.SetRange("Entry No.", "Entry No.");
                        if RecG337.FindSet() then
                            repeat
                                RecG337SV.TransferFields(RecG337);
                                RecG337SV.Insert();
                                IntGCpt += 1;
                            //RecG337.Delete;
                            until RecG337.Next() = 0;
                    end;
                if ("Source Type" = 39) then
                    if not RecGPurchHeader.Get("Source Subtype", "Source ID") then begin
                        RecG337.SetRange("Entry No.", "Entry No.");
                        if RecG337.FindSet() then
                            repeat
                                RecG337SV.TransferFields(RecG337);
                                RecG337SV.Insert();
                                IntGCpt += 1;
                            //RecG337.Delete;
                            until RecG337.Next() = 0;
                    end;


                if ("Source Type" = 901) then
                    if not RecGAssembletoOrderLink.Get("Source Subtype", "Source ID") then begin
                        RecG337.SetRange("Entry No.", "Entry No.");
                        if RecG337.FindSet() then
                            repeat
                                RecG337SV.TransferFields(RecG337);
                                RecG337SV.Insert();
                                IntGCpt += 1;
                            //RecG337.Delete;
                            until RecG337.Next() = 0;
                    end else
                        RecGKitSalesLine.Reset();
                RecGKitSalesLine.SetRange("Document Type", RecGAssembletoOrderLink."Document Type");
                RecGKitSalesLine.SetRange("Document No.", RecGAssembletoOrderLink."Document No.");
                RecGKitSalesLine.SetRange("Line No.", RecGAssembletoOrderLink."Document Line No.");
                if RecGKitSalesLine.findFirst() then
                    if RecGKitSalesLine."No." <> "Item No." then begin
                        RecG337.SetRange("Entry No.", "Entry No.");
                        if RecG337.FindSet() then
                            repeat
                                RecG337SV.TransferFields(RecG337);
                                RecG337SV."Changed By" := '<> article';
                                RecG337SV.Insert();
                                IntGCpt += 1;

                            until RecG337.Next() = 0;




                    end;
            end;

            trigger OnPostDataItem()
            begin
                if IntGCpt > 0 then
                    Message(CstG001, IntGCpt, RecG337SV.TABLENAME)
                else
                    Message(CstG002);
            end;

            trigger OnPreDataItem()
            begin
                //SetRange("Entry No.", 65);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RecGAssembletoOrderLink: Record "Assemble-to-Order Link";
        RecGKitSalesLine: Record "Assembly Line";
        RecGPurchHeader: Record "Purchase Header";
        RecG337: Record "Reservation Entry";
        RecG337SV: Record "Reservation EntryFTA";
        RecGSalesHeader: Record "Sales Header";
        IntGCpt: Integer;
        CstG001: Label 'Nombre d''erreur trouvé : %1 (voir la table %2)';
        CstG002: Label 'Pas d''erreur trouvée';
}

