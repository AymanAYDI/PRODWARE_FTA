namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Account;
pageextension 50004 GLAccountList extends "G/L Account List"//18
{
    layout
    {
        modify("Debit Amount")
        {
            Visible = false;
        }
        modify("Credit Amount")
        {
            Visible = false;
        }
    }

}

