codeunit 50003 "Export Sales Line Discount"
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
        RecLDiscountLines: Record "Sales Line Discount";
        TxtLRepertory: Text[250];
        TxtLFileName: Text[250];
        TxtLTextFields: array[80] of Text;

        IntLCmp: Integer;
    begin
        //>> Message structure: EDIFACT GENERIX
        // Get setup
        RecGSalesSetup.GET();

        // Get file setup for this customer
        TxtLRepertory := RecGSalesSetup."Export Customer Repertory";
        //TxtLFileName := 'Item_Export';

        TxtLFileName := 'SalesLineDiscount_Export_' +
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
        //RecLDiscountLines.SETRANGE(RecLDiscountLines."No.",'000001');

        // ********************************* HEADER ********************************* //
        CLEAR(TxtLTextFields);
        if RecLDiscountLines.FINDSET() then
            repeat
                if IntLCmp = 0 then begin
                    // 1 - Customer No.
                    TxtLTextFields[1] := CopyStr(CduGWriteFile.FormatText('Code vente', 50, false), 1, 350);
                    // 2 - Cust Name
                    TxtLTextFields[2] := CopyStr(CduGWriteFile.FormatText('Code remise', 50, false), 1, 350);
                    // 3 - Cust Adress 1
                    TxtLTextFields[3] := CopyStr(CduGWriteFile.FormatText('Pourcentage de remise', 50, false), 1, 350);

                    CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 3);

                end;
                IntLCmp += 1;


                // 1 - Customer No.
                TxtLTextFields[1] := CopyStr(CduGWriteFile.FormatText(RecLDiscountLines."Sales Code", 20, false), 1, 350);
                // 2 - Cust Name
                TxtLTextFields[2] := CopyStr(CduGWriteFile.FormatText(RecLDiscountLines.Code, 20, false), 1, 350);
                // 3 - Cust Adress 1
                TxtLTextFields[3] := CopyStr(CduGWriteFile.FormatText(FORMAT(RecLDiscountLines."Line Discount %"), 10, false), 1, 350);

                CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 3);
            until RecLDiscountLines.NEXT() = 0;
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

