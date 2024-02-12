codeunit 50007 debloqu
{

    trigger OnRun()
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        AssemblyHeader.Reset();
        AssemblyHeader.SetRange(AssemblyHeader."No.", 'A101869');
        AssemblyHeader.ModifyAll("Due Date", 20191112D);


        AssemblyHeader.Reset();
        AssemblyHeader.SetRange(AssemblyHeader."No.", 'A101886');
        AssemblyHeader.ModifyAll("Due Date", 20171112D);
    end;
}

