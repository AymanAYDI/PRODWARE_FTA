namespace Prodware.FTA;

using Microsoft.Bank.BankAccount;
pageextension 50019 "BankAccountCard" extends "Bank Account Card" //370
{
    actions
    {
        addafter(BankAccountReconciliations)
        {
            action(Test)
            {
                Promoted = true;
                Image = BankAccountRec;
                PromotedCategory = Process;
                Caption = 'Bank Recon. Statement';
                ApplicationArea = All;
                trigger OnAction()
                var
                    PagLBankRecStat: Page "Bank Recon. Statement";
                begin
                    CLEAR(PagLBankRecStat);
                    PagLBankRecStat.GetBancAccountCode(rec."No.");
                    PagLBankRecStat.RUN();
                end;
            }
        }
    }
}
