tableextension 50017 BOMComponent extends "BOM Component" //90
{
    fields
    {
        modify("No.")
        {
            TableRelation = if (Type = const(Item)) Item where(Type = const(Inventory),
                                                              "Quote Associated" = filter(false))
            else
            if (Type = const(Resource)) Resource;
        }
    }
    procedure CopyBOM(CodPFromParentItemNo: Code[20]; CodPToParentItemNo: Code[20])
    var
        RecLFromBOM: Record 90;
        RecLToBOM: Record 90;
    begin
        RecLToBOM.SETRANGE("Parent Item No.", CodPToParentItemNo);
        RecLToBOM.DELETEALL();

        RecLFromBOM.SETRANGE("Parent Item No.", CodPFromParentItemNo);
        if RecLFromBOM.FINDFIRST() then
            repeat
                RecLToBOM.INIT();
                RecLToBOM.TRANSFERFIELDS(RecLFromBOM);
                RecLToBOM."Parent Item No." := CodPToParentItemNo;
                RecLToBOM.INSERT();
            until RecLFromBOM.NEXT() = 0;
    end;
}

