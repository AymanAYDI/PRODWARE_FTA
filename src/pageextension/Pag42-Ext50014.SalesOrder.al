namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Sales.Comment;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Reporting;
pageextension 50014 "SalesOrder" extends "Sales Order" //42
{
    layout
    {
        modify("Sell-to Contact")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Caption = 'Posting Date';
        }
        modify("Order Date")
        {
            Caption = 'Order Date';
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Enabled = false;
        }
        modify("Shipping Agent Code")
        {
            Visible = false;
        }
        // addafter("Sell-to Customer Name")
        // {
        //     field("Customer India Product";rec."Customer India Product")
        //     {

        //     }
        // }
        addafter("Promised Delivery Date")
        {
            // field("Order Shipment Date";rec."Order Shipment Date")
            // {

            // }
        }
        addafter("Salesperson Code")
        {
            // field("Mobile Salesperson Code";rec."Mobile Salesperson Code")
            // {

            // }
        }
        addafter(Status)
        {

            // field("Franco Amount";rec."Franco Amount")
            // {

            // }
            // field("Desc. Shipment Method";rec."Desc. Shipment Method")
            // {

            // }
            // field("Total Parcels";rec."Total Parcels")
            // {

            // }
            // field("Total weight";rec."Total weight")
            // {

            // }
            // field("Fax No.";rec."Fax No.")
            // {

            // }
            //  field("E-Mail";rec."E-Mail")
            // {

            // }
            //  field("Subject Mail";rec."Subject Mail")
            // {

            // }
            //  field(Preparer;rec.Preparer)
            // {

            // }
            //  field(Assembler;rec.Assembler)
            // {

            // }
            //     field(Packer;rec.Packer)
            // {

            // }
            //     field("Auto AR Blocked";rec."Auto AR Blocked")
            // {

            // }
            //     field("Show Comment AR";rec."Show Comment AR")
            // {

            // }
            //     field("Workshop File";rec."Workshop File")
            // {

            // }
            //     field("Equipment Loans";rec."Equipment Loans")
            // {

            // }
        }
        addafter("Prepmt. Pmt. Discount Date")
        {
            group(Transport)
            {
                // field("Shipping Order No."; rec."Shipping Order No.")
                // {

                // }
                // field("Shipping Agent Name"; rec."Shipping Agent Name")
                // {

                // }
                // field("Planned Shipment Date" ; rec."Planned Shipment Date" )
                // {

                // }
            }
        }
        addafter(Control1906127307)
        {
            //TODO: page 50014 not migrated yet
            // part("Sales Order total"; "Sales Order total")
            // {
            //     SubPageLink = "Document Type" = field("Document Type"),
            //                   "Document No." = field("Document No."),
            //                   "Line No." = field("Line No.");
            //     PagePartID =Page 50014;
            //     ProviderID =58;
            //     Visible = TRUE;
            //     PartType =Page;

            // }
        }

    }
    actions
    {
        modify("Co&mments")
        {
            Visible = false;
        }
        modify("Reopen")
        {
            trigger OnAfterAction()
            begin
                OpenComment();
            end;
        }
        modify(CopyDocument)
        {
            Visible = false;
        }
        modify("Work Order")
        {
            Visible = false;
        }
        addafter("Co&mments")
        {
            action("Action1100267029")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                trigger OnAction()
                var
                    SalesCommentLine: Record "Sales Comment Line";
                    SalesCommentSheet: Page "Sales Comment Sheet";
                begin
                    SalesCommentLine.RESET();
                    SalesCommentLine.SETRANGE("Document Type", rec."Document Type");
                    SalesCommentLine.SETRANGE("No.", rec."No.");
                    SalesCommentLine.SETRANGE("Document Line No.", 0);
                    //TODO: page Sales comment sheet not migrated yet
                    // SalesCommentSheet.AddNewComment(rec."Document Type", rec."No.");
                    SalesCommentSheet.SETTABLEVIEW(SalesCommentLine);
                    SalesCommentSheet.RUN();
                end;
            }
        }
        addfirst("&Print")
        {
            action(Action1100267032)
            {
                Caption = 'Assembly Order';
                Image = Print;
                trigger OnAction()
                var
                    //TODO: codeunit not migrated yet
                    //CduLPrintPDF: Codeunit 50006;
                    RecLSalesLine: Record "Sales Line";
                    RecLItem: Record Item;
                begin
                    // TODO: table sales header not migrated yet
                    //DocPrint.PrintSalesOrder(Rec, rec.Usage::"Work Order");
                end;

            }
            action(Action1100267027)
            {
                Caption = 'Preparatory Delivery';
                Image = Print;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader := Rec;
                    SalesHeader.SETRECFILTER();
                    REPORT.RUNMODAL(50011, true, false, SalesHeader);
                end;
            }
            action(Action225)
            {
                Caption = 'Assembly Order';
                Image = Print;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    //  DocPrint.PrintSalesOrder(Rec,Usage::"Work Order");
                    SalesHeader := Rec;
                    SalesHeader.SETRECFILTER();
                    REPORT.RUNMODAL(50011, true, false, SalesHeader);
                end;
            }
        }
        addafter("Pick Instruction")
        {
            action(Action1100267019)
            {
                Caption = 'Proforma';
                trigger OnAction()
                var
                    RecLOrder: Record "Sales Header";
                begin
                    RecLOrder.RESET();
                    RecLOrder := Rec;
                    RecLOrder.SETRECFILTER();
                    REPORT.RUNMODAL(50080, true, false, RecLOrder);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        GetRecordLinkExist();
    end;

    trigger OnClosePage()
    var
        ReleaseSalesDocument: Codeunit "Release Sales Document";
    begin
        ReleaseSalesDocument.PerformManualRelease(Rec);
    end;

    var
        DocPrint: Codeunit "Document-Print";

    LOCAL PROCEDURE GetRecordLinkExist();
    VAR
        TxtCst001: Label 'Il existe des liens pour ce document.';
    BEGIN
        IF Rec.HASLINKS THEN
            MESSAGE(TxtCst001, Rec."No.");
    END;

    local procedure OpenComment();
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentSheet: Page "Sales Comment Sheet";
    begin
        SalesCommentLine.RESET();
        SalesCommentLine.SETRANGE("Document Type", rec."Document Type");
        SalesCommentLine.SETRANGE("No.", rec."No.");
        SalesCommentLine.SETRANGE("Document Line No.", 0);
        // SalesCommentSheet.AddNewComment(rec."Document Type", rec."No.");
        SalesCommentSheet.SETTABLEVIEW(SalesCommentLine);
        if not SalesCommentLine.ISEMPTY then
            SalesCommentSheet.RUN();
    end;
}
