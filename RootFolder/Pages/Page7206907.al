page 7206907 "QB Job Responsible vs Circuit"
{
    CaptionML = ENU = 'Responsible/Circuit', ESP = 'Responsables/Circuitos';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7206988;
    PageType = List;
    SourceTableTemporary = true;
    PromotedActionCategoriesML = ENU = '1,Aspecto,3,Acciones', ESP = '1,Aspecto,3,Acciones';

    layout
    {
        area(content)
        {
            group("group5")
            {

                field("Pages"; Pages)
                {

                    CaptionML = ENU = 'Value Filter', ESP = 'P�gina';
                    // OptionCaptionML = ENU = 'Value Filter', ESP = 'P�gina';
                    Style = StrongAccent;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                field("gNo"; gNo)
                {

                    CaptionML = ESP = 'Proyecto/Departamento';
                    Editable = false;
                }
                field("gUseDocType"; gUseDocType)
                {

                    CaptionML = ESP = 'Filtrar por documento';

                    ; trigger OnValidate()
                    BEGIN
                        SetCols;
                    END;


                }
                field("QBApprovalCircuitHeader.Document Type"; QBApprovalCircuitHeader."Document Type")
                {

                    CaptionML = ESP = 'Tipo de Documento';
                    Enabled = gUseDocType;

                    ; trigger OnValidate()
                    BEGIN
                        gDocType := QBApprovalCircuitHeader."Document Type";
                        SetCols;
                    END;


                }

            }
            repeater("table")
            {

                field("Position"; rec."Position")
                {

                    Editable = false;
                }
                field("User ID"; rec."User ID")
                {

                    StyleExpr = TRUE;
                }
                field("User Name"; rec."User Name")
                {

                }
                field("No in Approvals"; rec."No in Approvals")
                {

                    StyleExpr = TRUE;
                }
                // group("group15")
                // {
                // }

                field("Field1"; MATRIX_CellData[1])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(1);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(1);
                    END;


                }
                field("Field2"; MATRIX_CellData[2])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(2);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(2);
                    END;


                }
                field("Field3"; MATRIX_CellData[3])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(3);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(3);
                    END;


                }
                field("Field4"; MATRIX_CellData[4])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(4);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(4);
                    END;


                }
                field("Field5"; MATRIX_CellData[5])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(5);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(5);
                    END;


                }
                field("Field6"; MATRIX_CellData[6])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(6);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(6);
                    END;


                }
                field("Field7"; MATRIX_CellData[7])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(7);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(7);
                    END;


                }
                field("Field8"; MATRIX_CellData[8])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(8);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(8);
                    END;


                }
                field("Field9"; MATRIX_CellData[9])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(9);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(9);
                    END;


                }
                field("Field10"; MATRIX_CellData[10])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(10);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(10);
                    END;


                }
                field("Field11"; MATRIX_CellData[11])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(11);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(11);
                    END;


                }
                field("Field12"; MATRIX_CellData[12])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(12);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(12);
                    END;


                }
                field("Field13"; MATRIX_CellData[13])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(13);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(13);
                    END;


                }
                field("Field14"; MATRIX_CellData[14])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(14);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(14);
                    END;


                }
                field("Field15"; MATRIX_CellData[15])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(15);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(15);
                    END;


                }
                field("Field16"; MATRIX_CellData[16])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(16);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(16);
                    END;


                }
                field("Field17"; MATRIX_CellData[17])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(17);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(17);
                    END;


                }
                field("Field18"; MATRIX_CellData[18])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(18);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(18);
                    END;


                }
                field("Field19"; MATRIX_CellData[19])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(19);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(19);
                    END;


                }
                field("Field20"; MATRIX_CellData[20])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(20);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(20);
                    END;


                }
                field("Field21"; MATRIX_CellData[21])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(21);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(21);
                    END;


                }
                field("Field22"; MATRIX_CellData[22])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(22);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(22);
                    END;


                }
                field("Field23"; MATRIX_CellData[23])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(23);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(23);
                    END;


                }
                field("Field24"; MATRIX_CellData[24])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(24);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(24);
                    END;


                }
                field("Field25"; MATRIX_CellData[25])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(25);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(25);
                    END;


                }
                field("Field26"; MATRIX_CellData[26])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(26);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(26);
                    END;


                }
                field("Field27"; MATRIX_CellData[27])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(27);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(27);
                    END;


                }
                field("Field28"; MATRIX_CellData[28])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(28);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(28);
                    END;


                }
                field("Field29"; MATRIX_CellData[29])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(29);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(29);
                    END;


                }
                field("Field30"; MATRIX_CellData[30])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(30);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(30);
                    END;


                }
                field("Field31"; MATRIX_CellData[31])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];
                    Editable = False;

                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(31);
                    END;

                    trigger OnAssistEdit()
                    BEGIN
                        MATRIX_OnAssistEdit(31);
                    END;


                }
                field("Field32"; MATRIX_CellData[32])
                {

                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];
                    Editable = False;



                    ; trigger OnValidate()
                    BEGIN
                        //++MATRIX_OnValidate(32);
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

        }
    }
    trigger OnOpenPage()
    BEGIN
        //Monto la tabla temporal que relaciona Personas con Circuitos
        tmpResponsibleCircuit.RESET;
        tmpResponsibleCircuit.DELETEALL;

        QBApprovalCircuitHeader.RESET;
        QBApprovalCircuitHeader.SETRANGE("Approval By", gAppType);
        IF (QBApprovalCircuitHeader.FINDSET(FALSE)) THEN
            REPEAT
                QBApprovalCircuitLines.RESET;
                IF (QBApprovalCircuitLines.FINDSET(FALSE)) THEN
                    REPEAT
                        QBJobResponsible.RESET;
                        QBJobResponsible.SETRANGE(Type, gType);
                        QBJobResponsible.SETRANGE("Table Code", gNo);
                        QBJobResponsible.SETRANGE(Position, QBApprovalCircuitLines.Position);
                        QBJobResponsible.SETRANGE("No in Approvals", FALSE);
                        IF (QBJobResponsible.FINDSET(FALSE)) THEN
                            REPEAT
                                tmpResponsibleCircuit.INIT;
                                tmpResponsibleCircuit.Position := QBJobResponsible.Position;
                                tmpResponsibleCircuit."User ID" := QBJobResponsible."User ID";
                                tmpResponsibleCircuit.Circuit := QBApprovalCircuitLines."Circuit Code";
                                tmpResponsibleCircuit.Order := QBApprovalCircuitLines."Approval Level";
                                IF (QBApprovalCircuitLines."Approval Unlim.") THEN
                                    tmpResponsibleCircuit."Circuit Data" := STRSUBSTNO('Nivel %1, Ilimitado', QBApprovalCircuitLines."Approval Level")
                                ELSE IF (QBApprovalCircuitLines."Approval Limit" = 0) THEN
                                    tmpResponsibleCircuit."Circuit Data" := STRSUBSTNO('Nivel %1, Sin importe', QBApprovalCircuitLines."Approval Level")
                                ELSE
                                    tmpResponsibleCircuit."Circuit Data" := STRSUBSTNO('Nivel %1, Importe %2', QBApprovalCircuitLines."Approval Level", QBApprovalCircuitLines."Approval Limit");
                                IF NOT tmpResponsibleCircuit.INSERT THEN;
                            UNTIL (QBJobResponsible.NEXT = 0);
                    UNTIL (QBApprovalCircuitLines.NEXT = 0);
            UNTIL (QBApprovalCircuitHeader.NEXT = 0);

        //Calcular p�ginas
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
        QBJobResponsible: Record 7206992;
        QBApprovalCircuitHeader: Record 7206986;
        QBApprovalCircuitLines: Record 7206987;
        tmpResponsibleCircuit: Record 7206988;
        PageNo: Integer;
        PageMax: Integer;
        Pages: Text;
        MatrixRecords: ARRAY[32] OF Record 2000000007;
        MATRIX_CellData: ARRAY[32] OF Text;
        MATRIX_ColumnCaption: ARRAY[32] OF Text;
        MATRIX_ColumnCircuit: ARRAY[32] OF Code[20];
        TableName: Text;
        nCol: Integer;
        nPag: Integer;
        seeColCom: Boolean;
        seeColTab: Boolean;
        "------------------- Parámetros globales": Integer;
        gType: Option;
        gNo: Code[20];
        gAppType: Option;
        gOrder: Code[20];
        gUseDocType: Boolean;
        gDocType: Option;

    LOCAL procedure MATRIX_OnDrillDown(ColumnID: Integer);
    begin
    end;

    LOCAL procedure MATRIX_OnAfterGetRecord();
    begin
        CLEAR(MATRIX_CellData);
        nCol := 1;
        WHILE (nCol <= ARRAYLEN(MATRIX_CellData)) DO begin
            if tmpResponsibleCircuit.GET(rec.Position, rec."User ID", MATRIX_ColumnCircuit[nCol]) then   //Si encuenta el valor lo pone en la casilla
                MATRIX_CellData[nCol] := tmpResponsibleCircuit."Circuit Data";
            nCol += 1;
        end;
    end;

    procedure MATRIX_OnValidate(ColumnID: Integer);
    begin
        //No hace nada aqu�
    end;

    LOCAL procedure MATRIX_OnAssistEdit(ColumnID: Integer);
    begin
        //Cambiamos el orden para verlo seg�n el orden en el circuito seleccionado
        if (MATRIX_ColumnCircuit[ColumnID] = '') then
            exit;

        gOrder := MATRIX_ColumnCircuit[ColumnID];
        SetRows;
    end;

    LOCAL procedure IsManualTable(pNro: Integer): Boolean;
    var
        result: Boolean;
    begin
        exit(pNro IN [DATABASE::Customer, DATABASE::Vendor, DATABASE::Resource, DATABASE::"Bank Account", DATABASE::Employee]);
    end;

    LOCAL procedure SetRows();
    begin
        //Preparar la tabla temporal para la pantalla
        Rec.RESET;
        Rec.DELETEALL;

        QBApprovalCircuitHeader.RESET;
        QBApprovalCircuitHeader.SETRANGE("Approval By", gAppType);
        if (gUseDocType) then
            QBApprovalCircuitHeader.SETRANGE("Document Type", gDocType);

        PageMax := 0;
        PageNo := QBApprovalCircuitHeader.COUNT;
        repeat
            PageMax += 1;
            PageNo -= ARRAYLEN(MATRIX_CellData);
        until (PageNo <= 0);
        PageNo := 1;
        Pages := STRSUBSTNO('%1 / %2', PageNo, PageMax);

        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, gType);
        QBJobResponsible.SETRANGE("Table Code", gNo);
        if (QBJobResponsible.FINDSET(FALSE)) then
            repeat
                Rec.INIT;
                Rec.Position := QBJobResponsible.Position;
                Rec."User ID" := QBJobResponsible."User ID";
                Rec."No in Approvals" := QBJobResponsible."No in Approvals";
                if (gOrder <> '') then begin
                    if (tmpResponsibleCircuit.GET(rec.Position, rec."User ID", gOrder)) then
                        Rec.Order := tmpResponsibleCircuit.Order
                    ELSE
                        Rec.Order := 99999; //Para que se pongan al final
                end;
                if not Rec.INSERT then;
            until (QBJobResponsible.NEXT = 0);

        Rec.RESET;
        Rec.SETCURRENTKEY(Order);
    end;

    LOCAL procedure SetCols();
    begin
        //Cargar nombres de columnas
        Pages := STRSUBSTNO('%1 / %2', PageNo, PageMax);

        CLEAR(MATRIX_ColumnCaption);
        CLEAR(MATRIX_ColumnCircuit);
        nPag := 0;
        nCol := 0;
        QBApprovalCircuitHeader.RESET;
        QBApprovalCircuitHeader.SETRANGE("Approval By", gAppType);
        if (gUseDocType) then
            QBApprovalCircuitHeader.SETRANGE("Document Type", gDocType);

        if (QBApprovalCircuitHeader.FINDSET(FALSE)) then
            repeat
                nPag += 1;
                if (nPag >= ((PageNo - 1) * ARRAYLEN(MATRIX_CellData)) + 1) and (nPag <= (PageNo * ARRAYLEN(MATRIX_CellData))) then begin
                    nCol += 1;
                    if (gUseDocType) then
                        MATRIX_ColumnCaption[nCol] := QBApprovalCircuitHeader."Circuit Code" + ':' + QBApprovalCircuitHeader.Description
                    ELSE
                        MATRIX_ColumnCaption[nCol] := QBApprovalCircuitHeader."Circuit Code" + ' (' + FORMAT(QBApprovalCircuitHeader."Document Type") + '): ' + QBApprovalCircuitHeader.Description;
                    MATRIX_ColumnCircuit[nCol] := QBApprovalCircuitHeader."Circuit Code";
                end;
            until (QBApprovalCircuitHeader.NEXT = 0) or (nCol = ARRAYLEN(MATRIX_CellData));

        CurrPage.UPDATE(FALSE);
    end;

    procedure SetJob(pType: Option; pJob: Code[20]);
    begin
        gType := pType;
        gNo := pJob;
        gUseDocType := FALSE;

        CASE gType OF
            QBJobResponsible.Type::Job:
                gAppType := QBApprovalCircuitHeader."Approval By"::Job;
            QBJobResponsible.Type::Department:
                gAppType := QBApprovalCircuitHeader."Approval By"::Department;
            ELSE
                gAppType := 50; //Este valor no retornar� ning�n resultado
        end;
    end;

    // begin
    /*{
      JAV 01/07/22: - QB 1.10.58 Se cambia Update por Update(false) para evitar errores
    }*///end
}








