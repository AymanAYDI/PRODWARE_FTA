namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
pageextension 50050 "ApplyVendorEntries" extends "Apply Vendor Entries"//233
{


    layout
    {

        addafter("Vendor No.")
        {
            field("VendorName"; Rec."Vendor Name")
            {
                ToolTip = 'VendorName';
                ApplicationArea = All;

            }
        }
        addafter("Description")
        {
            field("CPFLG1"; Rec."CPFLG1")
            {
                ToolTip = 'CPFLG1';
                ApplicationArea = All;

            }
        }
    }


    PROCEDURE VerifPostingGroup(CodLAppliesID: Code[20]; CodLPostingGroup: Code[10]);
    VAR
        RecLVendorLedgEntry: Record "Vendor Ledger Entry";

    BEGIN
        IF (CodLPostingGroup <> '') THEN
            IF CodLAppliesID <> '' THEN BEGIN
                RecLVendorLedgEntry.RESET();
                RecLVendorLedgEntry.SETCURRENTKEY("Applies-to ID");
                RecLVendorLedgEntry.SETRANGE("Applies-to ID", CodLAppliesID);
                RecLVendorLedgEntry.SETFILTER("Vendor Posting Group", '<>%1', CodLPostingGroup);
                IF RecLVendorLedgEntry.FINDFIRST THEN ERROR(STRSUBSTNO(TxtErrorPostingGroup001, CodLPostingGroup));
            END;
    END;
}
