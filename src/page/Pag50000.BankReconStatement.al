namespace Prodware.FTA;

using Microsoft.Bank.Ledger;
using Microsoft.Finance.Dimension;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Navigate;

page 50000 "Bank Recon. Statement"
{
    Caption = 'Bank Recon. Statement';
    DataCaptionFields = "Bank Account No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Bank Account Ledger Entry";
    SourceTableView = sorting("Bank Account No.", Open) where(Open = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(Txt001; Txt001)
                {
                    Editable = false;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Net Change"; RecGBankAccount."Net Change")
                {
                    Caption = 'Acc. balance';
                    Editable = false;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(TxtGDateFilter; TxtGDateFilter)
                {
                    Caption = 'Date Filter';
                    ToolTip = 'Specifies the value of the Date Filter field.';
                    trigger OnValidate()
                    begin
                        if TxtGDateFilter <> '' then
                            Rec.SETFILTER("Posting Date", TxtGDateFilter)
                        else
                            Rec.SETRANGE("Posting Date");
                        if CodGBankCode = '' then
                            CodGBankCode := '512100';

                        RecGBankAccount.GET(CodGBankCode);
                        if Rec.GETFILTER("Posting Date") <> '' then
                            RecGBankAccount.SETFILTER("Date Filter", Rec.GETFILTER("Posting Date"));
                        RecGBankAccount.CALCFIELDS("Net Change");
                        TxtGBankStat := STRSUBSTNO(Txt004, RecGBankAccount."Last Statement No.");
                        RecGBankLedg.COPYFILTERS(Rec);
                        RecGBankLedg.CALCSUMS(Amount);

                        CurrPage.UPDATE(true);
                    end;
                }
            }
            repeater("Entries not reconciliated")
            {
                Caption = 'Entries not reconciliated';
                Editable = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    ToolTip = 'Specifies the document type on the bank account entry. The document type will be Payment, Refund, or the field will be blank.';
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the document number on the bank account entry.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the number of the bank account used for the entry.';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ToolTip = 'Specifies the description of the bank account entry.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the amount of the entry denominated in the applicable foreign currency.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the amount of the entry in LCY.';
                }
                field(Open; Rec.Open)
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies whether the amount on the bank account entry has been fully applied to, or if there is a remaining amount that must be applied to.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
            }
            group(Group2)
            {
                Editable = false;
                field(Txt002; Txt002)
                {
                    Caption = 'Total not reconciliated';
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(Txt003; Txt003)
                {
                    Caption = 'Bank balance';
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field(TxtGBankStat; TxtGBankStat)
                {
                    Caption = 'Balance for last statement No.';
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("1"; RecGBankLedg.Amount)
                {
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("2"; RecGBankAccount."Net Change" - RecGBankLedg.Amount)
                {
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("3"; RecGBankAccount."Balance Last Statement")
                {
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action.';
                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.RUN();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if CodGBankCode = '' then
            CodGBankCode := '512100';

        RecGBankAccount.GET(CodGBankCode);
        if Rec.GETFILTER("Posting Date") <> '' then
            RecGBankAccount.SETFILTER("Date Filter", Rec.GETFILTER("Posting Date"));
        RecGBankAccount.CALCFIELDS("Net Change");
        TxtGBankStat := STRSUBSTNO(Txt004, RecGBankAccount."Last Statement No.");
        RecGBankLedg.COPYFILTERS(Rec);
        RecGBankLedg.CALCSUMS(Amount);
    end;

    var

        RecGBankAccount: Record "Bank Account";
        RecGBankLedg: Record "Bank Account Ledger Entry";
        Navigate: Page "Navigate";
        CodGBankCode: Code[20];
        Txt001: Label 'Acc. balance';
        Txt002: Label 'Total not reconciliated';
        Txt003: Label 'Bank balance';
        Txt004: Label 'Balance for last statement No. %1', Comment = '%1="Last Statement No."';
        TxtGBankStat: Text;
        TxtGDateFilter: Text;

    procedure GetBancAccountCode(CodPBankAccountCode: Code[20])
    begin
        CodGBankCode := CodPBankAccountCode
    end;
}

