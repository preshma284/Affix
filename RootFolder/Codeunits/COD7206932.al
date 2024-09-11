Codeunit 7206932 "QB Expenses Activation"
{


    trigger OnRun()
    BEGIN
    END;

    PROCEDURE actCreate(Rec: Record 7206995);
    VAR
        QBActivableExpensesSetup: Record 7206997;
        MyDate: Date;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Esta funci¢n crear  los datos en la tabla de activaciones, a¤ade una nuevo periodo, sus proyectos y datos
        //-----------------------------------------------------------------------------------------------------------------------------------------
        Rec.RESET;
        IF (Rec.FINDLAST) THEN BEGIN
            Rec."Period End Date" := CALCDATE('+1D', Rec."Period End Date");
            Rec."Period End Date" := CALCDATE('PM', Rec."Period End Date");
        END ELSE BEGIN
            QBActivableExpensesSetup.GET;
            IF (QBActivableExpensesSetup."Activable First Date" = 0D) THEN
                Rec."Period End Date" := CALCDATE('PM', TODAY)
            ELSE
                Rec."Period End Date" := CALCDATE('PM', QBActivableExpensesSetup."Activable First Date")
        END;

        MyDate := Rec."Period End Date";
        CLEAR(Rec);

        Rec.VALIDATE("Period End Date", MyDate);
        Rec.Index := 0;
        Rec.INSERT(TRUE);

        actCalculate(Rec, TRUE);
    END;

    LOCAL PROCEDURE actUpdate(Rec: Record 7206995);
    VAR
        QBExpensesActivation: Record 7206995;
        QBExpensesActivation2: Record 7206995;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        TAuxJobsStatus: Record 7207440;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Esta funci¢n a¤ade todos los proyectos que le falten en la tabla de activaciones, con sus datos
        //-----------------------------------------------------------------------------------------------------------------------------------------
        Job.RESET;
        Job.SETRANGE("QB Activable", Job."QB Activable"::activatable);             //JAV 10/11/22: - QB 1.12.00 Cambio de boolean a option
                                                                                   //Job.SETFILTER("QB Activable Date", '=%1|<=%2',0D, Rec."Period Ini Date");  //JAV 10/11/22: - QB 1.12.00 Solo a patir de la fecha indicada en el propio proyecto
        IF (Job.FINDSET(FALSE)) THEN
            REPEAT
                IF (Job."QB Activable Date" = 0D) OR (Job."QB Activable Date" <= Rec."Period Ini Date") THEN BEGIN  //JAV 10/11/22: - QB 1.12.00 Solo a patir de la fecha indicada en el propio proyecto
                    QBExpensesActivation := Rec;
                    QBExpensesActivation."Job Code" := Job."No.";
                    QBExpensesActivation.Index := 1;
                    QBExpensesActivation."Job Status Type" := Job."Card Type";
                    QBExpensesActivation."Job Status Code" := Job."Internal Status";
                    IF QBExpensesActivation.INSERT(TRUE) THEN;
                END;
            UNTIL (Job.NEXT = 0);

        //A¤adir todas las partidas que le falten
        QBExpensesActivation.RESET;
        QBExpensesActivation.SETRANGE(Period, Rec.Period);
        IF (QBExpensesActivation.FINDSET) THEN
            REPEAT
                DataPieceworkForProduction.RESET;
                DataPieceworkForProduction.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                DataPieceworkForProduction.SETRANGE("QPR Activable", TRUE);
                IF (DataPieceworkForProduction.FINDSET) THEN
                    REPEAT
                        QBExpensesActivation2 := QBExpensesActivation;
                        QBExpensesActivation2.Piecework := DataPieceworkForProduction."Piecework Code";
                        QBExpensesActivation2.Index := 2;
                        QBExpensesActivation2."Job Status Type" := QBExpensesActivation."Job Status Type";
                        QBExpensesActivation2."Job Status Code" := QBExpensesActivation."Job Status Code";
                        IF QBExpensesActivation2.INSERT(TRUE) THEN;
                    UNTIL (DataPieceworkForProduction.NEXT = 0);
            UNTIL (QBExpensesActivation.NEXT = 0);

        QBExpensesActivation.RESET; //Quita filtros al finalizar
    END;

    LOCAL PROCEDURE actDeleteBlank(Rec: Record 7206995);
    VAR
        QBExpensesActivation: Record 7206995;
        QBExpensesActivation2: Record 7206995;
        Job: Record 167;
        DataPieceworkForProduction: Record 7207386;
        TAuxJobsStatus: Record 7207440;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 14/11/22: - QB 1.12.00 Esta funci¢n borra todos los registros que no tengan datos en el periodo
        //-----------------------------------------------------------------------------------------------------------------------------------------

        //Borrar partidas a cero
        QBExpensesActivation.RESET;
        QBExpensesActivation.SETRANGE(Period, Rec.Period);
        QBExpensesActivation.SETFILTER(Piecework, '<>%1', '');  //Solo eliminar partidas
        IF (QBExpensesActivation.FINDSET) THEN
            REPEAT
                QBExpensesActivation.CALCFIELDS("Amount G6", "Amount G7");
                IF (QBExpensesActivation."Amount G6" = 0) AND (QBExpensesActivation."Amount G7" = 0) AND
                   (QBExpensesActivation."Activation Management" = 0) AND (QBExpensesActivation."Activation Financial" = 0) AND
                   (QBExpensesActivation."Activation Managemen to Finan." = 0) THEN
                    QBExpensesActivation.DELETE;
            UNTIL (QBExpensesActivation.NEXT = 0);
    END;

    PROCEDURE actCalculate(Rec: Record 7206995; pDelete: Boolean);
    VAR
        QBExpensesActivation: Record 7206995;
        QBActivableExpensesSetup: Record 7206997;
        GLEntry: Record 17;
        Job: Record 167;
        FromDate: Date;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Calcular datos de cada una de las partidas en el periodo. Solo hay que marcar los movimientos contables, el c lculo se hace sumando
        //-----------------------------------------------------------------------------------------------------------------------------------------
        //Por si acaso actualizo los datos a calcular
        actUpdate(Rec);

        IF NOT QBActivableExpensesSetup.GET() THEN
            QBActivableExpensesSetup."Activable First Date" := 0D;

        QBExpensesActivation.RESET;
        QBExpensesActivation.SETRANGE(Period, Rec.Period);
        QBExpensesActivation.SETFILTER(Piecework, '<>%1', ''); //Solo las que tengan partida, si no la tienen son proyectos o periodo
        IF (QBExpensesActivation.FINDSET(TRUE)) THEN
            REPEAT
                //JAV 11/11/22: - QB 1.12.00 Calcular primera fecha de activaci¢n
                IF NOT Job.GET(QBExpensesActivation."Job Code") THEN
                    Job."QB Activable Date" := 0D;
                IF (Job."QB Activable Date" <> 0D) THEN
                    FromDate := Job."QB Activable Date"
                ELSE
                    FromDate := QBActivableExpensesSetup."Activable First Date";

                //Marcar los movimientos contables que vamos a tratar
                GLEntry.RESET;
                GLEntry.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                GLEntry.SETRANGE("QB Piecework Code", QBExpensesActivation.Piecework);
                GLEntry.SETFILTER("QB Activation Code", '=%1', '');
                GLEntry.SETRANGE("Posting Date", FromDate, QBExpensesActivation."Period End Date");
                GLEntry.MODIFYALL("QB Activation Code", Rec.Period);
            UNTIL (QBExpensesActivation.NEXT = 0);

        //Eliminar registros sin datos
        IF (pDelete) THEN
            actDeleteBlank(Rec);
    END;

    PROCEDURE actPost(Rec: Record 7206995);
    VAR
        QBActivableExpensesSetup: Record 7206997;
        QBExpensesActivation: Record 7206995;
        QBExpensesActivationPartida: Record 7206995;
        GenJournalLine: Record 81;
        GLEntry: Record 17;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Realiza el registro contable de la activaci¢n
        //-----------------------------------------------------------------------------------------------------------------------------------------
        QBActivableExpensesSetup.GET();

        //Preparar el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
        GenJournalLine.DELETEALL;

        //A¤adir las l¡neas al diario
        actCalculate(Rec, FALSE);          //Necesito tener todas las partidas para poder gestionarlo bien, calculo sin borrar las en blanco
        actPostPeriod(Rec);                //Activaci¢n general del mes
        actPostFinancial(Rec);             //Pasar de gesti¢n a financiero

        //Registrar el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
        GenJournalLine.FINDSET;
        IF (GenJournalLine.ISEMPTY) THEN
            MESSAGE('Nada que registrar')
        ELSE
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);

        //Eliminamos registros en blanco que ya no necesitamos tener
        actDeleteBlank(Rec);

        //Marcar que se han registrado las l¡neas
        QBExpensesActivation.RESET;
        QBExpensesActivation.SETRANGE(Period, Rec.Period);
        QBExpensesActivation.MODIFYALL(Status, QBExpensesActivation.Status::Posted);

        //Subir los importes a la cabecera
        QBExpensesActivation.RESET;
        QBExpensesActivation.SETRANGE(Period, Rec.Period);
        QBExpensesActivation.SETFILTER(Piecework, '=%1', ''); //Solo las que no sean de partida, si no la tienen son proyectos o periodo
        IF (QBExpensesActivation.FINDSET(TRUE)) THEN
            REPEAT

            UNTIL (QBExpensesActivation.NEXT = 0);

        COMMIT;
    END;

    LOCAL PROCEDURE actPostPeriod(Rec: Record 7206995);
    VAR
        QBExpensesActivation: Record 7206995;
        QBExpensesActivationJob: Record 7206995;
        QBExpensesActivation2: Record 7206995;
        QBActivableExpensesSetup: Record 7206997;
        GenJournalLine: Record 81;
        GeneralPostingSetup: Record 252;
        GLEntry: Record 17;
        TAuxJobsStatus: Record 7207440;
        TAuxJobsStatusAnt: Record 7207440;
        DataPieceworkForProduction: Record 7207386;
        GenJnlPostBatch: Codeunit 13;
        LineNo: Integer;
        CreateNew: Boolean;
        BalAccountNo: Code[20];
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Realiza el registro contable de la activaci¢n de las unidades del periodo
        //-----------------------------------------------------------------------------------------------------------------------------------------
        QBActivableExpensesSetup.GET();

        //Buscar la £ltima l¡nea en el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
        IF (GenJournalLine.FINDLAST) THEN
            LineNo := GenJournalLine."Line No."
        ELSE
            LineNo := 0;


        QBExpensesActivation.RESET;
        QBExpensesActivation.SETRANGE(Period, Rec.Period);
        QBExpensesActivation.SETFILTER(Piecework, '<>%1', ''); //Solo las que tengan partida, si no la tienen son proyectos o periodo
        IF (QBExpensesActivation.FINDSET(TRUE)) THEN
            REPEAT
                //Buscar la partida presupuestaria
                DataPieceworkForProduction.GET(QBExpensesActivation."Job Code", QBExpensesActivation.Piecework);

                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("QB Activation Code", "Job No.", "QB Piecework Code", "G/L Account No.");
                GLEntry.SETRANGE("QB Activation Code", QBExpensesActivation.Period);
                GLEntry.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                GLEntry.SETRANGE("QB Piecework Code", QBExpensesActivation.Piecework);
                IF (GLEntry.FINDSET(FALSE)) THEN
                    REPEAT
                        //Obtener el estado del proyecto para las cuentas y sumar importes
                        actGetAccounts(QBExpensesActivation, TAuxJobsStatus);
                        CASE TAuxJobsStatus.Activation OF
                            TAuxJobsStatus.Activation::Management:
                                QBExpensesActivation."Activation Management" += GLEntry.Amount;
                            TAuxJobsStatus.Activation::Financial:
                                QBExpensesActivation."Activation Financial" += GLEntry.Amount;
                        END;
                        QBExpensesActivation.MODIFY(FALSE);

                        //Partida a cancelar
                        CreateNew := TRUE;
                        IF (NOT QBActivableExpensesSetup."Activable Detailed") THEN BEGIN
                            GenJournalLine.RESET;
                            GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
                            GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
                            GenJournalLine.SETRANGE("Account No.", TAuxJobsStatus."Activation Account");
                            GenJournalLine.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                            GenJournalLine.SETRANGE("Piecework Code", QBExpensesActivation.Piecework);
                            GenJournalLine.SETRANGE("Dimension Set ID", GLEntry."Dimension Set ID");   //JAV 14/11/22: - QB 1.12.00 A¤adir el manejo de las dimensiones
                            IF (GenJournalLine.FINDFIRST) THEN BEGIN
                                GenJournalLine.VALIDATE(Amount, GenJournalLine.Amount + GLEntry.Amount);
                                GenJournalLine.MODIFY;
                                CreateNew := FALSE;
                            END;
                        END;

                        IF (CreateNew) THEN BEGIN
                            LineNo += 1;
                            GenJournalLine.INIT;
                            GenJournalLine."Journal Template Name" := QBActivableExpensesSetup."Journal Template";
                            GenJournalLine."Journal Batch Name" := QBActivableExpensesSetup."Journal Batch";
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account No." := TAuxJobsStatus."Activation Account";
                            GenJournalLine."Posting Date" := QBExpensesActivation."Period End Date";
                            GenJournalLine.VALIDATE(Amount, GLEntry.Amount);
                            GenJournalLine.Description := COPYSTR('Activaci¢n ' + GLEntry.Description, 1, MAXSTRLEN(GenJournalLine.Description));  //JAV 11/11/22 Ajustar longitud
                            GenJournalLine."Document No." := QBExpensesActivation."Document No.";
                            GenJournalLine."Job No." := QBExpensesActivation."Job Code";
                            GenJournalLine.VALIDATE("Piecework Code", QBExpensesActivation.Piecework);
                            GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                            GenJournalLine."Gen. Bus. Posting Group" := '';
                            GenJournalLine."Gen. Prod. Posting Group" := '';
                            GenJournalLine."QB Activation Mov." := TRUE;
                            GenJournalLine."QB Activation Code" := QBExpensesActivation.Period;
                            GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GLEntry."Global Dimension 1 Code");  //JAV 14/11/22: - QB 1.12.00 A¤adir el manejo de las dimensiones
                            GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GLEntry."Global Dimension 2 Code");
                            GenJournalLine.VALIDATE("Dimension Set ID", GLEntry."Dimension Set ID");
                            GenJournalLine.INSERT;
                        END;

                        //Contrapartida. Se usar  la de gesti¢n a no ser que el proyecto est‚ en estado financiero y la partida sea financiera
                        IF (TAuxJobsStatus.Activation = TAuxJobsStatus.Activation::Financial) AND (DataPieceworkForProduction."QPR Financial Unit") THEN
                            BalAccountNo := TAuxJobsStatus."Activation Account BalFin"
                        ELSE
                            BalAccountNo := TAuxJobsStatus."Activation Account BalGes";

                        CreateNew := TRUE;
                        IF (NOT QBActivableExpensesSetup."Activable Detailed") THEN BEGIN
                            GenJournalLine.RESET;
                            GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
                            GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
                            GenJournalLine.SETRANGE("Account No.", BalAccountNo);
                            GenJournalLine.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                            GenJournalLine.SETRANGE("Piecework Code", QBExpensesActivation.Piecework);
                            IF (GenJournalLine.FINDFIRST) THEN BEGIN
                                GenJournalLine.Description := COPYSTR('Activaci¢n ' + QBExpensesActivation.Period, 1, MAXSTRLEN(GenJournalLine.Description));  //JAV 11/11/22 Ajustar longitud
                                GenJournalLine.VALIDATE(Amount, GenJournalLine.Amount - GLEntry.Amount);
                                GenJournalLine.MODIFY;
                                CreateNew := FALSE;
                            END;
                        END;

                        IF (CreateNew) THEN BEGIN
                            LineNo += 1;
                            GenJournalLine."Line No." := LineNo;
                            GenJournalLine."Account No." := BalAccountNo;
                            GenJournalLine.VALIDATE(Amount, -GLEntry.Amount);
                            GenJournalLine.INSERT;
                        END;
                    UNTIL (GLEntry.NEXT = 0);
            UNTIL (QBExpensesActivation.NEXT = 0);
    END;

    LOCAL PROCEDURE actPostFinancial(Rec: Record 7206995);
    VAR
        QBExpensesActivation: Record 7206995;
        QBExpensesActivationJob: Record 7206995;
        QBExpensesActivation2: Record 7206995;
        QBActivableExpensesSetup: Record 7206997;
        GenJournalLine: Record 81;
        GeneralPostingSetup: Record 252;
        GLEntry: Record 17;
        TAuxJobsStatus: Record 7207440;
        TAuxJobsStatusAnt: Record 7207440;
        DataPieceworkForProduction: Record 7207386;
        LineNo: Integer;
        CreateNew: Boolean;
        BalAccountNo: Code[20];
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Realiza el registro contable de la activaci¢n. Pasar de gesti¢n a finaciero
        //-----------------------------------------------------------------------------------------------------------------------------------------
        QBActivableExpensesSetup.GET();

        //Buscar la £ltima l¡nea en el diario
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
        GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
        IF (GenJournalLine.FINDLAST) THEN
            LineNo := GenJournalLine."Line No."
        ELSE
            LineNo := 0;


        QBExpensesActivation.RESET;
        QBExpensesActivation.SETRANGE(Period, Rec.Period);
        QBExpensesActivation.SETFILTER(Piecework, '<>%1', ''); //Solo las que tengan partida, si no la tienen son proyectos o periodo
        IF (QBExpensesActivation.FINDSET(TRUE)) THEN
            REPEAT
                //Buscar la partida presupuestaria
                DataPieceworkForProduction.GET(QBExpensesActivation."Job Code", QBExpensesActivation.Piecework);

                //Obtener el estado el proyecto y del anterior
                actGetAccountsAnt(QBExpensesActivation, TAuxJobsStatus, TAuxJobsStatusAnt);

                //Si ha pasado de comercializaci¢n a gesti¢n en el mes, hay que hacer el asiento para traspasar el saldo de una cuenta a la otra si la partida es financiera
                IF (TAuxJobsStatus.Activation <> TAuxJobsStatusAnt.Activation) AND (DataPieceworkForProduction."QPR Financial Unit") THEN BEGIN
                    GLEntry.RESET;
                    GLEntry.SETCURRENTKEY("G/L Account No.");
                    GLEntry.SETRANGE("G/L Account No.", TAuxJobsStatusAnt."Activation Account");   //Movimiento de la cuenta de activaci¢n del estado anterior
                    GLEntry.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                    GLEntry.SETRANGE("QB Piecework Code", QBExpensesActivation.Piecework);
                    GLEntry.SETFILTER("QB Activation Code", '<>%1', '');              //Tiene que estar activado
                    GLEntry.SETFILTER("QB Activation Financial Code", '=%1', '');    //Pero que no est‚n activados como financieros
                    IF (GLEntry.FINDSET(TRUE)) THEN
                        REPEAT
                            //Marcar que se ha activado como financiero
                            GLEntry."QB Activation Financial Code" := QBExpensesActivation.Period;
                            GLEntry.MODIFY(FALSE);

                            //Guardar importe
                            QBExpensesActivation."Activation Managemen to Finan." += GLEntry.Amount;
                            QBExpensesActivation.MODIFY(FALSE);

                            //Partida a cancelar
                            CreateNew := TRUE;
                            IF (NOT QBActivableExpensesSetup."Activable Detailed") THEN BEGIN
                                GenJournalLine.RESET;
                                GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
                                GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
                                GenJournalLine.SETRANGE("Account No.", TAuxJobsStatusAnt."Activation Account");
                                GenJournalLine.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                                GenJournalLine.SETRANGE("Piecework Code", QBExpensesActivation.Piecework);
                                GenJournalLine.SETRANGE("Dimension Set ID", GLEntry."Dimension Set ID");   //JAV 14/11/22: - QB 1.12.00 A¤adir el manejo de las dimensiones
                                IF (GenJournalLine.FINDFIRST) THEN BEGIN
                                    GenJournalLine.VALIDATE(Amount, GenJournalLine.Amount - GLEntry.Amount);
                                    GenJournalLine.MODIFY;
                                    CreateNew := FALSE;
                                END;
                            END;

                            IF (CreateNew) THEN BEGIN
                                LineNo += 1;
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := QBActivableExpensesSetup."Journal Template";
                                GenJournalLine."Journal Batch Name" := QBActivableExpensesSetup."Journal Batch";
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account No." := TAuxJobsStatusAnt."Activation Account";
                                GenJournalLine."Posting Date" := QBExpensesActivation."Period End Date";
                                GenJournalLine.VALIDATE(Amount, -GLEntry.Amount);
                                GenJournalLine.Description := COPYSTR('Activaci¢n financiera ' + QBExpensesActivation.Period, 1, MAXSTRLEN(GenJournalLine.Description));  //JAV 11/11/22 Ajustar longitud
                                GenJournalLine."Document No." := QBExpensesActivation."Document No.";
                                GenJournalLine."Job No." := QBExpensesActivation."Job Code";
                                GenJournalLine.VALIDATE("Piecework Code", QBExpensesActivation.Piecework);
                                GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                                GenJournalLine."Gen. Bus. Posting Group" := '';
                                GenJournalLine."Gen. Prod. Posting Group" := '';
                                GenJournalLine."QB Activation Mov." := TRUE;
                                GenJournalLine."QB Activation Code" := QBExpensesActivation.Period;
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GLEntry."Global Dimension 1 Code");  //JAV 14/11/22: - QB 1.12.00 A¤adir el manejo de las dimensiones
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GLEntry."Global Dimension 2 Code");
                                GenJournalLine.VALIDATE("Dimension Set ID", GLEntry."Dimension Set ID");
                                GenJournalLine.INSERT;
                            END;

                            //Contrapartida
                            CreateNew := TRUE;
                            IF (NOT QBActivableExpensesSetup."Activable Detailed") THEN BEGIN
                                GenJournalLine.RESET;
                                GenJournalLine.SETRANGE("Journal Template Name", QBActivableExpensesSetup."Journal Template");
                                GenJournalLine.SETRANGE("Journal Batch Name", QBActivableExpensesSetup."Journal Batch");
                                GenJournalLine.SETRANGE("Account No.", TAuxJobsStatus."Activation Account");
                                GenJournalLine.SETRANGE("Job No.", QBExpensesActivation."Job Code");
                                GenJournalLine.SETRANGE("Piecework Code", QBExpensesActivation.Piecework);
                                IF (GenJournalLine.FINDFIRST) THEN BEGIN
                                    GenJournalLine.VALIDATE(Amount, GenJournalLine.Amount + GLEntry.Amount);
                                    GenJournalLine.MODIFY;
                                    CreateNew := FALSE;
                                END;
                            END;

                            IF (CreateNew) THEN BEGIN
                                LineNo += 1;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Account No." := TAuxJobsStatus."Activation Account";
                                GenJournalLine.VALIDATE(Amount, GLEntry.Amount);
                                GenJournalLine.INSERT;
                            END;

                        UNTIL (GLEntry.NEXT = 0);
                END;
            UNTIL (QBExpensesActivation.NEXT = 0);
    END;

    PROCEDURE actDelete(Rec: Record 7206995);
    VAR
        QBExpensesActivation: Record 7206995;
        GLEntry: Record 17;
        GLRegister: Record 45;
        JobLedgerEntry: Record 169;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Eliminar el registro contable de la activaci¢n
        //-----------------------------------------------------------------------------------------------------------------------------------------

        IF CONFIRM('¨Realmente desea cancelar el registro de la activaci¢n?', FALSE) THEN BEGIN
            //Borrar el asiento generado
            GLEntry.RESET;
            GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
            GLEntry.SETRANGE("Document No.", Rec."Document No.");
            GLEntry.SETRANGE("Posting Date", Rec."Period End Date");
            IF (GLEntry.FINDFIRST) THEN BEGIN
                //Borrar el asiento
                GLRegister.GET(GLEntry."Transaction No.");
                GLRegister.DELETE;
                //Borrar los apuntes
                GLEntry.DELETEALL(FALSE);
                //Borrar mov. proyecto
                JobLedgerEntry.RESET;
                JobLedgerEntry.SETCURRENTKEY("Document No.", "Posting Date");
                JobLedgerEntry.SETRANGE("Document No.", Rec."Document No.");
                JobLedgerEntry.SETRANGE("Posting Date", Rec."Period End Date");
                JobLedgerEntry.DELETEALL;
            END;

            //Quitar las marcas de activaci¢n financiera
            GLEntry.RESET;
            GLEntry.SETRANGE("QB Activation Financial Code", Rec.Period);
            GLEntry.MODIFYALL("QB Activation Financial Code", '');

            //Marcar como calculado y eliminar importes
            QBExpensesActivation.RESET;
            QBExpensesActivation.SETRANGE(Period, Rec.Period);
            QBExpensesActivation.MODIFYALL(Status, QBExpensesActivation.Status::Calculated);
            QBExpensesActivation.MODIFYALL("Activation Management", 0);
            QBExpensesActivation.MODIFYALL("Activation Financial", 0);
        END;
    END;

    PROCEDURE actGetAccounts(QBExpensesActivation: Record 7206995; VAR TAuxJobsStatus: Record 7207440);
    VAR
        Job: Record 167;
        QBExpensesActivationJob: Record 7206995;
        QBExpensesActivation2: Record 7206995;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Buscar las cuentas de activaci¢n de un apunte contable
        //-----------------------------------------------------------------------------------------------------------------------------------------

        QBExpensesActivationJob.GET(QBExpensesActivation.Period, QBExpensesActivation."Job Code", '');
        TAuxJobsStatus.GET(QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");

        QBExpensesActivationJob.GET(QBExpensesActivation.Period, QBExpensesActivation."Job Code", '');
        CASE TAuxJobsStatus.Activation OF
            TAuxJobsStatus.Activation::Management:
                BEGIN
                    IF (TAuxJobsStatus."Activation Account" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                    IF (TAuxJobsStatus."Activation Account BalGes" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en gesti¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                END;
            TAuxJobsStatus.Activation::Financial:
                BEGIN
                    IF (TAuxJobsStatus."Activation Account" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                    IF (TAuxJobsStatus."Activation Account BalGes" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en gesti¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                    IF (TAuxJobsStatus."Activation Account BalFin" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n financiera en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                END;
            ELSE
                ERROR('No ha definido un estado en el proyecto %1 adecuado para el c lculo de la activaci¢n', QBExpensesActivation."Job Code");
        END;
    END;

    PROCEDURE actGetAccountsAnt(QBExpensesActivation: Record 7206995; VAR TAuxJobsStatus: Record 7207440; VAR TAuxJobsStatusAnt: Record 7207440);
    VAR
        Job: Record 167;
        QBExpensesActivationJob: Record 7206995;
        QBExpensesActivation2: Record 7206995;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 25/10/22: - QB 1.12.00 Buscar las cuentas de activaci¢n de un apunte contable
        //-----------------------------------------------------------------------------------------------------------------------------------------

        actGetAccounts(QBExpensesActivation, TAuxJobsStatus);

        //Buscar el estado del periodo anterior
        QBExpensesActivation2.RESET;
        QBExpensesActivation2.SETFILTER(Period, '<%1', QBExpensesActivation.Period);
        QBExpensesActivation2.SETRANGE("Job Code", QBExpensesActivation."Job Code");
        QBExpensesActivation2.SETFILTER(Piecework, '=%1', '');
        IF (QBExpensesActivation2.FINDLAST) THEN
            TAuxJobsStatusAnt.GET(QBExpensesActivation2."Job Status Type", QBExpensesActivation2."Job Status Code")
        ELSE
            TAuxJobsStatusAnt := TAuxJobsStatus;

        CASE TAuxJobsStatusAnt.Activation OF
            TAuxJobsStatusAnt.Activation::Management:
                BEGIN
                    IF (TAuxJobsStatusAnt."Activation Account" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                    IF (TAuxJobsStatusAnt."Activation Account BalGes" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en gesti¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                END;
            TAuxJobsStatusAnt.Activation::Financial:
                BEGIN
                    IF (TAuxJobsStatusAnt."Activation Account" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                    IF (TAuxJobsStatusAnt."Activation Account BalGes" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n en gesti¢n en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                    IF (TAuxJobsStatusAnt."Activation Account BalFin" = '') THEN
                        ERROR('Falta la cuenta de activaci¢n financiera en el estado %1 - %2', QBExpensesActivation."Job Status Type", QBExpensesActivationJob."Job Status Code");
                END;
            ELSE
                TAuxJobsStatusAnt := TAuxJobsStatus;  //Si el estado anterior no tiene definida la activaci¢n, es como si no hubiera anterior
        END;
    END;

    PROCEDURE actNavigate(Rec: Record 7206995);
    VAR
        Navigate: Page 344;
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 18/11/22: - QB 1.12.00 Navegar al documento registrado
        //-----------------------------------------------------------------------------------------------------------------------------------------
        CLEAR(Navigate);
        Navigate.SetDoc(Rec."Period End Date", Rec."Document No.");
        Navigate.RUN;
    END;

    LOCAL PROCEDURE "----------------------------------------------------------- Responder a Eventos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 12, OnPostGLAccOnBeforeInsertGLEntry, '', true, true)]
    LOCAL PROCEDURE CU12_OnPostGLAccOnBeforeInsertGLEntry(VAR GenJournalLine: Record 81; VAR GLEntry: Record 17; VAR IsHandled: Boolean);
    BEGIN
        //-----------------------------------------------------------------------------------------------------------------------------------------
        // JAV 15/11/22: - QB 1.12.00 Tras crear el registro del movimiento, pasarle el c¢digo de la activaci¢n
        //-----------------------------------------------------------------------------------------------------------------------------------------

        GLEntry."QB Activation Code" := GenJournalLine."QB Activation Code";
    END;

    /*BEGIN
/*{
      JAV 25/10/22: - QB 1.12.00 Nueva CU para el manejo de los Gastos Activables
    }
END.*/
}









