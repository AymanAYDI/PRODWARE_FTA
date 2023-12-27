namespace Prodware.FTA;

using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
pageextension 50028 SalesQuoteSubform extends "Sales Quote Subform" //95
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>FTA1.00
    // FED_20090415:PA 15/04/2009 Kit Build up or remove into pieces
    // 
    // //>>NDBI
    // LALE.PA 21/01/2021 cf TDD_FTA_Article_et_Nomenclature_provisoire_sur_devis_V1(P26959_005)
    //         Add Field "Quote Associated"
    //         Add C/AL Code in triggers OnAfterGetRecord()
    //                                   NoOnAfterValidate
    //         Add Action ItemToVisible
    // 
    // ------------------------------------------------------------------------


    layout
    {
        addbefore(Type)
        {
            field("Item Base"; Rec."Item Base")
            {
                trigger OnValidate()
                begin
                    //>>FED_20090415:PA
                    CurrPage.UPDATE(true);
                end;
            }
        }
        addafter(Description)
        {
            field("Quote Associated"; Rec."Quote Associated")
            {
            }
        }
        moveafter("Unit Price"; "Line Discount %")
        modify("Line Discount %")
        {
            BlankZero = true;
        }
        addafter("Line Discount %")
        {
            field("Unit Price Discounted"; Rec."Unit Price Discounted")
            {
            }
        }
        addafter("Unit Price")
        {
            field("Purchase Price Base"; Rec."Purchase Price Base")
            {
            }
            field("Margin %"; Rec."Margin %")
            {
            }
        }
        addafter("Allow Item Charge Assignment")
        {
            field("Shipment Date"; Rec."Shipment Date")
            {
            }
        }
        modify(Control53)
        {
            Visible = FALSE;
        }
    }
    actions
    {
        addafter("InsertExtTexts")
        {
            action(ItemToVisible)
            {
                Caption = 'Rendre visible article provisoire';
                Image = Item;

                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    if (Rec.Type = Rec.Type::Item) and RecLItem.GET(Rec."No.") then begin
                        RecLItem."Quote Associated" := false;
                        RecLItem.MODIFY();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord() //TODO-> Verif
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        //>>NDBI
        Rec.CALCFIELDS("Quote Associated");
        //<<NDBI
    end;
}
