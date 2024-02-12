namespace Prodware.FTA;

using Microsoft.Purchases.Document;

pageextension 50024 PurchaseOrderSubform extends "Purchase Order Subform" //54
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:MA 25/06/2008: [Cde_Transport]
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Item Management : Pricing
    //                           - Add code in OnDelete

    // AutoSplitKey = true;
    // Caption = 'Lines';
    // DelayedInsert = true;
    // LinksAllowed = false;
    // MultipleNewLines = true;
    // PaGetype = ListPart;
    // SourceTable = "Purchase Line";
    // SourceTableView = WHERE("Document Type"=FILTER(Order));

    layout
    {
        addafter("No.")
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Item No. field.';
            }
        }
        moveafter("IC Partner Code"; "Gen. Prod. Posting Group")
        moveafter("IC Partner Reference"; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; "VAT Bus. Posting Group")
        // addafter("Direct Unit Cost")
        // {
        //     field("Initial Order No."; Rec."Initial Order No.")
        //     {
        //         Visible = false;
        //     }
        // }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Requested Receipt Date")
        {
            Visible = true;
        }
        modify("Promised Receipt Date")
        {
            Visible = true;
        }
        modify("Planned Receipt Date")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Order Date")
        {
            Visible = false;
        }
    }

    trigger OnDeleteRecord(): Boolean //TODO
    var
    //     ReservePurchLine: Codeunit "Purch. Line-Reserve";
    //     DocumentTotals: Codeunit 57;
    begin
        //     // >>FED_20090415:PA
        Rec.CalcFields("Reserved Quantity");
        Rec.TestField("Reserved Quantity", 0);
        //     // >>FED_20090415:PA
        //     DocumentTotals.PurchaseDocTotalsNotUpToDate();
        //     if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
        //              Commit();
        //         if not ReservePurchLine.DeleteLineConfirm(Rec) then
        //             exit(false);
        //         ReservePurchLine.DeleteLine(Rec);
        //     end;
    end;
}

