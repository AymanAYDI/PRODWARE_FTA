namespace Prodware.FTA;

using Microsoft.Purchases.Vendor;
pageextension 50009 VendorCard extends "Vendor Card" //26
{
    layout
    {
        addAfter("Currency Code")
        {
            field("Transaction Type"; Rec."Transaction Type")
            {

            }
            field("Transaction Specification"; Rec."Transaction Specification")
            {

            }
            field("Transport Method"; Rec."Transport Method")
            {

            }
            field("Entry Point"; Rec."Entry Point")
            {

            }
            field("Area"; Rec.Area)
            {

            }
        }
        addafter("Last Date Modified")
        {
            field("Creation Date"; Rec."Creation Date")
            {

            }
            field(User; rec.User)
            {

            }
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("IC Partner Code")
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
                //TODO: page 51026 not migrated yet
                // RunObject = Page 51026;
                // RunPageView = sorting("Shipping Agent", "Country Code", "Departement Code", "Post Code", "Pallet Nb", "Beginning Date", "Currency Code");
                // RunPageLink = "Shipping Agent" = FIELD("No.");
            }
        }
    }
}

