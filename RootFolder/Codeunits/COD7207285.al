Codeunit 7207285 "Production Daily Register"
{
  
  
    TableNo=7207327;
    trigger OnRun()
BEGIN
            ProductionDailyLine.COPY(Rec);
            Code;
            Rec.COPY(ProductionDailyLine);
          END;
    VAR
      QuoBuildingSetup : Record 7207278;
      ProductionDailyLine : Record 7207327;
      DailyBookProduction : Record 7207326;
      Job : Record 167;
      JobPostingGroup : Record 208;
      GenJournalLine : Record 81;
      NoSeriesManagement : Codeunit 396;
      JobJnlPostLine : Codeunit 1012;
      Text001 : TextConst ENU='Are you sure you want to record daily lines?',ESP='�Confirma que desea registrar las l�neas del diario?';
      Text002 : TextConst ENU='There is nothing to register.',ESP='No hay nada que registrar.';
      Text003 : TextConst ENU='The daily lines have been correctly recorded.',ESP='Se han registrado correctamente las l�neas del diario.';
      Window : Dialog;
      Text006 : TextConst ENU='Recording daily\',ESP='Registrando diario\';
      Text007 : TextConst ENU='Production Line  #1########\',ESP='Linea diario producci�n  #1########\';
      Text008 : TextConst ENU='Registering Jobs    #2########\',ESP='Registrando Proyecto     #2########\';
      Text009 : TextConst ENU='Registering Accountin #3########',ESP='Registrando Contabilidad #3########';
      CurrencyFactor : Decimal;
      EntryNo : Integer;

    PROCEDURE "Run(Y/N)"(Rec : Record 7207327);
    BEGIN
      IF CONFIRM(Text001) THEN BEGIN
        ProductionDailyLine.COPY(Rec);
        Code;
        Rec.COPY(ProductionDailyLine);
      END;
    END;

    LOCAL PROCEDURE Code();
    VAR
      UpdateViews : Codeunit 410;
    BEGIN
      WITH ProductionDailyLine DO BEGIN
        DailyBookProduction.GET("Daily Book Name");

        IF "Line No." = 0 THEN
          ERROR(Text002);

        Window.OPEN (Text006 +
                     Text007);

        SETRANGE("Daily Book Name","Daily Book Name");
        IF ProductionDailyLine.FINDSET(TRUE) THEN BEGIN
          REPEAT
            Window.UPDATE(1, "Line No.");

            //Buscar el proyecto y verificar datos necesarios
            ControlDaily;

            IF (Job."Calculate WIP by periods") THEN BEGIN
              //El movimiento contable
              EntryNo := GenerateGLDiary(ProductionDailyLine."Posting Date", ProductionDailyLine."Job in Progress");
              //El movimiento del proyecto
              GenerateJobDiary(ProductionDailyLine."Posting Date", 1, ProductionDailyLine."Job in Progress", EntryNo);

            END ELSE BEGIN
              //El movimiento contable en el �ltimo d�a del mes
              EntryNo := GenerateGLDiary(ProductionDailyLine."Posting Date", ProductionDailyLine."Job in Progress");
              //El movimiento del proyecto, debe ser en el �ltimo d�a del mes
              GenerateJobDiary(ProductionDailyLine."Posting Date", 1, ProductionDailyLine."Job in Progress", EntryNo);

              //Deshacer el movimiento contable al d�a siguiente
              EntryNo := GenerateGLDiary(ProductionDailyLine."Posting Date" + 1, -ProductionDailyLine."Job in Progress");
              //Deshacer el movimiento del proyecto al d�a siguiente
              GenerateJobDiary(ProductionDailyLine."Posting Date" + 1, -1, ProductionDailyLine."Job in Progress", EntryNo);
            END;

            //JMMA ACTUALIZAR VISTAS
            UpdateViews.UpdateAll(0,TRUE);
          UNTIL ProductionDailyLine.NEXT = 0;
        END ELSE
          ERROR(Text002);

        DELETEALL;
        COMMIT;

        IF DailyBookProduction."Serie No." <> '' THEN
          NoSeriesManagement.SaveNoSeries;
        COMMIT;

        Window.CLOSE;
        MESSAGE(Text003);

        RESET;
        FILTERGROUP(2);
        SETRANGE("Daily Book Name","Daily Book Name");
        FILTERGROUP(0);
      END;
    END;

    PROCEDURE ControlDaily();
    VAR
      JobJournalLine : Record 210;
    BEGIN
      WITH ProductionDailyLine DO BEGIN
        // Comporbamos el proyecto
        TESTFIELD("Job No.");
        Job.GET("Job No.");
        Job.TESTFIELD("Bill-to Customer No.");
        Job.TESTFIELD("Job Posting Group");

        // Comprobamos el grupo contable de proyectos
        JobPostingGroup.GET(Job."Job Posting Group");
        JobPostingGroup.TESTFIELD("Income Account Job in Progress");
        JobPostingGroup.TESTFIELD("CA Income Job in Progress");
        JobPostingGroup.TESTFIELD("Cont. Acc. Job in Progress(+)");
        JobPostingGroup.TESTFIELD("Cont. Acc. Job in Progress(-)");

        //Comprobamos datos del diario
        TESTFIELD("Posting Date");
        TESTFIELD("Document No.");
        TESTFIELD("G/L Account");
        TESTFIELD("Job in Progress");

        //Factor de la divisa, es fijo para todas las l�neas da igual su fecha
        CurrencyFactor := "Currency Factor";
      END;
    END;

    PROCEDURE GenerateGLDiary(pDate : Date;pAmount : Decimal) : Integer;
    VAR
      GenJournalLine : Record 81;
      GLAccount : Record 15;
      GenJnlPostLine : Codeunit 12;
      UpdateViews : Codeunit 410;
    BEGIN
      //Generar y registrar las l�neas del diario contable
      GenJournalLine.INIT;

      //JAV 13/11/20: - QB 1.07.05 El movimiento es de tipo WIP
      GenJournalLine."Document Type" := GenJournalLine."Document Type"::WIP;

      //JAV 13/11/20: - QB 1.07.05 Va contra el cliente o contra cuenta del grupo 3 seg�n est� configurado
      QuoBuildingSetup.GET();
      IF (NOT QuoBuildingSetup."Use Customer in WIP") THEN BEGIN
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        IF ProductionDailyLine."Job in Progress" >= 0 THEN
          GenJournalLine."Account No." := JobPostingGroup."Cont. Acc. Job in Progress(+)"
        ELSE
          GenJournalLine."Account No." := JobPostingGroup."Cont. Acc. Job in Progress(-)";
        GLAccount.GET(GenJournalLine."Account No."); //Verificar que existe la cuenta
      END ELSE BEGIN
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
        GenJournalLine."Account No." := Job."Bill-to Customer No.";
      END;

      //Contrapartida es la cuenta de ingresos
      GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
      GenJournalLine."Bal. Account No." := ProductionDailyLine."G/L Account";

      GenJournalLine."Posting Date" := pDate;                                                     //Esto cambia entre las l�neas
      GenJournalLine."Document No." := ProductionDailyLine."Document No.";
      GenJournalLine.Description := ProductionDailyLine.Description;
      GenJournalLine."Shortcut Dimension 1 Code" := ProductionDailyLine."Shortcut Dimension 1 Code";
      GenJournalLine."Shortcut Dimension 2 Code" := ProductionDailyLine."Shortcut Dimension 2 Code";
      GenJournalLine."Source Code" := ProductionDailyLine."Source Code";
      GenJournalLine."System-Created Entry" := FALSE;
      GenJournalLine."Job No." := ProductionDailyLine."Job No.";
      GenJournalLine."Job Task No." := ProductionDailyLine."Job Task No.";
      GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
      GenJournalLine.VALIDATE("Currency Code", Job."Currency Code");                              //JMMA 1611 A�ADIDO DIVISA DE PROYECTO
      GenJournalLine.VALIDATE("Currency Factor", CurrencyFactor);                                 //JMMA 1611 A�ADIDO DIVISA DE PROYECTO
      GenJournalLine.VALIDATE(Amount, pAmount);                                                   //Esto cambia seg�n el tipo
      GenJournalLine.Correction := (pAmount < 0);
      GenJournalLine."System-Created Entry" := TRUE;
      GenJournalLine."Source Type" := GenJournalLine."Source Type"::" ";
      GenJournalLine."Reason Code" := ProductionDailyLine."Reason Code";
      GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";

      GenJournalLine."Posting No. Series" := ProductionDailyLine."Posting Serie No.";
      GenJournalLine."Already Generated Job Entry" := TRUE;
      GenJournalLine."Usage/Sale" := GenJournalLine."Usage/Sale"::Sale;
      GenJournalLine."Dimension Set ID" := ProductionDailyLine."Dimension Set ID";
      GenJournalLine."Adjust WIP" := TRUE;

      EXIT(GenJnlPostLine.RunWithCheck(GenJournalLine));
    END;

    PROCEDURE GenerateJobDiary(pDate : Date;pQty : Integer;pAmount : Decimal;pEntryNo : Integer);
    VAR
      JobJournalLine : Record 210;
      JobJnlPostLine : Codeunit 1012;
      GLAccount : Record 15;
    BEGIN
      //Generar y registrar las l�neas del diario de proyectos
      JobJournalLine.INIT;
      JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Sale;
      JobJournalLine.VALIDATE("Job No.", ProductionDailyLine."Job No.");
      JobJournalLine."Job Task No." := ProductionDailyLine."Job Task No.";
      JobJournalLine."Posting Date" := pDate;                                                     //Esto cambia entre ambas l�neas
      JobJournalLine."Document Date" := JobJournalLine."Posting Date";
      JobJournalLine."Document No." := ProductionDailyLine."Document No.";
      JobJournalLine.Type := JobJournalLine.Type::"G/L Account";
      JobJournalLine."No." := ProductionDailyLine."G/L Account";
      JobJournalLine.Description := ProductionDailyLine.Description;
      JobJournalLine.Quantity := pQty;                                                            //Esto cambia entre ambas l�neas
      JobJournalLine.VALIDATE("Currency Code", Job."Currency Code");                              //JMMA 1611 A�ADE LA DIVISA DEL PROYECTO
      JobJournalLine.VALIDATE("Currency Factor", CurrencyFactor);
      JobJournalLine.VALIDATE("Unit Price", pAmount);                                             //Esto cambia dependiendo del tipo. JMMA 1611 A�ADE LA DIVISA DEL PROYECTO
      //JobJournalLine.VALIDATE("Unit Price (LCY)", ProductionDailyLine."Job in Progress");       //JMMA 1611 COMENTADO POR DIVISA DE PROYECTO
      JobJournalLine."Posting Group" := ProductionDailyLine."Gen. Bus. Posting Group";
      JobJournalLine."Source Code" := ProductionDailyLine."Source Code";
      JobJournalLine."Post Job Entry Only" := TRUE;
      JobJournalLine."Reason Code" := ProductionDailyLine."Reason Code";
      JobJournalLine."Gen. Bus. Posting Group" := ProductionDailyLine."Gen. Bus. Posting Group";
      JobJournalLine."Gen. Prod. Posting Group" := ProductionDailyLine."Gen. Prod. Posting Group";
      JobJournalLine."Serial No." := ProductionDailyLine."Serie No.";
      JobJournalLine."Posting No. Series" := ProductionDailyLine."Posting Serie No.";
      JobJournalLine."Quantity (Base)" := 1;
      JobJournalLine."Job Deviation Entry" := FALSE;
      JobJournalLine."Job in Progress" := TRUE;
      JobJournalLine.Chargeable := FALSE;
      JobJournalLine."Shortcut Dimension 1 Code" := ProductionDailyLine."Shortcut Dimension 1 Code";
      JobJournalLine."Shortcut Dimension 2 Code" := ProductionDailyLine."Shortcut Dimension 2 Code";
      JobJournalLine."Dimension Set ID" := ProductionDailyLine."Dimension Set ID";
      JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Journal;    //GAP888
      JobJournalLine."Related G/L Entry" := pEntryNo;   //JAV 03/12/20: - QB 1.07.10 Guardo el movimiento contable relacionado

      JobJnlPostLine.RunWithCheck(JobJournalLine);
    END;

    /* /*BEGIN
END.*/
}







