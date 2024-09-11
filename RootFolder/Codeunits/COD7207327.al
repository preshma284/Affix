Codeunit 7207327 "Record Costsheet"
{
  
  
    TableNo=7207433;
    Permissions=TableData 7207290=m,
                TableData 7207291=m,
                TableData 7207435=rimd,
                TableData 7207436=rimd;
    trigger OnRun()
VAR
            ItemChargeAssignmentPurch : Record 5805;
            CUUpdateAnalysisView : Codeunit 410;
            CostBaseAmount : Decimal;
            DiscountVATAmount : Decimal;
            Resource : Record 156;
            ResourcesSetup : Record 314;
          BEGIN
            IF PostingDateExists AND (ReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
              rec.VALIDATE("Posting Date",PostingDate);
            CLEARALL;

            CostsheetHeader.COPY(Rec);
            WITH CostsheetHeader DO BEGIN
            //Comprobamos los campos que deben de ser obligatorios al registrar el documento.
              TESTFIELD("Job No.");
              TESTFIELD("Posting Date");
              IF "Validated Sheet" = FALSE THEN
                ERROR(text011);
            END;

            //Copiamos las dimensiones.
            CheckDim;

            Window.OPEN(
              '#1#################################\\' +
              Text005 +
              Text006 +
              Text008 +
              Text7000000);

            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            GetGLSetup;

            //Comprobamos que el n� de serie de registro este relleno
            rec.TESTFIELD("Posting No. Series");

            //Bloqueamos las tablas a usar
            IF rec.RECORDLEVELLOCKING THEN BEGIN
              CostsheetLines.LOCKTABLE;
              JobLedgerEntry.LOCKTABLE;
              IF JobLedgerEntry.FINDLAST THEN;
            END;

            //Tomamos el c�d. de origen.
            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup."Job Journal";

            CreateHeaderHist;

            // Lineas
            CostsheetLines.RESET;
            CostsheetLines.SETRANGE("Document No.",rec."No.");
            LineCount := 0;
            IF CostsheetLines.FINDSET(FALSE) THEN BEGIN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);
                CtrlLine;
                InsertHist;
                CreateJobMov;
                CreateAccountingMov;
              UNTIL CostsheetLines.NEXT = 0;
            END ELSE BEGIN
              ERROR(Text001);
            END;

            rec.DELETE;
            CostsheetLines.DELETEALL;

            QBCommentLine.SETRANGE("No.",rec."No.");
            QBCommentLine.DELETEALL;

            COMMIT;
            CLEAR(JobJournalLine);

            Window.CLOSE;

            CUUpdateAnalysisView.UpdateAll(0,TRUE);
            Rec := CostsheetHeader;
          END;
    VAR
      GeneralLedgerSetup : Record 98;
      JobLedgerEntry : Record 169;
      CostsheetHeaderHist : Record 7207435;
      CostsheetLinesHist : Record 7207436;
      JobJournalLine : Record 210;
      SourceCodeSetup : Record 242;
      QBCommentLine : Record 7207270;
      QBCommentLine2 : Record 7207270;
      CUJobJnlPostLine : Codeunit 1012;
      CUDimensionManagement : Codeunit 408;
      Window : Dialog;
      PostingDate : Date;
      GenJnlLineDocNo : Code[20];
      SrcCode : Code[10];
      LineCount : Integer;
      PostingDateExists : Boolean;
      ReplacePostingDate : Boolean;
      ReplaceDocumentDate : Boolean;
      GLSetupRead : Boolean;
      JobsSetup : Record 315;
      CUNoSeriesManagement : Codeunit 396;
      Job : Record 167;
      CostsheetHeader : Record 7207433;
      CUFunctionQB : Codeunit 7207272;
      CUGenJnlPostLine : Codeunit 12;
      Cesion : Boolean;
      CostsheetLines : Record 7207434;
      Currency : Record 4;
      JobCont : Integer;
      RecCont : Integer;
      ContCont : Integer;
      UnitsPostingGroup : Record 7207431;
      Piecework : Record 7207277;
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas         #2######\';
      Text006 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando Proyecto       #3######\';
      Text008 : TextConst ESP='Registrando Contabilidad   #5######\';
      Text009 : TextConst ENU='Posting lines         #2######',ESP='Registrando l�neas         #2######';
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      Text023 : TextConst ENU='in the associated blanket order must not be greater than %1',ESP='en el pedido abierto asociado no debe ser superior a %1';
      Text024 : TextConst ENU='in the associated blanket order must be reduced.',ESP='en el pedido abierto asociado se debe reducir.';
      Text032 : TextConst ENU='The combination of dimensions used in %1 %2 is blocked.',ESP='La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada.';
      Text033 : TextConst ENU='The combination of dimensions used in %1 %2, line no. %3 is blocked.',ESP='La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada.';
      Text034 : TextConst ENU='The dimensions used in %1 %2 are invalid.',ESP='Las dimensiones usadas en %1 %2 son inv�lidas';
      Text035 : TextConst ENU='The dimensions used in %1 %2, line no. %3 are invalid.',ESP='Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos         #6######';
      Text036 : TextConst ESP='Parte';
      text011 : TextConst ESP='El parte debe estar validado';

    PROCEDURE SetPostingDate(NewReplacePostingDate : Boolean;NewReplaceDocumentDate : Boolean;NewPostingDate : Date);
    BEGIN
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      ReplaceDocumentDate := NewReplaceDocumentDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      QBCommentLine.SETRANGE("No.",FromNumber);
      IF QBCommentLine.FINDSET(TRUE) THEN
        REPEAT
         QBCommentLine."Document Type" := QBCommentLine."Document Type"::"Sheet Hist.";
         QBCommentLine2 := QBCommentLine;
         QBCommentLine2."No." := ToNumber;
         QBCommentLine2.INSERT;
       UNTIL QBCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetGLSetup();
    BEGIN
      IF NOT GLSetupRead THEN
        GeneralLedgerSetup.GET;
      GLSetupRead := TRUE;
    END;

    PROCEDURE CreateHeaderHist();
    BEGIN
      //Creo el documento que ir� al hist�rico
      CostsheetHeaderHist.INIT;
      CostsheetHeaderHist.TRANSFERFIELDS(CostsheetHeader);
      CostsheetHeaderHist."No. Series" :=  CostsheetHeader."Posting No. Series";
      CostsheetHeaderHist."No." := CUNoSeriesManagement.GetNextNo(CostsheetHeader."Posting No. Series",CostsheetHeader."Posting Date",TRUE);
      Window.UPDATE(1,STRSUBSTNO(Text010,CostsheetHeader."No.",CostsheetHeaderHist."No."));

      CostsheetHeaderHist."Source Code" := SrcCode;
      CostsheetHeaderHist."User ID" := USERID;
      CostsheetHeaderHist."Dimension Set ID" := CostsheetHeader."Dimension Set ID";
      CostsheetHeaderHist.INSERT(TRUE);

      CopyCommentLines(CostsheetHeader."No.",CostsheetHeaderHist."No.");
      GenJnlLineDocNo :=  CostsheetHeaderHist."No.";
    END;

    PROCEDURE CreateJobMov();
    VAR
      LOCResourceCost : Record 202;
    BEGIN
      JobCont += 1;
      Window.UPDATE(3,JobCont);

      JobJournalLine.INIT;
      JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;        //primer apunte "Consumo"
      JobJournalLine."Job No." := CostsheetHeader."Job No.";                      //el de la cabecera
      JobJournalLine.VALIDATE("Posting Date",CostsheetHeader."Posting Date");
      JobJournalLine."Document No." :=  CostsheetHeaderHist."No.";
      JobJournalLine.Type := JobJournalLine.Type::"G/L Account";
      JobJournalLine."No." := UnitsPostingGroup."Cost Account";

      JobJournalLine.Description := CostsheetLines.Description;
      JobJournalLine.VALIDATE(Quantity,1);
      JobJournalLine.VALIDATE("Unit Cost (LCY)",CostsheetLines.Amount);
      JobJournalLine."Unit Price (LCY)" := 0;
      JobJournalLine."Piecework Code" := CostsheetLines."Unit Cost No.";
      JobJournalLine."Shortcut Dimension 1 Code" := CostsheetLines."Shortcut Dimension 1 Code";
      JobJournalLine."Shortcut Dimension 2 Code" := CostsheetLines."Shortcut Dimension 2 Code";
      //JMMA DIMENSIONES DE CABECERA NO LINEAS JobJournalLine."Dimension Set ID" := CostsheetLines."Dimension Set ID";
      JobJournalLine."Dimension Set ID" := CostsheetHeader."Dimension Set ID";

      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimCA,UnitsPostingGroup."Cost Analytic Concept",JobJournalLine."Dimension Set ID");
      CUDimensionManagement.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID",JobJournalLine."Shortcut Dimension 1 Code",JobJournalLine."Shortcut Dimension 2 Code");

      JobJournalLine."Source Code" := SrcCode;
      JobJournalLine."Posting No. Series" := CostsheetHeader."Posting No. Series";
      JobJournalLine."Job Closure Entry" := TRUE;

      CUJobJnlPostLine.RunWithCheck(JobJournalLine);

      //JAV 08/07/19: - Dar un error si no existe la cuenta
      IF (UnitsPostingGroup."Entry Account" = '') THEN
        ERROR('No ha definido %2 en %1', UnitsPostingGroup.TABLECAPTION, UnitsPostingGroup.FIELDCAPTION("Entry Account"));

      JobCont += 1;
      Window.UPDATE(3,JobCont);

      JobJournalLine.INIT;
      JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Sale;          // segundo apunte "Venta"
      JobJournalLine."Job No." := CostsheetLines."Invoicing Job";          //el de las lineas
      JobJournalLine.VALIDATE("Posting Date",CostsheetHeader."Posting Date");
      JobJournalLine."Document No." :=  CostsheetHeaderHist."No.";
      JobJournalLine.Type := JobJournalLine.Type::"G/L Account";
      JobJournalLine."No." := UnitsPostingGroup."Entry Account";
      JobJournalLine.Description := CostsheetLines.Description;
      JobJournalLine.VALIDATE(Quantity,1);
      JobJournalLine."Unit Cost (LCY)" := 0;
      JobJournalLine.VALIDATE("Unit Price (LCY)",CostsheetLines.Amount);
      JobJournalLine."Piecework Code" := '';
      JobJournalLine."Dimension Set ID" := CostsheetLines."Dimension Set ID";

      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimCA,UnitsPostingGroup."Cost Analytic Concept",JobJournalLine."Dimension Set ID");
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimDpto,CUFunctionQB.GetDepartment(DATABASE::Job,CostsheetLines."Invoicing Job"),JobJournalLine."Dimension Set ID");
      CUDimensionManagement.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID",JobJournalLine."Shortcut Dimension 1 Code",JobJournalLine."Shortcut Dimension 2 Code");

      JobJournalLine."Source Code" := SrcCode;
      JobJournalLine."Posting No. Series" := CostsheetHeader."Posting No. Series";

      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimJobs,CostsheetLines."Invoicing Job",JobJournalLine."Dimension Set ID");
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimDpto,CUFunctionQB.GetDepartment(DATABASE::Job,CostsheetLines."Invoicing Job"),JobJournalLine."Dimension Set ID");
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimCA,UnitsPostingGroup."Cost Analytic Concept",JobJournalLine."Dimension Set ID");
      CUDimensionManagement.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID",JobJournalLine."Shortcut Dimension 1 Code",JobJournalLine."Shortcut Dimension 2 Code");
      CUJobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE CreateAccountingMov();
    VAR
      LOCGenJournalLine : Record 81;
      LOCResourceCost : Record 202;
      LOCGLAccount : Record 15;
    BEGIN
      ContCont += 1;
      Window.UPDATE(5,ContCont);

      LOCGenJournalLine.INIT;
      LOCGenJournalLine."Posting Date" := CostsheetHeader."Posting Date";
      LOCGenJournalLine."Account Type" := LOCGenJournalLine."Account Type"::"G/L Account";
      LOCGenJournalLine."Account No." := UnitsPostingGroup."Cost Account";                     //primer apunte
      LOCGLAccount.GET(UnitsPostingGroup."Cost Account");
      LOCGenJournalLine.Description := LOCGLAccount.Name;
      LOCGenJournalLine."Shortcut Dimension 1 Code" := CostsheetLines."Shortcut Dimension 1 Code";
      LOCGenJournalLine."Shortcut Dimension 2 Code" := CostsheetLines."Shortcut Dimension 2 Code";

      //JMMA TRAER DIMENSI�N DE CABECERA NO DE L�NEAS LOCGenJournalLine."Dimension Set ID" := CostsheetLines."Dimension Set ID";
      LOCGenJournalLine."Dimension Set ID" := CostsheetHeader."Dimension Set ID";
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimCA,UnitsPostingGroup."Cost Analytic Concept",JobJournalLine."Dimension Set ID");
      CUDimensionManagement.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID",JobJournalLine."Shortcut Dimension 1 Code",JobJournalLine."Shortcut Dimension 2 Code");

      LOCGenJournalLine."Document Type" := LOCGenJournalLine."Document Type"::" ";
      LOCGenJournalLine."Document No." := CostsheetHeaderHist."No.";
      LOCGenJournalLine.VALIDATE(Amount,CostsheetLines.Amount);
      LOCGenJournalLine.Correction := FALSE;

      LOCGenJournalLine."Source Type" := LOCGenJournalLine."Source Type"::" ";
      LOCGenJournalLine."Source Code" := SrcCode;
      LOCGenJournalLine."Already Generated Job Entry" := TRUE;
      LOCGenJournalLine."Usage/Sale" := LOCGenJournalLine."Usage/Sale"::Usage;
      LOCGenJournalLine."Job No." := CostsheetHeader."Job No.";                         // el de la cabecera
      LOCGenJournalLine."Piecework Code" := CostsheetLines."Unit Cost No.";
      LOCGenJournalLine."Job Closure Entry" := TRUE;

      //JAV 08/07/19: - Se validan las dimensiones globales para que tomen su valor correcto
      LOCGenJournalLine.VALIDATE("Shortcut Dimension 1 Code", CostsheetHeader."Shortcut Dimension 1 Code"); //Esta debe salir de la cabecera
      LOCGenJournalLine.VALIDATE("Shortcut Dimension 2 Code");
      LOCGenJournalLine.VALIDATE("Job No.");
      //JAV fin


      CUGenJnlPostLine.RunWithCheck(LOCGenJournalLine);

      ContCont += 1;
      Window.UPDATE(5,ContCont);

      LOCGenJournalLine.INIT;
      LOCGenJournalLine."Posting Date" := CostsheetHeader."Posting Date";
      LOCGenJournalLine."Account Type" := LOCGenJournalLine."Account Type"::"G/L Account";
      LOCGenJournalLine."Account No." := UnitsPostingGroup."Entry Account";                  // segundo apunte

      LOCGLAccount.GET(UnitsPostingGroup."Entry Account");
      LOCGenJournalLine.Description := LOCGLAccount.Name;

      LOCGenJournalLine."Shortcut Dimension 1 Code" := CostsheetLines."Shortcut Dimension 1 Code";
      LOCGenJournalLine."Shortcut Dimension 2 Code" := CostsheetLines."Shortcut Dimension 2 Code";
      LOCGenJournalLine."Dimension Set ID" := CostsheetLines."Dimension Set ID";
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimCA,UnitsPostingGroup."Cost Analytic Concept",JobJournalLine."Dimension Set ID");
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimDpto,CUFunctionQB.GetDepartment(DATABASE::Job,CostsheetLines."Invoicing Job"),JobJournalLine."Dimension Set ID");
      CUDimensionManagement.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID",JobJournalLine."Shortcut Dimension 1 Code",JobJournalLine."Shortcut Dimension 2 Code");

      LOCGenJournalLine."Document Type" := LOCGenJournalLine."Document Type"::" ";
      LOCGenJournalLine."Document No." := CostsheetHeaderHist."No.";

      LOCGenJournalLine.VALIDATE(Amount,-CostsheetLines.Amount);
      LOCGenJournalLine.Correction := FALSE;
      LOCGenJournalLine."Source Type" := LOCGenJournalLine."Source Type"::" ";
      LOCGenJournalLine."Source Code" := SrcCode;
      LOCGenJournalLine."Already Generated Job Entry" := TRUE;
      LOCGenJournalLine."Usage/Sale" := LOCGenJournalLine."Usage/Sale"::Sale;
      LOCGenJournalLine."Job No." := CostsheetLines."Invoicing Job";               // el de las lineas
      LOCGenJournalLine."Job Closure Entry" := TRUE;

      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimJobs,CostsheetLines."Invoicing Job",JobJournalLine."Dimension Set ID");
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimCA,UnitsPostingGroup."Cost Analytic Concept",JobJournalLine."Dimension Set ID");
      CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimDpto,CUFunctionQB.GetDepartment(DATABASE::Job,CostsheetLines."Invoicing Job"),JobJournalLine."Dimension Set ID");
      CUDimensionManagement.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID",JobJournalLine."Shortcut Dimension 1 Code",JobJournalLine."Shortcut Dimension 2 Code");
      CUGenJnlPostLine.RunWithCheck(LOCGenJournalLine);
    END;

    PROCEDURE InsertHist();
    BEGIN
      CostsheetLinesHist.INIT;
      CostsheetLinesHist.TRANSFERFIELDS(CostsheetLines);
      CostsheetLinesHist."Document No." :=  CostsheetHeaderHist."No.";
      CostsheetLinesHist."Dimension Set ID" := CostsheetLines."Dimension Set ID";
      CostsheetLinesHist.INSERT;
    END;

    PROCEDURE CtrlLine();
    VAR
      LOCDataPieceworkForProduction : Record 7207386;
    BEGIN
      LOCDataPieceworkForProduction.GET(CostsheetHeader."Job No.",CostsheetLines."Unit Cost No.");
      UnitsPostingGroup.GET(LOCDataPieceworkForProduction."Posting Group Unit Cost");
      UnitsPostingGroup.TESTFIELD("Cost Account");
      UnitsPostingGroup.TESTFIELD("Cost Analytic Concept");
    END;

    LOCAL PROCEDURE CheckDim();
    VAR
      LOCCostsheetLines2 : Record 7207434;
    BEGIN
      LOCCostsheetLines2."Line No." := 0;
      CheckDimValuePosting(LOCCostsheetLines2);
      CheckDimComb(LOCCostsheetLines2);

      LOCCostsheetLines2.SETRANGE("Document No.",CostsheetHeader."No.");
      IF LOCCostsheetLines2.FINDSET THEN
        REPEAT
          CheckDimComb(LOCCostsheetLines2);
          CheckDimValuePosting(LOCCostsheetLines2);
        UNTIL LOCCostsheetLines2.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(LOCCostsheetLines2 : Record 7207434);
    BEGIN
      IF LOCCostsheetLines2."Line No." = 0 THEN
        IF NOT CUDimensionManagement.CheckDimIDComb(CostsheetHeader."Dimension Set ID") THEN
          ERROR(
            Text032,
            CostsheetHeader."No.",CUDimensionManagement.GetDimCombErr);

      IF LOCCostsheetLines2."Line No." <> 0 THEN
        IF NOT CUDimensionManagement.CheckDimIDComb(LOCCostsheetLines2."Dimension Set ID") THEN
          ERROR(
            Text033,
            CostsheetHeader."No.",LOCCostsheetLines2."Line No.",CUDimensionManagement.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting(LOCCostsheetLines2 : Record 7207434);
    VAR
      TableIDArr : ARRAY [10] OF Integer;
      NumberArr : ARRAY [10] OF Code[20];
    BEGIN
      IF LOCCostsheetLines2."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Job;
        NumberArr[1] := LOCCostsheetLines2."Invoicing Job";
        IF NOT CUDimensionManagement.CheckDimValuePosting(TableIDArr,NumberArr,CostsheetHeader."Dimension Set ID") THEN
          ERROR(
            Text034,
            CostsheetHeader."No.",CUDimensionManagement.GetDimValuePostingErr);
      END ELSE BEGIN
        TableIDArr[1] := DATABASE::Job;
        NumberArr[1] := LOCCostsheetLines2."Invoicing Job";

        IF NOT CUDimensionManagement.CheckDimValuePosting(TableIDArr,NumberArr,LOCCostsheetLines2."Dimension Set ID") THEN
          ERROR(
            Text035,
            CostsheetHeader."No.",LOCCostsheetLines2."Line No.",CUDimensionManagement.GetDimValuePostingErr);
      END;
    END;

    /*BEGIN
/*{
      JAV 08/07/19: - Dar un error si no existe la cuenta
      JAV 08/07/19: - Se validan las dimensiones globales para que tomen su valor correcto
    }
END.*/
}







