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
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
        }
        addafter(Description)
        {
            field("Quote Associated"; Rec."Quote Associated")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Unit Price"; "Line Discount %")
        Modify("Line Discount %")
        {
            BlankZero = true;
        }
        addafter("Line Discount %")
        {
            field("Unit Price Discounted"; Rec."Unit Price Discounted")
            {
                ApplicationArea = All;
            }
        }
        addafter("Unit Price")
        {
            field("Purchase Price Base"; Rec."Purchase Price Base")
            {
                ApplicationArea = All;
            }
            field("Margin %"; Rec."Margin %")
            {
                ApplicationArea = All;
            }
        }
        addafter("Allow Item Charge Assignment")
        {
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
            }
        }
        Modify(Control53)
        {
            Visible = false;
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
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecLItem: Record Item;
                begin
                    if (Rec.Type = Rec.Type::Item) and RecLItem.Get(Rec."No.") then begin
                        RecLItem."Quote Associated" := false;
                        RecLItem.Modify();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord() //TODO-> Verif
    begin
        // Rec.ShowShortcutDimCode(ShortcutDimCode);
        Rec.CalcFields("Quote Associated");
    end;
}
