namespace Prodware.FTA;

using Microsoft.Purchases.Vendor;
pageextension 50009 VendorCard extends "Vendor Card" //26
{
    layout
    {
        addafter("Currency Code")
        {
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
            field("Entry Point"; Rec."Entry Point")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Entry/Exit Point Code field.';
            }
            field("Area"; Rec.Area)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Area Code field.';
            }
        }
        addafter("Last Date Modified")
        {
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Creation Date field.';
            }
            field(User; rec.User)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User field.';
            }
        }
        Modify("Responsibility Center")
        {
            Visible = false;
        }
        Modify("IC Partner Code")
        {
            Visible = false;
        }
    }
    actions
    {
        addlast("Ven&dor")
        {
            action("Tarif transporteur")
            {
                ApplicationArea = All;
                Caption = 'Shipping agent Price';
                ToolTip = 'Executes the Tarif transporteur action.';
                RunObject = Page "Shipping agent prices";
                RunPageView = sorting("Shipping Agent", "Country Code", "Departement Code", "Post Code", "Pallet Nb", "Beginning Date", "Currency Code");
                RunPageLink = "Shipping Agent" = field("No.");
            }
        }
    }
}

