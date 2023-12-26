namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50029 "PostedSalesCreditMemos" extends "Posted Sales Credit Memos" //144
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Visible = false;
            }
        }
    }
}
