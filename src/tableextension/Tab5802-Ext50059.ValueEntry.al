namespace Prodware.FTA;

using Microsoft.Inventory.Ledger;
using Microsoft.CRM.Team;
tableextension 50059 ValueEntry extends "Value Entry" //5802
{
    fields
    {
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
    }
    keys
    {
        key(Key50000; "Document No.", "Posting Date")
        {
        }
        key(Key50001; "Global Dimension 1 Code", "Item Ledger Entry Type", "Posting Date", "Entry Type")
        {
            SumIndexFields = "Sales Amount (Expected)", "Sales Amount (Actual)", "Valued Quantity", "Cost Amount (Actual)";
        }
    }
}

