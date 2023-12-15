namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Ledger;
tableextension 50002 GLEntry extends "G/L Entry" //17
{
    keys
    {
        key(key50000; "Source Type", "G/L Account No.", "Posting Date", "Source No.")
        {
            SumIndexFields = "Debit Amount", "Credit Amount";
        }
        key(Key50001; "G/L Account No.", "Source Type", "Source No.", "Document No.", "Posting Date")
        {
            SumIndexFields = Amount;
        }

    }
}

