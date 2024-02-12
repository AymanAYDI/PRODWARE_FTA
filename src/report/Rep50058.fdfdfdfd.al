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
        AssemblyHeader.Reset();
        AssemblyHeader.SetRange(AssemblyHeader."No.", 'A101869');
        AssemblyHeader.ModifyAll("Due Date", 20191122D);


        AssemblyHeader.Reset();
        AssemblyHeader.SetRange(AssemblyHeader."No.", 'A101886');
        AssemblyHeader.ModifyAll("Due Date", 20171122D);
    end;
}

