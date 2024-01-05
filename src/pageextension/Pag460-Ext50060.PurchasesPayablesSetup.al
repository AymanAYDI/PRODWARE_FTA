namespace prodware.fta;

using Microsoft.Purchases.Setup;

pageextension 50060 "PurchasesPayablesSetup" extends "Purchases & Payables Setup" //460
{
    layout
    {
        addafter("Number Series")
        {
            group(NavEas)
            {
                field("Charge (Item) used for Transp."; rec."Charge (Item) used for Transp.")
                {
                    ToolTip = 'Specifies the value of the Charge (Item) used for Transp. field.';
                    ApplicationArea = All;
                }
            }
            group(International)
            {
                field("Transaction Type"; rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type Code field.';
                    ApplicationArea = All;
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                    ToolTip = 'Specifies the value of the Transaction Specification Code field.';
                    ApplicationArea = All;
                }
                field("Transport Method"; rec."Transport Method")
                {
                    ToolTip = 'Specifies the value of the Transport Method Code field.';
                    ApplicationArea = All;
                }
                field("Entry  Point"; rec."Entry  Point")
                {
                    ToolTip = 'Specifies the value of the Entry/Exit Point Code field.';
                    ApplicationArea = All;
                }
                field("Area"; rec."Area")
                {
                    ToolTip = 'Specifies the value of the Area Code field.';
                    ApplicationArea = All;
                }
            }

        }
    }
}
