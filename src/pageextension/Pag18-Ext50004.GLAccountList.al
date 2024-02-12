namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Account;
pageextension 50004 GLAccountList extends "G/L Account List"//18
{
    layout
    {
        Modify("Debit Amount")
        {
            Visible = false;
        }
        Modify("Credit Amount")
        {
            Visible = false;
        }
    }

}

