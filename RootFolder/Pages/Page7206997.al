page 7206997 "QB Job Task Data"
{
    CaptionML = ENU = 'Job Task Data', ESP = 'Tareas de los Proyectos';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7206945;
    PageType = List;
    SourceTableTemporary = true;
    PromotedActionCategoriesML = ENU = '1,Aspecto,3,Acciones', ESP = '1,Aspecto,3,Acciones';

    layout
    {
        area(content)
        {
            repeater("table")
            {

                field("Job"; rec."Job")
                {

                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Period"; rec."Period")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                // group("group18")
                // {
                // }
                field("Field1"; MATRIX_CellData[1])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Enabled = enCol01;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(1);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(1);
                    END;


                }
                field("Field2"; MATRIX_CellData[2])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    Enabled = enCol02;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(2);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(2);
                    END;


                }
                field("Field3"; MATRIX_CellData[3])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    Enabled = enCol03;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(3);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(3);
                    END;


                }
                field("Field4"; MATRIX_CellData[4])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    Enabled = enCol04;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(4);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(4);
                    END;


                }
                field("Field5"; MATRIX_CellData[5])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    Enabled = enCol05;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(5);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(5);
                    END;


                }
                field("Field6"; MATRIX_CellData[6])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    Enabled = enCol06;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(6);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(6);
                    END;


                }
                field("Field7"; MATRIX_CellData[7])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    Enabled = enCol07;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(7);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(7);
                    END;


                }
                field("Field8"; MATRIX_CellData[8])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    Enabled = enCol08;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(8);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(8);
                    END;


                }
                field("Field9"; MATRIX_CellData[9])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    Enabled = enCol09;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(9);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(9);
                    END;


                }
                field("Field10"; MATRIX_CellData[10])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    Enabled = enCol10;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(10);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(10);
                    END;


                }
                field("Field11"; MATRIX_CellData[11])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];
                    Enabled = enCol11;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(11);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(11);
                    END;


                }
                field("Field12"; MATRIX_CellData[12])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];
                    Enabled = enCol12;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(12);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(12);
                    END;


                }
                field("Field13"; MATRIX_CellData[13])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];
                    Enabled = enCol13;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(13);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(13);
                    END;


                }
                field("Field14"; MATRIX_CellData[14])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];
                    Enabled = enCol14;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(14);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(14);
                    END;


                }
                field("Field15"; MATRIX_CellData[15])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];
                    Enabled = enCol15;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(15);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(15);
                    END;


                }
                field("Field16"; MATRIX_CellData[16])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];
                    Enabled = enCol16;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(16);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(16);
                    END;


                }
                field("Field17"; MATRIX_CellData[17])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];
                    Enabled = enCol17;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(17);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(17);
                    END;


                }
                field("Field18"; MATRIX_CellData[18])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];
                    Enabled = enCol18;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(18);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(18);
                    END;


                }
                field("Field19"; MATRIX_CellData[19])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];
                    Enabled = enCol19;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(19);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(19);
                    END;


                }
                field("Field20"; MATRIX_CellData[20])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];
                    Enabled = enCol20;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(20);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(20);
                    END;


                }
                field("Field21"; MATRIX_CellData[21])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];
                    Enabled = enCol21;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(21);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(21);
                    END;


                }
                field("Field22"; MATRIX_CellData[22])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];
                    Enabled = enCol22;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(22);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(22);
                    END;


                }
                field("Field23"; MATRIX_CellData[23])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];
                    Enabled = enCol23;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(23);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(23);
                    END;


                }
                field("Field24"; MATRIX_CellData[24])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];
                    Enabled = enCol24;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(24);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(24);
                    END;


                }
                field("Field25"; MATRIX_CellData[25])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];
                    Enabled = enCol25;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(25);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(25);
                    END;


                }
                field("Field26"; MATRIX_CellData[26])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];
                    Enabled = enCol26;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(26);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(26);
                    END;


                }
                field("Field27"; MATRIX_CellData[27])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];
                    Enabled = enCol27;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(27);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(27);
                    END;


                }
                field("Field28"; MATRIX_CellData[28])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];
                    Enabled = enCol28;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(28);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(28);
                    END;


                }
                field("Field29"; MATRIX_CellData[29])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];
                    Enabled = enCol29;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(29);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(29);
                    END;


                }
                field("Field30"; MATRIX_CellData[30])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];
                    Enabled = enCol30;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(30);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(30);
                    END;


                }
                field("Field31"; MATRIX_CellData[31])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];
                    Enabled = enCol31;

                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(31);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(31);
                    END;


                }
                field("Field32"; MATRIX_CellData[32])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];
                    Enabled = enCol32;



                    ; trigger OnValidate()
                    BEGIN
                        MATRIX_OnValidate(32);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(32);
                    END;


                }

            }

        }
    }

    actions
    {
        area(Processing)
        {


        }

    }

    trigger OnOpenPage()
    BEGIN
        //Montar las p�ginas
        SetRows;
        SetCols;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        MATRIX_OnAfterGetRecord;
    END;



    var
        Text001: TextConst ENU = 'The budgeted measurement for this unit of job has been exceeded.', ESP = 'Se ha sobrepasado la medici�n presupuestada para esta unidad de obra.';
        Text002: TextConst ENU = 'The budgeted cost for this unit of job has been exceeded.', ESP = 'Se ha sobrepasado el coste presupuestado para esta unidad de obra.';
        Text003: TextConst ENU = 'The budgeted production for this unit of job has been exceeded.', ESP = 'Se ha sobrepasado la producci�n presupuestada para esta unidad de obra.';
        Text005: TextConst ENU = 'You can not Rec.MODIFY data for records whose Account Type is Heading.', ESP = 'No se pueden modificar datos para registros cuyo Tipo Mov. es Mayor.';
        Text006: TextConst ENU = 'Processing planning data.', ESP = 'Procesando datos de planificaci�n.';
        Text000: TextConst ENU = 'Do you want to approve the planning?', ESP = '�Desea aprobar la planificaci�n?';
        Text004: TextConst ENU = 'Piecework/cost% 1 not fully planned.', ESP = 'La unidad de obra/coste %1 no esta totalmente planificada.';
        QBJobTask: Record 7206902;
        QBJobTask2: Record 7206902;
        QBJobTaskMonth: Record 7206945;
        QBJobTaskData: Record 7206927;
        QBJobTaskDataSetup: Page 7207028;
        QBJobTaskManagement: Codeunit 7206902;
        QBApprovalManagement: Codeunit 7207354;
        gType: Option "Month","Job";
        gJob: Code[20];
        gMonth: Code[10];
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        MATRIX_CellData: ARRAY[32] OF Text;
        MATRIX_ColumnCaption: ARRAY[32] OF Text[1024];
        MATRIX_ColumnTask: ARRAY[32] OF Integer;
        TableName: Text;
        nCol: Integer;
        enCol01: Boolean;
        enCol02: Boolean;
        enCol03: Boolean;
        enCol04: Boolean;
        enCol05: Boolean;
        enCol06: Boolean;
        enCol07: Boolean;
        enCol08: Boolean;
        enCol09: Boolean;
        enCol10: Boolean;
        enCol11: Boolean;
        enCol12: Boolean;
        enCol13: Boolean;
        enCol14: Boolean;
        enCol15: Boolean;
        enCol16: Boolean;
        enCol17: Boolean;
        enCol18: Boolean;
        enCol19: Boolean;
        enCol20: Boolean;
        enCol21: Boolean;
        enCol22: Boolean;
        enCol23: Boolean;
        enCol24: Boolean;
        enCol25: Boolean;
        enCol26: Boolean;
        enCol27: Boolean;
        enCol28: Boolean;
        enCol29: Boolean;
        enCol30: Boolean;
        enCol31: Boolean;
        enCol32: Boolean;

    LOCAL procedure MATRIX_OnDrillDown(ColumnID: Integer);
    begin
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord();
    begin
        CLEAR(MATRIX_CellData);
        CASE gType OF
            gType::Month:
                begin
                end;
            gType::Job:
                begin
                    nCol := 1;
                    WHILE (nCol <= ARRAYLEN(MATRIX_CellData)) DO begin
                        if QBJobTaskData.GET(rec.Job, rec.Period, MATRIX_ColumnTask[nCol]) then
                            MATRIX_CellData[nCol] := QBJobTaskData.Comment;
                        nCol += 1;
                    end;
                end;
        end;

        enCol01 := (MATRIX_ColumnCaption[1] <> '');
        enCol02 := (MATRIX_ColumnCaption[2] <> '');
        enCol03 := (MATRIX_ColumnCaption[3] <> '');
        enCol04 := (MATRIX_ColumnCaption[4] <> '');
        enCol05 := (MATRIX_ColumnCaption[5] <> '');
        enCol06 := (MATRIX_ColumnCaption[6] <> '');
        enCol07 := (MATRIX_ColumnCaption[7] <> '');
        enCol08 := (MATRIX_ColumnCaption[8] <> '');
        enCol09 := (MATRIX_ColumnCaption[9] <> '');
        enCol10 := (MATRIX_ColumnCaption[10] <> '');
        enCol11 := (MATRIX_ColumnCaption[11] <> '');
        enCol12 := (MATRIX_ColumnCaption[12] <> '');
        enCol13 := (MATRIX_ColumnCaption[13] <> '');
        enCol14 := (MATRIX_ColumnCaption[14] <> '');
        enCol15 := (MATRIX_ColumnCaption[15] <> '');
        enCol16 := (MATRIX_ColumnCaption[16] <> '');
        enCol17 := (MATRIX_ColumnCaption[17] <> '');
        enCol18 := (MATRIX_ColumnCaption[18] <> '');
        enCol19 := (MATRIX_ColumnCaption[19] <> '');
        enCol20 := (MATRIX_ColumnCaption[20] <> '');
        enCol21 := (MATRIX_ColumnCaption[21] <> '');
        enCol22 := (MATRIX_ColumnCaption[22] <> '');
        enCol23 := (MATRIX_ColumnCaption[23] <> '');
        enCol24 := (MATRIX_ColumnCaption[24] <> '');
        enCol25 := (MATRIX_ColumnCaption[25] <> '');
        enCol26 := (MATRIX_ColumnCaption[26] <> '');
        enCol27 := (MATRIX_ColumnCaption[27] <> '');
        enCol28 := (MATRIX_ColumnCaption[28] <> '');
        enCol29 := (MATRIX_ColumnCaption[29] <> '');
        enCol30 := (MATRIX_ColumnCaption[30] <> '');
        enCol31 := (MATRIX_ColumnCaption[31] <> '');
        enCol32 := (MATRIX_ColumnCaption[32] <> '');
    end;

    procedure MATRIX_OnValidate(ColumnID: Integer);
    begin
    end;

    LOCAL procedure MATRIX_OnAssistEdit(ColumnID: Integer);
    begin
        if (MATRIX_ColumnCaption[ColumnID] = '') then
            exit;

        if not ValidateUser(MATRIX_ColumnTask[ColumnID]) then
            ERROR('Usuario no autorizado a efectuar cambios para esta Tarea');

        CASE gType OF
            gType::Month:
                begin
                end;
            gType::Job:
                begin
                    //Si no existe el registro estamos confirmando siempre
                    if (not QBJobTaskData.GET(rec.Job, rec.Period, MATRIX_ColumnTask[ColumnID])) then begin
                        //Verificar si se puede establecer sin los anteriores
                        if (CanSet(ColumnID)) then begin
                            QBJobTaskData.INIT;
                            QBJobTaskData.Job := Rec.Job;
                            QBJobTaskData.Period := Rec.Period;
                            QBJobTaskData.Task := MATRIX_ColumnTask[ColumnID];
                            QBJobTaskData.Date := CURRENTDATETIME;
                            QBJobTaskData.User := USERID;
                            QBJobTaskData.Comment := STRSUBSTNO('%1 por %2', DT2DATE(QBJobTaskData.Date), GetUserName(QBJobTaskData.User));
                            QBJobTaskData.INSERT;

                            COMMIT; //Por el Run Modal
                            CLEAR(QBJobTaskDataSetup);
                            QBJobTaskDataSetup.SETRECORD(QBJobTaskData);
                            QBJobTaskDataSetup.SetType(TRUE);
                            QBJobTaskDataSetup.LOOKUPMODE(TRUE);
                            if (QBJobTaskDataSetup.RUNMODAL = ACTION::LookupOK) then begin
                                QBJobTaskDataSetup.GETRECORD(QBJobTaskData);
                                QBJobTaskData.MODIFY(TRUE);
                            end ELSE begin
                                QBJobTaskData.DELETE;
                            end;
                        end;
                    end ELSE begin
                        //El registro existe. Si no est� ejecutado por estado erroneo, lo lanzamos de nuevo
                        if (not QBJobTaskData.Performed) then begin
                            COMMIT; //Por el Run Modal
                            CLEAR(QBJobTaskDataSetup);
                            QBJobTaskDataSetup.SETRECORD(QBJobTaskData);
                            QBJobTaskDataSetup.SetType(TRUE);
                            QBJobTaskDataSetup.LOOKUPMODE(TRUE);
                            if (QBJobTaskDataSetup.RUNMODAL = ACTION::LookupOK) then begin
                                QBJobTaskDataSetup.GETRECORD(QBJobTaskData);
                                QBJobTaskData.MODIFY(TRUE);
                            end;
                        end ELSE begin
                            //Si no tiene error queremos eliminarlo, pero solo si es posible por los posteriores
                            if (CanDelete(ColumnID)) then begin
                                COMMIT; //Por el Run Modal
                                CLEAR(QBJobTaskDataSetup);
                                QBJobTaskDataSetup.SETRECORD(QBJobTaskData);
                                QBJobTaskDataSetup.SetType(FALSE);
                                QBJobTaskDataSetup.LOOKUPMODE(TRUE);
                                if (QBJobTaskDataSetup.RUNMODAL = ACTION::LookupOK) then
                                    QBJobTaskData.DELETE;
                            end;
                        end;
                    end;
                end;
        end;

        // CASE SeeInRows OF
        //  SeeInRows::Empresas :
        //    begin
        //       if CONFIRM('Confirme que desea actualizar la tabla %1 en la empresa %2', TRUE, MATRIX_ColumnTableNo[ColumnID], Rec.Company) then
        //        QMMasterDataManagement.UpdateOneTableInACompany(Rec.Company, MATRIX_ColumnTableNo[ColumnID]);
        //    end;
        //  SeeInRows::Tablas :
        //    begin
        //      if CONFIRM('Confirme que desea actualizar la tabla %1 en la empresa %2', TRUE, Rec."Table No.", MATRIX_ColumnCaption[ColumnID]) then
        //        QMMasterDataManagement.UpdateOneTableInACompany(MATRIX_ColumnCaption[ColumnID], Rec."Table No." );
        //    end;
        // end;

        COMMIT;
        CurrPage.UPDATE;
    end;

    LOCAL procedure IsManualTable(pNro: Integer): Boolean;
    var
        result: Boolean;
    begin
        exit(pNro IN [DATABASE::Customer, DATABASE::Vendor, DATABASE::Resource, DATABASE::"Bank Account", DATABASE::Employee]);
    end;

    LOCAL procedure SetRows();
    begin
        //Preparar la tabla temporal
        Rec.RESET;
        Rec.DELETEALL;

        CASE gType OF
            gType::Month:
                begin
                end;
            gType::Job:
                begin
                    QBJobTaskMonth.INIT;
                    QBJobTaskMonth.Job := gJob;
                    QBJobTaskMonth.Year := DATE2DMY(TODAY, 3);
                    QBJobTaskMonth.Month := DATE2DMY(TODAY, 2);
                    if (not QBJobTaskMonth.INSERT(TRUE)) then;

                    QBJobTaskMonth.RESET;
                    QBJobTaskMonth.SETRANGE(Job, gJob);
                    if (QBJobTaskMonth.FINDSET) then
                        repeat
                            Rec := QBJobTaskMonth;
                            Rec.INSERT;
                        until (QBJobTaskMonth.NEXT = 0);

                    Rec.RESET;
                    Rec.SETCURRENTKEY(Job, Period);
                    Rec.SETASCENDING(Period, TRUE);
                end;
        end;
    end;

    LOCAL procedure SetCols();
    begin
        //Cargar nombres de columnas
        CLEAR(MATRIX_ColumnCaption);
        CLEAR(MATRIX_ColumnTask);
        nCol := 0;

        QBJobTask.RESET;
        QBJobTask.SETCURRENTKEY("Job Type", Status, Order);
        QBJobTask.SETRANGE("Job Type", QBJobTaskManagement.GetJobType(gJob));
        QBJobTask.SETRANGE(Status, QBJobTask.Status::Active);
        if (QBJobTask.FINDSET(FALSE)) then
            repeat
                nCol += 1;
                MATRIX_ColumnCaption[nCol] := QBJobTask.Description;
                MATRIX_ColumnTask[nCol] := QBJobTask.Code;
            until (QBJobTask.NEXT = 0);
        CurrPage.UPDATE();
    end;

    procedure SetJob(pJob: Code[20]);
    var
        Job: Record 167;
    begin
        Job.GET(pJob);
        gType := gType::Job;
        gJob := pJob;
    end;

    LOCAL procedure GetUserName(pName: Text): Text;
    var
        pos: Integer;
    begin
        pos := STRPOS(pName, '\');
        exit(COPYSTR(pName, pos + 1));
    end;

    LOCAL procedure CanSet(ColumnID: Integer): Boolean;
    begin
        QBJobTask2.GET(MATRIX_ColumnTask[ColumnID]);

        QBJobTask.RESET;
        QBJobTask.SETCURRENTKEY("Job Type", Status, Order);
        QBJobTask.SETRANGE("Job Type", QBJobTaskManagement.GetJobType(gJob));
        QBJobTask.SETRANGE(Status, QBJobTask.Status::Active);
        QBJobTask.SETRANGE("Mandatory before the rest", TRUE);
        QBJobTask.SETFILTER(Order, '<%1', QBJobTask2.Order);
        if (QBJobTask.FINDSET) then
            repeat
                if (not QBJobTaskData.GET(rec.Job, rec.Period, QBJobTask.Code)) then begin
                    MESSAGE('No puede establecer este estado antes del "' + QBJobTask.Description + '"');
                    exit(FALSE);
                end;
            until (QBJobTask.NEXT = 0);

        exit(TRUE);
    end;

    LOCAL procedure CanDelete(ColumnID: Integer): Boolean;
    begin
        QBJobTask2.GET(MATRIX_ColumnTask[ColumnID]);
        if (not QBJobTask2."Erasable with NEXT") then
            exit(TRUE);

        QBJobTask.RESET;
        QBJobTask.SETCURRENTKEY("Job Type", Status, Order);
        QBJobTask.SETRANGE("Job Type", QBJobTaskManagement.GetJobType(gJob));
        QBJobTask.SETRANGE(Status, QBJobTask.Status::Active);
        QBJobTask.SETFILTER(Order, '>%1', QBJobTask2.Order);
        if (QBJobTask.FINDSET) then
            repeat
                if (QBJobTaskData.GET(rec.Job, rec.Period, QBJobTask.Code)) then begin
                    MESSAGE('No puede borrar este estado cuando tiene establecido el "' + QBJobTask.Description + '"');
                    exit(FALSE);
                end;
            until (QBJobTask.NEXT = 0);

        exit(TRUE);
    end;

    LOCAL procedure ValidateUser(ColumnID: Integer): Boolean;
    begin
        QBJobTask2.GET(MATRIX_ColumnTask[ColumnID]);
        if (QBJobTask2."Approval Circuit" = '') then
            exit(TRUE);

        exit(QBApprovalManagement.ExistUserInJob(USERID, gJob, QBJobTask2."Approval Circuit"));
    end;

    // begin
    /*{
      JAV 11/08/22: - QB 1.11.02 Nueva p�gina para ver los datos de los proyectos por meses
    }*///end
}







