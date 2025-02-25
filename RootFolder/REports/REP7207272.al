report 7207272 "Allocation Term Calend Gen."
{


    CaptionML = ENU = 'Allocation Term Calend Gen.', ESP = 'Gen. Calendario periodos imput';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Type Calendar"; "Type Calendar")
        {

            DataItemTableView = SORTING("Code")
                                 ORDER(Ascending);


            RequestFilterFields = "Code";
            trigger OnPreDataItem();
            BEGIN
                ContPeriod := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                ProcessDate := V_InitialDate;
                Initial := TRUE;  //Inserto el periodo inicial

                REPEAT
                    IF (Initial) OR (DATE2DWY(ProcessDate, 1) = 1) THEN //Si comenzamos o cambiamos de semana, generar el periodo
                        InsertPeriod;

                    AllocationTermDays.INIT;
                    AllocationTermDays.Calendar := "Type Calendar".Code;
                    AllocationTermDays."Allocation Term" := AllocationTerm.Code;
                    AllocationTermDays.Day := ProcessDate;
                    AllocationTermDays.Workday := Workingday;
                    IF DATE2DWY(ProcessDate, 1) > 5 THEN
                        AllocationTermDays.Holiday := TRUE
                    ELSE
                        AllocationTermDays.Holiday := FALSE;
                    AllocationTermDays."Long Weekend" := FALSE;
                    AllocationTermDays."Hours to work" := NumberHours;
                    IF NOT AllocationTermDays.INSERT THEN
                        AllocationTermDays.MODIFY;

                    Initial := (DATE2DMY(ProcessDate, 1) = 31) AND (DATE2DMY(ProcessDate, 2) = 12); // Si cambia el a¤o, creamos el periodo otra vez
                    ProcessDate := ProcessDate + 1;
                UNTIL ProcessDate > V_FinalDate
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group313")
                {

                    CaptionML = ENU = 'Options';
                    field("Fecha inicial"; "V_InitialDate")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            NamePeriod := FORMAT(DATE2DMY(V_InitialDate, 3)) + '-S';
                        END;


                    }
                    field("Fecha Final"; "V_FinalDate")
                    {

                    }
                    field("Long. periodo dias"; "V_LongPeriod")
                    {

                        CaptionML = ENU = 'Long. per¡odo d¡as';
                    }
                    field("Tipo de jornada"; "Workingday")
                    {

                        // OptionCaptionML=ENU='Winter,Summer',ESP='Invierno,Verano';
                    }
                    field("N§ horas al dia"; "NumberHours")
                    {

                        CaptionML = ENU = 'N§ horas al d¡a';
                    }
                    field("Tipo de numeraci¢n"; "Numeration")
                    {

                        //  OptionCaptionML=ENU='Manual de los periodos,Por semanas naturales',ESP='Manual de los per¡odos,Por semanas naturales';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       AllocationTerm@7001101 :
        AllocationTerm: Record 7207297;
        //       Hourstoperform@7001102 :
        Hourstoperform: Record 7207298;
        //       AllocationTermDays@7001103 :
        AllocationTermDays: Record 7207295;
        //       V_InitialDate@7001104 :
        V_InitialDate: Date;
        //       V_FinalDate@7001105 :
        V_FinalDate: Date;
        //       V_LongPeriod@7001106 :
        V_LongPeriod: Integer;
        //       Workingday@7001107 :
        Workingday: Option "Winter","Summer";
        //       NumberHours@7001108 :
        NumberHours: Decimal;
        //       NamePeriod@7001109 :
        NamePeriod: Text[30];
        //       Numeration@7001110 :
        Numeration: Option "Manual","For weeks";
        //       TextPeriod@7001111 :
        TextPeriod: Text[30];
        //       ContPeriod@7001112 :
        ContPeriod: Integer;
        //       Start@7001113 :
        Start: Boolean;
        //       ProcessDate@7001115 :
        ProcessDate: Date;
        //       Period@7001116 :
        Period: Code[10];
        //       i@7001117 :
        i: Integer;
        //       Text001@7001119 :
        Text001: TextConst ENU = 'You must specify a calendar type', ESP = 'Debe especificar un calendario tipo';
        //       Text002@7001120 :
        Text002: TextConst ENU = 'The final date cannït be less than the initial date', ESP = 'La fecha no puede ser menor que la fecha inicial';
        //       Text003@7001121 :
        Text003: TextConst ENU = 'The length of the period cannït be less than 1', ESP = 'La longitud del periodo no puede ser menor que 1';
        //       Text004@7001122 :
        Text004: TextConst ENU = 'The specified number of hours must be between 1 and 24 hours.', ESP = 'El n£mero de horas especificado debe estar comprendido entre 1 y 24 horas.';
        //       Initial@1100286000 :
        Initial: Boolean;



    trigger OnInitReport();
    begin
        // Inicializaci¢n de variables
        V_InitialDate := WORKDATE;
        V_LongPeriod := 7;
        V_FinalDate := V_InitialDate + 6;
        NumberHours := 8;
        NamePeriod := FORMAT(DATE2DMY(V_InitialDate, 3)) + '-S';
        Numeration := Numeration::"For weeks";

        if Numeration = Numeration::Manual then
            TextPeriod := NamePeriod + '1'
        else
            TextPeriod := NamePeriod + FORMAT(DATE2DWY(V_InitialDate, 2));
    end;

    trigger OnPreReport();
    begin
        if "Type Calendar".GETFILTERS = '' then
            ERROR(Text001);

        if V_InitialDate < V_InitialDate then
            ERROR(Text002);

        if V_LongPeriod < 1 then
            ERROR(Text003);

        if (NumberHours < 1) or (NumberHours > 24) then
            ERROR(Text004);
    end;



    LOCAL procedure InsertPeriod()
    begin
        if Numeration = Numeration::Manual then begin
            ContPeriod := ContPeriod + 1;
            Period := FORMAT(ContPeriod);
            Period := FORMAT(DATE2DMY(ProcessDate, 3)) + '-' + AjustarTexto(ContPeriod, 3);
        end else begin
            ContPeriod := DATE2DWY(ProcessDate, 2);
            if (ContPeriod > 52) and (DATE2DMY(ProcessDate, 1) = 1) then  //Si es la primera semana del a¤o no completa, ser  la cero
                ContPeriod := 0;
            Period := FORMAT(DATE2DMY(ProcessDate, 3)) + '-S' + AjustarTexto(ContPeriod, 2);
        end;

        //Periodos de imputaci¢n
        AllocationTerm.INIT;
        AllocationTerm.Code := Period;
        AllocationTerm.VALIDATE("Initial Date", AjustarLunes(ProcessDate));
        AllocationTerm.VALIDATE("Final Date", AjustarDomingo(ProcessDate));
        AllocationTerm."Period Type" := Workingday;
        if Numeration = Numeration::"For weeks" then
            AllocationTerm.Description := 'Semana ' + FORMAT(DATE2DWY(ProcessDate, 2)) + ' ,' + FORMAT(ProcessDate, 0, '<Month Text>') + ' de ' + FORMAT(DATE2DMY(ProcessDate, 3))
        else
            AllocationTerm.Description := 'Per¡odo ' + FORMAT(AllocationTerm."Initial Date") + ' al ' + FORMAT(AllocationTerm."Final Date");

        if not AllocationTerm.INSERT then
            AllocationTerm.MODIFY;

        //Relaci¢n calendario/periodo
        Hourstoperform.INIT;
        Hourstoperform.Calendar := "Type Calendar".Code;
        Hourstoperform.Period := AllocationTerm.Code;
        if not Hourstoperform.INSERT then
            Hourstoperform.MODIFY;
    end;

    //     LOCAL procedure AjustarLunes (pDate@1100286000 :
    LOCAL procedure AjustarLunes(pDate: Date): Date;
    begin
        if (DATE2DWY(pDate, 1) = 1) then
            exit(pDate);

        repeat
            if (DATE2DMY(pDate, 1) = 1) and (DATE2DMY(pDate, 2) = 1) then   //Si es el 1 de enero no hay que seguir
                exit(pDate);
            ;
            pDate := pDate - 1;
        until (DATE2DWY(pDate, 1) = 1);
        exit(pDate);
    end;

    //     LOCAL procedure AjustarDomingo (pDate@1100286000 :
    LOCAL procedure AjustarDomingo(pDate: Date): Date;
    begin
        if (DATE2DWY(pDate, 1) = 7) then
            exit(pDate);
        ;

        repeat
            if (DATE2DMY(pDate, 1) = 31) and (DATE2DMY(pDate, 2) = 12) then   //Si es el 31 de diciembre no hay que seguir
                exit(pDate);
            ;
            pDate := pDate + 1;
        until (DATE2DWY(pDate, 1) = 7);
        exit(pDate);
    end;

    //     LOCAL procedure AjustarTexto (pNro@1100286000 : Integer;pLon@1100286001 :
    LOCAL procedure AjustarTexto(pNro: Integer; pLon: Integer): Text;
    var
        //       Txt@1100286002 :
        Txt: Text;
    begin
        Txt := FORMAT(pNro);
        exit(PADSTR('', pLon - STRLEN(Txt), '0') + Txt);
    end;

    /*begin
    end.
  */

}



