namespace prodware.fta;

using Microsoft.Inventory.Setup;

pageextension 50061 "InventorySetup" extends "Inventory Setup" //461
{
    layout
    {
        addafter("Average Cost Period")
        {
            field("Negative Inventory Not Allowed"; rec."Negative Inventory Not Allowed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Negative Inventory Not Allowed field.';
            }
            field("Reservation FTA"; rec."Reservation FTA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FTA Reservation field.';
            }
            field("Template Item Transitory Code"; rec."Template Item Transitory Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Template Item Transitory Code field.';
            }
        }
        addafter("Posted Invt. Pick Nos.")
        {
            field("Transitory Item Nos."; rec."Transitory Item Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transitory Item Nos. field.';
            }
            field("Transitory Kit Item Nos."; rec."Transitory Kit Item Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transitory Kit Item Nos. field.';
            }
            field("Bored blocks Item Nos."; rec."Bored blocks Item Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bored blocks Item Nos.. field.';
            }
        }
        addafter(Numbering)
        {
            group(Montage)
            {
                field("Template Item Trans. Kit Code"; rec."Template Item Trans. Kit Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Template Item Trans. Kit Code field.';
                }
                field("Template Item Bored block Code"; rec."Template Item Bored block Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Template Item Bored block Code field.';
                }
            }
        }
    }


}
