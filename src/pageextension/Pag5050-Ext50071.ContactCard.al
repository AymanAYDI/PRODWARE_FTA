
namespace Prodware.FTA;

using Microsoft.CRM.Contact;
pageextension 50071 "ContactCard" extends "Contact Card" //5050
{
    layout
    {
        modify("Job Title")
        {
            visible = true;
        }
    }

}