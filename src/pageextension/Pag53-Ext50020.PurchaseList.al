namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50020 "PurchaseList" extends "Purchase List"//53
{
    layout
    {


        modify("No.")
        {
            Style = StandardAccent;
            StyleExpr = BooGTransportType;
        }



        addfirst(Control1)
        {
            field("Order Type"; rec."Order Type")
            {
                Style = StandardAccent;
                StyleExpr = BooGTransportType;

            }





        }
        addafter("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {

            }

        }
    }
    trigger OnAfterGetRecord()
    var
        "Purchase Header": Record "Purchase Header";
    begin
        IF rec."Order Type" = rec."Order Type"::Transport THEN
            BooGTransportType := TRUE;
    END;

    var

        BooGTransportType: Boolean;

}








