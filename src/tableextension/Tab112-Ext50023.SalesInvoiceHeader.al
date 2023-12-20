namespace Prodware.FTA;

using Microsoft.Sales.History;
using Microsoft.CRM.Team;
tableextension 50023 SalesInvoiceHeader extends "Sales Invoice Header" //112
{
    fields
    {
        field(50002; "Total weight"; Decimal)
        {
            Caption = 'Total weight';
            DecimalPlaces = 0 : 2;
        }
        field(50003; "Total Parcels"; Decimal)
        {
            Caption = 'Total Parcels';
            DecimalPlaces = 0 : 2;
        }
        field(50005; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            Editable = true;
        }
        field(50006; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            Description = 'FTA1.01';
        }
        field(50007; "Subject Mail"; Text[50])
        {
            Caption = 'Sujet Mail';
        }
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(51008; "Shipping Agent Name"; Text[50])
        {
            Caption = 'Shipping Agent Name';
        }
        field(51009; "Shipping Order No."; Code[20])
        {
            Caption = 'Shipping Order No.';
        }
    }
}

