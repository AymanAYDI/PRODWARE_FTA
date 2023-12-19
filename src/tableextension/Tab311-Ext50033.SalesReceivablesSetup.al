namespace Prodware.FTA;

using Microsoft.Sales.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Intrastat;
tableextension 50033 SalesReceivablesSetup extends "Sales & Receivables Setup" //311
{
    fields
    {
        field(50000; "Discount All Item"; Code[10])
        {
            Caption = 'Discount All Item';
            TableRelation = "Item Discount Group";
        }
        field(50010; "Print Invoice Text"; Boolean)
        {
            Caption = 'Print Invoice Text';
        }
        field(50011; "Invoice Text"; Text[250])
        {
            Caption = 'Invoice Text';
        }
        field(50012; "Print Shipment Text"; Boolean)
        {
            Caption = 'Print Shipment Text';
        }
        field(50013; "Shipment Text"; Text[250])
        {
            Caption = 'Shipment Text';
        }
        field(51100; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type Code';
            TableRelation = "Transaction Type";
        }
        field(51101; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification Code';
            TableRelation = "Transaction Specification";
        }
        field(51102; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method Code';
            TableRelation = "Transport Method";
        }
        field(51103; "Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point Code';
            TableRelation = "Entry/Exit Point";
        }
        field(51104; "Area"; Code[10])
        {
            Caption = 'Area Code';
            TableRelation = Area;
        }
        field(51105; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(51106; "Export Item Repertory"; Text[150])
        {
            Caption = 'Export Item Repertory';
        }
        field(51107; "Export Item Repertory Archive"; Text[150])
        {
            Caption = 'Export Item Repertory Archive';
        }
        field(51108; "Export Customer Repertory"; Text[150])
        {
            Caption = 'Export Customer Repertory';
        }
        field(51109; "Export Customer Repertory Arch"; Text[150])
        {
            Caption = 'Export Customer Repertory Arch';
        }
        field(51110; "Export Sales Discount Rep"; Text[150])
        {
            Caption = 'Export Sales Discount Rep';
        }
        field(51111; "Export Sales Disc Rep Archive"; Text[150])
        {
            Caption = 'Export Sales Discount Rep Archive';
        }
        field(51112; "Export Sales Price Repertory"; Text[150])
        {
            Caption = 'Export Sales Price Repertory';
        }
        field(51113; "Export Sales Price Rep Archive"; Text[150])
        {
            Caption = 'Export Sales Price Repertory Arch';
        }
    }
}

