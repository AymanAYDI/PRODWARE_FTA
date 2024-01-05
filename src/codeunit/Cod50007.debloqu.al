codeunit 50007 debloqu
{

    trigger OnRun()
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        AssemblyHeader.RESET();
        AssemblyHeader.SETRANGE(AssemblyHeader."No.", 'A101869');
        AssemblyHeader.MODIFYALL("Due Date", 20191112D);


        AssemblyHeader.RESET();
        AssemblyHeader.SETRANGE(AssemblyHeader."No.", 'A101886');
        AssemblyHeader.MODIFYALL("Due Date", 20171112D);
    end;
}

