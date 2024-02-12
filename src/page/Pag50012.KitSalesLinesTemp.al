namespace Prodware.FTA;

using Microsoft.Assembly.Document;
using Microsoft.Assembly.Comment;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Availability;
using Microsoft.Sales.Document;
using System.Globalization;
using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Location;
page 50012 "Kit Sales Lines Temp"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Kit Build up or remove into pieces
    // 
    //                     - Creation from the form 25002
    //                     - The table displays is temporary
    //                       ===============================
    //                     -Display "Level No.", "Kit Action","x Quantity per","Shipment Date"
    //                     -Add code in OnAfterGetRecord
    //                     -Add in Button Line a MenuItem Cas d'emploi

    AutoSplitKey = true;
    Caption = 'Assemble-to-Order Lines';
    DataCaptionExpression = GetCaption();
    DelayedInsert = true;
    PaGetype = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Assembly Line";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Level No."; Rec."Level No.")
                {
                    ToolTip = 'Specifies the value of the Level No. field.';
                }
                field(Kit; Rec.Kit)
                {
                    ToolTip = 'Specifies the value of the Kit field.';
                }
                field("Kit Action"; Rec."Kit Action")
                {
                    ToolTip = 'Specifies the value of the Kit Action field.';
                    trigger OnValidate()
                    var
                        RecLATOLink: Record "Assemble-to-Order Link";
                        IntLDocumentLineNo: Integer;
                        IntLLineNo: Integer;
                        BoolEndLoop: Boolean;

                    begin
                        CurrPage.SaveRecord();
                        IntLDocumentLineNo := Rec."Line No.";
                        IntLLineNo := Rec."Line No.";
                        case Rec."Kit Action" of
                            Rec."Kit Action"::Assembly:
                                if RecLATOLink.Get(Rec."Document Type", Rec."Document No.") then
                                    KitLine.Get(RecLATOLink."Document Type", RecLATOLink."Document No.", RecLATOLink."Document Line No.");

                            Rec."Kit Action"::Disassembly:
                                if RecLATOLink.Get(Rec."Document Type", Rec."Document No.") then
                                    KitLine.Get(RecLATOLink."Document Type", RecLATOLink."Document No.", RecLATOLink."Document Line No.");
                        end;
                        //CurrForm.Update(FALSE);
                        BoolEndLoop := false;
                        if Rec.FindSet() then
                            repeat
                                if IntLLineNo = Rec."Line No." then
                                    BoolEndLoop := true;
                            until (Rec.Next() = 0) or (BoolEndLoop = true);
                        Rec.Next(-1);
                        //IF Get("Document Type","Document No.",IntLDocumentLineNo,IntLLineNo) THEN;
                        CurrPage.Update(false);
                    end;
                }
                field("Avail. Warning"; Rec."Avail. Warning")
                {
                    BlankZero = true;
                    DrillDown = true;
                    ToolTip = 'Specifies the value of the Avail. Warning field.';
                    trigger OnDrillDown()
                    begin
                        //Rec.ShowAvailabilityWarning();
                        ShowAvailabilityWarning2();
                    end;
                }
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
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Avaibility no reserved"; Rec."Avaibility no reserved")
                {
                    ToolTip = 'Specifies the value of the Avaibility no reserved field.';
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ToolTip = 'Specifies the value of the Quantity per field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ToolTip = 'Specifies the value of the Reserved Quantity field.';
                }
                field("Consumed Quantity"; Rec."Consumed Quantity")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Consumed Quantity field.';
                }
                field("Qty. Picked"; Rec."Qty. Picked")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Qty. Picked field.';
                }
                field("Pick Qty."; Rec."Pick Qty.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pick Qty. field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Lead-Time Offset"; Rec."Lead-Time Offset")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Lead-Time Offset field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Bin Code field.';
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Inventory Posting Group field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ToolTip = 'Specifies the value of the Cost Amount field.';
                }
                field("Kit Qty Available by Assembly"; Rec."Kit Qty Available by Assembly")
                {
                    ToolTip = 'Specifies the value of the Kit Qty Available by Assembly field.';
                }
                field("x Quantity per"; Rec."x Quantity per")
                {
                    ToolTip = 'Specifies the value of the x Quantity per field.';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.';
                }
                field("Resource Usage Type"; Rec."Resource Usage Type")
                {
                    ToolTip = 'Specifies the value of the Resource Usage Type field.';
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Appl.-to Item Entry field.';
                }
                field("Appl.-from Item Entry"; Rec."Appl.-from Item Entry")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Appl.-from Item Entry field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Reserve")
            {
                Caption = '&Reserve';
                Ellipsis = true;
                Image = LineReserve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Reserve action.';
                trigger OnAction()
                begin
                    Rec.ShowReservation();
                end;
            }
            action("Select Item Substitution")
            {
                Caption = 'Select Item Substitution';
                Image = SelectItemSubstitution;
                ToolTip = 'Executes the Select Item Substitution action.';
                trigger OnAction()
                begin
                    Rec.ShowItemSub();
                    CurrPage.Update();
                end;
            }
            action("Explode BOM")
            {
                Caption = 'Explode BOM';
                Image = ExplodeBOM;
                ToolTip = 'Executes the Explode BOM action.';
                trigger OnAction()
                begin
                    Rec.ExplodeAssemblyList();
                    CurrPage.Update();
                end;
            }
            action("Assembly BOM")
            {
                Caption = 'Assembly BOM';
                Image = BulletList;
                ToolTip = 'Executes the Assembly BOM action.';
                trigger OnAction()
                begin
                    Rec.ShowAssemblyList();
                end;
            }
            action("Create Inventor&y Movement")
            {
                Caption = 'Create Inventor&y Movement';
                Ellipsis = true;
                Image = CreatePutAway;
                ToolTip = 'Executes the Create Inventor&y Movement action.';
                trigger OnAction()
                var
                    AssemblyHeader: Record "Assembly Header";
                    ATOMovementsCreated: Integer;
                    TotalATOMovementsToBeCreated: Integer;
                begin
                    AssemblyHeader.Get(Rec."Document Type", Rec."Document No.");
                    AssemblyHeader.CreateInvtMovement(false, false, false, ATOMovementsCreated, TotalATOMovementsToBeCreated);
                end;
            }
        }
        area(navigation)
        {
            action("Show Document")
            {
                Caption = 'Show Document';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Show Document action.';
                trigger OnAction()
                var
                    ATOLink: Record "Assemble-to-Order Link";
                    SalesLine: Record "Sales Line";
                begin
                    ATOLink.Get(Rec."Document Type", Rec."Document No.");
                    SalesLine.Get(ATOLink."Document Type", ATOLink."Document No.", ATOLink."Document Line No.");
                    ATOLink.ShowAsm(SalesLine);
                end;
            }
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'Executes the Dimensions action.';
                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
            action("Item &Tracking Lines")
            {
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+I';
                ToolTip = 'Executes the Item &Tracking Lines action.';
                trigger OnAction()
                begin
                    Rec.OpenItemTrackingLines();
                end;
            }
            group("Item Availability by")
            {
                Caption = 'Item Availability by';
                Image = ItemAvailability;
                action("Event")
                {
                    Caption = 'Event';
                    Image = "Event";
                    ToolTip = 'Executes the Event action.';
                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec, ItemAvailFormsMgt.ByEvent());
                    end;
                }
                action(Period)
                {
                    Caption = 'Period';
                    Image = Period;
                    ToolTip = 'Executes the Period action.';
                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec, ItemAvailFormsMgt.ByPeriod());
                    end;
                }
                action(Variant)
                {
                    Caption = 'Variant';
                    Image = ItemVariant;
                    ToolTip = 'Executes the Variant action.';
                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec, ItemAvailFormsMgt.ByVariant());
                    end;
                }
                action(Location)
                {
                    AccessByPermission = TableData Location = R;
                    Caption = 'Location';
                    Image = Warehouse;
                    ToolTip = 'Executes the Location action.';
                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec, ItemAvailFormsMgt.ByLocation());
                    end;
                }
                action("BOM Level")
                {
                    Caption = 'BOM Level';
                    Image = BOMLevel;
                    ToolTip = 'Executes the BOM Level action.';
                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec, ItemAvailFormsMgt.ByBOM());
                    end;
                }
            }
            action(Comments)
            {
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = Page "Assembly Comment Sheet";
                RunPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Document Line No." = field("Line No.");
                ToolTip = 'Executes the Comments action.';
            }
            action(ShowWarning)
            {
                Caption = 'Show Warning';
                Image = ShowWarning;
                ToolTip = 'Executes the Show Warning action.';
                trigger OnAction()
                begin
                    // Rec.ShowAvailabilityWarning();
                    ShowAvailabilityWarning2();
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        RecLItem: Record "Item";
        RecLATOLink: Record "Assemble-to-Order Link";
    begin
        Rec.UpdateAvailWarning();

        //>>FED_20090415:PA 15/04/2009
        if Rec.Type = Rec.Type::Item then
            if RecLItem.Get(Rec."No.") then begin
                //OLD RecLItem.SetRange("Date Filter","Shipment Date");
                RecLItem.SetRange("Date Filter", Rec."Due Date");
                if Rec."Location Code" <> '' then
                    RecLItem.SetFilter("Location Filter", Rec."Location Code");
                //PAMO RecLItem.CalcFields(Inventory,"Reserved Qty. on Inventory");
                //PAMO "Avaibility no reserved" := RecLItem.Inventory - RecLItem."Reserved Qty. on Inventory";
                //>>FED_20090415:PA 15/04/2009
                RecLItem.CalcFields(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders");
                Rec."Avaibility no reserved" := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + RecLItem."Qty. on Asm. Component")
                           + RecLItem."Reserved Qty. on Purch. Orders" + Rec."Remaining Quantity (Base)";
                //<<FED_20090415:PA 15/04/2009

            end;
        //<<FED_20090415:PA 15/04/2009
    end;

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyLineReserve: codeunit "Assembly Line-Reserve";
    begin
        if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
            Commit();
            if not AssemblyLineReserve.DeleteLineConfirm(Rec) then
                exit(false);
            AssemblyLineReserve.DeleteLine(Rec);
        end;
    end;

    var
        KitLine: Record "Sales Line";
        ItemAvailFormsMgt: codeunit "Item Availability Forms Mgt";

    local procedure GetCaption(): Text[250]
    var
        ObjTransln: Record "Object Translation";
        AsmHeader: Record "Assembly Header";
        Text001: Label '%1 %2 %3', comment = '%1=SourceTableName ,%2=SourceFilter ,%3=Description';
        SourceTableName: Text[250];
        SourceFilter: Text[200];
        Description: Text[100];
    begin
        Description := '';

        if AsmHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            SourceTableName := ObjTransln.TranslateObject(ObjTransln."Object Type"::table, 27);
            SourceFilter := AsmHeader."Item No.";
            Description := AsmHeader.Description;
        end;
        exit(StrSubstNo(Text001, SourceTableName, SourceFilter, Description));
    end;


    procedure ShowAvailabilityWarning2()
    var
        AssemblyHeader: Record "Assembly Header";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
    begin
        Rec.TestField(Type, Rec.Type::Item);

        if Rec."Due Date" = 0D then begin
            Rec.GetHeader();
            AssemblyHeader.Get(Rec."Document Type", Rec."Document No.");
            if AssemblyHeader."Due Date" <> 0D then
                Rec.Validate("Due Date", AssemblyHeader."Due Date")
            else
                Rec.Validate("Due Date", WorkDate());
        end;

        ItemCheckAvail.AssemblyLineCheck(Rec);
    end;
}

