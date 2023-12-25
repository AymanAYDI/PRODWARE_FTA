namespace Prodware.FTA;

using Microsoft.Inventory.Journal;
pageextension 50013 ItemJournal extends "Item Journal"//40
{
    layout
    {
        modify("Item No.")
        {
            Editable = false;
            trigger OnAfterValidate()
            var
                "Item Journal Line": Record "Item Journal Line";
            begin
                "Item Journal Line".CALCFIELDS("Shelf No.");
            end;
        }



        //todo a verifier 
        addafter("Description")
        {
            field("Shelf No."; rec."Shelf No.")
            {
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

                trigger OnAction()
                var
                    CduLItemJnlExplode: Codeunit "Item Jnl.-Explode BOM";
                begin

                    CLEAR(CduLItemJnlExplode);
                    CduLItemJnlExplode.Run(Rec);
                    CLEAR(CduLItemJnlExplode);

                end;
            }
            action("Démontage")
            {
                Caption = 'Démontage';
                Image = ExplodeBOM;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CduLItemJnlExplode: Codeunit "Item Jnl.-Explode BOM";
                begin

                    CLEAR(CduLItemJnlExplode);
                    CduLItemJnlExplode.Run(Rec);
                    CLEAR(CduLItemJnlExplode);

                end;


            }




        }

    }
}

