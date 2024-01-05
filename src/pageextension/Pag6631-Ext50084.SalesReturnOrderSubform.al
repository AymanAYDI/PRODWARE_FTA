
namespace Prodware.FTA;

using Microsoft.Sales.Document;
pageextension 50084 "SalesReturnOrderSubform" extends "Sales Return Order Subform"//6631
{
    layout
    {

        addafter("Type")
        {
            field("Item Base"; Rec."Item Base")
            {
                ToolTip = 'Item Base';
                ApplicationArea = All;
            }
        }
    }
}