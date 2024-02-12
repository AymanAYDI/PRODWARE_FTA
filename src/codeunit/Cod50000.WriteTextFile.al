codeunit 50000 "Write Text File"
{

    trigger OnRun()
    var
        CduL: Codeunit "Export Items";
    begin
        CduL.FctSendItems();
    end;

    var
        tempblob: Codeunit "Temp Blob";
        BigTGExportText: BigText;
        InsGInstream: InStream;
        OusGOutstream: OutStream;

        BooGCommaDecimal: Boolean;
        BooGFixedValue: Boolean;
        ChaGCR: Char;
        ChaGLF: Char;
        TxtGSeparator: Text[1];

    procedure FctInitMessage(TxtPSeparator: Text[1]; BooPFixedValue: Boolean; BooPCommaDecimal: Boolean)

    begin
        tempblob.CreateOutStream(OusGOutstream);
        TxtGSeparator := '';
        if not BooPFixedValue then
            TxtGSeparator := TxtPSeparator;

        // File Format
        BooGFixedValue := BooPFixedValue;

        // Decimal separator
        BooGCommaDecimal := BooPCommaDecimal;

        // Define carriage return and new line for outstream Write
        ChaGCR := 13;
        ChaGLF := 10;
    end;

    procedure FctWriteBigSegment(TxtPTextFields: array[80] of Text[350]; IntPEndSegment: Integer)
    var
        IntLCount: Integer;
    begin
        Clear(BigTGExportText);

        IntLCount := 1;
        while (IntLCount <= IntPEndSegment) do begin
            //BigTGExportText.AddText(CduGConvert.BigAsciiToAnsi(TxtPTextFields[IntLCount]) + TxtGSeparator);
            BigTGExportText.AddText(TxtPTextFields[IntLCount] + TxtGSeparator);
            IntLCount += 1;
        end;

        BigTGExportText.AddText(Format(ChaGCR));
        BigTGExportText.AddText(Format(ChaGLF));
        BigTGExportText.Write(OusGOutstream);
    end;

    procedure FormatText(VarPSource: Variant; IntPFieldLen: Integer; BooPLayoutToRight: Boolean) TxtLResult: Text
    var
        IntLValueLen: Integer;
    begin
        TxtLResult := Format(VarPSource);

        IntLValueLen := StrLen(TxtLResult);
        if IntLValueLen > IntPFieldLen then
            TxtLResult := CopyStr(TxtLResult, 1, IntPFieldLen)
        else begin
            if not BooGFixedValue then
                exit;
            // Enlarge result value with space character
            if BooPLayoutToRight then
                // Add to left because real value in on the right side
                TxtLResult := PadStr('', IntPFieldLen - IntLValueLen) + TxtLResult
            else
                // Add to right because real value in on the left side
                TxtLResult := PadStr(TxtLResult, IntPFieldLen);
        end;
    end;

    procedure FctEndMessage(filename: Text)
    begin
        //*************** Fin du Message ***************//
        // FilGToExport.Close;
        tempblob.CreateInStream(InsGInstream);
        DownloadFromStream(InsGInstream, '', '', '', filename);
        // specify folder Not used in cloud
    end;
}

