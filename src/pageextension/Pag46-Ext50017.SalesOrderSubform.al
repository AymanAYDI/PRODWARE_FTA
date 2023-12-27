namespace Prodware.FTA;

using Microsoft.Sales.Document;
using System.Security.User;
pageextension 50017 "SalesOrderSubform" extends "Sales Order Subform" //46
{
    layout
    {
        modify(Type)
        {
            Style = Favorable;
            StyleExpr = BooGOK;

        }
        modify("No.")
        {
            Style = Favorable;
            StyleExpr = BooGOK;
        }
        modify(Description)
        {
            Style = Favorable;
            StyleExpr = BooGOK;
        }
        modify("Location Code")
        {
            Style = Favorable;
            StyleExpr = BooGOK;
        }
        modify(Quantity)
        {
            Style = Favorable;
            StyleExpr = BooGOK;
            trigger OnAfterValidate()
            var
                CstL001: Label 'The Entered quantity is greather than the existing quantity, please entered this quantity in a new line.';
            begin
                if (xRec.Quantity <> 0) and (xRec.Quantity < rec.Quantity) then
                    ERROR(CstL001);
                DecGxQuantity := xRec.Quantity;
                OptGxPreparationType := xRec."Preparation Type";
            end;
        }
        modify("Unit of Measure Code")
        {
            Style = Favorable;
            StyleExpr = BooGOK;
        }
        modify("Unit Price")
        {
            Style = Favorable;
            StyleExpr = BooGOK;
        }
        modify("Line Amount")
        {
            Style = Favorable;
            StyleExpr = BooGOK;
        }
        modify("Line Discount %")
        {
            Style = Favorable;
            StyleExpr = BooGOK;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify(Control51)
        {
            Visible = false;
        }
        addafter(Type)
        {
            field("Item Base"; rec."Item Base")
            {
                Style = Favorable;
                StyleExpr = BooGOK;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Base field.';
                trigger OnValidate()
                begin
                    CurrPage.UPDATE(true);
                end;
            }
        }
        addafter("Location Code")
        {
            field(Prepare; rec.Prepare)
            {
                Enabled = PrepareEnable;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Préparé field.';
            }
        }
        addafter("Reserved Quantity")
        {
            field("Item Machining Time"; rec."Item Machining Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temps d''usinage field.';
            }
            field("Item Work Time"; rec."Item Work Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temps de montage field.';
            }
            field("Preparation Type"; rec."Preparation Type")
            {
                Editable = false;
                Style = Favorable;
                StyleExpr = BooGOK;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Preparation Type field.';
            }
        }
        addafter("Line Discount %")
        {
            field("Unit Price Discounted"; rec."Unit Price Discounted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Price Discounted field.';
            }
        }
        addafter("Line Discount Amount")
        {
            field("Purchase Price Base"; rec."Purchase Price Base")
            {
                Style = Favorable;
                StyleExpr = BooGOK;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purchase Price Base field.';
            }
            field("Margin %"; rec."Margin %")
            {
                Editable = false;
                Style = Favorable;
                StyleExpr = BooGOK;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Margin % field.';
            }
        }
        addafter("Shipment Date")
        {
            field("Start Date"; rec."Start Date")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Date départ field.';
            }
        }
        addafter("Line No.")
        {
            field("Parcel No."; rec."Parcel No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Parcel No. field.';
            }
        }
    }
    actions
    {
        addafter("&Line")
        {
            group("Information Article")
            {
                action("Item Card")
                {
                    Caption = 'Item Card';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Item Card action.';
                    trigger OnAction()
                    begin
                        SalesInfoPaneMgt.LookupItem(Rec);
                    end;
                }
            }
        }
        addafter(OpenSpecialPurchaseOrder)
        {
            action("Afficher ligne expédier uniquement")
            {
                Image = Filter;
                ApplicationArea = All;
                ToolTip = 'Executes the Afficher ligne expédier uniquement action.';
                trigger OnAction()
                begin
                    Rec.SETFILTER("Outstanding Quantity", '<>%1', 0);
                end;
            }
            action("Afficher ligne expédier mois en cours")
            {
                Image = Filter;
                ApplicationArea = All;
                ToolTip = 'Executes the Afficher ligne expédier mois en cours action.';
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    StartingDate: Date;
                    EndingDate: Date;

                begin
                    SalesLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
                    StartingDate := CALCDATE('<-CM>', TODAY);
                    EndingDate := CALCDATE('<CM>', TODAY);
                    SalesLine.SETFILTER("Shipment Date", '%1..%2', StartingDate, EndingDate, 0D);
                end;
            }
        }
        //TODO: function FctSetBooResaFTA not found
        // modify("Reserve")
        // {
        //     trigger OnBeforeAction()
        //     var
        //         myInt: Integer;
        //     begin
        //         FctSetBooResaFTA(TRUE);
        //     end;
        // }
    }
    var
        SalesInfoPaneMgt: codeunit "Sales Info-Pane Management";
        BooGOK: Boolean;
        PrepareEnable: Boolean;
        DecGxQuantity: Decimal;
        OptGxPreparationType: enum "Preparation Type";

    trigger OnOpenPage()
    begin
        PrepareOnlyFilter();
    end;

    LOCAL PROCEDURE PrepareOnlyFilter();
    VAR
        UserSetup: Record "User Setup";
    BEGIN
        IF UserSetup.GET(USERID) THEN
            IF UserSetup."Prepared Only" THEN
                rec.SETRANGE(rec.Prepare, TRUE);
    END;
    //TODO: i can't find event in OnAfterGetRecord
}
