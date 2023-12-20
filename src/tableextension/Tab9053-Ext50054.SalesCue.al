namespace Prodware.FTA;

using Microsoft.Sales.RoleCenters;
tableextension 50054 SalesCue extends "Sales Cue" //9053
{
    fields
    {

        //TODO: CalcFormula cannot be costomized
        // modify("Delayed")
        // {

        //     CalcFormula = Count("Sales Header" WHERE("Document Type"=FILTER(Order),
        //                   Status=FILTER(Released),
        //                   "Completely Shipped"=CONST(false),
        //                   "Requested Delivery Date"=FIELD("Date Filter"),
        //                   "Responsibility Center"=FIELD("Responsibility Center Filter")));
        // }

    }
    //TODO: migration procedure FilterOrders
}

