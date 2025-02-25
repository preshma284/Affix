report 7207386 "Generate Sheet Amort. Plant"
{
  
  
    CaptionML=ENU='Generate Sheet Amort. Plant',ESP='Generar parte amort. planta';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               ;
DataItem("Data Cost By Piecework";"Data Cost By Piecework")
{

               DataItemTableView=SORTING("Job No.","Piecework Code","Cod. Budget","Cost Type","No.")
                                 WHERE("Cost Type"=CONST("Resource"));
DataItemLink="Job No."= FIELD("Job No."),
                            "Piecework Code"= FIELD("Piecework Code") ;
trigger OnPreDataItem();
    BEGIN 
                               "Data Cost By Piecework".SETRANGE("Cod. Budget",Job."Current Piecework Budget");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF "Data Cost By Piecework"."No." = '' THEN
                                    CurrReport.SKIP;

                                  CLEAR(WorksheetHeader);
                                  WorksheetHeader."Sheet Type" := WorksheetHeader."Sheet Type"::"By Resource";
                                  WorksheetHeader.INSERT(TRUE);
                                  WorksheetHeader.VALIDATE("No. Resource /Job","Data Cost By Piecework"."No.");
                                  WorksheetHeader.VALIDATE("Posting Date",WORKDATE);
                                  WorksheetHeader.VALIDATE("Sheet Date",WORKDATE);
                                  WorksheetHeader."Shop Depreciate Sheet" := TRUE;
                                  WorksheetHeader."Shop Cost Unit Code" := "Data Piecework For Production"."Piecework Code";
                                  WorksheetHeader.MODIFY(TRUE);

                                  CLEAR(WorkSheetLines);
                                  WorkSheetLines.SETRANGE("Document No.",WorksheetHeader."No.");
                                  IF WorkSheetLines.FINDLAST THEN
                                    NoLine := WorkSheetLines."Line No."
                                  ELSE
                                    NoLine := 0;

                                  Resource.GET(WorksheetHeader."No. Resource /Job");

                                  DataCostByPiecework.SETRANGE("Job No.","Data Piecework For Production"."Job No.");
                                  DataCostByPiecework.SETRANGE("Cod. Budget",Job."Current Piecework Budget");
                                  DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
                                  DataCostByPiecework.SETRANGE("No.","Data Cost By Piecework"."No.");
                                  IF DataCostByPiecework.FINDSET THEN
                                    REPEAT
                                      IF DataCostByPiecework."Piecework Code" <> "Data Piecework For Production"."Piecework Code" THEN BEGIN 
                                        DataPieceworkForProduction.GET("Data Piecework For Production"."Job No.",DataCostByPiecework."Piecework Code");
                                        DataPieceworkForProduction.SETRANGE("Filter Date",0D,WORKDATE);
                                        DataPieceworkForProduction.CALCFIELDS("Total Measurement Production");
                                        MeasurePerform := DataPieceworkForProduction."Total Measurement Production";
                                        DataCostByPiecework.SETRANGE("Filter Date",0D,WORKDATE);
                                        DataCostByPiecework.CALCFIELDS("Measure Resource Exec.");
                                        Consumed := DataCostByPiecework."Measure Resource Exec.";
                                        QuantityAllocation := (MeasurePerform * DataCostByPiecework."Performance By Piecework") - Consumed;

                                        IF QuantityAllocation <> 0 THEN BEGIN 
                                          NoLine := NoLine + 10000;
                                          WorkSheetLines."Document No.":=WorksheetHeader."No.";
                                          WorkSheetLines."Line No." := NoLine;
                                          WorkSheetLines.INSERT(TRUE);

                                          WorkSheetLines."Resource No." := WorksheetHeader."No. Resource /Job";
                                          WorkSheetLines."Job No." := "Data Piecework For Production"."Job No.";
                                          WorkSheetLines.VALIDATE("Work Day Date",WORKDATE);
                                          WorkSheetLines.VALIDATE("Job No.");
                                          WorkSheetLines.VALIDATE("Piecework No.",DataCostByPiecework."Piecework Code");
                                          WorkSheetLines.VALIDATE("Work Type Code",Resource."Cod. Type Depreciation Jobs");

                                          WorkSheetLines.VALIDATE(Quantity,QuantityAllocation);
                                          WorkSheetLines.VALIDATE("Direct Cost Price",DataCostByPiecework."Direct Unitary Cost (JC)");
                                          WorkSheetLines.VALIDATE("Cost Price",DataCostByPiecework."Direct Unitary Cost (JC)" +
                                                                DataCostByPiecework."Indirect Unit Cost");
                                          WorkSheetLines.MODIFY;
                                        END;
                                      END;
                                    UNTIL DataCostByPiecework.NEXT =0;

                                  IF SinceSheet = '' THEN
                                    SinceSheet := WorksheetHeader."No.";

                                  UntilSheet := WorksheetHeader."No.";
                                END;

trigger OnPostDataItem();
    BEGIN 
                                MESSAGE(Text001,SinceSheet,UntilSheet);
                              END;


}
trigger OnAfterGetRecord();
    BEGIN 
                                  Job.GET("Data Piecework For Production"."Job No.");
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       Job@7001100 :
      Job: Record 167;
//       DataCostByPiecework@7001101 :
      DataCostByPiecework: Record 7207387;
//       WorksheetHeader@7001102 :
      WorksheetHeader: Record 7207290;
//       WorkSheetLines@7001103 :
      WorkSheetLines: Record 7207291;
//       NoLine@7001104 :
      NoLine: Integer;
//       Resource@7001105 :
      Resource: Record 156;
//       DataPieceworkForProduction@7001106 :
      DataPieceworkForProduction: Record 7207386;
//       MeasurePerform@7001107 :
      MeasurePerform: Decimal;
//       Consumed@7001108 :
      Consumed: Decimal;
//       QuantityAllocation@7001109 :
      QuantityAllocation: Decimal;
//       SinceSheet@7001110 :
      SinceSheet: Code[20];
//       Text001@7001111 :
      Text001: TextConst ENU='Amortization parts have been created from %1 to %2',ESP='Se han creado partes de amortizaci¢n desde %1 hasta %2';
//       UntilSheet@7001112 :
      UntilSheet: Code[20];

    /*begin
    end.
  */
  
}



