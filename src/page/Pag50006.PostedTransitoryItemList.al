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
    SourceTableView = WHERE("Item Base" = FILTER(Transitory | "Transitory Kit"));
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
            // }
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
                TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

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
                field("Item Product Group Code"; REc."Item Product Group Code")
                {
                }
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
        IF CodGVendorNo <> '' THEN
            Rec.SETFILTER("Item Vendor No.", CodGVendorNo)
        ELSE
            Rec.SETRANGE("Item Vendor No.");
        IF CodGProduct <> '' THEN
            Rec.SETFILTER("Item Product Group Code", CodGProduct)
        ELSE
            Rec.SETRANGE("Item Product Group Code");
        IF CodGCategory <> '' THEN
            Rec.SETFILTER("Item Category Code 2", CodGCategory)
        ELSE
            Rec.SETRANGE("Item Category Code 2");
        IF CodGStat <> '' THEN
            Rec.SETFILTER("Item Statistics Group", CodGStat)
        ELSE
            Rec.SETRANGE("Item Statistics Group");
        IF CodGDim <> '' THEN
            Rec.SETFILTER("Shortcut Dimension 1 Code", CodGDim)
        ELSE
            Rec.SETRANGE("Shortcut Dimension 1 Code");
    end;
}

