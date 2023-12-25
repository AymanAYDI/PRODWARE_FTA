namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Purchases.Vendor;
page 50020 "Assignment of the remainders v"
{
    // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // www.prodware.fr
    // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    // 
    // //>>MODIFHL
    // TI302489 DO.GEPO 15/12/2015 : modify OnOpenPage

    Caption = 'Assignment of the remainders';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Sales Line";
    SourceTableView = SORTING("Vendor No.", "No.", "Location Code")
                      WHERE("Document Type" = FILTER(Order),
                            Type = FILTER(Item),
                            "Outstanding Quantity" = FILTER(<> 0));

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
                    StyleExpr = TRUE;
                }
                field("Selected for Order"; Rec."Selected for Order")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
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
            // action("Generate Purchase Order")
            // {
            //     Caption = 'Generate Purchase Order';
            //     Image = Purchasing;
            //     Promoted = true;
            //     PromotedCategory = Process;

            //     trigger OnAction()
            //     var
            //         RecPSalesLine: Record "Sales Line";
            //         RecLItem: Record Item;
            //         RptPGeneratePurchaseOrder: Report "50005";//TODO ->Report Specifique
            //     begin

            //         CLEAR(RptPGeneratePurchaseOrder);
            //         IF CodGVendorNo <> '' THEN
            //             RecPSalesLine.SETFILTER("Vendor No.", CodGVendorNo);
            //         RptPGeneratePurchaseOrder.SETTABLEVIEW(RecPSalesLine);
            //         RptPGeneratePurchaseOrder.RUNMODAL;
            //         CurrPage.UPDATE(FALSE);
            //     end;
            // }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Reserved Quantity");
        Rec."Qty Not Assign FTA" := Rec."Outstanding Quantity" - Rec."Reserved Quantity";
    end;

    trigger OnOpenPage()
    begin
        //>>TI302489
        //FctSelectRecForOrder(Rec);
        //FctSelectRecForOrder2(Rec);
        //<<TI302489
        FctSelection();
        Rec.SETRANGE("Document Type", Rec."Document Type"::Order);
        Rec.CALCFIELDS("Inventory Value Zero");
        Rec.SETRANGE("Inventory Value Zero", FALSE);
    end;

    var
        CodGVendorNo: Code[100];
        BooGSelectLine: Boolean;


    procedure FctSelection()
    begin
        IF CodGVendorNo <> '' THEN
            Rec.SETFILTER("Vendor No.", CodGVendorNo)
        ELSE
            Rec.SETRANGE("Vendor No.");
        IF BooGSelectLine THEN
            Rec.SETRANGE("Selected for Order", TRUE)
        ELSE
            Rec.SETRANGE("Selected for Order");
        CurrPage.KitLines.PAGE.FctShowKitLine(CodGVendorNo, BooGSelectLine);
    end;

    local procedure CodGVendorNoOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
        //CurrForm.UPDATECONTROLS;
    end;

    local procedure BooGSelectLineOnPush()
    begin
        FctSelection();
    end;
}

