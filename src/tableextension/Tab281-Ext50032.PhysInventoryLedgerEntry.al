namespace Prodware.FTA;

using Microsoft.Inventory.Counting.Journal;
using Microsoft.CRM.Team;
tableextension 50032 PhysInventoryLedgerEntry extends "Phys. Inventory Ledger Entry" //281
{
    fields
    {
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            Description = 'FTA1.04';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}

