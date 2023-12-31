namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50022 "PurchaseCreditMemo" extends "Purchase Credit Memo" //52
{
    layout
    {
        addafter("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                Caption = 'Gen. Bus. Posting Group';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }

        }
    }
}
