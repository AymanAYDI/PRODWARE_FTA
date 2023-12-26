namespace Prodware.FTA;

using Microsoft.Sales.Receivables;
using Microsoft.Sales.Customer;
pageextension 50007 "CustomerLedgerEntries" extends "Customer Ledger Entries" //25
{
    layout
    {
        addbefore(Control1)
        {
            group(Group0)
            {
                field(CodGPostGrpFilter; CodGPostGrpFilter)
                {
                    TableRelation = "Customer Posting Group".Code;
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
            }
        }
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; Rec."Mobile Salesperson Code")
            {
                Visible = false;
                Editable = false;
            }
        }
        addafter("Control1")
        {
            group(Group1)
            {
                field(Balance; CalcRecBalance())
                {
                    AutoFormatType = 1;
                    Editable = false;
                }
                field(CodGAccName; CodGAccName)
                {
                    Visible = false;
                    Editable = false;
                }
                field(TxtGBalAccName; TxtGBalAccName)
                {

                }
            }
        }
    }
    var
        CodGPostGrpFilter: Code[20];
        CodGAccName: Code[20];
        TxtGBalAccName: Text[50];
        DecGBalance: Integer;

    local procedure ApplyFilters();
    begin
        if CodGPostGrpFilter <> '' then
            rec.setfilter("Customer Posting Group", CodGPostGrpFilter)
        else
            rec.setfilter("Customer Posting Group", '');

        CurrPage.UPDATE(false);
    end;

    local procedure CalcRecBalance(): Decimal;
    var
        RecLCustEntry: Record "Cust. Ledger Entry";
        DecLAmount: Decimal;
    begin
        RecLCustEntry.COPY(Rec);

        if RecLCustEntry.FindFirst() then
            repeat

                RecLCustEntry.CALCFIELDS("Remaining Amt. (LCY)");
                DecLAmount += RecLCustEntry."Remaining Amt. (LCY)";

            until RecLCustEntry.NEXT() = 0;


        exit(DecLAmount);
    end;

    local procedure UpdateLineInfo(RecLCustEntry: Record "Cust. Ledger Entry");
    begin
        with RecLCustEntry do begin
            CodGAccName := "Customer No.";
            TxtGBalAccName := Description;
        end;
    end;

    trigger OnOpenPage()
    begin
        if rec.GETFILTER(Rec."Customer Posting Group") <> '' then
            CodGPostGrpFilter := rec.GETFILTER(Rec."Customer Posting Group")
        else
            CodGPostGrpFilter := '';
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateLineInfo(Rec);
    end;
}
