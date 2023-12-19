namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.CRM.Team;
using Microsoft.Bank.BankAccount;
tableextension 50015 GenJournalLine extends "Gen. Journal Line" //81
{
    fields
    {
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(51000; "Payment Method Code2"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
    }

}

