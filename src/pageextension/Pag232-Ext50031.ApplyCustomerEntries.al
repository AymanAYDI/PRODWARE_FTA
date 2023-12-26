namespace prodware.fta;

using microsoft.sales.receivables;
pageextension 50031 "applycustomerentries" extends "apply customer entries" //232
{
    layout
    {
        addafter("customer no.")
        {
            field(customername; rec.getcustomername(rec."customer no."))
            {
                caption = 'name';
            }
            field("customer posting group"; rec."customer posting group")
            {
            }
        }
        addafter("remaining amount")
        {
            field(CPFLG1; rec.CPFLG1)
            {
            }
        }
    }
    procedure verifpostinggroup(codlappliesid: code[20]; codlpostinggroup: code[10]);
    var
        reclcustledgentry: record "cust. ledger entry";
        txterrorpostinggroup001: label 'posting group must be identical by applies-to id.\you cannot select a ledger entry with a posting group %1.';
    begin
        if (codlpostinggroup <> '') then
            if codlappliesid <> '' then begin
                reclcustledgentry.reset();
                reclcustledgentry.setcurrentkey("applies-to id");
                reclcustledgentry.setrange("applies-to id", codlappliesid);
                reclcustledgentry.setfilter("customer posting group", '<>%1', codlpostinggroup);
                if reclcustledgentry.findfirst() then error(strsubstno(txterrorpostinggroup001, codlpostinggroup));
            end;
    end;
}
