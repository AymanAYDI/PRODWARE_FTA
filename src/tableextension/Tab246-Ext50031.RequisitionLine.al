namespace Prodware.FTA;

using Microsoft.Inventory.Requisition;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Inventory.Item;
tableextension 50031 RequisitionLine extends "Requisition Line" //246
{
    fields
    {
        modify("No.")
        {
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item where(Type = const(Inventory),
            "Quote Associated" = filter(false));
        }
    }
}

