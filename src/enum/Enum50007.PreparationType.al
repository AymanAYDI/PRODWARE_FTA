enum 50007 "Preparation Type"
{
    Extensible = true;
    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }

    value(1; Stock)
    {
        Caption = 'Stock';
    }
    value(2; "Assembly")
    {
        Caption = 'Assembly';
    }
    value(3; Purchase)
    {
        Caption = 'Purchase';
    }
    value(4; Remainder)
    {
        Caption = 'Remainder';
    }
}
