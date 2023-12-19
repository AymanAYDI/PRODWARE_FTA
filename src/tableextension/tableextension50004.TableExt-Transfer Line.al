
namespace Prodware.FTA;

using Microsoft.Inventory.Transfer;
using Microsoft.Inventory.Item;
tableextension 50049 tableextension50004 extends "Transfer Line" //5741
{
    fields
    {
        modify("Item No.")
        {
            TableRelation = Item WHERE(Type = CONST(Inventory), "Quote Associated" = FILTER(false));
        }
    }
}

