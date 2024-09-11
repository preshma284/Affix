report 7207414 "Operat. projects without level"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Operat. projects without level',ESP='Proyectos Operativos sin nivel';
    
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               ;
Column(CAB_Company_Picture;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(CAB_Company_Name;CompanyInformation.Name)
{
//SourceExpr=CompanyInformation.Name;
}Column(CAB_Job_No;Job."No.")
{
//SourceExpr=Job."No.";
}Column(CAB_Job_Description;Job.Description)
{
//SourceExpr=Job.Description;
}Column(CAB_Job_Description2;Job."Description 2")
{
//SourceExpr=Job."Description 2";
}Column(CAB_BudgetCode;optBudgetCode)
{
//SourceExpr=optBudgetCode;
}Column(CAB_FirstDate;optFirstDate)
{
//SourceExpr=optFirstDate;
}Column(CAB_LastDate;optLastDate)
{
//SourceExpr=optLastDate;
}DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Type")
                                 ORDER(Ascending);
DataItemLink="Job No."= FIELD("No.");
Column(DPP_IsUnit;IsUnit)
{
//SourceExpr=IsUnit;
}Column(DPP_IsIndirect;IsIndirect)
{
//SourceExpr=IsIndirect;
}Column(DPP_Indent_UnitWorkCode;Indent_UnitWorkCode)
{
//SourceExpr=Indent_UnitWorkCode;
}Column(DPP_Indent_Description;Indent_Description)
{
//SourceExpr=Indent_Description;
}Column(DPP_Type;"Data Piecework For Production".Type)
{
//SourceExpr="Data Piecework For Production".Type;
}Column(DPP_PieceworkCode;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(DPP_Indentation;"Data Piecework For Production".Indentation)
{
//SourceExpr="Data Piecework For Production".Indentation;
}Column(DPP_UnitOfMeasure;"Data Piecework For Production"."Unit Of Measure")
{
//SourceExpr="Data Piecework For Production"."Unit Of Measure";
}Column(DPP_Importes_1_04;Importes[1,4])
{
//SourceExpr=Importes[1,4];
}Column(DPP_Importes_1_06;Importes[1,6])
{
//SourceExpr=Importes[1,6];
}Column(DPP_Importes_2_06;Importes[2,6])
{
//SourceExpr=Importes[2,6];
}Column(DPP_Importes_1_07;Importes[1,7])
{
//SourceExpr=Importes[1,7];
}Column(DPP_Importes_2_07;Importes[2,7])
{
//SourceExpr=Importes[2,7];
}Column(DPP_Importes_1_08;Importes[1,8])
{
//SourceExpr=Importes[1,8];
}Column(DPP_Importes_2_08;Importes[2,8])
{
//SourceExpr=Importes[2,8];
}Column(DPP_Importes_1_09;Importes[1,9])
{
//SourceExpr=Importes[1,9];
}Column(DPP_Importes_2_09;Importes[2,9])
{
//SourceExpr=Importes[2,9];
}Column(DPP_Importes_1_10;Importes[1,10])
{
//SourceExpr=Importes[1,10];
}Column(DPP_Importes_2_10;Importes[2,10])
{
//SourceExpr=Importes[2,10];
}Column(DPP_Importes_1_11;Importes[1,11])
{
//SourceExpr=Importes[1,11];
}Column(DPP_Importes_2_11;Importes[2,11])
{
//SourceExpr=Importes[2,11];
}Column(DPP_Importes_1_12;Importes[1,12])
{
//SourceExpr=Importes[1,12];
}Column(DPP_Importes_2_12;Importes[2,12])
{
//SourceExpr=Importes[2,12];
}Column(DPP_Importes_1_13;Importes[1,13])
{
//SourceExpr=Importes[1,13];
}Column(DPP_Importes_2_13;Importes[2,13])
{
//SourceExpr=Importes[2,13];
}Column(DPP_Importes_1_14;Importes[1,14])
{
//SourceExpr=Importes[1,14];
}Column(DPP_Importes_2_14;Importes[2,14])
{
//SourceExpr=Importes[2,14];
}Column(DPP_Importes_1_15;Importes[1,15])
{
//SourceExpr=Importes[1,15];
}Column(DPP_Importes_2_15;Importes[2,15])
{
//SourceExpr=Importes[2,15];
}Column(DPP_Importes_1_16;Importes[1,16])
{
//SourceExpr=Importes[1,16];
}Column(DPP_Importes_1_17;Importes[1,17])
{
//SourceExpr=Importes[1,17];
}Column(DPP_Importes_2_17;Importes[2,17])
{
//SourceExpr=Importes[2,17];
}Column(DPP_Importes_1_18;Importes[1,18])
{
//SourceExpr=Importes[1,18];
}Column(DPP_Importes_2_18;Importes[2,18])
{
//SourceExpr=Importes[2,18];
}Column(DPP_Importes_1_19;Importes[1,19])
{
//SourceExpr=Importes[1,19];
}Column(DPP_Importes_2_19;Importes[2,19])
{
//SourceExpr=Importes[2,19];
}Column(DPP_Importes_1_20;Importes[1,20])
{
//SourceExpr=Importes[1,20];
}Column(DPP_Importes_2_20;Importes[2,20])
{
//SourceExpr=Importes[2,20];
}Column(DPP_Importes_1_21;Importes[1,21])
{
//SourceExpr=Importes[1,21];
}Column(DPP_Importes_2_21;Importes[2,21])
{
//SourceExpr=Importes[2,21];
}Column(DPP_Importes_1_22;Importes[1,22])
{
//SourceExpr=Importes[1,22];
}Column(DPP_Importes_2_22;Importes[2,22])
{
//SourceExpr=Importes[2,22];
}Column(TotalGeneral_1_07;TotalGeneral[1,7])
{
//SourceExpr=TotalGeneral[1,7];
}Column(TotalGeneral_2_07;TotalGeneral[2,7])
{
//SourceExpr=TotalGeneral[2,7];
}Column(TotalGeneral_1_09;TotalGeneral[1,9])
{
//SourceExpr=TotalGeneral[1,9];
}Column(TotalGeneral_2_09;TotalGeneral[2,9])
{
//SourceExpr=TotalGeneral[2,9];
}Column(TotalGeneral_1_11;TotalGeneral[1,11])
{
//SourceExpr=TotalGeneral[1,11];
}Column(TotalGeneral_2_11;TotalGeneral[2,11])
{
//SourceExpr=TotalGeneral[2,11];
}Column(TotalGeneral_1_13;TotalGeneral[1,13])
{
//SourceExpr=TotalGeneral[1,13];
}Column(TotalGeneral_2_13;TotalGeneral[2,13])
{
//SourceExpr=TotalGeneral[2,13];
}Column(TotalGeneral_1_14;TotalGeneral[1,14])
{
//SourceExpr=TotalGeneral[1,14];
}Column(TotalGeneral_2_14;TotalGeneral[2,14])
{
//SourceExpr=TotalGeneral[2,14];
}Column(TotalGeneral_1_18;TotalGeneral[1,18])
{
//SourceExpr=TotalGeneral[1,18];
}Column(TotalGeneral_2_18;TotalGeneral[2,18])
{
//SourceExpr=TotalGeneral[2,18];
}Column(TotalGeneral_1_20;TotalGeneral[1,20])
{
//SourceExpr=TotalGeneral[1,20];
}Column(TotalGeneral_2_20;TotalGeneral[2,20])
{
//SourceExpr=TotalGeneral[2,20];
}Column(TotalGeneral_1_21;TotalGeneral[1,21])
{
//SourceExpr=TotalGeneral[1,21];
}Column(TotalGeneral_2_21;TotalGeneral[2,21] )
{
//SourceExpr=TotalGeneral[2,21] ;
}trigger OnPreDataItem();
    BEGIN 
                               "Data Piecework For Production".SETFILTER("Filter Date",'%1..%2',optFirstDate,optLastDate);
                               "Data Piecework For Production".SETFILTER("Budget Filter",optBudgetCode);

                               IF optLevelsText <> '' THEN
                                 "Data Piecework For Production".SETFILTER(Indentation,'<=%1',Levels);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  //--------------------------DATOS GENERALES-----------------------
                                  IsUnit := ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit);
                                  IsIndirect :=  ("Data Piecework For Production".Type = "Data Piecework For Production".Type::"Cost Unit");

                                  //--------------------------INDENTACIàN---------------------------
                                  Indent_Description := '';
                                  Indent_UnitWorkCode := '';
                                  IndentSpace := '';

                                  FOR i := 0 TO "Data Piecework For Production".Indentation DO BEGIN 
                                    Indent_Description  +=  '   ';
                                    Indent_UnitWorkCode  +=  '   ';
                                  END;

                                  //-------------------------- PGM 06/07/2020 TEXTO----------------
                                  QBText.RESET;
                                  QBText.SETRANGE(Key1,"Data Piecework For Production"."Job No.");
                                  QBText.SETRANGE(Key2,"Data Piecework For Production"."Piecework Code");
                                  IF QBText.FINDFIRST THEN BEGIN 
                                    QBText.CALCFIELDS("Cost Text");
                                    QBText."Cost Text".CREATEINSTREAM(InStr,TEXTENCODING::Windows);
                                    InStr.READTEXT(Indent_Description);
                                  END ELSE
                                    Indent_Description  +=  "Data Piecework For Production".Description;

                                  Indent_UnitWorkCode  +=  "Data Piecework For Production"."Piecework Code";


                                  //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. -
                                  CLEAR(TotalGeneral);
                                  //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. +

                                  IF ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit) THEN BEGIN 
                                    CalcLine("Data Piecework For Production"."Job No.", "Data Piecework For Production"."Piecework Code");
                                  END ELSE BEGIN 
                                    CLEAR(Totales);
                                    DPPTot.RESET;
                                    DPPTot.SETRANGE("Job No.", "Data Piecework For Production"."Job No.");
                                    DPPTot.SETFILTER("Piecework Code", "Data Piecework For Production".Totaling);
                                    DPPTot.SETRANGE("Account Type", DPPTot."Account Type"::Unit);
                                    IF (DPPTot.FINDSET(FALSE)) THEN
                                      REPEAT
                                        //Calcular todas las unidades internas
                                        CalcLine(DPPTot."Job No.", DPPTot."Piecework Code");
                                        //Sumas los importes
                                        FOR i:=1 TO ARRAYLEN(Importes, 2) DO BEGIN 
                                          Totales[1,i] += Importes[1,i];
                                          Totales[2,i] += Importes[2,i];
                                        END;
                                      UNTIL (DPPTot.NEXT = 0);

                                    //Cambiar la suma de lugar
                                    FOR i:=1 TO ARRAYLEN(Importes, 2) DO BEGIN 
                                      Importes[1,i] := Totales[1,i];
                                      Importes[2,i] := Totales[2,i];
                                    END;

                                  END;

                                  //Calcular los porcentuales
                                  CalcPorc;

                                  //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. -
                                  IF"Data Piecework For Production".Indentation = 0 THEN BEGIN 
                                    FOR i:=1 TO ARRAYLEN(Importes, 2) DO BEGIN 
                                      //TotalGeneral[1,i] += Totales[1,i];
                                      //TotalGeneral[2,i] += Totales[2,i];
                                      TotalGeneral[1,i] += Importes[1,i];
                                      TotalGeneral[2,i] += Importes[2,i];
                                    END;

                                    CalcPorcTotalGen;
                                  END;
                                  //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. +
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               Job.SETRANGE("No.",optJobNo);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. -
                                  IF NOT(JobBudget."Cod. Budget" = optBudgetCode) THEN
                                    JobBudget.GET(Job."No.",optBudgetCode);

                                  JobBudget.CALCFIELDS("Production Budget Amount");
                                  ImporteProdPpto := JobBudget."Production Budget Amount";
                                  //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. +
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
    field("JobNo";"optJobNo")
    {
        
                  CaptionML=ENU='Proyect',ESP='Proyecto';
                  TableRelation=Job;
                  
                              ;trigger OnValidate()    BEGIN

                               IF optBudgetCode <>'' THEN
                                 IF Job.GET(optJobNo)THEN BEGIN
                                   IF NOT JobBudget.GET(optJobNo,optBudgetCode) THEN BEGIN
                                     optBudgetCode := '';
                                   END;
                                 END ELSE
                                     optBudgetCode := '';
                             END;


    }
    field("BudgetCode";"optBudgetCode")
    {
        
                  CaptionML=ENU='Budget',ESP='Presupuesto';
                  TableRelation="Job Budget"."Cod. Budget";
                  
                            ;trigger OnLookup(var Text: Text): Boolean    BEGIN

                             CLEAR(JobBudgetList);
                             CLEAR(JobBudget);

                             JobBudgetList.LOOKUPMODE(TRUE);
                             IF optJobNo <> '' THEN BEGIN
                                 JobBudget.SETRANGE("Job No.", optJobNo);
                                 JobBudgetList.SETTABLEVIEW(JobBudget);
                             END;

                             IF JobBudgetList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                 JobBudgetList.GETRECORD(JobBudget);
                                 optBudgetCode := JobBudget."Cod. Budget";
                                 IF optJobNo = '' THEN
                                   optJobNo := JobBudget."Job No.";
                             END;
                           END;


    }
    field("FirstDate";"optFirstDate")
    {
        
                  CaptionML=ENU='First Date',ESP='Fecha desde';
    }
    field("LastDate";"optLastDate")
    {
        
                  CaptionML=ENU='Last Date',ESP='Fecha hasta';
    }
    field("LevelsText";"optLevelsText")
    {
        
                  CaptionML=ENU='Levels (all blank)',ESP='Niveles (Blanco todos)';
    }

}
}
  }
  labels
{
Company='"Company: "/ "Empresa: "/';
Job='"Job: "/ "Obra: "/';
Budget_='"Budget: "/ "Presupuesto: "/';
DateFrom='"Date from: "/ "Fecha desde: "/';
DateUntil='"Date until: "/ "Fecha hasta: "/';
Month='Month:/ Periodo:/';
Beginning='Beginning:/ Origen:/';
PeriodResult_='Period result/ Resultado periodo/';
BeginningResult_='Beginning result/ Resultado origen/';
CAB_1_01='"Code "/ "C¢digo "/';
CAB_1_02='Description/ Descripci¢n/';
CAB_1_03='Unit/ Unidad/';
CAB_2_03='of Measure/ de medida/';
CAB_1_04='Total Medition/ Medici¢n Total/';
CAB_2_04='U.O./ Partida/';
CAB_1_05='" "/ " "/';
CAB_2_05='" "/ " "/';
CAB_1_06='Executed/ Ejecuci¢n/';
CAB_1_10='Coste Previsto/';
CAB_1_12='Coste Real/';
CAB_1_14='Desviaci¢n Coste/';
CAB_1_16='Certificaci¢n/';
CAB_1_21='Desviaci¢n Cert./Prod./';
CAB_2_06='Medition/ Medici¢n/';
CAB_2_07='% Advance/ % Avance/';
CAB_2_08='Precio/';
CAB_2_09='Importe/';
CAB_2_10='Precio/';
CAB_2_11='Importe/';
CAB_2_12='Precio/';
CAB_2_13='Importe/';
CAB_2_14='Importe/';
CAB_2_15='%/';
CAB_2_16='Med. a Cert./';
CAB_2_17='Med. Certificada/';
CAB_2_18='% Advance/ % Avance/';
CAB_2_19='Precio/';
CAB_2_20='Importe/';
CAB_2_21='Importe/';
CAB_2_22='%/';
}
  
    var
//       JobBudget@1100286015 :
      JobBudget: Record 7207407;
//       JobBudgetList@1100286014 :
      JobBudgetList: Page 7207598;
//       JobTable@1100286013 :
      JobTable: Record 167;
//       CompanyInformation@1100286012 :
      CompanyInformation: Record 79;
//       DPP@1100286002 :
      DPP: Record 7207386;
//       DPPTot@1100286010 :
      DPPTot: Record 7207386;
//       QBText@1100286017 :
      QBText: Record 7206918;
//       InStr@1100286016 :
      InStr: InStream;
//       Importes@1100286019 :
      Importes: ARRAY [2,30] OF Decimal;
//       Totales@1100286001 :
      Totales: ARRAY [2,30] OF Decimal;
//       Levels@7001189 :
      Levels: Integer;
//       Budget@7001179 :
      Budget: Text;
//       IndentSpace@7001177 :
      IndentSpace: Text;
//       Indent_Description@7001176 :
      Indent_Description: Text[250];
//       Indent_UnitWorkCode@7001173 :
      Indent_UnitWorkCode: Code[20];
//       FirstPage@1100286000 :
      FirstPage: Boolean;
//       i@7001172 :
      i: Integer;
//       IsUnit@7001191 :
      IsUnit: Boolean;
//       IsIndirect@1100286018 :
      IsIndirect: Boolean;
//       "--------------------------- Opciones"@1100286003 :
      "--------------------------- Opciones": Integer;
//       optJobNo@1100286005 :
      optJobNo: Code[20];
//       optBudgetCode@1100286004 :
      optBudgetCode: Code[20];
//       optFirstDate@1100286009 :
      optFirstDate: Date;
//       optLastDate@1100286008 :
      optLastDate: Date;
//       optLevelsText@1100286006 :
      optLevelsText: Text;
//       TotalGeneral@1100286007 :
      TotalGeneral: ARRAY [2,30] OF Decimal;
//       ImporteProdPpto@1100286011 :
      ImporteProdPpto: Decimal;

    

trigger OnPreReport();    begin
                  if not JobTable.GET(optJobNo) then
                    ERROR('Falta introducir proyecto');
                  if optLastDate = 0D then
                     ERROR('Falta introducir fecha hasta: ');

                  if not EVALUATE(Levels,optLevelsText) and (optLevelsText <> '') then
                    ERROR('N£mero niveles no v lido, solo admite n£mero o vacio (todos los niveles)')
                  else
                    Levels := Levels - 1;

                  if optBudgetCode = '' then begin
                    JobBudget.SETRANGE("Job No.",JobTable."No.");
                    JobBudget.SETRANGE("Actual Budget",TRUE);
                    if JobBudget.FINDSET(FALSE,FALSE) then;
                  end else
                    JobBudget.GET(JobTable."No.",optBudgetCode);

                  Budget := JobBudget."Budget Name";
                  optBudgetCode := JobBudget."Cod. Budget";

                  CompanyInformation.GET;
                  CompanyInformation.CALCFIELDS(Picture);
                  FirstPage := TRUE;
                end;



// procedure SetParameters (pJob@1100286000 : Code[20];pBudget@1100286001 : Code[20];pFini@1100286002 : Date;pFfin@1100286003 :
procedure SetParameters (pJob: Code[20];pBudget: Code[20];pFini: Date;pFfin: Date)
    begin
      //JAV 25/07/19: - Nuevo par metro de proyecto y presupuesto a imprimir
      optJobNo := pJob;
      optBudgetCode := pBudget;
      optFirstDate := pFini;
      optLastDate := pFfin;
    end;

//     LOCAL procedure CalcLine (pJob@1100286000 : Code[20];pPiecework@1100286001 :
    LOCAL procedure CalcLine (pJob: Code[20];pPiecework: Code[20])
    begin
      //---------------------------------------------------------------------------------------------------------------------
      //JAV 14/11/22: - QB 1.12.18 Esta funci¢n calcula los importes de una sola Unidad de Obra
      //---------------------------------------------------------------------------------------------------------------------
      CLEAR(Importes);

      DPP.RESET;
      DPP.GET(pJob,pPiecework);
      DPP.SETFILTER("Budget Filter",optBudgetCode);

      //------------------------- DATOS TOTALES ---------------------------------------------------------
      DPP.CALCFIELDS("Measure Budg. Piecework Sol");
      Importes[1,4]  := DPP."Measure Budg. Piecework Sol";        //Medici¢n de coste
      Importes[2,4]  := DPP."Measure Budg. Piecework Sol";        //Medici¢n de coste
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. -
      if DPP.Type = DPP.Type::"Cost Unit" then begin
        Importes[1,16] := 0;
      end else
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. +
      Importes[1,16] := DPP."Sale Quantity (base)";               //Medici¢n de Certificaci¢n
      Importes[2,16] := DPP."Sale Quantity (base)";               //Medici¢n de Certificaci¢n

      //------------------------- DATOS DEL PERIODO------------------------------------------------------
      DPP.SETFILTER("Filter Date", '%1..%2', optFirstDate,optLastDate);
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. -
      DPP.CALCFIELDS("Amount Cost Budget (JC)");
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. +
      DPP.CALCFIELDS("Total Measurement Production","Amount Production Performed","Amount Cost Performed (JC)","Certified Quantity","Certified Amount");
      Importes[1,6]  := DPP."Total Measurement Production";                                   //Medici¢n Ejecutada
      Importes[1,9]  := DPP."Amount Production Performed";                                    //Importe Ejecutado
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. -
      if DPP.Type = DPP.Type::"Cost Unit" then begin
        if DPP."Allocation Terms" = DPP."Allocation Terms"::"Fixed Amount" then begin
          Importes[1,11] := DPP."Amount Cost Budget (JC)";
        end else
          Importes[1,11] := DPP."Amount Cost Performed (JC)";  // se iguala con el Coste Real.
      end else
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. +
      Importes[1,11] := DPP.AmountCostTheoreticalProduction(JobBudget."Cod. Budget",DPP);     //Coste Previsto
      Importes[1,13] := DPP."Amount Cost Performed (JC)";                                     //Coste Real
      Importes[1,17] := DPP."Certified Quantity";                                             //Cantidad Certificada
      Importes[1,20] := DPP."Certified Amount";                                               //Importe Certificado

      //------------------------- DATOS A ORIGEN -------------------------------------------------------
      DPP.SETFILTER("Filter Date", '..%1',optLastDate);
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. -
      DPP.CALCFIELDS("Amount Cost Budget (JC)");
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. +
      DPP.CALCFIELDS("Total Measurement Production","Amount Production Performed","Amount Cost Performed (JC)","Certified Quantity","Certified Amount");
      Importes[2,6]  := DPP."Total Measurement Production";                                   //Medici¢n Ejecutada
      Importes[2,9]  := DPP."Amount Production Performed";                                    //Importe Ejecutado
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. -
      if DPP.Type = DPP.Type::"Cost Unit" then begin
        if DPP."Allocation Terms" = DPP."Allocation Terms"::"Fixed Amount" then begin
          Importes[2,11] := DPP."Amount Cost Budget (JC)";
        end else
          Importes[2,11] := DPP."Amount Cost Performed (JC)";  // se iguala con el Coste Real.
      end else
      //Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL. +
      Importes[2,11] := DPP.AmountCostTheoreticalProduction(JobBudget."Cod. Budget",DPP);     //Coste Previsto
      Importes[2,13] := DPP."Amount Cost Performed (JC)";                                     //Coste Real
      Importes[2,17] := DPP."Certified Quantity";                                             //Cantidad Certificada
      Importes[2,20] := DPP."Certified Amount";                                               //Importe Certificado
    end;

    LOCAL procedure CalcPorc ()
    begin
      //---------------------------------------------------------------------------------------------------------------------
      //JAV 14/11/22: - QB 1.12.18 Esta funci¢n calcula los importes que son porcentuales
      //---------------------------------------------------------------------------------------------------------------------
      FOR i:=1 TO 2 DO begin
        //% Avance Ejecuci¢n
        if (Importes[i,4] <> 0) then
          Importes[i,7] := ROUND(Importes[i,6] * 100 / Importes[i,4], 0.01)
        else
          Importes[i,7] := 0;

        //Precio Medio Ejecuci¢n
        if (Importes[i,6]  <>  0) then
          Importes[i,8] := ROUND(Importes[i,9] / Importes[i,6], 0.01)
        else
          Importes[i,8] := 0;

        //Precio medio coste previsto
        if (Importes[i,6]  <>  0) then
          Importes[i,10] := ROUND(Importes[i,11] / Importes[i,6], 0.01)
        else
          Importes[i,10] := 0;

        //Precio medio coste real
        if (Importes[i,6]  <>  0) then
          Importes[i,12] := ROUND(Importes[i,13] / Importes[i,6], 0.01)
        else
          Importes[i,12] := 0;

        //Desviacion coste en importe
        //Importes[i,14] := Importes[i,13] - Importes[i,11];  //SE COMENTA.  CSM 11/07/2023.
        Importes[i,14] := Importes[i,11] - Importes[i,13];  //SE INSERTA.  CSM 11/07/2023.

        //Desviacion coste en porcentaje
        if (Importes[i,11] <> 0) then
          Importes[i,15] := ROUND(Importes[i,14] * 100 / Importes[i,11], 0.01)
        else
          Importes[i,15] := 0;

        //% Avance Certificaci¢n
        if (Importes[i,16] <> 0) then
          Importes[i,18] := ROUND(Importes[i,17] * 100 / Importes[i,16], 0.01)
        else
          Importes[i,18] := 0;

        //Precio medio certificaci¢n
        if (Importes[i,17]  <>  0) then
          Importes[i,19] := ROUND(Importes[i,20] / Importes[i,17], 0.01)
        else
          Importes[i,19] := 0;

        //DIFERENCIA CERTIFICADO/PRODUCIDO en importe
        Importes[i,21] := Importes[i,20] - Importes[i,9];

        //DIFERENCIA CERTIFICADO/PRODUCIDO en porcentaje
        if (Importes[i,9] <> 0) then
          Importes[i,22] := ROUND(Importes[i,21] * 100 / Importes[i,9], 0.01)
        else
          Importes[i,22] := 0;
      end;
    end;

    LOCAL procedure CalcPorcTotalGen ()
    begin
      //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. -
      FOR i:=1 TO 2 DO begin
        //% Avance Ejecuci¢n TOTAL
        if ImporteProdPpto <> 0 then
          TotalGeneral[i,7] := ROUND(TotalGeneral[i,9] * 100 / ImporteProdPpto, 0.01)
        else
          TotalGeneral[i,7] := 0;

        //% Avance Certificaci¢n Total
        if (TotalGeneral[i,16] <> 0) then
          TotalGeneral[i,18] := ROUND(TotalGeneral[i,17] * 100 / TotalGeneral[i,16], 0.01)
        else
          TotalGeneral[i,18] := 0;
      end;
      //Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL. +
    end;

    /*begin
    //{
//      001 MRR 21/09/17 - A¤adida "IsUnit" para modificar condici¢n de visibilidad de las l¡neas en el layout
//      JAV 30/05/19: - Multiplicaba por 100 el precio de venta
//      JAV 25/07/19: - Nuevo par metro de proyecto a imprimir
//      Q19563 CSM 12/06/23 Í Inf. proyectos operativos sin NIVEL.
//              - Se importa el report desde PROD que es donde se ha probado.
//      Q19769 CSM 26/06/23 Í Hijo de 19563 Inf. proyectos operativos sin NIVEL.
//    }
    end.
  */
  
}




