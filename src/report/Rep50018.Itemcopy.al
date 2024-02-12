
namespace Prodware.FTA;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Substitution;
using Microsoft.Finance.Dimension;
using Microsoft.Foundation.Comment;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Inventory.BOM;
using Microsoft.Sales.Pricing;
using Microsoft.Purchases.Pricing;
using System.Environment;
using System.Utilities;
using Microsoft.Inventory.Location;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Inventory.Item.Picture;
using Microsoft.Inventory.Setup;
using Microsoft.Foundation.NoSeries;


report 50018 "Item copy"
{

    Caption = 'Item Copy';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");

            trigger OnAfterGetRecord()
            var
                tenantMedia: Record "Tenant Media";
            begin
                //Nouvelle référence remplace l'ancienne
                if NvRefRemplaceAnc = true then begin
                    TSubstituttionRemp.Init();
                    TSubstituttionRemp."No." := Item."No.";
                    TSubstituttionRemp."Substitute No." := NvNo;
                    TSubstituttionRemp.Insert();
                end;

                //Article
                Article.Init();
                Article.TransferFields(Item, true);
                Article."No." := NvNo;
                if CodGSeriesNo <> '' then
                    Article."No. Series" := CodGSeriesNo;
                BooGCreate := true;

                Article."Creation Date" := WorkDate();


                Article.Insert();

                if CreerPtStMag = true then begin


                    StockkeepingUnit.Reset();
                    StockkeepingUnit.SetRange("Item No.", Item."No.");
                    if StockkeepingUnit.findFirst() then
                        repeat
                            StockkeepingUnitNew := StockkeepingUnit;
                            StockkeepingUnitNew.Validate("Item No.", NvNo);
                            StockkeepingUnitNew."Unit Cost" := 0;
                            StockkeepingUnitNew."Standard Cost" := 0;
                            StockkeepingUnitNew."Last Direct Cost" := 0;
                            StockkeepingUnitNew.Insert();
                        until StockkeepingUnit.Next() = 0;

                end;



                //Image
                //Item.CalcFields(Picture);

                //     IF Image AND (Item.Picture.Count <> 0) THEN BEGIN
                //         Article.Picture.CREATEOUTSTREAM(OutS);
                //         Item.Picture.CREATEINSTREAM(InS);
                //         CopyStrEAM(OutS, InS);


                //         Article.Picture.ImportStream()
                //    Item.Picture.CREATEINSTREAM(InS);
                //         CopyStrEAM(OutS, InS);
                //     END;


                if Image and tenantMedia.Get(Item.Picture.MediaId) then begin
                    tenantMedia.CalcFields(Content);
                    if tenantMedia.Content.HasValue then begin
                        tenantMedia.Content.CreateInStream(InS);
                        Article.Picture.Importstream(InS, '', '');
                        Article.Modify(true)
                    end;
                end;








                TUniteMesure.SetRange(TUniteMesure."Item No.", Item."No.");
                if TUniteMesure.findFirst() then
                    repeat
                        TUniteMesureNew.Init();
                        TUniteMesureNew.TransferFields(TUniteMesure, true);
                        TUniteMesureNew."Item No." := NvNo;
                        TUniteMesureNew.Insert();
                    until TUniteMesure.Next() = 0;




                //Prix d'achats
                if PrixAchat = true then begin
                    TPrixAchats.SetRange(TPrixAchats."Item No.", Item."No.");
                    if TPrixAchats.findFirst() then
                        repeat
                            TPrixAchatsNew.Init();
                            TPrixAchatsNew.TransferFields(TPrixAchats, true);
                            TPrixAchatsNew."Item No." := NvNo;
                            TPrixAchatsNew.Insert();
                        until TPrixAchats.Next() = 0;
                end;


                //Prix de ventes
                if PrixVentes = true then begin
                    TPrixVentes.SetRange(TPrixVentes."Item No.", Item."No.");
                    if TPrixVentes.findFirst() then
                        repeat
                            TPrixVentesNew.Init();
                            TPrixVentesNew.TransferFields(TPrixVentes, true);
                            TPrixVentesNew."Item No." := NvNo;
                            TPrixVentesNew.Insert();
                        until TPrixVentes.Next() = 0;
                end;

                //Remises ventes
                if RemisesVentes = true then begin
                    TRemisesVentes.SetRange(TRemisesVentes.Code, Item."No.");
                    if TRemisesVentes.findFirst() then
                        repeat
                            TRemisesVentesNew.Init();
                            TRemisesVentesNew.TransferFields(TRemisesVentes, true);
                            TRemisesVentesNew.Code := NvNo;
                            TRemisesVentesNew.Insert();
                        until TRemisesVentes.Next() = 0;
                end;


                //Remises achats
                if RemisesAchats = true then begin
                    TRemisesAchats.SetRange(TRemisesAchats."Item No.", Item."No.");
                    if TRemisesAchats.findFirst() then
                        repeat
                            TRemisesAchatsNew.Init();
                            TRemisesAchatsNew.TransferFields(TRemisesAchats, true);
                            TRemisesAchatsNew."Item No." := NvNo;
                            TRemisesAchatsNew.Insert();
                        until TRemisesAchats.Next() = 0;
                end;

                //Catalogue Fournisseur
                if CatalogueFour = true then begin
                    TCataFour.SetRange(TCataFour."Item No.", Item."No.");
                    if TCataFour.findFirst() then
                        repeat
                            TCataFourNew.Init();
                            TCataFourNew.TransferFields(TCataFour, true);
                            TCataFourNew."Item No." := NvNo;
                            TCataFourNew.Insert();
                        until TCataFour.Next() = 0;
                end;



                Item.CalcFields("Assembly BOM");
                if NomenclatureAssemblage and Item."Assembly BOM" then begin
                    TNomenclature.SetRange("Parent Item No.", Item."No.");
                    if TNomenclature.FindSet() then
                        repeat
                            TNomenclatureNew.Init();
                            TNomenclatureNew.TransferFields(TNomenclature, true);
                            TNomenclatureNew."Parent Item No." := NvNo;
                            TNomenclatureNew.Insert();
                        until TNomenclature.Next() = 0;
                end;


                if Substitution = true then begin
                    TSubstituttion.SetRange("No.", Item."No.");
                    if TSubstituttion.findFirst() then
                        repeat
                            TSubstituttionNew.Init();
                            TSubstituttionNew.TransferFields(TSubstituttion, true);
                            TSubstituttionNew."No." := NvNo;

                            TSubstituttionNew."Substitute No." := '';

                            TSubstituttionNew.Insert();
                        until TSubstituttion.Next() = 0;
                end;



                if Traductions = true then begin
                    TTraductions.SetRange(TTraductions."Item No.", Item."No.");
                    if TTraductions.findFirst() then
                        repeat
                            TTraductionsNew.Init();
                            TTraductionsNew.TransferFields(TTraductions, true);
                            TTraductionsNew."Item No." := NvNo;
                            TTraductionsNew.Insert();
                        until TTraductions.Next() = 0;
                end;

                if RéférencesEx = true then begin
                    TRefExterne.SetRange(TRefExterne."Item No.", Item."No.");
                    if TRefExterne.findFirst() then
                        repeat
                            TRefExterneNew.Init();
                            TRefExterneNew.TransferFields(TRefExterne, true);
                            TRefExterneNew."Item No." := NvNo;
                            TRefExterneNew.Insert();
                        until TRefExterne.Next() = 0;
                end;


                if Variantes = true then begin
                    TVariantes.SetRange(TVariantes."Item No.", Item."No.");
                    if TVariantes.findFirst() then
                        repeat
                            TVariantesNew.Init();
                            TVariantesNew.TransferFields(TVariantes, true);
                            TVariantesNew."Item No." := NvNo;
                            TVariantesNew.Insert();
                        until TVariantes.Next() = 0;
                end;


                if Commentaires = true then begin
                    TComment.SetRange(TComment."Table Name", TComment."Table Name"::Item);
                    TComment.SetRange(TComment."No.", Item."No.");
                    if TComment.findFirst() then
                        repeat
                            TCommentNew.Init();
                            TCommentNew.TransferFields(TComment, true);
                            TCommentNew."No." := NvNo;
                            TCommentNew.Insert();
                        until TComment.Next() = 0;
                end;


                if AxesAnalytiques = true then begin
                    TAxesAnaly.SetRange(TAxesAnaly."Table ID", 27);
                    TAxesAnaly.SetRange(TAxesAnaly."No.", Item."No.");
                    if TAxesAnaly.findFirst() then
                        repeat
                            TAxesAnalyNew.Init();
                            TAxesAnalyNew.TransferFields(TAxesAnaly, true);
                            TAxesAnalyNew."No." := NvNo;
                            TAxesAnalyNew.Insert();
                        until TAxesAnaly.Next() = 0;
                end;

                if TextGen = true then begin
                    TTextGenEntete.SetRange(TTextGenEntete."Table Name", TTextGenEntete."Table Name"::Item);
                    TTextGenEntete.SetRange(TTextGenEntete."No.", Item."No.");
                    if TTextGenEntete.findFirst() then
                        repeat
                            TTextGenEnteteNew.Init();
                            TTextGenEnteteNew.TransferFields(TTextGenEntete, true);
                            TTextGenEnteteNew."No." := NvNo;
                            TTextGenEnteteNew.Insert();
                        until TTextGenEntete.Next() = 0;
                end;

                if TextGen = true then begin
                    TTextGenLigne.SetRange(TTextGenLigne."Table Name", TTextGenLigne."Table Name"::Item);
                    TTextGenLigne.SetRange(TTextGenLigne."No.", Item."No.");
                    if TTextGenLigne.findFirst() then
                        repeat
                            TTextGenLigneNew.Init();
                            TTextGenLigneNew.TransferFields(TTextGenLigne, true);
                            TTextGenLigneNew."No." := NvNo;
                            TTextGenLigneNew.Insert();
                        until TTextGenLigne.Next() = 0;
                end;




            end;

            trigger OnPreDataItem()
            begin
                Item.SetFilter("No.", AncienNo);
            end;
        }
    }

    requestpage
    {
        Caption = 'Item Copy';

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AncienNo; AncienNo)
                    {
                        Caption = 'Article Source :';
                        TableRelation = Item;
                    }
                    field(NvNo; NvNo)
                    {
                        Caption = 'Article destination :';

                        trigger OnAssistEdit()
                        begin
                            FctSearchItemNumber();
                        end;
                    }
                    field(CreerPtStMag; CreerPtStMag)
                    {
                        Caption = 'Créer point de stock magasin :';
                    }
                    field(NvRefRemplaceAnc; NvRefRemplaceAnc)
                    {
                        Caption = 'Nvlle ref remplace l''ancienne :';
                    }
                    label(test)
                    {
                    }
                    label("Dupliquer les enregistrements existants :")
                    {
                        Caption = 'Dupliquer les enregistrements existants :';
                    }
                    label(tests)
                    {
                    }
                    field(Substitution; Substitution)
                    {
                        Caption = 'Substitution';
                    }
                    field(AxesAnalytiques; AxesAnalytiques)
                    {
                        Caption = 'Axes analytiques';
                    }
                    field(Image; Image)
                    {
                        Caption = 'Image';
                    }
                    field(Commentaires; Commentaires)
                    {
                        Caption = 'Commentaires';
                    }
                    field(Variantes; Variantes)
                    {
                        Caption = 'Variantes';
                    }
                    field(RéférencesEx; RéférencesEx)
                    {
                        Caption = 'Références externes';
                    }
                    field(Traductions; Traductions)
                    {
                        Caption = 'Traductions';
                    }
                    field(TextGen; TextGen)
                    {
                        Caption = 'Texte étendu général';
                    }
                    field(NomenclatureAssemblage; NomenclatureAssemblage)
                    {
                        Caption = 'Kit';
                    }
                    field(PrixVentes; PrixVentes)
                    {
                        Caption = 'Prix Ventes';
                    }
                    field(RemisesVentes; RemisesVentes)
                    {
                        Caption = 'Remises Ventes';
                    }
                    field(CatalogueFour; CatalogueFour)
                    {
                        Caption = 'Catalogue Fournisseur';
                    }
                    field(PrixAchat; PrixAchat)
                    {
                        Caption = 'Prix d''achat';
                    }
                    field(RemisesAchats; RemisesAchats)
                    {
                        Caption = 'Remises achats';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        RecLItem: Record "27";
    begin
        if BooGCreate then begin
            Commit();
            RecLItem.SetRange("No.", NvNo);
            PAGE.RunModal(Page::"Item Card", RecLItem);
        end;
    end;

    var
        Article: Record Item;
        StockkeepingUnit: Record "Stockkeeping Unit";
        StockkeepingUnitNew: Record "Stockkeeping Unit";
        TAxesAnaly: Record "Default Dimension";
        TAxesAnalyNew: Record "Default Dimension";
        TCataFour: Record "Item Vendor";
        TCataFourNew: Record "Item Vendor";
        TComment: Record "Comment Line";
        TCommentNew: Record "Comment Line";
        TNomenclature: Record "BOM Component";
        TNomenclatureNew: Record "BOM Component";
        TPrixAchats: Record "Purchase Price";
        TPrixAchatsNew: Record "Purchase Price";
        TPrixVentes: Record "Sales Price";
        TPrixVentesNew: Record "Sales Price";
        TRefExterne: Record "Item reference";
        TRefExterneNew: Record "Item reference";
        TRemisesAchats: Record "Purchase Line Discount";
        TRemisesAchatsNew: Record "Purchase Line Discount";
        TRemisesVentes: Record "Sales Line Discount";
        TRemisesVentesNew: Record "Sales Line Discount";
        TSubstituttion: Record "Item Substitution";
        TSubstituttionNew: Record "Item Substitution";
        TSubstituttionRemp: Record "Item Substitution";
        TTextGenEntete: Record "Extended Text Header";
        TTextGenEnteteNew: Record "Extended Text Header";
        TTextGenLigne: Record "Extended Text Line";
        TTextGenLigneNew: Record "Extended Text Line";
        TTraductions: Record "Item Translation";
        TTraductionsNew: Record "Item Translation";
        TUniteMesure: Record "Item Unit of Measure";
        TUniteMesureNew: Record "Item Unit of Measure";
        TVariantes: Record "Item Variant";
        TVariantesNew: Record "Item Variant";
        InS: InStream;
        "RéférencesEx": Boolean;
        AxesAnalytiques: Boolean;
        BooGCreate: Boolean;
        CatalogueFour: Boolean;
        Commentaires: Boolean;
        CreerPtStMag: Boolean;
        Image: Boolean;
        NomenclatureAssemblage: Boolean;
        NvRefRemplaceAnc: Boolean;
        PrixAchat: Boolean;
        PrixVentes: Boolean;
        RemisesAchats: Boolean;
        RemisesVentes: Boolean;
        Substitution: Boolean;
        TextGen: Boolean;
        Traductions: Boolean;
        Variantes: Boolean;
        AncienNo: Code[20];
        CodGSeriesNo: Code[20];
        NvNo: Code[20];




    procedure FctSearchItemNumber()
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if NvNo = '' then begin
            InvtSetup.Get();

            // GetInvtSetup;
            InvtSetup.TestField("Item Nos.");
            NoSeriesMgt.InitSeries(InvtSetup."Item Nos.", '', 0D, NvNo, CodGSeriesNo);
        end;
    end;
}

