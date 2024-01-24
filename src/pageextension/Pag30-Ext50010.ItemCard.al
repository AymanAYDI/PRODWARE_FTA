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
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. 2 field.';
            }

        }
        addafter("Item Category Code")
        {
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            }
            field("Creation Date"; rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Creation Date field.';
            }
            field(User; rec.User)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User field.';
            }
        }
        addafter("Inventory")
        {
            field("Reserved Qty. on Inventory"; rec."Reserved Qty. on Inventory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reserved Qty. on Inventory field.';
            }
            field("Reserved Qty. on Purch. Orders"; rec."Reserved Qty. on Purch. Orders")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reserved Qty. on Purch. Orders field.';
            }
        }
        addafter("Qty. on Asm. Component")
        {
            field(DecGAvailable; DecGAvailable)
            {
                Caption = 'Available';
                DecimalPlaces = 0 : 5;
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Available field.';
            }
        }
        addafter("PreventNegInventoryDefaultNo")
        {
            field("Margin in %"; rec."Margin in %")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Margin in % field.';
            }
            field("Pdf Url"; rec."Pdf Url")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pdf Url field.';
            }
            field("Send To Web"; rec."Send To Web")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Send To Web field.';
            }
            field("Assembly time"; rec."Assembly time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temps de montage field.';
            }
            field("Item Machining Time"; rec."Item Machining Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temps d''usinage field.';
            }
            field("Item Work Time"; rec."Item Work Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temps de montage field.';
            }
            field(Weight; rec.Weight)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Poids field.';
            }
            field("Storage type"; rec."Storage type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type stockage field.';
            }
            field("Default Prepared Sales Lines"; rec."Default Prepared Sales Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Préparé automatiquement lignes vente field.';
            }
        }
        addafter("Last Direct Cost")
        {
            field("Single-Level Material Cost"; rec."Single-Level Material Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Single-Level Material Cost field.';
            }
            field("Purchase Price Base"; rec."Purchase Price Base")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purchase Price Base field.';
            }
            field("Multiplying Coefficient"; rec."Multiplying Coefficient")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Multiplying Coefficient field.';
            }

        }
        addafter("Application Wksh. User ID")
        {
            field("Kit - Sales Price"; rec."Kit - Sales Price")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Kit - Sales Price field.';
            }
        }
        addafter("Assembly Policy")
        {
            field("Rolled-up Material Cost"; rec."Rolled-up Material Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rolled-up Material Cost field.';
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
                RunObject = Page "Item Comment";
                RunPageLink = "Item No." = field("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = History;
                ApplicationArea = All;
                ToolTip = 'Executes the Historique de l''article action.';
            }
        }
        addbefore("Return Orders")
        {
            action("Sales order archive")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Sales order archive action.';
                RunObject = Page "Sales Archive";
                RunPageView = sorting("Document Type", Type, "No.") order(descending);
                RunPageLink = "Document Type" = const(Order), Type = const(Item), "No." = field("No.");
            }
            action("Sales quote archive")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Sales quote archive action.';
                RunObject = Page "Sales Archive";
                RunPageView = sorting("Document Type", Type, "No.") order(descending);
                RunPageLink = "Document Type" = const(Quote), Type = const(Item), "No." = field("No.");
            }
        }
        addafter("Item Tracing")
        {
            action("Calculation Purchase Price Base")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Calculation Purchase Price Base action.';
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
                ApplicationArea = All;
                ToolTip = 'Executes the Calulation Unit price action.';
                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    CLEAR(RecLItem);
                    RecLItem.SETRANGE("No.", rec."No.");
                    REPORT.RUNMODAL(Report::"Calculate Unit Price Item", true, false, RecLItem);
                end;
            }
            action("Calcul Prix Kit")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Calcul Prix Kit action.';
                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    CLEAR(RecLItem);
                    RecLItem.SETRANGE("No.", rec."No.");
                    REPORT.RUNMODAL(Report::"Calculate Kit Price Item", true, false, RecLItem);
                end;
            }
            action("Calculer Co– Kit")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Calculer Co– Kit action.';
                trigger OnAction()
                begin
                    CLEAR(CalculateStdCost);
                    CalculateStdCost.CalcItem(rec."No.", true);
                end;
            }
            action("Calculation all Prices")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Calculation all Prices action.';
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
                // Visible = false;
                action(kit)
                {
                    Promoted = true;
                    Visible = false;
                    PromotedIsBig = true;
                    Image = AssemblyBOM;
                    ApplicationArea = All;
                    ToolTip = 'Executes the kit action.';
                    trigger OnAction()
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
        DecGAvailable := (rec.Inventory - (rec."Qty. on Sales Order" + rec."Qty. on Asm. Component")) + rec."Reserved Qty. on Purch. Orders";
    end;

}

