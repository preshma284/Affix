report 7207279 "Suggest Cost Data. Piecework"
{
  
  
    ProcessingOnly=true;
    
  dataset
{

DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Account Type"=CONST("Unit"),"Customer Certification Unit"=CONST(true));
               

               RequestFilterFields="Piecework Code";
trigger OnPreDataItem();
    BEGIN 
                               "Data Piecework For Production".SETRANGE("Job No.",MeasurementHeader."Job No.");

                               //GAP029 - Si hay expediente, solo las de este
                               IF MeasurementHeader."Expedient No." <> '' THEN
                                 "Data Piecework For Production".SETRANGE("No. Record",MeasurementHeader."Expedient No.");

                               ThereIsDatabaseCost := FALSE;
                               CalcNoLine;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  InsertLines;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                IF NOT ThereIsDatabaseCost THEN ERROR(Text003);
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
//       MeasurementHeader@7001101 :
      MeasurementHeader: Record 7207336;
//       LinMeasurement@7001103 :
      LinMeasurement: Record 7207337;
//       ForLineMeasurement@7001106 :
      ForLineMeasurement: Record 7207337;
//       DataPieceworkForProduction@7001105 :
      DataPieceworkForProduction: Record 7207386;
//       Text003@7001107 :
      Text003: TextConst ENU='Cost Database pieceworks don''t exist',ESP='No existe unidades de obra preciario';
//       Job@1100286000 :
      Job: Record 167;
//       Filtrppres@1100286003 :
      Filtrppres: Text[250];
//       ThereIsDatabaseCost@1100286002 :
      ThereIsDatabaseCost: Boolean;
//       NoLine@1100286001 :
      NoLine: Integer;

    

trigger OnPreReport();    begin
                  Filtrppres := "Data Piecework For Production".GETFILTERS;
                end;



procedure CalcNoLine ()
    begin
      WITH MeasurementHeader DO begin
        LinMeasurement.RESET;
        LinMeasurement.SETRANGE("Document No.","No.");
        if LinMeasurement.FINDLAST then
          NoLine := LinMeasurement."Line No." + 10000
        else
          NoLine := 10000;
      end;
    end;

    procedure InsertLines ()
    begin
      WITH MeasurementHeader DO begin
        //Si ya est  en el documento no lo vuelvo a crear
        ForLineMeasurement.RESET;
        ForLineMeasurement.SETRANGE("Document No.", MeasurementHeader."No.");
        ForLineMeasurement.SETRANGE("Job No.", MeasurementHeader."Job No.");
        ForLineMeasurement.SETRANGE("Piecework No.", "Data Piecework For Production"."Piecework Code");
        if (ForLineMeasurement.ISEMPTY) then begin
          ForLineMeasurement.INIT;
          ForLineMeasurement."Document type" := "Document Type";
          ForLineMeasurement."Document No." := "No.";
          ForLineMeasurement."Line No." := NoLine;
          ForLineMeasurement.VALIDATE("Job No.","Job No.");
          ForLineMeasurement.VALIDATE("Piecework No.","Data Piecework For Production"."Piecework Code");
          if DataPieceworkForProduction.GET("Data Piecework For Production"."Job No.",
                             "Data Piecework For Production"."Piecework Code") then
            ForLineMeasurement.Description := DataPieceworkForProduction.Description;
          ForLineMeasurement.VALIDATE("Job No.","Job No.");
          ForLineMeasurement.VALIDATE("Contract Price","Data Piecework For Production"."Unit Price Sale (base)");
          ForLineMeasurement.VALIDATE(ForLineMeasurement."Last Price Redetermined","Data Piecework For Production"."Last Unit Price Redetermined");
          ForLineMeasurement.INSERT(TRUE);

          NoLine:= NoLine + 10000;
          ThereIsDatabaseCost := TRUE;
        end;
      end;
    end;

//     procedure SetParameters (var NewMeasurementHeader@1000 :
    procedure SetParameters (var NewMeasurementHeader: Record 7207336)
    begin
      MeasurementHeader := NewMeasurementHeader;
    end;

    /*begin
    //{
//      JDC 30/07/19: - KALAM GAP029 Modified function "Data Piecework For Production - OnPreDataItem"
//    }
    end.
  */
  
}



