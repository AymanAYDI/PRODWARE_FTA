namespace Prodware.FTA;

using Microsoft.Bank.BankAccount;
pageextension 50055 "BankAccountCard" extends "Bank Account Card" //370
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
                    Clear(PagLBankRecStat);
                    PagLBankRecStat.GetBancAccountCode(rec."No.");
                    PagLBankRecStat.Run();
                end;
            }
        }
    }
}
