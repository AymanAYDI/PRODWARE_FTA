namespace Prodware.FTA;

using Microsoft.Sales.Customer;
using Microsoft.Inventory.Intrastat;
tableextension 50030 ShiptoAddress extends "Ship-to Address" //222
{
    fields
    {
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
            Caption = 'Exit Point';
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
    }
    trigger OnAfterInsert()
    var
        Cust: Record Customer;
    begin
        Cust.Get("Customer No.");
        "Transaction Type" := Cust."Transaction Type";
        "Transaction Specification" := Cust."Transaction Specification";
        "Transport Method" := Cust."Transport Method";
        "Exit Point" := Cust."Exit Point";
        Area := Cust.Area;
        "EU 3-Party Trade" := Cust."EU 3-Party Trade";
    end;
}

