codeunit 50004 "Export Sales Price"
{
    // TableNo = "Job Queue Entry";

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
        RecLSalesPrice: Record "Sales Price";
        TxtLRepertory: Text[250];
        TxtLFileName: Text[250];
        TxtLTextFields: array[80] of Text;
        IntLCmp: Integer;
    begin
        //>> Message structure: EDIFACT GENERIX
        // Get setup
        RecGSalesSetup.GET();

        // Get file setup for this customer
        TxtLRepertory := RecGSalesSetup."Export Sales Price Repertory";
        //TxtLFileName := 'Item_Export';

        TxtLFileName := 'SalesPrice_Export_' +
          //OLD FORMAT(CURRENTDATETIME,0,'<year4><month,2><Day,2><Hours24,2><Filler Character,0><Minutes,2><Seconds,2>')
          FORMAT(TODAY, 0, '<year4><month,2><Day,2><Filler Character,0>')
          + '_' + FORMAT(TIME, 0, '<Hours,2><Minutes,2><Seconds,2><Filler Character,0>')
          + '.csv';

        // STRSUBSTNO(RecPEDICustSetup."File Name",'F' + RecPSalesInvHeader."No.");

        // Create file
        BooGFixedFile := false;
        BooGCommaDecimal := false;


        CduGWriteFile.FctInitMessage(';', BooGFixedFile, BooGCommaDecimal);



        IntLCmp := 0;

        // Pour les tests
        RecLSalesPrice.SETRANGE(RecLSalesPrice."Sales Type", RecLSalesPrice."Sales Type"::Customer);

        // ********************************* HEADER ********************************* //
        CLEAR(TxtLTextFields);
        if RecLSalesPrice.FINDSET() then
            repeat

                if IntLCmp = 0 then begin
                    // 1 - Customer No.
                    TxtLTextFields[1] := CduGWriteFile.FormatText('Code client', 50, false);
                    // 2 - Code Article
                    TxtLTextFields[2] := CduGWriteFile.FormatText('Code article', 50, false);
                    // 3 - Date début
                    TxtLTextFields[3] := CduGWriteFile.FormatText('Date début', 50, false);
                    // 4 - Date fin
                    TxtLTextFields[4] := CduGWriteFile.FormatText('Date fin', 50, false);
                    // 5 - Prix Unitaire
                    TxtLTextFields[5] := CduGWriteFile.FormatText('Prix unitaire', 50, false);


                    CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 5);

                end;
                IntLCmp += 1;


                // 1 - Customer No.
                TxtLTextFields[1] := CduGWriteFile.FormatText(RecLSalesPrice."Sales Code", 20, false);
                // 2 - Code Article
                TxtLTextFields[2] := CduGWriteFile.FormatText(RecLSalesPrice."Item No.", 20, false);
                // 3 - Date début
                TxtLTextFields[3] := CduGWriteFile.FormatText(FORMAT(RecLSalesPrice."Starting Date"), 10, false);
                // 4 - Date fin
                TxtLTextFields[4] := CduGWriteFile.FormatText(FORMAT(RecLSalesPrice."Ending Date"), 10, false);
                // 5 - Prix Unitaire
                TxtLTextFields[5] := CduGWriteFile.FormatText(FORMAT(RecLSalesPrice."Unit Price"), 10, false);


                CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 5);
            until RecLSalesPrice.NEXT() = 0;
        //Demande Golda pour MARKRO : ne pas prendre en compte :
        //CduGWriteFile.FctWriteBigSegment(TxtLTextFields,71);


        /*
        // *************** Update Document *************** //
        RecLSalesInvHeader2 := RecPSalesInvHeader;
        RecLSalesInvHeader2."EDI Exported" := TRUE;
        RecLSalesInvHeader2."EDI DateTime Export" := CURRENTDATETIME;
        RecLSalesInvHeader2.MODIFY;
        */

        CduGWriteFile.FctEndMessage(TxtLFileName);

    end;
}

