Codeunit 7207280 "Production Daily Management"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      Text004 : TextConst ENU='PREDET.',ESP='PREDET.';
      Text005 : TextConst ENU='Daily predet.',ESP='Diario predet.';
      Text000 : TextConst ENU='Production',ESP='Produccion';
      Text001 : TextConst ENU='Production Daily',ESP='Diario Produccion';
      LastProductionDailyLine : Record 7207327;
      Text006 : TextConst ENU=': The job in progress is equal to (Consumption at cost price / cost budget) *',ESP='": La obra en curso es igual a (Consumos a precio de coste / presupuesto de costes) * "';
      Text007 : TextConst ENU='Sale Budget',ESP='Presupuesto de venta';
      Text008 : TextConst ENU=': The job in progress is given by the set of production measurements in the period.',ESP=': La obra en curso la da el conjunto de mediciones de producci¢n en el periodo.';
      Text009 : TextConst ENU=': The job in progress is the amount I have invoiced in the period.',ESP=': La obra en curso es el importe que he facturado en el periodo.';
      Text010 : TextConst ENU=': The job in progress is the sum of the invoicing , I produce what I invoice.',ESP=': La obra en curso es el sumatorio de la facturaci¢n, produzco lo que facturo.';
      Text011 : TextConst ENU=': There is no preset method for calculating production.',ESP=': No existe un m‚todo prefijado para el c lculo de la producci¢n.';
      Text012 : TextConst ENU=': No production is calculated.',ESP=': No se calcula la producci¢n.';
      OpenFromBatch : Boolean;

    PROCEDURE OpenBook(VAR CurrentBook : Code[10];VAR ProductionDailyLine : Record 7207327);
    VAR
      Book : Code[20];
    BEGIN
      Book := ProductionDailyLine.GETRANGEMAX("Daily Book Name");
      CheckNameBook(Book);

      ProductionDailyLine.FILTERGROUP := 2;
      ProductionDailyLine.SETRANGE("Daily Book Name",CurrentBook);
      ProductionDailyLine.FILTERGROUP := 0;
    END;

    PROCEDURE CheckNameBook(CurrentNameBook : Code[20]);
    VAR
      DailyBookProduction : Record 7207326;
    BEGIN
      DailyBookProduction.GET(CurrentNameBook);
    END;

    PROCEDURE SelectBook(VAR ProductionDailyLine : Record 7207327) : Code[20];
    VAR
      DiaryBookProduction : Record 7207326;
      JnlSelected : Boolean;
    BEGIN
      JnlSelected := FALSE;

      DiaryBookProduction.RESET;
      CASE DiaryBookProduction.COUNT OF
        0:
          BEGIN
            DiaryBookProduction.INIT;
            DiaryBookProduction.Name := Text000;
            DiaryBookProduction.Description := Text001;
            DiaryBookProduction.INSERT;
            JnlSelected := TRUE;
          END;
        1:
          BEGIN
            DiaryBookProduction.FINDFIRST;
            JnlSelected := TRUE;
          END;
        ELSE
          JnlSelected := PAGE.RUNMODAL(0,DiaryBookProduction) = ACTION::LookupOK;
      END;

      IF JnlSelected THEN BEGIN
        ProductionDailyLine.FILTERGROUP(2);
        ProductionDailyLine.SETRANGE("Daily Book Name", DiaryBookProduction.Name);
        ProductionDailyLine.FILTERGROUP(0);
      END;

      IF (JnlSelected) THEN
        EXIT(DiaryBookProduction.Name)
      ELSE
        EXIT('');
    END;

    PROCEDURE CatchName(VAR ProductionDailyLine : Record 7207327;VAR DescriptionJob : Text[60];VAR DescriptionMode : Text[1024]);
    VAR
      Job : Record 167;
      GLAccount : Record 15;
    BEGIN
      // Esta funci¢n devuelve el nombre de lo que exista en la l¡nea en ese momento, es decir, si en las l¡nas del
      // diario hay recursos, producto o cuentas, muestra el nombre del C¢d. que exista.
      IF (ProductionDailyLine."Job No." <> LastProductionDailyLine."Job No.") THEN BEGIN
        DescriptionJob := '';
        DescriptionMode := '';
        IF Job.GET(ProductionDailyLine."Job No.") THEN BEGIN
          DescriptionJob:= Job.Description;
          DescriptionMode := FORMAT(Job."Production Calculate Mode");
          CASE Job."Production Calculate Mode" OF
            Job."Production Calculate Mode"::"Lump Sums":
              DescriptionMode := DescriptionMode + Text006 + ' '+
                             Text007;
            Job."Production Calculate Mode"::"Production by Piecework":
              DescriptionMode := DescriptionMode + Text008;
            Job."Production Calculate Mode"::Administration:
              DescriptionMode := DescriptionMode + Text009;
            Job."Production Calculate Mode"::"Production=Invoicing":
              DescriptionMode := DescriptionMode + Text010;
            Job."Production Calculate Mode"::Free:
              DescriptionMode := DescriptionMode + Text011;
            Job."Production Calculate Mode"::"Without Production":
              DescriptionMode := DescriptionMode + Text012;
          END;
        END;
      END;

      LastProductionDailyLine := ProductionDailyLine;
    END;

    PROCEDURE CheckName(VAR ProductionDailyLine : Record 7207327);
    VAR
      DailyBookProduction : Record 7207326;
    BEGIN
      DailyBookProduction.GET(ProductionDailyLine.GETRANGEMAX("Daily Book Name"));
    END;

    PROCEDURE EstablishName(Book : Code[20];VAR ProductionDailyLine : Record 7207327);
    BEGIN
      ProductionDailyLine.FILTERGROUP := 2;
      ProductionDailyLine.SETRANGE("Daily Book Name",Book);
      ProductionDailyLine.FILTERGROUP := 0;
      IF ProductionDailyLine.FINDFIRST THEN;
    END;

    PROCEDURE LookName(VAR ProductionDailyLine : Record 7207327);
    VAR
      DailyBookProduction : Record 7207326;
      Book : Code[20];
    BEGIN
      COMMIT;
      DailyBookProduction.Name := ProductionDailyLine.GETRANGEMAX("Daily Book Name");
      DailyBookProduction.FILTERGROUP := 2;
      DailyBookProduction.SETRANGE(Name,DailyBookProduction.Name);
      DailyBookProduction.FILTERGROUP := 0;

      IF PAGE.RUNMODAL(0,DailyBookProduction) = ACTION::LookupOK THEN BEGIN
        Book := DailyBookProduction.Name;
        EstablishName(Book,ProductionDailyLine);
      END;
    END;

    /* /*BEGIN
END.*/
}







