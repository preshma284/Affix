table 7207407 "Job Budget"
{
  
  
    CaptionML=ENU='Job Budget',ESP='Presupuestos Obra';
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(2;"Cod. Budget";Code[20])
    {
        CaptionML=ENU='Cod. Budget',ESP='C¢d. Presupuesto';
                                                   NotBlank=true;


    }
    field(3;"Budget Name";Text[30])
    {
        CaptionML=ENU='Budget Name',ESP='Nombre Presupuesto';


    }
    field(4;"Budget Date";Date)
    {
        CaptionML=ENU='Budget Date',ESP='Fecha Presupuesto';


    }
    field(5;"Status";Option)
    {
        OptionMembers="Open","Close";CaptionML=ENU='Status',ESP='Estado';
                                                   OptionCaptionML=ENU='Open,Close',ESP='Abierto,Cerrado';
                                                   
                                                   Editable=false;


    }
    field(6;"Cod. Reestimation";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Cod. Reestimation',ESP='C¢d. Reestimaci¢n';

trigger OnValidate();
    BEGIN 
                                                                FunctionQB.ValidateReest("Cod. Reestimation");
                                                              END;

trigger OnLookup();
    BEGIN 
                                                              IF FunctionQB.LookUpReest("Cod. Reestimation",FALSE) THEN
                                                                VALIDATE("Cod. Reestimation","Cod. Reestimation");
                                                            END;


    }
    field(7;"Actual Budget";Boolean)
    {
        CaptionML=ENU='Actual Budget',ESP='Presupuesto actual';
                                                   Editable=false;


    }
    field(8;"Production Budget Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount" WHERE ("Entry Type"=CONST("Incomes"),
                                                                                                                  "Job No."=FIELD("Job No."),
                                                                                                                  "Expected Date"=FIELD(FILTER("Filter Date")),
                                                                                                                  "Cod. Budget"=FIELD("Cod. Budget")));
                                                   CaptionML=ENU='Production Budget Amount',ESP='Importe producci¢n ppto.';
                                                   Editable=false;


    }
    field(9;"Filter Date";Date)
    {
        FieldClass=FlowFilter;
                                                   CaptionML=ENU='Filter Date',ESP='Filtro fecha';


    }
    field(10;"Budget Simulation";Boolean)
    {
        CaptionML=ENU='Budget Simulation',ESP='Ppto. Simulaci¢n';


    }
    field(11;"Reestimation";Boolean)
    {
        CaptionML=ENU='Budget Simulation',ESP='Reestimaci¢n';
                                                   Description='JAV 11/10/19: - Si el presupuesto se ha reestimado, no editable';
                                                   Editable=false;


    }
    field(12;"Origin";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Budget Simulation',ESP='Origen';
                                                   Description='JAV 11/10/19: - De donde se ha copiado/reestimado el presupuesto actual';
                                                   Editable=false;


    }
    field(13;"Budget Ref.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Budget Simulation',ESP='Master Ref.';
                                                   Description='JAV 29/01/20: Marcar que es el master de referencia';
                                                   Editable=false;


    }
    field(14;"Initial Budget";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Presupuesto Inicial';
                                                   Description='QB 1.06.11 - JAV 25/08/20: - Si es el presupuesto inicial del proyecto';
                                                   Editable=false;


    }
    field(15;"Cost in closed period";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cost in closed period',ESP='Se han registrado costes';
                                                   Description='Q13715';


    }
    field(20;"Budget Amount Cost";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                  "Cod. Budget"=FIELD("Cod. Budget"),
                                                                                                                  "Entry Type"=CONST("Expenses"),
                                                                                                                  "Expected Date"=FIELD("Filter Date")));
                                                   CaptionML=ENU='Budget Amount Cost',ESP='Importe coste ppto.';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(21;"Budget Amount Cost Direct";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                  "Cod. Budget"=FIELD("Cod. Budget"),
                                                                                                                  "Entry Type"=CONST("Expenses"),
                                                                                                                  "Expected Date"=FIELD("Filter Date"),
                                                                                                                  "Unit Type"=CONST("Job Unit")));
                                                   CaptionML=ENU='Budget Amount Cost',ESP='Importe coste ppto. Directos';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(22;"Budget Amount Cost Indirect";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                  "Cod. Budget"=FIELD("Cod. Budget"),
                                                                                                                  "Entry Type"=CONST("Expenses"),
                                                                                                                  "Expected Date"=FIELD("Filter Date"),
                                                                                                                  "Unit Type"=CONST("Cost Unit")));
                                                   CaptionML=ENU='Budget Amount Cost',ESP='Importe coste ppto. Indirectos';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(40;"Med Presupuestada";Decimal)
    {
        DataClassification=ToBeClassified;


    }
    field(41;"Med Ejecutada";Decimal)
    {
        DataClassification=ToBeClassified;


    }
    field(42;"Porcentaje Ejecutado";Decimal)
    {
        DataClassification=ToBeClassified;


    }
    field(43;"Coste Directo Ejecutado";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Editable=false;


    }
    field(44;"Coste Indirecto Ejecutado";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Editable=false;


    }
    field(45;"Coste Total Ejecutado";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Editable=false;


    }
    field(46;"Importe Directo Esperado";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Editable=false;


    }
    field(47;"Diferencia Directos Esperada";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Editable=false;


    }
    field(50;"Importe Total Esperado";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Editable=false;


    }
    field(52;"Resultado Produccion";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Resultado Producci¢n';
                                                   Editable=false;


    }
    field(53;"Importe Produccion Ejecutada";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Producci¢n Ejecutada';
                                                   Editable=false;


    }
    field(54;"Otros Ingresos";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Editable=false;


    }
    field(56;"Pending Calculation Budget";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='JAV 30/01/19: - Si el presupuesto est  pendiente de calculo';


    }
    field(57;"Pending Calculation Analitical";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='JAV 30/01/19: - Si el presupuesto anal¡tico est  pendiente de calculo';


    }
    field(60;"Value Date";Date)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Value Date',ESP='Fecha valor Divisa';
                                                   Description='GEN003-03';

trigger OnValidate();
    VAR
//                                                                 ForecastDataAmountPiecework@1100286000 :
                                                                ForecastDataAmountPiecework: Record 7207392;
                                                              BEGIN 
                                                                ForecastDataAmountPiecework.RESET;
                                                                ForecastDataAmountPiecework.SETRANGE("Job No.", Rec."Job No.");
                                                                ForecastDataAmountPiecework.SETRANGE("Cod. Budget", "Cod. Budget");
                                                                IF ForecastDataAmountPiecework.FINDSET THEN BEGIN 
                                                                  REPEAT
                                                                    ForecastDataAmountPiecework.VALIDATE("Currency Amount Date", Rec."Value Date");
                                                                    ForecastDataAmountPiecework.MODIFY(TRUE);
                                                                  UNTIL ForecastDataAmountPiecework.NEXT = 0;
                                                                END;
                                                              END;


    }
    field(61;"Production Budget Amount (LCY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount (LCY)" WHERE ("Entry Type"=CONST("Incomes"),
                                                                                                                          "Job No."=FIELD("Job No."),
                                                                                                                          "Expected Date"=FIELD(FILTER("Filter Date")),
                                                                                                                          "Cod. Budget"=FIELD("Cod. Budget")));
                                                   CaptionML=ENU='Production Budget Amount (LCY)',ESP='Importe producci¢n ppto. (DL)';
                                                   Description='GEN003-03';
                                                   Editable=false;


    }
    field(62;"Budget Amount Cost (LCY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount (LCY)" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                          "Cod. Budget"=FIELD("Cod. Budget"),
                                                                                                                          "Entry Type"=CONST("Expenses"),
                                                                                                                          "Expected Date"=FIELD("Filter Date")));
                                                   CaptionML=ENU='Budget Amount Cost (LCY)',ESP='Importe coste ppto. (DL)';
                                                   Description='GEN003-03';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(63;"Production Budget Amount (ACY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount (ACY)" WHERE ("Entry Type"=CONST("Incomes"),
                                                                                                                          "Job No."=FIELD("Job No."),
                                                                                                                          "Expected Date"=FIELD(FILTER("Filter Date")),
                                                                                                                          "Cod. Budget"=FIELD("Cod. Budget")));
                                                   CaptionML=ENU='Production Budget Amount (ACY)',ESP='Importe producci¢n ppto. (DR)';
                                                   Description='GEN003-03';
                                                   Editable=false;


    }
    field(64;"Budget Amount Cost (ACY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Forecast Data Amount Piecework"."Amount (ACY)" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                          "Cod. Budget"=FIELD("Cod. Budget"),
                                                                                                                          "Entry Type"=CONST("Expenses"),
                                                                                                                          "Expected Date"=FIELD("Filter Date")));
                                                   CaptionML=ENU='Budget Amount Cost (ACY)',ESP='Importe coste ppto. (DR)';
                                                   Description='GEN003-03';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(70;"Target Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("QB Objectives Header"."Total Target" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                   "Budget Code"=FIELD("Cod. Budget")));
                                                   CaptionML=ESP='Importe Objetivo';
                                                   Editable=false;


    }
    field(120;"Approval Status";Option)
    {
        OptionMembers="Open","Released","Pending Approval";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Estado Aprobaci¢n';
                                                   OptionCaptionML=ENU='Open,Released,Pending Approval',ESP='Abierto,Lanzado,Aprobaci¢n pendiente';
                                                   
                                                   Description='QB 1.00- JAV 10/03/20: - Estado de aprobaci¢n';
                                                   Editable=false;


    }
    field(121;"OLD_Approval Situation";Option)
    {
        OptionMembers="Pending","Approved","Rejected","Withheld";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Status',ESP='Situaci¢n de la Aprobaci¢n';
                                                   OptionCaptionML=ESP='Pendiente,Aprobado,Rechazado,Retenido';
                                                   
                                                   Description='### ELIMINAR ### no se usa';
                                                   Editable=false;


    }
    field(122;"OLD_Approval Coment";Text[80])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Comentario Aprobaci¢n';
                                                   Description='### ELIMINAR ### no se usa';
                                                   Editable=false;


    }
    field(123;"OLD_Approval Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha aprobaci¢n';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(600;"QPR End Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha fin';
                                                   Description='QB 1.09.05 JAV 15/07/21 Fecha de fin del presupuesto';


    }
    field(610;"QPR Cost Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QPR Amounts"."Cost Amount" WHERE ("Job No."=FIELD("Job No."),
                                                                                                      "Budget Code"=FIELD("Cod. Budget"),
                                                                                                      "Type"=CONST("Cost")));
                                                   CaptionML=ESP='Importe Presup. Gastos';
                                                   Description='Importe del gasto presupuestado';
                                                   Editable=false;


    }
    field(611;"QPR Cost Comprometido";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Gastos Comprometidos';
                                                   Description='Importe del gasto';
                                                   Editable=false;


    }
    field(612;"QPR Cost Performed";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Gastos Realizados';
                                                   Editable=false;


    }
    field(613;"QPR Cost Invoiced";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Gastos Facturados';
                                                   Description='Importe del ingreso presupuestado';
                                                   Editable=false;


    }
    field(620;"QPR Sale Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QPR Amounts"."Sale Amount" WHERE ("Job No."=FIELD("Job No."),
                                                                                                      "Budget Code"=FIELD("Cod. Budget"),
                                                                                                      "Type"=CONST("Sales")));
                                                   CaptionML=ESP='Importe Presup. Ingresos';
                                                   Description='Estos son para calcular los movimientos';
                                                   Editable=false;


    }
    field(621;"QPR Sale Comprometido";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Ingresos Comprometidos';
                                                   Description='Importe del gasto';
                                                   Editable=false;


    }
    field(622;"QPR Sale Performed";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Ingresos Realizados';
                                                   Editable=false;


    }
    field(623;"QPR Sale Invoiced";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Ingresos Facturados';
                                                   Editable=false;


    }
    field(7207336;"QB Approval Circuit Code";Code[20])
    {
        TableRelation="QB Approval Circuit Header" WHERE ("Document Type"=CONST("Budget"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Approval Circuit Code',ESP='Circuito de Aprobaci�n';
                                                   Description='QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


    }
    field(7238177;"QB Budget item";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Account Type"=FILTER("Unit"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='QPR' ;


    }
}
  keys
{
    key(key1;"Job No.","Cod. Budget")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Job@1100286000 :
      Job: Record 167;
//       JobBudget@1100286001 :
      JobBudget: Record 7207407;
//       MeasurementLinPiecewProd@7001100 :
      MeasurementLinPiecewProd: Record 7207390;
//       DataCostByPiecework@7001101 :
      DataCostByPiecework: Record 7207387;
//       ExpectedTimeUnitData@7001102 :
      ExpectedTimeUnitData: Record 7207388;
//       ForecastDataAmountPiecework@7001103 :
      ForecastDataAmountPiecework: Record 7207392;
//       Text000@1100286003 :
      Text000: TextConst ENU='You have not entered a code for the quote',ESP='No ha indicado un c¢digo para el presupuesto';
//       Text001@7001104 :
      Text001: TextConst ENU='It is not allowed to rename job budget',ESP='No est  permitido renombrar presupuesto de obra';
//       FunctionQB@7001105 :
      FunctionQB: Codeunit 7207272;
//       Reestimation@7001106 :
      Reestimation: Code[20];
//       Text002@1100286002 :
      Text002: TextConst ESP='A_BORRAR';
//       Text003@1100286004 :
      Text003: TextConst ENU='You have not indicated the date in the budget %1',ESP='No ha indicado la fecha en el presupuesto %1';
//       QuoBuildingSetup@1100286005 :
      QuoBuildingSetup: Record 7207278;
//       QBObjectivesHeader@1100286006 :
      QBObjectivesHeader: Record 7207403;
//       Text004@1100286007 :
      Text004: TextConst ENU='The objectives card is in negative, do you want to create the new budget?',ESP='La ficha de objeticos est  en negativo, ¨desea crear el nuevo presupuesto?';
//       TextError001@1100286008 :
      TextError001: TextConst ENU='The budget objectives sheet has not been established %1',ESP='No se ha establecido la ficha de objetivos del presupuesto %1';

    

trigger OnInsert();    var
//                TxtMsgError01@1100286000 :
               TxtMsgError01: TextConst ENU='It is not possible to create new budgets with the objective card in negative.',ESP='No se puede crear nuevos presupuestos con la ficha de objetivos en negativo.';
//                monthObj@1100286001 :
               monthObj: Integer;
//                TxtMsgError02@1100286003 :
               TxtMsgError02: TextConst ENU='Canceled at the request of the user.',ESP='Cancelado a petici¢n del usuario.';
//                TxtMsg01@1100286002 :
               TxtMsg01: TextConst ENU='The objectives card is in negative, do you want to create the new budget?',ESP='La ficha de objetivos est  en negativo, ¨desea crear el nuevo presupuesto?';
//                TxtMsg02@1100286004 :
               TxtMsg02: TextConst ESP='No ha establecido ninguna ficha de objetivos';
             begin
               //JAV 27/10/20: - QB 1.07.00 No dejar dar de alta presupuestos sin c¢digo
               if ("Cod. Budget" = '') then
                 ERROR(Text000);

               //Q13643 + No se deja crear un nuevo presupuesto si la ficha de objetivos es negativa y no est  aprobada
               if Job.GET("Job No.") then   //JAV 29/09/21: - QB 1.09.99 Solo para proyectos operativos
                 if (Job."Card Type" = Job."Card Type"::"Proyecto operativo") then  begin
                   QuoBuildingSetup.GET();
                   if (QuoBuildingSetup."Control Negative Target") then begin //Solo si el campo "Control Negative Target" de la configuraci¢n de quobuilding est  activo.
                     QBObjectivesHeader.RESET;
                     QBObjectivesHeader.SETCURRENTKEY("Job No.","Budget Date");
                     QBObjectivesHeader.SETRANGE("Job No.", Rec."Job No.");  //Q13643 filtrando por el campo del c¢digo del proyecto
                     if QBObjectivesHeader.FINDLAST then begin               //Q13643 el £ltimo existente si se encuentra
                       if (QBObjectivesHeader."Total Target" < 0) and (not QBObjectivesHeader."Allow Negative") then begin //Q13643 ver si importe total es menor que cero y NO est  aprobado permitir el negativo
                         monthObj := DATE2DMY(QBObjectivesHeader."Budget Date",2);
                         if (FunctionQB.AllowReestimationMonth(monthObj)) then begin //Q13643 Si el campo 141 est  activado, y el mes de fecha presupuesto est  entre los meses marcados en campos 142 a 153
                           ERROR(TxtMsgError01);
                         end else begin  //Q13643 En caso contrario, pedir confirmaci¢n
                           if not CONFIRM(TxtMsg01,TRUE) then begin
                             ERROR(TxtMsgError02) //Q13643 si no confirman sigue si no cancela el alta
                           end;
                         end;
                       end;
                     end else
                       ERROR(TxtMsg02);
                   end;
                 end;
               //Q13643 -
             end;

trigger OnDelete();    begin
               MeasurementLinPiecewProd.SETRANGE("Job No.","Job No.");
               MeasurementLinPiecewProd.SETRANGE("Code Budget","Cod. Budget");
               MeasurementLinPiecewProd.DELETEALL;

               DataCostByPiecework.SETRANGE("Job No.","Job No.");
               DataCostByPiecework.SETRANGE("Cod. Budget","Cod. Budget");
               DataCostByPiecework.DELETEALL;

               ExpectedTimeUnitData.SETCURRENTKEY("Job No.");
               ExpectedTimeUnitData.SETRANGE("Job No.","Job No.");
               ExpectedTimeUnitData.SETRANGE("Budget Code","Cod. Budget");
               ExpectedTimeUnitData.DELETEALL;

               ForecastDataAmountPiecework.SETCURRENTKEY("Job No.");
               ForecastDataAmountPiecework.SETRANGE("Job No.","Job No.");
               ForecastDataAmountPiecework.SETRANGE("Cod. Budget","Cod. Budget");
               //JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
               ForecastDataAmountPiecework.SETFILTER("Unit Type",'%1|%2',ForecastDataAmountPiecework."Entry Type"::Expenses,ForecastDataAmountPiecework."Entry Type"::Incomes);

               ForecastDataAmountPiecework.DELETEALL;

               GET("Job No.","Cod. Budget");   //Esto hay que hacerlo porque al borrar marca como debe recalcular, si no refresco no funcionar 

               //Si es un proyecto operativo y eliminamos el presupuesto actual del proyecto hay que cambiarlo
               if Job.GET("Job No.") then begin
                 if (Job."Card Type" = Job."Card Type"::"Proyecto operativo") and (Job."Current Piecework Budget" = "Cod. Budget") then begin
                   //Cambiar el presupuesto actual por el £ltimo que exista por fechas
                   JobBudget.RESET;
                   JobBudget.SETCURRENTKEY("Job No.","Budget Date");
                   JobBudget.SETRANGE("Job No.", "Job No.");
                   JobBudget.SETFILTER("Cod. Budget",'<>%1',"Cod. Budget");
                   JobBudget.SETRANGE("Actual Budget", TRUE); //Si hay uno activo ese debe ser, aunque esto no debe darse
                   if (not JobBudget.FINDLAST) then
                     JobBudget.SETRANGE("Actual Budget");  //Si no, buscamos cualquiera

                   if (JobBudget.FINDLAST) then begin
                     JobBudget."Actual Budget" := TRUE;
                     JobBudget.Status := JobBudget.Status::Open;
                     JobBudget.MODIFY;
                     Job."Current Piecework Budget" := JobBudget."Cod. Budget";
                   end else
                     Job."Current Piecework Budget" := '';

                   Job.MODIFY;
                 end;
               end;
             end;

trigger OnRename();    begin
               //JAV 04/11/20: - QB 1.07.03 Permitir renombrar presupuestos a un nombre preestablecido (as¡ puedo cambiar los que no tienen c¢digo)
               if ("Cod. Budget" <> Text002) then
                 ERROR(Text001);
             end;



procedure Margins ()
    begin
    end;

    procedure CalculateMarginBudget () : Decimal;
    begin

      CALCFIELDS("Production Budget Amount","Budget Amount Cost");

       exit("Production Budget Amount"-"Budget Amount Cost");
    end;

    procedure CalculateMarginBudgetPercentage () : Decimal;
    begin
      CALCFIELDS("Production Budget Amount","Budget Amount Cost");

      if "Production Budget Amount" <> 0 then
        exit(ROUND((("Production Budget Amount"-"Budget Amount Cost")*100/"Production Budget Amount"),0.01))
      else
        exit(0);
    end;

    procedure CalculateProduction ()
    var
//       DP@1100286000 :
      DP: Record 7207386;
//       PrecioCosteReal@1100286001 :
      PrecioCosteReal: Decimal;
//       MedicionPendiente@1100286002 :
      MedicionPendiente: Decimal;
//       ImportePendiente@1100286003 :
      ImportePendiente: Decimal;
//       ImporteEsperado@1100286004 :
      ImporteEsperado: Decimal;
//       PrecioCosteMedio@1100286005 :
      PrecioCosteMedio: Decimal;
//       Diferencia@1100286006 :
      Diferencia: Decimal;
    begin
      Job.GET("Job No.");
      if (Job."Card Type" = Job."Card Type"::"Proyecto operativo") and (Rec."Budget Date" = 0D) then
        ERROR(Text003, Rec."Cod. Budget");

      //JAV 14/06/19: - Se Calculan los totales de importe de producci¢n ejecutada
      "Med Presupuestada" := 0;
      "Med Ejecutada" := 0;
      "Porcentaje Ejecutado" := 0;
      "Coste Directo Ejecutado" := 0;
      "Coste Indirecto Ejecutado" := 0;
      "Coste Total Ejecutado" := 0;
      "Importe Directo Esperado" := 0;
      "Diferencia Directos Esperada" := 0;
      "Importe Total Esperado" := 0;
      "Importe Produccion Ejecutada" := 0;
      "Otros Ingresos" := 0;

      DP.RESET;
      DP.SETRANGE("Job No.", "Job No.");
      DP.SETRANGE("Account Type",DP."Account Type"::Unit);
      DP.SETFILTER("Budget Filter", "Cod. Budget");
      if DP.FINDSET(FALSE) then begin
        repeat
          //JMMA 120121 se cambia para que calcule datos hasta la fecha de reestimaci¢n menos uno
          //{
//          DP.SETRANGE("Budget Filter", "Cod. Budget");
//          DP.CALCFIELDS("Amount Production Performed", "Measure Pending Budget", "Total Measurement Production", "Amount Cost Performed (JC)",
//                        "Amount Cost Budget (JC)", "Aver. Cost Price Pend. Budget", "Amount Sale Performed (JC)","Budget Measure");
//                        }
          //JMMA 240221
          //DP.SETFILTER("Filter Date",'..%1',CALCDATE('-1D',Rec."Budget Date"));
          if Rec."Budget Date"<>0D then
            DP.SETFILTER("Filter Date",'..%1',CALCDATE('-1D',Rec."Budget Date"));
          DP.CALCFIELDS("Amount Production Performed", "Amount Cost Performed (JC)", "Amount Sale Performed (JC)");
          DP.SETRANGE("Filter Date");
          DP.CALCFIELDS("Measure Pending Budget", "Total Measurement Production",
                        "Amount Cost Budget (JC)", "Aver. Cost Price Pend. Budget","Budget Measure");
          //--JMMA 120121

          //if (DP."Total Measurement Production" <> 0) then
          //  PrecioCosteReal := ROUND(DP."Amount Cost Performed LCY" / DP."Total Measurement Production", 0.01);
          MedicionPendiente := DP."Budget Measure" - DP."Total Measurement Production";
          ImportePendiente := MedicionPendiente * DP."Aver. Cost Price Pend. Budget";
          ImporteEsperado := DP."Amount Cost Performed (JC)" + ImportePendiente;
          //if (DP."Measure Pending Budget" <> 0) then
          //  PrecioCosteMedio := ROUND(ImporteEsperado / DP."Measure Pending Budget", 0.01);

          if (DP.Type = DP.Type::Piecework) then begin
            "Med Presupuestada" += DP."Budget Measure"; // DP."Measure Pending Budget";
            "Med Ejecutada" += DP."Total Measurement Production";
            "Importe Produccion Ejecutada" += DP."Amount Production Performed";
            "Coste Directo Ejecutado" += DP."Amount Cost Performed (JC)";
            "Importe Directo Esperado" += ImporteEsperado;
            "Diferencia Directos Esperada" := "Coste Directo Ejecutado" - "Importe Directo Esperado";
            if (DP."Amount Sale Performed (JC)" <> 0) and (DP."Amount Production Performed" = 0) then
              "Otros Ingresos" += -DP."Amount Sale Performed (JC)";
          end else begin
            "Coste Indirecto Ejecutado" += DP."Amount Cost Performed (JC)";
          end;


        until DP.NEXT=0;

        //CPA 25-04-22. Q17043. C�clulo del Coste Directo ejecutado y Coste Indirecto ejecutado.begin
        getDirectAndIndirectCostAmounts("Job No.", "Budget Date", '', "Coste Indirecto Ejecutado", "Coste Directo Ejecutado");
        "Diferencia Directos Esperada" := "Coste Directo Ejecutado" - "Importe Directo Esperado";
        //CPA 25-04-22. Q17043. C�clulo del Coste Directo ejecutado y Coste Indirecto ejecutado.end
      end;

      CALCFIELDS("Budget Amount Cost Indirect");

      "Coste Total Ejecutado" := "Coste Directo Ejecutado" + "Coste Indirecto Ejecutado";
      "Importe Total Esperado" := "Importe Directo Esperado" + "Budget Amount Cost Indirect";
      "Resultado Produccion" := "Importe Produccion Ejecutada" + "Otros Ingresos" - "Coste Total Ejecutado";

      if ("Med Presupuestada" <> 0) then
          "Porcentaje Ejecutado" := ROUND("Med Ejecutada" * 100 / "Med Presupuestada", 0.01);
      if Rec."Cod. Budget"<>'' then //JMMA 240121 a¤adido por error al calcular ppto en estudios.
        MODIFY;
    end;

    procedure RenameToEliminate () : Text;
    begin
      RENAME("Job No.",Text002);
    end;

//     LOCAL procedure getDirectAndIndirectCostAmounts (JobNo@1100286001 : Code[20];BudgetDate@1100286003 : Date;GlobalDimension2Filter@1100286005 : Text;var CosteIndirectoEjecutado@1100286002 : Decimal;var CosteDirectoEjecutado@1100286004 :
    LOCAL procedure getDirectAndIndirectCostAmounts (JobNo: Code[20];BudgetDate: Date;GlobalDimension2Filter: Text;var CosteIndirectoEjecutado: Decimal;var CosteDirectoEjecutado: Decimal)
    var
//       JobLedgEntry@1100286000 :
      JobLedgEntry: Record 169;
//       DP@1100286006 :
      DP: Record 7207386;
    begin
      //CPA 25-04-22. Q17043. C�clulo del Coste Directo ejecutado y Coste Indirecto ejecutado.begin
      JobLedgEntry.RESET;
      JobLedgEntry.SETCURRENTKEY("Job No.","Piecework No.","Entry Type","Posting Date","Global Dimension 2 Code");
      JobLedgEntry.SETRANGE("Job No.", JobNo);
      JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
      JobLedgEntry.SETFILTER("Posting Date", '..%1', CALCDATE('-1D', BudgetDate));
      JobLedgEntry.SETFILTER("Global Dimension 2 Code", GlobalDimension2Filter);

      CosteIndirectoEjecutado := 0;
      CosteDirectoEjecutado := 0;
      if JobLedgEntry.FINDSET then repeat
        if JobLedgEntry."Piecework No." <> '' then begin
          if (JobLedgEntry."Job No." <> DP."Job No.") or (JobLedgEntry."Piecework No." <> DP."Piecework Code") then
            DP.GET(JobLedgEntry."Job No.", JobLedgEntry."Piecework No.");

          if (DP.Type = DP.Type::Piecework) then
            CosteDirectoEjecutado += JobLedgEntry."Total Cost"
          else
            CosteIndirectoEjecutado += JobLedgEntry."Total Cost";
        end else
          CosteIndirectoEjecutado += JobLedgEntry."Total Cost";
      until JobLedgEntry.NEXT = 0;
      //CPA 25-04-22. Q17043. C�clulo del Coste Directo ejecutado y Coste Indirecto ejecutado.end
    end;

    /*begin
    //{
//      JAV 11/10/19: - Se a¤ade el campo 11 "Reestimation" que indica si el presupuesto se ha reestimado y el 12 "Origin" con el presupuesto del que se ha copiado o restimado
//      JAV 29/01/20: - Se a¤ade el campo 12 para Marcar que es el master de referencia
//      JAV 31/01/20: - Se a¤ade el campo de estado de si los importes necesitan recalcularse
//      QMD 23/06/21: - Q13715 Se a¤ade campo "Cost in closed period"
//      MMS 13/07/21: - Q13643 Mejoras en la ficha de objetivos del proyecto
//      JAV 20/10/21: - QB 1.09.22 Considerar �nicamente ingresos y gastos, no certificaciones
//      CPA 25/04/22: - QB 1.10.37 (Q17043) C�clulo del Coste Directo ejecutado y Coste Indirecto ejecutado. Modificada funci�n CalculateProduction y a�adida getDirectAndIndirectCostAmounts
//    }
    end.
  */
}







