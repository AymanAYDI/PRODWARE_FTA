namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.PaymentTerms;
tableextension 50006 VendorLedgerEntry extends "Vendor Ledger Entry" //25
{
    fields
    {
        field(50000; CPFLG1; Text[1])
        {
            Caption = 'Lettrage ORION';
        }
        field(51000; "Payment Method Code2"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(51001; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
    }
    keys
    {
        key(key50000; "Vendor No.", Open, Positive, "Vendor Posting Group", "Due Date")
        {
        }
        key(key50001; "Vendor No.", "Document Type")
        {
        }
    }


    procedure getVendorName(CodLVendNo: Code[20]): Text[100]
    var
        RecgLVendor: Record 23;
    begin
        if RecgLVendor.GET(CodLVendNo) then
            exit(RecgLVendor.Name)
        else
            exit('');
    end;
}

