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
                    Caption = 'Posting Group Filter';
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
        addafter("Salesperson Code")
        {
            field("Mobile Salesperson Code"; Rec."Mobile Salesperson Code")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Mobile Salesperson Code field.';
            }
        }
        addafter("Control1")
        {
            group(Group1)
            {
                field(Balance; CalcRecBalance())
                {
                    Caption = 'Balance';
                    AutoFormatType = 1;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CalcRecBalance() field.';
                }
                field(CodGAccName; CodGAccName)
                {
                    Caption = 'Account No.';
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CodGAccName field.';
                }
                field(TxtGBalAccName; TxtGBalAccName)
                {
                    Caption = 'Account Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TxtGBalAccName field.';
                }
            }
        }
    }
    var
        CodGPostGrpFilter: Code[20];
        CodGAccName: Code[20];
        TxtGBalAccName: Text[100];


    local procedure ApplyFilters();
    begin
        if CodGPostGrpFilter <> '' then
            rec.SetFilter("Customer Posting Group", CodGPostGrpFilter)
        else
            rec.SetFilter("Customer Posting Group", '');

        CurrPage.Update(false);
    end;

    local procedure CalcRecBalance(): Decimal;
    var
        RecLCustEntry: Record "Cust. Ledger Entry";
        DecLAmount: Decimal;
    begin
        RecLCustEntry.Copy(Rec);

        if RecLCustEntry.findFirst() then
            repeat

                RecLCustEntry.CalcFields("Remaining Amt. (LCY)");
                DecLAmount += RecLCustEntry."Remaining Amt. (LCY)";

            until RecLCustEntry.Next() = 0;


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
        if rec.GetFilter(Rec."Customer Posting Group") <> '' then
            CodGPostGrpFilter := rec.GetFilter(Rec."Customer Posting Group")
        else
            CodGPostGrpFilter := '';
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateLineInfo(Rec);
    end;
}
