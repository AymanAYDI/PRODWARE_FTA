namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Sales.Document;
page 50011 "Kit Line to order"
{
    // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // www.prodware.fr
    // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>MODIFHL
    // TI302489 DO.GEPO 15/12/2015 : modify OnOpenPage

    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Assembly Line";
    SourceTableView = sorting("Remaining Quantity")
                      where("Remaining Quantity" = filter(<> 0));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Level No."; Rec."Level No.")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                // field("No."; Rec."No.")
                // {
                //     Editable = false;
                // }
                field("Item No. 2"; Rec."Item No. 2")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    Editable = false;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    Editable = false;
                }
                field("Qty Not Assign FTA"; Rec."Qty Not Assign FTA")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Qty to be Ordered"; Rec."Qty to be Ordered")
                {
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Selected for Order"; Rec."Selected for Order")
                {
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    Editable = false;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    Editable = false;
                }
                field("Avaibility no reserved"; Rec."Avaibility no reserved")
                {
                    Editable = false;
                }
                field("Kit BOM No."; Rec."Kit BOM No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //>>TI302489
        //FctSelectRecForOrder(Rec);
        Rec.FctSelectRecForOrder2(Rec);
        //<<TI302489
        Rec.FILTERGROUP(0);
        Rec.SETRANGE("Document Type", Rec."Document Type"::Order);
        Rec.CALCFIELDS("Inventory Value Zero");
        Rec.SETRANGE("Inventory Value Zero", false);
        Rec.FILTERGROUP(2);
    end;


    procedure FctShowDocKit()
    var
        RecLSalesHeader: Record "Sales Header";
        RecLAssembletoOrderLink: Record "Assemble-to-Order Link";
    begin
        //>>MIG NAV 2015 : Update OLD Code
        if RecLAssembletoOrderLink.GET(Rec."Document Type", Rec."Document No.") then begin
            RecLSalesHeader.SETRANGE("Document Type", RecLAssembletoOrderLink."Document Type");
            RecLSalesHeader.SETRANGE("No.", RecLAssembletoOrderLink."Document No.");
            if RecLAssembletoOrderLink."Document Type" = RecLAssembletoOrderLink."Document Type"::Order then
                page.RUNMODAL(Page::"Sales Order", RecLSalesHeader);
            if RecLAssembletoOrderLink."Document Type" = RecLAssembletoOrderLink."Document Type"::Invoice then
                page.RUNMODAL(Page::"Sales Invoice", RecLSalesHeader);
        end;
        //<<MIG NAV 2015 : Update OLD Code
    end;


    procedure FctShowKitLine(var CodPVendorNo: Code[20]; var BooPSelectLine: Boolean)
    begin
        if CodPVendorNo <> '' then
            Rec.SETFILTER("Vendor No.", CodPVendorNo)
        else
            Rec.SETRANGE("Vendor No.");
        if BooPSelectLine then
            Rec.SETRANGE(Rec."Selected for Order", true)
        else
            Rec.SETRANGE("Selected for Order");
        CurrPage.UPDATE(false);
    end;
}

