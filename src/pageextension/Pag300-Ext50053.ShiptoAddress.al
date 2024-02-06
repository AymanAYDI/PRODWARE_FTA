
namespace Prodware.FTA;

using Microsoft.Sales.Customer;

pageextension 50053 ShiptoAddress extends "Ship-to Address" //300
{
    layout
    {
        addafter("Customer No.")
        {
            group(International)
            {
                Caption = 'International';
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EU 3-Party Trade field.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Type Code field.';
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction Specification Code field.';
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transport Method Code field.';
                }
                field("Exit Point"; Rec."Exit Point")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exit Point field.';
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Area Code field.';
                }
            }
        }
    }
}

