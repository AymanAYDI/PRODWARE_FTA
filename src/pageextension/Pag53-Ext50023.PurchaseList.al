namespace Prodware.FTA;

using Microsoft.Purchases.Document;
pageextension 50023 "PurchaseList" extends "Purchase List"//53
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
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Type field.';
            }





        }
        addafter("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date when the order was created.';
            }

        }
    }
    trigger OnAfterGetRecord()
    var
        "Purchase Header": Record "Purchase Header";
    begin
        if rec."Order Type" = rec."Order Type"::Transport then
            BooGTransportType := true;
    end;

    var

        BooGTransportType: Boolean;

}








