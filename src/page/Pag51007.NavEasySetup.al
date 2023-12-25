namespace Prodware.FTA;
page 51007 "NavEasy Setup"
{
    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>EASY1.00
    // NAVEASY:NI 20/06/2008 [Param_NaviEasy]
    //                           -  Create Form
    // 
    // ------------------------------------------------------------------------

    Caption = 'NavEasy Setup';
    PageType = Card;
    SourceTable = "NavEasy Setup";

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("Filing Sales Quotes"; Rec."Filing Sales Quotes")
                {
                    ToolTip = 'Specifies the value of the Filing Sales Quotes field.';
                }
                field("Filing Sales Orders"; Rec."Filing Sales Orders")
                {
                    ToolTip = 'Specifies the value of the Filing Sales Orders field.';
                }
                field("Date jour en factur/livraison"; Rec."Date jour en factur/livraison")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Date jour en factur/livraison field.';
                }
                field("Parm Msg franco de port"; Rec."Parm Msg franco de port")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Parm Msg franco de port field.';
                }
                field("Parm Ctrl price on order"; Rec."Parm Ctrl price on order")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Parm Ctrl price on order field.';
                }
                field("Parm Sample Order"; Rec."Parm Sample Order")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Parm Sample Order field.';
                }
                field("Parm Eco Emballage"; Rec."Parm Eco Emballage")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Parm Eco Emballage field.';
                }
                field("Parm Logistique"; Rec."Parm Logistique")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Parm Logistique field.';
                }
                field("Eclater nomenclature en auto"; Rec."Eclater nomenclature en auto")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Eclater nomenclature en auto field.';
                }
                field("Used Post-it"; Rec."Used Post-it")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Used Post-it field.';
                }
                field("Affichage du N° BL"; Rec."Affichage du N° BL")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Affichage du N° BL field.';
                }
                field("Affichage du N° BR"; Rec."Affichage du N° BR")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Affichage du N° BR field.';
                }
                field("Four: Date jour en Fact/recept"; Rec."Four: Date jour en Fact/recept")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Four: Date jour en Fact/recept field.';
                }
                field("Affichage N° facture Ventes"; Rec."Affichage N° facture Ventes")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Affichage N° facture Ventes field.';
                }
                field("Affichage N° facture Achat"; Rec."Affichage N° facture Achat")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Affichage N° facture Achat field.';
                }
                field("Date jour ds date facture Acha"; Rec."Date jour ds date facture Acha")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Date jour ds date facture Acha field.';
                }
            }
        }
    }

    actions
    {
    }
}

