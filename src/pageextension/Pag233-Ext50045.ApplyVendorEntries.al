namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
pageextension 50045 ApplyVendorEntries extends "Apply Vendor Entries" //233
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>EASY1.00
    // NAVEASY:MA 25/06/2008 : [Multi_Collectif]
    //                        - Add field "Vendor Posting Group"
    //                        - Checking of the unicity of the Posting Group by Applies-to ID:
    //                           Add Function VerifPostingGroup()
    //                           Add code in function SetVendApplId()
    //                        Suppression of the modifications related to the Management of the [Gestion_Tiers_Payeur]
    // 
    // ------------------------------------------------------------------------


    layout
    {

        addafter("Vendor No.")
        {
            field(VendorName; Rec.getVendorName(Rec."Vendor No."))
            {
                Caption = 'Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name field.';
            }
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                Caption = 'Vendor Posting Group';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Posting Group field.';
            }
        }
        addafter(Description)
        {
            field("CPFLG1"; Rec."CPFLG1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lettrage ORION field.';
            }
        }
    }
    procedure VerifPostingGroup(CodLAppliesID: Code[20]; CodLPostingGroup: Code[10])
    var
        RecLVendorLedgEntry: Record "Vendor Ledger Entry";
        TxtErrorPostingGroup001: Label 'Posting Group must be identical by Applies-to ID.\You cannot select a Ledger Entry with a Posting Group %1.';
    begin
        if (CodLPostingGroup <> '') then
            if CodLAppliesID <> '' then begin
                RecLVendorLedgEntry.RESET();
                RecLVendorLedgEntry.SETCURRENTKEY("Applies-to ID");
                RecLVendorLedgEntry.SETRANGE("Applies-to ID", CodLAppliesID);
                RecLVendorLedgEntry.SETFILTER("Vendor Posting Group", '<>%1', CodLPostingGroup);
                if RecLVendorLedgEntry.FINDFIRST() then ERROR(STRSUBSTNO(TxtErrorPostingGroup001, CodLPostingGroup));
            end;
    end;
}

