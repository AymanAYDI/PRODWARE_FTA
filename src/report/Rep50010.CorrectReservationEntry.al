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
                    if not RecGSalesHeader.GET("Source Subtype", "Source ID") then begin
                        RecG337.SETRANGE("Entry No.", "Entry No.");
                        if RecG337.FINDSET() then
                            repeat
                                RecG337SV.TRANSFERFIELDS(RecG337);
                                RecG337SV.INSERT();
                                IntGCpt += 1;
                            //RecG337.DELETE;
                            until RecG337.NEXT() = 0;
                    end;
                if ("Source Type" = 39) then
                    if not RecGPurchHeader.GET("Source Subtype", "Source ID") then begin
                        RecG337.SETRANGE("Entry No.", "Entry No.");
                        if RecG337.FINDSET() then
                            repeat
                                RecG337SV.TRANSFERFIELDS(RecG337);
                                RecG337SV.INSERT();
                                IntGCpt += 1;
                            //RecG337.DELETE;
                            until RecG337.NEXT() = 0;
                    end;


                if ("Source Type" = 901) then
                    if not RecGAssembletoOrderLink.GET("Source Subtype", "Source ID") then begin
                        RecG337.SETRANGE("Entry No.", "Entry No.");
                        if RecG337.FINDSET() then
                            repeat
                                RecG337SV.TRANSFERFIELDS(RecG337);
                                RecG337SV.INSERT();
                                IntGCpt += 1;
                            //RecG337.DELETE;
                            until RecG337.NEXT() = 0;
                    end else
                        RecGKitSalesLine.RESET();
                RecGKitSalesLine.SETRANGE("Document Type", RecGAssembletoOrderLink."Document Type");
                RecGKitSalesLine.SETRANGE("Document No.", RecGAssembletoOrderLink."Document No.");
                RecGKitSalesLine.SETRANGE("Line No.", RecGAssembletoOrderLink."Document Line No.");
                if RecGKitSalesLine.FINDFIRST() then
                    if RecGKitSalesLine."No." <> "Item No." then begin
                        RecG337.SETRANGE("Entry No.", "Entry No.");
                        if RecG337.FINDSET() then
                            repeat
                                RecG337SV.TRANSFERFIELDS(RecG337);
                                RecG337SV."Changed By" := '<> article';
                                RecG337SV.INSERT();
                                IntGCpt += 1;

                            until RecG337.NEXT() = 0;




                    end;
            end;

            trigger OnPostDataItem()
            begin
                if IntGCpt > 0 then
                    MESSAGE(CstG001, IntGCpt, RecG337SV.TABLENAME)
                else
                    MESSAGE(CstG002);
            end;

            trigger OnPreDataItem()
            begin
                //SETRANGE("Entry No.", 65);
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
        RecGSalesHeader: Record "Sales Header";
        RecGPurchHeader: Record "Purchase Header";
        RecG337SV: Record "Reservation EntryFTA";
        RecG337: Record "Reservation Entry";
        RecGKitSalesLine: Record "Assembly Line";
        IntGCpt: Integer;
        CstG001: Label 'Nombre d''erreur trouvé : %1 (voir la table %2)';
        CstG002: Label 'Pas d''erreur trouvée';
        RecGAssembletoOrderLink: Record "Assemble-to-Order Link";
}

