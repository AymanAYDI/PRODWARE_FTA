
namespace Prodware.FTA;

using Microsoft.Foundation.Company;

pageextension 50001 CompanyInFormation extends "Company InFormation" //1
{
    layout
    {

        addafter("Industrial Classification")
        {
            field("ECOM ID"; Rec."ECOM ID")
            {
                ToolTip = 'Specifies the value of the Identifiant ECOM field.';
                ApplicationArea = All;
            }
        }
        addafter("Picture")
        {
            field("Forme Juridique"; Rec."Forme Juridique")
            {
                ToolTip = 'Specifies the value of the Forme Juridique field.';
                ApplicationArea = All;
            }
            field(RCS; rec.RCS)
            {
                ToolTip = 'Specifies the value of the RCS field.';
                ApplicationArea = All;
            }
        }
        addafter("Forme Juridique")
        {
            field("Fax No. of Export Department"; rec."Fax No. of Export Department")
            {
                ToolTip = 'Specifies the value of the Fax No. of Export Department field.';
                ApplicationArea = All;
            }
        }
    }
}

