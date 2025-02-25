report 7207356 "Move Costs Budget"
{
  
  
    CaptionML=ENU='Move Costs Budget',ESP='mover ppto. costes';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code");
               
                                 ;
trigger OnPreDataItem();
    BEGIN 
                               IF FORMAT(RegularLongDate) = '' THEN
                                 ERROR(Text003);

                               CLEAR(Currency);
                               Currency.InitRoundingPrecision;
                               ExpectedTimeUnitData.SETCURRENTKEY("Job No.","Piecework Code","Budget Code");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  Job.GET("Data Piecework For Production"."Job No.");
                                  IF Job."Latest Reestimation Code" <> '' THEN
                                    ERROR(Text004);

                                  //JAV 17/12/2018 Mover tambi‚n las fechas de las UO
                                  "Date init" := CALCDATE(RegularLongDate, "Date init");  //Primero cambio las dos fechas para evitar errores en la validaci¢n
                                  "Date end" := CALCDATE(RegularLongDate, "Date end");

                                  VALIDATE("Date init");    //Y ahora que las dos est n cambiadas las valido
                                  VALIDATE("Date end");
                                  MODIFY;
                                  //JAV 17/12/2018 fin

                                  Job.JobStatus(Job."No.");
                                  BudgetFilter := "Data Piecework For Production".GETFILTER("Budget Filter");
                                  IF BudgetFilter = '' THEN
                                    "Data Piecework For Production".SETRANGE("Budget Filter",'');
                                  "Data Piecework For Production".CALCFIELDS("Measure Pending Budget","Budget Measure");

                                  ExpectedTimeUnitData.SETRANGE("Job No.","Data Piecework For Production"."Job No.");
                                  ExpectedTimeUnitData.SETRANGE("Piecework Code","Data Piecework For Production"."Piecework Code");
                                  ExpectedTimeUnitData.SETRANGE("Budget Code",BudgetFilter);
                                  ExpectedTimeUnitData.SETRANGE(Performed,FALSE);
                                  IF ExpectedTimeUnitData.FINDSET THEN
                                    REPEAT
                                      ExpectedTimeUnitDataInsert := ExpectedTimeUnitData;
                                      ExpectedTimeUnitDataInsert."Expected Date" := CALCDATE(RegularLongDate,ExpectedTimeUnitData."Expected Date");
                                      ExpectedTimeUnitDataInsert.MODIFY;
                                    UNTIL ExpectedTimeUnitData.NEXT = 0;
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group624")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("RegularLongDate";"RegularLongDate")
    {
        
                  CaptionML=ENU='Length Term',ESP='Longitud del periodo';
    }

}

}
}
  }
  labels
{
}
  
    var
//       RegularLongDate@7001100 :
      RegularLongDate: DateFormula;
//       Text003@7001101 :
      Text003: TextConst ENU='Must indicate length of casting period',ESP='Debe indicar longitud del periodo de reparto';
//       Currency@7001102 :
      Currency: Record 4;
//       Job@7001104 :
      Job: Record 167;
//       Text004@7001105 :
      Text004: TextConst ENU='This functionality can not be used for job already reestimations',ESP='No se puede emplear esta funcionalidad para proyectos ya reestimados';
//       BudgetFilter@7001106 :
      BudgetFilter: Code[20];
//       ExpectedTimeUnitData@7001107 :
      ExpectedTimeUnitData: Record 7207388;
//       ExpectedTimeUnitDataInsert@7001108 :
      ExpectedTimeUnitDataInsert: Record 7207388;
//       "--- JAV 17/12/20018"@1100286000 :
      "--- JAV 17/12/20018": Integer;
//       aux1@1100286004 :
      aux1: Text;
//       aux2@1100286003 :
      aux2: Text;
//       DataPieceworkForProductionMayor@1100286002 :
      DataPieceworkForProductionMayor: Record 7207386;
//       DataPieceworkForProductionUnidad@1100286001 :
      DataPieceworkForProductionUnidad: Record 7207386;

    /*begin
    {
      JAV 17/12/2018 - Mover tambi‚s las fechas de las UO
    }
    end.
  */
  
}



