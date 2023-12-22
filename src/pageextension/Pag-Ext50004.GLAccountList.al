namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Account;
pageextension 50004 GLAccountList extends "G/L Account List"
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



    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SETRANGE("G/L Entry Type Filter","G/L Entry Type Filter"::Definitive);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SETRANGE("G/L Entry Type Filter","G/L Entry Type Filter"::Definitives);
    */
    //end;
}

