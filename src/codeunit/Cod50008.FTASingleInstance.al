codeunit 50008 FTASingleInstance
{
    SingleInstance = true;

    var
        BooGResaFTA: Boolean;
        BooGResaAssFTA: Boolean;

    procedure FctSetBooResaFTA(BooPResaFTA: Boolean);
    begin
        BooGResaFTA := BooPResaFTA;
    end;

    procedure FctSetBooResaAssFTA(BooPResaAssFTA: Boolean);
    begin
        BooGResaAssFTA := BooPResaAssFTA;
    end;

    procedure FctGetBooResaFTA(): Boolean
    begin
        exit(BooGResaFTA);
    end;

    procedure FctGetBooResaAssFTA(): Boolean
    begin
        exit(BooGResaAssFTA);
    end;
}
