
namespace Prodware.FTA;

using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Bank.BankAccount;
tableextension 50040 DetailedCVLedgEntryBuffer extends "Detailed CV Ledg. Entry Buffer" //383
{
    fields
    {
        field(51000; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';

            TableRelation = "Payment Method";
        }
    }
}

