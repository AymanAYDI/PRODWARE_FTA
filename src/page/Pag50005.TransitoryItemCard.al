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
using Microsoft.Inventory.Item.Catalog;
using Microsoft.Inventory.Item.Substitution;
using Microsoft.Foundation.ExtendedText;
using Microsoft.Manufacturing.ProductionBOM;
using Microsoft.Service.Item;
using Microsoft.Service.Maintenance;
using Microsoft.Service.Resources;
using Microsoft.Warehouse.ADCS;
using Microsoft.Sales.Pricing;
using Microsoft.Purchases.Pricing;
using System.IO;
using Microsoft.Manufacturing.StandardCost;
using Microsoft.Inventory.Planning;
page 50005 "Transitory Item Card"
{

    Caption = 'Transitory Item Card';
    PaGetype = Card;
    RefreshOnActivate = true;
    SourceTable = Item;
    SourceTableView = where("Item Base" = filter(Transitory));
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
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update();
                    end;

                    trigger OnValidate()
                    begin
                        Rec."Item Base" := Rec."Item Base"::Transitory;
                    end;
                }
                field("No. 2"; Rec."No. 2")
                {
                    ToolTip = 'Specifies the value of the No. 2 field.';
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ToolTip = 'Specifies where to Find the item in the warehouse. This is inFormational only.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies what you are selling.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies inFormation in addition to the description.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ToolTip = 'Specifies a search description that you use to Find the item in lists.';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the vendor code of who supplies this item by default.';
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ToolTip = 'Specifies the number that the vendor uses for this item.';
                }
                // field("Item Category Code"; Rec."Item Category Code")
                // {
                //     ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
                // }
                // field("Product Group Code"; Rec."Product Group Code")
                // {
                //     ToolTip = 'Specifies the value of the Product Group Code field.';
                // }
                //Todo : verifier
                field("item category parent"; itemcat."Parent Category")
                {

                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    trigger OnValidate()
                    begin
                        itemcat.Get(rec."Item Category Code");
                    end;

                }//todo end verifer
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Item Disc. Group"; Rec."Item Disc. Group")
                {
                    ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
                }
                field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
                {
                    ToolTip = 'Specifies that an extended text that you have set up will be added automatically on sales or purchase documents for this item.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example an item that is placed in quarantine.';
                }
                field("Inventory Value Zero"; Rec."Inventory Value Zero")
                {
                    ToolTip = 'Specifies whether the item on inventory must be excluded from inventory valuation. This is relevant if the item is kept on inventory on someone else''s behalf.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies when the item card was last modified.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field(User; Rec.User)
                {
                    Editable = false;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    Editable = false;
                    ToolTip = 'Specifies the unit in which the item is held in inventory. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field("Purchase Price Base"; Rec."Purchase Price Base")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Purchase Price Base field.';
                }
                field("Multiplying Coefficient"; Rec."Multiplying Coefficient")
                {
                    ToolTip = 'Specifies the value of the Multiplying Coefficient field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price for one unit.';
                }
                field("Margin in %"; Rec."Margin in %")
                {
                    ToolTip = 'Specifies the value of the Margin in % field.';
                }
                field("Margin net in %"; Rec."Margin net in %")
                {
                    ToolTip = 'Specifies the value of the Net Margin in % field.';
                }
                field("Unit Price net"; Rec."Unit Price net")
                {
                    ToolTip = 'Specifies the value of the Unit Net Price field.';
                }
                field("Storage type"; Rec."Storage type")
                {
                    ToolTip = 'Specifies the value of the Type stockage field.';
                }
                field("Item Machining Time"; Rec."Item Machining Time")
                {
                    ToolTip = 'Specifies the value of the Temps d''usinage field.';
                }
                field("Item Work Time"; Rec."Item Work Time")
                {
                    ToolTip = 'Specifies the value of the Temps de montage field.';
                }
            }
            group(Misc)
            {
                Caption = 'Misc';
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
                }
                field("Reserved Qty. on Inventory"; Rec."Reserved Qty. on Inventory")
                {
                    ToolTip = 'Specifies the value of the Reserved Qty. on Inventory field.';
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
                }
                field("Qty. on Sales Quote"; Rec."Qty. on Sales Quote")
                {
                    ToolTip = 'Specifies the value of the Qty. on Sales Order field.';
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
                }
                field("Item Base"; Rec."Item Base")
                {
                    Editable = true;
                    ToolTip = 'Specifies the value of the Item Base field.';
                }
                field("Pdf Url"; Rec."Pdf Url")
                {
                    ToolTip = 'Specifies the value of the Pdf Url field.';
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field("Reordering Policy"; Rec."Reordering Policy")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the reordering policy.';
                    trigger OnValidate()
                    begin
                        EnablePlanningControls()
                    end;
                }
                field(Reserve; Rec.Reserve)
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies if and how the item will be reserved. Never: It is not possible to reserve the item. Optional: You can reserve the item manually. Always: The item is automatically reserved from demand, such as sales orders, against inventory, purchase orders, assembly orders, and production orders.';
                }
                field("Order Tracking Policy"; Rec."Order Tracking Policy")
                {
                    ToolTip = 'Specifies if and how order tracking entries are created and maintained between supply and its corresponding demand.';
                }
                field("Stockkeeping Unit Exists"; Rec."Stockkeeping Unit Exists")
                {
                    ToolTip = 'Specifies that a stockkeeping unit exists for this item.';
                }
                field("Dampener Period"; Rec."Dampener Period")
                {
                    Enabled = DampenerPeriodEnable;
                    ToolTip = 'Specifies a period of time during which you do not want the planning system to propose to reschedule existing supply orders forward. The dampener period limits the number of insignificant rescheduling of existing supply to a later date if that new date is within the dampener period. The dampener period function is only Initiated if the supply can be rescheduled to a later date and not if the supply can be rescheduled to an earlier date. Accordingly, if the suggested new supply date is after the dampener period, then the rescheduling suggestion is not blocked. If the lot accumulation period is less than the dampener period, then the dampener period is dynamically set to equal the lot accumulation period. This is not shown in the value that you enter in the Dampener Period field. The last demand in the lot accumulation period is used to determine whether a potential supply date is in the dampener period. If this field is empty, then the value in the Default Dampener Period field in the Manufacturing Setup window applies. The value that you enter in the Dampener Period field must be a date formula, and one day (1D) is the shortest allowed period.';
                }
                field("Dampener Quantity"; Rec."Dampener Quantity")
                {
                    Enabled = DampenerQtyEnable;
                    ToolTip = 'Specifies a dampener quantity to block insignificant change suggestions for an existing supply, if the change quantity is lower than the dampener quantity.';
                }
                field(Critical; Rec.Critical)
                {
                    ToolTip = 'Specifies if the item is included in availability calculations to promise a shipment date for its parent item.';
                }
                field("Safety Lead Time"; Rec."Safety Lead Time")
                {
                    Enabled = SafetyLeadTimeEnable;
                    ToolTip = 'Specifies a date formula to indicate a safety lead time that can be used as a buffer period for production and other delays.';
                }
                field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
                {
                    Enabled = SafetyStockQtyEnable;
                    ToolTip = 'Specifies a quantity of stock to have in inventory to protect against supply-and-demand fluctuations during replenishment lead time.';
                }
                group("Lot-for-Lot Parameters")
                {
                    Caption = 'Lot-for-Lot Parameters';
                    field("Include Inventory"; Rec."Include Inventory")
                    {
                        Enabled = IncludeInventoryEnable;
                        ToolTip = 'Specifies that the inventory quantity is included in the projected available balance when replenishment orders are calculated.';
                        trigger OnValidate()
                        begin
                            EnablePlanningControls()
                        end;
                    }
                    field("Lot Accumulation Period"; Rec."Lot Accumulation Period")
                    {
                        Enabled = LotAccumulationPeriodEnable;
                        ToolTip = 'Specifies a period in which multiple demands are accumulated into one supply order when you use the Lot-for-Lot reordering policy.';
                    }
                    field("Rescheduling Period"; Rec."Rescheduling Period")
                    {
                        Enabled = ReschedulingPeriodEnable;
                        ToolTip = 'Specifies a period within which any suggestion to change a supply date always consists of a Reschedule action and never a Cancel + New action.';
                    }
                }
                group("Reorder-Point Parameters")
                {
                    Caption = 'Reorder-Point Parameters';
                    grid(Rows2)
                    {
                        GridLayout = Rows;
                        group(Group2)
                        {
                            field("Reorder Point"; Rec."Reorder Point")
                            {
                                Enabled = ReorderPointEnable;
                                ToolTip = 'Specifies a stock quantity that sets the inventory below the level that you must replenish the item.';
                            }
                            field("Reorder Quantity"; Rec."Reorder Quantity")
                            {
                                Enabled = ReorderQtyEnable;
                                ToolTip = 'Specifies a standard lot size quantity to be used for all order proposals.';
                            }
                            field("Maximum Inventory"; Rec."Maximum Inventory")
                            {
                                Enabled = MaximumInventoryEnable;
                                ToolTip = 'Specifies a quantity that you want to use as a maximum inventory level.';
                            }
                        }
                    }
                    field("Overflow Level"; Rec."Overflow Level")
                    {
                        Enabled = OverflowLevelEnable;
                        Importance = Additional;
                        ToolTip = 'Specifies a quantity you allow projected inventory to exceed the reorder point, before the system suggests to decrease supply orders.';
                    }
                    field("Time Bucket"; Rec."Time Bucket")
                    {
                        Enabled = TimeBucketEnable;
                        Importance = Additional;
                        ToolTip = 'Specifies a time period that defines the recurring planning horizon used with Fixed Reorder Qty. or Maximum Qty. reordering policies.';
                    }
                }
                group("Order Modifiers")
                {
                    Caption = 'Order Modifiers';
                    grid(Rows)
                    {
                        GridLayout = Rows;
                        group(Group)
                        {
                            field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
                            {
                                Enabled = MinimumOrderQtyEnable;
                                ToolTip = 'Specifies a minimum allowable quantity for an item order proposal.';
                            }
                            field("Maximum Order Quantity"; Rec."Maximum Order Quantity")
                            {
                                Enabled = MaximumOrderQtyEnable;
                                ToolTip = 'Specifies a maximum allowable quantity for an item order proposal.';
                            }
                            field("Order Multiple"; Rec."Order Multiple")
                            {
                                Enabled = OrderMultipleEnable;
                                ToolTip = 'Specifies a parameter used by the planning system to Modify the quantity of planned supply orders.';
                            }
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                Visible = true;
                action("Stockkeepin&g Units")
                {
                    Caption = 'Stockkeepin&g Units';
                    Image = PostingEntries;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                    Visible = false;
                    ToolTip = 'Executes the Stockkeepin&g Units action.';
                }
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Visible = false;
                    action("Ledger E&ntries")
                    {
                        Caption = 'Ledger E&ntries';
                        Image = Revenue;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                        ShortCutKey = 'Ctrl+F7';
                        Visible = false;
                        ToolTip = 'Executes the Ledger E&ntries action.';
                    }
                    action("&Reservation Entries")
                    {
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = const(Reservation),
                                      "Item No." = field("No.");
                        RunPageView = sorting("Item No.", "Variant Code", "Location Code", "Reservation Status");
                        Visible = false;
                        ToolTip = 'Executes the &Reservation Entries action.';
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                        Visible = false;
                        ToolTip = 'Executes the &Phys. Inventory Ledger Entries action.';
                    }
                    action("&Value Entries")
                    {
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                        Visible = false;
                        ToolTip = 'Executes the &Value Entries action.';
                    }
                    action("Item &Tracking Entries")
                    {  //TODO -> can't Find CallItemTrackingEntryForm
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;
                        Visible = false;

                        trigger OnAction()
                        var
                            ItemTrackingSetup: Record "Item Tracking Setup";
                            ItemTrackingDMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            //CallItemTrackingEntryForm
                            ItemTrackingDMgt.ShowItemTrackingForEntity(3, '', Rec."No.", '', '', ItemTrackingSetup);
                        end;
                    }
                    action("Application Worksheet")
                    {
                        Caption = 'Application Worksheet';
                        Image = ApplicationWorksheet;
                        RunObject = Page "Application Worksheet";
                        RunPageLink = "Item No." = field("No.");
                        Visible = false;
                        ToolTip = 'Executes the Application Worksheet action.';
                    }
                }
                action("Historique de l'article")
                {
                    Caption = 'Historique de l''article';
                    Image = History;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Item Comment";
                    RunPageLink = "Item No." = field("No.");
                    ToolTip = 'Executes the Historique de l''article action.';
                }
                group(GStatistics)
                {
                    Caption = 'Statistics';
                    Visible = false;
                    action(Statistics)
                    {
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';
                        Visible = false;
                        ToolTip = 'Executes the Statistics action.';
                        trigger OnAction()
                        var
                            ItemStatistics: Page "Item Statistics";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RunModal();
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
                        ToolTip = 'Executes the Entry Statistics action.';
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
                        ToolTip = 'Executes the T&urnover action.';
                    }
                }
                action("Items b&y Location")
                {
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;
                    Visible = false;
                    ToolTip = 'Executes the Items b&y Location action.';
                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin
                        ItemsByLocation.SetRecord(Rec);
                        ItemsByLocation.Run();
                    end;
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
                        ToolTip = 'Executes the Period action.';
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = VATEntries;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                        Visible = false;
                        ToolTip = 'Executes the Variant action.';
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Loaners;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                        Visible = false;
                        ToolTip = 'Executes the Location action.';
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
                    ToolTip = 'Executes the &Bin Contents action.';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Item), "No." = field("No.");
                    ToolTip = 'Executes the Co&mments action.';
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
                    ToolTip = 'Executes the Dimensions action.';
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
                    ToolTip = 'Executes the &Picture action.';
                }
                separator(Separator)
                {
                }
                action("&Units of Measure")
                {
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No." = field("No.");
                    Visible = false;
                    ToolTip = 'Executes the &Units of Measure action.';
                }
                action("Va&riants")
                {
                    Caption = 'Va&riants';
                    Image = VATEntries;
                    RunObject = Page "Item Variants";
                    RunPageLink = "Item No." = field("No.");
                    Visible = false;
                    ToolTip = 'Executes the Va&riants action.';
                }
                action("Cross Re&ferences")
                {
                    Caption = 'Cross Re&ferences';
                    Image = ReleaseDoc;
                    RunObject = Page "Item Reference Entries";
                    RunPageLink = "Item No." = field("No.");
                    ToolTip = 'Executes the Cross Re&ferences action.';
                }
                action("Substituti&ons")
                {
                    Caption = 'Substituti&ons';
                    Image = SubcontractingWorksheet;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type = const(Item), "No." = field("No.");
                    Visible = false;
                    ToolTip = 'Executes the Substituti&ons action.';
                }
                action("Nonstoc&k Items")
                {
                    Caption = 'Nonstoc&k Items';
                    Image = NonStockItem;
                    RunObject = Page "Catalog Item List";
                    Visible = false;
                    ToolTip = 'Executes the Nonstoc&k Items action.';
                }
                separator(separator1)
                {
                }
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = field("No.");
                    Visible = false;
                    ToolTip = 'Executes the Translations action.';
                }
                action("E&xtended Texts")
                {
                    Caption = 'E&xtended Texts';
                    Image = ExternalDocument;
                    RunObject = Page "Extended Text";
                    RunPageLink = "Table Name" = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    ToolTip = 'Executes the E&xtended Texts action.';
                }
                separator(Separator2)
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
                        ToolTip = 'Executes the Where-Used action.';
                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WorkDate());
                            ProdBOMWhereUsed.RunModal();
                        end;
                    }
                    action("K-Calc. Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;
                        Visible = false;
                        ToolTip = 'Executes the Calc. Stan&dard Cost action.';
                        trigger OnAction()
                        begin
                            Clear(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", true);
                        end;
                    }
                }
                group("Manufa&cturing")
                {
                    Caption = 'Manufa&cturing';
                    Visible = false;
                    action("M-Where-Used")
                    {
                        Caption = 'Where-Used';
                        Image = "Where-Used";
                        Visible = false;
                        ToolTip = 'Executes the Where-Used action.';
                        trigger OnAction()
                        var
                            ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WorkDate());
                            ProdBOMWhereUsed.RunModal();
                        end;
                    }
                    action("M-Calc. Stan&dard Cost")
                    {
                        Caption = 'Calc. Stan&dard Cost';
                        Image = CalculateCost;
                        Visible = false;
                        ToolTip = 'Executes the Calc. Stan&dard Cost action.';
                        trigger OnAction()
                        begin
                            Clear(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", false);
                        end;
                    }
                }
                separator(Separator3)
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
                    ToolTip = 'Executes the Ser&vice Items action.';
                }
                group("Troubles&hooting")
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
                        ToolTip = 'Executes the Troubleshooting &Setup action.';
                    }
                    action("Troubleshooting")
                    {
                        Caption = 'Troubles&hooting';
                        Image = Troubleshoot;
                        Visible = false;
                        ToolTip = 'Executes the Troubles&hooting action.';
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
                        ToolTip = 'Executes the Resource Skills action.';
                    }
                    action("Skilled Resources")
                    {
                        Caption = 'Skilled Resources';
                        Image = Skills;
                        Visible = false;
                        ToolTip = 'Executes the Skilled Resources action.';
                        trigger OnAction()
                        var
                            ResourceSkill: Record "Resource Skill";
                        begin
                            Clear(SkilledResourceList);
                            SkilledResourceList.Initialize(ResourceSkill.Type::Item, Rec."No.", Rec.Description);
                            SkilledResourceList.RunModal();
                        end;
                    }
                }
                separator(Separator4)
                {
                }
                action(Identifiers)
                {
                    Caption = 'Identifiers';
                    Image = Indent;
                    RunObject = Page "Item Identifiers";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.", "Variant Code", "Unit of Measure Code");
                    Visible = false;
                    ToolTip = 'Executes the Identifiers action.';
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                action("S-Prices")
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                    ToolTip = 'Executes the Prices action.';
                }
                action("S-Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = Type = const(Item), Code = field("No.");
                    RunPageView = sorting(Type, Code);
                    ToolTip = 'Executes the Line Discounts action.';
                }
            }
            group("&Purchases")
            {
                Caption = '&Purchases';
                action("P-Prices")
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                    ToolTip = 'Executes the Prices action.';
                }
                action("P-Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Item No." = field("No.");
                    ToolTip = 'Executes the Line Discounts action.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Create Stockkeeping Unit")
                {
                    Caption = '&Create Stockkeeping Unit';
                    Image = CreatePutAway;
                    Visible = false;
                    ToolTip = 'Executes the &Create Stockkeeping Unit action.';
                    trigger OnAction()
                    var
                        Item: Record "Item";
                    begin
                        Item.SetRange("No.", Rec."No.");
                        REPORT.RunModal(REPORT::"Create Stockkeeping Unit", true, false, Item);
                    end;
                }
                action("C&alculate Counting Period")
                {
                    Caption = 'C&alculate Counting Period';
                    Image = Calculate;
                    Visible = false;
                    ToolTip = 'Executes the C&alculate Counting Period action.';
                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Rec);
                    end;
                }
                separator(Separator5)
                {
                }
                action("Apply Template1")
                {
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    ToolTip = 'Executes the Apply Template action.';
                    trigger OnAction()
                    var
                        TemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        TemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
                action("Calculation Purchase Price Base")
                {
                    Caption = 'Calculation Purchase Price Base';
                    Image = CalculateLines;
                    ToolTip = 'Executes the Calculation Purchase Price Base action.';
                    trigger OnAction()
                    var
                        RecLItem: Record "Item";
                    begin
                        Clear(RecLItem);
                        RecLItem.SetRange("No.", Rec."No.");
                        //Record.SetRecFilter()
                        //Report.SetTableView(Reclitem)
                        REPORT.RunModal(50004, true, false, RecLItem)
                    end;
                }
                action("Calulation Unit price")
                {
                    Caption = 'Calulation Unit price';
                    Image = CalculateCost;
                    ToolTip = 'Executes the Calulation Unit price action.';
                    trigger OnAction()
                    var
                        RecLItem: Record "Item";
                    begin
                        Clear(RecLItem);
                        RecLItem.SetRange("No.", Rec."No.");
                        //Record.SetRecFilter()
                        //Report.SetTableView(Reclitem)
                        REPORT.RunModal(50007, true, false, RecLItem)
                    end;
                }
                action("Calculation Kit Price")
                {
                    Caption = 'Calculation Kit Price';
                    Image = CalculateConsumption;
                    Visible = false;
                    ToolTip = 'Executes the Calculation Kit Price action.';
                    trigger OnAction()
                    var
                        RecLItem: Record "Item";
                    begin
                        Clear(RecLItem);
                        RecLItem.SetRange("No.", Rec."No.");
                        REPORT.RunModal(50008, true, false, RecLItem);
                    end;
                }
                action("Calc. Stan&dard Cost")
                {
                    Caption = 'Calc. Stan&dard Cost';
                    Image = CalculateCost;
                    Visible = false;
                    ToolTip = 'Executes the Calc. Stan&dard Cost action.';
                    trigger OnAction()
                    begin
                        Clear(CalculateStdCost);
                        CalculateStdCost.CalcItem(Rec."No.", true);
                    end;
                }
                action("Calculation all Prices")
                {
                    Caption = 'Calculation all Prices';
                    Image = CalculateBalanceAccount;
                    ToolTip = 'Executes the Calculation all Prices action.';
                    trigger OnAction()
                    var
                        RecLItem: Record "Item";
                    begin
                        Clear(RecLItem);
                        RecLItem := Rec;
                        RecLItem.SetRange("No.", Rec."No.");
                        RecLItem.SetRecFilter();
                        //Report.SetTableView(Reclitem)
                        REPORT.RunModal(50009, true, false, RecLItem);
                    end;
                }
            }
            action("Apply Template")
            {
                Caption = 'Apply Template';
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Apply Template action.';
                trigger OnAction()
                begin
                    Rec.FctCreateFromTemplate();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetRange(Rec."No.");
        EnablePlanningControls();
        EnableCostingControls();
    end;

    trigger OnClosePage()
    begin
        UpdatePriceOnCLose();
    end;

    trigger OnInit()
    begin
        UnitCostEnable := true;
        StandardCostEnable := true;
        OverflowLevelEnable := true;
        DampenerQtyEnable := true;
        DampenerPeriodEnable := true;
        LotAccumulationPeriodEnable := true;
        ReschedulingPeriodEnable := true;
        IncludeInventoryEnable := true;
        OrderMultipleEnable := true;
        MaximumOrderQtyEnable := true;
        MinimumOrderQtyEnable := true;
        MaximumInventoryEnable := true;
        ReorderQtyEnable := true;
        ReorderPointEnable := true;
        SafetyStockQtyEnable := true;
        SafetyLeadTimeEnable := true;
        TimeBucketEnable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Item Base" := Rec."Item Base"::Transitory;
    end;

    var
        TroubleshHeader: Record "Troubleshooting Header";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        SkilledResourceList: Page "Skilled Resource List";
        TimeBucketEnable: Boolean;
        SafetyLeadTimeEnable: Boolean;
        SafetyStockQtyEnable: Boolean;
        ReorderPointEnable: Boolean;
        ReorderQtyEnable: Boolean;
        MaximumInventoryEnable: Boolean;
        MinimumOrderQtyEnable: Boolean;
        MaximumOrderQtyEnable: Boolean;
        OrderMultipleEnable: Boolean;
        IncludeInventoryEnable: Boolean;
        ReschedulingPeriodEnable: Boolean;
        LotAccumulationPeriodEnable: Boolean;
        DampenerPeriodEnable: Boolean;
        DampenerQtyEnable: Boolean;
        OverflowLevelEnable: Boolean;
        StandardCostEnable: Boolean;
        UnitCostEnable: Boolean;
        itemcat: Record "Item Category";


    procedure EnablePlanningControls()
    var
        PlanningParameters: Record "Planning Parameters";
        PlanningGetParam: Codeunit "Planning-Get Parameters";

    begin
        PlanningParameters."Reordering Policy" := Rec."Reordering Policy";
        PlanningParameters."Include Inventory" := Rec."Include Inventory";
        PlanningGetParam.SetPlanningParameters(PlanningParameters);

        TimeBucketEnable := PlanningParameters."Time Bucket Enabled";
        SafetyLeadTimeEnable := PlanningParameters."Safety Lead Time Enabled";
        SafetyStockQtyEnable := PlanningParameters."Safety Stock Qty Enabled";
        ReorderPointEnable := PlanningParameters."Reorder Point Enabled";
        ReorderQtyEnable := PlanningParameters."Reorder Quantity Enabled";
        MaximumInventoryEnable := PlanningParameters."Maximum Inventory Enabled";
        MinimumOrderQtyEnable := PlanningParameters."Minimum Order Qty Enabled";
        MaximumOrderQtyEnable := PlanningParameters."Maximum Order Qty Enabled";
        OrderMultipleEnable := PlanningParameters."Order Multiple Enabled";
        IncludeInventoryEnable := PlanningParameters."Include Inventory Enabled";
        ReschedulingPeriodEnable := PlanningParameters."Rescheduling Period Enabled";
        LotAccumulationPeriodEnable := PlanningParameters."Lot Accum. Period Enabled";
        DampenerPeriodEnable := PlanningParameters."Dampener Period Enabled";
        DampenerQtyEnable := PlanningParameters."Dampener Quantity Enabled";
        OverflowLevelEnable := PlanningParameters."Overflow Level Enabled";

    end;


    procedure EnableCostingControls()
    begin
    end;

    local procedure UpdatePriceOnCLose()
    var
        RecLItem: Record "Item";
    begin
        Clear(RecLItem);
        RecLItem := Rec;
        RecLItem.SetRange("No.", Rec."No.");
        RecLItem.SetRecFilter();
        //Report.SetTableView(Reclitem)
        REPORT.RunModal(50009, false, false, RecLItem);
    end;

}

