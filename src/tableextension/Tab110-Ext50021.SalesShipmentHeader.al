namespace Prodware.FTA;

using Microsoft.Sales.History;
using Microsoft.CRM.Team;
tableextension 50021 SalesShipmentHeader extends "Sales Shipment Header" //110
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
        }
        field(50006; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(50007; "Subject Mail"; Text[50])
        {
            Caption = 'Sujet Mail';
        }
        field(50012; Preparer; Text[30])
        {
            Caption = 'Preparer';
            //TODO: table SPE not migrated yet
            //TableRelation = "Workshop Person";
        }
        field(50013; Assembler; Text[30])
        {
            Caption = 'Assembler';
            //TODO: table SPE not migrated yet
            //TableRelation = "Workshop Person";
        }
        field(50014; Packer; Text[30])
        {
            Caption = 'Packer';
            //TODO: table SPE not migrated yet
            //TableRelation = "Workshop Person";
        }
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}

