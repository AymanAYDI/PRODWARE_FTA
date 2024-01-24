codeunit 50002 "Customers Export"
{
    // TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        FctSendCustomers();
    end;

    var
        RecGSalesSetup: Record "Sales & Receivables Setup";
        CduGWriteFile: Codeunit "Write Text File";
        BooGFixedFile: Boolean;
        BooGCommaDecimal: Boolean;


    procedure FctSendCustomers()
    var
        RecLCustomer: Record "Customer";
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

        TxtLFileName := 'Customer_Export_' +
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
        //RecLCustomer.SETRANGE(RecLCustomer."No.",'000001');

        // ********************************* HEADER ********************************* //
        CLEAR(TxtLTextFields);
        if RecLCustomer.FINDSET() then
            repeat

                if IntLCmp = 0 then begin
                    // 1 - Customer No.
                    TxtLTextFields[1] := CduGWriteFile.FormatText('Code client', 30, false);
                    // 2 - Cust Name
                    TxtLTextFields[2] := CduGWriteFile.FormatText('Nom client', 50, false);
                    // 3 - Cust Adress 1
                    TxtLTextFields[3] := CduGWriteFile.FormatText('Addresse 1', 50, false);
                    // 4 -  Cust Adress 2
                    TxtLTextFields[4] := CduGWriteFile.FormatText('Adresse 2', 50, false);
                    // 5 - Post Code
                    TxtLTextFields[5] := CduGWriteFile.FormatText('Code postal', 50, false);

                    // 6 - City
                    TxtLTextFields[6] := CduGWriteFile.FormatText('Ville', 30, false);
                    // 7 - Country
                    TxtLTextFields[7] := CduGWriteFile.FormatText('Pays', 10, false);
                    // 8 - Phone No.
                    TxtLTextFields[8] := CduGWriteFile.FormatText('Numero de telephone', 30, false);

                    CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 8);

                end;
                IntLCmp += 1;


                // 1 - Customer No.
                TxtLTextFields[1] := CduGWriteFile.FormatText(RecLCustomer."No.", 30, false);
                // 2 - Cust Name
                TxtLTextFields[2] := CduGWriteFile.FormatText(RecLCustomer.Name, 50, false);
                // 3 - Cust Adress 1
                TxtLTextFields[3] := CduGWriteFile.FormatText(RecLCustomer.Address, 50, false);
                // 4 -  Cust Adress 2
                TxtLTextFields[4] := CduGWriteFile.FormatText(RecLCustomer."Address 2", 50, false);
                // 5 - Post Code
                TxtLTextFields[5] := CduGWriteFile.FormatText(RecLCustomer."Post Code", 20, false);

                // 6 - City
                TxtLTextFields[6] := CduGWriteFile.FormatText(RecLCustomer.City, 30, false);
                // 7 - Country
                TxtLTextFields[7] := CduGWriteFile.FormatText(RecLCustomer."Country/Region Code", 10, false);
                // 8 - Phone No.
                TxtLTextFields[8] := CduGWriteFile.FormatText(RecLCustomer."Phone No.", 30, false);

                CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 8);
            until RecLCustomer.NEXT() = 0;
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

