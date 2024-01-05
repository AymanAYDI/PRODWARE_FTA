codeunit 50098 TestPrint
{

    trigger OnRun()
    var
        CduL: Codeunit "Print PDF";
    begin
        CduL.PrintExternalDocument('C:\temp\Test.pdf');
    end;
}

