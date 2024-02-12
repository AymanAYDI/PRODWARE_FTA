
namespace Prodware.FTA;

using Microsoft.Inventory.Transfer;
using Microsoft.Inventory.Item;
tableextension 50056 TransferLine extends "Transfer Line" //5741
{
    fields
    {
        Modify("Item No.")
        {
            TableRelation = Item where(Type = const(Inventory), "Quote Associated" = filter(false));
        }
    }
}

