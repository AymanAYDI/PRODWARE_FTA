report 50058 fdfdfdfd
{
    DefaultLayout = RDLC;
    RDLCLayout = './fdfdfdfd.rdlc';

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        AssemblyHeader.RESET();
        AssemblyHeader.SETRANGE(AssemblyHeader."No.", 'A101869');
        AssemblyHeader.MODIFYALL("Due Date", 20191122D);


        AssemblyHeader.RESET();
        AssemblyHeader.SETRANGE(AssemblyHeader."No.", 'A101886');
        AssemblyHeader.MODIFYALL("Due Date", 20171122D);
    end;
}

