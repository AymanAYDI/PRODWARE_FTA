namespace Prodware.FTA;

using Microsoft.Sales.History;
pageextension 50031 "PostedSalesShipment" extends "Posted Sales Shipment" //130
{
    layout
    {
        modify("Shipping Agent Code")
        {
            Editable = true;
        }
        addafter("Sell-to Contact No.")
        {
            field("Your Reference"; rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Your Reference field.';
            }
            field("E-Mail"; rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the E-Mail field.';
            }
            field("Fax No."; rec."Fax No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Fax No. field.';
            }
            field("Subject Mail"; rec."Subject Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sujet Mail field.';
            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; rec."Mobile Salesperson Code")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
        }
        addafter("Responsibility Center")
        {
            field(Preparer; rec.Preparer)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Preparer field.';
            }
            field(Assembler; rec.Assembler)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Assembler field.';
            }
            field(Packer; rec.Packer)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packer field.';
            }

        }
        addafter("Shipping Agent Service Code")
        {
            field("Total weight"; rec."Total weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total weight field.';
            }
            field("Total Parcels"; rec."Total Parcels")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Parcels field.';
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
                    ApplicationArea = All;
                    ToolTip = 'Executes the Expédition valorisée action.';
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
