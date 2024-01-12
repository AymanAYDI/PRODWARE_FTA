namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Ledger;

pageextension 50098 "ApplyGLEntries" extends "Apply G/L Entries" //10842
{
    actions
    {
        modify(SetAppliesToID)
        {
            trigger OnAfterAction()
            begin
                // EVALUATE(EntryApplID,USERID);
            end;
        }
    }
    //TODO : verifier migration action SetAppliesToID
}
