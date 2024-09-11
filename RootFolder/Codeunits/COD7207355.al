Codeunit 7207355 "Guarantees"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        Txt001: TextConst ESP = 'Ya existe una garant�a provisional en estado %1';
        Txt002: TextConst ESP = 'Confirme que desea crear una garant�a provisional';
        Txt003: TextConst ESP = 'No puede crear una garant�a definitiva si no est� el proyecto aceptado';
        Txt004: TextConst ESP = 'Ya existe una garant�a defintiiva en estado %1';
        Txt005: TextConst ESP = 'Confirme que desea crear una garant�a definitiva';
        Txt006: TextConst ESP = 'No se pudo enviar el mail\Error: %1';
        Txt007: TextConst ESP = 'Solicitud de garant�a %1 para %2 %3';
        Txt008: TextConst ESP = 'El usuario <b>%1</b> ha creado la garant�a <b>%2</b>, solicitando depositar una %3 para el <b>%4 %5</b>, por un importe de <b>%6</b>, por favor atiendala.';
        Txt009: TextConst ESP = 'No ha definido el tipo de la garant�a, no puede generar';
        Txt010: TextConst ESP = 'Existen %3 l�neas en el diario %1 secci�n %2, �desea eliminarlas?';
        Txt011: TextConst ESP = 'No puede crear la garant�a, est� en estado %1';
        Txt012: TextConst ESP = 'No puede procesar una garant�a con importe provisional a cero';
        Txt013: TextConst ESP = 'No puede procesar una garant�a con importe definitivo a cero';
        Txt014: TextConst ESP = 'No puede crear una garnatia definitiva sin indicar un proyecto';
        Txt015: TextConst ESP = 'No ha definido una cuenta de gastos para el tipo de garant�a %1';
        Txt016: TextConst ESP = 'Prev. Gastos garant�a %1 %2';
        Txt021: TextConst ESP = 'No puede reclamar la devoluci�n de una ganta�a en estado %1';
        Txt022: TextConst ESP = 'No ha indicado el estudio';
        Txt023: TextConst ESP = 'No ha indicado el proyecto';
        FunctionQB: Codeunit 7207272;

    PROCEDURE SolicitudProvisional(pJob: Record 167);
    VAR
        Guarantee: Record 7207441;
        GuaranteeLines: Record 7207442;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n crea una solicitud de provisional y env�a un mail a los responsables       |
        // +-----------------------------------------------------------------------------------------+

        IF (pJob."Guarantee Provisional" = 0) THEN
            ERROR(Txt012);

        Guarantee.RESET;
        Guarantee.SETRANGE("Quote No.", pJob."No.");
        IF (Guarantee.FINDFIRST) THEN
            IF (Guarantee."Provisional Status" <> Guarantee."Provisional Status"::" ") THEN
                ERROR(Txt001, Guarantee."Provisional Status");

        IF (CONFIRM(Txt002)) THEN BEGIN
            CLEAR(Guarantee);
            Guarantee.INSERT(TRUE);

            Guarantee.VALIDATE("Quote No.", pJob."No.");
            Guarantee."Provisional Amount" := pJob."Guarantee Provisional";
            Guarantee."Provisional Status" := Guarantee."Provisional Status"::Requested;
            Guarantee."Provisional Date ofApplication" := TODAY;
            Guarantee.MODIFY(TRUE);

            GuaranteeLines.INIT;
            GuaranteeLines."No." := Guarantee."No.";
            GuaranteeLines.Date := Guarantee."Provisional Date ofApplication";
            GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::ProvSol;
            GuaranteeLines."Descripción" := 'Solicitud de garant�a provisional';
            GuaranteeLines.User := USERID;
            GuaranteeLines.Amount := pJob."Guarantee Provisional";
            GuaranteeLines.INSERT(TRUE);

            SendMail(USERID, Guarantee."No.", 'provisional', 'estudio', pJob."No.", pJob."Guarantee Provisional")

        END;
    END;

    PROCEDURE SolicitudDefinitiva(pJob: Record 167; pConfirm: Boolean);
    VAR
        Guarantee: Record 7207441;
        GuaranteeLines: Record 7207442;
        Ok: Boolean;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n crea una solicitud de definitiva y env�a un mail a los responsables        |
        // +-----------------------------------------------------------------------------------------+

        IF (pJob."Guarantee Definitive" = 0) THEN
            ERROR(Txt013);

        IF (pJob."Card Type" = pJob."Card Type"::Estudio) AND (pJob."Quote Status" <> pJob."Quote Status"::Accepted) THEN
            ERROR(Txt003);

        Guarantee.RESET;
        CASE pJob."Card Type" OF
            pJob."Card Type"::Estudio:
                Guarantee.SETRANGE("Quote No.", pJob."No.");
            pJob."Card Type"::"Proyecto operativo":
                Guarantee.SETRANGE("Job No.", pJob."No.");
        END;

        IF (Guarantee.FINDFIRST) THEN
            IF (pConfirm) AND (Guarantee."Definitive Status" <> Guarantee."Definitive Status"::" ") THEN
                ERROR(Txt004, Guarantee."Definitive Status");

        IF (pConfirm) THEN
            Ok := CONFIRM(Txt005);

        IF (NOT pConfirm) OR (Ok) THEN BEGIN
            Guarantee.RESET;
            CASE pJob."Card Type" OF
                pJob."Card Type"::Estudio:
                    Guarantee.SETRANGE("Quote No.", pJob."No.");
                pJob."Card Type"::"Proyecto operativo":
                    Guarantee.SETRANGE("Job No.", pJob."No.");
            END;
            IF (NOT Guarantee.FINDFIRST) THEN BEGIN
                CLEAR(Guarantee);
                Guarantee.INSERT(TRUE);
            END;

            CASE pJob."Card Type" OF
                pJob."Card Type"::Estudio:
                    Guarantee.VALIDATE("Quote No.", pJob."No.");
                pJob."Card Type"::"Proyecto operativo":
                    Guarantee.VALIDATE("Job No.", pJob."No.");
            END;

            Guarantee."Definitive Amount" := pJob."Guarantee Definitive";
            Guarantee."Definitive Status" := Guarantee."Definitive Status"::Requested;
            Guarantee."Definitive Date of Application" := TODAY;
            Guarantee.MODIFY(TRUE);

            GuaranteeLines.INIT;
            GuaranteeLines."No." := Guarantee."No.";
            GuaranteeLines.Date := Guarantee."Definitive Date of Application";
            GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefSol;
            GuaranteeLines."Descripción" := 'Solicitud de garant�a definitiva';
            GuaranteeLines.User := USERID;
            GuaranteeLines.Amount := pJob."Guarantee Definitive";
            GuaranteeLines.INSERT(TRUE);

            CASE pJob."Card Type" OF
                pJob."Card Type"::Estudio:
                    SendMail(USERID, Guarantee."No.", 'definitiva', 'estudio', pJob."No.", pJob."Guarantee Definitive");
                pJob."Card Type"::"Proyecto operativo":
                    SendMail(USERID, Guarantee."No.", 'definitiva', 'proyecto', pJob."No.", pJob."Guarantee Definitive");
            END;
        END;
    END;

    LOCAL PROCEDURE SendMail(pUsuario: Text; pGuarantee: Text; pType: Text; pTypeJob: Text; pJob: Text; pAmount: Decimal);
    VAR
        UserSetup: Record 91;
        Mail: Codeunit 397;
        destino: Text;
        asunto: Text;
        cuerpo: Text;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n env�a un mail a los responsables de garant�as                              |
        // +-----------------------------------------------------------------------------------------+

        destino := '';
        UserSetup.RESET;
        UserSetup.SETFILTER("User ID", '<>%1', USERID); //No envi�rmelo a mi mismo
        UserSetup.SETRANGE("Guarantees Administrator", TRUE);
        UserSetup.SETFILTER("E-Mail", '<>%1', '');
        IF UserSetup.FINDSET(FALSE) THEN
            REPEAT
                IF destino <> '' THEN
                    destino += ';';
                destino += UserSetup."E-Mail";
            UNTIL UserSetup.NEXT = 0;

        IF (destino = '') THEN
            EXIT;

        asunto := STRSUBSTNO(Txt007, pType, pTypeJob, pJob);
        cuerpo := STRSUBSTNO(Txt008, pUsuario, pGuarantee, pType, pTypeJob, pJob, pAmount);
        Mail.CreateMessage(destino, '', '', asunto, cuerpo, FALSE, TRUE);
        IF NOT Mail.Send THEN
            MESSAGE(Txt006, Mail.GetErrorDesc());
    END;

    PROCEDURE GetIdDimension(JobNo: Code[20]; Analiticalconcept: Code[20]): Integer;
    VAR
        DefaultDimension: Record 352;
        DimensionSetEntry: Record 480 TEMPORARY;
        DimMgt: Codeunit 408;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n obtiene el ID de dimensi�n de un registro de la tabla JOB, al que le a�ade |
        // | el valor del concepto anal�tico que se le pase                                          |
        // +-----------------------------------------------------------------------------------------+

        DimensionSetEntry.RESET;
        DimensionSetEntry.DELETEALL;

        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
        DefaultDimension.SETRANGE("No.", JobNo);
        DefaultDimension.SETFILTER("Dimension Value Code", '<>%1', '');
        IF (DefaultDimension.FINDSET(FALSE)) THEN
            REPEAT
                DimensionSetEntry.VALIDATE("Dimension Set ID", 0);
                DimensionSetEntry.VALIDATE("Dimension Code", DefaultDimension."Dimension Code");
                DimensionSetEntry.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                DimensionSetEntry.INSERT;
            UNTIL (DefaultDimension.NEXT = 0);


        //Dimensi�n C.A.
        IF (Analiticalconcept <> '') THEN BEGIN
            DimensionSetEntry.VALIDATE("Dimension Set ID", 0);
            DimensionSetEntry.VALIDATE("Dimension Code", FunctionQB.ReturnDimCA);
            DimensionSetEntry.VALIDATE("Dimension Value Code", Analiticalconcept);
            IF NOT DimensionSetEntry.INSERT THEN
                DimensionSetEntry.MODIFY;
        END;

        EXIT(DimMgt.GetDimensionSetID(DimensionSetEntry));
    END;

    PROCEDURE CreateLine(VAR pGuarantee: Record 7207441; pTipoAval: Option "Provisional","Definitivo"; pTipoMovimiento: Option "Deposito","Cancelacion"; pAdd: Boolean);
    VAR
        QuoBuildingSetup: Record 7207278;
        GuaranteeLines: Record 7207442;
        GuaranteeType: Record 7207443;
        GenJournalLine: Record 81;
        Job: Record 167;
        Line: Integer;
        PostingDate: Date;
        CostAmount: Decimal;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n crea las l�neas del registro y los asientos relacionados                   |
        // +-----------------------------------------------------------------------------------------+

        QuoBuildingSetup.GET();
        IF NOT GuaranteeType.GET(pGuarantee.Type) THEN
            ERROR(Txt009);
        PostingDate := TODAY;

        //Verificar errores
        CASE pTipoAval OF
            pTipoAval::Provisional:
                BEGIN
                    IF (pTipoMovimiento = pTipoMovimiento::Deposito) AND (pGuarantee."Provisional Status" > pGuarantee."Provisional Status"::Requested) THEN
                        ERROR(Txt011, pGuarantee."Provisional Status");
                    IF (pTipoMovimiento = pTipoMovimiento::Cancelacion) AND (pGuarantee."Provisional Status" <> pGuarantee."Provisional Status"::Deposited) THEN
                        ERROR(Txt011, pGuarantee."Provisional Status");
                    IF (pGuarantee."Provisional Amount" = 0) THEN
                        ERROR(Txt012);
                END;
            pTipoAval::Definitivo:
                BEGIN
                    IF (pGuarantee."Job No." = '') THEN
                        ERROR(Txt014);
                    IF (pTipoMovimiento = pTipoMovimiento::Deposito) AND (pGuarantee."Definitive Status" > pGuarantee."Definitive Status"::Requested) THEN
                        ERROR(Txt011, pGuarantee."Definitive Status");
                    IF (pTipoMovimiento = pTipoMovimiento::Cancelacion) AND (pGuarantee."Definitive Status" <> pGuarantee."Definitive Status"::Deposited) THEN
                        ERROR(Txt011, pGuarantee."Definitive Status");
                    IF (pGuarantee."Definitive Amount" = 0) THEN
                        ERROR(Txt012);
                END;
        END;

        //Ajusto el estado del aval
        CASE pTipoAval OF
            pTipoAval::Provisional:
                IF (pTipoMovimiento = pTipoMovimiento::Deposito) THEN BEGIN
                    pGuarantee."Provisional Status" := pGuarantee."Provisional Status"::Deposited;
                    pGuarantee."Provisional Date of Issue" := PostingDate;
                END ELSE BEGIN
                    pGuarantee."Provisional Status" := pGuarantee."Provisional Status"::Canceled;
                    pGuarantee."Provisional Date of return" := PostingDate;
                END;
            pTipoAval::Definitivo:
                IF (pTipoMovimiento = pTipoMovimiento::Deposito) THEN BEGIN
                    pGuarantee."Definitive Status" := pGuarantee."Definitive Status"::Deposited;
                    pGuarantee."Definitive Date of Issue" := PostingDate;
                END ELSE BEGIN
                    pGuarantee."Definitive Status" := pGuarantee."Definitive Status"::Canceled;
                    pGuarantee."Definitive Date of return" := PostingDate;
                END;
        END;
        pGuarantee.MODIFY(TRUE);

        //Creo la l�nea del aval donde se refleja la creaci�n o devoluci�n de la garant�a
        GuaranteeLines.INIT;
        GuaranteeLines."No." := pGuarantee."No.";
        GuaranteeLines.INSERT(TRUE);

        CASE pTipoAval OF
            pTipoAval::Provisional:
                BEGIN
                    Job.GET(pGuarantee."Quote No.");
                    IF (pTipoMovimiento = pTipoMovimiento::Deposito) THEN BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::ProvReg;
                        GuaranteeLines."Descripción" := 'Deposito garantia provisional proyecto ' + Job."No.";
                        GuaranteeLines.Amount := pGuarantee."Provisional Amount";
                        CostAmount := pGuarantee."Provisional Emisions costs";
                    END ELSE BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::ProvDev;
                        GuaranteeLines."Descripción" := 'Cancelaci�n garantia provisional proyecto ' + Job."No.";
                        GuaranteeLines.Amount := -pGuarantee."Provisional Amount";
                        CostAmount := pGuarantee."Provisional final cost";
                    END;
                END;
            pTipoAval::Definitivo:
                BEGIN
                    Job.GET(pGuarantee."Job No.");
                    IF (pTipoMovimiento = pTipoMovimiento::Deposito) THEN BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefReg;
                        GuaranteeLines."Descripción" := 'Deposito garantia definitiva proyecto ' + Job."No.";
                        GuaranteeLines.Amount := pGuarantee."Definitive Amount";
                        CostAmount := pGuarantee."Definitive Emisions costs";
                    END ELSE BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefDev;
                        GuaranteeLines."Descripción" := 'Cancelaci�n garantia definitiva proyecto ' + Job."No.";
                        GuaranteeLines.Amount := -pGuarantee."Definitive Amount";
                        CostAmount := pGuarantee."Definitive final cost";
                    END;
                END;
        END;

        CASE GuaranteeType.Type OF
            GuaranteeType.Type::Cash:
                GuaranteeLines."Financial Amount" := GuaranteeLines.Amount;
            GuaranteeType.Type::GuaranteeWith:
                GuaranteeLines."Financial Amount" := ROUND(GuaranteeLines.Amount * GuaranteeType."Retention %" / 100, 0.01);
            ELSE
                GuaranteeLines."Financial Amount" := 0;
        END;

        GuaranteeLines.Date := PostingDate;
        GuaranteeLines.User := USERID;
        IF (GuaranteeLines."Financial Amount" <> 0) THEN
            GuaranteeLines."Document No." := pGuarantee."No." + '-' + FORMAT(GuaranteeLines."Line No.");
        GuaranteeLines.MODIFY;

        //Creo las unidades de obra necesarias
        CreatePiecework(Job, GuaranteeType);

        //Miro si hay l�neas en el diario, si solo hay una asumo que es la creada autom�ticamente al registrar el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        IF (NOT pAdd) THEN BEGIN
            IF (GenJournalLine.COUNT > 1) THEN
                IF (NOT CONFIRM(Txt010, TRUE, QuoBuildingSetup."Jobs Book", QuoBuildingSetup."Jobs Batch Book", GenJournalLine.COUNT)) THEN
                    ERROR('');
            GenJournalLine.DELETEALL;
        END;

        //Crear las l�neas del diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        IF (GenJournalLine.FINDLAST) THEN
            Line := GenJournalLine."Line No."
        ELSE
            Line := 0;

        //L�nea del dep�sito
        IF (GuaranteeLines."Financial Amount" <> 0) THEN BEGIN
            //Creo la l�nea del banco
            Line += 10000;
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Jobs Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Jobs Batch Book";
            GenJournalLine."Line No." := Line;
            GenJournalLine."Posting Date" := GuaranteeLines.Date;
            GenJournalLine."Document No." := GuaranteeLines."Document No.";

            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"Bank Account");
            GenJournalLine.VALIDATE("Account No.", GuaranteeType."Bank Account No.");
            //GenJournalLine.VALIDATE(Description, GuaranteeLines.Descripci�n); PGM
            GenJournalLine.VALIDATE(Description, COPYSTR(GuaranteeLines."Descripción", 1, 50)); //PGM
            GenJournalLine.VALIDATE(Amount, -GuaranteeLines."Financial Amount");
            GenJournalLine.VALIDATE("Dimension Set ID", GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
            GenJournalLine.INSERT;


            //Contrapartida
            Line += 10000;
            GenJournalLine."Line No." := Line;
            CASE GuaranteeType."Destination Type" OF
                GuaranteeType."Destination Type"::"G/L Account":
                    GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GuaranteeType."Destination Type"::"Bank Account":
                    GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"Bank Account");
            END;
            GenJournalLine.VALIDATE("Account No.", GuaranteeType."Destination No.");
            //GenJournalLine.VALIDATE(Description, GuaranteeLines.Descripci�n); PGM
            GenJournalLine.VALIDATE(Description, COPYSTR(GuaranteeLines."Descripción", 1, 50));  //PGM
            GenJournalLine.VALIDATE(Amount, GuaranteeLines."Financial Amount");
            IF (GuaranteeType."Destination Type" = GuaranteeType."Destination Type"::"G/L Account") THEN BEGIN
                GenJournalLine.VALIDATE("Job No.", Job."No.");
                GenJournalLine.VALIDATE("Piecework Code", QuoBuildingSetup."Guarantee Piecework Unit");
            END;
            GenJournalLine.VALIDATE("Dimension Set ID", GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
            GenJournalLine.INSERT;
        END;

        //Si es la devoluci�n de la definitiva, registrar el importe incautado si lo hay
        IF (pTipoAval = pTipoAval::Definitivo) AND (pTipoMovimiento = pTipoMovimiento::Cancelacion) AND (pGuarantee."Definitive Seized amount" <> 0) THEN BEGIN

            //Creo la l�nea donde se refleja
            GuaranteeLines.INIT;
            GuaranteeLines."No." := pGuarantee."No.";
            GuaranteeLines.INSERT(TRUE);

            GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefReg;
            GuaranteeLines."Descripción" := 'Parte incautada gar. definitiva ' + Job."No.";
            GuaranteeLines.Amount := pGuarantee."Definitive Seized amount";
            GuaranteeLines."Financial Amount" := pGuarantee."Definitive Seized amount";
            GuaranteeLines.Date := PostingDate;
            GuaranteeLines.User := USERID;
            GuaranteeLines."Document No." := pGuarantee."No." + '-' + FORMAT(GuaranteeLines."Line No.");
            GuaranteeLines.MODIFY;

            //La incautaci�n va a p�rdidas
            Line += 10000;
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Jobs Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Jobs Batch Book";
            GenJournalLine."Line No." := Line;
            GenJournalLine."Posting Date" := GuaranteeLines.Date;
            GenJournalLine."Document No." := GuaranteeLines."Document No.";
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
            GenJournalLine.VALIDATE("Account No.", GuaranteeType."Account for Seizure");
            GenJournalLine.VALIDATE(Description, GuaranteeLines."Descripción");
            GenJournalLine.VALIDATE(Amount, pGuarantee."Definitive Seized amount");
            GenJournalLine.VALIDATE("Job No.", Job."No.");
            GenJournalLine.VALIDATE("Piecework Code", QuoBuildingSetup."Guarantee Piecework Unit");
            GenJournalLine.VALIDATE("Dimension Set ID", GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
            GenJournalLine.INSERT;

            //Contra el banco
            Line += 10000;
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Jobs Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Jobs Batch Book";
            GenJournalLine."Line No." := Line;
            GenJournalLine."Posting Date" := GuaranteeLines.Date;
            GenJournalLine."Document No." := GuaranteeLines."Document No.";
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"Bank Account");
            GenJournalLine.VALIDATE("Account No.", GuaranteeType."Bank Account No.");
            GenJournalLine.VALIDATE(Description, GuaranteeLines."Descripción");
            GenJournalLine.VALIDATE(Amount, -pGuarantee."Definitive Seized amount");
            GenJournalLine.VALIDATE("Dimension Set ID", GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
            GenJournalLine.INSERT;
        END;

        //Si hay previsi�n de gastos
        IF (QuoBuildingSetup."Guarantee Piecework Unit Prov." <> '') AND (pTipoMovimiento = pTipoMovimiento::Deposito) THEN BEGIN
            GuaranteeLines.INIT;
            GuaranteeLines."No." := pGuarantee."No.";
            GuaranteeLines.INSERT(TRUE);

            CASE pTipoAval OF
                pTipoAval::Provisional:
                    BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::ProvGastos;
                        GuaranteeLines."Descripción" := STRSUBSTNO(Txt016, 'provisional', Job."No.");
                        GuaranteeLines.Amount := pGuarantee."Provisional Expenses Forecast";
                    END;
                pTipoAval::Definitivo:
                    BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefGastos;
                        GuaranteeLines."Descripción" := STRSUBSTNO(Txt016, 'definitiva', Job."No.");
                        GuaranteeLines.Amount := pGuarantee."Definitive Expenses Forecast";
                    END;
            END;
            GuaranteeLines."Financial Amount" := 0;
            GuaranteeLines.Date := PostingDate;
            GuaranteeLines.User := USERID;
            GuaranteeLines."Document No." := '';
            GuaranteeLines.MODIFY;

            AddForecast(Job, GuaranteeType, 2, GuaranteeLines.Amount);
        END;

        //Gastos de apertura o cancelaci�n
        IF (CostAmount <> 0) THEN BEGIN
            //Creo la l�nea donde se refleja
            GuaranteeLines.INIT;
            GuaranteeLines."No." := pGuarantee."No.";
            GuaranteeLines.INSERT(TRUE);

            CASE pTipoAval OF
                pTipoAval::Provisional:
                    BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::ProvGastos;
                        IF (pTipoMovimiento = pTipoMovimiento::Deposito) THEN
                            GuaranteeLines."Descripción" := 'Gastos apertura garant�a provisional ' + Job."No."
                        ELSE
                            GuaranteeLines."Descripción" := 'Gastos cancelaci�n garant�a provisional ' + Job."No.";
                        ;
                    END;
                pTipoAval::Definitivo:
                    BEGIN
                        GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefGastos;
                        IF (pTipoMovimiento = pTipoMovimiento::Deposito) THEN
                            GuaranteeLines."Descripción" := 'Gastos apertura garant�a definitiva ' + Job."No."
                        ELSE
                            GuaranteeLines."Descripción" := 'Gastos cancelaci�n garant�a definitiva ' + Job."No.";
                        ;
                    END;
            END;
            GuaranteeLines."Financial Amount" := CostAmount;
            GuaranteeLines.Date := PostingDate;
            GuaranteeLines.User := USERID;
            GuaranteeLines."Document No." := pGuarantee."No." + '-' + FORMAT(GuaranteeLines."Line No.");
            GuaranteeLines.MODIFY;

            //Descuento de la previsi�n de gastos
            IF (QuoBuildingSetup."Guarantee Piecework Unit Prov." <> '') THEN
                AddForecast(Job, GuaranteeType, pTipoMovimiento, -CostAmount);


            //Creo la l�nea del banco
            Line += 10000;
            GenJournalLine.INIT;
            GenJournalLine."Journal Template Name" := QuoBuildingSetup."Jobs Book";
            GenJournalLine."Journal Batch Name" := QuoBuildingSetup."Jobs Batch Book";
            GenJournalLine."Line No." := Line;
            GenJournalLine."Posting Date" := GuaranteeLines.Date;
            GenJournalLine."Document No." := GuaranteeLines."Document No.";

            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"Bank Account");
            GenJournalLine.VALIDATE("Account No.", GuaranteeType."Bank Account No.");
            GenJournalLine.VALIDATE(Description, GuaranteeLines."Descripción");
            GenJournalLine.VALIDATE(Amount, -GuaranteeLines."Financial Amount");
            GenJournalLine.VALIDATE("Dimension Set ID", GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
            GenJournalLine.INSERT;

            //Contrapartida por el gasto
            Line += 10000;
            GenJournalLine."Line No." := Line;
            GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
            IF (GuaranteeType."Account for Initial Expenses" = '') THEN
                GenJournalLine.VALIDATE("Account No.", GuaranteeType."Account for Expenses")
            ELSE
                GenJournalLine.VALIDATE("Account No.", GuaranteeType."Account for Initial Expenses");
            GenJournalLine.VALIDATE(Description, GuaranteeLines."Descripción");
            GenJournalLine.VALIDATE(Amount, GuaranteeLines."Financial Amount");
            GenJournalLine.VALIDATE("Job No.", Job."No.");
            GenJournalLine.VALIDATE("Piecework Code", QuoBuildingSetup."Guarantee Piecework Unit");
            GenJournalLine.VALIDATE("Dimension Set ID", GetIdDimension(Job."No.", QuoBuildingSetup."Guarantee Analitical Concept"));
            GenJournalLine.INSERT;
        END;

        //Registrar el diario
        IF (NOT pAdd) AND (Line <> 0) THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);
    END;

    PROCEDURE SolicitarDevolucion(pGuarantee: Record 7207441; pTipo: Option "Provisional","Definitivo");
    VAR
        QuoBuildingSetup: Record 7207278;
        GuaranteeLines: Record 7207442;
        Job: Record 167;
        PostingDate: Date;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n crea una l�nea con la solicitud de devoluci�n                              |
        // +-----------------------------------------------------------------------------------------+

        QuoBuildingSetup.GET();
        PostingDate := TODAY;

        CASE pTipo OF
            pTipo::Provisional:
                BEGIN
                    IF (pGuarantee."Provisional Status" <> pGuarantee."Provisional Status"::Deposited) THEN
                        ERROR(Txt021, pGuarantee."Provisional Status");
                    IF (pGuarantee."Quote No." = '') THEN
                        ERROR(Txt022);
                END;
            pTipo::Definitivo:
                BEGIN
                    IF (pGuarantee."Definitive Status" IN [pGuarantee."Definitive Status"::Deposited, pGuarantee."Definitive Status"::Canceled]) THEN
                        ERROR(Txt021, pGuarantee."Definitive Status");
                    IF (pGuarantee."Job No." = '') THEN
                        ERROR(Txt023);
                END;
        END;

        //Ajusto la fecha
        IF pTipo = pTipo::Provisional THEN
            pGuarantee."Provisional Date of request" := PostingDate
        ELSE
            pGuarantee."Definitive Date of request" := PostingDate;
        pGuarantee.MODIFY(TRUE);

        //Creo la l�nea donde se refleja la reclamaci�n de la garant�a
        GuaranteeLines.INIT;
        GuaranteeLines."No." := pGuarantee."No.";
        GuaranteeLines.INSERT(TRUE);

        IF (pGuarantee."Job No." = '') THEN
            Job.GET(pGuarantee."Quote No.")
        ELSE
            Job.GET(pGuarantee."Job No.");

        CASE pTipo OF
            pTipo::Provisional:
                BEGIN
                    GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::ProvDev;
                    GuaranteeLines."Descripción" := 'Reclamaci�n de la garantia provisional ' + Job."No.";
                END;
            pTipo::Definitivo:
                BEGIN
                    GuaranteeLines."Line Type" := GuaranteeLines."Line Type"::DefDev;
                    GuaranteeLines."Descripción" := 'Reclamaci�n de la garantia definitiva ' + Job."No.";
                END;
        END;

        GuaranteeLines.Date := PostingDate;
        GuaranteeLines.User := USERID;
        GuaranteeLines.MODIFY;
    END;

    PROCEDURE ToDefinitive(VAR pGuarantee: Record 7207441);
    VAR
        QuoBuildingSetup: Record 7207278;
        GenJournalLine: Record 81;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n pasa una garant�a provisional a definitiva                                 |
        // +-----------------------------------------------------------------------------------------+

        //Verificar errores
        IF (pGuarantee."Provisional Status" <> pGuarantee."Provisional Status"::Deposited) THEN
            ERROR(Txt011, pGuarantee."Provisional Status");
        IF (pGuarantee."Provisional Amount" = 0) THEN
            ERROR(Txt012);
        IF (pGuarantee."Definitive Amount" = 0) THEN
            ERROR(Txt013);
        IF (pGuarantee."Quote No." = '') THEN
            ERROR(Txt022);
        IF (pGuarantee."Job No." = '') THEN
            ERROR(Txt023);

        QuoBuildingSetup.GET();

        //Miro si hay l�neas en el diario, si solo hay una asumo que es la creada autom�ticamente al registrar el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        IF (GenJournalLine.COUNT > 1) THEN
            IF (NOT CONFIRM(Txt010, TRUE, QuoBuildingSetup."Jobs Book", QuoBuildingSetup."Jobs Batch Book", GenJournalLine.COUNT)) THEN
                ERROR('');
        GenJournalLine.DELETEALL;

        //Cerramos la garant�a provisional y creamos la definitiva
        CreateLine(pGuarantee, 0, 1, TRUE);
        pGuarantee."Provisional Status" := pGuarantee."Provisional Status"::Definitive;
        pGuarantee."Definitive Status" := pGuarantee."Definitive Status"::Requested;
        pGuarantee.MODIFY(TRUE);
        CreateLine(pGuarantee, 1, 0, TRUE);

        //Registrar el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QuoBuildingSetup."Jobs Book");
        GenJournalLine.SETRANGE("Journal Batch Name", QuoBuildingSetup."Jobs Batch Book");
        IF GenJournalLine.FINDFIRST THEN //Q8089
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);
    END;

    PROCEDURE CreatePiecework(pJob: Record 167; pGuaranteeType: Record 7207443);
    VAR
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
        DataCostByPiecework: Record 7207387;
        ExpectedTimeUnitData: Record 7207388;
        nLine: Integer;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n crea las unidades de obra asociadas a las garant�as en el proyecto         |
        // | si no existen                                                                           |
        // +-----------------------------------------------------------------------------------------+

        QuoBuildingSetup.GET();

        //La cuenta y la U.O. donde imputar los gastos es obligatoria
        IF (pGuaranteeType."Account for Expenses" = '') THEN
            ERROR(Txt015, pGuaranteeType.Code);

        QuoBuildingSetup.TESTFIELD("Guarantee Piecework Unit");
        IF (NOT DataPieceworkForProduction.GET(pJob."No.", QuoBuildingSetup."Guarantee Piecework Unit")) THEN BEGIN
            DataPieceworkForProduction.INIT;
            DataPieceworkForProduction."Job No." := pJob."No.";
            DataPieceworkForProduction."Piecework Code" := QuoBuildingSetup."Guarantee Piecework Unit";
            DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
            DataPieceworkForProduction."Type Unit Cost" := DataPieceworkForProduction."Type Unit Cost"::Internal;
            DataPieceworkForProduction.Description := 'Registro de gastos de las Garant�as';
            DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
            DataPieceworkForProduction."Subtype Cost" := DataPieceworkForProduction."Subtype Cost"::"Current Expenses";
            DataPieceworkForProduction."Production Unit" := TRUE;
            DataPieceworkForProduction."Customer Certification Unit" := FALSE;
            DataPieceworkForProduction.VALIDATE("Measure Pending Budget", 1);
            DataPieceworkForProduction.INSERT;

            AddPieceworkCnt(pJob."No.", QuoBuildingSetup."Guarantee Piecework Unit");
        END;

        //La U.O. de la previsi�n de gastos es opcional
        IF (QuoBuildingSetup."Guarantee Piecework Unit Prov." <> '') THEN BEGIN
            IF (NOT DataPieceworkForProduction.GET(pJob."No.", QuoBuildingSetup."Guarantee Piecework Unit Prov.")) THEN BEGIN
                DataPieceworkForProduction.INIT;
                DataPieceworkForProduction."Job No." := pJob."No.";
                DataPieceworkForProduction."Piecework Code" := QuoBuildingSetup."Guarantee Piecework Unit Prov.";
                DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
                DataPieceworkForProduction."Type Unit Cost" := DataPieceworkForProduction."Type Unit Cost"::Internal;
                DataPieceworkForProduction.Description := 'Previsi�n de gastos de Garant�as';
                DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
                DataPieceworkForProduction."Subtype Cost" := DataPieceworkForProduction."Subtype Cost"::"Current Expenses";
                DataPieceworkForProduction."Production Unit" := TRUE;
                DataPieceworkForProduction."Customer Certification Unit" := FALSE;
                DataPieceworkForProduction.VALIDATE("Measure Pending Budget", 1);
                DataPieceworkForProduction.INSERT;

                AddPieceworkCnt(pJob."No.", QuoBuildingSetup."Guarantee Piecework Unit Prov.");
            END;
        END;
    END;

    PROCEDURE AddPieceworkCnt(pJobNo: Code[20]; pPiecework: Code[20]);
    VAR
        ExpectedTimeUnitData: Record 7207388;
        nLine: Integer;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n a�ade a la unidad de obra asociadas a las garant�as el registro de la      |
        // | tabla Expected Time Unit Data, para que tenga una cantidad.                             |
        // +-----------------------------------------------------------------------------------------+

        ExpectedTimeUnitData.RESET;
        ExpectedTimeUnitData.SETRANGE("Job No.", pJobNo);
        ExpectedTimeUnitData.SETRANGE("Piecework Code", pPiecework);
        ExpectedTimeUnitData.SETRANGE(Performed, FALSE);
        IF (NOT ExpectedTimeUnitData.FINDFIRST) THEN BEGIN
            ExpectedTimeUnitData.RESET;
            IF ExpectedTimeUnitData.FINDLAST THEN
                nLine := ExpectedTimeUnitData."Entry No." + 1
            ELSE
                nLine := 1;

            ExpectedTimeUnitData.INIT;
            ExpectedTimeUnitData."Job No." := pJobNo;
            ExpectedTimeUnitData."Piecework Code" := pPiecework;
            ExpectedTimeUnitData.Performed := FALSE;
            ExpectedTimeUnitData."Entry No." := nLine;
            ExpectedTimeUnitData.INSERT;
        END;

        ExpectedTimeUnitData."Expected Measured Amount" := 1;
        ExpectedTimeUnitData.MODIFY;
    END;

    PROCEDURE AddForecast(pJob: Record 167; pGuaranteeType: Record 7207443; pTipoMovimiento: Option "Deposito","Cancelaci¢n","Previsi¢n","Registro"; pAmount: Decimal);
    VAR
        QuoBuildingSetup: Record 7207278;
        DataCostByPiecework: Record 7207387;
        AccountNo: Code[20];
        tAmount: Decimal;
    BEGIN
        // +-----------------------------------------------------------------------------------------+
        // | Esta funci�n suma o resta un importe a la previsi�n de gastos de las garant�as, pero    |
        // | no la deja nunca en negativo                                                            |
        // +-----------------------------------------------------------------------------------------+

        QuoBuildingSetup.GET();
        IF (QuoBuildingSetup."Guarantee Piecework Unit Prov." <> '') THEN BEGIN
            //Calculo el importe ya imputado
            DataCostByPiecework.RESET;
            DataCostByPiecework.SETRANGE("Job No.", pJob."No.");
            DataCostByPiecework.SETRANGE("Piecework Code", QuoBuildingSetup."Guarantee Piecework Unit Prov.");
            DataCostByPiecework.SETRANGE("Cod. Budget", QuoBuildingSetup."Initial Budget Code");
            DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Account);
            DataCostByPiecework.SETRANGE("No.", AccountNo);
            IF (DataCostByPiecework.FINDSET(FALSE)) THEN
                REPEAT
                    tAmount += DataCostByPiecework."Direc Unit Cost";
                UNTIL DataCostByPiecework.NEXT = 0;

            IF (tAmount + pAmount) < 0 THEN
                pAmount := -tAmount;

            IF (pAmount <> 0) THEN BEGIN
                //Busco la cuenta
                CASE pTipoMovimiento OF
                    pTipoMovimiento::Deposito:
                        AccountNo := pGuaranteeType."Account for Initial Expenses";
                    pTipoMovimiento::"Cancelaci¢n":
                        AccountNo := pGuaranteeType."Account for Final Expenses";
                    pTipoMovimiento::"Previsi¢n":
                        AccountNo := pGuaranteeType."Account for Forecast Expenses";
                    pTipoMovimiento::Registro:
                        AccountNo := pGuaranteeType."Account for Expenses";
                END;
                IF (AccountNo = '') THEN
                    AccountNo := pGuaranteeType."Account for Expenses";

                //Creo o a�ado a la l�nea
                IF (QuoBuildingSetup."Guarantee Piecework Unit Prov." <> '') THEN BEGIN
                    //-Q18970.1
                    DataCostByPiecework.SETRANGE("Job No.", pJob."No.");
                    DataCostByPiecework.SETRANGE("Piecework Code", QuoBuildingSetup."Guarantee Piecework Unit Prov.");
                    DataCostByPiecework.SETRANGE("Cod. Budget", QuoBuildingSetup."Initial Budget Code");
                    DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type"::Account);
                    DataCostByPiecework.SETRANGE("No.", AccountNo);
                    IF DataCostByPiecework.FINDSET THEN BEGIN
                        REPEAT
                            //IF (DataCostByPiecework.GET(pJob."No.", QuoBuildingSetup."Guarantee Piecework Unit Prov.", QuoBuildingSetup."Initial Budget Code", DataCostByPiecework."Cost Type"::Account, AccountNo)) THEN BEGIN
                            DataCostByPiecework.VALIDATE("Direc Unit Cost", DataCostByPiecework."Direc Unit Cost" + pAmount);
                            DataCostByPiecework.MODIFY;
                        UNTIL DataCostByPiecework.NEXT = 0;
                    END ELSE BEGIN
                        DataCostByPiecework.INIT;
                        DataCostByPiecework."Job No." := pJob."No.";
                        DataCostByPiecework."Piecework Code" := QuoBuildingSetup."Guarantee Piecework Unit Prov.";
                        DataCostByPiecework."Cod. Budget" := QuoBuildingSetup."Initial Budget Code";
                        DataCostByPiecework."Cost Type" := DataCostByPiecework."Cost Type"::Account;
                        DataCostByPiecework."No." := AccountNo;
                        DataCostByPiecework.Description := FORMAT(pTipoMovimiento) + ' de gastos de Garant�as';
                        DataCostByPiecework.VALIDATE(Quantity, 1);
                        DataCostByPiecework.VALIDATE("Direc Unit Cost", DataCostByPiecework."Direc Unit Cost" + pAmount);
                        DataCostByPiecework.INSERT;
                    END;
                END;
            END;
        END;
    END;

    /*BEGIN
/*{
      AML 12/6/23  -  Adaptaciones nueva clave para Data cost by piecework.
    }
END.*/
}







