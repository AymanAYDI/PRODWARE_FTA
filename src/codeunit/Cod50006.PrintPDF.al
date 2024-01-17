codeunit 50006 "Print PDF"
{

    trigger OnRun()
    begin
    end;

    var

        ProcessStartInfo: DotNet ProcessStartInfo;

        ProcessWindowStyle: DotNet ProcessWindowStyle;

        Process: DotNet Process;


    procedure PrintExternalDocument(TxtPFilePath: Text[250])
    begin
        PrintDocument(TxtPFilePath);
    end;

    local procedure PrintDocument(TxtPFilePath: Text[250])
    begin
        ProcessStartInfo := ProcessStartInfo.ProcessStartInfo(TxtPFilePath);
        ProcessStartInfo.Verb := 'Print';
        ProcessStartInfo.CreateNoWindow := true;
        ProcessStartInfo.WindowStyle := ProcessWindowStyle.Hidden;

        Process.Start(ProcessStartInfo);
    end;

    trigger Process::OutputDataReceived(sender: Variant; e: DotNet DataReceivedEventArgs)
    begin
    end;

    trigger Process::ErrorDataReceived(sender: Variant; e: DotNet DataReceivedEventArgs)
    begin
    end;

    trigger Process::Exited(sender: Variant; e: DotNet EventArgs)
    begin
    end;

    trigger Process::Disposed(sender: Variant; e: DotNet EventArgs)
    begin
    end;
}

