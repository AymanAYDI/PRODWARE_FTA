enum 50016 status
{
    Extensible = true;

    value(0; "'Referencing in progress")
    {
        Caption = 'Referencing in progress",Referred,"No Referred",Unreferred';
    }
    value(1; Referred)
    {
        Caption = 'Referred';
    }
    value(2; "No Referred")
    {
        Caption = 'No Referred';
    }
    value(3; Unreferred)
    {
        Caption = 'Unreferred';
    }
}
