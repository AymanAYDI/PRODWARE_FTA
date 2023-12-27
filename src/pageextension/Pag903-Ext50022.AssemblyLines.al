
namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Assembly.Document;


pageextension 50022 "AssemblyLines" extends "Assembly Lines"//903

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
                Promoted = TRUE;
                PromotedIsBig = TRUE;
                Image = View;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    myInt: Integer;

                    SalesHeader: Record "Sales Header";
                begin

                    //>>MIGR NAV 2015
                    IF RecGAssToOrder."Document Type" = RecGAssToOrder."Document Type"::Order THEN
                        SalesHeader.GET(RecGAssToOrder."Document Type", RecGAssToOrder."Document No.");
                    PAGE.RUN(PAGE::"Sales Order", SalesHeader);

                END;
            }
        }

    }


    trigger OnAfterGetRecord()
    BEGIN

        IF NOT RecGAssToOrder.GET(rec."Document Type", rec."Document No.") THEN
            RecGAssToOrder.INIT();

    END;

    VAR
        RecGAssToOrder: Record 904;

}

