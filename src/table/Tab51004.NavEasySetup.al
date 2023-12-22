table 51004 "NavEasy Setup"
{

    Caption = 'NavEasy Setup';

    fields
    {
        field(1; "Key"; Code[10])
        {
            Caption = 'Key';
        }
        field(2; "Parm Msg franco de port"; Boolean)
        {
            Caption = 'Print Msg about sending';
        }
        field(3; "Parm Ctrl price on order"; Boolean)
        {
            Caption = 'Ctrl order price';
        }
        field(4; "Parm Sample Order"; Boolean)
        {
            Caption = 'Sample Order';
        }
        field(5; "Parm Eco Emballage"; Boolean)
        {
            Caption = 'Eco-Emballage';
        }
        field(6; "Parm Logistique"; Boolean)
        {
            Caption = 'Logistique';
        }
        field(7; "Filing Sales Quotes"; Boolean)
        {
            Caption = 'Filing Sales Quotes';
            Description = 'NAVEASY.001 [Archivage_Devis]';
        }
        field(8; "Filing Sales Orders"; Boolean)
        {
            Caption = 'Filing Sales Orders';
            Description = 'NAVEASY.001 [Archivage_Cde]';
        }
        field(9; "Eclater nomenclature en auto"; Boolean)
        {
            Caption = 'Explode BOM automaticaly';
        }
        field(10; "Date jour en factur/livraison"; Boolean)
        {
            Caption = 'Day date for invoices and deliveries';
        }
        field(11; "Used Post-it"; Code[10])
        {
            Caption = 'Used Post-it';
            Description = 'NAVEASY.001 [Post_It]';
        }
        field(12; "Affichage du N° BL"; Boolean)
        {
            Caption = 'Display BL No.';
        }
        field(13; "Affichage du N° BR"; Boolean)
        {
            Caption = 'Display BR No.';
        }
        field(14; "Four: Date jour en Fact/recept"; Boolean)
        {
            Caption = 'Vendor: Date Day for Invoice/receipt.';
        }
        field(15; "Affichage N° facture Ventes"; Boolean)
        {
            Caption = 'Display Sales Invoice No.';
        }
        field(16; "Affichage N° facture Achat"; Boolean)
        {
            Caption = 'Display Purchase Invoice No.';
        }
        field(17; "Date jour ds date facture Acha"; Boolean)
        {
            Caption = 'Date Day Invoice/Purchase';
        }
    }

    keys
    {
        key(Key1; "Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

