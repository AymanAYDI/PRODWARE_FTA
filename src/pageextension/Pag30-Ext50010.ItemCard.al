namespace Prodware.FTA;

using Microsoft.Inventory.Item;
using Microsoft.Manufacturing.StandardCost;
using Microsoft.Manufacturing.ProductionBOM;
pageextension 50010 ItemCard extends "Item Card" //30
{
    //TODO: SourceTableView cannot be customized
    //SourceTableView=SORTING(Search Description);
    layout
    {
        modify("Created From Nonstock Item")
        {
            Visible = false;
        }

        modify("Service Item Group")
        {
            Visible = false;
        }
        modify("Qty. on Prod. Order")
        {
            Visible = false;
        }
        modify("Qty. on Component Lines")
        {
            Visible = false;
        }
        modify("Qty. on Service Order")
        {
            Visible = false;
        }
        modify("Overhead Rate")
        {
            Visible = false;
        }
        modify("Indirect Cost %")
        {
            Visible = false;
        }
        modify(ItemPicture)
        {
            Visible = false;
        }
        modify("Price/Profit Calculation")
        {
            Visible = false;
        }
        modify("Profit %")
        {
            Visible = false;
        }
        modify("Net Invoiced Qty.")
        {
            Visible = false;
        }
        addafter("Description")
        {
            field("No. 2"; rec."No. 2")
            {

            }

        }
        addafter("Item Category Code")
        {
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {

            }
            field("Creation Date"; rec."Creation Date")
            {

            }
            field(User; rec.User)
            {

            }
        }
        addafter("Inventory")
        {
            field("Reserved Qty. on Inventory"; rec."Reserved Qty. on Inventory")
            {

            }
            field("Reserved Qty. on Purch. Orders"; rec."Reserved Qty. on Purch. Orders")
            {

            }
        }
        addafter("Qty. on Asm. Component")
        {
            field(DecGAvailable; DecGAvailable)
            {
                Caption = 'Available';
                DecimalPlaces = 0 : 5;
                Editable = false;
            }
        }
        addafter("PreventNegInventoryDefaultNo")
        {
            field("Margin in %"; rec."Margin in %")
            {
                Editable = false;
            }
            field("Pdf Url"; rec."Pdf Url")
            {

            }
            field("Send To Web"; rec."Send To Web")
            {

            }
            field("Assembly time"; rec."Assembly time")
            {

            }
            field("Item Machining Time"; rec."Item Machining Time")
            {

            }
            field("Item Work Time"; rec."Item Work Time")
            {

            }
            field(Weight; rec.Weight)
            {

            }
            field("Storage type"; rec."Storage type")
            {

            }
            field("Default Prepared Sales Lines"; rec."Default Prepared Sales Lines")
            {

            }
        }
        addafter("Last Direct Cost")
        {
            field("Single-Level Material Cost"; rec."Single-Level Material Cost")
            {

            }
            field("Purchase Price Base"; rec."Purchase Price Base")
            {
                Editable = false;
            }
            field("Multiplying Coefficient"; rec."Multiplying Coefficient")
            {

            }

        }
        addafter("Application Wksh. User ID")
        {
            field("Kit - Sales Price"; rec."Kit - Sales Price")
            {
                Editable = false;
            }
        }
        addafter("Assembly Policy")
        {
            field("Rolled-up Material Cost"; rec."Rolled-up Material Cost")
            {

            }
        }

    }

    actions
    {
        modify("Va&riants")
        {
            visible = false;
        }
        modify("Substituti&ons")
        {
            visible = false;
        }
        modify("Translations")
        {
            visible = false;
        }


        modify("Identifiers")
        {
            visible = false;
        }
        modify("ItemAvailabilityBy")
        {
            visible = false;
        }
        modify("Variant")
        {
            visible = false;
        }
        //TODO: RunPageView cannot be customized
        // modify("Action85")
        // {
        //     RunPageView=SORTING("Item No.");
        // }
        modify("Set Special Discounts")
        {
            trigger OnAfterAction()
            begin
                rec.Validate("Margin in %");
                CurrPage.Update(true);
            end;
        }
        modify("Action5")
        {
            visible = false;
        }
        modify("&Bin Contents")
        {
            visible = false;
        }
        modify("Stockkeepin&g Units")
        {
            visible = false;
        }
        modify("Ser&vice Items")
        {
            visible = false;
        }
        modify("Troubleshooting")
        {
            visible = false;
        }
        modify("Troubleshooting setup")
        {
            visible = false;
        }
        modify("Resources")
        {
            visible = false;
        }
        modify("Resource Skills")
        {
            visible = false;
        }
        modify("Skilled Resources")
        {
            visible = false;
        }
        addafter("Application Worksheet")
        {
            action("Historique de l'article")
            {
                //TODO: page SPE not migrated yet
                // RunObject = Page 50023;
                // RunPageLink = "Item No."=FIELD("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = History;
            }
        }
        addbefore("Return Orders")
        {
            action("Sales order archive")
            {
                //TODO: page SPE not migrated yet
                // RunObject = Page 51009;
                // RunPageView = sorting("Document Type", Type, "No.") order(descending);
                // RunPageLink = "Document Type"=const(Order),Type=const(Item),"No."=field("No.");
            }
            action("Sales quote archive")
            {
                //TODO: page SPE not migrated yet
                // RunObject = Page 51009;
                // RunPageView = SORTING("Document Type", Type, "No.") ORDER(Descending);
                // RunPageLink = "Document Type"=CONST(Quote),Type=CONST(Item),"No."=FIELD("No.");
            }
        }
        addafter("Item Tracing")
        {
            action("Calculation Purchase Price Base")
            {
                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    CLEAR(RecLItem);
                    RecLItem.SETRANGE("No.", rec."No.");
                    REPORT.RUNMODAL(50004, true, false, RecLItem);
                end;
            }
            action("Calulation Unit price")
            {
                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    CLEAR(RecLItem);
                    RecLItem.SETRANGE("No.", rec."No.");
                    REPORT.RUNMODAL(50007, true, false, RecLItem);
                end;
            }
            action("Calcul Prix Kit")
            {
                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    CLEAR(RecLItem);
                    RecLItem.SETRANGE("No.", rec."No.");
                    REPORT.RUNMODAL(50008, true, false, RecLItem);
                end;
            }
            action("Calculer Co– Kit")
            {
                trigger OnAction()
                begin
                    CLEAR(CalculateStdCost);
                    CalculateStdCost.CalcItem(rec."No.", true);
                end;
            }
            action("Calculation all Prices")
            {
                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    CLEAR(RecLItem);
                    RecLItem := Rec;
                    RecLItem.SETRANGE("No.", rec."No.");
                    RecLItem.SETRECFILTER();
                    REPORT.RUNMODAL(50009, true, false, RecLItem);
                end;
            }
            group(Action1100267023)
            {
                Caption = 'Kit';
                Visible = false;
                action(kit)
                {
                    Promoted = true;
                    Visible = false;
                    PromotedIsBig = true;
                    Image = AssemblyBOM;
                    trigger OnAction()
                    var
                        RecLProdBOMHeader: Record "Production BOM Header";
                    begin
                        rec.FctBOM(Rec);
                        CurrPage.UPDATE(true);
                    end;
                }
            }

        }
    }
    var
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        DecGAvailable: Decimal;

    trigger OnAfterGetRecord()
    begin
        rec.CALCFIELDS(rec.Inventory, rec."Qty. on Sales Order", rec."Qty. on Asm. Component", rec."Reserved Qty. on Purch. Orders");
        DecGAvailable := rec.Inventory - (rec."Qty. on Sales Order" + rec."Qty. on Asm. Component") + rec."Reserved Qty. on Purch. Orders";
    end;

}

