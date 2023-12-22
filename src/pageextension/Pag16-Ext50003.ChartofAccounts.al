namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Account;
pageextension 50003 ChartofAccounts extends "Chart of Accounts" //16
{
    layout
    {


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

