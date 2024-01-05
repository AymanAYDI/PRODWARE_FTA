namespace Prodware.FTA;

using Microsoft.Bank.Payment;
pageextension 50081 "PaymentSlip" extends "Payment Slip" //10868
{
    actions
    {
        modify(Post)
        {
            ShortCutKey = F11;
        }
    }
}
