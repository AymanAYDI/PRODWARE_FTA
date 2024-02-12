namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Assembly.Comment;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Availability;
using Microsoft.Sales.Document;
using System.Globalization;
using Microsoft.Finance.Dimension;
using Microsoft.Sales.History;
page 50013 "Shipment Not Invoiced"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>EASY1.00.01.03
    // NAVEASY:NI 19/09/2008 [Recup_Form]
    //                           - Create Form
    // 
    // ------------------------------------------------------------------------

    Caption = 'Shipment Not Invoiced';
    Editable = true;
    PaGetype = List;
    SourceTable = "Sales Shipment Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                Editable = false;
                field("Document No."; Rec."Document No.")
                {
                    Style = Strong;
                    StyleExpr = BooGUpdateFond;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Visible = true;
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field.';
                }
                field(SalesShptHeader; SalesShptHeader."Bill-to Name")
                {
                    Caption = 'Nom client facturé';
                    ToolTip = 'Specifies the value of the SalesShptHeader field.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = true;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Appl.-to Item Entry field.';
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shipment Date field.';
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ToolTip = 'Specifies the value of the Quantity Invoiced field.';
                }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                {
                    ToolTip = 'Specifies the value of the Qty. Shipped Not Invoiced field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Show Document action.';
                    trigger OnAction()
                    begin
                        SalesShptHeader.Get(Rec."Document No.");
                        PAGE.Run(PAGE::"Posted Sales Shipment", SalesShptHeader);
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'Executes the Item &Tracking Lines action.';
                    trigger OnAction()
                    begin
                        Rec.ShowItemTrackingLines();
                    end;
                }
            }
        }
        area(processing)
        {
            action(OK)
            {
                Caption = 'OK';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the OK action.';
                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);

                    //PRM : Controle pour qu'il n'y ait qu'un seul client selectionné
                    SVSell := '';
                    if Rec.findFirst() then
                        repeat
                            if Rec.MarkedOnly() = true then
                                if SVSell = '' then begin
                                    SVSell := Rec."Sell-to Customer No.";
                                    // recherche 1er entete de commande pour chercher l'adresse de livraison
                                    SalesHeader3.Get(SalesHeader3."Document Type"::Order, Rec."Order No.");
                                end;
                            if (SVSell <> '') and (SVSell <> Rec."Sell-to Customer No.") then
                                Error(Text100);
                        until Rec.Next() = 0;

                    // le n° de cde puis le client et les zones associées

                    //PRM : Création entête commande
                    // le n° de cde puis le client et les zones associées
                    if SVSell <> '' then begin
                        SalesHeader.Init();
                        SalesHeader.TransferFields(SalesHeader3);
                        SalesHeader."No." := '';
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        SalesHeader.Status := SalesHeader.Status::Open;
                        //SalesHeader."Sell-to Customer No.":= "Bill-to Customer No." ;
                        //SalesHeader.Validate("Sell-to Customer No.",Rec."Bill-to Customer No.");

                        SalesHeader."Ship-to Code" := SalesHeader3."Ship-to Code";
                        SalesHeader."Ship-to Name" := SalesHeader3."Ship-to Name";
                        SalesHeader."Ship-to Address" := SalesHeader3."Ship-to Address";
                        SalesHeader."Ship-to Address 2" := SalesHeader3."Ship-to Address 2";
                        SalesHeader."Ship-to Post Code" := SalesHeader3."Ship-to Post Code";
                        SalesHeader."Ship-to City" := SalesHeader3."Ship-to City";
                        SalesHeader."Ship-to Contact" := SalesHeader3."Ship-to Contact";
                        SalesHeader."Ship-to Code" := SalesHeader3."Ship-to Code";
                        SalesHeader."Ship-to Code" := SalesHeader3."Ship-to Code";
                        //FGSalesHeader."SAV Order No.":= SalesHeader3."No.";
                        SalesHeader."Document Date" := WorkDate();
                        SalesHeader."Posting Date" := WorkDate();
                        SalesHeader.Validate("Payment Terms Code");
                        SalesHeader.Validate("Document Date");
                        SalesHeader.Validate("Posting Date");

                        //SalesHeader.Ship :=FALSE;
                        //SalesHeader."Last Shipping No." :='';

                        SalesHeader.Insert(true);
                        SalesHeader.Validate("Shortcut Dimension 1 Code");
                        SalesHeader.Validate("Shortcut Dimension 2 Code");

                        Commit();
                        //PRM : Fin création entête commande
                        SalesGetShpt.SetSalesHeader(SalesHeader);

                        //COMMENTAIRE SL 19/10/06 NSC1.13
                        OldDocumentNo := '';
                        if Rec.findFirst() then
                            repeat
                                if Rec."Document No." <> OldDocumentNo then begin
                                    SalesShipLine2.Reset();
                                    SalesShipLine2.SetRange("Document No.", Rec."Document No.");
                                    //FGIF SalesShipLine2.findFirst() THEN
                                    //FGSalesGetShpt.CreateInvLinesWithAll(SalesShipLine2);
                                end;
                                OldDocumentNo := Rec."Document No.";
                            until Rec.Next() = 0;
                        //Fin COMMENTAIRE SL 19/10/06 NSC1.13

                        //Appel de la facture et de ses lignes...
                        Commit();
                        PAGE.RunModal(Page::"Sales Invoice", SalesHeader);
                    end;
                    Rec.ClearMARKS();
                    Rec.MarkedOnly(false);
                    Rec.SetFilter(Type, '');

                    //CurrForm.Close;
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    //REPORT.Run(REPORT::"Shipments not Invoiced",TRUE,FALSE,Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //DESIGN SL 27/09/06 NSC1.08
        SalesShptHeader.Get(Rec."Document No.");
        //Fin DESIGN SL 27/09/06 NSC1.08
        DocumentNoOnFormat(Format(Rec."Document No."));
    end;

    trigger OnOpenPage()
    begin

        //COMMENTAIRE SL 19/10/06 NSC1.13
        Rec.FILTERGROUP(0);
        //FGSetRange("To be invoiced",TRUE);
        Rec.SetFilter("Qty. Shipped Not Invoiced", '<>%1', 0);
        Rec.FILTERGROUP(2);
        //Fin COMMENTAIRE SL 19/10/06 NSC1.13
    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesHeader: Record "Sales Header";
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
        SalesShipLine2: Record "Sales Shipment Line";
        "Sales Shipment line": Record "Sales Shipment Line";
        SalesHeader3: Record "Sales Header";
        SalesShipLine: Record "Sales Shipment Line";
        SalesGetShpt: Codeunit "Sales-Get Shipment";
        Text100: Label 'You can select only one customer. Make you order correctly.';
        SVSell: Code[20];
        FiltreBL: Option "tous les BL","BL à regrouper","BL sans regroupement";
        OldDocumentNo: Code[20];
        BooGUpdateFond: Boolean;


    procedure SetSalesHeader(var SalesHeader2: Record "Sales Header")
    begin
        /*SalesHeader.Get(SalesHeader2."Document Type",SalesHeader2."No.");
        SalesHeader.TestField("Document Type",SalesHeader."Document Type"::Invoice);  */

    end;

    local procedure IsFirstDocLine(): Boolean
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin

        TempSalesShptLine.Reset();
        TempSalesShptLine.CopyFilters(Rec);
        TempSalesShptLine.SetRange("Document No.", Rec."Document No.");
        if not TempSalesShptLine.findFirst() then begin
            SalesShptLine.CopyFilters(Rec);
            SalesShptLine.SetRange("Document No.", Rec."Document No.");
            SalesShptLine.findFirst();
            TempSalesShptLine := SalesShptLine;
            TempSalesShptLine.Insert();
        end;
        if Rec."Line No." = TempSalesShptLine."Line No." then
            exit(true);
    end;

    local procedure DocumentNoOnFormat(Text: Text[1024])
    begin
        //FTA
        BooGUpdateFond := false;
        if IsFirstDocLine() then
            BooGUpdateFond := true
        //CurrPage."Document No.".UPDATEFONTBOLD := TRUE
        ////FTA
        else
            Text := '';
    end;
}

