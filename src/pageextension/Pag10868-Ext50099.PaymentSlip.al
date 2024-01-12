namespace Prodware.FTA;

using Microsoft.Bank.Payment;
using Microsoft.Sales.Customer;
pageextension 50099 "PaymentSlip" extends "Payment Slip" //10868
{
    actions
    {
        modify(Post)
        {
            ShortCutKey = F11;
        }
        modify(SuggestCustomerPayments)
        {
            Visible = false;
        }
        addafter(SuggestCustomerPayments)
        {
            action(SuggestCustomerPaymentsSPE)
            {
                ApplicationArea = all;
                Caption = 'Suggest &Customer Payments';
                Image = SuggestCustomerPayments;
                ToolTip = 'Process open customer ledger entries (entries that result from posting invoices, finance charge memos, credit memos, and payments) to create a payment suggestion as lines in a payment slip.';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    PaymentClass: Record "Payment Class";
                    // CreateCustomerPmtSuggestion: Report "Suggest Customer Payments";
                    // i change CreateCustomerPmtSuggestion with "Suggest Customer Payments SPE"
                    SuggestCustomerPaymentsSPE: Report "Suggest Customer Payments SPE";
                    Text002: Label 'This payment class does not authorize customer suggestions.';
                    Text003: Label 'You cannot suggest payments on a posted header.';
                begin
                    if Rec."Status No." <> 0 then
                        Message(Text003)
                    else
                        if PaymentClass.Get(Rec."Payment Class") then
                            if PaymentClass.Suggestions = PaymentClass.Suggestions::Customer then begin
                                SuggestCustomerPaymentsSPE.SetGenPayLine(Rec);
                                Customer.SetRange("Partner Type", Rec."Partner Type");
                                SuggestCustomerPaymentsSPE.SetTableView(Customer);
                                SuggestCustomerPaymentsSPE.RunModal();
                                Clear(SuggestCustomerPaymentsSPE);
                            end else
                                Message(Text002);
                end;
            }

        }
        modify(SuggestVendorPayments)
        {
            Visible = false;
        }
        addafter(SuggestVendorPayments)
        {
            action(SuggestVendorPaymentsSPE)
            {
                ApplicationArea = All;
                Caption = 'Suggest &Vendor Payments';
                Image = SuggestVendorPayments;
                ToolTip = 'Process open vendor ledger entries (entries that result from posting invoices, finance charge memos, credit memos, and payments) to create a payment suggestion as lines in a payment slip. ';

                trigger OnAction()
                var
                    PaymentClass: Record "Payment Class";
                    SuggestVendorPaymentsFR2: Report "Suggest Vendor Payments FR 2";
                    // CreateVendorPmtSuggestion: Report "Suggest Vendor Payments FR";
                    Text001: Label 'This payment class does not authorize vendor suggestions.';
                    Text003: Label 'You cannot suggest payments on a posted header.';
                begin
                    if Rec."Status No." <> 0 then
                        Message(Text003)
                    else
                        if PaymentClass.Get(Rec."Payment Class") then
                            if PaymentClass.Suggestions = PaymentClass.Suggestions::Vendor then begin
                                SuggestVendorPaymentsFR2.SetGenPayLine(Rec);
                                SuggestVendorPaymentsFR2.RunModal();
                                Clear(SuggestVendorPaymentsFR2);
                            end else
                                Message(Text001);
                end;
            }
        }

    }
}
