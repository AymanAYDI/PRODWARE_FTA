codeunit 51001 "Clear FA Ledger"
{

    Permissions = TableData "FA Ledger Entry" = d,
                  TableData "FA Depreciation Book" = d,
                  TableData "FA Register" = d;

    trigger OnRun()
    begin
        if not CONFIRM(CstG000)
           then
            ERROR(CstG001);

        FADepreciationBook.DELETEALL();

        FALedgerEntry.DELETEALL();

        FixedAsset.DELETEALL(true);
        FARegister.DELETEALL();
        RecupImmo.DELETEALL();

        MESSAGE(CstG002);

    end;

    var
        FALedgerEntry: Record "FA Ledger Entry";
        FixedAsset: Record "Fixed Asset";
        FADepreciationBook: Record "FA Depreciation Book";
        FARegister: Record "FA Register";
        RecupImmo: Record "FA Import Buffer";
        CstG000: Label 'This processing will delete the posted FA ledger entries. Are you sure you want to continue?';
        CstG001: Label 'Processing stopped.';
        CstG002: Label 'You can now start the recovery process';
}

