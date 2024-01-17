codeunit 50000 "Write Text File"
{

    trigger OnRun()
    var
        CduL: Codeunit "Export Items";
    begin
        CduL.FctSendItems();
    end;

    var
        FilGToExport: File;
        InsGInstream: InStream;
        OusGOutstream: OutStream;
        TxtGSeparator: Text[1];
        TxtGHeaderSeparator: Text[1];
        TxtGLineSeparator: Text[1];
        TxtGReadFile: Text[250];
        BigTGExportText: BigText;
        BooGFixedValue: Boolean;
        BooGCommaDecimal: Boolean;
        ChaGCR: Char;
        ChaGLF: Char;


    procedure FctInitMessage(TxtPRepertory: Text[250]; TxtPFileName: Text[250]; TxtPSeparator: Text[1]; BooPFixedValue: Boolean; BooPCommaDecimal: Boolean)
    var
        tempblob: Codeunit "Temp Blob";
        i: Integer;
        TxtLTestFieldRef: Text[250];
        intLFileLenght: Integer;
        outstream: OutStream;
        instream: InStream;
        text: text;
    begin

        // tempblob.CREATEOUTSTREAM(outstream);
        // tempblob.CREATEINSTREAM(instream);

        tempblob.CREATEOUTSTREAM(OusGOutstream);
        text := 'dfff';
        OusGOutstream.WriteText(text);
        //*************** Initialisation du message et du fichier texte ***************//
        // Create export file
        FilGToExport.TEXTMODE(true);
        FilGToExport.WRITEMODE(true);
        if FilGToExport.OPEN(TxtPRepertory + '\' + TxtPFileName) then begin
            if FilGToExport.LEN > 0 then
                //if tempblob.LENGTH() > 0 then
                FilGToExport.SEEK(FilGToExport.LEN)
            //FilGToExport.SEEK(tempblob.LENGTH())
            else
                FilGToExport.CREATE(TxtPRepertory + '\' + TxtPFileName, TEXTENCODING::Windows);
            FilGToExport.CREATEOUTSTREAM(OusGOutstream);
        end else begin
            FilGToExport.CREATE(TxtPRepertory + '\' + TxtPFileName, TEXTENCODING::Windows);
            FilGToExport.CREATEOUTSTREAM(OusGOutstream);
            // tempblob.CREATEOUTSTREAM(OusGOutstream);

        end;

        // Field separator
        TxtGSeparator := '';
        if not BooPFixedValue then
            TxtGSeparator := TxtPSeparator;

        // File format
        BooGFixedValue := BooPFixedValue;

        // Decimal separator
        BooGCommaDecimal := BooPCommaDecimal;

        // Define carriage return and new line for outstream write
        ChaGCR := 13;
        ChaGLF := 10;
    end;


    procedure FctWriteSegment(TxtPTextFields: array[50] of Text[250]; IntPEndSegment: Integer)
    var
        IntLCount: Integer;
    begin
        //*************** Fonction qui va écrire une ligne dans le fichier texte ***************//
        CLEAR(BigTGExportText);

        IntLCount := 1;
        while (IntLCount <= IntPEndSegment) do begin
            //BigTGExportText.ADDTEXT(CduGConvert.AsciiToAnsi(TxtPTextFields[IntLCount]) + TxtGSeparator);
            BigTGExportText.ADDTEXT(TxtPTextFields[IntLCount] + TxtGSeparator);
            IntLCount += 1;
        end;

        BigTGExportText.ADDTEXT(FORMAT(ChaGCR));
        BigTGExportText.ADDTEXT(FORMAT(ChaGLF));
        BigTGExportText.WRITE(OusGOutstream);
    end;


    procedure FctEndMessage()
    begin
        //*************** Fin du message ***************//
        FilGToExport.CLOSE;
    end;


    procedure FormatText(VarPSource: Variant; IntPFieldLen: Integer; BooPLayoutToRight: Boolean) TxtLResult: Text[500]
    var
        IntLValueLen: Integer;
    begin
        // Format value
        TxtLResult := FORMAT(VarPSource);

        IntLValueLen := STRLEN(TxtLResult);
        if IntLValueLen > IntPFieldLen then
            TxtLResult := COPYSTR(TxtLResult, 1, IntPFieldLen)
        else begin
            if not BooGFixedValue then
                exit;
            // Enlarge result value with space character
            if BooPLayoutToRight then
                // Add to left because real value in on the right side
                TxtLResult := PADSTR('', IntPFieldLen - IntLValueLen) + TxtLResult
            else
                // Add to right because real value in on the left side
                TxtLResult := PADSTR(TxtLResult, IntPFieldLen);
        end;
    end;


    procedure FormatDecimal(DecPValue: Decimal; IntPFieldLen: Integer; BooPDropSeparator: Boolean; IntPDecimalPlaces: Integer) TxtLResult: Text[20]
    var
        CstL000: Label 'Quantity of Decimals %1 not managed.';
    begin
        // Format value in text and set comma as decimal separator
        if not BooGFixedValue then
            IntPFieldLen := 0;

        if BooGCommaDecimal then
            // Format value in text and set comma as decimal separator
            case IntPDecimalPlaces of
                0:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,0:0><Integer><Decimal><Comma,,>');
                1:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,1:1><Integer><Decimal><Comma,,>');
                2:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,2:2><Integer><Decimal><Comma,,>');
                3:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,3:3><Integer><Decimal><Comma,,>');
                4:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,4:4><Integer><Decimal><Comma,,>');
                5:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,5:5><Integer><Decimal><Comma,,>');
                else
                    ERROR(CstL000, IntPDecimalPlaces);

            end else
            // Format value in text and set dot as decimal separator
            case IntPDecimalPlaces of
                0:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,0:0><Integer><Decimal><Comma,.>');
                1:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,1:1><Integer><Decimal><Comma,.>');
                2:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,2:2><Integer><Decimal><Comma,.>');
                3:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,3:3><Integer><Decimal><Comma,.>');
                4:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,4:4><Integer><Decimal><Comma,.>');
                5:
                    TxtLResult := FORMAT(DecPValue, IntPFieldLen, '<Precision,5:5><Integer><Decimal><Comma,.>');
                else
                    ERROR(CstL000, IntPDecimalPlaces);
            end;


        // Manage Fixed decimal value
        if not BooGFixedValue then
            exit;

        // Drop decimal separator if required
        if BooPDropSeparator and (IntPDecimalPlaces <> 0) then
            TxtLResult := ' ' + COPYSTR(TxtLResult, 1, IntPFieldLen - (IntPDecimalPlaces + 1)) +
              COPYSTR(TxtLResult, IntPFieldLen - IntPDecimalPlaces + 1, IntPDecimalPlaces);

        if DecPValue = 0 then
            TxtLResult := PADSTR('', IntPFieldLen);
    end;


    procedure FctWriteBigSegment(TxtPTextFields: array[80] of Text[350]; IntPEndSegment: Integer)
    var
        IntLCount: Integer;
    begin
        // Copied from FctWriteSegment: use ARRAY [80] OF Text[350]
        CLEAR(BigTGExportText);

        IntLCount := 1;
        while (IntLCount <= IntPEndSegment) do begin
            //BigTGExportText.ADDTEXT(CduGConvert.BigAsciiToAnsi(TxtPTextFields[IntLCount]) + TxtGSeparator);
            BigTGExportText.ADDTEXT(TxtPTextFields[IntLCount] + TxtGSeparator);
            IntLCount += 1;
        end;

        BigTGExportText.ADDTEXT(FORMAT(ChaGCR));
        BigTGExportText.ADDTEXT(FORMAT(ChaGLF));
        BigTGExportText.WRITE(OusGOutstream);
    end;


    procedure FormatDate(DatPDate: Date): Text[8]
    begin
        exit(FORMAT(DatPDate, 0, '<Year4><Month,2><Day,2>'));
    end;


    procedure FormatTime(TimPTime: Time): Text[6]
    begin
        exit(FORMAT(TimPTime, 0, '<Hours24><Minutes,2><Seconds,2>'));
    end;


    procedure InitMessageFilepath(_Filepath: Text[250]; TxtPSeparator: Text[1]; BooPFixedValue: Boolean; BooPCommaDecimal: Boolean)
    var
        i: Integer;
        TxtLTestFieldRef: Text[250];
        intLFileLenght: Integer;
    begin
        //*************** Initialisation du message et du fichier texte ***************//
        // Create export file
        FilGToExport.TEXTMODE(true);
        FilGToExport.WRITEMODE(true);
        if FilGToExport.OPEN(_Filepath) then begin
            if FilGToExport.LEN > 0 then
                FilGToExport.SEEK(FilGToExport.LEN)
            else
                FilGToExport.CREATE(_Filepath, TEXTENCODING::Windows);
            FilGToExport.CREATEOUTSTREAM(OusGOutstream);
        end else begin
            FilGToExport.CREATE(_Filepath, TEXTENCODING::Windows);
            FilGToExport.CREATEOUTSTREAM(OusGOutstream);
        end; //TODO 

        // Field separator
        TxtGSeparator := '';
        if not BooPFixedValue then
            TxtGSeparator := TxtPSeparator;

        // File format
        BooGFixedValue := BooPFixedValue;

        // Decimal separator
        BooGCommaDecimal := BooPCommaDecimal;

        // Define carriage return and new line for outstream write
        ChaGCR := 13;
        ChaGLF := 10;
    end;


    procedure FormatDate2(_Date: Date): Text
    begin
        exit(FORMAT(_Date, 0, '<Year4>-<Month,2>-<Day,2>'));
    end;
}

