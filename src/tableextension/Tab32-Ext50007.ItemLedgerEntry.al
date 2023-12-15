namespace Prodware.FTA;
using Microsoft.Inventory.Ledger;
tableextension 50007 ItemLedgerEntry extends "Item Ledger Entry" //32
{
    keys
    {
        key(Key15; "Item No.", "Location Code", Open, "Posting Date", "Variant Code")
        {
            SumIndexFields = "Remaining Quantity";
        }
        key(Key16; "Global Dimension 1 Code", "Entry Type", "Posting Date")
        {
            SumIndexFields = Quantity;
        }
    }
}

