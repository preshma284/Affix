page 7207015 "QB Plan Job Certification"
{
CaptionML=ENU='Planning Job Certification',ESP='Planificaci�n Certificaci�n de proyecto';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7206984;
    SourceTableView=SORTING("QB_Job No.","QB_Record No.","QB_Expected Date");
    PageType=List;
    SourceTableTemporary=true;
    ShowFilter=false;
    
  layout
{
area(content)
{
    field("CabTitulo";CabTitulo)
    {
        
                Editable=false;
                Style=Standard;
                StyleExpr=TRUE ;
    }
group("group9")
{
        
                CaptionML=ESP='Opciones';
    field("nMeses1";nMeses1)
    {
        
                CaptionML=ESP='Desde Mes';
                
                            ;trigger OnValidate()    BEGIN
                             SetStyle;
                           END;


    }
    field("Year1";Year1)
    {
        
                CaptionML=ESP='Desde A�o';
                // DecimalPlaces=0:0;
                MinValue=2010;
                MaxValue=2050;
                
                            ;trigger OnValidate()    BEGIN
                             SetStyle;
                           END;


    }
    field("DateFirst";DateFirst)
    {
        
                CaptionML=ESP='Primera Fecha';
                Visible=false ;
    }
    field("nMeses2";nMeses2)
    {
        
                CaptionML=ESP='Hasta Mes';
                
                            ;trigger OnValidate()    BEGIN
                             SetStyle;
                           END;


    }
    field("Year2";Year2)
    {
        
                CaptionML=ESP='Hasta A�o';
                // DecimalPlaces=0:0;
                MinValue=2010;
                MaxValue=2050;
                
                            ;trigger OnValidate()    BEGIN
                             SetStyle;
                           END;


    }
    field("DateEnd";DateEnd)
    {
        
                CaptionML=ESP='�ltima fecha';
                Visible=false ;
    }
group("group16")
{
        
    field("BudgetAmount";BudgetAmount)
    {
        
                CaptionML=ESP='Importe a Certificar';
                Editable=false ;
    }
    field("ImpCertificado";ImpCertificado)
    {
        
                CaptionML=ENU='Performed Amount',ESP='Importe Certificado';
                Editable=false ;
    }
    field("impDistribuido";impDistribuido)
    {
        
                CaptionML=ESP='Importe Distribuido';
                Editable=false ;
    }
    field("BudgetAmount - impDistribuido - ImpCertificado";BudgetAmount - impDistribuido - ImpCertificado)
    {
        
                CaptionML=ESP='Importe Pendiente';
    }

}

}
repeater("LinPlanif")
{
        
    field("Periodo";Periodo)
    {
        
                CaptionML=ESP='A�o/Mes';
                Editable=false;
                Style=Strong;
                StyleExpr=stPer ;
    }
    field("QB_Initial Planning Amount";rec."QB_Initial Planning Amount")
    {
        
                Editable=false;
                Style=Strong;
                StyleExpr=stPer ;
    }
    field("QB_Pending Planning Amount";rec."QB_Pending Planning Amount")
    {
        
                CaptionML=ENU='Expected Measured Amount',ESP='Certificaci�n Prevista';
                Editable=not stPer;
                Style=Strong;
                StyleExpr=stPer;
                
                            ;trigger OnValidate()    BEGIN
                             IF xRec."QB_Pending Planning Amount" <> Rec."QB_Pending Planning Amount" THEN
                               impDistribuido := impDistribuido - xRec."QB_Pending Planning Amount" + Rec."QB_Pending Planning Amount";

                             CurrPage.UPDATE;
                           END;


    }
    field("QB_Performed Amount";rec."QB_Performed Amount")
    {
        
                Editable=FALSE;
                Style=Strong;
                StyleExpr=stPer 

  ;
    }

}

}
}actions
{
area(Processing)
{

    action("Set")
    {
        
                      CaptionML=ENU='Appr&ove',ESP='Apr&obar';
                      Promoted=true;
                      Visible=Not Global;
                      PromotedIsBig=true;
                      Image=Confirm;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 ValidateData;
                               END;


    }
    action("Adjust")
    {
        
                      CaptionML=ESP='Ajustar';
                      Promoted=true;
                      Visible=Not Global;
                      Image=AdjustEntries;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 i : Integer;
                                 Suma : Decimal;
                               BEGIN
                                 AdjustData;
                               END;


    }
    action("Repartir")
    {
        
                      CaptionML=ESP='Repartir';
                      Promoted=true;
                      Visible=Not Global;
                      Image=Calculate;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 CreateData;
                               END;


    }
    action("SetInitial")
    {
        
                      CaptionML=ENU='Set Inital Planning',ESP='Fijar planificaci�n inicial';
                      Promoted=true;
                      Visible=Not Global;
                      PromotedIsBig=true;
                      Image=Copy;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 DifAmount : Decimal;
                               BEGIN
                                 DifAmount := BudgetAmount - impDistribuido - ImpCertificado;
                                 IF DifAmount <> 0 THEN
                                     ERROR(Text013,DifAmount);

                                 Rec.SETFILTER("QB_Initial Planning Amount",'<>%1',0);
                                 IF Rec.FINDFIRST THEN
                                   ERROR(Error0001);

                                 Rec.SETRANGE("QB_Initial Planning Amount");
                                 Rec.FINDFIRST;
                                 REPEAT
                                     rec."QB_Initial Planning Amount" := rec."QB_Pending Planning Amount";
                                     Rec.MODIFY;
                                 UNTIL Rec.NEXT = 0;
                               END;


    }
    action("Delete")
    {
        
                      CaptionML=ESP='Borrar Planificaci�n';
                      Promoted=true;
                      Visible=Not Global;
                      Image=DeleteQtyToHandle;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    BEGIN
                                 DeletePlan;
                               END;


    }

}
}
  
trigger OnOpenPage()    BEGIN
                 IF CodeNo = '*' THEN
                   CabTitulo := CodeJob
                 ELSE
                   CabTitulo := CodeJob + ' - ' + CodeNo;

                 CurrPage.EDITABLE(NOT Global);
                 Decimales := 0.01;
                 Job.GET(CodeJob);
                 //Calcular el total a repartir
                 BudgetAmount := 0;
                 Records.RESET;
                 Records.SETRANGE("Job No.", CodeJob);
                 Records.SETFILTER("No.",CodeNo);
                 IF (NOT Records.FINDSET(FALSE)) THEN
                   ERROR('No hay expedientes de venta')
                 ELSE
                   REPEAT
                     BudgetAmount += Records.SaleAmount(0);
                   UNTIL (Records.NEXT = 0);
                 //Copiamos los datos existentes
                 //Buscar las fechas
                 /*{
                 Rec.RESET;
                 Rec.SETRANGE("QB_Job No.", CodeJob);
                 //Rec.SETFILTER("QB_Record No.",CodeNo);
                 Rec.SETFILTER("QB_Record No.",'%1',CodeNo);
                 IF Rec.FINDFIRST THEN begin
                   {
                   IF (Job."Starting Date" < Rec."QB_Expected Date") THEN
                       DateFirst := Job."Starting Date"
                     ELSE
                     }
                       DateFirst := Rec."QB_Expected Date";
                 END ELSE
                   DateFirst := Job."Starting Date";

                 IF Rec.FINDLAST THEN begin
                     /*{
                     IF (Job."Ending Date" > Rec."QB_Expected Date") THEN
                       DateEnd := Job."Ending Date"
                     ELSE
                     }
                       DateEnd := Rec."QB_Expected Date";
                 END ELSE
                   DateEnd := Job."Ending Date";

                 nMeses1 := DATE2DMY(DateFirst, 2) - 1;
                 Year1   := DATE2DMY(DateFirst, 3);
                 nMeses2 := DATE2DMY(DateEnd, 2) - 1;
                 Year2   := DATE2DMY(DateEnd, 3);
                 }*/
                 IF NOT Global THEN BEGIN
                   QBCertificationPlanning.RESET;
                   QBCertificationPlanning.SETRANGE("QB_Job No.", CodeJob);
                   QBCertificationPlanning.SETFILTER("QB_Record No.",CodeNo);
                   IF QBCertificationPlanning.FINDFIRST THEN
                     REPEAT
                       Rec.INIT;
                       Rec.TRANSFERFIELDS(QBCertificationPlanning);
                       rec."QB_Performed Amount" := rec.GetCertificationPerformed;
                       ImpCertificado += rec."QB_Performed Amount";
                       IF rec."QB_Performed Amount" <> 0 THEN
                         //impDistribuido += rec."QB_Performed Amount"
                         impDistribuido += 0
                       ELSE BEGIN
                         IF rec."QB_Expected Date" > GetLasJobPerformDate(CodeJob,CodeNo) THEN
                           impDistribuido += QBCertificationPlanning."QB_Pending Planning Amount";
                       END;
                       Rec.INSERT;
                     UNTIL QBCertificationPlanning.NEXT = 0;
                 END ELSE BEGIN //Agrupamos por proyecto y fecha

                   QBCertificationPlanning.RESET;
                   QBCertificationPlanning.SETRANGE("QB_Job No.", CodeJob);
                   IF QBCertificationPlanning.FINDFIRST THEN
                     REPEAT
                       Rec.RESET;
                       Rec.SETRANGE("QB_Job No.", CodeJob);
                       Rec.SETRANGE("QB_Expected Date",QBCertificationPlanning."QB_Expected Date");
                       IF NOT Rec.FINDFIRST THEN BEGIN
                         Rec.INIT;
                         Rec.TRANSFERFIELDS(QBCertificationPlanning);
                         //
                         rec."QB_Record No." := '';
                         //
                         //rec."QB_Performed Amount" := GetCertificationPerformed;
                         rec."QB_Performed Amount" := QBCertificationPlanning.GetCertificationPerformed;
                         IF rec."QB_Performed Amount" <> 0 THEN
                           Performed := TRUE;
                         ImpCertificado += rec."QB_Performed Amount";
                         IF rec."QB_Performed Amount" <> 0 THEN
                           //impDistribuido += rec."QB_Performed Amount"
                           impDistribuido += 0
                         ELSE BEGIN
                           IF rec."QB_Expected Date" > GetLasJobPerformDate(CodeJob,CodeNo) THEN
                             impDistribuido += QBCertificationPlanning."QB_Pending Planning Amount";
                         END;
                         Rec.INSERT;
                       END ELSE BEGIN
                         rec."QB_Initial Planning Amount" += QBCertificationPlanning."QB_Initial Planning Amount";
                         rec."QB_Pending Planning Amount" += QBCertificationPlanning."QB_Pending Planning Amount";
                         rec."QB_Performed Amount" += QBCertificationPlanning.GetCertificationPerformed;
                         IF rec."QB_Performed Amount" <> 0 THEN
                           Performed := TRUE;
                         Rec.MODIFY;
                         ImpCertificado += QBCertificationPlanning.GetCertificationPerformed;
                         IF QBCertificationPlanning.GetCertificationPerformed = 0 THEN BEGIN
                           IF rec."QB_Expected Date" > GetLasJobPerformDate(CodeJob,CodeNo) THEN
                             impDistribuido += QBCertificationPlanning."QB_Pending Planning Amount";
                         END;
                       END;

                     UNTIL QBCertificationPlanning.NEXT = 0;
                 END;

                 //Buscar las fechas
                 Rec.RESET;
                 Rec.SETRANGE("QB_Job No.", CodeJob);
                 Rec.SETFILTER("QB_Record No.",CodeNo);
                 IF Rec.FINDFIRST THEN BEGIN
                       DateFirst := Rec."QB_Expected Date";
                 END ELSE
                   DateFirst := Job."Starting Date";

                 IF Rec.FINDLAST THEN BEGIN
                       DateEnd := Rec."QB_Expected Date";
                 END ELSE
                   DateEnd := Job."Ending Date";

                 nMeses1 := DATE2DMY(DateFirst, 2) - 1;
                 Year1   := DATE2DMY(DateFirst, 3);
                 nMeses2 := DATE2DMY(DateEnd, 2) - 1;
                 Year2   := DATE2DMY(DateEnd, 3);
                 IF NOT Global THEN
                   ImpCertificado := rec.GetJobCertificationPerformed(CodeJob,CodeNo,DateFirst,DateEnd,LastPerformDate);
                 //
                 //Ponemos los filtros en la pantalla

                 Rec.RESET;
                 Rec.FILTERGROUP(2);
                 Rec.SETRANGE("QB_Job No.", CodeJob);
                 Rec.SETFILTER("QB_Record No.",CodeNo);
                 Rec.FILTERGROUP(0);
               END;

trigger OnAfterGetRecord()    BEGIN


                       LastPerformDate := GetLasJobPerformDate(CodeJob,CodeNo);
                       //Performed := (GetCertificationPerformed <> 0) OR ("QB_Expected Date"< GetLasPerformDate);
                       Performed := (rec."QB_Performed Amount" <> 0) OR (rec."QB_Expected Date"< GetLasJobPerformDate(CodeJob,CodeNo));
                       SetStyle;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN

                           SetStyle;
                         END;



    var
      Text001 : TextConst ESP='Este proceso elimina la planificaci�n de las certificaciones �Realmente desea ejecutarlo?';
      Text010 : TextConst ENU='Previous planning will be erased . Do you want to approve?',ESP='Se borrar� la planificaci�n anterior del expediente. �Desea aprobar la nueva planificaci�n?';
      Text011 : TextConst ENU='No Microsoft Project data is pending processing.',ESP='No hay datos pendientes de procesar.';
      Text012 : TextConst ENU='Processing planning data.',ESP='Procesando Unidades de Obra';
      Text013 : TextConst ENU='%1 Is not fully planned.',ESP='No esta totalmente planificado (falta %1)';
      Text020 : TextConst ESP='Se a�adir� en %1 un importe de %2, �Realmente desea realizar este ajuste?';
      Text021 : TextConst ESP='No es posible ajustar, no se encuentra una columna v�lida';
      Text022 : TextConst ESP='Nada que ajustar';
      QBCertificationPlanning : Record 7206984;
      "ExpectedTimeUnitData." : Record 7207388;
      Job : Record 167;
      JobPostingGroup : Record 208;
      ForecastDataAmountPiecework : Record 7206984;
      Records : Record 7207393;
      CodeJob : Code[20];
      BudgetAmount : Decimal;
      Decimales : Decimal;
      DateFirst : Date;
      DateEnd : Date;
      nReg : Integer;
      suma : Decimal;
      impDistribuido : Decimal;
      stPer : Boolean;
      Periodo : Text;
      Year1 : Integer;
      Year2 : Integer;
      nMeses1: Option "Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic";
      nMeses2: Option "Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic";
      nMeses3: Option "Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic";
      CodeNo : Code[20];
      ImpCertificado : Decimal;
      Error0001 : TextConst ENU='La previsi�n inicial ya se encuentra fijada.';
      Global : Boolean;
      Performed : Boolean;
      LastPerformDate : Date;
      CabTitulo : Text;

    procedure SetData(pJobNo : Code[20]);
    begin
      CodeJob := pJobNo;
    end;

    LOCAL procedure SetStyle();
    begin
      stPer := Performed;

      DateFirst := DMY2DATE(1, nMeses1 + 1, Year1);
      DateEnd   := DMY2DATE(1, nMeses2 + 1, Year2);
      if (Rec."QB_Expected Date" <> 0D) then begin
        nMeses3 := DATE2DMY(Rec."QB_Expected Date", 2) - 1;
        Periodo := FORMAT(DATE2DMY(Rec."QB_Expected Date", 3)) + ' - ' + FORMAT(nMeses3);
      end ELSE
        Periodo := '';
    end;

    LOCAL procedure CreateData();
    var
      Meses : Integer;
      AuxFecha : Date;
      AuxFecha2 : Date;
      i : Integer;
      Amount : Decimal;
      ExistPerform : Boolean;
      RcdJob : Record 167;
      LastPerfDate : Date;
      MesesCert : Integer;
    begin
      //Creamos proporcional, pero respetamos lo ya registrado

      //Actualizamos importes certificados
      QBCertificationPlanning.RESET;
      QBCertificationPlanning.SETRANGE("QB_Job No.", CodeJob);
      QBCertificationPlanning.SETFILTER("QB_Record No.",CodeNo);
      if QBCertificationPlanning.FINDSET then
        repeat
          QBCertificationPlanning."QB_Performed Amount" := QBCertificationPlanning.GetCertificationPerformed;
          QBCertificationPlanning.MODIFY;
          if QBCertificationPlanning."QB_Performed Amount" <> 0 then begin
            ExistPerform := TRUE;
            LastPerfDate := QBCertificationPlanning."QB_Expected Date";
          end;
        until QBCertificationPlanning.NEXT = 0;

      if ExistPerform then begin
        QBCertificationPlanning.RESET;
        QBCertificationPlanning.SETRANGE("QB_Job No.", CodeJob);
        QBCertificationPlanning.SETFILTER("QB_Record No.",CodeNo);
        QBCertificationPlanning.SETFILTER("QB_Performed Amount",'=%1',0);
        QBCertificationPlanning.SETFILTER("QB_Expected Date",'%1..',LastPerfDate);
        if (QBCertificationPlanning.FINDFIRST) then begin
          AuxFecha2 := QBCertificationPlanning."QB_Expected Date";
          QBCertificationPlanning.CALCSUMS("QB_Pending Planning Amount");
        end ELSE begin
          AuxFecha2 := DateFirst;
        end;
      end ELSE
        AuxFecha2 := DateFirst;

      Meses := 0;
      AuxFecha := AuxFecha2;
      repeat
        Meses += 1;
        AuxFecha := CALCDATE('PM+1d', AuxFecha);
      until (AuxFecha > DateEnd);
      if (Meses < 1) then
        Meses := 1;
      MesesCert := 0;
      AuxFecha := AuxFecha2;
      Amount := ROUND((BudgetAmount  - ImpCertificado) / Meses, Decimales);
      suma := impDistribuido - ImpCertificado;
      impDistribuido := 0;
      FOR i:= 1 TO Meses DO begin

        Rec.RESET;
        Rec.SETRANGE("QB_Job No.", CodeJob);
        Rec.SETFILTER("QB_Record No.",CodeNo);
        Rec.SETRANGE("QB_Expected Date",AuxFecha);
        if Rec.FINDFIRST then begin
          if Global then begin
            rec."QB_Pending Planning Amount" := Amount;
            impDistribuido += Amount;
            Rec.MODIFY;
          end;
        end ELSE begin
          Rec.INIT;
          rec."QB_Job No." := CodeJob;
          rec."QB_Record No." := CodeNo;
          rec."QB_Expected Date" := AuxFecha;
          rec."QB_Performed Amount" := rec.GetCertificationPerformed;
          //ImpCertificado += rec."QB_Performed Amount";
          //if rec."QB_Performed Amount" = 0 then
          //  impDistribuido += Amount;
          if rec."QB_Performed Amount" <> 0 then begin
            Performed := TRUE;
            MesesCert += 1;
            if LastPerfDate < rec."QB_Expected Date" then
              LastPerfDate := rec."QB_Expected Date";
            if rec."QB_Pending Planning Amount" = 0 then
              rec."QB_Pending Planning Amount" := rec."QB_Performed Amount";
          end;
          //rec."QB_Pending Planning Amount" := Amount;
          Rec.INSERT;
        end;

        AuxFecha := CALCDATE('PM+1d', AuxFecha);
        suma += rec."QB_Pending Planning Amount";
      end;
      Rec.SETRANGE("QB_Expected Date");

      //Calculamo el numero de meses certificados
      LastPerformDate := GetLasJobPerformDate(CodeJob,CodeNo);
      Rec.RESET;
      Rec.SETRANGE("QB_Job No.", CodeJob);
      Rec.SETFILTER("QB_Record No.",CodeNo);

      if Rec.FINDSET then //Obtengo el ultimo mes certificado
        repeat
          if (rec."QB_Performed Amount" <> 0) and (LastPerfDate < rec."QB_Expected Date") then
            LastPerfDate := rec."QB_Expected Date";
        until Rec.NEXT = 0;

      Rec.SETFILTER("QB_Expected Date",'%1..%2',DateFirst,LastPerfDate);
      MesesCert := Rec.COUNT;
      if not ExistPerform then
        Amount := ROUND((BudgetAmount  - ImpCertificado) / (Meses - MesesCert) , Decimales);

      Rec.RESET;
      Rec.SETRANGE("QB_Job No.", CodeJob);
      Rec.SETFILTER("QB_Record No.",CodeNo);
      Rec.SETFILTER("QB_Expected Date",'%1..',LastPerfDate);
      Rec.SETFILTER("QB_Performed Amount",'=%1',0);
      if Rec.FINDFIRST then
        repeat
          rec."QB_Pending Planning Amount" := Amount;
          impDistribuido += Amount;
          Rec.MODIFY;
        until Rec.NEXT = 0;

      Rec.SETRANGE("QB_Expected Date");
      Rec.SETRANGE("QB_Performed Amount");

      if (suma <> BudgetAmount) then begin
        QBCertificationPlanning."QB_Pending Planning Amount" += BudgetAmount - suma;
      end;
    end;

    LOCAL procedure AdjustData();
    var
      DifAmount : Decimal;
    begin
      //Ajusta las diferencias en el �ltimo periodo existente en la tabla temporal
      QBCertificationPlanning.RESET;
      QBCertificationPlanning.SETRANGE("QB_Job No.", CodeJob);
      QBCertificationPlanning.SETFILTER("QB_Record No.",CodeNo);
      QBCertificationPlanning.CALCSUMS("QB_Pending Planning Amount");
      suma := QBCertificationPlanning."QB_Pending Planning Amount";

      DifAmount := BudgetAmount - impDistribuido - ImpCertificado;
      if DifAmount = 0 then
        MESSAGE(Text022)
      ELSE begin
        Rec.FINDLAST;
        SetStyle;
        if CONFIRM(Text020, TRUE, Periodo, DifAmount) then begin
            rec."QB_Pending Planning Amount" += DifAmount;
            impDistribuido += DifAmount;
            Rec.MODIFY;
         end;

      end;
    end;

    LOCAL procedure ValidateData();
    var
      Window : Dialog;
      DifAmount : Decimal;
    begin
      DifAmount := BudgetAmount - impDistribuido - ImpCertificado;
      if DifAmount <> 0 then
          ERROR(Text013,DifAmount);
      if CONFIRM(Text010) then begin
        Window.OPEN(Text012);

        //Eliminamos datos existentes
        ForecastDataAmountPiecework.RESET;
        ForecastDataAmountPiecework.SETRANGE("QB_Job No.", CodeJob);
        ForecastDataAmountPiecework.SETFILTER("QB_Record No.",CodeNo);
        ForecastDataAmountPiecework.DELETEALL;

        Job.TESTFIELD("Job Posting Group");
        JobPostingGroup.GET(Job."Job Posting Group");
        JobPostingGroup.TESTFIELD("Sales Analytic Concept");

        //Traspasar los registros
          Rec.FINDFIRST;
          repeat
            nReg += 1;
            ForecastDataAmountPiecework.INIT;
            ForecastDataAmountPiecework."QB_Job No." := CodeJob;
            ForecastDataAmountPiecework."QB_Expected Date" := rec."QB_Expected Date";
            ForecastDataAmountPiecework."QB_Record No." := rec."QB_Record No.";
            ForecastDataAmountPiecework."QB_Pending Planning Amount" := rec."QB_Pending Planning Amount";
            ForecastDataAmountPiecework."QB_Initial Planning Amount" := rec."QB_Initial Planning Amount";
            ForecastDataAmountPiecework.INSERT(FALSE);
          until Rec.NEXT = 0;
        Window.CLOSE;
      end;
    end;

    LOCAL procedure DeletePlan();
    var
      AuxDateFirst : Date;
      AuxDateEnd : Date;
    begin
      if (CONFIRM(Text001)) then begin
        //Eliminamos datos existentes
        Rec.RESET;
        Rec.SETRANGE("QB_Job No.", CodeJob);
        Rec.SETFILTER("QB_Record No.",CodeNo);
        Rec.SETFILTER("QB_Initial Planning Amount",'<>%1',0);
        //Rec.SETFILTER("QB_Performed Amount",'<>%1',0);
        if Rec.FINDFIRST then
          AuxDateFirst := Rec."QB_Expected Date";
        if Rec.FINDLAST then
          AuxDateEnd := rec."QB_Expected Date";

        Rec.SETRANGE("QB_Initial Planning Amount");
        Rec.SETFILTER("QB_Performed Amount",'<>%1',0);
        if Rec.FINDFIRST then
          if AuxDateFirst > rec."QB_Expected Date" then
            AuxDateFirst := rec."QB_Expected Date";

        if Rec.FINDLAST then
          if AuxDateEnd < rec."QB_Expected Date" then
           AuxDateEnd := Rec."QB_Expected Date";

        Rec.SETRANGE("QB_Initial Planning Amount",0);
        Rec.SETFILTER("QB_Performed Amount",'=%1',0);
        Rec.SETFILTER("QB_Expected Date",'..%1',AuxDateFirst);
        Rec.DELETEALL;

        Rec.SETRANGE("QB_Initial Planning Amount",0);
        Rec.SETFILTER("QB_Performed Amount",'=%1',0);
        Rec.SETFILTER("QB_Expected Date",'%1..',AuxDateEnd);
        Rec.DELETEALL;

        Rec.SETRANGE("QB_Expected Date");
        Rec.SETRANGE("QB_Initial Planning Amount");
        Rec.SETRANGE("QB_Performed Amount");
        Rec.SETFILTER("QB_Performed Amount",'<>%1',0);
        CLEAR(AuxDateEnd);
        if Rec.FINDFIRST then
            AuxDateFirst := rec."QB_Expected Date";
        if Rec.FINDLAST then
           AuxDateEnd := Rec."QB_Expected Date";

        Rec.SETRANGE("QB_Expected Date");
        Rec.SETRANGE("QB_Initial Planning Amount");
        Rec.SETRANGE("QB_Performed Amount");

        Rec.SETFILTER("QB_Pending Planning Amount",'<>%1',0);
        Rec.SETFILTER("QB_Performed Amount",'=%1',0);
        if AuxDateEnd <> 0D then
          Rec.SETFILTER("QB_Expected Date",'%1..',AuxDateEnd);
        if Rec.FINDFIRST then
          repeat
            impDistribuido -= rec."QB_Pending Planning Amount" ;
            rec."QB_Pending Planning Amount" := 0;

            Rec.MODIFY
          until Rec.NEXT = 0;
        Rec.SETRANGE("QB_Initial Planning Amount");
        Rec.SETRANGE("QB_Pending Planning Amount");
        Rec.SETRANGE("QB_Performed Amount");
        Rec.SETRANGE("QB_Expected Date");
        impDistribuido := 0;
      end;
    end;

    procedure SetDatas(pJobNo : Code[20];pNo : Code[20]);
    begin
      CodeJob := pJobNo;
      Global := FALSE;
      if pNo = '' then begin
        Global := TRUE;
        CodeNo := '*'
      end ELSE
        CodeNo := pNo;
    end;

    LOCAL procedure CalcImpDistribuido() : Decimal;
    var
      TotalDistrib : Decimal;
    begin
      TotalDistrib := 0;
      Rec.FINDFIRST;
       repeat
         TotalDistrib += rec."QB_Pending Planning Amount";
      until Rec.NEXT = 0;
      exit(TotalDistrib);
    end;

    LOCAL procedure GetLasJobPerformDate(P_JobCode : Code[20];P_ExpCode : Code[20]) : Date;
    var
      LastDate : Date;
      HistCertificationLines : Record 7207342;
    begin
      HistCertificationLines.RESET;
      HistCertificationLines.SETRANGE("Job No.",P_JobCode);
      HistCertificationLines.SETFILTER(Record,P_ExpCode);
      HistCertificationLines.SETFILTER("Cert Term PEM amount",'<>%1',0);
      if HistCertificationLines.FINDLAST then
        LastDate := HistCertificationLines."Certification Date";

      exit(LastDate);
    end;

    // begin
    /*{
      16216 01/02/22 DGG - Creaci�n de la p�gina
    }*///end
}







