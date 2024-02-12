namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Payables;

pageextension 50050 PaymentJournal extends "Payment Journal" //256
{
    layout
    {
        addafter(Description)
        {
            field("Posting Group "; Rec."Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting Group field.';
            }

        }
    }
    actions
    {
        Modify(SuggestVendorPayments)
        {
            Visible = false;
        }
        addafter(SuggestVendorPayments)
        {
            action(SuggestVendorPaymentsSPE)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest Vendor Payments';
                Ellipsis = true;
                Image = SuggestVendorPayments;
                ToolTip = 'Create payment suggestions as lines in the payment journal.';

                trigger OnAction()
                var
                    //SuggestVendorPayments --> SuggestVendorPaymentsSPEC
                    SuggestVendorPaymentsSPEC: Report "Suggest Vendor PaymentsSPEC";
                // SuggestVendorPayments: Report "Suggest Vendor Payments";
                begin
                    Clear(SuggestVendorPaymentsSPEC);
                    SuggestVendorPaymentsSPEC.SetGenJnlLine(Rec);
                    SuggestVendorPaymentsSPEC.RunModal();
                end;
            }
        }
    }
}

