namespace Prodware.FTA;

using Microsoft.Bank.Payment;
pageextension 50046 "PaymentSlip" extends "Payment Slip" //10868
{
    actions
    {
        modify(Post)
        {
            ShortCutKey = F11;
        }
    }
}
