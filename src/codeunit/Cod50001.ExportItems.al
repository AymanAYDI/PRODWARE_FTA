codeunit 50001 "Export Items"
{
    // TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        FctSendItems();
    end;

    var
        RecGSalesSetup: Record "Sales & Receivables Setup";
        CduGWriteFile: Codeunit "Write Text File";
        BooGFixedFile: Boolean;
        BooGCommaDecimal: Boolean;
        DecGAvailable: Decimal;


    procedure FctSendItems()
    var
        RecLCompanyInfo: Record "Company Information";
        RecLGLSetup: Record "General Ledger Setup";
        RecLVendor: Record Vendor;
        //RecLItemCrossRef: Record "5717";
        RecLItem: Record Item;
        TxtLRepertory: Text[250];
        TxtLFileName: Text[250];
        TxtLTextFields: array[80] of Text;

        IntLCmp: Integer;
    begin
        //>> Message structure: EDIFACT GENERIX
        RecGSalesSetup.GET();

        // Get file setup for this customer
        TxtLRepertory := RecGSalesSetup."Export Item Repertory";
        //TxtLFileName := 'Item_Export';

        TxtLFileName := 'Item_Export_' +
          //OLD FORMAT(CURRENTDATETIME,0,'<year4><month,2><Day,2><Hours24,2><Filler Character,0><Minutes,2><Seconds,2>')
          FORMAT(TODAY, 0, '<year4><month,2><Day,2><Filler Character,0>')
          + '_' + FORMAT(TIME, 0, '<Hours,2><Minutes,2><Seconds,2><Filler Character,0>')
          + '.csv';

        // STRSUBSTNO(RecPEDICustSetup."File Name",'F' + RecPSalesInvHeader."No.");

        // Create file
        BooGFixedFile := false;
        BooGCommaDecimal := false;


        CduGWriteFile.FctInitMessage(';', BooGFixedFile, BooGCommaDecimal);

        // Get setup
        RecLCompanyInfo.GET();
        RecLGLSetup.GET();

        // Pour les tests
        //RecLItem.SETRANGE(RecLItem."No.",'2072');
        IntLCmp := 0;
        // ********************************* HEADER ********************************* //
        CLEAR(TxtLTextFields);
        RecLItem.SETRANGE(RecLItem."Send To Web", true);
        if RecLItem.FINDSET() then
            repeat
                if IntLCmp = 0 then begin
                    // 1 - Item No.
                    TxtLTextFields[1] := CduGWriteFile.FormatText('Code article', 50, false);
                    // 2 - Item Description
                    TxtLTextFields[2] := CduGWriteFile.FormatText('Designation', 50, false);
                    // 3 - Item Disc Group
                    TxtLTextFields[3] := CduGWriteFile.FormatText('Groupe remise article', 50, false);
                    // 4 - Réf Fournisseur
                    TxtLTextFields[4] := CduGWriteFile.FormatText('Reference fournisseur', 50, false);
                    // 5 - Prix Unitaire
                    TxtLTextFields[5] := CduGWriteFile.FormatText('Prix unitaire', 20, false);

                    // 6 - Nom du fournisseur

                    TxtLTextFields[6] := CduGWriteFile.FormatText('Nom du fournisseur', 50, false);
                    // 7 - Stock
                    TxtLTextFields[7] := CduGWriteFile.FormatText('Stock', 20, false);
                    // 8 - BOM
                    TxtLTextFields[8] := CduGWriteFile.FormatText('BOM', 10, false);

                    // 9 - Item Category Code
                    TxtLTextFields[9] := CduGWriteFile.FormatText('Code categorie article', 50, false);


                    CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 9);

                end;
                IntLCmp += 1;

                // 1 - Item No.
                TxtLTextFields[1] := CduGWriteFile.FormatText(RecLItem."No.", 30, false);
                // 2 - Item Description
                TxtLTextFields[2] := CduGWriteFile.FormatText(RecLItem.Description, 50, false);
                // 3 - Item Disc Group
                TxtLTextFields[3] := CduGWriteFile.FormatText(RecLItem."Item Disc. Group", 20, false);
                // 4 - Réf Fournisseur
                TxtLTextFields[4] := CduGWriteFile.FormatText(RecLItem."Vendor Item No.", 20, false);
                // 5 - Prix Unitaire
                TxtLTextFields[5] := CduGWriteFile.FormatText(RecLItem."Unit Price", 20, false);

                // 6 - Nom du fournisseur
                if RecLVendor.GET(RecLItem."Vendor No.") then
                    TxtLTextFields[6] := CopyStr(CduGWriteFile.FormatText(RecLVendor.Name, 50, false), 1, 350)
                else
                    TxtLTextFields[6] := CopyStr(CduGWriteFile.FormatText('', 8, false), 1, 350);
                // 7 - Stock
                RecLItem.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Asm. Component", "Reserved Qty. on Purch. Orders", RecLItem."Assembly BOM");
                DecGAvailable := RecLItem.Inventory - (RecLItem."Qty. on Sales Order" + RecLItem."Qty. on Asm. Component") + RecLItem."Reserved Qty. on Purch. Orders";
                TxtLTextFields[7] := CopyStr(CduGWriteFile.FormatText(FORMAT(DecGAvailable), 20, false), 1, 350);
                // 8 - BOM
                TxtLTextFields[8] := CopyStr(CduGWriteFile.FormatText(FORMAT(RecLItem."Assembly BOM"), 10, false), 1, 350);

                // 9 - Item Category Code
                //>>TI487350
                //TxtLTextFields[9] := CduGWriteFile.FormatText(RecLItem."Item Category Code",10,FALSE);
                TxtLTextFields[9] := CopyStr(CduGWriteFile.FormatText(RecLItem."Global Dimension 1 Code", 20, false), 1, 350);
                //<<TI478350


                CduGWriteFile.FctWriteBigSegment(TxtLTextFields, 9);
            until RecLItem.NEXT() = 0;
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

