namespace Prodware.FTA;

using Microsoft.Inventory.BOM;
using Microsoft.Inventory.Item;
pageextension 50078 "AssemblyBOM" extends "Assembly BOM"//36
{
    actions
    {
        addafter(CalcUnitPrice)
        {
            action("Copy BOM")
            {

                Promoted = true;
                PromotedIsBig = true;
                Image = CopyBOM;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Executes the Copy BOM action.';
                trigger OnAction()
                var
                    RecLItem: Record Item;
                    rec: Record "BOM Component";
                begin

                    rec.TestField(rec."Parent Item No.");
                    RecLItem.SetRange(RecLItem."Assembly BOM", true);

                    if page.RunModal(0, RecLItem) = ACTION::LookupOK then
                        rec.CopyBOM(RecLItem."No.", rec."Parent Item No.");
                end;
            }
        }
    }
    trigger OnClosePage()
    var
        RecLItem: Record Item;
    begin
        if (rec.GetFilter(rec."Parent Item No.") <> '') then begin
            RecLItem.Get(rec."Parent Item No.");
            if rec.findFirst() then begin
                if RecLItem."Replenishment System" <> RecLItem."Replenishment System"::Assembly then begin
                    RecLItem."Replenishment System" := RecLItem."Replenishment System"::Assembly;
                    RecLItem.Modify();
                end;
            end
            else
                if RecLItem."Replenishment System" = RecLItem."Replenishment System"::Assembly then begin
                    RecLItem."Replenishment System" := RecLItem."Replenishment System"::Purchase;
                    RecLItem.Modify();
                end;
        end;
    end;

}