namespace Prodware.FTA;

using Microsoft.Sales.Document;
pageextension 50018 "SalesCrMemoSubform" extends "Sales Cr. Memo Subform" //96
{
    layout
    {
        addfirst(Control1)
        {
            field("Item Base"; rec."Item Base")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Base field.';
            }
        }
    }
}
