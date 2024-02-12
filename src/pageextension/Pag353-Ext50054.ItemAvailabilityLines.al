namespace Prodware.FTA;

using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

pageextension 50054 ItemAvailabilityLines extends "Item Availability Lines" //353
{
    layout
    {
        // addafter("Period Name")
        // {
        //     field(Inventory; Item.Inventory)
        //     {
        //         Caption = 'Inventory';
        //         DecimalPlaces = 0 : 5;
        //         ToolTip = 'Specifies the value of the Inventory field.';
        //         ApplicationArea = All;
        //         trigger OnDrillDown()
        //         begin
        //             ShowItemLedgerEntries(false);
        //         end;
        //     }
        // }
        Modify("Item.Inventory")
        {
            Visible = true;
        }
        moveafter("Period Name"; "Item.Inventory")
        Modify(PlannedOrderRcpt)
        {
            Visible = false;
        }
    }
    // trigger OnAfterGetRecord()
    // begin
    //     Item.CalcFields(Inventory);
    // end;

    procedure ShowItemLedgerEntries(NetChange: Boolean)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        SetItemFilter();
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", Item."No.");
        ItemLedgerEntry.SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
        ItemLedgerEntry.SetFilter("Drop Shipment", Item.GetFilter("Drop Shipment Filter"));
        ItemLedgerEntry.SetFilter("Location Code", Item.GetFilter("Location Filter"));
        ItemLedgerEntry.SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
        ItemLedgerEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        if NetChange then
            ItemLedgerEntry.SetFilter("Posting Date", Item.GetFilter("Date Filter"));
        PAGE.Run(0, ItemLedgerEntry);
    end;

    local procedure SetItemFilter()
    begin
        if AmountType = AmountType::"Net Change" then
            Item.SetRange("Date Filter", Rec."Period Start", Rec."Period End")
        else
            Item.SetRange("Date Filter", 0D, Rec."Period End");
    end;

    var
        Item: Record "Item";
        AmountType: Option "Net Change","Balance at Date";

}

