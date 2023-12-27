
namespace Prodware.FTA;

using Microsoft.Inventory.Availability;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Item;

pageextension 50054 ItemAvailabilityLines extends "Item Availability Lines" //353
{
    layout
    {
        addafter("Period Name")
        {
            field(Inventory; Item.Inventory)
            {
                Caption = 'Inventory';
                DecimalPlaces = 0 : 5;

                trigger OnDrillDown()
                begin
                    ShowItemLedgerEntries(false);
                end;
            }
        }
        modify(PlannedOrderRcpt)
        {
            Visible = FALSE;
        }
    }
    procedure ShowItemLedgerEntries(NetChange: Boolean)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        SetItemFilter();
        ItemLedgerEntry.RESET();
        ItemLedgerEntry.SETCURRENTKEY("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
        ItemLedgerEntry.SETFILTER("Variant Code", Item.GETFILTER("Variant Filter"));
        ItemLedgerEntry.SETFILTER("Drop Shipment", Item.GETFILTER("Drop Shipment Filter"));
        ItemLedgerEntry.SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
        ItemLedgerEntry.SETFILTER("Global Dimension 1 Code", Item.GETFILTER("Global Dimension 1 Filter"));
        ItemLedgerEntry.SETFILTER("Global Dimension 2 Code", Item.GETFILTER("Global Dimension 2 Filter"));
        IF NetChange THEN
            ItemLedgerEntry.SETFILTER("Posting Date", Item.GETFILTER("Date Filter"));
        PAGE.RUN(0, ItemLedgerEntry);
    end;

    local procedure SetItemFilter()
    begin
        IF AmountType = AmountType::"Net Change" THEN
            Item.SETRANGE("Date Filter", Rec."Period Start", Rec."Period End")
        ELSE
            Item.SETRANGE("Date Filter", 0D, Rec."Period End");
    end;

    var
        Item: Record "Item";
        AmountType: Option "Net Change","Balance at Date";

}

