namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Vendor;
tableextension 50037 PaymentBuffer extends "Payment Buffer" //372
{
    fields
    {
        field(51000; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
            TableRelation = "Vendor Posting Group";
        }
    }
}

