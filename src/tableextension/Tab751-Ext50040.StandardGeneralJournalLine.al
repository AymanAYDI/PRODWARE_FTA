namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Purchases.Vendor;
using Microsoft.Bank.BankAccount;
using Microsoft.CRM.Team;
tableextension 50040 StandardGeneralJournalLine extends "Standard General Journal Line" //751
{
    fields
    {
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                Cust.Get("Account No.");
                if "Account Type" = "Account Type"::Customer then
                    "Mobile Salesperson Code" := Cust."Mobile Salesperson Code";
                if "Account Type" = "Account Type"::Vendor then
                    "Mobile Salesperson Code" := '';
                if "Account Type" = "Account Type"::"Bank Account" then
                    "Mobile Salesperson Code" := '';
            end;
        }
        modify("Bal. Account No.")
        {
            trigger OnAfterValidate()
            var
                GLAcc: Record "G/L Account";
                Cust: Record Customer;
                Vend: Record Vendor;
                BankAcc: Record "Bank Account";
            begin
                GLAcc.Get("Bal. Account No.");
                Cust.Get("Bal. Account No.");
                Vend.Get("Bal. Account No.");
                BankAcc.Get("Bal. Account No.");
                if "Bal. Account Type" = "Bal. Account Type"::"G/L Account" then
                    if ("Account No." = '') or
                    ("Account Type" in
                    ["Account Type"::"G/L Account", "Account Type"::"Bank Account"]) then
                        "Mobile Salesperson Code" := '';
                if "Bal. Account Type" = "Bal. Account Type"::Customer then
                    "Mobile Salesperson Code" := Cust."Mobile Salesperson Code";
                if "Bal. Account Type" = "Bal. Account Type"::Vendor then
                    "Mobile Salesperson Code" := '';
                if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then
                    if ("Account No." = '') or
                    ("Account Type" in
                    ["Account Type"::"G/L Account", "Account Type"::"Bank Account"]) then
                        "Mobile Salesperson Code" := '';
            end;
        }
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}

