report 7207315 "Gen. Resource Subcontr. Job"
{
  
  
    ProcessingOnly=true;
  
  dataset
{

DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               
                                 ;
trigger OnPreDataItem();
    BEGIN 
                               PieceworkSetup.GET;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF "Data Piecework For Production"."Analytical Concept Subcon Code" = '' THEN
                                    "Data Piecework For Production"."Analytical Concept Subcon Code" := PieceworkSetup."CA Resource Sub";

                                  IF "Data Piecework For Production"."Analytical Concept Subcon Code" = '' THEN
                                    ERROR(Text001);

                                  IF "Data Piecework For Production"."Price Subcontracting Cost" = 0 THEN
                                    ERROR(Text002);


                                  IF "Data Piecework For Production"."No. Subcontracting Resource" = '' THEN BEGIN 
                                    // Insetar Resource nuevo
                                    CLEAR(Resource);
                                    Resource.INIT();
                                    Resource.INSERT(TRUE);
                                    Resource.VALIDATE(Type, Resource.Type::Subcontracting);
                                    Resource.VALIDATE(Name, COPYSTR("Data Piecework For Production".Description, 1, 30));
                                    IF NOT UnitofMeasure.GET("Data Piecework For Production"."Unit Of Measure") THEN BEGIN 
                                      UnitofMeasure.INIT();
                                      UnitofMeasure.Code := "Data Piecework For Production"."Unit Of Measure";
                                      UnitofMeasure.Description := "Data Piecework For Production"."Unit Of Measure";
                                      UnitofMeasure.INSERT(TRUE);
                                    END;
                                    IF NOT ResourceUnitofMeasure.GET(Resource."No.", "Data Piecework For Production"."Unit Of Measure") THEN BEGIN 
                                      ResourceUnitofMeasure.INIT();
                                      ResourceUnitofMeasure.VALIDATE("Resource No.", Resource."No.");
                                      ResourceUnitofMeasure.VALIDATE(Code, "Data Piecework For Production"."Unit Of Measure");
                                      ResourceUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                                      ResourceUnitofMeasure.INSERT(TRUE);
                                    END;
                                    Resource.VALIDATE("Base Unit of Measure", UnitofMeasure.Code);
                                    Resource.VALIDATE("Unit Cost","Data Piecework For Production"."Price Subcontracting Cost");
                                    Resource.VALIDATE("Gen. Prod. Posting Group", PieceworkSetup."G.C. Resource PRESTO");
                                    Resource."Created by PRESTO S/N" := FALSE;
                                    Resource.VALIDATE("Activity Code","Data Piecework For Production"."Activity Code");

                                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN BEGIN 
                                      Resource.VALIDATE("Global Dimension 1 Code","Data Piecework For Production"."Analytical Concept Subcon Code");
                                    END;
                                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN BEGIN 
                                      Resource.VALIDATE("Global Dimension 2 Code","Data Piecework For Production"."Analytical Concept Subcon Code");
                                    END;
                                    Resource.MODIFY(TRUE);
                                    ResourceCost.RESET();
                                    IF NOT ResourceCost.GET(ResourceCost.Type::Resource, Resource."No.") THEN BEGIN 
                                      // Le meto un precio de coste
                                      ResourceCost.INIT();
                                      ResourceCost.VALIDATE(Type, ResourceCost.Type::Resource);
                                      ResourceCost.VALIDATE(Code, Resource."No.");
                                      ResourceCost.VALIDATE("Unit Cost","Data Piecework For Production"."Price Subcontracting Cost");
                                      ResourceCost.INSERT(TRUE);
                                    END;
                                    "Data Piecework For Production"."No. Subcontracting Resource" := Resource."No.";
                                    "Data Piecework For Production".MODIFY;
                                  END;


                                  // Insertar Descompuesto
                                  Job.GET("Data Piecework For Production"."Job No.");
                                  DataCostByPiecework.SETRANGE("Job No.","Data Piecework For Production"."Job No.");
                                  DataCostByPiecework.SETRANGE("Piecework Code","Data Piecework For Production"."Piecework Code");
                                  IF Job."Current Piecework Budget" <> '' THEN
                                    DataCostByPiecework.SETRANGE("Cod. Budget",Job."Current Piecework Budget")
                                  ELSE
                                    DataCostByPiecework.SETRANGE("Cod. Budget",Job."Initial Budget Piecework");

                                  DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
                                  DataCostByPiecework.SETRANGE("No.","Data Piecework For Production"."No. Subcontracting Resource");
                                  IF DataCostByPiecework.FINDFIRST THEN
                                    DataCostByPiecework.DELETEALL;

                                  CLEAR(DataCostByPiecework."Job No.");
                                  DataCostByPiecework."Job No.":="Data Piecework For Production"."Job No.";
                                  DataCostByPiecework."Piecework Code":="Data Piecework For Production"."Piecework Code";
                                  DataCostByPiecework."Cost Type" :=DataCostByPiecework."Cost Type"::Resource;
                                  DataCostByPiecework."No." :="Data Piecework For Production"."No. Subcontracting Resource";
                                  DataCostByPiecework.VALIDATE("Analytical Concept Direct Cost","Data Piecework For Production"."Analytical Concept Subcon Code");

                                  DataCostByPiecework.VALIDATE("Activity Code","Data Piecework For Production"."Activity Code"); //JAV 18/02/21: - QB 1.08.12 Pone la actividad en el descompuesto

                                  DataCostByPiecework."Budget Quantity" := 1;
                                  DataCostByPiecework."Performance By Piecework":=1;
                                  DataCostByPiecework."Cod. Measure Unit":= "Data Piecework For Production"."Unit Of Measure";
                                  DataCostByPiecework."Direct Unitary Cost (JC)":="Data Piecework For Production"."Price Subcontracting Cost";
                                  DataCostByPiecework."Budget Cost":="Data Piecework For Production"."Price Subcontracting Cost";
                                  IF Job."Current Piecework Budget" <> '' THEN
                                    DataCostByPiecework."Cod. Budget" := Job."Current Piecework Budget"
                                  ELSE
                                    DataCostByPiecework."Cod. Budget" := Job."Initial Budget Piecework";

                                  DataCostByPiecework.Description := "Data Piecework For Production".Description;
                                  DataCostByPiecework.INSERT;
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
//       PieceworkSetup@7001100 :
      PieceworkSetup: Record 7207279;
//       Text001@7001101 :
      Text001: TextConst ENU='Must indicate analytical concept of subcontracting.',ESP='Debe indicar concepto analitico de subcontratci¢n.';
//       Text002@7001102 :
      Text002: TextConst ENU='Must indicate a subcontracting price.',ESP='Debe indicar un precio de subcontratacion.';
//       Resource@7001103 :
      Resource: Record 156;
//       UnitofMeasure@7001104 :
      UnitofMeasure: Record 204;
//       ResourceUnitofMeasure@7001105 :
      ResourceUnitofMeasure: Record 205;
//       ResourceCost@7001107 :
      ResourceCost: Record 202;
//       Job@7001108 :
      Job: Record 167;
//       DataCostByPiecework@7001109 :
      DataCostByPiecework: Record 7207387;
//       FunctionQB@1100286000 :
      FunctionQB: Codeunit 7207272;

    /*begin
    end.
  */
  
}



