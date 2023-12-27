namespace Prodware.FTA;

using System.Security.User;
pageextension 50036 "UserSetup" extends "User Setup" //119
{
    layout
    {
        addafter("User ID")
        {
            field("E-Mail"; rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the email address of the user in the User ID field.';
            }
        }
        addafter("Time Sheet Admin.")
        {
            field("Allowed To Modify Cust Dispute"; rec."Allowed To Modify Cust Dispute")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allowed To Modify Cust Dispute field.';
            }
            field("Prepared Only"; rec."Prepared Only")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Préparé uniquement field.';
            }

        }
    }
}
