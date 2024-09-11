Codeunit 7207289 "ChangeNotInLetters"
{


    trigger OnRun()
    BEGIN
        MESSAGE(Decimal2Text(31.145, 2, TRUE, TRUE, '', 0));
    END;

    VAR
        GeneralLedgerSetup: Record 98;
        WithAsterisks: Boolean;
        Text10755: TextConst ENU = '" CENTS"', ESP = '" C�NTIMOS"';
        Text10756: TextConst ENU = '" CENTS"', ESP = '" C�NTIMOS"';
        Text10757: TextConst ENU = 'THOUSANDTH', ESP = 'MIL�SIMAS';
        Text10758: TextConst ENU = 'TEN THOUSANDTH', ESP = 'DIEZMIL�SIMAS';
        Text10759: TextConst ENU = '" CENT"', ESP = '" C�NTIMO"';
        Text10760: TextConst ENU = '" CENT"', ESP = '" C�NTIMO"';
        Text10761: TextConst ENU = 'THOUSANDTH', ESP = 'MIL�SIMA';
        Text10762: TextConst ENU = 'TEN THOUSANDTH', ESP = 'DIEZMIL�SIMA';
        Text001: TextConst ENU = '%1 is too big to be text-formatted', ESP = '%1 es demasiado grande para convertir a texto';
        NotAsterisks2: Boolean;
        NotTextCent: Boolean;
        DL: Boolean;
        Text002: TextConst ENU = '%1 \results in a written number which is too long.', ESP = 'El resultado es un texto demasiado largo.';
        Text003: TextConst ESP = '<Integer>';
        Text004: TextConst ENU = '<decimals>', ESP = '<Decimals>';
        Cero: Boolean;
        Remainder: Integer;
        HundMilion: Integer;
        TenMilion: Integer;
        UnitsMilion: Integer;
        HundThousands: Integer;
        TenThousands: Integer;
        UnitsThousands: Integer;
        Hundreds: Integer;
        Tens: Integer;
        Units: Integer;
        DecimalPlaces: Integer;
        Decimals: Integer;
        DecimalString: Text[15];
        TextDecimals: Boolean;
        One: Boolean;
        CurrencyPut: Boolean;
        DecimalText: ARRAY[2] OF Text[80];
        Text004a: TextConst ESP = '<Integer Thousand>';
        Text005: TextConst ENU = 'With', ESP = 'CON';
        Text006: TextConst ENU = 'With', ESP = 'DE';
        Text026: TextConst ENU = 'CERO', ESP = '"CERO "';
        Text50000: TextConst ESP = '"UNA "';
        Text10745: TextConst ENU = '"UN "', ESP = '"UN "';
        Text10746: TextConst ENU = '"UNO "', ESP = '"UNO "';
        Text10747: TextConst ENU = '"DOS "', ESP = '"DOS "';
        Text10748: TextConst ENU = '"TRES "', ESP = '"TRES "';
        Text10749: TextConst ENU = '"CUATRO "', ESP = '"CUATRO "';
        Text10750: TextConst ENU = '"CINCO "', ESP = '"CINCO "';
        Text10751: TextConst ENU = '"SEIS "', ESP = '"SEIS "';
        Text10752: TextConst ENU = '"SIETE "', ESP = '"SIETE "';
        Text10753: TextConst ENU = '"OCHO "', ESP = '"OCHO "';
        Text10754: TextConst ENU = '"NUEVE "', ESP = '"NUEVE "';
        Text10722: TextConst ENU = 'DIX', ESP = '"DIEZ "';
        Text10723: TextConst ENU = 'ELEVEN', ESP = '"ONCE "';
        Text10724: TextConst ENU = 'TWELVE', ESP = '"DOCE "';
        Text10725: TextConst ENU = 'THIRTEEN', ESP = '"TRECE "';
        Text10726: TextConst ENU = 'FOURTEEN', ESP = '"CATORCE "';
        Text10727: TextConst ENU = 'FIFTEEN', ESP = '"QUINCE "';
        Text10728: TextConst ENU = 'DIECI', ESP = 'DIECI';
        Text10729: TextConst ENU = '"VEINTE "', ESP = '"VEINTE "';
        Text10730: TextConst ENU = 'VEINTI', ESP = 'VEINTI';
        Text10731: TextConst ENU = '"TREINTA "', ESP = '"TREINTA "';
        Text10732: TextConst ENU = '"TREINTA Y "', ESP = '"TREINTA Y "';
        Text10733: TextConst ENU = '"CUARENTA "', ESP = '"CUARENTA "';
        Text10734: TextConst ENU = '"CUARENTA Y "', ESP = '"CUARENTA Y "';
        Text10735: TextConst ENU = '"CINCUENTA "', ESP = '"CINCUENTA "';
        Text10736: TextConst ENU = '"CINCUENTA Y "', ESP = '"CINCUENTA Y "';
        Text10737: TextConst ENU = '"SESENTA "', ESP = '"SESENTA "';
        Text10738: TextConst ENU = '"SESENTA Y "', ESP = '"SESENTA Y "';
        Text10739: TextConst ENU = '"SETENTA "', ESP = '"SETENTA "';
        Text10740: TextConst ENU = '"SETENTA Y "', ESP = '"SETENTA Y "';
        Text10741: TextConst ENU = '"OCHENTA "', ESP = '"OCHENTA "';
        Text10742: TextConst ENU = '"OCHENTA Y "', ESP = '"OCHENTA Y "';
        Text10743: TextConst ENU = '"NOVENTA "', ESP = '"NOVENTA "';
        Text10744: TextConst ENU = '"NOVENTA Y "', ESP = '"NOVENTA Y "';
        Text10704: TextConst ENU = 'ONE HUNDRED', ESP = '"CIEN "';
        Text10705: TextConst ENU = 'HUNDRED', ESP = '"CIENTO "';
        Text10706: TextConst ENU = 'TWO HUNDRED', ESP = '"DOSCIENTOS "';
        Text10707: TextConst ENU = 'THREE HUNDRED', ESP = '"TRESCIENTOS "';
        Text10708: TextConst ENU = 'FOUR HUNDRED', ESP = '"CUATROCIENTOS "';
        Text10709: TextConst ENU = 'FIVE HUNDRED', ESP = '"QUINIENTOS "';
        Text10710: TextConst ENU = 'SIX HUNDRED', ESP = '"SEISCIENTOS "';
        Text10711: TextConst ENU = 'SEVEN HUNDRED', ESP = '"SETECIENTOS "';
        Text10712: TextConst ENU = 'EIGHT HUNDRED', ESP = '"OCHOCIENTOS "';
        Text10713: TextConst ENU = '"NINE HUNDRED "', ESP = '"NOVECIENTOS "';
        Text10714: TextConst ENU = 'TWO HUNDRED', ESP = '"DOSCIENTOS "';
        Text10715: TextConst ENU = 'THREE HUNDRED', ESP = '"TRESCIENTOS "';
        Text10716: TextConst ENU = '"FOUR HUNDRED "', ESP = '"CUATROCIENTOS "';
        Text10717: TextConst ENU = 'FIVE HUNDREDS', ESP = '"QUINIENTOS "';
        Text10718: TextConst ENU = 'SIX HUNDREDS', ESP = '"SEISCIENTOS "';
        Text10719: TextConst ENU = 'SEVEN HUNDREDS', ESP = '"SETECIENTOS "';
        Text10720: TextConst ENU = 'EIGHT HUNDREDS', ESP = '"OCHOCIENTOS "';
        Text10721: TextConst ENU = 'NINE HUNDREDS', ESP = '"NOVECIENTOS "';
        Text10703: TextConst ENU = 'THOUSAND', ESP = '"MIL "';
        Text10702: TextConst ENU = 'ONE MILLION', ESP = '"UN MILL�N "';
        Text10701: TextConst ENU = 'MILLONS', ESP = '"MILLONES "';

    LOCAL PROCEDURE "---------------------------------------- Pasar de n£mero a texto"();
    BEGIN
    END;

    PROCEDURE Decimal2TextTwoLines(VAR Line1: Text; VAR Line2: Text; LineLeng: Integer; No: Decimal; WithInteger: Boolean; CurrencyName: Text; CaseFormat: Option "UL","U","L");
    VAR
        txt: Text;
        i: Integer;
    BEGIN
        //Funci�n que retorna un n�mero decimal convertido en cadena, dividido en dos l�neas
        //   Line1: Primera l�nea
        //   Line2: Segunda l�nea
        //   LineLeng: M�xima longitud de las l�neas
        //   No: N�mero a convertir
        //   WithInteger: Si no tiene parte entera, si se a�ade de todas formas
        //   CurrencyName: El nombre de la divisa, siempre los importes van en divisa
        //   CaseFormat: Si se retorna Primera en may�sculas y resto min�sculas, todo en may�sculas o todo en min�sculas

        txt := '--- ' + Decimal2Text(No, 0, WithInteger, TRUE, CurrencyName, CaseFormat) + ' ---';

        IF (STRLEN(txt) <= LineLeng) THEN BEGIN
            Line1 := txt;
            Line2 := '';
        END ELSE BEGIN
            i := LineLeng + 2;
            REPEAT
                i -= 1;
            UNTIL (COPYSTR(txt, i, 1) = ' ');
            Line1 := COPYSTR(txt, 1, i - 1);
            Line2 := COPYSTR(txt, i + 1);
            IF (STRLEN(Line2) > LineLeng) THEN
                ERROR(Text002);
        END;
    END;

    PROCEDURE Decimal2Text(No: Decimal; NoDecimals: Integer; WithInteger: Boolean; IsCurrency: Boolean; CurrencyName: Text; CaseFormat: Option "UL","U","L"): Text;
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        cp: Text;
        cs: Text;
        fp: Text;
        fs: Text;
        fw: Boolean;
        fe: Boolean;
        nd: Integer;
        txt: Text;
        IntegerPart: Integer;
        DecimalPart: Integer;
        CaseFormat2: Option;
    BEGIN
        //Funci�n que retorna un n�mero decimal convertido en cadena
        //   No: N�mero a convertir
        //   NoDecimals: M�ximo n�mero de decimales, si es cero se emplean los de la divisa
        //   WithInteger: Si no tiene parte entera, si se a�ade de todas formas "CERO" delante
        //   IsCurrency: Si es importe es una divisa o un n�mero general
        //   CurrencyName: Si es en divisa su nombre
        //   CaseFormat: Si se retorna Primera en may�sculas y resto min�sculas, todo en may�sculas o todo en min�sculas
        // Retorna:
        //   [Text] Valor convertido

        JobCurrencyExchangeFunction.GetCurrencyValues(CurrencyName, cp, cs, fp, fs, fw, fe, nd);

        txt := FORMAT(No, 0, Text003);
        IF NOT EVALUATE(IntegerPart, txt) THEN
            IntegerPart := 0;

        IF (NoDecimals = 0) THEN
            NoDecimals := nd;
        txt := COPYSTR(FORMAT(No, 0, Text004), 2, NoDecimals);
        IF (STRLEN(txt) < NoDecimals) THEN
            txt := PADSTR(txt, NoDecimals, '0');   //Rellenamos con ceros por la derecha para pasar a un entero adecuado, si no 0'10 = 0'01 = 1
        IF NOT EVALUATE(DecimalPart, txt) THEN
            DecimalPart := 0;

        txt := '';


        IF (IntegerPart <> 0) OR (WithInteger) THEN
            txt := Integer2Text(IntegerPart, IsCurrency, CurrencyName, fe, FALSE, CaseFormat);

        IF (DecimalPart <> 0) THEN BEGIN
            IF (CaseFormat = CaseFormat::U) THEN
                CaseFormat2 := CaseFormat::U
            ELSE
                CaseFormat2 := CaseFormat::L;

            IF (IntegerPart <> 0) OR (WithInteger) THEN BEGIN
                txt += ' ' + SetCaseFormat(Text005, CaseFormat2) + ' ';
            END;

            IF (txt = '') THEN
                txt += Integer2Text(DecimalPart, FALSE, '', fe, IsCurrency, CaseFormat)
            ELSE
                txt += Integer2Text(DecimalPart, FALSE, '', fe, IsCurrency, CaseFormat2);

            IF (IsCurrency) THEN BEGIN
                IF (DecimalPart = 1) THEN
                    txt += ' ' + GetCurrencyName(fp, fs, TRUE, CaseFormat)
                ELSE
                    txt += ' ' + GetCurrencyName(fp, fs, FALSE, CaseFormat);

                IF (fw) THEN
                    txt += ' ' + SetCaseFormat(Text006, CaseFormat2) + ' ' + GetCurrencyName(cp, cs, TRUE, CaseFormat);
            END;
        END;

        EXIT(DELCHR(txt, '>'));
    END;

    PROCEDURE Integer2Text(No: Decimal; IsCurrency: Boolean; CurrencyName: Text; isFemale: Boolean; isDecimal: Boolean; CaseFormat: Option "UL","U","L"): Text;
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        cp: Text;
        cs: Text;
        fp: Text;
        fs: Text;
        fw: Boolean;
        fe: Boolean;
        nd: Integer;
        rem: Integer;
        txt: Text;
        Nombres: ARRAY[2] OF Text;
        i: Integer;
    BEGIN
        //Funci�n que retorna un n�mero entero convertido en cadena
        //   No: N�mero a convertir
        //   IsCurrency: Si es importe es una divisa o un n�mero general
        //   CurrencyName: Si es en divisa su nombre
        //   CaseFormat: Si se retorna Primera en may�sculas y resto min�sculas, todo en may�sculas o todo en min�sculas
        // Retorna:
        //   [Text] Valor convertido

        JobCurrencyExchangeFunction.GetCurrencyValues(CurrencyName, cp, cs, fp, fs, fw, fe, nd);

        txt := '';

        IF (No > 999999999) THEN
            ERROR(Text001, No);

        IF (No = 0) THEN
            txt := Text026
        ELSE BEGIN

            rem := No;

            HundMilion := rem DIV 100000000;
            rem := rem MOD 100000000;
            TenMilion := rem DIV 10000000;
            rem := rem MOD 10000000;
            UnitsMilion := rem DIV 1000000;
            rem := rem MOD 1000000;
            HundThousands := rem DIV 100000;
            rem := rem MOD 100000;
            TenThousands := rem DIV 10000;
            rem := rem MOD 10000;
            UnitsThousands := rem DIV 1000;
            rem := rem MOD 1000;
            Hundreds := rem DIV 100;
            rem := rem MOD 100;
            Tens := rem DIV 10;
            rem := rem MOD 10;
            Units := rem;

            txt := DELCHR(txt + TextHundMilion(HundMilion, TenMilion, UnitsMilion, TRUE), '<');
            txt := DELCHR(txt + TextTenUnitsMilion(HundMilion, TenMilion, UnitsMilion, TRUE), '<');
            txt := DELCHR(txt + TextHundThousands(HundThousands, TenThousands, UnitsThousands, FALSE), '<');
            txt := DELCHR(txt + TextTenUnitsThousands(HundThousands, TenThousands, UnitsThousands, TRUE), '<'); //*******
            txt := DELCHR(txt + TextHundreds(Hundreds, Tens, Units, TRUE), '<');
            IF (Tens <> 0) OR (Units <> 0) THEN
                txt := DELCHR(txt + TextTensUnits(Tens, Units, IsCurrency OR isDecimal, isFemale), '<');
        END;

        txt := SetCaseFormat(txt, CaseFormat);

        IF (IsCurrency) THEN
            txt += GetCurrencyName(cp, cs, (No = 1), CaseFormat);

        EXIT(DELCHR(txt, '>'));
    END;

    PROCEDURE GetCurrencyName(TP: Text; TS: Text; Singular: Boolean; CaseFormat: Option "UL","U","L"): Text;
    VAR
        txt: Text;
    BEGIN
        //Funci�n que retorna el nombre de la divisa en singular o plural
        //   CurrencyName: Si es en divisa su nombre
        //   Singular: Si es en sigunlar o plural
        //   CaseFormat: Si se retorna Primera en may�sculas y resto min�sculas, todo en may�sculas o todo en min�sculas
        // Retorna:
        //   [Text] Nombre

        IF (TP = '') THEN
            TP := TS;
        IF (TS = '') THEN
            TS := TP;

        IF (Singular) THEN
            txt := TS
        ELSE
            txt := TP;

        txt := SetCaseFormat(txt, CaseFormat);

        EXIT(txt);
    END;

    PROCEDURE SetCaseFormat(txt: Text; CaseFormat: Option "UL","U","L"): Text;
    BEGIN
        //Funci�n que retorna una cadena en el formato de may�sculas establecido
        //   txt: Texto a tratar
        //   CaseFormat: Si se retorna Primera en may�sculas y resto min�sculas, todo en may�sculas o todo en min�sculas
        // Retorna:
        //   [Text] Texto

        CASE CaseFormat OF
            CaseFormat::UL:
                txt := COPYSTR(txt, 1, 1) + LOWERCASE(COPYSTR(txt, 2));
            CaseFormat::U:
                txt := UPPERCASE(txt);
            CaseFormat::L:
                txt := LOWERCASE(txt);
        END;

        EXIT(txt);
    END;

    PROCEDURE TextHundMilion(Hundreds: Integer; Ten: Integer; Units: Integer; Last: Boolean): Text[250];
    BEGIN
        //Funci�n que retorna miles de millones en texto
        //   Hundreds: Cientos
        //   Ten: Decenas
        //   Units: Unidades
        //   Last: Si el importe es final de frase
        // Retorna:
        //   [Text] Valor convertido

        IF Hundreds <> 0 THEN
            EXIT(TextHundreds(Hundreds, Ten, Units, TRUE));
    END;

    PROCEDURE TextTenUnitsMilion(Hundreds: Integer; Ten: Integer; Units: Integer; Last: Boolean): Text[250];
    BEGIN
        //Funci�n que retorna decenas de millones en texto
        //   Hundreds: Cientos
        //   Ten: Decenas
        //   Units: Unidades
        //   Last: Si el importe es final de frase
        // Retorna:
        //   [Text] Valor convertido

        IF (Hundreds <> 0) AND (Ten = 0) AND (Units = 0) THEN
            EXIT(Text10701);
        IF (Hundreds = 0) AND (Ten = 0) AND (Units = 1) THEN
            EXIT(Text10702);
        IF (Ten <> 0) OR (Units <> 0) THEN
            EXIT(TextTensUnits(Ten, Units, Last, FALSE) + Text10701);
    END;

    PROCEDURE TextHundThousands(Hundreds: Integer; Ten: Integer; Units: Integer; Last: Boolean): Text[250];
    BEGIN
        //Funci�n que retorna cientos de miles en texto
        //   Hundreds: Cientos
        //   Ten: Decenas
        //   Units: Unidades
        //   Last: Si el importe es final de frase
        // Retorna:
        //   [Text] Valor convertido

        IF Hundreds <> 0 THEN
            EXIT(TextHundreds(Hundreds, Ten, Units, Last))
    END;

    PROCEDURE TextTenUnitsThousands(Hundreds: Integer; Ten: Integer; Units: Integer; Last: Boolean): Text[250];
    BEGIN
        //Funci�n que retorna decenas de miles en texto
        //   Hundreds: Cientos
        //   Ten: Decenas
        //   Units: Unidades
        //   Last: Si el importe es final de frase
        // Retorna:
        //   [Text] Valor convertido

        IF (Hundreds <> 0) AND (Ten = 0) AND (Units = 0) THEN
            EXIT(Text10703);
        IF (Hundreds = 0) AND (Ten = 0) AND (Units = 1) THEN
            EXIT(Text10703);
        IF (Ten <> 0) OR (Units <> 0) THEN
            EXIT(TextTensUnits(Ten, Units, Last, FALSE) + Text10703);
    END;

    PROCEDURE TextHundreds(Hundreds: Integer; Tens: Integer; Units: Integer; Last: Boolean): Text[250];
    BEGIN
        //Funci�n que retorna cientos en texto
        //   Hundreds: Cientos
        //   Ten: Decenas
        //   Units: Unidades
        //   Last: Si el importe es final de frase
        // Retorna:
        //   [Text] Valor convertido

        IF Hundreds = 0 THEN
            EXIT('');

        IF Last THEN
            CASE Hundreds OF
                1:
                    IF (Tens = 0) AND (Units = 0) THEN
                        EXIT(Text10704)
                    ELSE
                        EXIT(Text10705);
                2:
                    EXIT(Text10706);
                3:
                    EXIT(Text10707);
                4:
                    EXIT(Text10708);
                5:
                    EXIT(Text10709);
                6:
                    EXIT(Text10710);
                7:
                    EXIT(Text10711);
                8:
                    EXIT(Text10712);
                9:
                    EXIT(Text10713);
            END
        ELSE
            CASE Hundreds OF
                1:
                    IF (Tens = 0) AND (Units = 0) THEN
                        EXIT(Text10704)
                    ELSE
                        EXIT(Text10705);
                2:
                    EXIT(Text10714);
                3:
                    EXIT(Text10715);
                4:
                    EXIT(Text10716);
                5:
                    EXIT(Text10717);
                6:
                    EXIT(Text10718);
                7:
                    EXIT(Text10719);
                8:
                    EXIT(Text10720);
                9:
                    EXIT(Text10721);
            END;
    END;

    PROCEDURE TextTensUnits(Tens: Integer; Units: Integer; Last: Boolean; IsFemale: Boolean): Text[250];
    BEGIN
        //Funci�n que retorna decenas en texto
        //   Ten: Decenas
        //   Units: Unidades
        //   Last: Si el importe es final de frase
        //   IsFemale: Si el importe es masculino o femenino
        // Retorna:
        //   [Text] Valor convertido

        CASE Tens OF
            0:
                EXIT(TextUnits(Units, Last, IsFemale));
            1:
                CASE Units OF
                    0:
                        EXIT(Text10722);
                    1:
                        EXIT(Text10723);
                    2:
                        EXIT(Text10724);
                    3:
                        EXIT(Text10725);
                    4:
                        EXIT(Text10726);
                    5:
                        EXIT(Text10727);
                    ELSE
                        EXIT(Text10728 + TextUnits(Units, Last, IsFemale));
                END;
            2:
                IF Units = 0 THEN
                    EXIT(Text10729)
                ELSE
                    EXIT(Text10730 + TextUnits(Units, Last, IsFemale));
            3:
                IF Units = 0 THEN
                    EXIT(Text10731)
                ELSE
                    EXIT(Text10732 + TextUnits(Units, Last, IsFemale));
            4:
                IF Units = 0 THEN
                    EXIT(Text10733)
                ELSE
                    EXIT(Text10734 + TextUnits(Units, Last, IsFemale));
            5:
                IF Units = 0 THEN
                    EXIT(Text10735)
                ELSE
                    EXIT(Text10736 + TextUnits(Units, Last, IsFemale));
            6:
                IF Units = 0 THEN
                    EXIT(Text10737)
                ELSE
                    EXIT(Text10738 + TextUnits(Units, Last, IsFemale));
            7:
                IF Units = 0 THEN
                    EXIT(Text10739)
                ELSE
                    EXIT(Text10740 + TextUnits(Units, Last, IsFemale));
            8:
                IF Units = 0 THEN
                    EXIT(Text10741)
                ELSE
                    EXIT(Text10742 + TextUnits(Units, Last, IsFemale));
            9:
                IF Units = 0 THEN
                    EXIT(Text10743)
                ELSE
                    EXIT(Text10744 + TextUnits(Units, Last, IsFemale));
        END;
    END;

    PROCEDURE TextUnits(Units: Integer; Last: Boolean; IsFemale: Boolean): Text[250];
    BEGIN
        //Funci�n que retorna unidades en texto
        //   Units: Unidades
        //   Last: Si el importe es final de frase
        //   IsFemale: Si el importe es masculino o femenino
        // Retorna:
        //   [Text] Valor convertido

        CASE Units OF
            0:
                EXIT('');
            1:
                IF IsFemale THEN
                    EXIT(Text50000)
                ELSE IF Last THEN
                    EXIT(Text10745)
                ELSE
                    EXIT(Text10746);
            2:
                EXIT(Text10747);
            3:
                EXIT(Text10748);
            4:
                EXIT(Text10749);
            5:
                EXIT(Text10750);
            6:
                EXIT(Text10751);
            7:
                EXIT(Text10752);
            8:
                EXIT(Text10753);
            9:
                EXIT(Text10754);
        END;
    END;

    LOCAL PROCEDURE "-------------------------------------- Pasar un d¡a a texto"();
    BEGIN
    END;

    PROCEDURE DiaATexto(dia: Integer) TxtLetra: Text[80];
    BEGIN
        EXIT(Integer2Text(dia, FALSE, '', FALSE, FALSE, 2));
    END;

    LOCAL PROCEDURE "-------------------------------------- Montar una cadena con un n£mero"();
    BEGIN
    END;

    PROCEDURE Decimal2FormatText(No: Decimal; CurrencyName: Text): Text;
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        cp: Text;
        cs: Text;
        fp: Text;
        fs: Text;
        fw: Boolean;
        fe: Boolean;
        nd: Integer;
        txt: Text;
    BEGIN
        //Esta funci�n retorna un n�mero montado en una cadena de caracteres num�ricos, con separador de miles y nro de decimales seg�n divisa
        JobCurrencyExchangeFunction.GetCurrencyValues(CurrencyName, cp, cs, fp, fs, fw, fe, nd);

        //Montar los decimales
        txt := FORMAT(No, 0, Text004);
        txt := DELCHR(txt, '<', '0');
        txt := DELCHR(txt, '<', '.');
        txt := DELCHR(txt, '<', ',');
        txt := COPYSTR(txt, 1, nd);
        IF (STRLEN(txt) < nd) THEN
            txt := PADSTR(txt, nd, '0');   //Rellenamos con ceros por la derecha

        //Montar el n�mero completo
        txt := FORMAT(No, 0, Text004a) + ',' + txt;

        EXIT(txt);
    END;

    PROCEDURE Decimal2Format(No: Decimal; CurrencyName: Text; Lon: Integer; Car: Text): Text;
    VAR
        JobCurrencyExchangeFunction: Codeunit 7207332;
        cp: Text;
        cs: Text;
        fp: Text;
        fs: Text;
        fw: Boolean;
        fe: Boolean;
        nd: Integer;
        txt: Text;
    BEGIN
        //Esta funci�n retorna un n�mero montado en una cadena de caracteres num�ricos, con separador de miles y nro de decimales seg�n divisa, ajustado a una longitud
        //y relleno delante y detr�s con el caracter que se le indique
        txt := Decimal2FormatText(No, CurrencyName);

        IF (Lon <> 0) THEN BEGIN
            IF (Car = '') THEN
                Car := ' ';
            txt := PADSTR('', Lon - STRLEN(txt) - 3, Car) + txt + PADSTR(Car, 3, Car);
        END;

        EXIT(txt);
    END;

    /*BEGIN
/*{
      Funciones que retornan n�meros convertidos a su expresi�n num�rica legible
    }
END.*/
}







