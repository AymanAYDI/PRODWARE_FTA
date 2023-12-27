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
        IF rec.GETFILTER("Vendor Posting Group") <> '' THEN
            CodGPostGrpFilter := rec.GETFILTER("Vendor Posting Group")
        ELSE
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

    LOCAL PROCEDURE UpdateLineInfo(RecLVendEntry: Record "Vendor Ledger Entry");
    BEGIN
        WITH RecLVendEntry DO BEGIN
            CodGAccName := "Vendor No.";
            TxtGBalAccName := Description;
        END;
    END;

    LOCAL PROCEDURE ApplyFilters();
    BEGIN
        IF CodGPostGrpFilter <> '' THEN
            rec.SETFILTER("Vendor Posting Group", CodGPostGrpFilter)
        ELSE
            rec.SETFILTER("Vendor Posting Group", '');

        CurrPage.UPDATE(FALSE)
    END;

    LOCAL PROCEDURE CalcRecBalance(): Decimal;
    VAR
        RecLVendEntry: Record "Vendor Ledger Entry";
        DecLAmount: Decimal;
    BEGIN
        RecLVendEntry.COPY(Rec);
        IF RecLVendEntry.FIND('-') THEN
            REPEAT

                RecLVendEntry.CALCFIELDS("Remaining Amt. (LCY)");
                DecLAmount += RecLVendEntry."Remaining Amt. (LCY)";
            UNTIL RecLVendEntry.NEXT() = 0;

        EXIT(DecLAmount);
    END;
}
