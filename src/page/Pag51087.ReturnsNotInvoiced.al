namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Sales.History;
using Microsoft.Inventory.Tracking;
page 51087 "Returns Not Invoiced"
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

    Caption = 'Sales Returns Not Invoiced';
    Editable = true;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Document Type", "Document No.", "Line No.")
                      where("Document Type" = FILTER("Return Order"),
                            "Return Qty. Rcd. Not Invd." = FILTER(<> 0));
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
                }
                field("Posting Date"; RecGSalesHeader."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Visible = true;
                }
                field(Name; RecGCostumer.Name)
                {
                    Caption = 'Nom client facturé';
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Visible = false;
                }
                field("Return Qty. Received"; Rec."Return Qty. Received")
                {
                }
                field("Return Qty. to Receive"; Rec."Return Qty. to Receive")
                {
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                }
                field(DecGQteReturnRestante; DecGQteReturnRestante)
                {
                    Caption = 'Remaining Return quantity';
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
                action("Show Document")
                {
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F5';

                    trigger OnAction()
                    begin
                        RecGSalesHeader.SETRANGE("No.", Rec."Document No.");
                        IF RecGSalesHeader.FINDFIRST() THEN
                            page.RUN(page::"Sales Return Order", RecGSalesHeader);
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData 348 = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

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

                    trigger OnAction()
                    begin
                        Rec.OpenItemTrackingLines();
                    end;
                }
            }
        }
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    //REPORT.RUN(REPORT::"Credit Memo to Emit",TRUE,FALSE,Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecGSalesHeader.SETRANGE("No.", Rec."Document No.");
        RecGSalesHeader.FINDFIRST();
        RecGCostumer.GET(Rec."Bill-to Customer No.");
        DecGQteReturnRestante := ROUND(Rec."Return Qty. Received" - Rec."Quantity Invoiced");
    end;

    var
        RecGSalesHeader: Record "Sales Header";
        RecGReturnReceiptHeader: Record "Return Receipt Header";
        RecGCostumer: Record Customer;
        CduGItemTrackingMgt: codeunit "Item Tracking Management";
        Text100: Label 'You can select only one customer. Make you order correctly.';

        DecGQteReturnRestante: Decimal;

    local procedure IsFirstDocLine(): Boolean
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
    end;
}

