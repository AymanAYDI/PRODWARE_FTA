namespace Prodware.FTA;

using Microsoft.Sales.Setup;

pageextension 50058 "SalesReceivablesSetup" extends "Sales & Receivables Setup" //459
{
    layout
    {
        addbefore(Dimensions)
        {
            field("Discount All Item"; rec."Discount All Item")
            {
                ToolTip = 'Specifies the value of the Discount All Item field.';
                ApplicationArea = All;
            }
        }
        addafter("Direct Debit Mandate Nos.")
        {
            group(International)
            {
                field("EU 3-Party Trade"; rec."EU 3-Party Trade")
                {
                    ToolTip = 'Specifies the value of the EU 3-Party Trade  field.';
                    ApplicationArea = All;
                }
                field("Transaction Type"; rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type  field.';
                    ApplicationArea = All;
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                    ToolTip = 'Specifies the value of the Transaction Specification  field.';
                    ApplicationArea = All;
                }
                field("Transport Method"; rec."Transport Method")
                {
                    ToolTip = 'Specifies the value of the Transport Method  field.';
                    ApplicationArea = All;
                }
                field("Exit Point"; rec."Exit Point")
                {
                    ToolTip = 'Specifies the value of the Exit Point  field.';
                    ApplicationArea = All;
                }
                field("Area"; rec."Area")
                {
                    ToolTip = 'Specifies the value of the Area  field.';
                    ApplicationArea = All;
                }
            }
        }
        addafter("Notify On Success")
        {
            group("Shipment Invoice Text")
            {
                field("Print Shipment Text"; rec."Print Shipment Text")
                {
                    ToolTip = 'Specifies the value of the Print Shipment Text  field.';
                    ApplicationArea = All;
                }
                field("Shipment Text"; rec."Shipment Text")
                {
                    ToolTip = 'Specifies the value of the Shipment Text field.';
                    ApplicationArea = All;
                }
                field("Print Invoice Text"; rec."Print Invoice Text")
                {
                    ToolTip = 'Specifies the value of the Print Invoice Text  field.';
                    ApplicationArea = All;
                }
                field("Invoice Text"; rec."Invoice Text")
                {
                    ToolTip = 'Specifies the value of the Invoice Text  field.';
                    ApplicationArea = All;
                }
            }
            group(PrestaShop)
            {
                field("Export Item Repertory"; rec."Export Item Repertory")
                {
                    ToolTip = 'Specifies the value of the Export Item Repertory  field.';
                    ApplicationArea = All;
                }
                field("Export Item Repertory Archive"; rec."Export Item Repertory Archive")
                {
                    ToolTip = 'Specifies the value of the Export Item Repertory Archive  field.';
                    ApplicationArea = All;
                }
                field("Export Customer Repertory"; rec."Export Customer Repertory")
                {
                    ToolTip = 'Specifies the value of the Export Customer Repertory  field.';
                    ApplicationArea = All;
                }
                field("Export Customer Repertory Arch"; rec."Export Customer Repertory Arch")
                {
                    ToolTip = 'Specifies the value of the Export Customer Repertory Arch  field.';
                    ApplicationArea = All;
                }
                field("Export Sales Discount Rep"; rec."Export Sales Discount Rep")
                {
                    ToolTip = 'Specifies the value of the Export Sales Discount Rep  field.';
                    ApplicationArea = All;
                }
                field("Export Sales Disc Rep Archive"; rec."Export Sales Disc Rep Archive")
                {
                    ToolTip = 'Specifies the value of the Export Sales Disc Rep Archive  field.';
                    ApplicationArea = All;
                }
                field("Export Sales Price Repertory"; rec."Export Sales Price Repertory")
                {
                    ToolTip = 'Specifies the value of the Export Sales Price Repertory field.';
                    ApplicationArea = All;
                }
                field("Export Sales Price Rep Archive"; rec."Export Sales Price Rep Archive")
                {
                    ToolTip = 'Specifies the value of the Export Sales Price Rep Archive  field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
