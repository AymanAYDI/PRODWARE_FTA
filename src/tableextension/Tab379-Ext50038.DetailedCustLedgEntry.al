namespace Prodware.FTA;

using Microsoft.Sales.Receivables;
using Microsoft.Bank.BankAccount;
tableextension 50038 DetailedCustLedgEntry extends "Detailed Cust. Ledg. Entry"//379
{
    fields
    {
        field(51000; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            Description = 'NAVEASY.001 [Payment Method propagation] Ajout du champ';
            TableRelation = "Payment Method";
        }
        field(51006; "Customer Posting Group"; Code[10])
        {
            FieldClass = FlowField;
            // TODO CalcFormula = Lookup ("Cust. Ledger Entry"."Customer Posting Group" WHERE ("Entry No."=FIELD(Cust.Ledger Entry.No.)));
            Caption = 'Customer Posting Group';
            Description = 'NAVEASY.001 [Multi_Collectif] Ajout du champ';
            Editable = false;

        }
    }
}

