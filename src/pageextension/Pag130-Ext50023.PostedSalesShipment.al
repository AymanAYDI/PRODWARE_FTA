namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50023 "PostedSalesShipment" extends "Posted Sales Shipment" //130
{
    layout
    {
        addafter("Sell-to Contact No.")
        {
            field("Your Reference"; rec."Your Reference")
            {

            }
            field("E-Mail"; rec."E-Mail")
            {

            }
            field("Fax No."; rec."Fax No.")
            {

            }
            field("Subject Mail"; rec."Subject Mail")
            {

            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Editable = false;
            }
        }
        addafter("Responsibility Center")
        {
            field(Preparer; rec.Preparer)
            {
                Editable = false;
            }
            field(Assembler; rec.Assembler)
            {
                Editable = false;
            }
            field(Packer; rec.Packer)
            {
                Editable = false;
            }
        }
        addafter("Shipping Agent Service Code")
        {
            field("Total weight"; rec."Total weight")
            {
            }
            field("Total Parcels"; rec."Total Parcels")
            {
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Navigate")
        {
            group(Print)
            {
                action("Expédition valorisée")
                {
                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(SalesShptHeader);
                        SalesShptHeader.PrintRecords(true);
                    end;
                }
            }
        }
    }
    var
        SalesShptHeader: Record "Sales Shipment Header";
}
