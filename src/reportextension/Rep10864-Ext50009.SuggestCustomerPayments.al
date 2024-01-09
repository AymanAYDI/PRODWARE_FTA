namespace Prodware.FTA;

using Microsoft.Bank.Payment;
reportextension 50009 "SuggestCustomerPayments" extends "Suggest Customer Payments" //10864
{
    dataset
    {
        modify(Customer)
        {
            trigger OnAfterAfterGetRecord()
            begin
                //TODO: i can't find solution
                //     if BooGCheckPostGroup then begin
                //         GetCustLedgEntries2(true, false);
                //         GetCustLedgEntries2(false, false);
                //     end
                //    CheckAmounts(false);
            end;
        }
    }
    requestpage
    {
        layout
        {
            addafter("CurrencyFilter")
            {
                field("Payment Method Filter"; CodGPayMetFilter)
                {
                }
            }
        }
    }
    var
        CodGNextDocNo: Code[20];
        BooGCheckPostGroup: Boolean;
        CodGPayMetFilter: Code[50];
        CustEntryEdit: Codeunit 103;
}
