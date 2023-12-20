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
            CalcFormula = sum("G/L Entry"."Debit Amount" where("G/L Account No." = field("No."),
                                                                "G/L Account No." = field(Totaling),
                                                                "Business Unit Code" = field("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                "Posting Date" = field("Date Filter"),

                                                                "Source Type" = field("Source Type Filter"),
                                                                "Source No." = field("Source No. Filter")));
            Caption = 'Debit Amount Type';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51002; "Credit Amount Type"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("G/L Entry"."Credit Amount" where("G/L Account No." = field("No."),
                                                                "G/L Account No." = field("Totaling"),
                                                                 "Business Unit Code" = field("Business Unit Filter"),
                                                                 "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                 "Posting Date" = field("Date Filter"),

                                                                 "Source Type" = field("Source Type Filter"),
                                                                 "Source No." = field("Source No. Filter")));
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

