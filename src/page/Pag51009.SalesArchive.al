namespace Prodware.FTA;

using Microsoft.Sales.Archive;
page 51009 "Sales Archive"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>EASY1.00
    // NAVEASY:NI 20/06/2008 [Archivage_Cde]
    //                           - Create Form
    // 
    // NAVEASY:NI 20/06/2008 [Archivage_Devis]
    //                           - Using Form
    // 
    // ------------------------------------------------------------------------

    Caption = 'Sales Archive List';
    DataCaptionFields = "Document Type";
    Editable = false;
    PaGetype = List;
    SourceTable = "Sales Line Archive";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the value of the Shipment Date field.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ToolTip = 'Specifies the value of the Outstanding Quantity field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the value of the Line Discount % field.';
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
                action("Show Card")
                {
                    Caption = 'Show Card';
                    Image = Card;
                    ShortCutKey = 'Shift+F5';
                    ToolTip = 'Executes the Show Card action.';
                    trigger OnAction()
                    var
                        RecLSalesHeadArch: Record "Sales Header Archive";
                    begin
                        RecLSalesHeadArch.Reset();
                        RecLSalesHeadArch.SetRange("Document Type", Rec."Document Type");
                        RecLSalesHeadArch.SetRange("No.", Rec."Document No.");
                        if RecLSalesHeadArch.findFirst() then
                            case Rec."Document Type" of
                                Rec."Document Type"::Order:
                                    PAGE.Run(PAGE::"Sales Order Archive", RecLSalesHeadArch);
                                Rec."Document Type"::Quote:
                                    PAGE.Run(PAGE::"Sales Quote Archive", RecLSalesHeadArch);
                            end;
                    end;
                }
            }
        }
    }
}

