namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
page 50007 "Assignment of the remainders"
{
    // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // www.prodware.fr
    // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>MODIFHL
    // TI302489 DO.GEPO 15/12/2015 : Modify OnOpenPage
    // 
    // TI302489 DO.ALMI 08/03/2016 : OnOpen Page launch FctSelectRecForOrder3

    Caption = 'Assignment of the remainders';
    DeleteAllowed = false;
    InsertAllowed = false;
    PaGetype = Worksheet;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Vendor No.", "No.", "Location Code") where("Document Type" = filter(Order), Type = filter(Item), "Outstanding Quantity" = filter(<> 0));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(CodGVendorNo; CodGVendorNo)
            {
                Caption = 'Item Vendor No.';
                TableRelation = Vendor;

                trigger OnValidate()
                begin
                    FctSelection();
                    CodGVendorNoOnAfterValidate();
                end;
            }
            field(BooGSelectLine; BooGSelectLine)
            {
                Caption = 'Selected line for Order';

                trigger OnValidate()
                begin
                    BooGSelectLineOnPush();
                end;
            }
            repeater("Lignes de documents")
            {
                Caption = 'Lignes de documents';
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
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Item No.2"; Rec."Item No.2")
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
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Item Base"; Rec."Item Base")
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    Editable = false;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    Editable = false;
                }
                field("Qty Not Assign FTA"; Rec."Qty Not Assign FTA")
                {
                    Caption = 'Qty. to Assign';
                    Visible = false;
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
                // field("Requested Receipt Date"; "Requested Receipt Date")
                // {
                //     Style = Strong;
                //     StyleExpr = TRUE;
                // }
                field("Item Lead Time Calculation"; Rec."Item Lead Time Calculation")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    Editable = false;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    Editable = false;
                }
            }
            part(KitLines; "Kit Line to order")
            {
                Caption = 'Kits Lines';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Kit Document")
            {
                Caption = 'Kit Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecLSalesHeader: Record "Sales Header";
                begin
                    CurrPage.KitLines.PAGE.FctShowDocKit();
                end;
            }
            action("Generate Purchase Order")
            {
                Caption = 'Generate Purchase Order';
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecPSalesLine: Record "Sales Line";
                    RecLItem: Record "Item";
                    RptPGeneratePurchaseOrder: Report "Generate Purchase Order";
                begin

                    Clear(RptPGeneratePurchaseOrder);
                    if CodGVendorNo <> '' then
                        RecPSalesLine.SetFilter("Vendor No.", CodGVendorNo);
                    RptPGeneratePurchaseOrder.SetTableView(RecPSalesLine);
                    RptPGeneratePurchaseOrder.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Reserved Quantity");
        Rec."Qty Not Assign FTA" := Rec."Outstanding Quantity" - Rec."Reserved Quantity";
    end;

    trigger OnOpenPage()
    begin
        //>>TI302489
        //FctSelectRecForOrder(Rec);
        //FctSelectRecForOrder2(Rec);
        Rec.FctSelectRecForOrder3(Rec);
        //<<TI302489
        FctSelection();
        Rec.SetRange("Document Type", Rec."Document Type"::Order);
        Rec.CalcFields("Inventory Value Zero");
        Rec.SetRange("Inventory Value Zero", false);
    end;

    var
        CodGVendorNo: Code[100];
        BooGSelectLine: Boolean;

    procedure FctSelection()
    begin
        if CodGVendorNo <> '' then
            Rec.SetFilter(Rec."Vendor No.", CodGVendorNo)
        else
            Rec.SetRange(Rec."Vendor No.");
        if BooGSelectLine then
            Rec.SetRange("Selected for Order", true)
        else
            Rec.SetRange("Selected for Order");
        CurrPage.KitLines.PAGE.FctShowKitLine(CodGVendorNo, BooGSelectLine);
    end;

    local procedure CodGVendorNoOnAfterValidate()
    begin
        CurrPage.Update(false);
        //CurrForm.UPDATECONTROLS;
    end;

    local procedure BooGSelectLineOnPush()
    begin
        FctSelection();
    end;
}

