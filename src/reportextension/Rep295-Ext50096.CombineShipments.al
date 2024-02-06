namespace Prodware.FTA;

using Microsoft.Sales.Document;
reportextension 50096 "CombineShipments" extends "Combine Shipments"//295
{
    dataset
    {
        modify(SalesOrderHeader)
        {
            // todo DataItemTableView cannot be customized
            // DataItemTableView = SORTING("Document Type", "Bill-to Customer No.", "Combine Shipments", "Currency Code")
            //                      WHERE("Document Type"=CONST(Order));
        }
        modify("Sales Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                if SalesOrderHeader."Combine Shipments" = false then
                    BoolGCreateNewInvoice := true
                else
                    if not RecGSalesHeader."Combine Shipments" then
                        BoolGCreateNewInvoice := true
                    else
                        if (RecGSalesHeader."Bill-to Customer No." <> SalesOrderHeader."Bill-to Customer No.") or
                           (RecGSalesHeader."Currency Code" <> SalesOrderHeader."Currency Code") or
                           ((RecGSalesHeader."Bill-to Customer No." = SalesOrderHeader."Bill-to Customer No.") and (BoolGSkip)) then
                            BoolGCreateNewInvoice := true;



            end;
        }
        modify("Sales Shipment Line")
        {
            trigger OnAfterAfterGetRecord()
            begin

                if ("Qty. Shipped Not Invoiced" <> 0) or (Type = 0) then begin


                    BoolGSkip := false;


                    if (Type <> 0) and ("Bill-to Customer No." <> '') then
                        if (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
                                         (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
                                         (SalesOrderHeader."EU 3-Party Trade" <> SalesHeader."EU 3-Party Trade") or
                                         (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID")


                                         or BoolGCreateNewInvoice
                               then begin
                            if BoolGCreateNewInvoice then
                                SalesHeader.INIT();

                        end else
                            BoolGSkip := true;

                    BoolGCreateNewInvoice := false;


                end;
            end;

            trigger OnAfterPostDataItem()
            begin
                RecGSalesHeader := SalesOrderHeader;

            end;

        }

    }


    procedure Fct_FinalizeAdress();
    begin

        with SalesHeader do begin
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
        end;
    end;

    var
        RecGSalesHeader: Record "Sales Header";
        BoolGCombineShipments: Boolean;
        BoolGCreateNewInvoice: Boolean;
        BoolGSkip: Boolean;


}
