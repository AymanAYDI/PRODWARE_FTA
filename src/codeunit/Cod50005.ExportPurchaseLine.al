codeunit 50005 "Export Purchase Line"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        FctSendSalesLineDiscount();
    end;

    var
        RecGSalesSetup: Record "Sales & Receivables Setup";
        CduGWriteFile: Codeunit "Write Text File";
        BooGFixedFile: Boolean;
        BooGCommaDecimal: Boolean;

    procedure FctSendSalesLineDiscount()
    var
        RecLPurchLine: Record "Purchase Line";
        TxtLRepertory: Text[250];
        TxtLFileName: Text[250];
        TxtLTextFields: array[80] of Text[350];
        DecLQty: Decimal;
        IntLCmp: Integer;
    begin
        //>> Message structure: EDIFACT GENERIX
        // Get setup
        RecGSalesSetup.GET();

        // Get file setup for this customer
        TxtLRepertory := RecGSalesSetup."Export Sales Price Repertory";
        //TxtLFileName := 'Item_Export';

        TxtLFileName := 'PurchaseLine_Export_' +
          //OLD FORMAT(CURRENTDATETIME,0,'<year4><month,2><Day,2><Hours24,2><Filler Character,0><Minutes,2><Seconds,2>')
          FORMAT(TODAY, 0, '<year4><month,2><Day,2><Filler Character,0>')
          + '_' + FORMAT(TIME, 0, '<Hours,2><Minutes,2><Seconds,2><Filler Character,0>')
          + '.csv';

        // STRSUBSTNO(RecPEDICustSetup."File Name",'F' + RecPSalesInvHeader."No.");

        // Create file
        BooGFixedFile := false;
        BooGCommaDecimal := false;


        CduGWriteFile.FctInitMessage(TxtLRepertory, TxtLFileName, ';', BooGFixedFile, BooGCommaDecimal);



        IntLCmp := 0;

        // Pour les tests
        //DatLDate := DMY2DATE(1,1,2018);
        //RecLPurchLine.SETFILTER(RecLPurchLine."Expected Receipt Date",'%1..',DatLDate);
        RecLPurchLine.SETFILTER(RecLPurchLine."Promised Receipt Date", '>%1', TODAY);
        RecLPurchLine.SETRANGE(RecLPurchLine.Type, RecLPurchLine.Type::Item);
        // ********************************* HEADER ********************************* //
        CLEAR(TxtLTextFields);
        if RecLPurchLine.FINDSET() then
            repeat
                if IntLCmp = 0 then begin
                    // 1 - Code Article
                    TxtLTextFields[1] := CduGWriteFile.FormatText('Code article', 50, false);
                    // 2 - Quantité non reservée
                    TxtLTextFields[2] := CduGWriteFile.FormatText('Quantite non reservee', 50, false);
                    // 3 - Date début
                    TxtLTextFields[3] := CduGWriteFile.FormatText('Date de reception confirmee', 50, false);
                    // 4 - Date fin
                    TxtLTextFields[4] := CduGWriteFile.FormatText('Date de réception prevue', 50, false);


                    CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 4);

                end;
                IntLCmp += 1;


                // 1 - Code Article
                TxtLTextFields[1] := CduGWriteFile.FormatText(RecLPurchLine."No.", 20, false);
                // 2 - Quantité non reservée
                RecLPurchLine.CALCFIELDS(RecLPurchLine."Reserved Quantity");
                DecLQty := RecLPurchLine."Outstanding Quantity" - RecLPurchLine."Reserved Quantity";
                TxtLTextFields[2] := CduGWriteFile.FormatText(FORMAT(DecLQty), 20, false);
                // 3 - Date début
                TxtLTextFields[3] := CduGWriteFile.FormatText(FORMAT(RecLPurchLine."Promised Receipt Date"), 10, false);
                // 4 - Date fin
                TxtLTextFields[4] := CduGWriteFile.FormatText(FORMAT(RecLPurchLine."Expected Receipt Date"), 10, false);


                CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 4);
            until RecLPurchLine.NEXT() = 0;
        //Demande Golda pour MARKRO : ne pas prendre en compte :
        //CduGWriteFile.FctWriteBigSegment(TxtLTextFields,71);


        /*
        // *************** Update Document *************** //
        RecLSalesInvHeader2 := RecPSalesInvHeader;
        RecLSalesInvHeader2."EDI Exported" := TRUE;
        RecLSalesInvHeader2."EDI DateTime Export" := CURRENTDATETIME;
        RecLSalesInvHeader2.MODIFY;
        */

        CduGWriteFile.FctEndMessage();

    end;
}

