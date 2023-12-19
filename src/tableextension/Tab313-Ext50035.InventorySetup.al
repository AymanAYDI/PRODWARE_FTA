namespace Prodware.FTA;

using Microsoft.Inventory.Setup;
using Microsoft.Foundation.NoSeries;
using System.IO;
tableextension 50035 InventorySetup extends "Inventory Setup" //313
{
    fields
    {
        field(50000; "Reservation FTA"; Boolean)
        {
            Caption = 'FTA Reservation';
        }
        field(50001; "Transitory Item Nos."; Code[10])
        {
            Caption = 'Transitory Item Nos.';
            TableRelation = "No. Series";
        }
        field(50002; "Transitory Kit Item Nos."; Code[10])
        {
            Caption = 'Transitory Kit Item Nos.';
            TableRelation = "No. Series";
        }
        field(50003; "Template Item Transitory Code"; Code[10])
        {
            Caption = 'Template Item Transitory Code';
            TableRelation = "Config. Template Header";
        }
        field(50004; "Template Item Trans. Kit Code"; Code[10])
        {
            Caption = 'Template Item Trans. Kit Code';
            TableRelation = "Config. Template Header";
        }
        field(50005; "Bored blocks Item Nos."; Code[10])
        {
            Caption = 'Bored blocks Item Nos..';
            TableRelation = "No. Series";
        }
        field(50006; "Template Item Bored block Code"; Code[10])
        {
            Caption = 'Template Item Bored block Code';
            TableRelation = "Config. Template Header";
        }
        field(51100; "Negative Inventory Not Allowed"; Boolean)
        {
            Caption = 'Negative Inventory Not Allowed';
        }
    }
}

