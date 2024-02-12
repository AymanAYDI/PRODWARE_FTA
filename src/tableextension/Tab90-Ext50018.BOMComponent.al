namespace Prodware.FTA;

using Microsoft.Inventory.BOM;
using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;
tableextension 50018 BOMComponent extends "BOM Component" //90
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
        RecLFromBOM: Record "BOM Component";
        RecLToBOM: Record "BOM Component";
    begin
        RecLToBOM.SetRange("Parent Item No.", CodPToParentItemNo);
        RecLToBOM.DeleteALL();

        RecLFromBOM.SetRange("Parent Item No.", CodPFromParentItemNo);
        if RecLFromBOM.findFirst() then
            repeat
                RecLToBOM.Init();
                RecLToBOM.TransferFields(RecLFromBOM);
                RecLToBOM."Parent Item No." := CodPToParentItemNo;
                RecLToBOM.Insert();
            until RecLFromBOM.Next() = 0;
    end;
}

