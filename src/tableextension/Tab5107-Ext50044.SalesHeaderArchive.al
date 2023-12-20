namespace Prodware.FTA;

using Microsoft.Sales.Archive;
using Microsoft.CRM.Team;
tableextension 50044 SalesHeaderArchive extends "Sales Header Archive"  //5107
{
    fields
    {
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(51000; "Cause filing"; enum "Cause filing")
        {
            Caption = 'Cause filing';
        }
    }
}

