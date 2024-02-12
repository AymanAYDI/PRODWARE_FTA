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
        Modify("Created From Nonstock Item")
        {
            Visible = false;
        }

        Modify("Service Item Group")
        {
            Visible = false;
        }
        Modify("Qty. on Prod. Order")
        {
            Visible = false;
        }
        Modify("Qty. on Component Lines")
        {
            Visible = false;
        }
        Modify("Qty. on Service Order")
        {
            Visible = false;
        }
        Modify("Overhead Rate")
        {
            Visible = false;
        }
        Modify("Indirect Cost %")
        {
            Visible = false;
        }
        Modify(ItemPicture)
        {
            Visible = false;
        }
        Modify("Price/Profit Calculation")
        {
            Visible = false;
        }
        Modify("Profit %")
        {
            Visible = false;
        }
        Modify("Net Invoiced Qty.")
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
            field("Item Base"; Rec."Item Base")
            {
                //Todo : added for test
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Base field.';
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
        Modify("Va&riants")
        {
            visible = false;
        }
        Modify("Substituti&ons")
        {
            visible = false;
        }
        Modify("Translations")
        {
            visible = false;
        }


        Modify("Identifiers")
        {
            visible = false;
        }
        Modify("ItemAvailabilityBy")
        {
            visible = false;
        }
        Modify("Variant")
        {
            visible = false;
        }
        //TODO: RunPageView cannot be customized
        // Modify("Action85")
        // {
        //     RunPageView=SORTING("Item No.");
        // }
        Modify("Set Special Discounts")
        {
            trigger OnAfterAction()
            begin
                rec.Validate("Margin in %");
                CurrPage.Update(true);
            end;
        }
        Modify("Action5")
        {
            visible = false;
        }
        Modify("&Bin Contents")
        {
            visible = false;
        }
        Modify("Stockkeepin&g Units")
        {
            visible = false;
        }
        Modify("Ser&vice Items")
        {
            visible = false;
        }
        Modify("Troubleshooting")
        {
            visible = false;
        }
        Modify("Troubleshooting setup")
        {
            visible = false;
        }
        Modify("Resources")
        {
            visible = false;
        }
        Modify("Resource Skills")
        {
            visible = false;
        }
        Modify("Skilled Resources")
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
                    Clear(RecLItem);
                    RecLItem.SetRange("No.", rec."No.");
                    REPORT.RunModal(50004, true, false, RecLItem);
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
                    Clear(RecLItem);
                    RecLItem.SetRange("No.", rec."No.");
                    REPORT.RunModal(Report::"Calculate Unit Price Item", true, false, RecLItem);
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
                    Clear(RecLItem);
                    RecLItem.SetRange("No.", rec."No.");
                    REPORT.RunModal(Report::"Calculate Kit Price Item", true, false, RecLItem);
                end;
            }
            action("Calculer Co– Kit")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Calculer Co– Kit action.';
                trigger OnAction()
                begin
                    Clear(CalculateStdCost);
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
                    Clear(RecLItem);
                    RecLItem := Rec;
                    RecLItem.SetRange("No.", rec."No.");
                    RecLItem.SetRecFilter();
                    REPORT.RunModal(50009, true, false, RecLItem);
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
                        CurrPage.Update(true);
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
        rec.CalcFields(rec.Inventory, rec."Qty. on Sales Order", rec."Qty. on Asm. Component", rec."Reserved Qty. on Purch. Orders");
        DecGAvailable := (rec.Inventory - (rec."Qty. on Sales Order" + rec."Qty. on Asm. Component")) + rec."Reserved Qty. on Purch. Orders";
    end;

}

