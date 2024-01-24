namespace Prodware.FTA;
using Microsoft.Purchases.Document;
using Microsoft.Foundation.Reporting;
pageextension 50079 "PurchaseOrderList" extends "Purchase Order List" //9307
{
    layout
    {
        addafter("Document Date")
        {
            field("Order Date"; rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date when the order was created.';
            }
        }
        addafter("Job Queue Status")
        {
            field("Confirmed AR Order"; rec."Confirmed AR Order")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Commande AR confirmée field.';
            }
        }
    }
    actions
    {
        addafter("Print")
        {
            action(Email)
            {
                Ellipsis = true;
                Caption = 'Email';
                Image = Email;
                ApplicationArea = All;
                ToolTip = 'Executes the Email action.';
                trigger OnAction()
                var
                    DocPrint: Codeunit FTA_Functions;
                begin
                    DocPrint.EmailPurchHeader(Rec);
                end;
            }
        }
    }
}
