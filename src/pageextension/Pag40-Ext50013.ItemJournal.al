namespace Prodware.FTA;

using Microsoft.Inventory.Journal;
pageextension 50013 ItemJournal extends "Item Journal"//40
{
    layout
    {
        Modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                rec.CalcFields("Shelf No.");
            end;
        }
        addafter("Description")
        {
            field("Shelf No."; rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }
    }

    actions
    {
        addafter("E&xplode BOM")
        {
            action(Montage)
            {
                Caption = 'Montage';
                Image = ExplodeBOM;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Executes the Montage action.';
                trigger OnAction()
                var
                    CduLItemJnlExplode: Codeunit "Item Jnl.-Explode BOM";
                begin
                    Clear(CduLItemJnlExplode);
                    CduLItemJnlExplode.Run(Rec);
                    Clear(CduLItemJnlExplode);
                end;
            }
            action("Démontage")
            {
                Caption = 'Démontage';
                Image = ExplodeBOM;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Executes the Démontage action.';
                trigger OnAction()
                var
                    CduLItemJnlExplode: Codeunit "Item Jnl.-Explode BOM";
                begin
                    Clear(CduLItemJnlExplode);
                    CduLItemJnlExplode.Run(Rec);
                    Clear(CduLItemJnlExplode);
                end;
            }
        }
    }
}

