namespace Prodware.FTA;

using Microsoft.Bank.Payment;

pageextension 50086 PaymentSlipSubform extends "Payment Slip Subform" //10869
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:NI 20/06/2008 [Multi_Collectif]
    //                           - Modification of Properties of Field "Posting Gr
    //                             VISIBLE No => Yes
    //                           - Add column "ID Lettrage"
    // 
    // ------------------------------------------------------------------------
    layout
    {
        addbefore("Account Type")
        {
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to ID field.';
            }
        }

    }


    procedure IsBankInfoEditable(): Boolean
    begin
        //>>BUG NAV 2015
        //EXIT(NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]));
        exit((Rec."Account Type" in [Rec."Account Type"::Customer, Rec."Account Type"::Vendor]));
        //<<BUG NAV 2015
    end;
}

