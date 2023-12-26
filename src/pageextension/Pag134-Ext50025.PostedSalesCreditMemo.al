namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50025 "PostedSalesCreditMemo" extends "Posted Sales Credit Memo" //134
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Editable = false;
            }
        }
        addafter("No. Printed")
        {
            field("Fax No."; rec."Fax No.")
            {
            }
            field("E-Mail"; rec."E-Mail")
            {
            }
            field("Subject Mail"; rec."Subject Mail")
            {
            }
        }
    }
}
