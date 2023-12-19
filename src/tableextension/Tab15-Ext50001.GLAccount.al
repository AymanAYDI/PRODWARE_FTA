namespace Prodware.FTA;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Ledger;
tableextension 50001 GLAccount extends "G/L Account" //15 
{
    fields
    {
        field(51000; "Source Type Filter"; enum "Source Type Filter")
        {
            Caption = 'Source Type Filter';

            FieldClass = FlowFilter;

        }
        field(51001; "Debit Amount Type"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("G/L Entry"."Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                "G/L Account No." = FIELD(Totaling),
                                                                "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                "Posting Date" = FIELD("Date Filter"),

                                                                "Source Type" = FIELD("Source Type Filter"),
                                                                "Source No." = FIELD("Source No. Filter")));
            Caption = 'Debit Amount Type';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51002; "Credit Amount Type"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("G/L Entry"."Credit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                "G/L Account No." = FIELD("Totaling"),
                                                                 "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Posting Date" = FIELD("Date Filter"),

                                                                 "Source Type" = FIELD("Source Type Filter"),
                                                                 "Source No." = FIELD("Source No. Filter")));
            Caption = 'Credit Amount Type';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51003; "Source No. Filter"; Code[20])
        {

            FieldClass = FlowFilter;
        }
    }
}

