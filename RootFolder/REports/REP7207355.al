report 7207355 "Distri. Propor. Budget Cost"
{


    CaptionML = ENU = '"Distri. Propor. Budget Cost "', ESP = 'Repartir propor. ppto costes';
    ProcessingOnly = true;

    dataset
    {

        DataItem("DataPiecewForProd"; "Data Piecework For Production")
        {

            DataItemTableView = SORTING("Job No.", "Piecework Code");

            ;
            trigger OnPreDataItem();
            BEGIN
                CheckDates;

                IF FORMAT(opcRegularLongDate) = '' THEN
                    ERROR(Text003);

                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                ExpectedTimeUnitData.SETCURRENTKEY("Job No.", "Piecework Code", "Budget Code");

                //Obtengo el presupuesto para el que calculamos
                FilterBudget := DataPiecewForProd.GETFILTER("Budget Filter");

                //JAV 07/10/21: - QB 1.09.22 Opci¢n para pasarlo a Todas las unidades
                IF (opcUnits = opcUnits::Todas) THEN BEGIN
                    DataPiecewForProd.RESET;
                    DataPiecewForProd.SETRANGE("Job No.", JobNo);
                    //-16181 DGG 19/01/22
                    Job.GET(JobNo);
                    IF (Job."Card Type" = Job."Card Type"::"Proyecto operativo") THEN
                        DataPiecewForProd.SETRANGE("Budget Filter", FilterBudget);
                    //+16181 DGG 19/01/22
                END;

                DataPiecewForProd.SETRANGE("Account Type", DataPiecewForProd."Account Type"::Unit);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                //No para proyectos reestimados
                Job.GET("Job No.");
                //--JMMA No bloqueamos los cambios en reestimaciones
                //IF Job."Latest Reestimation Code" <> '' THEN
                //  ERROR(Text004);
                //++JMMA
                //Poner fechas solo para los de detalle
                IF (DataPiecewForProd."Account Type" = DataPiecewForProd."Account Type"::Unit) THEN BEGIN
                    //Poner las fechas si no tiene
                    IF (NOT opcUseDates) OR (DataPiecewForProd."Date init" = 0D) THEN
                        DataPiecewForProd.VALIDATE("Date init", opcInitialDate);
                    IF (NOT opcUseDates) OR (DataPiecewForProd."Date end" = 0D) THEN
                        DataPiecewForProd.VALIDATE("Date end", opcFinalDate);

                    //Calcular n£mero de periodos, siempre desde la £ltima reestimaci¢n
                    DateBegin := DataPiecewForProd."Date init";
                    ExpectedTimeUnitData.RESET;
                    ExpectedTimeUnitData.SETRANGE("Job No.", DataPiecewForProd."Job No.");
                    ExpectedTimeUnitData.SETRANGE("Piecework Code", DataPiecewForProd."Piecework Code");
                    ExpectedTimeUnitData.SETRANGE("Budget Code", FilterBudget);
                    ExpectedTimeUnitData.SETRANGE(Performed, TRUE);
                    IF (ExpectedTimeUnitData.FINDSET) THEN
                        REPEAT
                            IF (ExpectedTimeUnitData."Expected Date" > DateBegin) THEN
                                DateBegin := CALCDATE('+1d', ExpectedTimeUnitData."Expected Date");
                        UNTIL (ExpectedTimeUnitData.NEXT = 0);

                    NumberRegular := 0;
                    IF (DateBegin <> 0D) AND (DataPiecewForProd."Date end" <> 0D) AND (DateBegin <= DataPiecewForProd."Date end") THEN BEGIN
                        NumberRegular := calcRegular(DateBegin, DataPiecewForProd."Date end", opcRegularLongDate);

                        //Si hay fechas hago el rec lculo
                        IF NumberRegular > 0 THEN
                            IF (FilterBudget = Text005) OR (FilterBudget = '') THEN BEGIN
                                DataPiecewForProd.SETRANGE("Budget Filter", '');
                                FilterBudget := '';
                            END;
                        IF DataPiecewForProd."Account Type" = DataPiecewForProd."Account Type"::Unit THEN
                            DataPiecewForProd.CALCFIELDS("Budget Measure", "Measure Pending Budget");

                        ExpectedTimeUnitData.RESET;
                        ExpectedTimeUnitData.SETRANGE("Job No.", DataPiecewForProd."Job No.");
                        ExpectedTimeUnitData.SETRANGE("Piecework Code", DataPiecewForProd."Piecework Code");
                        ExpectedTimeUnitData.SETRANGE("Budget Code", FilterBudget);
                        ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
                        ExpectedTimeUnitData.DELETEALL;

                        ExpectedTimeUnitData.RESET;
                        IF ExpectedTimeUnitData.FINDLAST THEN
                            LastEntry := ExpectedTimeUnitData."Entry No."
                        ELSE
                            LastEntry := 0;

                        AmountToDistribute := DataPiecewForProd."Measure Pending Budget";
                        Accumulated := 0;
                        LastRegister := 0;
                        Amount := ROUND(AmountToDistribute / NumberRegular, 0.000001);  //Para no calcularlo cada vez
                        FOR i := 1 TO NumberRegular DO BEGIN
                            CLEAR(ExpectedTimeUnitData);
                            LastEntry := LastEntry + 1;
                            ExpectedTimeUnitData."Entry No." := LastEntry;
                            ExpectedTimeUnitData."Job No." := DataPiecewForProd."Job No.";
                            ExpectedTimeUnitData."Expected Date" := DateBegin;
                            ExpectedTimeUnitData."Expected Measured Amount" := Amount;
                            IF (FilterBudget <> '') AND (FilterBudget <> Text005) THEN
                                ExpectedTimeUnitData."Budget Code" := FilterBudget;
                            ExpectedTimeUnitData."Piecework Code" := DataPiecewForProd."Piecework Code";
                            ExpectedTimeUnitData."Unit Type" := DataPiecewForProd.Type;
                            ExpectedTimeUnitData."Incluided In Dispatch" := FALSE;
                            ExpectedTimeUnitData."Doc. Dispatch No." := '';
                            ExpectedTimeUnitData.Description := DataPiecewForProd.Description;
                            ExpectedTimeUnitData."Cost Database Code" := DataPiecewForProd."Code Cost Database";
                            ExpectedTimeUnitData."Unique Code" := DataPiecewForProd."Unique Code";
                            IF ExpectedTimeUnitData."Expected Measured Amount" <> 0 THEN BEGIN
                                ExpectedTimeUnitData.INSERT;
                                LastRegister := ExpectedTimeUnitData."Entry No.";
                            END;
                            Accumulated += ExpectedTimeUnitData."Expected Measured Amount";

                            DateBegin := CALCDATE(opcRegularLongDate, DateBegin);
                        END;

                        // Redondear el £ltimo importe por los decimales
                        IF (LastRegister <> 0) AND (Accumulated <> AmountToDistribute) THEN BEGIN
                            ExpectedTimeUnitData.GET(LastRegister);
                            ExpectedTimeUnitData."Expected Measured Amount" += AmountToDistribute - Accumulated;
                            ExpectedTimeUnitData.MODIFY;
                        END;

                        //Marcar como Distribuido
                        Distributed := TRUE;
                        MODIFY(TRUE);

                    END;
                END;
            END;

            trigger OnPostDataItem();
            BEGIN
                MESSAGE('Reparto finalizado');
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group613")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    group("group614")
                    {

                        CaptionML = ENU = 'For those who have a date', ESP = 'Unidades';
                        field("opcUnits"; "opcUnits")
                        {

                            CaptionML = ESP = 'Unidades a calcular';
                        }

                    }
                    group("group616")
                    {

                        CaptionML = ENU = 'For those who have a date', ESP = 'Para las U.O. que tengan fecha';
                        field("opcUseDates"; "opcUseDates")
                        {

                            CaptionML = ESP = 'Usar las fechas de la UO';
                        }

                    }
                    group("group618")
                    {

                        CaptionML = ENU = 'For those who do not have a date', ESP = 'Para las U.O. que no tengan fecha';
                        field("opcInitialDate"; "opcInitialDate")
                        {

                            CaptionML = ENU = 'Initial Date', ESP = 'Fecha inicial';

                            ; trigger OnValidate()
                            BEGIN
                                //JAV 03/08/20: - Control de la fecha con la de incio del proyecto
                                CheckDates;
                            END;


                        }
                        field("opcFinalDate"; "opcFinalDate")
                        {

                            CaptionML = ENU = 'Last Date', ESP = 'Fecha final';

                            ; trigger OnValidate()
                            BEGIN
                                //JAV 03/08/20: - Control de la fecha con la de fin del proyecto
                                CheckDates;
                            END;


                        }

                    }
                    group("group621")
                    {

                        CaptionML = ENU = 'Period', ESP = 'Periodo';
                        field("opcRegularLongDate"; "opcRegularLongDate")
                        {

                            CaptionML = ENU = 'Length of The Period', ESP = 'Longitud del periodo';
                            Enabled = false

    ;
                        }

                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            opcInitialDate := JobInitialDate;
            opcFinalDate := JobFinalDate;
        END;


    }
    labels
    {
    }

    var
        //       Text001@7001102 :
        Text001: TextConst ENU = 'Must indicate start date and last date of cost sharing.', ESP = 'Debe indicar fecha inicial y fecha final de reparto de costes';
        //       Text002@7001103 :
        Text002: TextConst ENU = 'Final date must be greater than the starting date', ESP = 'La fecha final debe ser mayor que la fecha inicial';
        //       Text003@7001104 :
        Text003: TextConst ENU = 'Must indicate length of casting period', ESP = 'Debe indicar longitud del periodo de reparto';
        //       Text004@7001111 :
        Text004: TextConst ENU = 'This functionality can not be used for job already reestimation', ESP = 'No se puede emplear esta funcionalidad para proyectos ya reestimados';
        //       Text005@7001113 :
        Text005: TextConst ENU = ''''';ESP=''''';
        //       Text006@7001114 :
        Text006: TextConst ESP = 'No tiene fecha';
        //       Currency@1100286017 :
        Currency: Record 4;
        //       ExpectedTimeUnitData@1100286016 :
        ExpectedTimeUnitData: Record 7207388;
        //       DataPieceworkForProductionMayor@1100286003 :
        DataPieceworkForProductionMayor: Record 7207386;
        //       DataPieceworkForProductionUnidad@1100286002 :
        DataPieceworkForProductionUnidad: Record 7207386;
        //       Job@1100286012 :
        Job: Record 167;
        //       NumberRegular@1100286015 :
        NumberRegular: Integer;
        //       DateBegin@1100286014 :
        DateBegin: Date;
        //       FilterBudget@1100286011 :
        FilterBudget: Code[20];
        //       AmountToDistribute@1100286010 :
        AmountToDistribute: Decimal;
        //       LastEntry@1100286009 :
        LastEntry: Integer;
        //       Accumulated@1100286008 :
        Accumulated: Decimal;
        //       i@1100286006 :
        i: Integer;
        //       aux1@1100286005 :
        aux1: Text;
        //       aux2@1100286004 :
        aux2: Text;
        //       texto@1100286001 :
        texto: Text;
        //       LastRegister@1100286000 :
        LastRegister: Integer;
        //       Options@1100286020 :
        Options: TextConst ENU = 'For Period,For Days', ESP = 'Por Periodo,Por d¡as';
        //       Err01@1100286021 :
        Err01: TextConst ESP = 'La fehca de inicio no puede ser anterior a la de inicio del proyecto (%1)';
        //       Err02@1100286022 :
        Err02: TextConst ESP = 'La fehca de fin no puede ser posterior a la de fin del proyecto (%1)';
        //       JobInitialDate@1100286024 :
        JobInitialDate: Date;
        //       JobFinalDate@1100286023 :
        JobFinalDate: Date;
        //       JobNo@1100286027 :
        JobNo: Code[20];
        //       Amount@1100286029 :
        Amount: Decimal;
        //       "---------------------------- Opciones"@1100286007 :
        "---------------------------- Opciones": Integer;
        //       opcUseDates@1100286025 :
        opcUseDates: Boolean;
        //       opcInitialDate@1100286019 :
        opcInitialDate: Date;
        //       opcFinalDate@1100286018 :
        opcFinalDate: Date;
        //       opcRegularLongDate@1100286013 :
        opcRegularLongDate: DateFormula;
        //       opcUnits@1100286026 :
        opcUnits: Option "Seleccionadas","Todas";



    trigger OnInitReport();
    begin
        opcUseDates := TRUE;
        EVALUATE(opcRegularLongDate, '1M');
    end;



    LOCAL procedure CheckDates()
    begin
        //Ver rango
        if opcInitialDate > opcFinalDate then
            ERROR(Text002);

        //JAV 03/08/20: - Control de la fecha con la de incio del proyecto
        if (opcInitialDate < JobInitialDate) then
            ERROR(Err01, JobInitialDate);

        //JAV 03/08/20: - Control de la fecha con la de fin del proyecto
        if (opcFinalDate > JobFinalDate) then
            ERROR(Err02, JobFinalDate);
    end;

    //     LOCAL procedure calcRegular (IniDate@7001100 : Date;EndDate@7001101 : Date;Periode@7001103 :
    LOCAL procedure calcRegular(IniDate: Date; EndDate: Date; Periode: DateFormula): Integer;
    var
        //       number@7001102 :
        number: Integer;
    begin
        number := 1;
        repeat
            IniDate := CALCDATE(Periode, IniDate);
            if IniDate <= EndDate then
                number += 1;
        until IniDate >= EndDate;

        exit(number);
    end;

    //     procedure setJob (pJobNo@1100286000 :
    procedure setJob(pJobNo: Code[20])
    begin
        JobNo := pJobNo;
        Job.GET(JobNo);
        JobInitialDate := Job."Starting Date";
        JobFinalDate := Job."Ending Date";
    end;

    /*begin
    //{
//      JAV 17/12/2018 - Trabajar tambi‚n con las fechas indicadas en la ficha
//      16181 DGG 19/01/22 Correcci¢n en la seleccion la opcion "Todas", para que filtre tambien por el presupuesto.
//    }
    end.
  */

}



