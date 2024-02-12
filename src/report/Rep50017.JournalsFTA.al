// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license inFormation.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Finance.GeneralLedger.Reports;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Period;
using System.Utilities;

report 50017 JournalsFTA //Dupliquer de 10801
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/Journals.rdl';
    ApplicationArea = All;
    Caption = 'Journals';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Date; Date)
        {
            DataItemTableView = sorting("Period Type", "Period Start");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Period Type", "Period Start";
            column(Title; Title)
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(StrSubstNo_Text006____; StrSubstNo(Text006, ''))
            {
            }
            column(StrSubstNo_Text007____; StrSubstNo(Text007, ''))
            {
            }
            column(GLEntry2_TABLECAPTION__________Filter; GLEntry2.TableCaption + ': ' + Filter)
            {
            }
            column("Filter"; Filter)
            {
            }
            column(Hidden; Hidden)
            {
            }
            column(GBoolCentralisationPiece; GBoolCentralisationPiece)
            {

            }
            column(ConstGText001; ConstGText001)
            {

            }
            column(FiscalYearStatusText; FiscalYearStatusText)
            {
            }
            column(SourceCode_TABLECAPTION__________Filter2; SourceCode.TableCaption + ': ' + Filter2)
            {
            }
            column(Filter2; Filter2)
            {
            }
            column(DisplayEntries; DisplayEntries)
            {
            }
            column(SortingByNo; SortingByNo)
            {
            }
            column(DateRecNo; DateRecNo)
            {
            }
            column(DisplayCentral; DisplayCentral)
            {
            }
            column(DebitTotal; DebitTotal)
            {
            }
            column(CreditTotal; CreditTotal)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(External_Document_No_Caption; External_Document_No_CaptionLbl)
            {
            }
            column(G_L_Account_No_Caption; G_L_Account_No_CaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(Grand_Total__Caption; Grand_Total__CaptionLbl)
            {
            }
            dataitem(SourceCode; "Source Code")
            {
                DataItemTableView = sorting(Code);
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Code";
                column(Date__Period_Type_; Date."Period Type")
                {
                }
                column(Date__Period_Name____YearString; Date."Period Name" + YearString)
                {
                }
                column(PeriodTypeNo; PeriodTypeNo)
                {
                }
                column(SourceCode_Code; Code)
                {
                }
                column(SourceCode_Description; Description)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Source Code" = field(Code);
                    DataItemTableView = sorting("Source Code", "Posting Date");
                    column(SourceCode2_Code; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2_Description; SourceCode2.Description)
                    {
                    }
                    column(G_L_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(G_L_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(G_L_Entry__Posting_Date_; Format("Posting Date"))
                    {
                    }
                    column(G_L_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(G_L_Entry__External_Document_No__; "External Document No.")
                    {
                    }
                    column(G_L_Entry__G_L_Account_No__; "G/L Account No.")
                    {
                    }
                    column(G_L_Entry_Description; Description)
                    {
                    }
                    column(StrSubstNo_Text008_FIELDCAPTION__Document_No_____Document_No___; StrSubstNo(Text008, FieldCaption("Document No."), "Document No."))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if DisplayEntries then
                            if GBoolCentralisationPiece then begin
                                RecGLEntryTEMP.Reset();
                                RecGLEntryTEMP.SetCurrentKey("G/L Account No.", "Document No.", "Posting Date");
                                RecGLEntryTEMP.SetRange("G/L Account No.", "G/L Account No.");
                                RecGLEntryTEMP.SetRange("Posting Date", "Posting Date");
                                RecGLEntryTEMP.SetRange("Document Type", "Document Type");
                                RecGLEntryTEMP.SetRange("Document No.", "Document No.");
                                if RecGLEntryTEMP.findFirst() then
                                    CurrReport.Skip();

                                RecGLEntry.Reset();
                                RecGLEntry.SetCurrentKey("G/L Account No.", "Document No.", "Posting Date");
                                RecGLEntry.CopyFilters("G/L Entry");
                                RecGLEntry.SetRange("G/L Account No.", "G/L Account No.");
                                RecGLEntry.SetRange("Posting Date", "Posting Date");
                                RecGLEntry.SetRange("Document Type", "Document Type");
                                RecGLEntry.SetRange("Document No.", "Document No.");
                                if RecGLEntry.findFirst() then
                                    repeat
                                        if RecGLEntry."Entry No." > "Entry No." then begin
                                            "Debit Amount" := "Debit Amount" + RecGLEntry."Debit Amount";
                                            "Credit Amount" := "Credit Amount" + RecGLEntry."Credit Amount";
                                        end;
                                    until RecGLEntry.Next() = 0;

                                RecGLEntryTEMP.Init();
                                RecGLEntryTEMP := "G/L Entry";
                                RecGLEntryTEMP.Insert();


                                DebitTotal := DebitTotal + "Debit Amount";
                                CreditTotal := CreditTotal + "Credit Amount";

                            end
                            else begin
                                DebitTotal := DebitTotal + "Debit Amount";
                                CreditTotal := CreditTotal + "Credit Amount";
                            end;

                    end;

                    trigger OnPostDataItem()
                    begin
                        if Date."Period Type" = Date."Period Type"::Date then
                            Finished := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not DisplayEntries then
                            CurrReport.Break();

                        if DisplayEntries then
                            case SortingBy of
                                SortingBy::"Posting Date":
                                    SetCurrentKey("Source Code", "Posting Date", "Document No.");
                                SortingBy::"Document No.":
                                    SetCurrentKey("Source Code", "Document No.", "Posting Date");
                            end;

                        if StartDate > Date."Period Start" then
                            Date."Period Start" := StartDate;
                        if EndDate < Date."Period End" then
                            Date."Period End" := EndDate;
                        if Date."Period Type" <> Date."Period Type"::Date then
                            SetRange("Posting Date", Date."Period Start", Date."Period End")
                        else
                            SetRange("Posting Date", StartDate, EndDate);
                    end;
                }
                dataitem("G/L Account"; "G/L Account")
                {
                    DataItemTableView = sorting("No.");
                    PrintOnlyIfDetail = true;
                    column(SourceCode2_Code_Control1120096; SourceCode2.Code)
                    {
                    }
                    column(SourceCode2_Description_Control1120098; SourceCode2.Description)
                    {
                    }
                    column(GLEntry2__Debit_Amount_; GLEntry2."Debit Amount")
                    {
                    }
                    column(GLEntry2__Credit_Amount_; GLEntry2."Credit Amount")
                    {
                    }
                    column(G_L_Account___No__; "No.")
                    {
                    }
                    dataitem(GLEntry2; "G/L Entry")
                    {
                        DataItemTableView = sorting("G/L Account No.", "Posting Date", "Source Code");
                        column(G_L_Account__Name; "G/L Account".Name)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not DisplayEntries then begin
                                DebitTotal := DebitTotal + "Debit Amount";
                                CreditTotal := CreditTotal + "Credit Amount";
                            end;
                        end;

                        trigger OnPostDataItem()
                        begin
                            if Date."Period Type" = Date."Period Type"::Date then
                                Finished := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetCurrentKey("G/L Account No.", "Posting Date", "Source Code");
                            SetRange("G/L Account No.", "G/L Account"."No.");
                            if Date."Period Type" <> Date."Period Type"::Date then
                                SetRange("Posting Date", Date."Period Start", Date."Period End")
                            else
                                SetRange("Posting Date", StartDate, EndDate);
                            SetRange("Source Code", SourceCode.Code);
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        if not DisplayCentral then
                            CurrReport.Break();
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    SourceCode2 := SourceCode;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                YearString := '';
                if Date."Period Type" <> Date."Period Type"::Year then begin
                    Year := Date2DMY("Period End", 3);
                    YearString := ' ' + Format(Year);
                end;
                if Finished then
                    CurrReport.Break();
                PeriodTypeNo := "Period Type";
                DateRecNo += 1;
            end;

            trigger OnPreDataItem()
            var
                Period: Record Date;
            begin
                Hidden := false;

                if GetFilter("Period Type") = '' then
                    Error(Text004, FieldCaption("Period Type"));
                if GetFilter("Period Start") = '' then
                    Error(Text004, FieldCaption("Period Start"));
                if CopyStr(GetFilter("Period Start"), 1, 1) = '.' then
                    Error(Text005);
                StartDate := GetRangeMin("Period Start");
                CopyFilter("Period Type", Period."Period Type");
                Period.SetRange("Period Start", StartDate);
                if not Period.findFirst() then
                    Error(Text009, StartDate, GetFilter("Period Type"));
                DateFilterCalc.CreateFiscalYearFilter(TextDate, TextDate, StartDate, 0);
                TextDate := ConvertStr(TextDate, '.', ',');
                VerifiyDateFilter(TextDate);
                TextDate := CopyStr(TextDate, 1, 8);
                Evaluate(PreviousStartDate, TextDate);
                if CopyStr(GetFilter("Period Start"), StrLen(GetFilter("Period Start")), 1) = '.' then
                    EndDate := 0D
                else
                    EndDate := GetRangeMax("Period Start");
                if EndDate = StartDate then
                    EndDate := ReturnEndingPeriod(StartDate, Date.GetRangeMin("Period Type"));
                Clear(Period);
                CopyFilter("Period Type", Period."Period Type");
                Period.SetRange("Period End", ClosingDate(EndDate));
                if not Period.findFirst() then
                    Error(Text010, EndDate, GetFilter("Period Type"));
                FiscalYearStatusText := StrSubstNo(Text011, CheckFiscalYearStatus(GetFilter("Period Start")));

                DateRecNo := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Journals; Display)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Display';
                        OptionCaption = 'Journals,Centralized Journals,Journals and Centralization';
                        ToolTip = 'Specifies how the report displays the results. Choose Journals to display the amounts of individual transactions. Choose Centralized Journals to display amounts centralized per account. Choose Journals and Centralization to display both.';

                        trigger OnValidate()
                        begin
                            PageRefresh();
                        end;
                    }
                    field("Posting Date"; SortingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sorted by';
                        OptionCaption = 'Posting Date,Document No.';
                        ToolTip = 'Specifies criteria for arranging inFormation in the report.';

                        trigger OnValidate()
                        begin
                            if SortingBy = SortingBy::"Document No." then
                                if not DocumentNoVisible then
                                    Error(Text666, SortingBy);
                            if SortingBy = SortingBy::"Posting Date" then
                                if not PostingDateVisible then
                                    Error(Text666, SortingBy);
                        end;
                    }
                    field("Total by document"; GBoolCentralisationPiece)
                    {
                        Caption = 'Total by document';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DocumentNoVisible := true;
            PostingDateVisible := true;
        end;

        trigger OnOpenPage()
        begin
            PageRefresh();
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Filter := Date.GetFilters();
        Filter2 := SourceCode.GetFilters();

        case Display of
            Display::Journals:
                begin
                    DisplayEntries := true;
                    Title := Text001
                end;
            Display::"Centralized Journals":
                begin
                    DisplayCentral := true;
                    Title := Text002
                end;
            Display::"Journals and Centralization":
                begin
                    DisplayEntries := true;
                    DisplayCentral := true;
                    Title := Text003
                end;
        end;
        SortingByNo := SortingBy;
    end;

    trigger OnInitReport()
    begin
        GBoolCentralisationPiece := true;
    end;

    var
        RecGLEntry: Record 17;
        RecGLEntryTEMP: Record 17 temporary;
        SourceCode2: Record "Source Code";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        FiscalYearFiscalClose: Codeunit "Fiscal Year-FiscalClose";
        DisplayCentral: Boolean;
        DisplayEntries: Boolean;
        DocumentNoVisible: Boolean;
        Finished: Boolean;
        GBoolCentralisationPiece: Boolean;
        Hidden: Boolean;
        PostingDateVisible: Boolean;
        EndDate: Date;
        PreviousStartDate: Date;
        StartDate: Date;
        CreditTotal: Decimal;
        DebitTotal: Decimal;
        DateRecNo: Integer;
        PeriodTypeNo: Integer;
        SortingByNo: Integer;
        Year: Integer;
        Display: Option Journals,"Centralized Journals","Journals and Centralization";
        SortingBy: Option "Posting Date","Document No.";
        "Filter": Text;
        Filter2: Text;
        FiscalYearStatusText: Text;
        TextDate: Text[30];
        Title: Text;
        YearString: Text;
        ConstGText001: Label 'Total by document.';
        CreditCaptionLbl: Label 'Credit';
        DebitCaptionLbl: Label 'Debit';
        DescriptionCaptionLbl: Label 'Description';
        Document_No_CaptionLbl: Label 'Document No.';
        External_Document_No_CaptionLbl: Label 'External Document No.';
        Grand_Total__CaptionLbl: Label 'Grand Total :';
        G_L_Account_No_CaptionLbl: Label 'G/L Account No.';
        Posting_DateCaptionLbl: Label 'Posting Date';
        Text001: Label 'Journals';
        Text002: Label 'Centralized journals';
        Text003: Label 'Journals and Centralization';
        Text004: Label 'You must fill in the %1 field.';
        Text005: Label 'You must specify a Starting Date.';
        Text006: Label 'Printed by %1';
        Text007: Label 'Page %1';
        Text008: Label 'Total %1 %2';
        Text009: Label 'The selected starting date %1 is not the start of a %2.';
        Text010: Label 'The selected ending date %1 is not the end of a %2.';
        Text011: Label 'Fiscal-Year Status: %1';
        Text10800: Label 'The selected date is not a starting period.';
        Text666: Label '%1 is not a valid selection.';

    local procedure PageRefresh()
    begin
        PostingDateVisible := (Display = Display::Journals) or (Display = Display::"Journals and Centralization");
        DocumentNoVisible := (Display = Display::Journals) or (Display = Display::"Journals and Centralization");
    end;
    //Dupliqer de codeunit DateFilter-Calc
    procedure VerifiyDateFilter("Filter": Text[30])
    begin
        if Filter = ',,,' then
            Error(Text10800);
    end;
    //Dupliqer de codeunit DateFilter-Calc
    procedure ReturnEndingPeriod(StartPeriod: Date; PeriodType: Option Date,Week,Month,Quarter,Year): Date
    var
        PeriodDate: Record Date;
    begin
        PeriodDate.SetRange("Period Type", PeriodType);
        PeriodDate.SetRange("Period Start", StartPeriod);
        if PeriodDate.findFirst() then
            exit(PeriodDate."Period End")
        else
            exit(0D);
    end;
    //dupliquer de codeunit "Fiscal Year-FiscalClose"
    procedure CheckFiscalYearStatus(PeriodRange: Text[30]): Text[30]
    var
        AccountingPeriod: Record "Accounting Period";
        Date: Record Date;
    begin
        Date.SetRange("Period Type", Date."Period Type"::Date);
        Date.SetFilter("Period Start", PeriodRange);
        Date.FindLast();
        AccountingPeriod.SetFilter("Starting Date", '<=%1', Date."Period Start");
        AccountingPeriod.SetRange("New Fiscal Year", true);
        AccountingPeriod.FindLast();
        if AccountingPeriod."Fiscally Closed" then
            exit(Text009);

        exit(Text010);
    end;
}

