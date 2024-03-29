namespace Prodware.FTA;

using Microsoft.Purchases.Payables;
using Microsoft.Sales.Customer;
pageextension 50005 "VendorLedgerEntries" extends "Vendor Ledger Entries"//29
{
    layout
    {
        addbefore("Control1")
        {
            group(group1)
            {
                field(CodGPostGrpFilter; CodGPostGrpFilter)
                {
                    TableRelation = "Customer Posting Group".Code;
                    Caption = 'Posting Group Filter';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CodGPostGrpFilter field.';
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
            }
        }
        addafter("Control1")
        {
            group(Group2)
            {
                field("Balance"; CalcRecBalance())
                {
                    AutoFormatType = 1;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CalcRecBalance() field.';
                }
                field("TxtGBalAccName"; TxtGBalAccName)
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TxtGBalAccName field.';
                }
                field("CodGAccName"; CodGAccName)
                {
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CodGAccName field.';
                }
            }
        }

    }
    trigger OnOpenPage()
    begin
        if rec.GetFilter("Vendor Posting Group") <> '' then
            CodGPostGrpFilter := rec.GetFilter("Vendor Posting Group")
        else
            CodGPostGrpFilter := '';
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateLineInfo(Rec);
    end;

    var
        CodGPostGrpFilter: Code[20];
        CodGAccName: Code[20];
        TxtGBalAccName: Text[50];
        DecGBalance: Decimal;

    local procedure UpdateLineInfo(RecLVendEntry: Record "Vendor Ledger Entry");
    begin
        with RecLVendEntry do begin
            CodGAccName := "Vendor No.";
            TxtGBalAccName := Description;
        end;
    end;

    local procedure ApplyFilters();
    begin
        if CodGPostGrpFilter <> '' then
            rec.SetFilter("Vendor Posting Group", CodGPostGrpFilter)
        else
            rec.SetFilter("Vendor Posting Group", '');

        CurrPage.Update(false)
    end;

    local procedure CalcRecBalance(): Decimal;
    var
        RecLVendEntry: Record "Vendor Ledger Entry";
        DecLAmount: Decimal;
    begin
        RecLVendEntry.Copy(Rec);
        if RecLVendEntry.findFirst() then
            repeat

                RecLVendEntry.CalcFields("Remaining Amt. (LCY)");
                DecLAmount += RecLVendEntry."Remaining Amt. (LCY)";
            until RecLVendEntry.Next() = 0;

        exit(DecLAmount);
    end;
}
