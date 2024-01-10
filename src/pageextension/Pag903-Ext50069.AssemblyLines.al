
namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Assembly.Document;


pageextension 50069 "AssemblyLines" extends "Assembly Lines"//903

{
    layout
    {
        addafter("Document No.")
        {
            field("RecGAssToOrder.Document Type"; "RecGAssToOrder"."Document Type")
            {
                ToolTip = 'Document Type';
                ApplicationArea = All;
            }
            field("RecGAssToOrder.Document No."; "RecGAssToOrder"."Document No.")
            {
                ToolTip = 'Document No';
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        addbefore("Item &Tracking Lines")
        {
            action("Show Sales Documen")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = View;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    myInt: Integer;

                    SalesHeader: Record "Sales Header";
                begin

                    //>>MIGR NAV 2015
                    if RecGAssToOrder."Document Type" = RecGAssToOrder."Document Type"::Order then
                        SalesHeader.GET(RecGAssToOrder."Document Type", RecGAssToOrder."Document No.");
                    PAGE.RUN(PAGE::"Sales Order", SalesHeader);

                end;
            }
        }

    }


    trigger OnAfterGetRecord()
    begin

        if not RecGAssToOrder.GET(rec."Document Type", rec."Document No.") then
            RecGAssToOrder.INIT();

    end;

    VAR
        RecGAssToOrder: Record 904;

}

