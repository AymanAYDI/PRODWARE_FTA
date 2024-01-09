
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
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                //Nouvelle référence remplace l'ancienne
                IF NvRefRemplaceAnc = TRUE THEN BEGIN
                    TSubstituttionRemp.INIT();
                    TSubstituttionRemp."No." := Item."No.";
                    TSubstituttionRemp."Substitute No." := NvNo;
                    TSubstituttionRemp.INSERT();
                END;

                //Article
                Article.INIT();
                Article.TRANSFERFIELDS(Item, TRUE);
                Article."No." := NvNo;
                IF CodGSeriesNo <> '' THEN
                    Article."No. Series" := CodGSeriesNo;
                BooGCreate := TRUE;

                Article."Creation Date" := WORKDATE();


                Article.INSERT();

                IF CreerPtStMag = TRUE THEN BEGIN


                    StockkeepingUnit.RESET();
                    StockkeepingUnit.SETRANGE("Item No.", Item."No.");
                    IF StockkeepingUnit.FIND('-') THEN
                        REPEAT
                            StockkeepingUnitNew := StockkeepingUnit;
                            StockkeepingUnitNew.VALIDATE("Item No.", NvNo);
                            StockkeepingUnitNew."Unit Cost" := 0;
                            StockkeepingUnitNew."Standard Cost" := 0;
                            StockkeepingUnitNew."Last Direct Cost" := 0;
                            StockkeepingUnitNew.INSERT();
                        UNTIL StockkeepingUnit.NEXT() = 0;

                END;



                //Image
                //todo   Item.CALCFIELDS(Picture);

                //todo  IF Image AND Item.Picture.HASVALUE THEN
                //todo  BEGIN
                //todo      Article.Picture.CREATEOUTSTREAM(OutS);
                //todo    Item.Picture.CREATEINSTREAM(InS);
                //todo     COPYSTREAM(OutS, InS);
                //todo    END;

                Article.MODIFY();


                TUniteMesure.SETRANGE(TUniteMesure."Item No.", Item."No.");
                IF TUniteMesure.FIND('-') THEN
                    REPEAT
                        TUniteMesureNew.INIT();
                        TUniteMesureNew.TRANSFERFIELDS(TUniteMesure, TRUE);
                        TUniteMesureNew."Item No." := NvNo;
                        TUniteMesureNew.INSERT();
                    UNTIL TUniteMesure.NEXT() = 0;




                //Prix d'achats
                IF PrixAchat = TRUE THEN BEGIN
                    TPrixAchats.SETRANGE(TPrixAchats."Item No.", Item."No.");
                    IF TPrixAchats.FIND('-') THEN
                        REPEAT
                            TPrixAchatsNew.INIT();
                            TPrixAchatsNew.TRANSFERFIELDS(TPrixAchats, TRUE);
                            TPrixAchatsNew."Item No." := NvNo;
                            TPrixAchatsNew.INSERT();
                        UNTIL TPrixAchats.NEXT() = 0;
                END;


                //Prix de ventes
                IF PrixVentes = TRUE THEN BEGIN
                    TPrixVentes.SETRANGE(TPrixVentes."Item No.", Item."No.");
                    IF TPrixVentes.FIND('-') THEN
                        REPEAT
                            TPrixVentesNew.INIT();
                            TPrixVentesNew.TRANSFERFIELDS(TPrixVentes, TRUE);
                            TPrixVentesNew."Item No." := NvNo;
                            TPrixVentesNew.INSERT();
                        UNTIL TPrixVentes.NEXT() = 0;
                END;

                //Remises ventes
                IF RemisesVentes = TRUE THEN BEGIN
                    TRemisesVentes.SETRANGE(TRemisesVentes.Code, Item."No.");
                    IF TRemisesVentes.FIND('-') THEN
                        REPEAT
                            TRemisesVentesNew.INIT();
                            TRemisesVentesNew.TRANSFERFIELDS(TRemisesVentes, TRUE);
                            TRemisesVentesNew.Code := NvNo;
                            TRemisesVentesNew.INSERT();
                        UNTIL TRemisesVentes.NEXT() = 0;
                END;


                //Remises achats
                IF RemisesAchats = TRUE THEN BEGIN
                    TRemisesAchats.SETRANGE(TRemisesAchats."Item No.", Item."No.");
                    IF TRemisesAchats.FIND('-') THEN
                        REPEAT
                            TRemisesAchatsNew.INIT();
                            TRemisesAchatsNew.TRANSFERFIELDS(TRemisesAchats, TRUE);
                            TRemisesAchatsNew."Item No." := NvNo;
                            TRemisesAchatsNew.INSERT();
                        UNTIL TRemisesAchats.NEXT() = 0;
                END;

                //Catalogue Fournisseur
                IF CatalogueFour = TRUE THEN BEGIN
                    TCataFour.SETRANGE(TCataFour."Item No.", Item."No.");
                    IF TCataFour.FIND('-') THEN
                        REPEAT
                            TCataFourNew.INIT();
                            TCataFourNew.TRANSFERFIELDS(TCataFour, TRUE);
                            TCataFourNew."Item No." := NvNo;
                            TCataFourNew.INSERT();
                        UNTIL TCataFour.NEXT() = 0;
                END;



                Item.CALCFIELDS("Assembly BOM");
                IF NomenclatureAssemblage AND Item."Assembly BOM" THEN BEGIN
                    TNomenclature.SETRANGE("Parent Item No.", Item."No.");
                    IF TNomenclature.FINDSET() THEN
                        REPEAT
                            TNomenclatureNew.INIT();
                            TNomenclatureNew.TRANSFERFIELDS(TNomenclature, TRUE);
                            TNomenclatureNew."Parent Item No." := NvNo;
                            TNomenclatureNew.INSERT();
                        UNTIL TNomenclature.NEXT() = 0;
                END;


                IF Substitution = TRUE THEN BEGIN
                    TSubstituttion.SETRANGE("No.", Item."No.");
                    IF TSubstituttion.FIND('-') THEN
                        REPEAT
                            TSubstituttionNew.INIT();
                            TSubstituttionNew.TRANSFERFIELDS(TSubstituttion, TRUE);
                            TSubstituttionNew."No." := NvNo;

                            TSubstituttionNew."Substitute No." := '';

                            TSubstituttionNew.INSERT();
                        UNTIL TSubstituttion.NEXT() = 0;
                END;



                IF Traductions = TRUE THEN BEGIN
                    TTraductions.SETRANGE(TTraductions."Item No.", Item."No.");
                    IF TTraductions.FIND('-') THEN
                        REPEAT
                            TTraductionsNew.INIT();
                            TTraductionsNew.TRANSFERFIELDS(TTraductions, TRUE);
                            TTraductionsNew."Item No." := NvNo;
                            TTraductionsNew.INSERT();
                        UNTIL TTraductions.NEXT() = 0;
                END;

                IF RéférencesEx = TRUE THEN BEGIN
                    TRefExterne.SETRANGE(TRefExterne."Item No.", Item."No.");
                    IF TRefExterne.FIND('-') THEN
                        REPEAT
                            TRefExterneNew.INIT();
                            TRefExterneNew.TRANSFERFIELDS(TRefExterne, TRUE);
                            TRefExterneNew."Item No." := NvNo;
                            TRefExterneNew.INSERT();
                        UNTIL TRefExterne.NEXT() = 0;
                END;


                IF Variantes = TRUE THEN BEGIN
                    TVariantes.SETRANGE(TVariantes."Item No.", Item."No.");
                    IF TVariantes.FIND('-') THEN
                        REPEAT
                            TVariantesNew.INIT();
                            TVariantesNew.TRANSFERFIELDS(TVariantes, TRUE);
                            TVariantesNew."Item No." := NvNo;
                            TVariantesNew.INSERT();
                        UNTIL TVariantes.NEXT() = 0;
                END;


                IF Commentaires = TRUE THEN BEGIN
                    TComment.SETRANGE(TComment."Table Name", TComment."Table Name"::Item);
                    TComment.SETRANGE(TComment."No.", Item."No.");
                    IF TComment.FIND('-') THEN
                        REPEAT
                            TCommentNew.INIT();
                            TCommentNew.TRANSFERFIELDS(TComment, TRUE);
                            TCommentNew."No." := NvNo;
                            TCommentNew.INSERT();
                        UNTIL TComment.NEXT() = 0;
                END;


                IF AxesAnalytiques = TRUE THEN BEGIN
                    TAxesAnaly.SETRANGE(TAxesAnaly."Table ID", 27);
                    TAxesAnaly.SETRANGE(TAxesAnaly."No.", Item."No.");
                    IF TAxesAnaly.FIND('-') THEN
                        REPEAT
                            TAxesAnalyNew.INIT();
                            TAxesAnalyNew.TRANSFERFIELDS(TAxesAnaly, TRUE);
                            TAxesAnalyNew."No." := NvNo;
                            TAxesAnalyNew.INSERT();
                        UNTIL TAxesAnaly.NEXT() = 0;
                END;

                IF TextGen = TRUE THEN BEGIN
                    TTextGenEntete.SETRANGE(TTextGenEntete."Table Name", TTextGenEntete."Table Name"::Item);
                    TTextGenEntete.SETRANGE(TTextGenEntete."No.", Item."No.");
                    IF TTextGenEntete.FIND('-') THEN
                        REPEAT
                            TTextGenEnteteNew.INIT();
                            TTextGenEnteteNew.TRANSFERFIELDS(TTextGenEntete, TRUE);
                            TTextGenEnteteNew."No." := NvNo;
                            TTextGenEnteteNew.INSERT();
                        UNTIL TTextGenEntete.NEXT() = 0;
                END;

                IF TextGen = TRUE THEN BEGIN
                    TTextGenLigne.SETRANGE(TTextGenLigne."Table Name", TTextGenLigne."Table Name"::Item);
                    TTextGenLigne.SETRANGE(TTextGenLigne."No.", Item."No.");
                    IF TTextGenLigne.FIND('-') THEN
                        REPEAT
                            TTextGenLigneNew.INIT();
                            TTextGenLigneNew.TRANSFERFIELDS(TTextGenLigne, TRUE);
                            TTextGenLigneNew."No." := NvNo;
                            TTextGenLigneNew.INSERT();
                        UNTIL TTextGenLigne.NEXT() = 0;
                END;




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
        IF BooGCreate THEN BEGIN
            COMMIT();
            RecLItem.SETRANGE("No.", NvNo);
            PAGE.RUNMODAL(Page::"Item Card", RecLItem);
        END;
    end;

    var
        AncienNo: Code[20];
        Article: Record "27";
        NvNo: Code[20];
        CreerPtStMag: Boolean;
        NvRefRemplaceAnc: Boolean;
        Substitution: Boolean;
        AxesAnalytiques: Boolean;
        Image: Boolean;
        Commentaires: Boolean;
        Variantes: Boolean;
        "RéférencesEx": Boolean;
        Traductions: Boolean;
        TextGen: Boolean;
        TextVentes: Boolean;
        TextAchats: Boolean;
        NomenclatureAssemblage: Boolean;
        PrixVentes: Boolean;
        RemisesVentes: Boolean;
        CatalogueFour: Boolean;
        PrixAchat: Boolean;
        RemisesAchats: Boolean;
        CopieArticleTexte01: Label 'Numéro d''aticle %1 n''existe pas';
        CopieArticleTexte02: Label 'Numéro d''aticle %1 existe déjà';
        TUniteMesure: Record "Item Unit of Measure";
        TUniteMesureNew: Record "Item Unit of Measure";
        TSubstituttion: Record "Item Substitution";
        TSubstituttionNew: Record "Item Substitution";
        TSubstituttionRemp: Record "Item Substitution";
        TAxesAnaly: Record "Default Dimension";
        TAxesAnalyNew: Record "Default Dimension";
        TComment: Record "Comment Line";
        TCommentNew: Record "Comment Line";
        TVariantes: Record "Item Variant";
        TVariantesNew: Record "Item Variant";
        TRefExterne: Record "Item reference";
        TRefExterneNew: Record "Item reference";
        TTraductions: Record "Item Translation";
        TTraductionsNew: Record "Item Translation";
        TTextGenEntete: Record "Extended Text Header";
        TTextGenEnteteNew: Record "Extended Text Header";
        TTextGenLigne: Record "Extended Text Line";
        TTextGenLigneNew: Record "Extended Text Line";
        TNomenclature: Record "BOM Component";
        TNomenclatureNew: Record "BOM Component";
        TPrixVentes: Record "Sales Price";
        TPrixVentesNew: Record "Sales Price";
        TRemisesVentes: Record "Sales Line Discount";
        TRemisesVentesNew: Record "Sales Line Discount";
        TCataFour: Record "Item Vendor";
        TCataFourNew: Record "Item Vendor";
        TPrixAchats: Record "Purchase Price";
        TPrixAchatsNew: Record "Purchase Price";
        TRemisesAchats: Record "Purchase Line Discount";
        TRemisesAchatsNew: Record "Purchase Line Discount";
        InS: InStream;
        OutS: OutStream;
        "--NSC1.07--": Integer;
        ItemNew: Record Item;
        "--NSC1.11--": Integer;
        StockkeepingUnit: Record "Stockkeeping Unit";
        StockkeepingUnitNew: Record "Stockkeeping Unit";
        ProdBOMCopy: Codeunit "Production BOM-Copy";
        CodGSeriesNo: Code[20];
        BooGCreate: Boolean;
        iheb: Page "Item Picture";

    [Scope('Internal')]
    procedure "FTA1.00"()
    begin
    end;


    procedure FctSearchItemNumber()
    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF NvNo = '' THEN BEGIN
            InvtSetup.GET();

            // GetInvtSetup;
            InvtSetup.TESTFIELD("Item Nos.");
            NoSeriesMgt.InitSeries(InvtSetup."Item Nos.", '', 0D, NvNo, CodGSeriesNo);
        END;
    end;
}

