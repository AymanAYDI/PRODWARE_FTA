namespace Prodware.FTA;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Tracking;
using Microsoft.Inventory.Counting.Journal;
using Microsoft.Inventory.Analysis;
using Microsoft.Inventory.Availability;
using Microsoft.Warehouse.Structure;
using Microsoft.Foundation.Comment;
using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Item.Picture;
using Microsoft.Inventory.Item.Substitution;
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Manufacturing.StandardCost;
using Microsoft.Service.Item;
using Microsoft.Service.Maintenance;
using Microsoft.Service.Resources;
using Microsoft.Warehouse.ADCS;
using Microsoft.Sales.Pricing;
using Microsoft.Purchases.Pricing;
using Microsoft.Inventory.BOM;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Inventory.Planning;
page 50010 "Transitory Kit Item Card"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:MA 25/06/2008 : Champs_Suppl
    //                          - Ajout du champ "Creation Date"
    //                          - Ajout du champ User
    // 
    // NAVEASY:MA 25/06/2008 : Doc_Associés
    //                          - Ajout code sur OnPush du Bouton
    // NAVEASY:MA 25/06/2008 : Archivage_Cde
    //                          - Ajout du MenuItem "Cdes Historiques" sur MenuButton "Ventes"
    // NAVEASY:MA 25/06/2008 : Archivage_Devis
    //                          - Ajout du MenuItem "Devis Historiques" sur MenuButton "Ventes"
    // 
    // NAVEASY:MA 25/06/2008  : Field Modifications
    //                       - modification of the property "Editable" the User to  "yes"
    // 
    //                       - modification of the property "Editable" the User to  "No"
    // 
    // 
    // 
    // ------------------------------------------------------------------------
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Item Management : Pricing
    //                           - Display field "Purchase Price Base","Unit Sales Price","Multiplying Coefficient",
    //                                           "Margin in %","Kit - Sales Price"
    //                           - Design
    //                           - Add Button Kit
    // 
    // //>>TI489379 - 07/04/20 : Demande de développement - Ajout 2 champs dans fiche article
    //                           - Fields added in group "<Control1>": "Assembly time" and "Weight"
    // 
    // 
    // //>>NDBI
    // LALE.PA 21/01/2021 cf TDD_FTA_Article_et_Nomenclature_provisoire_sur_devis_V1(P26959_005)
    //         Add Field "Quote Associated"
    //         Add Action ItemToVisible
    // 
    // //>>FTA1.00
    // FTA:AM  31.03.2023  Add new action  "Historique de l'article"
    // 
    // ------------------------------------------------------------------------

    Caption = 'Transitory Kit Item Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Item;
    SourceTableView = where("Item Base" = filter("Transitory Kit"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.UPDATE();
                    end;
                }
                field("No. 2"; Rec."No. 2")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Search Description"; Rec."Search Description")
                {
                }
                field("Customer Code"; Rec."Customer Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                }
                // field("Product Group Code"; Rec."Product Group Code")
                // {
                // }//TODO -> Field 'Product Group Code' is removed
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Item Disc. Group"; Rec."Item Disc. Group")
                {
                }
                field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(User; Rec.User)
                {
                    Editable = false;
                    Enabled = true;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    Editable = false;
                }
                field("Assembly BOM"; Rec."Assembly BOM")
                {
                }
                field("Single-Level Material Cost"; Rec."Single-Level Material Cost")
                {
                }
                field("Kit - Sales Price"; Rec."Kit - Sales Price")
                {
                    Editable = false;
                }
                field("Purchase Price Base"; Rec."Purchase Price Base")
                {
                }
                field("Multiplying Coefficient"; Rec."Multiplying Coefficient")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Margin in %"; Rec."Margin in %")
                {
                }
                field("Margin net in %"; Rec."Margin net in %")
                {
                }
                field("Unit Price net"; Rec."Unit Price net")
                {
                }
                field("Pdf Url"; Rec."Pdf Url")
                {
                }
                field("Assembly time"; Rec."Assembly time")
                {
                    Visible = false;
                }
                field("Item Machining Time"; Rec."Item Machining Time")
                {
                }
                field("Item Work Time"; Rec."Item Work Time")
                {
                }
                field(Weight; Rec.Weight)
                {
                }
                field("Quote Associated"; Rec."Quote Associated")
                {
                }
            }
            group(Misc)
            {
                Caption = 'Misc';
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field(Inventory; Rec.Inventory)
                {
                }
                field("Reserved Qty. on Inventory"; Rec."Reserved Qty. on Inventory")
                {
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                }
                field("Qty. on Sales Quote"; Rec."Qty. on Sales Quote")
                {
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                }
                field("Item Base"; Rec."Item Base")
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Kit")
            {
                Caption = '&Kit';
                Visible = true;
                action("Stockkeepin&g Units")
                {
                    Caption = 'Stockkeepin&g Units';
                    Image = TeamSales;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                    Visible = false;
                }
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Visible = false;
                    action("Ledger E&ntries")
                    {
                        Caption = 'Ledger E&ntries';
                        Image = LedgerEntries;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                        ShortCutKey = 'Ctrl+F7';
                        Visible = false;
                    }
                    action("&Reservation Entries")
                    {
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = const(Reservation), "Item No." = field("No.");
                        RunPageView = sorting("Item No.", "Variant Code", "Location Code", "Reservation Status");
                        Visible = false;
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                        Visible = false;
                    }
                    action("&Value Entries")
                    {
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                        Visible = false;
                    }
                    action("Item &Tracking Entries")
                    {
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;
                        Visible = false;

                        trigger OnAction()
                        var
                            ItemTrackingSetup: Record "Item Tracking Setup";
                            ItemTrackingDMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            ItemTrackingDMgt.ShowItemTrackingForEntity(3, '', REc."No.", '', '', ItemTrackingSetup);
                        end;
                    }
                    action("Application Worksheet")
                    {
                        Caption = 'Application Worksheet';
                        Image = ApplicationWorksheet;
                        RunObject = Page "Application Worksheet";
                        RunPageLink = "Item No." = field("No.");
                        Visible = false;
                    }
                }
                group(Statistic)
                {
                    Caption = 'Statistics';
                    Visible = false;
                    action(Statistics)
                    {
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        ShortCutKey = 'F7';
                        Visible = false;

                        trigger OnAction()
                        var
                            ItemStatistics: Page "Item Statistics";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RUNMODAL();
                        end;
                    }
                    action("Entry Statistics")
                    {
                        Caption = 'Entry Statistics';
                        Image = EntryStatistics;
                        RunObject = Page "Item Entry Statistics";
                        RunPageLink = "No." = field("No."),
                                      "Date Filter" = field("Date Filter"),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                        Visible = false;
                    }
                    action("T&urnover")
                    {
                        Caption = 'T&urnover';
                        Image = Turnover;
                        RunObject = Page "Item Turnover";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                        Visible = false;
                    }
                }
                action("Items b&y Location")
                {
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;
                    Visible = false;

                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin
                        ItemsByLocation.SETRECORD(Rec);
                        ItemsByLocation.RUN();
                    end;
                }
                action("Historique de l'article")
                {
                    Caption = 'Historique de l''article';
                    Image = History;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Item Comment";
                    RunPageLink = "Item No." = field("No.");
                }
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Visible = false;
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                        Visible = false;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = View;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                        Visible = false;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Lock;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                        Visible = false;
                    }
                }
                action("&Bin Contents")
                {
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Item Bin Contents";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                    Visible = false;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Item),
                                  "No." = field("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(27),
                                  "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = false;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Item Picture";
                    RunPageLink = "No." = field("No."),
                                  "Date Filter" = field("Date Filter"),
                                  "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                  "Location Filter" = field("Location Filter"),
                                  "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                  "Variant Filter" = field("Variant Filter");
                    Visible = false;
                }
                separator(separator1)
                {
                }
                action("&Units of Measure")
                {
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No." = field("No.");
                    Visible = false;
                }
                action("Va&riants")
                {
                    Caption = 'Va&riants';
                    Image = VATEntries;
                    RunObject = Page "Item Variants";
                    RunPageLink = "Item No." = field("No.");
                    Visible = false;
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    Image = Receipt;
                    RunObject = Page "Item Reference Entries";
                    RunPageLink = "Item No." = field("No.");
                }
                action("Substituti&ons")
                {
                    Caption = 'Substituti&ons';
                    Image = SubcontractingWorksheet;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                    Visible = false;
                }
                action("Nonstoc&k Items")
                {
                    Caption = 'Nonstoc&k Items';
                    Image = NonStockItem;
                    RunObject = Page "Catalog Item List";
                    Visible = false;
                }
                separator(separator2)
                {
                }
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translation;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = field("No.");
                    Visible = false;
                }
                action("E&xtended Texts")
                {
                    Caption = 'E&xtended Texts';
                    Image = ExternalDocument;
                    RunObject = Page "Extended Text";
                    RunPageLink = "Table Name" = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                }
                separator(separator3)
                {
                }
                group(Kitting)
                {
                    Caption = 'Kitting';
                    Visible = false;
                    action("K-Where-Used")
                    {
                        Caption = 'Where-Used';
                        Image = "Where-Used";
                        Visible = false;

                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";//99000811
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WORKDATE());
                            ProdBOMWhereUsed.RUNMODAL();
                        end;
                    }
                    action("K-Calc. Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';
                        Image = Calculate;
                        Visible = false;

                        trigger OnAction()
                        var
                            CalculateStdCost: Codeunit "Calculate Standard Cost";
                        begin
                            CLEAR(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", true);
                        end;
                    }
                }
                group("Manufa&cturing")
                {
                    Caption = 'Manufa&cturing';
                    Visible = false;
                    action("Where-Used")
                    {
                        Caption = 'Where-Used';
                        Image = "Where-Used";
                        Visible = false;

                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WORKDATE());
                            ProdBOMWhereUsed.RUNMODAL();
                        end;
                    }
                    action("Calc.Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;
                        Visible = false;

                        trigger OnAction()
                        begin
                            CLEAR(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", false);
                        end;
                    }
                }
                separator(separator4)
                {
                    Caption = '';
                }
                action("Ser&vice Items")
                {
                    Caption = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                    Visible = false;
                }
                group("Troubleshooting")
                {
                    Caption = 'Troubles&hooting';
                    Visible = false;
                    action("Troubleshooting &Setup")
                    {
                        Caption = 'Troubleshooting &Setup';
                        Image = Troubleshoot;
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type = const(Item),
                                      "No." = field("No.");
                        Visible = false;
                    }
                    action("Troubles&hooting")
                    {
                        Caption = 'Troubles&hooting';
                        Image = Indent;
                        Visible = false;

                        trigger OnAction()
                        begin
                            TroubleshHeader.ShowForItem(Rec);
                        end;
                    }
                }
                group("R&esource")
                {
                    Caption = 'R&esource';
                    Visible = false;
                    action("Resource Skills")
                    {
                        Caption = 'Resource Skills';
                        Image = ResourceSkills;
                        RunObject = Page "Resource Skills";
                        RunPageLink = Type = const(Item),
                                      "No." = field("No.");
                        Visible = false;
                    }
                    action("Skilled Resources")
                    {
                        Caption = 'Skilled Resources';
                        Image = ResourceRegisters;
                        Visible = false;

                        trigger OnAction()
                        var
                            ResourceSkill: Record "Resource Skill";
                        begin
                            CLEAR(SkilledResourceList);
                            SkilledResourceList.Initialize(ResourceSkill.Type::Item, Rec."No.", Rec.Description);
                            SkilledResourceList.RUNMODAL();
                        end;
                    }
                }
                separator(separator5)
                {
                }
                action(Identifiers)
                {
                    Caption = 'Identifiers';
                    Image = InactivityDescription;
                    RunObject = Page "Item Identifiers";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.", "Variant Code", "Unit of Measure Code");
                    Visible = false;
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                action(Price)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = Type = const(Item),
                                  Code = field("No.");
                    RunPageView = sorting(Type, Code);
                }
            }
            group("&Purchases")
            {
                Caption = '&Purchases';
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                }
                action("Line Discount")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Item No." = field("No.");
                }
            }
            group("Assembly/Production")
            {
                Caption = 'Assembly/Production';
                Image = Production;
                action(Structure)
                {
                    Caption = 'Structure';
                    Image = Hierarchy;

                    trigger OnAction()
                    var
                        BOMStructure: Page "BOM Structure";
                    begin
                        BOMStructure.InitItem(Rec);
                        BOMStructure.RUN();
                    end;
                }
                action("Cost Shares")
                {
                    Caption = 'Cost Shares';
                    Image = CostBudget;

                    trigger OnAction()
                    var
                        BOMCostShares: Page "BOM Cost Shares";
                    begin
                        BOMCostShares.InitItem(Rec);
                        BOMCostShares.RUN();
                    end;
                }
                group("Assemb&ly")
                {
                    Caption = 'Assemb&ly';
                    Image = AssemblyBOM;
                    action("Assembly-BOM")
                    {
                        Caption = 'Assembly BOM';
                        Image = BOM;
                        RunObject = Page "Assembly BOM";
                        RunPageLink = "Parent Item No." = field("No.");
                    }
                    action("Where Used")
                    {
                        Caption = 'Where-Used';
                        Image = Track;
                        RunObject = Page "Where-Used List";
                        RunPageLink = Type = const(Item),
                                      "No." = field("No.");
                        RunPageView = sorting(Type, "No.");
                        Visible = false;
                    }
                    action("Calc. Standard Cost")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;

                        trigger OnAction()
                        begin
                            CLEAR(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", true);
                        end;
                    }
                    action("Calc. Unit Price")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        Caption = 'Calc. Unit Price';
                        Image = SuggestItemPrice;

                        trigger OnAction()
                        begin
                            CLEAR(CalculateStdCost);
                            CalculateStdCost.CalcAssemblyItemPrice(Rec."No.")
                        end;
                    }
                }
                group(Production)
                {
                    Caption = 'Production';
                    Image = Production;
                    action("Production BOM")
                    {
                        Caption = 'Production BOM';
                        Image = BOM;
                        RunObject = Page "Production BOM";
                        RunPageLink = "No." = field("No.");
                    }
                    action("Where &Used")
                    {
                        AccessByPermission = TableData "Production BOM Header" = R;
                        Caption = 'Where-Used';
                        Image = "Where-Used";

                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WORKDATE());
                            ProdBOMWhereUsed.RUNMODAL();
                        end;
                    }
                    action("Calc. Stan&dard-Cost")
                    {
                        AccessByPermission = TableData "Production BOM Header" = R;
                        Caption = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;
                        Visible = false;

                        trigger OnAction()
                        begin
                            CLEAR(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", false);
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = false;
            }
            action(Kit)
            {
                Caption = 'Kit';
                Image = Sales;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    RecLProdBOMHeader: Record "Production BOM Header";
                begin
                    Rec.FctBOM(Rec);//TODO -> Specifique 
                    CurrPage.UPDATE(true);
                    //FctBOMtoValidate(Rec);
                end;
            }
            action("Calculation Kit Price")
            {
                Caption = 'Calculation Kit Price';
                Image = CalculateBalanceAccount;

                trigger OnAction()
                var
                    RecLItem: Record "Item";
                begin
                    CLEAR(RecLItem);
                    RecLItem.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(Report::"Calculate Kit Price Item", true, false, RecLItem);
                end;
            }
            action("Calc. Stan&dard Cost")
            {
                Caption = 'Calc. Stan&dard Cost';
                Image = Calculate;

                trigger OnAction()
                begin
                    CLEAR(CalculateStdCost);
                    CalculateStdCost.CalcItem(Rec."No.", true);
                end;
            }
            action("Calculation all Prices")
            {
                Caption = 'Calculation all Prices';
                Image = CalculateConsumption;

                trigger OnAction()
                var
                    RecLItem: Record "Item";
                begin
                    CLEAR(RecLItem);
                    RecLItem := Rec;
                    RecLItem.SETRANGE("No.", Rec."No.");
                    RecLItem.SETRECFILTER();
                    //Report.SETTABLEVIEW(Reclitem)
                    REPORT.RUNMODAL(50009, true, false, RecLItem);
                end;
            }
            action("Apply Template")
            {
                Caption = 'Apply Template';
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.FctCreateFromTemplate();
                end;
            }
            action(ItemToVisible)
            {
                Caption = 'Rendre visible article provisoire';
                Image = Item;

                trigger OnAction()
                begin
                    if Rec."Quote Associated" then begin
                        Rec."Quote Associated" := false;
                        Rec.MODIFY();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SETRANGE("No.");
        EnablePlanningControls();
        EnableCostingControls();
    end;

    trigger OnClosePage()
    begin
        UpdatePriceOnCLose();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Item Base" := Rec."Item Base"::"Transitory Kit";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Item Base" := Rec."Item Base"::"Transitory Kit";
    end;

    var
        TroubleshHeader: Record "Troubleshooting Header";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        SkilledResourceList: Page "Skilled Resource List";



    procedure EnablePlanningControls()
    var
        PlanningParameters: Record "Planning Parameters";
        PlanningGetParam: Codeunit "Planning-Get Parameters";
    begin
        PlanningParameters."Reordering Policy" := Rec."Reordering Policy";
        PlanningParameters."Include Inventory" := Rec."Include Inventory";
        PlanningGetParam.SetPlanningParameters(PlanningParameters);
    end;


    procedure EnableCostingControls()
    begin
    end;

    local procedure UpdatePriceOnCLose()
    var
        RecLItem: Record Item;
    begin
        CLEAR(RecLItem);
        RecLItem := Rec;
        RecLItem.SETRANGE("No.", Rec."No.");
        RecLItem.SETRECFILTER();
        //Report.SETTABLEVIEW(Reclitem)
        REPORT.RUNMODAL(50009, false, false, RecLItem);
    end;
}

