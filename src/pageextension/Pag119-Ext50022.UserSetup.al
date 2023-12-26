namespace Prodware.FTA;

using System.Security.User;
pageextension 50022 "UserSetup" extends "User Setup" //119
{
    layout
    {
        addafter("User ID")
        {
            field("E-Mail"; rec."E-Mail")
            {
            }
        }
        addafter("Time Sheet Admin.")
        {
            field("Allowed To Modify Cust Dispute"; rec."Allowed To Modify Cust Dispute")
            {
            }
            field("Prepared Only"; rec."Prepared Only")
            {

            }

        }
    }
}
