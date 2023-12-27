namespace Prodware.FTA;

using Microsoft.Sales.History;
using Microsoft.CRM.Team;
tableextension 50012 "SalesCrMemoHeader" extends "Sales Cr.Memo Header" //114
{
    fields
    {
        field(50005; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = ToBeClassified;
        }
        field(50006; "E-Mail"; Text[80])
        {
            caption = 'E-Mail';
        }
        field(50007; "Subject Mail"; Text[50])
        {
            ;
            Caption = 'Subject Mail';
        }
        field(50008; "Mobile Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Mobile Salesperson Code';
        }
        field(50009; "Shipping Agent Name"; Text[50])
        {
            Caption = 'Shipping Agent Name';
        }
        field(50010; "Shipping Order No."; Code[20])
        {
            Caption = 'Shipping Order No.';
        }
    }
}
