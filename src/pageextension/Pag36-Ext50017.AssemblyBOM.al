pageextension 50017 "AssemblyBOM" extends "Assembly BOM"//36
{
    actions
    {
        addafter(CalcUnitPrice)
        {
            action("Copy BOM")
            {

                Promoted = TRUE;
                PromotedIsBig = TRUE;
                Image = CopyBOM;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecLItem: Record Item;
                    rec: Record "BOM Component";
                begin

                    rec.TestField(rec."Parent Item No.");
                    RecLItem.SETRANGE(RecLItem."Assembly BOM", TRUE);

                    IF page.RUNMODAL(0, RecLItem) = ACTION::LookupOK THEN
                        rec.CopyBOM(RecLItem."No.", rec."Parent Item No.");
                end;


            }
        }
    }

    trigger OnClosePage()
    var
        RecLItem: Record Item;
    BEGIN
        IF (rec.GETFILTER(rec."Parent Item No.") <> '') THEN BEGIN
            RecLItem.GET(rec."Parent Item No.");
            IF rec.FINDFIRST() THEN BEGIN
                IF RecLItem."Replenishment System" <> RecLItem."Replenishment System"::Assembly THEN BEGIN
                    RecLItem."Replenishment System" := RecLItem."Replenishment System"::Assembly;
                    RecLItem.MODIFY();
                END;
            END
            ELSE
                IF RecLItem."Replenishment System" = RecLItem."Replenishment System"::Assembly THEN BEGIN
                    RecLItem."Replenishment System" := RecLItem."Replenishment System"::Purchase;
                    RecLItem.MODIFY();
                END;
        END;
    END;

}