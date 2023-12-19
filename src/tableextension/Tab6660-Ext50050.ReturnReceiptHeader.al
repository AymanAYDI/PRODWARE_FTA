
namespace Prodware.FTA;

using Microsoft.Sales.History;
using Microsoft.CRM.Team;
tableextension 50050 ReturnReceiptHeader extends "Return Receipt Header" //6660
{
    fields
    {
        field(50029; "Mobile Salesperson Code"; Code[10])
        {
            Caption = 'Mobile Salesperson Code';

            TableRelation = "Salesperson/Purchaser";
        }
    }
}

