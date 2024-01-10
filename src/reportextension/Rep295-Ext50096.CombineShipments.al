namespace Prodware.FTA;

using Microsoft.Sales.Document;
reportextension 50096 "CombineShipments" extends "Combine Shipments"//295
{
    dataset
    {
        modify("Sales Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            begin


                IF SalesOrderHeader."Combine Shipments" = FALSE THEN
                    BoolGCreateNewInvoice := TRUE
                ELSE
                    IF NOT RecGSalesHeader."Combine Shipments" THEN
                        BoolGCreateNewInvoice := TRUE
                    ELSE
                        IF (RecGSalesHeader."Bill-to Customer No." <> SalesOrderHeader."Bill-to Customer No.") OR
                           (RecGSalesHeader."Currency Code" <> SalesOrderHeader."Currency Code") OR
                           ((RecGSalesHeader."Bill-to Customer No." = SalesOrderHeader."Bill-to Customer No.") AND (BoolGSkip)) THEN
                            BoolGCreateNewInvoice := TRUE;



            end;
        }
        modify("Sales Shipment Line")
        {
            trigger OnAfterAfterGetRecord()
            begin

                IF ("Qty. Shipped Not Invoiced" <> 0) OR (Type = 0) THEN BEGIN


                    BoolGSkip := FALSE;


                    IF (Type <> 0) AND ("Bill-to Customer No." <> '') THEN
                        IF (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") OR
                                         (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") OR
                                         (SalesOrderHeader."EU 3-Party Trade" <> SalesHeader."EU 3-Party Trade") OR
                                         (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID")


                                         OR BoolGCreateNewInvoice
                               then begin
                            IF BoolGCreateNewInvoice THEN
                                SalesHeader.INIT();

                        END ELSE
                            BoolGSkip := TRUE;

                    BoolGCreateNewInvoice := FALSE;


                end;
            end;

            trigger OnAfterPostDataItem()
            begin
                RecGSalesHeader := SalesOrderHeader;

            end;

        }

    }


    PROCEDURE Fct_FinalizeAdress();
    BEGIN

        WITH SalesHeader DO BEGIN
            "Bill-to Name" := "Sales Shipment Header"."Bill-to Name";
            "Bill-to Name 2" := "Sales Shipment Header"."Bill-to Name 2";
            "Bill-to Address" := "Sales Shipment Header"."Bill-to Address";
            "Bill-to Address 2" := "Sales Shipment Header"."Bill-to Address 2";
            "Bill-to City" := "Sales Shipment Header"."Bill-to City";
            "Bill-to Post Code" := "Sales Shipment Header"."Bill-to Post Code";
            "Bill-to Contact" := "Sales Shipment Header"."Bill-to Contact";

            "Ship-to Name" := "Sales Shipment Header"."Ship-to Name";
            "Ship-to Name 2" := "Sales Shipment Header"."Ship-to Name 2";
            "Ship-to Address" := "Sales Shipment Header"."Ship-to Address";
            "Ship-to Address 2" := "Sales Shipment Header"."Ship-to Address 2";
            "Ship-to City" := "Sales Shipment Header"."Ship-to City";
            "Ship-to Post Code" := "Sales Shipment Header"."Ship-to Post Code";
            "Ship-to Contact" := "Sales Shipment Header"."Ship-to Contact";

            "Sell-to Customer Name" := "Sales Shipment Header"."Sell-to Customer Name";
            "Sell-to Customer Name 2" := "Sales Shipment Header"."Sell-to Customer Name 2";
            "Sell-to Address" := "Sales Shipment Header"."Sell-to Address";
            "Sell-to Address 2" := "Sales Shipment Header"."Sell-to Address 2";
            "Sell-to City" := "Sales Shipment Header"."Sell-to City";
            "Sell-to Contact" := "Sales Shipment Header"."Sell-to Contact";
            "Sell-to Post Code" := "Sales Shipment Header"."Sell-to Post Code";
        END;
    END;

    var
        RecGSalesHeader: Record "Sales Header";
        BoolGCreateNewInvoice: Boolean;
        BoolGCombineShipments: Boolean;
        BoolGSkip: Boolean;


}
