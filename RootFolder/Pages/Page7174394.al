page 7174394 "QM MasterData Table/Company"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Company/Table Setup', ESP = 'Master Data Empresa/Tabla';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7174394;
    PageType = List;
    SourceTableTemporary = true;
    PromotedActionCategoriesML = ENU = '1,Aspecto,3,Acciones', ESP = '1,Aspecto,3,Acciones';

    layout
    {
        area(content)
        {
            group("group7")
            {

                field("Pages"; Pages)
                {

                    CaptionML = ENU = 'Value Filter', ESP = 'P�gina';
                    // OptionCaptionML = ENU = 'Value Filter', ESP = 'P�gina';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("SeeInRows"; SeeInRows)
                {

                    CaptionML = ESP = 'Ver las las filas';
                    Visible = false;
                }
                field("nColMaster"; nColMaster)
                {

                    Visible = false;
                }

            }
            repeater("table")
            {

                field("Is Master"; rec."Is Master")
                {

                    Visible = seeColCom;
                    Editable = false;
                }
                field("Company"; rec."Company")
                {

                    Visible = seeColCom;
                    Style = Strong;
                    StyleExpr = IsMaster;
                }
                field("Table No."; rec."Table No.")
                {

                    Visible = seeColTab;
                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Table Name"; rec."Table Name")
                {

                    Visible = seeColTab;
                    Style = Strong;
                    StyleExpr = IsMaster;
                }
                // group("group16")
                // {
                // }
                field("Field1"; MATRIX_CellData[1])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Editable = edCol01;
                    Style = Subordinate;
                    StyleExpr = not edcol01;

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
                    Editable = edCol02;
                    Style = Subordinate;
                    StyleExpr = not edcol02;

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
                    Editable = edCol03;
                    Style = Subordinate;
                    StyleExpr = not edcol03;

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
                    Editable = edCol04;
                    Style = Subordinate;
                    StyleExpr = not edcol04;

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
                    Editable = edCol05;
                    Style = Subordinate;
                    StyleExpr = not edcol05;

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
                    Editable = edCol06;
                    Style = Subordinate;
                    StyleExpr = not edcol06;

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
                    Editable = edCol07;
                    Style = Subordinate;
                    StyleExpr = not edcol07;

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
                    Editable = edCol08;
                    Style = Subordinate;
                    StyleExpr = not edcol08;

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
                    Editable = edCol09;
                    Style = Subordinate;
                    StyleExpr = not edcol09;

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
                    Editable = edCol11;
                    Style = Subordinate;
                    StyleExpr = not edcol10;

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
                    Editable = edCol11;
                    Style = Subordinate;
                    StyleExpr = not edcol11;

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
                    Editable = edCol12;
                    Style = Subordinate;
                    StyleExpr = not edcol12;

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
                    Editable = edCol13;
                    Style = Subordinate;
                    StyleExpr = not edcol13;

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
                    Editable = edCol14;
                    Style = Subordinate;
                    StyleExpr = not edcol14;

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
                    Editable = edCol15;
                    Style = Subordinate;
                    StyleExpr = not edcol15;

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
                    Editable = edCol16;
                    Style = Subordinate;
                    StyleExpr = not edcol16;

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
                    Editable = edCol17;
                    Style = Subordinate;
                    StyleExpr = not edcol17;

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
                    Editable = edcol18;
                    Style = Subordinate;
                    StyleExpr = not edcol18;

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
                    Editable = edcol19;
                    Style = Subordinate;
                    StyleExpr = not edcol19;

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
                    Editable = edcol20;
                    Style = Subordinate;
                    StyleExpr = not edcol20;

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
                    Editable = edcol21;
                    Style = Subordinate;
                    StyleExpr = not edcol21;

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
                    Editable = edcol22;
                    Style = Subordinate;
                    StyleExpr = not edcol22;

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
                    Editable = edcol23;
                    Style = Subordinate;
                    StyleExpr = not edcol23;

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
                    Editable = edcol24;
                    Style = Subordinate;
                    StyleExpr = not edcol24;

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
                    Editable = edcol25;
                    Style = Subordinate;
                    StyleExpr = not edcol25;

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
                    Editable = edcol26;
                    Style = Subordinate;
                    StyleExpr = not edcol26;

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
                    Editable = edcol27;
                    Style = Subordinate;
                    StyleExpr = not edcol27;

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
                    Editable = edcol28;
                    Style = Subordinate;
                    StyleExpr = not edcol28;

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
                    Editable = edcol29;
                    Style = Subordinate;
                    StyleExpr = not edcol29;

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
                    Editable = edcol30;
                    Style = Subordinate;
                    StyleExpr = not edcol30;

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
                    Editable = edcol31;
                    Style = Subordinate;
                    StyleExpr = not edcol31;

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
                    Editable = edcol32;
                    Style = Subordinate;
                    StyleExpr = not edcol32;



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

            action("action1")
            {
                CaptionML = ESP = 'Pg. Anterior';
                Promoted = true;
                PromotedIsBig = true;
                Image = PreviousSet;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    IF (PageNo > 1) THEN BEGIN
                        PageNo -= 1;
                        SetCols;
                    END;
                END;


            }
            action("action2")
            {
                CaptionML = ESP = 'Cambiar Fila/Columna';
                Promoted = true;
                PromotedIsBig = true;
                Image = Change;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    CASE SeeInRows OF
                        SeeInRows::Empresas:
                            SeeInRows := SeeInRows::Tablas;
                        SeeInRows::Tablas:
                            SeeInRows := SeeInRows::Empresas;
                    END;
                    SetRows;
                    SetCols;

                    CurrPage.UPDATE(FALSE);
                END;


            }
            action("action3")
            {
                CaptionML = ESP = 'Pg. Siguiente';
                Promoted = true;
                PromotedIsBig = true;
                Image = NextSet;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    IF (PageNo < PageMax) THEN BEGIN
                        PageNo += 1;
                        SetCols;
                    END;
                END;


            }
            action("action4")
            {
                CaptionML = ESP = 'Sincronizar Tablas';
                Promoted = true;
                PromotedIsBig = true;
                Image = UpdateDescription;
                PromotedCategory = Category4;


                trigger OnAction()
                VAR
                    ok: Boolean;
                BEGIN
                    CASE SeeInRows OF
                        SeeInRows::Empresas:
                            BEGIN
                                IF CONFIRM('Desea sincronizar todas las tablas en la empresa %1', TRUE, rec.Company) THEN
                                    QMMasterDataManagement.UpdateAllTablesByCompany(rec.Company);
                            END;
                        SeeInRows::Tablas:
                            BEGIN
                                IF CONFIRM('Desea sincronizar en todas las empresas la tabla %1 %2', TRUE, rec."Table No.", rec."Table Name") THEN
                                    QMMasterDataManagement.UpdateTableInAllCompany(rec."Table No.");
                            END;
                    END;
                END;


            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        //JAV 28/04/22: - QM 1.00.04 Crear los datos de la tabla de dimensiones
        QMMasterDataTable.InsertDefaultDimension;


        QMMasterDataConfiguration.GET;

        //Calcular p�ginas
        SeeInRows := SeeInRows::Empresas;
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
        QMMasterDataConfiguration: Record 7174390;
        QMMasterDataCompanies: Record 7174391;
        QMMasterDataTable: Record 7174392;
        QMMasterDataCompanieTable: Record 7174394;
        QMMasterDataManagement: Codeunit 7174368;
        SeeInRows: Option "Empresas","Tablas";
        PageNo: Integer;
        PageMax: Integer;
        Pages: Text;
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        MATRIX_CellData: ARRAY[32] OF option " ","Automtico";
        MATRIX_ColumnCaption: ARRAY[32] OF Text[1024];
        MATRIX_ColumnTableNo: ARRAY[32] OF Integer;
        TableName: Text;
        nColMaster: Integer;
        nCol: Integer;
        nPag: Integer;
        IsMaster: Boolean;
        seeColCom: Boolean;
        seeColTab: Boolean;
        edCol01: Boolean;
        edCol02: Boolean;
        edCol03: Boolean;
        edCol04: Boolean;
        edCol05: Boolean;
        edCol06: Boolean;
        edCol07: Boolean;
        edCol08: Boolean;
        edCol09: Boolean;
        edCol10: Boolean;
        edCol11: Boolean;
        edCol12: Boolean;
        edCol13: Boolean;
        edCol14: Boolean;
        edCol15: Boolean;
        edCol16: Boolean;
        edCol17: Boolean;
        edCol18: Boolean;
        edCol19: Boolean;
        edCol20: Boolean;
        edCol21: Boolean;
        edCol22: Boolean;
        edCol23: Boolean;
        edCol24: Boolean;
        edCol25: Boolean;
        edCol26: Boolean;
        edCol27: Boolean;
        edCol28: Boolean;
        edCol29: Boolean;
        edCol30: Boolean;
        edCol31: Boolean;
        edCol32: Boolean;

    LOCAL procedure MATRIX_OnDrillDown(ColumnID: Integer);
    begin
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord();
    begin
        CLEAR(MATRIX_CellData);
        if (SeeInRows = SeeInRows::Tablas) then begin
            if not QMMasterDataTable.GET(rec."Table No.") then
                QMMasterDataCompanieTable.INIT;
            IsMaster := QMMasterDataTable."Is Default Dimension Table";

            nCol := 1;
            WHILE (nCol <= ARRAYLEN(MATRIX_CellData)) DO begin
                if QMMasterDataCompanieTable.GET(MATRIX_ColumnCaption[nCol], rec."Table No.") then   //Si encuenta el valor lo pone en la casilla
                    MATRIX_CellData[nCol] := QMMasterDataCompanieTable.Sync;
                nCol += 1;
            end;
        end ELSE begin
            IsMaster := (rec.Company = QMMasterDataManagement.GetMaster);
            nCol := 1;
            WHILE (nCol <= ARRAYLEN(MATRIX_CellData)) DO begin
                if QMMasterDataCompanieTable.GET(rec.Company, MATRIX_ColumnTableNo[nCol]) then   //Si encuenta el valor lo pone en la casilla
                    MATRIX_CellData[nCol] := QMMasterDataCompanieTable.Sync;
                nCol += 1;
            end;
        end;

        edCol01 := (MATRIX_ColumnCaption[1] <> '') and (nColMaster <> 1) and (not IsMaster);
        edCol02 := (MATRIX_ColumnCaption[2] <> '') and (nColMaster <> 2) and (not IsMaster);
        edCol03 := (MATRIX_ColumnCaption[3] <> '') and (nColMaster <> 3) and (not IsMaster);
        edCol04 := (MATRIX_ColumnCaption[4] <> '') and (nColMaster <> 4) and (not IsMaster);
        edCol05 := (MATRIX_ColumnCaption[5] <> '') and (nColMaster <> 5) and (not IsMaster);
        edCol06 := (MATRIX_ColumnCaption[6] <> '') and (nColMaster <> 6) and (not IsMaster);
        edCol07 := (MATRIX_ColumnCaption[7] <> '') and (nColMaster <> 7) and (not IsMaster);
        edCol08 := (MATRIX_ColumnCaption[8] <> '') and (nColMaster <> 8) and (not IsMaster);
        edCol09 := (MATRIX_ColumnCaption[9] <> '') and (nColMaster <> 9) and (not IsMaster);
        edCol10 := (MATRIX_ColumnCaption[10] <> '') and (nColMaster <> 10) and (not IsMaster);
        edCol11 := (MATRIX_ColumnCaption[11] <> '') and (nColMaster <> 11) and (not IsMaster);
        edCol12 := (MATRIX_ColumnCaption[12] <> '') and (nColMaster <> 12) and (not IsMaster);
        edCol13 := (MATRIX_ColumnCaption[13] <> '') and (nColMaster <> 13) and (not IsMaster);
        edCol14 := (MATRIX_ColumnCaption[14] <> '') and (nColMaster <> 14) and (not IsMaster);
        edCol15 := (MATRIX_ColumnCaption[15] <> '') and (nColMaster <> 15) and (not IsMaster);
        edCol16 := (MATRIX_ColumnCaption[16] <> '') and (nColMaster <> 16) and (not IsMaster);
        edCol17 := (MATRIX_ColumnCaption[17] <> '') and (nColMaster <> 17) and (not IsMaster);
        edCol18 := (MATRIX_ColumnCaption[18] <> '') and (nColMaster <> 18) and (not IsMaster);
        edCol19 := (MATRIX_ColumnCaption[19] <> '') and (nColMaster <> 19) and (not IsMaster);
        edCol20 := (MATRIX_ColumnCaption[20] <> '') and (nColMaster <> 20) and (not IsMaster);
        edCol21 := (MATRIX_ColumnCaption[21] <> '') and (nColMaster <> 21) and (not IsMaster);
        edCol22 := (MATRIX_ColumnCaption[22] <> '') and (nColMaster <> 22) and (not IsMaster);
        edCol23 := (MATRIX_ColumnCaption[23] <> '') and (nColMaster <> 23) and (not IsMaster);
        edCol24 := (MATRIX_ColumnCaption[24] <> '') and (nColMaster <> 24) and (not IsMaster);
        edCol25 := (MATRIX_ColumnCaption[25] <> '') and (nColMaster <> 25) and (not IsMaster);
        edCol26 := (MATRIX_ColumnCaption[26] <> '') and (nColMaster <> 26) and (not IsMaster);
        edCol27 := (MATRIX_ColumnCaption[27] <> '') and (nColMaster <> 27) and (not IsMaster);
        edCol28 := (MATRIX_ColumnCaption[28] <> '') and (nColMaster <> 28) and (not IsMaster);
        edCol29 := (MATRIX_ColumnCaption[29] <> '') and (nColMaster <> 29) and (not IsMaster);
        edCol30 := (MATRIX_ColumnCaption[30] <> '') and (nColMaster <> 30) and (not IsMaster);
        edCol31 := (MATRIX_ColumnCaption[31] <> '') and (nColMaster <> 31) and (not IsMaster);
        edCol32 := (MATRIX_ColumnCaption[32] <> '') and (nColMaster <> 32) and (not IsMaster);
    end;

    procedure MATRIX_OnValidate(ColumnID: Integer);
    begin
        //Guardar el valor del campo
        if (SeeInRows = SeeInRows::Empresas) then begin
            if (MATRIX_CellData[ColumnID] = QMMasterDataCompanieTable.Sync::Manual) and (not IsManualTable(MATRIX_ColumnTableNo[ColumnID])) then
                ERROR('Esta tabla no admite sincronizaci�n manual');

            if QMMasterDataCompanieTable.GET(rec.Company, MATRIX_ColumnTableNo[ColumnID]) then begin  //Si encuenta el valor lo pone en la casilla
                QMMasterDataCompanieTable.Sync := MATRIX_CellData[ColumnID];
                QMMasterDataCompanieTable.MODIFY;
            end ELSE begin
                QMMasterDataCompanieTable.Company := Rec.Company;
                QMMasterDataCompanieTable."Table No." := MATRIX_ColumnTableNo[ColumnID];
                QMMasterDataCompanieTable.Sync := MATRIX_CellData[ColumnID];
                QMMasterDataCompanieTable.INSERT;
            end;
        end ELSE begin
            if (MATRIX_CellData[ColumnID] = QMMasterDataCompanieTable.Sync::Manual) and (not IsManualTable(Rec."Table No.")) then
                ERROR('Esta tabla no admite sincronizaci�n manual');

            if QMMasterDataCompanieTable.GET(MATRIX_ColumnCaption[ColumnID], rec."Table No.") then begin  //Si encuenta el valor lo pone en la casilla
                QMMasterDataCompanieTable.Sync := MATRIX_CellData[ColumnID];
                QMMasterDataCompanieTable.MODIFY;
            end ELSE begin
                QMMasterDataCompanieTable.Company := MATRIX_ColumnCaption[ColumnID];
                QMMasterDataCompanieTable."Table No." := Rec."Table No.";
                QMMasterDataCompanieTable.Sync := MATRIX_CellData[ColumnID];
                QMMasterDataCompanieTable.INSERT;
            end;
        end;

        COMMIT;
        CurrPage.UPDATE;
    end;

    LOCAL procedure MATRIX_OnAssistEdit(ColumnID: Integer);
    begin
        //JAV 22/04/22: - QM 1.00.02 Solo se pueden sincronizar tablas lanzandolo desde la empresa master
        if (not QMMasterDataManagement.CompanyIsMaster(COMPANYNAME)) then
            ERROR('Este proceso solo se puede lanzar desde la empresa Master');


        if (MATRIX_CellData[ColumnID] = MATRIX_CellData[ColumnID] ::" ") then
            exit;

        CASE SeeInRows OF
            SeeInRows::Empresas:
                begin
                    if CONFIRM('Confirme que desea actualizar la tabla %1 en la empresa %2', TRUE, MATRIX_ColumnTableNo[ColumnID], Rec.Company) then
                        QMMasterDataManagement.UpdateOneTableInACompany(Rec.Company, MATRIX_ColumnTableNo[ColumnID]);
                end;
            SeeInRows::Tablas:
                begin
                    if CONFIRM('Confirme que desea actualizar la tabla %1 en la empresa %2', TRUE, Rec."Table No.", MATRIX_ColumnCaption[ColumnID]) then
                        QMMasterDataManagement.UpdateOneTableInACompany(MATRIX_ColumnCaption[ColumnID], Rec."Table No.");
                end;
        end;
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

        if (SeeInRows = SeeInRows::Tablas) then begin
            QMMasterDataCompanies.RESET;
            PageMax := 0;
            PageNo := QMMasterDataCompanies.COUNT;
            repeat
                PageMax += 1;
                PageNo -= ARRAYLEN(MATRIX_CellData);
            until (PageNo <= 0);
            PageNo := 1;
            Pages := STRSUBSTNO('%1 / %2', PageNo, PageMax);

            QMMasterDataTable.RESET;
            if (QMMasterDataTable.FINDSET) then
                repeat
                    Rec.INIT;
                    Rec.Company := '';
                    Rec."Table No." := QMMasterDataTable."Table No.";
                    Rec."Is Master" := FALSE;
                    Rec.INSERT;
                until (QMMasterDataTable.NEXT = 0);
        end ELSE begin
            Rec.SETCURRENTKEY("Is not Master");

            QMMasterDataTable.RESET;
            PageMax := 0;
            PageNo := QMMasterDataTable.COUNT;
            repeat
                PageMax += 1;
                PageNo -= ARRAYLEN(MATRIX_CellData);
            until (PageNo <= 0);
            PageNo := 1;
            Pages := STRSUBSTNO('%1 / %2', PageNo, PageMax);

            QMMasterDataCompanies.RESET;
            if (QMMasterDataCompanies.FINDSET) then
                repeat
                    Rec.INIT;
                    Rec.Company := QMMasterDataCompanies.Company;
                    Rec."Table No." := 0;
                    Rec."Is Master" := QMMasterDataManagement.CompanyIsMaster(Rec.Company);
                    Rec."Is not Master" := (not Rec."Is Master");
                    Rec.INSERT;
                until (QMMasterDataCompanies.NEXT = 0);
        end;
    end;

    LOCAL procedure SetCols();
    begin
        //Cargar nombres de columnas
        Pages := STRSUBSTNO('%1 / %2', PageNo, PageMax);

        CLEAR(MATRIX_ColumnCaption);
        CLEAR(MATRIX_ColumnTableNo);
        nPag := 0;
        nCol := 0;
        nColMaster := -1;

        if (SeeInRows = SeeInRows::Tablas) then begin
            QMMasterDataCompanies.RESET;
            QMMasterDataCompanies.SETCURRENTKEY("Is not Master");  //Ordenar, primero la master
            if QMMasterDataCompanies.FINDSET then
                repeat
                    nPag += 1;
                    if (nPag >= ((PageNo - 1) * ARRAYLEN(MATRIX_CellData)) + 1) and (nPag <= (PageNo * ARRAYLEN(MATRIX_CellData))) then begin
                        nCol += 1;
                        MATRIX_ColumnCaption[nCol] := QMMasterDataCompanies.Company;
                        if (QMMasterDataManagement.CompanyIsMaster(QMMasterDataCompanies.Company)) then begin
                            nColMaster := nCol;
                            MATRIX_ColumnCaption[nCol] := '[M] ' + QMMasterDataCompanies.Company;
                        end;
                    end;
                until (QMMasterDataCompanies.NEXT = 0) or (nCol = ARRAYLEN(MATRIX_CellData));
        end ELSE begin
            QMMasterDataTable.RESET;
            if QMMasterDataTable.FINDSET then
                repeat
                    QMMasterDataTable.CALCFIELDS("Table Name");
                    nPag += 1;
                    if (nPag >= ((PageNo - 1) * ARRAYLEN(MATRIX_CellData)) + 1) and (nPag <= (PageNo * ARRAYLEN(MATRIX_CellData))) then begin
                        nCol += 1;
                        MATRIX_ColumnCaption[nCol] := FORMAT(QMMasterDataTable."Table No.") + ' ' + QMMasterDataTable."Table Name";
                        MATRIX_ColumnTableNo[nCol] := QMMasterDataTable."Table No.";

                        //No editable la columna de dimensi�n pro defecto
                        if (QMMasterDataTable."Is Default Dimension Table") then begin
                            nColMaster := nCol;
                            MATRIX_ColumnCaption[nCol] := '[D] ' + MATRIX_ColumnCaption[nCol];
                        end;
                    end;
                until (QMMasterDataTable.NEXT = 0) or (nCol = ARRAYLEN(MATRIX_CellData));
        end;
        seeColCom := (SeeInRows = SeeInRows::Empresas);
        seeColTab := (SeeInRows = SeeInRows::Tablas);

        CurrPage.UPDATE();
    end;

    // begin
    /*{
      JAV 22/04/22: - QM 1.00.02 Solo se pueden sincronizar tablas lanzandolo desde la empresa master
      JAV 28/04/22: - QM 1.00.04 Crear los datos de la tabla de dimensiones
    }*///end
}









