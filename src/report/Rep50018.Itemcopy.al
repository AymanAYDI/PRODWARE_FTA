
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
                filename: Text;
            begin
                //Nouvelle référence remplace l'ancienne
                if NvRefRemplaceAnc = true then begin
                    TSubstituttionRemp.INIT();
                    TSubstituttionRemp."No." := Item."No.";
                    TSubstituttionRemp."Substitute No." := NvNo;
                    TSubstituttionRemp.INSERT();
                end;

                //Article
                Article.INIT();
                Article.TRANSFERFIELDS(Item, true);
                Article."No." := NvNo;
                if CodGSeriesNo <> '' then
                    Article."No. Series" := CodGSeriesNo;
                BooGCreate := true;

                Article."Creation Date" := WORKDATE();


                Article.INSERT();

                if CreerPtStMag = true then begin


                    StockkeepingUnit.RESET();
                    StockkeepingUnit.SETRANGE("Item No.", Item."No.");
                    if StockkeepingUnit.FIND('-') then
                        repeat
                            StockkeepingUnitNew := StockkeepingUnit;
                            StockkeepingUnitNew.VALIDATE("Item No.", NvNo);
                            StockkeepingUnitNew."Unit Cost" := 0;
                            StockkeepingUnitNew."Standard Cost" := 0;
                            StockkeepingUnitNew."Last Direct Cost" := 0;
                            StockkeepingUnitNew.INSERT();
                        until StockkeepingUnit.NEXT() = 0;

                end;



                //Image
                //Item.CALCFIELDS(Picture);

                //     IF Image AND (Item.Picture.Count <> 0) THEN BEGIN
                //         Article.Picture.CREATEOUTSTREAM(OutS);
                //         Item.Picture.CREATEINSTREAM(InS);
                //         COPYSTREAM(OutS, InS);


                //         Article.Picture.ImportStream()
                //    Item.Picture.CREATEINSTREAM(InS);
                //         COPYSTREAM(OutS, InS);
                //     END;


                if Image and tenantMedia.Get(Item.Picture.MediaId) then begin
                    tenantMedia.CalcFields(Content);
                    if tenantMedia.Content.HasValue then begin
                        tenantMedia.Content.CreateInStream(InS);
                        Article.Picture.Importstream(InS, '', '');
                        Article.Modify(true)
                    end;
                end;








                TUniteMesure.SETRANGE(TUniteMesure."Item No.", Item."No.");
                if TUniteMesure.FIND('-') then
                    repeat
                        TUniteMesureNew.INIT();
                        TUniteMesureNew.TRANSFERFIELDS(TUniteMesure, true);
                        TUniteMesureNew."Item No." := NvNo;
                        TUniteMesureNew.INSERT();
                    until TUniteMesure.NEXT() = 0;




                //Prix d'achats
                if PrixAchat = true then begin
                    TPrixAchats.SETRANGE(TPrixAchats."Item No.", Item."No.");
                    if TPrixAchats.FIND('-') then
                        repeat
                            TPrixAchatsNew.INIT();
                            TPrixAchatsNew.TRANSFERFIELDS(TPrixAchats, true);
                            TPrixAchatsNew."Item No." := NvNo;
                            TPrixAchatsNew.INSERT();
                        until TPrixAchats.NEXT() = 0;
                end;


                //Prix de ventes
                if PrixVentes = true then begin
                    TPrixVentes.SETRANGE(TPrixVentes."Item No.", Item."No.");
                    if TPrixVentes.FIND('-') then
                        repeat
                            TPrixVentesNew.INIT();
                            TPrixVentesNew.TRANSFERFIELDS(TPrixVentes, true);
                            TPrixVentesNew."Item No." := NvNo;
                            TPrixVentesNew.INSERT();
                        until TPrixVentes.NEXT() = 0;
                end;

                //Remises ventes
                if RemisesVentes = true then begin
                    TRemisesVentes.SETRANGE(TRemisesVentes.Code, Item."No.");
                    if TRemisesVentes.FIND('-') then
                        repeat
                            TRemisesVentesNew.INIT();
                            TRemisesVentesNew.TRANSFERFIELDS(TRemisesVentes, true);
                            TRemisesVentesNew.Code := NvNo;
                            TRemisesVentesNew.INSERT();
                        until TRemisesVentes.NEXT() = 0;
                end;


                //Remises achats
                if RemisesAchats = true then begin
                    TRemisesAchats.SETRANGE(TRemisesAchats."Item No.", Item."No.");
                    if TRemisesAchats.FIND('-') then
                        repeat
                            TRemisesAchatsNew.INIT();
                            TRemisesAchatsNew.TRANSFERFIELDS(TRemisesAchats, true);
                            TRemisesAchatsNew."Item No." := NvNo;
                            TRemisesAchatsNew.INSERT();
                        until TRemisesAchats.NEXT() = 0;
                end;

                //Catalogue Fournisseur
                if CatalogueFour = true then begin
                    TCataFour.SETRANGE(TCataFour."Item No.", Item."No.");
                    if TCataFour.FIND('-') then
                        repeat
                            TCataFourNew.INIT();
                            TCataFourNew.TRANSFERFIELDS(TCataFour, true);
                            TCataFourNew."Item No." := NvNo;
                            TCataFourNew.INSERT();
                        until TCataFour.NEXT() = 0;
                end;



                Item.CALCFIELDS("Assembly BOM");
                if NomenclatureAssemblage and Item."Assembly BOM" then begin
                    TNomenclature.SETRANGE("Parent Item No.", Item."No.");
                    if TNomenclature.FINDSET() then
                        repeat
                            TNomenclatureNew.INIT();
                            TNomenclatureNew.TRANSFERFIELDS(TNomenclature, true);
                            TNomenclatureNew."Parent Item No." := NvNo;
                            TNomenclatureNew.INSERT();
                        until TNomenclature.NEXT() = 0;
                end;


                if Substitution = true then begin
                    TSubstituttion.SETRANGE("No.", Item."No.");
                    if TSubstituttion.FIND('-') then
                        repeat
                            TSubstituttionNew.INIT();
                            TSubstituttionNew.TRANSFERFIELDS(TSubstituttion, true);
                            TSubstituttionNew."No." := NvNo;

                            TSubstituttionNew."Substitute No." := '';

                            TSubstituttionNew.INSERT();
                        until TSubstituttion.NEXT() = 0;
                end;



                if Traductions = true then begin
                    TTraductions.SETRANGE(TTraductions."Item No.", Item."No.");
                    if TTraductions.FIND('-') then
                        repeat
                            TTraductionsNew.INIT();
                            TTraductionsNew.TRANSFERFIELDS(TTraductions, true);
                            TTraductionsNew."Item No." := NvNo;
                            TTraductionsNew.INSERT();
                        until TTraductions.NEXT() = 0;
                end;

                if RéférencesEx = true then begin
                    TRefExterne.SETRANGE(TRefExterne."Item No.", Item."No.");
                    if TRefExterne.FIND('-') then
                        repeat
                            TRefExterneNew.INIT();
                            TRefExterneNew.TRANSFERFIELDS(TRefExterne, true);
                            TRefExterneNew."Item No." := NvNo;
                            TRefExterneNew.INSERT();
                        until TRefExterne.NEXT() = 0;
                end;


                if Variantes = true then begin
                    TVariantes.SETRANGE(TVariantes."Item No.", Item."No.");
                    if TVariantes.FIND('-') then
                        repeat
                            TVariantesNew.INIT();
                            TVariantesNew.TRANSFERFIELDS(TVariantes, true);
                            TVariantesNew."Item No." := NvNo;
                            TVariantesNew.INSERT();
                        until TVariantes.NEXT() = 0;
                end;


                if Commentaires = true then begin
                    TComment.SETRANGE(TComment."Table Name", TComment."Table Name"::Item);
                    TComment.SETRANGE(TComment."No.", Item."No.");
                    if TComment.FIND('-') then
                        repeat
                            TCommentNew.INIT();
                            TCommentNew.TRANSFERFIELDS(TComment, true);
                            TCommentNew."No." := NvNo;
                            TCommentNew.INSERT();
                        until TComment.NEXT() = 0;
                end;


                if AxesAnalytiques = true then begin
                    TAxesAnaly.SETRANGE(TAxesAnaly."Table ID", 27);
                    TAxesAnaly.SETRANGE(TAxesAnaly."No.", Item."No.");
                    if TAxesAnaly.FIND('-') then
                        repeat
                            TAxesAnalyNew.INIT();
                            TAxesAnalyNew.TRANSFERFIELDS(TAxesAnaly, true);
                            TAxesAnalyNew."No." := NvNo;
                            TAxesAnalyNew.INSERT();
                        until TAxesAnaly.NEXT() = 0;
                end;

                if TextGen = true then begin
                    TTextGenEntete.SETRANGE(TTextGenEntete."Table Name", TTextGenEntete."Table Name"::Item);
                    TTextGenEntete.SETRANGE(TTextGenEntete."No.", Item."No.");
                    if TTextGenEntete.FIND('-') then
                        repeat
                            TTextGenEnteteNew.INIT();
                            TTextGenEnteteNew.TRANSFERFIELDS(TTextGenEntete, true);
                            TTextGenEnteteNew."No." := NvNo;
                            TTextGenEnteteNew.INSERT();
                        until TTextGenEntete.NEXT() = 0;
                end;

                if TextGen = true then begin
                    TTextGenLigne.SETRANGE(TTextGenLigne."Table Name", TTextGenLigne."Table Name"::Item);
                    TTextGenLigne.SETRANGE(TTextGenLigne."No.", Item."No.");
                    if TTextGenLigne.FIND('-') then
                        repeat
                            TTextGenLigneNew.INIT();
                            TTextGenLigneNew.TRANSFERFIELDS(TTextGenLigne, true);
                            TTextGenLigneNew."No." := NvNo;
                            TTextGenLigneNew.INSERT();
                        until TTextGenLigne.NEXT() = 0;
                end;




            end;

            trigger OnPreDataItem()
            begin
                Item.SETFILTER("No.", AncienNo);
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
            COMMIT();
            RecLItem.SETRANGE("No.", NvNo);
            PAGE.RUNMODAL(Page::"Item Card", RecLItem);
        end;
    end;

    var


        Article: Record Item;
        TNomenclature: Record "BOM Component";
        TNomenclatureNew: Record "BOM Component";
        TComment: Record "Comment Line";
        TCommentNew: Record "Comment Line";
        TAxesAnaly: Record "Default Dimension";
        TAxesAnalyNew: Record "Default Dimension";
        TTextGenEntete: Record "Extended Text Header";
        TTextGenEnteteNew: Record "Extended Text Header";
        TTextGenLigne: Record "Extended Text Line";
        TTextGenLigneNew: Record "Extended Text Line";
        ItemNew: Record Item;
        TRefExterne: Record "Item reference";
        TRefExterneNew: Record "Item reference";
        TSubstituttion: Record "Item Substitution";
        TSubstituttionNew: Record "Item Substitution";
        TSubstituttionRemp: Record "Item Substitution";
        TTraductions: Record "Item Translation";
        TTraductionsNew: Record "Item Translation";
        TUniteMesure: Record "Item Unit of Measure";
        TUniteMesureNew: Record "Item Unit of Measure";
        TVariantes: Record "Item Variant";
        TVariantesNew: Record "Item Variant";
        TCataFour: Record "Item Vendor";
        TCataFourNew: Record "Item Vendor";
        TRemisesAchats: Record "Purchase Line Discount";
        TRemisesAchatsNew: Record "Purchase Line Discount";
        TPrixAchats: Record "Purchase Price";
        TPrixAchatsNew: Record "Purchase Price";
        TRemisesVentes: Record "Sales Line Discount";
        TRemisesVentesNew: Record "Sales Line Discount";
        TPrixVentes: Record "Sales Price";
        TPrixVentesNew: Record "Sales Price";
        StockkeepingUnit: Record "Stockkeeping Unit";
        StockkeepingUnitNew: Record "Stockkeeping Unit";
        ProdBOMCopy: Codeunit "Production BOM-Copy";
        iheb: Page "Item Picture";
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
        "RéférencesEx": Boolean;
        RemisesAchats: Boolean;
        RemisesVentes: Boolean;
        Substitution: Boolean;
        TextAchats: Boolean;
        TextGen: Boolean;
        TextVentes: Boolean;
        Traductions: Boolean;
        Variantes: Boolean;
        AncienNo: Code[20];
        CodGSeriesNo: Code[20];
        NvNo: Code[20];
        InS: InStream;
        "--NSC1.07--": Integer;
        "--NSC1.11--": Integer;
        CopieArticleTexte01: Label 'Numéro d''aticle %1 n''existe pas';
        CopieArticleTexte02: Label 'Numéro d''aticle %1 existe déjà';
        OutS: OutStream;

    [Scope('Internal')]
    procedure "FTA1.00"()
    begin
    end;


    procedure FctSearchItemNumber()
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if NvNo = '' then begin
            InvtSetup.GET();

            // GetInvtSetup;
            InvtSetup.TESTFIELD("Item Nos.");
            NoSeriesMgt.InitSeries(InvtSetup."Item Nos.", '', 0D, NvNo, CodGSeriesNo);
        end;
    end;
}

