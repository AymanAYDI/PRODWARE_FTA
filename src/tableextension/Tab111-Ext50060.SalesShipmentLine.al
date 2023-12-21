tableextension 50060 SalesShipmentLine extends "Sales Shipment Line" //111
{
    fields
    {
        field(50041; Prepare; Boolean)
        {
            Caption = 'Préparé';
            Description = 'FTA1.00';
        }
        field(50044; "Parcel No."; Integer)
        {
            Caption = 'Parcel No.';
            Description = 'FTA1.00';
        }
        field(51000; "Qty. Ordered"; Decimal)
        {
            Caption = 'Qty. Ordered';
            Description = 'NAVEASY.001 [Gestion_Reliquat] Ajout du champ';
        }
        field(51001; "Qty Shipped on Order"; Decimal)
        {
            Caption = 'Qty Shipped on Order';
            Description = 'NAVEASY.001 [Gestion_Reliquat] Ajout du champ';
        }
    }
    keys
    {
        key(Key50; "Shortcut Dimension 1 Code", "Document No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "InsertInvLineFromShptLine(PROCEDURE 2)".

    //procedure InsertInvLineFromShptLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SETRANGE("Document No.","Document No.");

    TempSalesLine := SalesLine;
    IF SalesLine.FIND('+') THEN
      NextLineNo := SalesLine."Line No." + 10000
    ELSE
      NextLineNo := 10000;

    IF SalesInvHeader."No." <> TempSalesLine."Document No." THEN
      SalesInvHeader.GET(TempSalesLine."Document Type",TempSalesLine."Document No.");

    IF SalesLine."Shipment No." <> "Document No." THEN BEGIN
      SalesLine.INIT;
      SalesLine."Line No." := NextLineNo;
      SalesLine."Document Type" := TempSalesLine."Document Type";
      SalesLine."Document No." := TempSalesLine."Document No.";
      SalesLine.Description := STRSUBSTNO(Text000,"Document No.");
      SalesLine.INSERT;
      NextLineNo := NextLineNo + 10000;
    END;

    TransferOldExtLines.ClearLineNumbers;

    REPEAT
      ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

      IF SalesOrderLine.GET(
           SalesOrderLine."Document Type"::Order,"Order No.","Order Line No.")
      THEN BEGIN
        IF (SalesOrderHeader."Document Type" <> SalesOrderLine."Document Type"::Order) OR
           (SalesOrderHeader."No." <> SalesOrderLine."Document No.")
        THEN
          SalesOrderHeader.GET(SalesOrderLine."Document Type"::Order,"Order No.");

        InitCurrency("Currency Code");

        IF SalesInvHeader."Prices Including VAT" THEN BEGIN
          IF NOT SalesOrderHeader."Prices Including VAT" THEN
            SalesOrderLine."Unit Price" :=
              ROUND(
                SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
                Currency."Unit-Amount Rounding Precision");
        END ELSE BEGIN
          IF SalesOrderHeader."Prices Including VAT" THEN
            SalesOrderLine."Unit Price" :=
              ROUND(
                SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
                Currency."Unit-Amount Rounding Precision");
        END;
      END ELSE BEGIN
        SalesOrderHeader.INIT;
        IF ExtTextLine OR (Type = Type::" ") THEN BEGIN
          SalesOrderLine.INIT;
          SalesOrderLine."Line No." := "Order Line No.";
          SalesOrderLine.Description := Description;
          SalesOrderLine."Description 2" := "Description 2";
        END ELSE
          ERROR(Text001);
      END;

      SalesLine := SalesOrderLine;
      SalesLine."Line No." := NextLineNo;
      SalesLine."Document Type" := TempSalesLine."Document Type";
      SalesLine."Document No." := TempSalesLine."Document No.";
      SalesLine."Variant Code" := "Variant Code";
      SalesLine."Location Code" := "Location Code";
      SalesLine."Quantity (Base)" := 0;
      SalesLine.Quantity := 0;
      SalesLine."Outstanding Qty. (Base)" := 0;
      SalesLine."Outstanding Quantity" := 0;
      SalesLine."Quantity Shipped" := 0;
      SalesLine."Qty. Shipped (Base)" := 0;
      SalesLine."Quantity Invoiced" := 0;
      SalesLine."Qty. Invoiced (Base)" := 0;
      SalesLine.Amount := 0;
      SalesLine."Amount Including VAT" := 0;
      SalesLine."Purchase Order No." := '';
      SalesLine."Purch. Order Line No." := 0;
      SalesLine."Drop Shipment" := "Drop Shipment";
      SalesLine."Special Order Purchase No." := '';
      SalesLine."Special Order Purch. Line No." := 0;
      SalesLine."Special Order" := FALSE;
      SalesLine."Shipment No." := "Document No.";
      SalesLine."Shipment Line No." := "Line No.";
      SalesLine."Appl.-to Item Entry" := 0;
      SalesLine."Appl.-from Item Entry" := 0;
      IF NOT ExtTextLine AND (SalesLine.Type <> 0) THEN BEGIN
        SalesLine.VALIDATE(Quantity,Quantity - "Quantity Invoiced");
        SalesLine.VALIDATE("Unit Price",SalesOrderLine."Unit Price");
        SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
        SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
        SalesOrderLine."Line Discount Amount" :=
          ROUND(
            SalesOrderLine."Line Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
            Currency."Amount Rounding Precision");
        IF SalesInvHeader."Prices Including VAT" THEN BEGIN
          IF NOT SalesOrderHeader."Prices Including VAT" THEN
            SalesOrderLine."Line Discount Amount" :=
              ROUND(
                SalesOrderLine."Line Discount Amount" *
                (1 + SalesOrderLine."VAT %" / 100),Currency."Amount Rounding Precision");
        END ELSE BEGIN
          IF SalesOrderHeader."Prices Including VAT" THEN
            SalesOrderLine."Line Discount Amount" :=
              ROUND(
                SalesOrderLine."Line Discount Amount" /
                (1 + SalesOrderLine."VAT %" / 100),Currency."Amount Rounding Precision");
        END;
        SalesLine.VALIDATE("Line Discount Amount",SalesOrderLine."Line Discount Amount");
        SalesLine."Line Discount %" := SalesOrderLine."Line Discount %";
        SalesLine.UpdatePrePaymentAmounts;
      END;

      SalesLine."Attached to Line No." :=
        TransferOldExtLines.TransferExtendedText(
          SalesOrderLine."Line No.",
          NextLineNo,
          SalesOrderLine."Attached to Line No.");
      SalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
      SalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
      SalesLine."Dimension Set ID" := "Dimension Set ID";
      SalesLine.INSERT;
      CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",SalesLine);

      ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine,SalesLine);

      NextLineNo := NextLineNo + 10000;
      IF "Attached to Line No." = 0 THEN
        SETRANGE("Attached to Line No.","Line No.");
    UNTIL (NEXT = 0) OR ("Attached to Line No." = 0);

    IF SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,"Order No.") THEN BEGIN
      SalesOrderHeader."Get Shipment Used" := TRUE;
      SalesOrderHeader.MODIFY;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17

      //>>FED_20091015:PA
      SalesLine.Description := COPYSTR(CstG0003,1,50);

      SalesLine.INSERT;
      NextLineNo := NextLineNo + 10000;
    #62..64

        RecGSalesShipHeader.GET("Document No.");
        IF STRLEN(STRSUBSTNO(CstG0001,"Document No.",RecGSalesShipHeader."External Document No.",RecGSalesShipHeader."Order No."))
               <=50 THEN
          SalesLine.Description := COPYSTR(STRSUBSTNO(CstG0001,"Document No.",RecGSalesShipHeader."External Document No.",
          RecGSalesShipHeader."Order No."),1,50)
        ELSE
          SalesLine.Description := COPYSTR(STRSUBSTNO(CstG0002,"Document No.",RecGSalesShipHeader."External Document No."),1,50);
      //<<FED_20091015:PA

    #18..87

        //>>FED_20090415:PA
        SalesLine.FctParmFromCompileBL;
        //<<FED_20090415:PA

    #88..135
    */
    //end;
    //TODO SLESline 

    var

        CstG0001: Label 'No %1|Your Ref: %2|Order FTA %3';
        "---FTA1.00---": Integer;
        RecGSalesShipHeader: Record "110";
        CstG0002: Label 'No %1|Your Ref: %2';
        TxtGText: Text[250];
        CstG0003: Label '======================================================================================================';
}

