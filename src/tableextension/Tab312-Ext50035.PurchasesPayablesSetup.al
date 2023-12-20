namespace Prodware.FTA;

using Microsoft.Purchases.Setup;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Intrastat;
tableextension 50035 PurchasesPayablesSetup extends "Purchases & Payables Setup" //312
{
    fields
    {
        field(51000; "Charge (Item) used for Transp."; Code[20])
        {
            Caption = 'Charge (Item) used for Transp.';
            TableRelation = "Item Charge";
        }
        field(51100; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type Code';
            TableRelation = "Transaction Type";
        }
        field(51101; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification Code';
            TableRelation = "Transaction Specification";
        }
        field(51102; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method Code';
            Description = 'NAVEASY.001 [Parametres_DEB] Ajout du champ';
            TableRelation = "Transport Method";
        }
        field(51103; "Entry  Point"; Code[10])
        {
            Caption = 'Entry/Exit Point Code';
            TableRelation = "Entry/Exit Point";
        }
        field(51104; "Area"; Code[10])
        {
            Caption = 'Area Code';
            TableRelation = Area;
        }
    }
}

