Codeunit 7207290 "Post reestimation"
{
  
  
    TableNo=7207315;
    trigger OnRun()
VAR
            PostingDateExists : Boolean;
            ReplacePostingDate : Boolean;
            PostingDate : Date;
            InitialEstimate : Boolean;
            DimensionValue : Record 349;
            FunctionQB : Codeunit 7207272;
            ReestimationLines : Record 7207316;
            GLEntry : Record 17;
            SourceCodeSetup : Record 242;
            SrcCode : Code[10];
            HistReestimationHeader : Record 7207317;
            QuoBuildingSetup : Record 7207278;
            NoSeriesManagement : Codeunit 396;
            LineCount : Integer;
            QBCommentLine : Record 7207270;
            MovBudgetForecast : Record 7207319;
            UpdateAnalysisView : Codeunit 410;
          BEGIN
            IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
              rec.VALIDATE(rec."Posting Date",PostingDate);
            CLEARALL;
            ReestimationHeader.COPY(Rec);
            WITH ReestimationHeader DO BEGIN

            //Comprobamos los campos obligatorios
              TESTFIELD("Job No.");
              TESTFIELD("Reestimation Code");
              TESTFIELD("Posting Date");
              TESTFIELD("Reestimation Date");
            END;

            Job2.GET(rec."Job No.");
            //Comprobamos los campos que deben de ser obligatorios al registrar el documento.
            Job2.TESTFIELD(Blocked,Job2.Blocked::" ");
            Job2.TESTFIELD("Budget Status",Job2."Budget Status"::Open);

            InitialEstimate := (Job2."Latest Reestimation Code" = '');
            //Copiamos las dimensiones.
            CheckDim;

            //Genero la reestimaci�n


            ReestimationHeader2 := Rec;
              Window.OPEN(
                '#1#################################\\' +
                text003 +
                Text005 +
                Text7000000);
            IF Job2."Latest Reestimation Code" = '' THEN BEGIN
              DimensionValue.SETRANGE("Dimension Code",FunctionQB.ReturnDimReest);
              DimensionValue.SETRANGE(Code,'',ReestimationHeader."Reestimation Code");
              IF DimensionValue.FINDLAST THEN BEGIN
                IF DimensionValue.NEXT(-1) <> 0 THEN
                  LatestReestimation := DimensionValue.Code
                ELSE
                  LatestReestimation := ''
              END ELSE
                LatestReestimation := '';
            END ELSE BEGIN
              LatestReestimation := Job2."Latest Reestimation Code";
            END;

            Window.UPDATE(1,STRSUBSTNO('%1',ReestimationHeader2."Job No."));
            IF Job2."Latest Reestimation Code" <> ReestimationHeader."Reestimation Code" THEN BEGIN
              EraseLatestReestCodMov;
              EraseCurrentMov;
              GetLastReesMov;
              GenMovTotalAmountCA;
              GenMovByForecastLine;
            END ELSE BEGIN
              EraseCurrentMov;
              GenMovTotalAmountCA;
              GenMovByForecastLine;
            END;

            //fin Genero la reestimaci�n
            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            GetGLSetup;


            //Comprobamos que el n� de serie de registro este relleno
            rec.TESTFIELD(rec."Posting Series No.");

            //Bloqueamos las tablas a usar
            IF rec.RECORDLEVELLOCKING THEN BEGIN
              ReestimationLines.LOCKTABLE;
              GLEntry.LOCKTABLE;
              IF GLEntry.FINDLAST THEN;
            END;

            //Tomamos el c�d. de origen.
            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup.Reestimation;

            QuoBuildingSetup.GET;
            QuoBuildingSetup.TESTFIELD("Serie for Reestimate Post");

            //Creo el documento que ir� al hist�rico
            HistReestimationHeader.INIT;
            HistReestimationHeader.TRANSFERFIELDS(ReestimationHeader);
            HistReestimationHeader."Pre-Assigned No. Series" := ReestimationHeader."Posting Series No.";

            //El n� del histor�co se tomara de una numeraci�n serie, ahora cojo el n� que viene y lo cambio un poco
            HistReestimationHeader."No." := NoSeriesManagement.GetNextNo(QuoBuildingSetup."Serie for Reestimate Post",ReestimationHeader."Posting Date",TRUE);
            Window.UPDATE(1,STRSUBSTNO(Text010,rec."No.",HistReestimationHeader."No."));

            HistReestimationHeader."Source Code" := SrcCode;
            HistReestimationHeader."User ID" := USERID;
            HistReestimationHeader."Dimension Set ID" := ReestimationHeader."Dimension Set ID";
            HistReestimationHeader.INSERT;

            CopyCommentLines(rec."No.",HistReestimationHeader."No.");

            // Lineas
            ReestimationLines.RESET;
            ReestimationLines.SETRANGE("Document No.",rec."No.");
            LineCount := 0;
            IF ReestimationLines.FINDSET(FALSE) THEN BEGIN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);
                ReestimationLines.CALCFIELDS(ReestimationLines."Estimated outstanding amount");
                HistReestimationLines.INIT;
                HistReestimationLines.TRANSFERFIELDS(ReestimationLines);
                HistReestimationLines."Estimated outstanding amount" := ReestimationLines."Estimated outstanding amount";
                HistReestimationLines."Total amount to estimated orig" := HistReestimationLines."Realized Amount" +
                            HistReestimationLines."Estimated outstanding amount";
                HistReestimationLines."Document No." :=  HistReestimationHeader."No.";
                HistReestimationLines."Dimension Set ID" := HistReestimationLines."Dimension Set ID";
                HistReestimationLines.INSERT;
              UNTIL ReestimationLines.NEXT = 0;
            END ELSE BEGIN
              ERROR(Text001);
            END;

            //No hay lineas, comprobar a ver que pasa.
            rec.DELETE;
            ReestimationLines.DELETEALL;

            QBCommentLine.SETRANGE("No.",rec."No.");
            QBCommentLine.DELETEALL;

            MovBudgetForecast.RESET;
            MovBudgetForecast.SETRANGE("Document No.",ReestimationHeader."No.");
            MovBudgetForecast.SETRANGE("Job No.",ReestimationHeader."Job No.");
            MovBudgetForecast.SETRANGE("Reestimation code",ReestimationHeader."Reestimation Code");
            IF MovBudgetForecast.FINDFIRST THEN
              MovBudgetForecast.DELETEALL;

            COMMIT;

            Window.CLOSE;

            UpdateAnalysisView.UpdateAll(0,TRUE);
            Rec := ReestimationHeader;
          END;
    VAR
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      text003 : TextConst ENU='Posting Budget Mov.           #3######\',ESP='Registrando Mov. ppto.           #3######\';
      Text004 : TextConst ENU='Reestimation',ESP='Reestimaci�n';
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas               #2######\';
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      Text032 : TextConst ENU='The combination of dimensions used in %1 %2 is blocked.',ESP='La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada';
      Text033 : TextConst ENU='The combination of dimensions used in %1 %2, line no. %3 is blocked.',ESP='La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada.';
      Text034 : TextConst ENU='The dimensions used in %1 %2 are invalid.',ESP='Las dimensiones usadas en %1 %2 son inv�lidas';
      Text035 : TextConst ENU='The dimensions used in %1 %2, line no. %3 are invalid.',ESP='Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos               #6######';
      LatestReestimation : Code[20];
      NoMov : Integer;
      LineCountCont : Integer;
      Window : Dialog;
      ReestimationHeader2 : Record 7207315;
      ReestimationHeader : Record 7207315;
      Job : Record 167;
      Job2 : Record 167;
      HistReestimationLines : Record 7207318;
      FunctionQB : Codeunit 7207272;

    PROCEDURE EraseLatestReestCodMov();
    VAR
      GLBudgetEntry : Record 96;
      ReestimationHeader : Record 7207315;
    BEGIN
      //Elimina todo movimiento para  la reestimaci�n - 1.
      RecompReestCode;
      GLBudgetEntry.RESET;
      GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Name", FunctionQB.ReturnBudgetJobs);
      GLBudgetEntry.SETRANGE("Budget Dimension 1 Code",ReestimationHeader."Job No.");
      GLBudgetEntry.SETRANGE("Budget Dimension 2 Code",LatestReestimation + '0');
      GLBudgetEntry.DELETEALL;
    END;

    PROCEDURE EraseCurrentMov();
    VAR
      GLBudgetEntry : Record 96;
      ReestimationHeader : Record 7207315;
    BEGIN
      //Elimina todo movimiento para la reestimaci�n de la cabecera del documento.
      GLBudgetEntry.RESET;
      GLBudgetEntry.SETRANGE(GLBudgetEntry."Budget Name", FunctionQB.ReturnBudget(Job2));   //JAV 28/06/21: - QB 1.09.03 Se cambia el campo en la tabla de proyecto que retorna el presupuesto anal�itico por la funci�n que nos lo retorna
      GLBudgetEntry.SETRANGE("Budget Dimension 1 Code",ReestimationHeader."Job No.");
      GLBudgetEntry.SETRANGE("Budget Dimension 2 Code",ReestimationHeader."Reestimation Code");
      GLBudgetEntry.DELETEALL;
    END;

    PROCEDURE GetLastReesMov();
    VAR
      GLBudgetEntry : Record 96;
      GLBudgetEntry2 : Record 96;
      ReestimationLines : Record 7207316;
    BEGIN
      //Busca los movimientos de la �ltima reestimaci�n y los crea con reestimaci�n -1.
      Job.GET(ReestimationHeader."Job No.");

      GLBudgetEntry.RESET;
      GLBudgetEntry.SETRANGE("Budget Name", FunctionQB.ReturnBudget(Job2));   //JAV 28/06/21: - QB 1.09.03 Se cambia el campo en la tabla de proyecto que retorna el presupuesto anal�itico por la funci�n que nos lo retorna
      GLBudgetEntry.SETRANGE("Budget Dimension 1 Code",ReestimationHeader2."Job No.");
      GLBudgetEntry.SETRANGE("Budget Dimension 2 Code",Job."Latest Reestimation Code");
      GLBudgetEntry.SETRANGE(Type);
      IF GLBudgetEntry.FINDSET(TRUE) THEN BEGIN
        CalcNoMov;
        RecompReestCode;
        REPEAT
          GLBudgetEntry2.INIT;
          GLBudgetEntry2.TRANSFERFIELDS(GLBudgetEntry);
          GLBudgetEntry2.Amount := - GLBudgetEntry2.Amount;
          GLBudgetEntry2."Budget Dimension 2 Code" := LatestReestimation + '0';
          GLBudgetEntry2."User ID" := USERID;
          GLBudgetEntry2.Type := ReestimationLines.Type;
          GLBudgetEntry2."Entry No." := NoMov;
          GLBudgetEntry2.INSERT(TRUE);
          NoMov := NoMov + 1;
          Window.UPDATE(3,STRSUBSTNO('%1',GLBudgetEntry."Entry No."));
        UNTIL GLBudgetEntry.NEXT = 0;
      END;
    END;

    PROCEDURE GenMovTotalAmountCA();
    VAR
      ReestimationLines : Record 7207316;
      ReestimationHeader : Record 7207315;
      GLBudgetEntry : Record 96;
      ReestimationHeader2 : Record 7207315;
    BEGIN
      //Crea un movimiento por CA y por importe realizado hasta fecha de reestimaci�n con c�digo de reestimaci�n el de la cabecera.
      CalcNoMov;
      ReestimationLines.RESET;
      ReestimationLines.SETRANGE("Document No.",ReestimationHeader."No.");
      ReestimationLines.SETFILTER("Realized Amount",'<>0');
      IF ReestimationLines.FINDSET(FALSE) THEN
        REPEAT
          GLBudgetEntry.INIT;
          GLBudgetEntry."Budget Name" := FunctionQB.ReturnBudget(Job2);   //JAV 28/06/21: - QB 1.09.03 Se cambia el campo en la tabla de proyecto que retorna el presupuesto anal�itico por la funci�n que nos lo retorna
          GLBudgetEntry."G/L Account No." := ReestimationLines."G/L Account";
          GLBudgetEntry.Date := ReestimationHeader."Reestimation Date";
          GLBudgetEntry."Global Dimension 1 Code" := ReestimationHeader."Shortcut Dimension 1 Code";
          GLBudgetEntry."Global Dimension 2 Code" := ReestimationLines."Analytical concept";
          GLBudgetEntry."Budget Dimension 1 Code" := ReestimationHeader."Job No.";
          GLBudgetEntry."Budget Dimension 2 Code" := ReestimationHeader."Reestimation Code";
          GLBudgetEntry.Type := ReestimationLines.Type;
          GLBudgetEntry."User ID" := USERID;
          GLBudgetEntry.Amount := ReestimationLines."Realized Amount";
          GLBudgetEntry."Entry No." := NoMov;
          GLBudgetEntry.INSERT(TRUE);
          NoMov := NoMov + 1;
          LineCountCont := LineCountCont + 1;
          Window.UPDATE(3,STRSUBSTNO('%1',LineCountCont));
        UNTIL ReestimationLines.NEXT = 0;

      //Actualiza los datos de la ficha del proyecto si la Fecha de reestimaci�n es posterior a la que hay en Proyecto
      IF ReestimationHeader2."Reestimation Code" <> Job2."Latest Reestimation Code" THEN
        CurrJobReestCode;
    END;

    PROCEDURE GenMovByForecastLine();
    VAR
      MovBudgetForecast : Record 7207319;
      ReestimationHeader : Record 7207315;
      ReestimationLines : Record 7207316;
      GLBudgetEntry : Record 96;
      ReestimationHeader2 : Record 7207315;
    BEGIN
      //Crea tantos movimientos con c�digo de reestimaci�n el de la cabecera del documento de reestimaci�n
      //como movimientos existan en la tabla de previsiones del pendiente.
      MovBudgetForecast.RESET;
      MovBudgetForecast.SETRANGE("Document No.",ReestimationHeader."No.");
      MovBudgetForecast.SETRANGE("Job No.",ReestimationHeader."Job No.");
      MovBudgetForecast.SETRANGE("Reestimation code",ReestimationHeader."Reestimation Code");

      IF MovBudgetForecast.FINDSET(FALSE) THEN BEGIN
        CalcNoMov;
        REPEAT
          ReestimationLines.GET(MovBudgetForecast."Document No.",MovBudgetForecast."Line No.");
          GLBudgetEntry.INIT;
          GLBudgetEntry."Budget Name" := FunctionQB.ReturnBudget(Job2);   //JAV 28/06/21: - QB 1.09.03 Se cambia el campo en la tabla de proyecto que retorna el presupuesto anal�itico por la funci�n que nos lo retorna
          GLBudgetEntry.Date := MovBudgetForecast."Forecast Date";
          GLBudgetEntry."Global Dimension 2 Code" := MovBudgetForecast."Anality Concept Code";
          GLBudgetEntry."Global Dimension 1 Code" := ReestimationHeader."Shortcut Dimension 1 Code";
          GLBudgetEntry."G/L Account No." := ReestimationLines."G/L Account";
          GLBudgetEntry."Budget Dimension 1 Code" := MovBudgetForecast."Job No.";
          GLBudgetEntry."Budget Dimension 2 Code" := ReestimationHeader."Reestimation Code";
          GLBudgetEntry.Description := MovBudgetForecast.Description;
          GLBudgetEntry."User ID" := USERID;
          GLBudgetEntry.Type := ReestimationLines.Type;
          GLBudgetEntry.Amount := MovBudgetForecast."Outstanding Temporary Forecast";
          GLBudgetEntry."Entry No." := NoMov;
          GLBudgetEntry.INSERT(TRUE);
          NoMov := NoMov + 1;
          LineCountCont := LineCountCont + 1;
          Window.UPDATE(3,STRSUBSTNO('%1',LineCountCont));
        UNTIL MovBudgetForecast.NEXT = 0;

      //Actualiza los datos de la ficha del proyecto si la Fecha de reestimaci�n es posterior a la que hay en Proyecto
        IF ReestimationHeader2."Reestimation Code" > Job2."Latest Reestimation Code" THEN
          CurrJobReestCode;
      END;
    END;

    LOCAL PROCEDURE GetGLSetup();
    VAR
      GLSetupRead : Boolean;
      GeneralLedgerSetup : Record 98;
    BEGIN
      IF NOT GLSetupRead THEN
        GeneralLedgerSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    VAR
      QBCommentLine : Record 7207270;
      QBCommentLine2 : Record 7207270;
    BEGIN
      QBCommentLine.SETRANGE("No.",FromNumber);
      IF QBCommentLine.FINDSET(TRUE) THEN
        REPEAT
         QBCommentLine2 := QBCommentLine;
         QBCommentLine2."No." := ToNumber;
         QBCommentLine2."Document Type" := QBCommentLine2."Document Type"::"Rest. Hist.";
         QBCommentLine2.INSERT;
       UNTIL QBCommentLine.NEXT = 0;
    END;

    PROCEDURE SetPostingDate(NewReplacePostingDate : Boolean;NewReplaceDocumentDate : Boolean;NewPostingDate : Date);
    VAR
      PostingDateExists : Boolean;
      ReplacePostingDate : Boolean;
      ReplaceDocumentDate : Boolean;
      PostingDate : Date;
    BEGIN
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      ReplaceDocumentDate := NewReplaceDocumentDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE Increment(VAR Number : Decimal;Number2 : Decimal);
    BEGIN
      Number := Number + Number2;
    END;

    PROCEDURE CurrJobReestCode();
    VAR
      Job : Record 167;
      ReestimationHeader : Record 7207315;
      ReestimationHeader2 : Record 7207315;
    BEGIN
      Job.GET(ReestimationHeader."Job No.");
      Job."Latest Reestimation Code" := ReestimationHeader2."Reestimation Code";
      Job."Last Date Modified":= ReestimationHeader2."Reestimation Date";
      Job.MODIFY;
    END;

    PROCEDURE CalcNoMov();
    VAR
      GLBudgetEntry : Record 96;
    BEGIN
      GLBudgetEntry.RESET;
      IF GLBudgetEntry.FINDLAST THEN
        NoMov := GLBudgetEntry."Entry No." +1
      ELSE
        NoMov := 1;
    END;

    PROCEDURE RecompReestCode();
    VAR
      NewCodReet : Text[30];
      NewCodReet2 : Date;
      Year : Text[2];
      Month : Text[2];
      Day : Text[2];
      Date : Text[30];
      IntYear : Integer;
      IntMonth : Integer;
      IntDay : Integer;
      NewCodReet4 : Date;
    BEGIN
      NewCodReet := COPYSTR(ReestimationHeader2."Reestimation Code",2);
      IF EVALUATE(NewCodReet2,NewCodReet) THEN BEGIN
        Year := COPYSTR(NewCodReet,1,2);
        Month := COPYSTR(NewCodReet,3,2);
        Day := COPYSTR(NewCodReet,5,2);
        Date := Day + Month + Year;
        NewCodReet2 := CALCDATE('-1D',NewCodReet2);

        IF EVALUATE(NewCodReet2,Date) THEN
          NewCodReet4 := CALCDATE('-1D',NewCodReet2);

      //Ahora vuelvo a formar el Cod. reestimac
        IntDay := DATE2DMY(NewCodReet4,1);
        IntMonth := DATE2DMY(NewCodReet4,2);
        IntYear := DATE2DMY(NewCodReet4,3);

        Year := COPYSTR(FORMAT(IntYear),3,2);
        Month := COPYSTR(FORMAT(IntMonth),1,2);
        Day := COPYSTR(FORMAT(IntDay),1,2);
        IF STRLEN(Month) = 1 THEN
          Month := '0' + Month;
        IF STRLEN(Day) = 1 THEN
          Day := '0' + Day;
        Date := 'R' + Year + Month + Day;
      END;
    END;

    LOCAL PROCEDURE CheckDim();
    VAR
      WorkSheetLines : Record 7207291;
      ReestimationHeader : Record 7207315;
    BEGIN
      WorkSheetLines."Line No." := 0;
      CheckDimValuePosting(WorkSheetLines);
      CheckDimComb(WorkSheetLines);

      WorkSheetLines.SETRANGE("Document No.",ReestimationHeader."No.");
      IF WorkSheetLines.FINDSET THEN
        REPEAT
          CheckDimComb(WorkSheetLines);
          CheckDimValuePosting(WorkSheetLines);
        UNTIL WorkSheetLines.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(WorkSheetLines : Record 7207291);
    VAR
      DimensionManagement : Codeunit 408;
      ReestimationHeader : Record 7207315;
    BEGIN
      IF WorkSheetLines."Line No." = 0 THEN
        IF NOT DimensionManagement.CheckDimIDComb(ReestimationHeader."Dimension Set ID") THEN
          ERROR(
            Text032,
            ReestimationHeader."No.",DimensionManagement.GetDimCombErr);

      IF WorkSheetLines."Line No." <> 0 THEN
        IF NOT DimensionManagement.CheckDimIDComb(WorkSheetLines."Dimension Set ID") THEN
          ERROR(
            Text033,
            ReestimationHeader."No.",WorkSheetLines."Line No.",DimensionManagement.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(VAR WorkSheetLines : Record 7207291);
    VAR
      TableIDArr : ARRAY [10] OF Integer;
      NumberArr : ARRAY [10] OF Code[20];
      ReestimationHeader : Record 7207315;
      DimensionManagement : Codeunit 408;
    BEGIN
      IF WorkSheetLines."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Job;
        NumberArr[1] := ReestimationHeader."Job No.";
        IF NOT DimensionManagement.CheckDimValuePosting(TableIDArr,NumberArr,ReestimationHeader."Dimension Set ID") THEN
          ERROR(
            Text034,
            Text004,ReestimationHeader."No.",DimensionManagement.GetDimValuePostingErr);
      END ELSE BEGIN
        TableIDArr[1] := DATABASE::Job;
        NumberArr[1] := WorkSheetLines."Job No.";
        IF NOT DimensionManagement.CheckDimValuePosting(TableIDArr,NumberArr,WorkSheetLines."Dimension Set ID") THEN
          ERROR(
            Text035,
            Text004,ReestimationHeader."No.",WorkSheetLines."Line No.",DimensionManagement.GetDimValuePostingErr);
      END;
    END;

    /*BEGIN
/*{
      JAV 28/06/21: - QB 1.09.03 Se cambia el campo en la tabla de proyecto que retorna el presupuesto anal�itico por la funci�n que nos lo retorna
    }
END.*/
}







