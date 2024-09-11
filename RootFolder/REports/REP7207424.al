report 7207424 "Month Closing Process"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Month Closing',ESP='Cierre mes';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
trigger OnPreDataItem();
    BEGIN 
                               //+Q18730
                               ClosingMonthStart := DMY2DATE(1, ClosingMonthOpt + 1, YearActiveBudget);   //Comienza en cero
                               //-Q18730
                               ClosingMonthEnd := CALCDATE('<CM>', ClosingMonthStart);

                               NextMonthStart := CALCDATE('<1M>', ClosingMonthStart);
                               NextMonthEnd := CALCDATE('<CM>', NextMonthStart);
                             END;

trigger OnAfterGetRecord();
    VAR
//                                   QBObjectivesHeader@1100286000 :
                                  QBObjectivesHeader: Record 7207403;
//                                   realMarkMonth@1100286001 :
                                  realMarkMonth: Integer;
                                BEGIN 
                                  //Solo para proyectos operativos
                                  IF (NOT recEstado.GET(recEstado.Usage::"Proyecto operativo", Job."Internal Status")) THEN
                                    ERROR(Err003, Job."No.")
                                  ELSE BEGIN 
                                    IF (NOT recEstado.Operative) THEN
                                      ERROR(Err002, recEstado.Description)
                                    ELSE BEGIN 
                                      //Comprobar si existe uno para el mes siguiente.
                                      JobBudget.RESET;
                                      JobBudget.SETRANGE("Job No.", Job."No.");
                                      JobBudget.SETRANGE(Status, JobBudget.Status::Open);
                                      JobBudget.SETRANGE("Budget Date", NextMonthStart, NextMonthEnd);
                                      NextMonthBudgetExist := JobBudget.FINDFIRST;

                                      //Comprobar si existe uno para el mes actual y cerrarlo.
                                      JobBudget.RESET;
                                      JobBudget.SETRANGE("Job No.", Job."No.");
                                      JobBudget.SETRANGE(Status, JobBudget.Status::Open);
                                      JobBudget.SETRANGE("Budget Date", ClosingMonthStart, ClosingMonthEnd);
                                      IF NOT JobBudget.FINDSET(FALSE) THEN
                                        ERROR(Err004, ClosingMonthStart, ClosingMonthEnd, Job."No.")
                                      ELSE BEGIN 
                                        REPEAT
                                          //Q13643+
                                           IF QuoBuildingSetup."Control Negative Target" THEN begin //{Q13643 si el nuevo campo 140 de la config de quobuilding est  activo}
                                            JobBudget.CALCFIELDS("Target Amount");
                                            IF (JobBudget."Target Amount" < 0) AND (NOT QBObjectivesHeader."Allow Negative") THEN begin //{verificar si su importe total es menor que cero y que NO est  aprobado permitir el negativo
                                              realMarkMonth := DATE2DMY(JobBudget."Budget Date",2);
                                              IF FunctionQB.AllowReestimationMonth(realMarkMonth) THEN begin //{Si el campo 141 est  activado y la fecha presupuesto est  en uno de los meses marcados en los campos 142 a 153, entonces
                                                JobsError += Job."No." + ', '; //{a¤adimos el c¢digo del proyecto en la variable JobsError, cada proyecto separado por una coma y un espacio del anterior
                                                CurrReport.BREAK;              //{Luego nos saltamos el proceso interno entre REPEAT y UNTIL completamente (este punto es fundamental)
                                              END ELSE BEGIN 
                                                JobsMsg += Job."No." + ', ';   //{En caso contrario a¤adimos el proyecto en la variable JobsMsg
                                              END;
                                            END;
                                          END;
                                          //Q13643-

                                          //Si no existe presupuesto para el mes siguiente copiarlo antes.
                                          IF NOT NextMonthBudgetExist THEN BEGIN 
                                            //Cerrar el mes y fijar el nuevo proyecto
                                            Job."Current Piecework Budget" := CopyJobBudgetToNextMonth(JobBudget);
                                            Job.MODIFY;
                                          END;

                                          //Marco como cerrado y no actual, lo vuelvo a leer porque el proceso anterior puede haberlo cambiado
                                          JobBudget2.GET(JobBudget."Job No.",JobBudget."Cod. Budget");
                                          JobBudget2.Status := JobBudget.Status::Close;
                                          JobBudget2."Actual Budget" := FALSE;
                                          JobBudget2.MODIFY(TRUE);
                                        UNTIL JobBudget.NEXT = 0;
                                      END;
                                    END;
                                  END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                TextMessage := '';
                               // {OnPostDataitem de la tabla Job, si la variable JobsError no est  vac¡a, mensaje que indique "Los siguientes proyectos no se han creado por tener el Objetivo negativo:Ê+ la variable JobsError
                                IF (JobsError <> '') THEN
                                  TextMessage := STRSUBSTNO(Txt002, JobsError);

                               // {Si la variable JobsMsg no est  vac¡a preparamos un mensaje que indique ÊLos siguientes proyectos tienen el objetivo negativo, rev¡selos: + el contenido de la variable JobsMsg
                                IF (JobsMsg <> '') THEN BEGIN 
                                  IF (TextMessage <> '') THEN
                                    TextMessage += '\\';

                                  TextMessage += STRSUBSTNO(Txt003,JobsMsg);
                                END;

                               // {Se presentar  el mensaje que tenga contenido de los dos, o ambos separados por una l¡nea en blanco si ambos lo tienen.
                                //MESSAGE(TextMessage);
                              END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group815")
{
        
                  CaptionML=ENU='Filters',ESP='Opciones';
    field("ClosingMonthOpt";"ClosingMonthOpt")
    {
        
                  CaptionML=ENU='Month',ESP='Mes a cerrar';
                  //OptionCaptionML=ENU='Month',ESP='Mes a cerrar';
                  
                              trigger OnValidate()    BEGIN
                               SetType;
                             END;


    }
    field("txtName";"txtName")
    {
        
                  CaptionML=ESP='Nuevo Presupuesto';
                  Editable=false ;
    }
    field("Type";"Type")
    {
        
                  CaptionML=ESP='Tipo';
    }

}

}
}trigger OnOpenPage()    BEGIN
                   SetType;
                   //-Q18150
                   IF pJobNo <> '' THEN SetMonth(pJobNo);
                   //+Q18150
                 END;


  }
  labels
{
}
  
    var
//       QuoBuildingSetup@1100286022 :
      QuoBuildingSetup: Record 7207278;
//       JobBudget@1100286025 :
      JobBudget: Record 7207407;
//       JobBudget2@1100286024 :
      JobBudget2: Record 7207407;
//       NextMonthJobBudget@1100286021 :
      NextMonthJobBudget: Record 7207407;
//       DataCostByPiecework@1100286020 :
      DataCostByPiecework: Record 7207387;
//       NextMonthDataCostByPiecework@1100286019 :
      NextMonthDataCostByPiecework: Record 7207387;
//       UserSetup@1100286010 :
      UserSetup: Record 91;
//       recEstado@1100286007 :
      recEstado: Record 7207440;
//       CopyJobBudget@1100286016 :
      CopyJobBudget: Report 7207400;
//       BudgetReestimationInitialize@1100286012 :
      BudgetReestimationInitialize: Codeunit 7207334;
//       FunctionQB@1100286033 :
      FunctionQB: Codeunit 7207272;
//       AuxMonth@1100286001 :
      AuxMonth: Integer;
//       ClosingMonthStart@1100286003 :
      ClosingMonthStart: Date;
//       ClosingMonthEnd@1100286004 :
      ClosingMonthEnd: Date;
//       NextMonthStart@1100286006 :
      NextMonthStart: Date;
//       NextMonthEnd@1100286005 :
      NextMonthEnd: Date;
//       NextMonthBudgetExist@1100286008 :
      NextMonthBudgetExist: Boolean;
//       Txt001@1100286014 :
      Txt001: TextConst ESP='%1 de %2';
//       FinishText@1100286002 :
      FinishText: TextConst ENU='Process ended.',ESP='Proceso finalizado.';
//       Err001@1100286011 :
      Err001: TextConst ESP='No tiene permisos para modificar el estado de los presupuestos';
//       Err002@1100286013 :
      Err002: TextConst ESP='El proyecto debe estar en un estado marcado como operativo, actualmente est  en %1';
//       Err003@1100286026 :
      Err003: TextConst ESP='No ha defindio un estado interno v lido para el proyecto %1';
//       Year@1100286009 :
      Year: Integer;
//       txtYear@1100286018 :
      txtYear: Text[4];
//       txtMonth@1100286017 :
      txtMonth: Text[2];
//       JobsError@1100286028 :
      JobsError: Text;
//       JobsMsg@1100286029 :
      JobsMsg: Text;
//       TextMessage@1100286032 :
      TextMessage: Text;
//       "--------------------------- Opciones"@1100286015 :
      "--------------------------- Opciones": Integer;
//       ClosingMonthOpt@1100286000 :
      ClosingMonthOpt: Option "January","February","March","April","May","June","July","August","September","October","November","December";
//       Type@1100286023 :
      Type: Option "Copiar","Reestimar";
//       Err004@1100286027 :
      Err004: TextConst ESP='No encuentro un presupuesto en el rango de fechas %1 a %2 para el proyecto %3';
//       Txt002@1100286030 :
      Txt002: TextConst ENU='The following projects have not been created because they have a negative Goal: %1',ESP='Los siguientes proyectos no se han creado por tener el Objetivo negativo: %1';
//       Txt003@1100286031 :
      Txt003: TextConst ENU='The following projects have the negative target, please review them: %1',ESP='Los siguientes proyectos tienen el objetivo negativo, rev¡selos: %1';
//       txtName@1100286034 :
      txtName: Text;
//       pJobNo@1100286035 :
      pJobNo: Code[20];
//       pBudgetNo@1100286036 :
      pBudgetNo: Code[20];
//       Month@1100286037 :
      Month: Integer;
//       YearActiveBudget@1100286038 :
      YearActiveBudget: Integer;

    

trigger OnInitReport();    var
//                    realMarkMonth@1100286000 :
                   realMarkMonth: Integer;
                 begin
                   UserSetup.GET(USERID);
                   if (not UserSetup."Modify Budget Status") then
                     ERROR(Err001);
                   //+Q18730
                  //  {
                  //  AuxMonth := DATE2DMY(WORKDATE, 2);
                  //  Year := DATE2DMY(WORKDATE, 3);
                  //  if (AuxMonth > 1) then
                  //    ClosingMonthOpt := AuxMonth - 2  //Comienza en cero y nos vamos al mes anterior
                  //  else begin
                  //    Year -= 1;
                  //    ClosingMonthOpt := ClosingMonthOpt::December;   //Si es enero ser  el diciembre anterior
                  //  end;
                  //  }
                   //-Q18730
                 end;

trigger OnPreReport();    var
//                   realMarkMonth@1100286000 :
                  realMarkMonth: Integer;
                begin
                  //Q13643+
                  if QuoBuildingSetup."Block Reestimations" then begin
                    //la variable type tendra el valor Copiar en los meses no marcados entre los campos 142 a 153,
                    realMarkMonth := (ClosingMonthOpt + 1);//Comienza en cero
                    if not FunctionQB.AllowReestimationMonth(realMarkMonth) then
                      Type := Type::Copiar
                    else// y el valor Reestimar en los meses en que est‚n marcados los campos 142 a 153,
                      Type := Type::Reestimar;
                  end;
                  //Q13643-
                end;

trigger OnPostReport();    begin
                   //MESSAGE(FinishText);
                 end;



// LOCAL procedure CopyJobBudgetToNextMonth (JobBudget@1100286001 :
LOCAL procedure CopyJobBudgetToNextMonth (JobBudget: Record 7207407) : Code[20];
    begin
      //NextMonthJobBudget.COPY(JobBudget);
      txtYear := FORMAT(DATE2DMY(NextMonthStart, 3));
      txtMonth := FORMAT(DATE2DMY(NextMonthStart, 2));
      if STRLEN(txtMonth) < 2 then
        txtMonth := '0' + txtMonth;

      NextMonthJobBudget.INIT;
      NextMonthJobBudget."Job No." := JobBudget."Job No.";
      NextMonthJobBudget."Cod. Budget" := txtYear + '-' + txtMonth;
      NextMonthJobBudget.VALIDATE("Budget Date", NextMonthStart);
      NextMonthJobBudget."Budget Name" := SetName(NextMonthStart);  //JAV 09/10/19: - Se informa del nombre del presupuesto con el nombre del mes y el a¤o
      NextMonthJobBudget.INSERT(TRUE);
      //JAV 10/08/19: - Si se copia o se reestima el nuevo presupuesto
      CASE Type OF
        Type::Copiar :
          begin
            CLEAR(CopyJobBudget);
            CopyJobBudget.PassParameters2(NextMonthJobBudget, JobBudget."Cod. Budget");
            CopyJobBudget.USErequestpage(FALSE);
            CopyJobBudget.RUN;
          end;
        Type::Reestimar :
          begin
            CLEAR(BudgetReestimationInitialize);
            BudgetReestimationInitialize.RUN(NextMonthJobBudget);
          end;
      end;

      //Marcamos presupuesto actual, lo vuelvo a leer porque los procesos anteriores pueden haber modificado el registro
      NextMonthJobBudget.GET(NextMonthJobBudget."Job No.",NextMonthJobBudget."Cod. Budget");
      NextMonthJobBudget."Actual Budget" := TRUE;
      NextMonthJobBudget.MODIFY(TRUE);

      exit(NextMonthJobBudget."Cod. Budget");
    end;

//     LOCAL procedure SetName (pDate@1100286000 :
    LOCAL procedure SetName (pDate: Date) : Text;
    var
//       lText@1100286001 :
      lText: Text;
    begin
      CASE DATE2DMY(pDate, 2) OF
         1 : lText := 'Enero';
         2 : lText := 'Febrero';
         3 : lText := 'Marzo';
         4 : lText := 'Abril';
         5 : lText := 'Mayo';
         6 : lText := 'Junio';
         7 : lText := 'Julio';
         8 : lText := 'Agosto';
         9 : lText := 'Septiembre';
        10 : lText := 'Octubre';
        11 : lText := 'Noviembre';
        12 : lText := 'Diciembre';
      end;
      lText := STRSUBSTNO(Txt001, lText, DATE2DMY(pDate, 3));
      if (Type = Type::Reestimar) then
        lText += ' (Reest.)';
      exit(COPYSTR(lText,1,MAXSTRLEN(JobBudget."Budget Name")));
    end;

//     procedure SetMonth (pJobNo@1100286000 :
    procedure SetMonth (pJobNo: Code[20])
    begin
      JobBudget.RESET;
      JobBudget.SETRANGE("Job No.", pJobNo);
      JobBudget.SETRANGE("Actual Budget", TRUE);
      if (JobBudget.FINDFIRST) then begin
        ClosingMonthOpt := DATE2DMY(JobBudget."Budget Date", 2) - 1; //Comienza en cero
        //Year := DATE2DMY(JobBudget."Budget Date", 3);
      end;
    end;

    LOCAL procedure SetType ()
    var
//       JobBudget@1100286002 :
      JobBudget: Record 7207407;
//       YearSetType@1100286001 :
      YearSetType: Integer;
    begin
      //JAV 20/07/21: - QB 1.09.11 Calculo del tipo seg£n el mes, se pasa a funci¢n para usarlo mas veces. Incluye Q13643
      Month := (ClosingMonthOpt + 2);  //Comienza en cero, y vemos lo que pasa el mes siguiente al que estamos cerrando
      //+Q18730
      JobBudget.RESET;
      JobBudget.SETRANGE("Job No.", pJobNo);
      JobBudget.SETRANGE("Actual Budget", TRUE);
      if (JobBudget.FINDFIRST) then begin
        YearActiveBudget := DATE2DMY(JobBudget."Budget Date",3);
        if (Month > 12) then begin  //Si estamos en diciembre abriremos Enero
        Month := 1;
        Year := DATE2DMY(JobBudget."Budget Date", 3) + 1;
      end else
        Year := DATE2DMY(JobBudget."Budget Date", 3);
      end;
      //-Q18730

      if QuoBuildingSetup."Block Reestimations" then begin
        if not FunctionQB.AllowReestimationMonth(Month) then
          Type := Type::Copiar
        else
          Type := Type::Reestimar;
      end else begin
        QuoBuildingSetup.GET();
        CASE QuoBuildingSetup."Close month process" OF
          QuoBuildingSetup."Close month process"::Copy       : Type := Type::Copiar;
          QuoBuildingSetup."Close month process"::Reestimate : Type := Type::Reestimar;
        end;
      end;

      txtName := SetName(DMY2DATE(1,Month, Year));

      //+Q18730
    end;

//     procedure Parametros (pJob@1100286000 : Code[20];pBudget@1100286001 :
    procedure Parametros (pJob: Code[20];pBudget: Code[20])
    begin
      pJobNo:= pJob;
      pBudgetNo:= pBudget;
      //-Q18730
    end;

    /*begin
    //{
//                    - QCPM_GAP08 Proceso de cierre del mes en curso de una obra, crea un nuevo presupuesto copiando del actual
//      JAV 11/10/19: - Mejoras para copiar mes o restimarlo
//      Q13643 MMS 14/07/21 Mejoras en la ficha de objetivos del proyecto cambios en OnInitReport, OnPreReport sobre reestimaci¢n de objetivos
//      AML 26/06/23: - Q18150 Llamada para filtrar bien el mes
//    }
    end.
  */
  
}




