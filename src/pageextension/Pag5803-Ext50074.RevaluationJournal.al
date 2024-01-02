
namespace Prodware.FTA;

using Microsoft.Inventory.Journal;
pageextension 50074 "RevaluationJournal" extends "Revaluation Journal"//5803
{
    layout


    {

        addafter("Description")
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ToolTip = 'Specifies the value of the Identifiant ECOM field.';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    rec.CalcFields("Shelf No.")
                end;
            }
        }



    }
}