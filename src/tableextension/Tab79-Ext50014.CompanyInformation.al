namespace Prodware.FTA;
using Microsoft.Foundation.Company;
tableextension 50014 CompanyInformation extends "Company Information" //79
{
    fields
    {
        field(50000; "ECOM ID"; Code[20])
        {
            Caption = 'Identifiant ECOM';

        }
        field(50001; "Forme Juridique"; Text[50])
        {
        }
        field(50002; RCS; Text[50])
        {
        }
        field(51000; "Fax No. of Export Department"; Text[20])
        {
            Caption = 'Fax No. of Export Department';

        }
    }
}

