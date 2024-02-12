namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Sales.Comment;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Reporting;
pageextension 50014 "SalesOrder" extends "Sales Order" //42
{
    layout
    {
        Modify("Sell-to Contact")
        {
            Visible = false;
        }
        Modify("Posting Date")
        {
            Caption = 'Posting Date';
        }
        Modify("Order Date")
        {
            Caption = 'Order Date';
        }
        Modify("Document Date")
        {
            Visible = false;
        }
        Modify("Campaign No.")
        {
            Visible = false;
        }
        Modify("Responsibility Center")
        {
            Visible = false;
        }
        Modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        Modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        Modify("Prices Including VAT")
        {
            Visible = false;
        }
        Modify("Shipment Method Code")
        {
            Enabled = false;
        }
        Modify("Shipping Agent Code")
        {
            Visible = false;
        }
        addafter("Sell-to Customer Name")
        {
            field("Customer India Product"; rec."Customer India Product")
            {

            }
        }
        addafter("Promised Delivery Date")
        {
            field("Order Shipment Date"; rec."Order Shipment Date")
            {

            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {

            }
        }
        addafter(Status)
        {

            field("Franco Amount"; rec."Franco Amount")
            {

            }
            field("Desc. Shipment Method"; rec."Desc. Shipment Method")
            {

            }
            field("Total Parcels"; rec."Total Parcels")
            {

            }
            field("Total weight"; rec."Total weight")
            {

            }
            field("Fax No."; rec."Fax No.")
            {

            }
            field("E-Mail"; rec."E-Mail")
            {

            }
            field("Subject Mail"; rec."Subject Mail")
            {

            }
            field(Preparer; rec.Preparer)
            {

            }
            field(Assembler; rec.Assembler)
            {

            }
            field(Packer; rec.Packer)
            {

            }
            field("Auto AR Blocked"; rec."Auto AR Blocked")
            {

            }
            field("Show Comment AR"; rec."Show Comment AR")
            {

            }
            field("Workshop File"; rec."Workshop File")
            {

            }
            field("Equipment Loans"; rec."Equipment Loans")
            {

            }
        }
        addafter("Prepmt. Pmt. Discount Date")
        {
            group(Transport)
            {
                field("Shipping Order No."; rec."Shipping Order No.")
                {

                }
                field("Shipping Agent Name"; rec."Shipping Agent Name")
                {

                }
                field("Planned Shipment Date"; rec."Planned Shipment Date")
                {

                }
            }
        }
        addafter(Control1906127307)
        {
            part("Sales Order total"; "Sales Order total")
            {
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                            "Line No." = field("Line No.");
                Provider = SalesLines;
                Visible = true;
                UpdatePropagation = Both;
                ShowFilter = true;
            }
        }

    }
    actions
    {
        Modify("Co&mments")
        {
            Visible = false;
        }
        Modify("Reopen")
        {
            trigger OnAfterAction()
            begin
                OpenComment();
            end;
        }
        Modify(CopyDocument)
        {
            Visible = false;
        }
        Modify("Work Order")
        {
            Visible = false;
        }
        addafter("Co&mments")
        {
            action("Action1100267029")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                ApplicationArea = All;
                ToolTip = 'Executes the Co&mments action.';
                trigger OnAction()
                var
                    SalesCommentLine: Record "Sales Comment Line";
                    SalesCommentSheet: Page "Sales Comment Sheet";
                begin
                    SalesCommentLine.Reset();
                    SalesCommentLine.SetRange("Document Type", rec."Document Type");
                    SalesCommentLine.SetRange("No.", rec."No.");
                    SalesCommentLine.SetRange("Document Line No.", 0);
                    //TODO: procedure AddNewComment removed ... maybe -> SetUpNewLine
                    // SalesCommentSheet.AddNewComment(rec."Document Type", rec."No.");
                    SalesCommentSheet.SetTableView(SalesCommentLine);
                    SalesCommentSheet.Run();
                end;
            }
        }
        addfirst("&Print")
        {
            action("Assembly Order")
            {
                Caption = 'Assembly Order';
                Image = Print;
                ApplicationArea = All;
                ToolTip = 'Executes the Assembly Order action.';
                trigger OnAction()
                begin
                    DocPrint.PrintSalesOrder(Rec, Usage::"Work Order");
                end;

            }
            action("Preparatory Delivery")
            {
                Caption = 'Preparatory Delivery';
                Image = Print;
                ApplicationArea = All;
                ToolTip = 'Executes the Preparatory Delivery action.';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader := Rec;
                    SalesHeader.SetRecFilter();
                    REPORT.RunModal(50011, true, false, SalesHeader);
                end;
            }
            action(Action225)
            {
                Caption = 'Assembly Order';
                Image = Print;
                ApplicationArea = All;
                ToolTip = 'Executes the Assembly Order action.';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    DocPrint.PrintSalesOrder(Rec, Usage::"Work Order");
                    SalesHeader := Rec;
                    SalesHeader.SetRecFilter();
                    REPORT.RunModal(50011, true, false, SalesHeader);
                end;
            }
        }
        addafter("Pick Instruction")
        {
            action(Action1100267019)
            {
                Caption = 'Proforma';
                ApplicationArea = All;
                ToolTip = 'Executes the Proforma action.';
                trigger OnAction()
                var
                    RecLOrder: Record "Sales Header";
                begin
                    RecLOrder.Reset();
                    RecLOrder := Rec;
                    RecLOrder.SetRecFilter();
                    REPORT.RunModal(Report::"Sales - PROFORMA FTA", true, false, RecLOrder);
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
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";

    local procedure GetRecordLinkExist();
    var
        TxtCst001: Label 'Il existe des liens pour ce document.';
    begin
        if Rec.HASLINKS then
            Message(TxtCst001, Rec."No.");
    end;

    local procedure OpenComment();
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentSheet: Page "Sales Comment Sheet";
    begin
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", rec."Document Type");
        SalesCommentLine.SetRange("No.", rec."No.");
        SalesCommentLine.SetRange("Document Line No.", 0);
        // SalesCommentSheet.AddNewComment(rec."Document Type", rec."No.");
        SalesCommentSheet.SetTableView(SalesCommentLine);
        if not SalesCommentLine.IsEmpty then
            SalesCommentSheet.Run();
    end;
}
