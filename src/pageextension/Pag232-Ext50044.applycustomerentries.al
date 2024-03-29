namespace prodware.fta;

using microsoft.sales.receivables;
pageextension 50044 "applycustomerentries" extends "apply customer entries" //232
{
    layout
    {
        addafter("customer no.")
        {
            field(customername; rec.Getcustomername(rec."customer no."))
            {
                caption = 'name';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the name field.';
            }
            field("customer posting group"; rec."customer posting group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s market type to link business transactions to.';
            }
        }
        addafter("remaining amount")
        {
            field(CPFLG1; rec.CPFLG1)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lettrage ORION field.';
            }
        }
    }
    procedure verifpostinggroup(codlappliesid: code[20]; codlpostinggroup: code[10]);
    var
        reclcustledgentry: record "cust. ledger entry";
        txtErrorpostinggroup001: label 'posting group must be identical by applies-to id.\you cannot select a ledger entry with a posting group %1.';
    begin
        if (codlpostinggroup <> '') then
            if codlappliesid <> '' then begin
                reclcustledgentry.Reset();
                reclcustledgentry.SetCurrentKey("applies-to id");
                reclcustledgentry.SetRange("applies-to id", codlappliesid);
                reclcustledgentry.SetFilter("customer posting group", '<>%1', codlpostinggroup);
                if reclcustledgentry.findFirst() then Error(StrSubstNo(txtErrorpostinggroup001, codlpostinggroup));
            end;
    end;
}
