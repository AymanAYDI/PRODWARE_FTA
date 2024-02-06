namespace Prodware.FTA;

using Microsoft.Sales.History;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
using Microsoft.Finance.Dimension;
page 50006 "Posted Transitory Item List"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Kit Build up or remove into pieces
    //                              - Creation

    Caption = 'Posted Transitory Item List';
    PageType = List;
    SourceTable = "Sales Invoice Line";
    SourceTableView = where("Item Base" = filter(Transitory | "Transitory Kit"));
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
                end;
            }
            field(CodGCategory; CodGCategory)
            {
                Caption = 'Item Category Code';
                TableRelation = "Item Category";

                trigger OnValidate()
                begin
                    FctSelection();
                end;
            }
            // field(CodGProduct; CodGProduct)
            // {
            //     Caption = 'Item Product Group Code';
            //     TableRelation = "Product Group";

            //     trigger OnValidate()
            //     begin
            //         FctSelection();
            //     end;
            // } //TODO -> Table Removed
            field(CodGStat; CodGStat)


            {
                Caption = 'Item Statistics Group';

                trigger OnValidate()
                begin
                    FctSelection();
                end;
            }
            field(CodGDim; CodGDim)
            {
                Caption = 'Item Type';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

                trigger OnValidate()
                begin
                    FctSelection();
                end;
            }
            repeater(Repeater)
            {
                Editable = false;
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Item No. 2"; Rec."Item No. 2")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Item Description 2"; Rec."Item Description 2")
                {
                }
                field("Item Statistics Group"; Rec."Item Statistics Group")
                {
                }
                field("Item Vendor No."; Rec."Item Vendor No.")
                {
                }
                field("Item Category Code 2"; Rec."Item Category Code 2")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                // field("Item Product Group Code"; Rec."Item Product Group Code")
                // {
                // }
            }
        }
    }

    actions
    {
    }

    var
        CodGVendorNo: Code[100];
        CodGProduct: Code[100];
        CodGCategory: Code[100];
        CodGStat: Code[100];
        CodGDim: Code[100];

    procedure FctSelection()
    begin
        if CodGVendorNo <> '' then
            Rec.SETFILTER("Item Vendor No.", CodGVendorNo)
        else
            Rec.SETRANGE("Item Vendor No.");
        if CodGProduct <> '' then
            Rec.SETFILTER("Item Category Code", CodGProduct)
        else
            Rec.SETRANGE("Item Category Code");
        if CodGCategory <> '' then
            Rec.SETFILTER("Item Category Code 2", CodGCategory)
        else
            Rec.SETRANGE("Item Category Code 2");
        if CodGStat <> '' then
            Rec.SETFILTER("Item Statistics Group", CodGStat)
        else
            Rec.SETRANGE("Item Statistics Group");
        if CodGDim <> '' then
            Rec.SETFILTER("Shortcut Dimension 1 Code", CodGDim)
        else
            Rec.SETRANGE("Shortcut Dimension 1 Code");
    end;
}

