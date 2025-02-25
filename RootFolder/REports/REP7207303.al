report 7207303 "Resource Generate Subcontract"
{
  
  
    ProcessingOnly=true;
  
  dataset
{

DataItem("Jobs Units";"Piecework")
{

               DataItemTableView=SORTING("Cost Database Default","No.");
               

               RequestFilterFields="Cost Database Default";
trigger OnPreDataItem();
    BEGIN 
                               ConfJobsUnits.GET;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF "Jobs Units"."Concept Analitycal Subcon Code" = '' THEN
                                    ERROR(Text001);

                                  IF "Jobs Units"."Resource Subcontracting Code" = '' THEN BEGIN 
                                    // Insertar recurso nuevo
                                    CLEAR(Resource);
                                    Resource.INIT();
                                    Resource.INSERT(TRUE);
                                    Resource.VALIDATE(Type,Resource.Type::Subcontracting);
                                    Resource.VALIDATE(Name,COPYSTR("Jobs Units".Description, 1, 30));
                                    IF NOT UnitofMeasure.GET("Jobs Units"."Units of Measure") THEN BEGIN 
                                      UnitofMeasure.INIT();
                                      UnitofMeasure.Code := "Jobs Units"."Units of Measure";
                                      UnitofMeasure.Description := "Jobs Units"."Units of Measure";
                                      UnitofMeasure.INSERT(TRUE);
                                    END;
                                    IF NOT ResourceUnitofMeasure.GET(Resource."No.","Jobs Units"."Units of Measure") THEN BEGIN 
                                      ResourceUnitofMeasure.INIT();
                                      ResourceUnitofMeasure.VALIDATE("Resource No.", Resource."No.");
                                      ResourceUnitofMeasure.VALIDATE(Code, "Jobs Units"."Units of Measure");
                                      ResourceUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                                      ResourceUnitofMeasure.INSERT(TRUE);
                                    END;
                                    Resource.VALIDATE("Base Unit of Measure", UnitofMeasure.Code);
                                    Resource.VALIDATE("Unit Cost", "Jobs Units"."Price Cost");
                                    Resource.VALIDATE("Gen. Prod. Posting Group", ConfJobsUnits."G.C. Resource PRESTO");
                                    Resource."Created by PRESTO S/N" := FALSE;
                                    Resource."Activity Code" := "Jobs Units"."Cod. Activity";
                                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN BEGIN 
                                      Resource.VALIDATE("Global Dimension 1 Code","Jobs Units"."Concept Analitycal Subcon Code");
                                    END;
                                    IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN BEGIN 
                                      Resource.VALIDATE("Global Dimension 2 Code", "Jobs Units"."Concept Analitycal Subcon Code");
                                    END;
                                    //JMMA
                                    Resource.VALIDATE(Name,COPYSTR("Jobs Units".Description, 1, 30));
                                    Resource.MODIFY(TRUE);
                                    ResourceCost.RESET();
                                    IF NOT ResourceCost.GET(ResourceCost.Type::Resource,Resource."No.") THEN BEGIN 
                                      // Meter un precio de coste
                                      ResourceCost.INIT();
                                      ResourceCost.VALIDATE(Type,ResourceCost.Type::Resource);
                                      ResourceCost.VALIDATE(Code,Resource."No.");
                                      ResourceCost.VALIDATE("Unit Cost","Jobs Units"."Price Cost");
                                      ResourceCost.INSERT(TRUE);
                                    END;
                                    "Jobs Units"."Resource Subcontracting Code" := Resource."No.";
                                    "Jobs Units".MODIFY;
                                  END;

                                  // Insertar Descompuesto
                                  BillofItemData."Cod. Cost database" := "Jobs Units"."Cost Database Default";
                                  BillofItemData."Cod. Piecework" := "Jobs Units"."No.";
                                  BillofItemData.Type := BillofItemData.Type::Resource;
                                  BillofItemData."No." := "Jobs Units"."Resource Subcontracting Code";
                                  BillofItemData.VALIDATE("Concep. Analytical Direct Cost","Jobs Units"."Concept Analitycal Subcon Code");
                                  BillofItemData."Quantity By" := 1;
                                  BillofItemData."Units of Measure" := "Jobs Units"."Units of Measure";
                                  BillofItemData."Direct Unit Cost" := "Jobs Units"."Price Cost";
                                  BillofItemData."Piecework Cost" := "Jobs Units"."Price Cost";
                                  BillofItemData."Bill of Item Units" := 1;
                                  BillofItemData.INSERT;
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
//       Resource@7207270 :
      Resource: Record 156;
//       UnitofMeasure@7207271 :
      UnitofMeasure: Record 204;
//       ResourceUnitofMeasure@7207272 :
      ResourceUnitofMeasure: Record 205;
//       ConfJobsUnits@7207279 :
      ConfJobsUnits: Record 7207279;
//       ResourceCost@7207273 :
      ResourceCost: Record 202;
//       BillofItemData@7207274 :
      BillofItemData: Record 7207384;
//       FunctionQB@7207275 :
      FunctionQB: Codeunit 7207272;
//       LastFieldNo@7207276 :
      LastFieldNo: Integer;
//       FooterPrinted@7207277 :
      FooterPrinted: Boolean;
//       Text001@7207278 :
      Text001: TextConst ENU='Must indicate analytical concept of subcontracting',ESP='Debe indicar concepto anal¡tico de subcontratacion';

    /*begin
    end.
  */
  
}



