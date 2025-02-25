report 7207321 "Assign Sales to Production"
{
  
  
    CaptionML=ENU='Assign Sales to Production',ESP='Asignar venta a producci¢n';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Type"=CONST("Piecework"),"Account Type"=CONST("Unit"),"Production Unit"=CONST(true));
DataItemLink="Job No."= FIELD("No.") ;
trigger OnAfterGetRecord();
    BEGIN 
                                  "Data Piecework For Production".CALCFIELDS("Amount Cost Budget (JC)","Budget Measure");

                                  IF "Data Piecework For Production"."Budget Measure" <> 0 THEN BEGIN 
                                    "Data Piecework For Production"."Initial Produc. Price" :=
                                        ROUND(("Data Piecework For Production"."Amount Cost Budget (JC)" * AbsorptionRatio) /
                                               "Data Piecework For Production"."Budget Measure",Currency."Amount Rounding Precision");

                                  "Data Piecework For Production".MODIFY;
                                  END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                IF Job.GET(Job."No.") THEN BEGIN 
                                  DataPieceworkForProduction.RESET;
                                  DataPieceworkForProduction.SETRANGE("Job No.","Job No.");
                                  IF DataPieceworkForProduction.FINDFIRST THEN BEGIN 
                                    ConvertToBudgetxCA.UpdateBudgetxCA(DataPieceworkForProduction,JobIsVersion,"Data Piecework For Production"."Job No.");
                                  END;
                                END;
                              END;


}
trigger OnPreDataItem();
    BEGIN 
                               CLEAR(Currency);
                               Currency.InitRoundingPrecision;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  CALCFIELDS(Job."Amou Piecework Meas./Certifi.");
                                  CostTotalJob := CostTotalDirect;
                                  IF CostTotalJob <> 0 THEN
                                    AbsorptionRatio := Job."Amou Piecework Meas./Certifi." / CostTotalJob
                                  ELSE
                                    BEGIN 
                                      MESSAGE(Text0001);
                                      CurrReport.BREAK;
                                    END;
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
//       Currency@7001100 :
      Currency: Record 4;
//       CostTotalJob@7001101 :
      CostTotalJob: Decimal;
//       AbsorptionRatio@7001102 :
      AbsorptionRatio: Decimal;
//       Text0001@7001103 :
      Text0001: TextConst ENU='There is no defined cost of production.',ESP='No hay definido coste de producci¢n.';
//       DataPieceworkForProduction@7001104 :
      DataPieceworkForProduction: Record 7207386;
//       ConvertToBudgetxCA@7001105 :
      ConvertToBudgetxCA: Codeunit 7207282;
//       JobIsVersion@7001106 :
      JobIsVersion: Boolean;

    procedure CostTotalDirect () : Decimal;
    var
//       Cost@7001100 :
      Cost: Decimal;
//       DataPieceworkForProduction@7001101 :
      DataPieceworkForProduction: Record 7207386;
    begin
      Cost := 0;
      DataPieceworkForProduction.RESET;
      DataPieceworkForProduction.SETRANGE("Account Type",DataPieceworkForProduction."Account Type"::Unit);
      DataPieceworkForProduction.SETRANGE("Production Unit",TRUE);
      DataPieceworkForProduction.SETRANGE(Type,DataPieceworkForProduction.Type::Piecework);
      if DataPieceworkForProduction.FINDSET then begin
        repeat
          DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
          Cost := Cost + DataPieceworkForProduction."Amount Cost Budget (JC)";
        until DataPieceworkForProduction.NEXT = 0;
      end;
      exit(Cost);
    end;

    /*begin
    end.
  */
  
}



