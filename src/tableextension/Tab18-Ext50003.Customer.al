namespace Prodware.FTA;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Archive;
using Microsoft.CRM.Team;
using System.Security.AccessControl;
using Microsoft.Inventory.Intrastat;
using Microsoft.Sales.Setup;
tableextension 50003 Customer extends Customer //18
{
    fields
    {
        field(50000; "Franco Amount"; Decimal)
        {
            Caption = 'Franco Amount';
        }
        field(50001; "Order confirmation"; Boolean)
        {
            Caption = 'Order confirmation';
        }
        field(50002; "Delivery with amount"; Boolean)
        {
            Caption = 'Delivery with amount';
        }
        field(50003; "India Product"; Boolean)
        {
            Caption = 'India Product';
        }
        field(50010; "No. of Archive Quotes"; Integer)
        {
            CalcFormula = count("Sales Header Archive" where("Document Type" = const(Quote),
                                                              "Sell-to Customer No." = field("No.")));
            Caption = 'No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Bill-to No. of Archive Quotes"; Integer)
        {
            CalcFormula = count("Sales Header Archive" where("Document Type" = const(Quote),
                                                              "Sell-to Customer No." = field("No.")));
            Caption = 'Bill-to No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Customer Typology"; Code[20])
        {
            Caption = 'Customer Typology';
            TableRelation = "Customer Typology";
        }
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50050; "Email G/L"; Text[80])
        {
            Caption = 'G/L Email';
            ExtendedDatatype = EMail;
        }
        field(51000; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(51001; User; Code[20])
        {
            Caption = 'User';
            Editable = false;
            TableRelation = User;
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
    }
    fieldgroups
    {
        addlast(DropDown; "Search Name")
        {

        }
    }
    trigger OnAfterInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        "Creation Date" := WorkDate();
        User := UserId;
        SalesSetup.Get();
        "Transaction Type" := SalesSetup."Transaction Type";
        "Transaction Specification" := SalesSetup."Transaction Specification";
        "Transport Method" := SalesSetup."Transport Method";
        "Exit Point" := SalesSetup."Exit Point";
        Area := SalesSetup.Area;
        "EU 3-Party Trade" := SalesSetup."EU 3-Party Trade";
        Modify()
    end;


}

