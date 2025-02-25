report 7207397 "QB_Generate TXT File"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("QB_IRPF Statement Names"; "QB_IRPF Statement Names")
        {

            DataItemTableView = SORTING("QB_Declaration");
            ;
            DataItem("QB_IRPF VAT Statement Line"; "QB_IRPF VAT Statement Line")
            {

                DataItemTableView = SORTING("QB_IRPF Declaration", "QB_No.")
                                 WHERE("QB_Print" = CONST(true));
                DataItemLink = "QB_IRPF Declaration" = FIELD("QB_Declaration");
                trigger OnPreDataItem();
                VAR
                    //                                IRPFVATStatementLine@1100286000 :
                    IRPFVATStatementLine: Record 7206979;
                BEGIN
                    TransferenceFormat.DELETEALL;

                    IRPFVATStatementLine.RESET;
                    IRPFVATStatementLine.SETRANGE(QB_Type, IRPFVATStatementLine.QB_Type::Ask);
                    PAGE.RUNMODAL(PAGE::"QB_IRPF Transference Format", IRPFVATStatementLine);

                    IRPFVATStatementLine.RESET;
                    IRPFVATStatementLine.SETRANGE("QB_IRPF Declaration", "QB_IRPF Statement Names".QB_Declaration);
                    IRPFVATStatementLine.FINDSET;
                    REPEAT
                        TransferenceFormat.INIT;
                        TransferenceFormat."VAT Statement Name" := IRPFVATStatementLine."QB_IRPF Declaration";
                        TransferenceFormat."No." := IRPFVATStatementLine."QB_No.";
                        TransferenceFormat.Subtype := IRPFVATStatementLine.QB_Subtype;
                        TransferenceFormat.Length := IRPFVATStatementLine.QB_Length;
                        TransferenceFormat.Position := IRPFVATStatementLine.QB_Position;
                        TransferenceFormat.INSERT;
                    UNTIL IRPFVATStatementLine.NEXT = 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    TransferenceFormat.RESET;
                    TransferenceFormat.GET("QB_IRPF VAT Statement Line"."QB_IRPF Declaration", "QB_IRPF VAT Statement Line"."QB_No.");

                    CalcTotLine("QB_IRPF VAT Statement Line", TotalAmount, 0);
                    IF "QB_IRPF VAT Statement Line"."QB_Print with" = "QB_IRPF VAT Statement Line"."QB_Print with"::"Opposite Sign" THEN
                        TotalAmount := -TotalAmount;
                    IF "QB_IRPF VAT Statement Line".QB_Type = "QB_IRPF VAT Statement Line".QB_Type::Numerical THEN
                        LoadValue(TransferenceFormat, TotalAmount);

                    TransferenceFormat.MODIFY;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                "QB_IRPF Statement Names".SETFILTER(QB_Declaration, IRPFDeclaration);
            END;


        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group("group727")
                {

                    CaptionML = ENU = 'General';
                    field("IRPFDeclaration"; "IRPFDeclaration")
                    {

                        CaptionML = ESP = 'Declaraci¢n IRPF';
                        TableRelation = "QB_IRPF Statement Names";
                    }
                    field("IRPFWithhTypeFilter"; "IRPFWithhTypeFilter")
                    {

                        CaptionML = ESP = 'Filtro Tipo retenc. IRPF';
                        TableRelation = "Withholding Group".Code;
                    }
                    field("PeriodFilter"; "PeriodFilter")
                    {

                        CaptionML = ESP = 'Filtro Periodo';
                    }
                    field("WithholdingFilter"; "WithholdingFilter")
                    {

                        CaptionML = ESP = 'Filtro Retenci¢n';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       VATPostSetup@1100286008 :
        VATPostSetup: Record 325;
        //       TransferenceFormat@1100286014 :
        TransferenceFormat: Record 10705 TEMPORARY;
        //       TemplateTransfFormat@1100286016 :
        TemplateTransfFormat: Record 10705;
        //       TempBlob@1100286028 :
        TempBlob: Codeunit "Temp Blob";
        //       IRPFDeclaration@1100286000 :
        IRPFDeclaration: Code[10];
        //       IRPFWithhTypeFilter@1100286001 :
        IRPFWithhTypeFilter: Code[1024];
        //       PeriodFilter@1100286002 :
        PeriodFilter: Text;
        //       Text001@1100286003 :
        Text001: TextConst ESP = 'Debe seleccionar un valor para el campo ÈDeclaraci¢n IRPFÉ, ÈFiltro Tipo retenc. IRPFÉ y ÈFiltro PeriodoÉ.';
        //       WithholdingFilter@1100286004 :
        WithholdingFilter: Integer;
        //       IntegerPrinted@1100286018 :
        IntegerPrinted: Boolean;
        //       Amount@1100286005 :
        Amount: Decimal;
        //       Base@1100286007 :
        Base: Decimal;
        //       VATAmount@1100286011 :
        VATAmount: Decimal;
        //       TotalAmount@1100286017 :
        TotalAmount: Decimal;
        //       TotalBase@1100286006 :
        TotalBase: Decimal;
        //       TotalECAmount@1100286013 :
        TotalECAmount: Decimal;
        //       TotalVATAmount@1100286012 :
        TotalVATAmount: Decimal;
        //       i@1100286037 :
        i: Integer;
        //       VATPercentage@1100286010 :
        VATPercentage: Decimal;
        //       ECPercentage@1100286009 :
        ECPercentage: Decimal;
        //       Text002@1100286043 :
        Text002: TextConst ENU = 'Exportar Archivo', ESP = 'Exportar Archivo';
        //       TextFile@1100286044 :
        TextFile: TextConst ESP = 'Archivos de texto (*.txt)|*.txt';
        //       Text1100003@1100286015 :
        Text1100003: TextConst ENU = 'E', ESP = 'E';
        //       Text1100006@1100286041 :
        Text1100006: TextConst ENU = 'C:\', ESP = 'C:\';
        //       Text1100007@1100286029 :
        Text1100007: TextConst ENU = '.txt', ESP = '.txt';
        //       Text1100008@1100286019 :
        Text1100008: TextConst ENU = 'Transference format line N§ %1 must be integer', ESP = 'El formato transfrencia l¡nea n§ %1 debe ser entero';
        //       Negative@1100286020 :
        Negative: Code[1];
        //       Text1100009@1100286021 :
        Text1100009: TextConst ENU = 'N', ESP = 'N';
        //       Text1100010@1100286025 :
        Text1100010: TextConst ENU = '<Precision,', ESP = '<Precision,';
        //       Text1100011@1100286024 :
        Text1100011: TextConst ENU = '><Integer><Decimal>', ESP = '><Integer><Decimal>';
        //       Text1100012@1100286023 :
        Text1100012: TextConst ENU = '<Integer>', ESP = '<Integer>';
        //       Text1100013@1100286022 :
        Text1100013: TextConst ENU = '><Decimal>', ESP = '><Decimal>';
        //       TextError@1100286046 :
        TextError: Text[80];
        //       RowNo@1100286045 :
        RowNo: ARRAY[6] OF Integer;
        //       Counter@1100286036 :
        Counter: Integer;
        //       Position@1100286032 :
        Position: Integer;
        //       FieldValue@1100286035 :
        FieldValue: Text[250];
        //       Acum@1100286030 :
        Acum: Integer;
        //       Decimal1@1100286034 :
        Decimal1: Text[30];
        //       Decimal2@1100286033 :
        Decimal2: Text[30];
        //       CM@1100286031 :
        CM: Text;
        //       Line@1100286039 :
        Line: Text[250];
        //       LineLen@1100286038 :
        LineLen: Integer;
        //       FromFile@1100286027 :
        FromFile: Text[1024];
        //       ToFile@1100286026 :
        ToFile: Text[1024];
        //       SilentMode@1100286040 :
        SilentMode: Boolean;
        //       SilentModeFileName@1100286042 :
        SilentModeFileName: Text;



    trigger OnPreReport();
    begin
        if (IRPFDeclaration = '') or (IRPFWithhTypeFilter = '') or (PeriodFilter = '') then
            ERROR(Text001);
    end;

    trigger OnPostReport();
    begin
        TransferenceFormat.RESET;
        TransferenceFormat.FINDSET;
        repeat
            if (TransferenceFormat.Value = '') and (TransferenceFormat.Type = TransferenceFormat.Type::Numerical) then
                LoadValue(TransferenceFormat, 0);
        until TransferenceFormat.NEXT = 0;

        TransferenceFormat.RESET;
        TransferenceFormat.FINDSET;
        repeat
            if TransferenceFormat.Type = TransferenceFormat.Type::Currency then begin
                TransferenceFormat.Value := Text1100003;
                TransferenceFormat.MODIFY
            end;
        until TransferenceFormat.NEXT = 0;

        TransferenceFormat.MODIFY;
        FileGeneration(TransferenceFormat);
    end;



    // procedure CalcTotLine (IRPFVATStatementLine2@1100000 : Record 7206979;var TotalAmount@1100001 : Decimal;Level@1100002 :
    procedure CalcTotLine(IRPFVATStatementLine2: Record 7206979; var TotalAmount: Decimal; Level: Integer): Boolean;
    var
        //       WithholdingMovements@1100286000 :
        WithholdingMovements: Record 7207329;
        //       WithholdingGroup@1100286001 :
        WithholdingGroup: Record 7207330;
        //       WithholdingMovementsRecRef@1100286002 :
        WithholdingMovementsRecRef: RecordRef;
        //       FieldRef@1100286003 :
        FieldRef: FieldRef;
        //       intValue@1100286004 :
        intValue: Integer;
        //       Period@1100286005 :
        Period: Integer;
        //       decAmount@1100286006 :
        decAmount: Decimal;
        //       strValue@1100286007 :
        strValue: Text;
    begin
        if Level = 0 then
            TotalAmount := 0;

        intValue := 0;
        Amount := 0;

        CASE IRPFVATStatementLine2.QB_Type OF
            IRPFVATStatementLine2.QB_Type::Numerical:
                begin
                    WithholdingMovementsRecRef.OPEN(DATABASE::"Withholding Movements");

                    WithholdingGroup.RESET;
                    if IRPFVATStatementLine2."QB_Withholding Filter" <> '' then
                        WithholdingGroup.SETFILTER(Code, IRPFVATStatementLine2."QB_Withholding Filter")
                    else
                        WithholdingGroup.SETFILTER(QB_IRPFWithhType, IRPFVATStatementLine2."QB_IRPF Withh. Type Filter");
                    if WithholdingGroup.FINDSET then
                        repeat
                            if IRPFVATStatementLine2."QB_Application Type" <> IRPFVATStatementLine2."QB_Application Type"::" " then begin
                                FieldRef := WithholdingMovementsRecRef.FIELD(WithholdingMovements.FIELDNO("Withholding Type"));
                                FieldRef.SETFILTER('%1', IRPFVATStatementLine2."QB_Application Type");
                            end;
                            FieldRef := WithholdingMovementsRecRef.FIELD(WithholdingMovements.FIELDNO("Withholding Code"));
                            FieldRef.SETFILTER('%1', WithholdingGroup.Code);

                            FieldRef := WithholdingMovementsRecRef.FIELD(WithholdingMovements.FIELDNO("Posting Date"));
                            FieldRef.SETFILTER(PeriodFilter);
                            if WithholdingMovementsRecRef.FINDSET then
                                repeat
                                    FieldRef := WithholdingMovementsRecRef.FIELD(IRPFVATStatementLine2."QB_Withholding Field");
                                    decAmount := FieldRef.VALUE;
                                    Amount += decAmount;
                                until WithholdingMovementsRecRef.NEXT = 0;
                        until WithholdingGroup.NEXT = 0;
                    CalcTotAmount(IRPFVATStatementLine2, TotalAmount);
                    TransferenceFormat.Type := TransferenceFormat.Type::Numerical;
                end;
            IRPFVATStatementLine2.QB_Type::Counter:
                begin
                    WithholdingMovementsRecRef.OPEN(DATABASE::"Withholding Movements");

                    WithholdingGroup.RESET;
                    if IRPFVATStatementLine2."QB_Withholding Filter" <> '' then
                        WithholdingGroup.SETFILTER(WithholdingGroup.Code, IRPFVATStatementLine2."QB_Withholding Filter")
                    else
                        WithholdingGroup.SETFILTER(QB_IRPFWithhType, IRPFVATStatementLine2."QB_IRPF Withh. Type Filter");
                    if WithholdingGroup.FINDSET then
                        repeat
                            if IRPFVATStatementLine2."QB_Application Type" <> IRPFVATStatementLine2."QB_Application Type"::" " then begin
                                FieldRef := WithholdingMovementsRecRef.FIELD(WithholdingMovements.FIELDNO("Withholding Type"));
                                FieldRef.SETFILTER('%1', IRPFVATStatementLine2."QB_Application Type");
                            end;
                            FieldRef := WithholdingMovementsRecRef.FIELD(WithholdingMovements.FIELDNO("Withholding Code"));
                            FieldRef.SETFILTER('%1', WithholdingGroup.Code);

                            FieldRef := WithholdingMovementsRecRef.FIELD(WithholdingMovements.FIELDNO("Posting Date"));
                            FieldRef.SETFILTER(PeriodFilter);
                            intValue += WithholdingMovementsRecRef.COUNT;
                        until WithholdingGroup.NEXT = 0;

                    TransferenceFormat.Value := FORMAT(intValue);
                    TransferenceFormat.Type := TransferenceFormat.Type::Numerical;
                end;
            IRPFVATStatementLine2.QB_Type::Fix:
                begin
                    TransferenceFormat.Value := IRPFVATStatementLine2.QB_Value;
                    TransferenceFormat.Type := TransferenceFormat.Type::Fix;
                end;
            IRPFVATStatementLine2.QB_Type::Alphanumerical:
                begin
                    TransferenceFormat.Value := IRPFVATStatementLine2.QB_Value;
                    TransferenceFormat.Type := TransferenceFormat.Type::Alphanumerical;
                end;
            IRPFVATStatementLine2.QB_Type::Ask:
                begin
                    if IRPFVATStatementLine2.QB_Subtype <> IRPFVATStatementLine2.QB_Subtype::" " then begin
                        if EVALUATE(decAmount, IRPFVATStatementLine2.QB_Value) then begin
                            TransferenceFormat.Value := IRPFVATStatementLine2.QB_Value;
                            TransferenceFormat.Type := TransferenceFormat.Type::Numerical;

                            strValue := INSSTR(IRPFVATStatementLine2.QB_Value, ',', STRLEN(IRPFVATStatementLine2.QB_Value) - 1);
                            if EVALUATE(decAmount, strValue) then;
                            if COPYSTR(strValue, 1, 1) = Text1100009 then
                                decAmount := -decAmount;

                            Amount += decAmount;
                            LoadValue(TransferenceFormat, TotalAmount);
                            CalcTotAmount(IRPFVATStatementLine2, TotalAmount);
                        end;
                    end else begin
                        TransferenceFormat.Value := IRPFVATStatementLine2.QB_Value;
                        TransferenceFormat.Type := TransferenceFormat.Type::Ask;
                    end;
                end;
            IRPFVATStatementLine2.QB_Type::"Row Totaling":
                begin
                    if Level >= ARRAYLEN(RowNo) then
                        exit(FALSE);
                    Level := Level + 1;
                    RowNo[Level] := IRPFVATStatementLine2."QB_No.";

                    if IRPFVATStatementLine2."QB_Row Totaling" = '' then
                        exit(TRUE);
                    IRPFVATStatementLine2.SETRANGE("QB_IRPF Declaration", IRPFVATStatementLine2."QB_IRPF Declaration");
                    IRPFVATStatementLine2.SETFILTER("QB_No.", IRPFVATStatementLine2."QB_Row Totaling");
                    if IRPFVATStatementLine2.FINDSET then
                        repeat
                            if not CalcTotLine(IRPFVATStatementLine2, TotalAmount, Level) then begin
                                if Level > 1 then
                                    exit(FALSE);
                                FOR i := 1 TO ARRAYLEN(RowNo) DO
                                    TextError := TextError + FORMAT(RowNo[i]) + ' => ';
                                TextError := TextError + '...';
                                IRPFVATStatementLine2.FIELDERROR("QB_No.", TextError);
                            end;
                        until IRPFVATStatementLine2.NEXT = 0;

                    TransferenceFormat.Type := TransferenceFormat.Type::Numerical;
                    LoadValue(TransferenceFormat, TotalAmount);
                end;
        end;

        exit(TRUE);
    end;

    //     LOCAL procedure CalcTotAmount (IRPFVATStatementLine2@1100000 : Record 7206979;var TotalAmount@1100001 :
    LOCAL procedure CalcTotAmount(IRPFVATStatementLine2: Record 7206979; var TotalAmount: Decimal)
    begin
        TotalAmount := TotalAmount + Amount;
        TotalBase := TotalBase + Base;
    end;

    //     procedure LoadValue (var TransFormat@1100000 : Record 10705;Amt@1100001 :
    procedure LoadValue(var TransFormat: Record 10705; Amt: Decimal)
    begin
        if TransFormat.Type <> TransFormat.Type::Numerical then
            ERROR(Text1100008, TransFormat."No.");

        if Amt < 0 then begin
            Negative := Text1100009;
            Amt := -Amt;
        end else
            Negative := '';

        CASE TransFormat.Subtype OF
            TransFormat.Subtype::"Integer and Decimal Part":
                begin
                    TransFormat.Value := FORMAT(Amt, TransFormat.Length, Text1100010 + '2' + Text1100011);
                    TransFormat.Value := CONVERTSTR(DELCHR(TransFormat.Value, '=', ',.'), ' ', '0');
                    TransFormat.Value := Negative + PADSTR('', TransFormat.Length - STRLEN(Negative) -
                        STRLEN(TransFormat.Value), '0') + TransFormat.Value;
                end;
            TransFormat.Subtype::"Integer Part":
                begin
                    TransFormat.Value := Negative + FORMAT(Amt, TransFormat.Length - STRLEN(Negative),
                        Text1100012);
                    TransFormat.Value := CONVERTSTR(CONVERTSTR(TransFormat.Value, ',', '.'), ' ', '0');
                end;
            TransFormat.Subtype::"Decimal Part":
                begin
                    TransFormat.Value := FORMAT(Amt, TransFormat.Length, Text1100010 + '2' + Text1100013);
                    TransFormat.Value := CONVERTSTR(DELCHR(TransFormat.Value, '=', '.,'), ' ', '0');
                    TransFormat.Value := Negative + PADSTR('', TransFormat.Length - STRLEN(Negative) -
                        STRLEN(TransFormat.Value), '0') + TransFormat.Value;
                end;
        end;
        TransFormat.MODIFY;
    end;

    //     procedure FileGeneration (var TransFormat@1100000 :
    procedure FileGeneration(var TransFormat: Record 10705)
    var
        //       FileManagement@1100002 :
        FileManagement: Codeunit 419;
        //       OutStream@1100003 :
        OutStream: OutStream;
        //       InStream@1100286000 :
        InStream: InStream;
        //       l@1100286001 :
        l: Integer;
    begin
        TransFormat.FINDLAST;
        ToFile := "QB_IRPF Statement Names".QB_Description + Text1100007;

        CLEAR(TempBlob);

        TempBlob.CREATEOUTSTREAM(OutStream);
        TempBlob.CREATEINSTREAM(InStream);

        Acum := 0;
        TransFormat.FINDSET;
        repeat
            if (TransFormat.Position + TransFormat.Length) > Acum then
                Acum := TransFormat.Position + TransFormat.Length;
        until TransFormat.NEXT = 0;
        Acum := Acum - 1;

        CM := PADSTR(CM, Acum, ' ');

        l := STRLEN(CM);

        TransFormat.FINDSET;
        repeat
            Position := TransFormat.Position;
            Counter := TransFormat.Length - STRLEN(TransFormat.Value);
            FieldValue := TransFormat.Value;

            CASE TransFormat.Type OF
                TransFormat.Type::Alphanumerical:
                    begin
                        OutStream.WRITETEXT(FieldValue);
                        FOR i := 1 TO (TransFormat.Length - STRLEN(FieldValue)) DO
                            OutStream.WRITETEXT(' ');
                    end;
                TransFormat.Type::Numerical:
                    begin
                        WHILE Counter > 0 DO begin
                            Counter := Counter - 1;
                            OutStream.WRITETEXT('0');
                        end;
                        if TransFormat.Subtype = TransFormat.Subtype::"Integer and Decimal Part" then begin
                            if STRPOS(FieldValue, '.') <> 0 then begin
                                Decimal1 := DELSTR(FieldValue, 1, STRLEN(FieldValue) - 1);
                                Decimal2 := DELSTR(FieldValue, 1, STRLEN(FieldValue) - 2);
                                Decimal2 := DELSTR(Decimal2, 2, 1);
                                FieldValue := DELSTR(FieldValue, 15, 3);
                                FieldValue := '0' + FieldValue;
                                FieldValue := FieldValue + Decimal2 + Decimal1;
                            end;
                        end;
                        OutStream.WRITETEXT(FieldValue);
                    end;
                TransFormat.Type::Fix:
                    OutStream.WRITETEXT(FieldValue);
                TransFormat.Type::Ask:
                    begin
                        OutStream.WRITETEXT(FieldValue);
                        FOR i := 1 TO (TransFormat.Length - STRLEN(FieldValue)) DO
                            OutStream.WRITETEXT(' ');
                    end;
                TransFormat.Type::Currency:
                    OutStream.WRITETEXT(FieldValue);
            end;
        until TransFormat.NEXT = 0;

        DOWNLOADFROMSTREAM(InStream, Text002, '', TextFile, ToFile);
    end;

    /*begin
    //{
//      Q15410 MCM - 14/10/21 - Creacion del report de exportaci¢n
//    }
    end.
  */

}



