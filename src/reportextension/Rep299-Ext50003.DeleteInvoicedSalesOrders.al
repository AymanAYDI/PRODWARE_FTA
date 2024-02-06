namespace Prodware.FTA;

using Microsoft.Sales.Document;
reportextension 50003 "DeleteInvoicedSalesOrders" extends "Delete Invoiced Sales Orders" //299
{
    dataset
    {

    }
    //TODO : Utiliser par menusuite 1010
    //TODO : verifier l'archivage OnafterGetRecord() line 52..59 ARAXIS 
    // si non utiliser l'event OnSalesHeaderOnAfterGetRecordOnBeforeAutoArchiveSalesDocument
}
