Codeunit 7207343 "QB Rel. Certification/Product."
{
  
  
    Permissions=TableData 454=rim,
                TableData 7000002=m;
    trigger OnRun()
BEGIN
          END;

    PROCEDURE ExistSeparation(pJob : Code[20]) : Boolean;
    VAR
      RelCertificationProduct : Record 7207397;
    BEGIN
      //JAV 01/12/20: - QB 1.07.08 Retorna si hay unidades relacionadas
      RelCertificationProduct.RESET;
      RelCertificationProduct.SETRANGE("Job No.",pJob);
      EXIT(NOT RelCertificationProduct.ISEMPTY);
    END;

    PROCEDURE DistributePercentage(pJob : Code[20]);
    VAR
      rJob : Record 167;
      DataPieceworkForProductionC : Record 7207386;
      DataPieceworkForProductionV : Record 7207386;
      RelCertificationProduct : Record 7207397;
      TotalCost : Decimal;
      VPercentageAssigned : Decimal;
    BEGIN
      //JMMA Esta funci¢n reparte autom ticamente los porcentajes en funci¢n la peso de la unidad

      //Lanzar el calculo del presupuesto antes de comenzar
      Recalculate(pJob);

      rJob.GET(pJob);

      DataPieceworkForProductionV.RESET;
      DataPieceworkForProductionV.SETRANGE("Job No.",pJob);
      DataPieceworkForProductionV.SETRANGE("Customer Certification Unit",TRUE);
      DataPieceworkForProductionV.SETRANGE("Account Type",DataPieceworkForProductionV."Account Type"::Unit);
      DataPieceworkForProductionV.SETFILTER("Budget Filter",rJob."Current Piecework Budget");
      IF DataPieceworkForProductionV.FINDFIRST THEN
        REPEAT
          TotalCost := 0;
          RelCertificationProduct.RESET;
          RelCertificationProduct.SETRANGE("Job No.",pJob);
          RelCertificationProduct.SETRANGE("Certification Unit Code",DataPieceworkForProductionV."Piecework Code");
          IF RelCertificationProduct.FINDFIRST THEN
            REPEAT
              //ver datapiece para calcular el peso de la partida
              DataPieceworkForProductionC.RESET;
              DataPieceworkForProductionC.SETRANGE("Job No.",pJob);
              DataPieceworkForProductionC.SETFILTER("Budget Filter",rJob."Current Piecework Budget");
              DataPieceworkForProductionC.SETRANGE("Piecework Code",RelCertificationProduct."Production Unit Code");
              IF DataPieceworkForProductionC.FINDFIRST THEN BEGIN
                DataPieceworkForProductionC.CALCFIELDS("Amount Cost Budget (LCY)");
                TotalCost += DataPieceworkForProductionC."Amount Cost Budget (LCY)";
                RelCertificationProduct."Percentage Of Assignment" := 0;
                RelCertificationProduct.MODIFY;
              END;
            UNTIL RelCertificationProduct.NEXT=0;
          //Ya tengo el coste total repito para tener el porcentaje de cada
          RelCertificationProduct.RESET;
          RelCertificationProduct.SETRANGE("Job No.",pJob);
          RelCertificationProduct.SETRANGE("Certification Unit Code",DataPieceworkForProductionV."Piecework Code");
          IF RelCertificationProduct.FINDFIRST THEN
            REPEAT
              DataPieceworkForProductionC.RESET;
              DataPieceworkForProductionC.SETRANGE("Job No.",pJob);
              DataPieceworkForProductionC.SETFILTER("Budget Filter",rJob."Current Piecework Budget");
              DataPieceworkForProductionC.SETRANGE("Piecework Code",RelCertificationProduct."Production Unit Code");
              IF DataPieceworkForProductionC.FINDFIRST THEN BEGIN
                DataPieceworkForProductionC.CALCFIELDS("Amount Cost Budget (LCY)");
                IF TotalCost <> 0 THEN BEGIN
                  RelCertificationProduct.VALIDATE("Percentage Of Assignment", ROUND(DataPieceworkForProductionC."Amount Cost Budget (LCY)"/TotalCost*100,0.000000001));
                  RelCertificationProduct.MODIFY;
                END;
              END;
            UNTIL RelCertificationProduct.NEXT=0;

          //JMMA AJUSTAR LA UðLTIMA
          VPercentageAssigned := 0;
          RelCertificationProduct.RESET;
          RelCertificationProduct.SETRANGE("Job No.",pJob);
          RelCertificationProduct.SETRANGE("Certification Unit Code", DataPieceworkForProductionV."Piecework Code");
          IF RelCertificationProduct.FINDFIRST THEN
            REPEAT
              VPercentageAssigned += RelCertificationProduct."Percentage Of Assignment";
            UNTIL RelCertificationProduct.NEXT=0;

          RelCertificationProduct.RESET;
          RelCertificationProduct.SETRANGE("Job No.", pJob);
          RelCertificationProduct.SETRANGE("Certification Unit Code", DataPieceworkForProductionV."Piecework Code");
          IF RelCertificationProduct.FINDLAST THEN BEGIN
            RelCertificationProduct.VALIDATE("Percentage Of Assignment", RelCertificationProduct."Percentage Of Assignment"+(100-VPercentageAssigned));
            RelCertificationProduct.MODIFY;
          END;
          //JMMA AJUSTAR LA UðLTIMA

        UNTIL DataPieceworkForProductionV.NEXT=0;

      //Volver a calcular el presupuesto.
      Recalculate(pJob);
    END;

    PROCEDURE RecalculatePercentage(pJob : Code[20]);
    VAR
      rJob : Record 167;
      DataPieceworkForProductionC : Record 7207386;
      DataPieceworkForProductionV : Record 7207386;
      RelCertificationProduct : Record 7207397;
      TotalCost : Decimal;
      VPercentageAssigned : Decimal;
    BEGIN
      //JAV recalcula el procentaje inverso

      RelCertificationProduct.RESET;
      RelCertificationProduct.SETRANGE("Job No.", pJob);
      IF (RelCertificationProduct.FINDSET(TRUE)) THEN
        REPEAT
          RelCertificationProduct.VALIDATE("Percentage Of Assignment");
          RelCertificationProduct.MODIFY;
        UNTIL RelCertificationProduct.NEXT=0;
    END;

    PROCEDURE Separate(pJob : Code[20]) : Boolean;
    VAR
      DataPieceworkForProductionC : Record 7207386;
      DataPieceworkForProductionV : Record 7207386;
      RelCertificationProduct : Record 7207397;
      ProdMeasureLines : Record 7207400;
      HistProdMeasureLines : Record 7207402;
      MeasurementLines : Record 7207337;
      HistMeasureLines : Record 7207339;
      HistCertificationLines : Record 7207342;
      Window : Dialog;
      Nro : Integer;
    BEGIN
      //JAV 30/09/20: - QB 1.06.16 Separar las unidades de venta de las de coste creando nuevas unidades con una V delante
      IF (CONFIRM('ESTE PROCESO ES IRREVERSIBLE, separa las unidades marcadas como producci¢n y certificaci¢n, confirme con precauci¢n.',FALSE)) THEN BEGIN
        Window.OPEN('Creando nuevas U.O. #1##############');
        Nro := 0;
        DataPieceworkForProductionC.RESET;
        DataPieceworkForProductionC.SETRANGE("Job No.", pJob);
        DataPieceworkForProductionC.SETRANGE(Type, DataPieceworkForProductionC.Type::Piecework);
        DataPieceworkForProductionC.SETRANGE("Production Unit", TRUE);
        DataPieceworkForProductionC.SETRANGE("Customer Certification Unit", TRUE);
        IF (DataPieceworkForProductionC.FINDSET(TRUE)) THEN
          REPEAT
            Window.UPDATE(1, DataPieceworkForProductionC."Piecework Code");
            Nro += 1;

            //Crea la unidad de venta, igual a la de coste pero con una V delante y que no sea de producci¢n
            DataPieceworkForProductionV := DataPieceworkForProductionC;
            DataPieceworkForProductionV."Piecework Code" := 'V' + DataPieceworkForProductionC."Piecework Code" ;
            DataPieceworkForProductionV."Production Unit" := FALSE;
            DataPieceworkForProductionV."Customer Certification Unit" := TRUE;
            DataPieceworkForProductionV.INSERT;

            //La unidad de coste no puede ser tambi‚n de certificaci¢n ni estar en un expediente de venta
            DataPieceworkForProductionC."Production Unit" := TRUE;
            DataPieceworkForProductionC."Customer Certification Unit" := FALSE;
            DataPieceworkForProductionC."No. Record" := '';
            DataPieceworkForProductionC.MODIFY;

            //Si es de tipo unidad
            IF (DataPieceworkForProductionC."Account Type" = DataPieceworkForProductionC."Account Type"::Unit) THEN BEGIN
              //Cambiamos de las agrupaciones las unidades de venta si ya estuvieran asociadas
              RelCertificationProduct.RESET;
              RelCertificationProduct.SETRANGE("Job No.", pJob);
              RelCertificationProduct.SETRANGE("Certification Unit Code", DataPieceworkForProductionC."Piecework Code");
              IF (RelCertificationProduct.FINDFIRST) THEN BEGIN
                RelCertificationProduct.DELETE;
                RelCertificationProduct."Certification Unit Code" := DataPieceworkForProductionV."Piecework Code";
                RelCertificationProduct.INSERT;
              END;

              //Asociamos la nueva unidad de venta con la de coste
              RelCertificationProduct.RESET;
              RelCertificationProduct."Job No." := pJob;
              RelCertificationProduct.VALIDATE("Production Unit Code", DataPieceworkForProductionC."Piecework Code");
              RelCertificationProduct.VALIDATE("Certification Unit Code", DataPieceworkForProductionV."Piecework Code");
              IF (RelCertificationProduct."Percentage Of Assignment" <> 0) THEN
                IF NOT RelCertificationProduct.INSERT THEN ;


              //Documentos
              //Cambiamos l¡neas de mediciones y certificaciones sin registrar
              MeasurementLines.RESET;
              MeasurementLines.SETRANGE("Job No.", pJob);
              MeasurementLines.SETRANGE("Piecework No.", DataPieceworkForProductionC."Piecework Code");
              IF (MeasurementLines.FINDSET(TRUE)) THEN
                REPEAT
                  MeasurementLines."Piecework No." := DataPieceworkForProductionV."Piecework Code";
                  MeasurementLines.MODIFY;
                UNTIL MeasurementLines.NEXT = 0;

              //Cambiamos l¡neas de mediciones registradas
              HistMeasureLines.RESET;
              HistMeasureLines.SETRANGE("Job No.", pJob);
              HistMeasureLines.SETRANGE("Piecework No.", DataPieceworkForProductionC."Piecework Code");
              IF (HistMeasureLines.FINDSET(TRUE)) THEN
                REPEAT
                  HistMeasureLines."Piecework No." := DataPieceworkForProductionV."Piecework Code";
                  HistMeasureLines.MODIFY;
                UNTIL HistMeasureLines.NEXT = 0;

              //Cambiamos l¡neas de certificaciones registradas
              HistCertificationLines.RESET;
              HistCertificationLines.SETRANGE("Job No.", pJob);
              HistCertificationLines.SETRANGE("Piecework No.", DataPieceworkForProductionC."Piecework Code");
              IF (HistCertificationLines.FINDSET(TRUE)) THEN
                REPEAT
                  HistCertificationLines."Piecework No." := DataPieceworkForProductionV."Piecework Code";
                  HistCertificationLines.MODIFY;
                UNTIL HistCertificationLines.NEXT = 0;
            END;

          UNTIL (DataPieceworkForProductionC.NEXT = 0);
        Window.CLOSE;

        //Volver a calcular el presupuesto.
        IF (Nro <> 0) THEN
          Recalculate(pJob);

        MESSAGE('Finalizado, separadas %1 unidades', Nro);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    PROCEDURE AutoAssociate(pJob : Code[20]);
    VAR
      RelCertificationProduct : Record 7207397;
      DataPieceworkForProductionC : Record 7207386;
      DataPieceworkForProductionV : Record 7207386;
      Window : Dialog;
      Nro : Integer;
    BEGIN
      //JAV 30/09/20: - QB 1.06.16 Asociar autom ticamente las unidades de venta con las de coste que tengan el mismo c¢digo Presto

      IF (CONFIRM('Confime que desea asociar las unidades no asociadas de coste y las de venta con el mismo CODIGO PRESTO',FALSE)) THEN BEGIN
        Window.OPEN('Modificando U.O. #1##############');
        Nro := 0;

        //Eliminamos los que no tengan porcentaje de asociaci¢n para que los busque de nuevo
        RelCertificationProduct.INIT;
        RelCertificationProduct.SETRANGE("Job No.", pJob);
        RelCertificationProduct.SETRANGE("Percentage Of Assignment", 0);
        RelCertificationProduct.DELETEALL;

        DataPieceworkForProductionC.RESET;
        DataPieceworkForProductionC.SETRANGE("Job No.", pJob);
        DataPieceworkForProductionC.SETRANGE("Account Type", DataPieceworkForProductionC."Account Type"::Unit);
        DataPieceworkForProductionC.SETRANGE(Type, DataPieceworkForProductionC.Type::Piecework);
        DataPieceworkForProductionC.SETRANGE("Production Unit", TRUE);
        IF (DataPieceworkForProductionC.FINDSET(FALSE)) THEN
          REPEAT
            Window.UPDATE(1, DataPieceworkForProductionC."Piecework Code");

            //Buscamos la unidad de venta relacionada
            DataPieceworkForProductionV.RESET;
            DataPieceworkForProductionV.SETRANGE("Job No.", pJob);
            DataPieceworkForProductionV.SETRANGE("Account Type", DataPieceworkForProductionC."Account Type"::Unit);
            DataPieceworkForProductionV.SETRANGE(Type, DataPieceworkForProductionC.Type::Piecework);
            DataPieceworkForProductionV.SETRANGE("Customer Certification Unit", TRUE);
            DataPieceworkForProductionV.SETRANGE("Code Piecework PRESTO", DataPieceworkForProductionC."Code Piecework PRESTO");
            IF (DataPieceworkForProductionV.FINDFIRST) THEN BEGIN

              //Creo la relaci¢n coste/venta
              RelCertificationProduct.INIT;
              RelCertificationProduct."Job No." := pJob;
              RelCertificationProduct.VALIDATE("Production Unit Code", DataPieceworkForProductionC."Piecework Code");
              RelCertificationProduct.VALIDATE("Certification Unit Code", DataPieceworkForProductionV."Piecework Code");
              //Miro que no est‚ asociada la unidad de venta en otra unidad, si no lo est  la asocio
              IF (RelCertificationProduct."Percentage Of Assignment" <> 0) THEN
                IF RelCertificationProduct.INSERT THEN
                  Nro += 1;
            END;
          UNTIL (DataPieceworkForProductionC.NEXT = 0);
        Window.CLOSE;

        //Volver a calcular el presupuesto.
        IF (Nro <> 0) THEN
          Recalculate(pJob);

        MESSAGE('Finalizado, asociadas %1 unidades', Nro);
      END;
    END;

    LOCAL PROCEDURE Recalculate(pJob : Code[20]);
    VAR
      Job : Record 167;
      JobBudget : Record 7207407;
      Text000 : TextConst ESP='Presupuesto cerrado';
      RateBudgetsbyPiecework : Codeunit 7207329;
    BEGIN
      Job.GET(pJob);
      JobBudget.GET(Job."No.", Job."Current Piecework Budget");
      IF (JobBudget.Status = JobBudget.Status::Close) THEN
        MESSAGE(Text000);

      RateBudgetsbyPiecework.ValueInitialization(Job, JobBudget)
    END;

    /* /*BEGIN
END.*/
}







