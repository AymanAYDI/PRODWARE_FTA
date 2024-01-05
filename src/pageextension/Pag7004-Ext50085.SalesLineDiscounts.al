namespace prodware.fta;

using Microsoft.Sales.Pricing;


pageextension 50085 "SalesLineDiscounts" extends "Sales Line Discounts"//7004
{
    layout
    {
        addafter(Code)
        {
            field("Item Description"; Rec."Item Description")
            {
            }
            field("Item No. 2"; Rec."Item No. 2")
            {
            }

        }

    }


}
