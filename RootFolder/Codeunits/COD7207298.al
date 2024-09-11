Codeunit 7207298 "Transfers Between Jobs Post"
{
  
  
    TableNo=7207286;
    Permissions=TableData 7207288=rimd,
                TableData 7207289=rimd;
    trigger OnRun()
BEGIN
            CLEARALL;
            Cab.COPY(Rec);
            Cab.TESTFIELD("Posting Date");

            Window.OPEN(
              Text004 +
              Text005 +
              Text006);

            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            GeneralLedgerSetup.GET;
            QuoBuildingSetup.GET;


            //Comprobamos que el n� de serie de registro este relleno
            rec.TESTFIELD(rec."Posting No. Series");

            //Bloqueamos las tablas a usar
            IF rec.RECORDLEVELLOCKING THEN BEGIN
              Lin.LOCKTABLE;
              JobLedgerEntry.LOCKTABLE;
              IF JobLedgerEntry.FINDLAST THEN;
              IF GLEntry.FINDLAST THEN;
            END;

            //Tomamos el c�d. de origen.
            SourceCodeSetup.GET;
            SrcCode := SourceCodeSetup."Charges and Discharge";

            CreateHeaderPosted;

            CLEAR(JobJournalLine);
            CLEAR(GenJnlLine);

            // Lineas
            Lin.RESET;
            Lin.SETRANGE("Document No.",rec."No.");
            Lin.SETFILTER(Lin.Amount, '<>0');
            IF (Lin.ISEMPTY) THEN
              ERROR(Text001);

            IF Lin.FINDSET(FALSE) THEN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);

                CtrlLine;     //Verificar los datos de la l�nea
                CreateEntry;  //Crear los diarios

                //Pasar al hist�rico y eliminar la l�nea
                CreateLinesPosted;
                Lin.DELETE;
              UNTIL Lin.NEXT = 0;

            rec.DELETE;

            CLEAR(JobJournalLine);
            CLEAR(GenJnlLine);

            Window.CLOSE;

            UpdateAnalysisView.UpdateAll(0,TRUE);
            Rec := Cab;
          END;
    VAR
      GeneralLedgerSetup : Record 98;
      QuoBuildingSetup : Record 7207278;
      Cab : Record 7207286;
      Lin : Record 7207287;
      RegCab : Record 7207288;
      RegLin : Record 7207289;
      QBCommentLine : Record 7207270;
      QBCommentLine2 : Record 7207270;
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      JobJournalLine : Record 210;
      Currency : Record 4;
      Text037 : TextConst ENU='Can not do a charge charge to the same project, piecework, department and  C.A.',ESP='No se puede hacer un traspaso al mismo proyecto, unidad de obra, departamento y Concepto Anal�tico';
      Text004 : TextConst ESP='#1#################################\\';
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas         #2######\';
      Text006 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos         #3######';
      JobLedgerEntry : Record 169;
      GLEntry : Record 17;
      SourceCodeSetup : Record 242;
      Text038 : TextConst ENU='The document should give a balance of zero (%1)',ESP='El documento debe dar un saldo de cero (%1)';
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';
      Text002 : TextConst ESP='Traspaso a %2: %3';
      Text003 : TextConst ESP='Traspaso desde %1: %3';
      LDefaultDimension : Record 352;
      GenJnlLine : Record 81;
      NoSeriesManagement : Codeunit 396;
      DimensionManagement : Codeunit 408;
      FunctionQB : Codeunit 7207272;
      JobJnlPostLine : Codeunit 1012;
      GenJnlPostLine : Codeunit 12;
      UpdateAnalysisView : Codeunit 410;
      Window : Dialog;
      SrcCode : Code[10];
      LineCount : Integer;
      LineNo : Integer;

    PROCEDURE CtrlLine();
    VAR
      GLAccount : Record 15;
      Job : Record 167;
    BEGIN
      Lin.TESTFIELD("Allocation Account of Transfe");
      GLAccount.GET(Lin."Allocation Account of Transfe");
      Lin.TESTFIELD(Amount);

      Lin.TESTFIELD("Origin Job No.");
      Lin.TESTFIELD("Origin C.A.");
      Lin.TESTFIELD("Origin Departament");
      //Lin.TESTFIELD("Origin Piecework");
      //Q20308-
      IF (Job.GET(Lin."Origin Job No.")) AND (Job."Mandatory Allocation Term By" <> Job."Mandatory Allocation Term By"::"Not necessary") THEN
        Lin.TESTFIELD("Origin Piecework");
      //Q20308+

      Lin.TESTFIELD("Destination Job No.");
      Lin.TESTFIELD("Destination C.A.");
      Lin.TESTFIELD("Destination Departament");
      //Lin.TESTFIELD("Destination Piecework");
      //Q20308-
      IF (Job.GET(Lin."Destination Job No.")) AND (Job."Mandatory Allocation Term By" <> Job."Mandatory Allocation Term By"::"Not necessary") THEN
        Lin.TESTFIELD("Destination Piecework");
      //Q20308+

      IF (Lin."Origin Job No." = Lin."Destination Job No.") AND
         (Lin."Origin C.A." = Lin."Destination C.A.") AND
         //Q20308-
         ((Lin."Origin Piecework" <> '') AND (Lin."Destination Piecework" <> '') AND (Lin."Origin Piecework" = Lin."Destination Piecework")) AND
         //Q20308+
         (Lin."Origin Departament" = Lin."Destination Departament") THEN
        ERROR(Text037);
    END;

    PROCEDURE CreateEntry();
    VAR
      amount : Decimal;
    BEGIN
      //L�nea del diario general
      IF Lin."Document Type" = Lin."Document Type"::Costs THEN
        amount := -Lin.Amount
      ELSE
        amount := Lin.Amount;

      CreateEntryJob(Text002, amount, Lin."Origin Job No.", Lin."Origin Departament", Lin."Origin C.A.",
                     Lin."Origin Piecework", Lin."Origin Task No.", Lin."Origin Dimension Set ID");
      CreateEntryJob(Text003, -amount, Lin."Destination Job No.", Lin."Destination Departament", Lin."Destination C.A.",
                     Lin."Destination Piecework", Lin."Destination Task No.", Lin."Destination Dimension Set ID");
      CreateEntryAcc(Text002, amount, Lin."Origin Job No.", Lin."Origin Departament", Lin."Origin C.A.",
                     Lin."Origin Piecework", Lin."Origin Task No.", Lin."Origin Dimension Set ID");
      CreateEntryAcc(Text003, -amount, Lin."Destination Job No.", Lin."Destination Departament", Lin."Destination C.A.",
                     Lin."Destination Piecework", Lin."Destination Task No.", Lin."Destination Dimension Set ID");
    END;

    PROCEDURE CreateEntryJob(pText : Text;pAmount : Decimal;pJob : Code[20];pDep : Code[20];pCA : Code[20];pPiecework : Code[20];pTask : Code[20];pDim : Integer);
    BEGIN
      //L�nea del diario de proyectos

      JobJournalLine.INIT;
      JobJournalLine."Posting Date" := Cab."Posting Date";
      JobJournalLine."Document No." :=  RegCab."No.";
      JobJournalLine."Source Code" := SrcCode;
      JobJournalLine."Document Date" := Cab."Posting Date";
      JobJournalLine."External Document No." :=  RegCab."No.";
      JobJournalLine."Posting No. Series" := Cab."Posting No. Series";
      JobJournalLine.VALIDATE("Job No.",pJob);
      JobJournalLine."Piecework Code" := pPiecework;
      JobJournalLine."Job Task No." := Lin."Origin Task No.";
      JobJournalLine.Description := COPYSTR(STRSUBSTNO(pText, Lin."Origin Job No.", Lin."Destination Job No.", Lin.Description), 1, MAXSTRLEN(JobJournalLine.Description));
      JobJournalLine.Type := JobJournalLine.Type::"G/L Account";
      JobJournalLine."No." := Lin."Allocation Account of Transfe";

      IF pAmount > 0 THEN
        JobJournalLine.VALIDATE(Quantity, 1)
      ELSE
        JobJournalLine.VALIDATE(Quantity, -1);
      //JMMA 23/09/20: En el movimiento de proyecto cambiar el signo si es �facturaci�n�.
      IF Lin."Document Type"=Lin."Document Type"::Invoiced THEN
        JobJournalLine.VALIDATE(Quantity, -JobJournalLine.Quantity);


      IF (Lin."Document Type" = Lin."Document Type"::Costs) THEN BEGIN
        JobJournalLine.VALIDATE("Unit Cost", ABS(pAmount));
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
        JobJournalLine."Job Correction" := JobJournalLine."Job Correction"::Cost;
      END ELSE BEGIN
        JobJournalLine.VALIDATE("Unit Price", ABS(pAmount));
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Sale;
        JobJournalLine."Job Correction" := JobJournalLine."Job Correction"::Invoiced;
      END;

      JobJournalLine.Chargeable := FALSE;
      JobJournalLine."Post Job Entry Only" := TRUE;
      JobJournalLine."Job Deviation Entry" := FALSE;
      JobJournalLine."Compute for hours" := FALSE;
      JobJournalLine."Unit of Measure Code" := '';
      JobJournalLine."Qty. per Unit of Measure" := 1;
      JobJournalLine."Work Type Code" := '';
      JobJournalLine."Gen. Prod. Posting Group" := '';
      JobJournalLine."Source Currency Total Price" := ROUND(JobJournalLine."Total Price (LCY)",Currency."Amount Rounding Precision");

      JobJournalLine."Dimension Set ID" := pDim;
      IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
        JobJournalLine."Shortcut Dimension 1 Code" := Lin."Origin Departament";
        JobJournalLine."Shortcut Dimension 2 Code" := Lin."Origin C.A.";
      END ELSE BEGIN
        JobJournalLine."Shortcut Dimension 1 Code" := Lin."Origin C.A.";
        JobJournalLine."Shortcut Dimension 2 Code" := Lin."Origin Departament";
      END;
      JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    PROCEDURE CreateEntryAcc(pText : Text;pAmount : Decimal;pJob : Code[20];pDep : Code[20];pCA : Code[20];pPiecework : Code[20];pTask : Code[20];pDim : Integer);
    BEGIN
      //L�neas del diario general

      GenJnlLine.INIT;
      GenJnlLine.INIT;
      GenJnlLine."Posting Date" := Cab."Posting Date";
      GenJnlLine."Document Date" := Cab."Posting Date";
      GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
      GenJnlLine."Account No." := Lin."Allocation Account of Transfe";
      GenJnlLine.Description := COPYSTR(STRSUBSTNO(pText, Lin."Origin Job No.", Lin."Destination Job No.", Lin.Description), 1, MAXSTRLEN(GenJnlLine.Description));
      GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
      GenJnlLine."Document No." := RegCab."No.";
      GenJnlLine."External Document No." := RegCab."No.";
      GenJnlLine.Amount := pAmount;
      GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
      GenJnlLine."Sales/Purch. (LCY)" := GenJnlLine.Amount;
      GenJnlLine."Currency Factor" :=  1;
      GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
      GenJnlLine."Source No." := '';
      GenJnlLine."Source Code" := SrcCode;
      GenJnlLine.Correction := FALSE;
      GenJnlLine."System-Created Entry" := TRUE;
      GenJnlLine."Already Generated Job Entry" := TRUE;
      //GenJnlLine."OLD_Mark Accounting" := TRUE;
      IF Lin."Document Type" = Lin."Document Type"::Costs THEN
        GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Usage
      ELSE
        GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Sale;
      GenJnlLine.VALIDATE("Job No.", pJob);
      GenJnlLine."Piecework Code" := pPiecework;
      GenJnlLine."Job Task No." := pTask;

      GenJnlLine."Dimension Set ID" := pDim;
      IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 THEN BEGIN
        GenJnlLine."Shortcut Dimension 1 Code" := pDep;
        GenJnlLine."Shortcut Dimension 2 Code" := pCA;
      END ELSE BEGIN
        GenJnlLine."Shortcut Dimension 1 Code" := pDep;
        GenJnlLine."Shortcut Dimension 2 Code" := pCA;
      END;
      GenJnlPostLine.RunWithCheck(GenJnlLine);
    END;

    LOCAL PROCEDURE CreateHeaderPosted();
    BEGIN
      // Creo la cabecera del documento que ir� al hist�rico
      RegCab.INIT;
      RegCab.TRANSFERFIELDS(Cab);
      RegCab."Preassigned Serie No." :=  Cab."Posting No. Series";
      IF Cab."Serie No." <> Cab."Posting No. Series" THEN
        RegCab."No." := NoSeriesManagement.GetNextNo(Cab."Posting No. Series",Cab."Posting Date",TRUE)
      ELSE
        RegCab."No." := Cab."No.";


      RegCab."Source Code" := SrcCode;
      RegCab."User ID" := USERID;
      RegCab.INSERT(TRUE);

      Window.UPDATE(3,RegCab."No.");

      CopyCommentLines(Cab."No.",RegCab."No.");
    END;

    LOCAL PROCEDURE CreateLinesPosted();
    BEGIN
      //Creo las l�neas del documento que van al hist�rico
      RegLin.INIT;
      RegLin.TRANSFERFIELDS(Lin);
      RegLin."Document No." :=  RegCab."No.";
      RegLin.INSERT;
    END;

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      //Copiar los comentarios al documento registrado
      QBCommentLine.RESET;
      QBCommentLine.SETRANGE("No.",FromNumber);
      IF QBCommentLine.FINDSET(FALSE) THEN
        REPEAT
         QBCommentLine2 := QBCommentLine;
         QBCommentLine2."No." := ToNumber;
         QBCommentLine2.INSERT;

        QBCommentLine.DELETE;
       UNTIL QBCommentLine.NEXT = 0;
    END;

    /*BEGIN
/*{
      JAV 28/10/19: - Se cambia el name y caption para que sea mas significativo del contenido
                    - Se rehace para que funcione correctamente
      JAV 23/03/22: - Se elimina el manejo del campo "Mark Accounting"  que no se utiliza
      PSM 16/10/23: - Q20308 Agregar la unidad de obra al control de campos repetidos
                             A�adir Testfield de U.Obra, si el proyecto la requiere
    }
END.*/
}







