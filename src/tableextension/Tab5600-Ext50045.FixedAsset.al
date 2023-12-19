namespace Prodware.FTA;

using Microsoft.FixedAssets.FixedAsset;
tableextension 50045 FixedAsset extends "Fixed Asset" //5600
{
    fields
    {
        field(51000; "Retrospective Derog. Amount"; Decimal)
        {
            Caption = 'Retrospective Derog. Amount';
        }
    }
}

