namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
using Microsoft.Bank.BankAccount;
tableextension 50039 DetailedVendorLedgEntry extends "Detailed Vendor Ledg. Entry" //380
{
    fields
    {
        field(51000; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(51001; "Vendor Posting Group"; Code[20])
        {
            CalcFormula = lookup("Vendor Ledger Entry"."Vendor Posting Group" where("Entry No." = field("Vendor Ledger Entry No.")));
            Caption = 'Vendor Posting Group';
            FieldClass = FlowField;
        }
    }
}

