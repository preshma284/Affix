report 7207354 "Generate Broken Down"
{
  
  
    CaptionML=ENU='Generate Broken Down',ESP='Generar descompuesto comp. of.';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Comparative Quote Lines";"Comparative Quote Lines")
{

               DataItemTableView=SORTING("Quote No.","Type","No.","Activity Code")
                                 ORDER(Ascending);
               

               RequestFilterFields="Quote No.","Job No.","Activity Code","Piecework No.","Type","No.";
trigger OnPreDataItem();
    BEGIN 
                               Window.OPEN(Text001 +
                                            Text002 +
                                            Text003 +
                                            Text004 );
                               Counter := 0;
                             END;

trigger OnAfterGetRecord();
    VAR
//                                   RecLocOferta@1100251000 :
                                  RecLocOferta: Record 167;
                                BEGIN 
                                  Window.UPDATE(1,"Comparative Quote Lines"."Job No.");
                                  Window.UPDATE(2,"Comparative Quote Lines"."Piecework No.");
                                  Window.UPDATE(3,"Comparative Quote Lines"."No.");
                                  //JMMA modificado para que funcione en comparativos donde no hay unidad de obra TESTFIELD("Piecework No.");
                                  Job.GET("Comparative Quote Lines"."Job No.");
                                  DataCostByPiecework.SETRANGE(DataCostByPiecework."Job No.",Job."No.");
                                  IF "Comparative Quote Lines"."Piecework No."<>'' THEN
                                    DataCostByPiecework.SETRANGE(DataCostByPiecework."Piecework Code","Comparative Quote Lines"."Piecework No.");
                                  DataCostByPiecework.SETRANGE(DataCostByPiecework."Cod. Budget",Job."Current Piecework Budget");
                                  IF Type = Type::Item THEN
                                    DataCostByPiecework.SETRANGE(DataCostByPiecework."Cost Type",DataCostByPiecework."Cost Type"::Item);
                                  IF Type = Type::Resource THEN
                                    DataCostByPiecework.SETRANGE(DataCostByPiecework."Cost Type",DataCostByPiecework."Cost Type"::Resource);
                                  DataCostByPiecework.SETRANGE(DataCostByPiecework."No.","Comparative Quote Lines"."No.");
                                  ComparativeQuoteHeader.GET("Quote No.");
                                  RecLocOferta.GET(ComparativeQuoteHeader."Job No.");
                                  //JMMA CAMBIO POR NUEVO CAMPO ESTADO PARA ESTUDIOS/OBRAS
                                  //IF (RecLocOferta.Status=RecLocOferta.Status::Open) AND
                                  //    (NOT "Comparative Quote Lines".Manual)  THEN
                                  //     CurrReport.SKIP;

                                  //IF (RecLocOferta."Card Type"=RecLocOferta."Card Type"::Estudio) AND
                                  //    (NOT "Comparative Quote Lines".Manual)  THEN
                                  //     CurrReport.SKIP;


                                  "Comparative Quote Lines".CALCFIELDS("Lowest Price","Purchase Price","Selected Vendor");
                                  IF NOT DataCostByPiecework.FINDFIRST THEN BEGIN 
                                    IF "Comparative Quote Lines"."Piecework No."<>'' THEN BEGIN 
                                      DataCostByPiecework.INIT;
                                      DataCostByPiecework.VALIDATE("Job No.","Comparative Quote Lines"."Job No.");
                                      DataCostByPiecework.VALIDATE("Piecework Code","Comparative Quote Lines"."Piecework No.");
                                      IF Type = Type::Item THEN
                                        DataCostByPiecework.VALIDATE("Cost Type",DataCostByPiecework."Cost Type"::Item);
                                      IF Type = Type::Resource THEN
                                        DataCostByPiecework.VALIDATE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
                                      DataCostByPiecework.VALIDATE("No.","No.");
                                      DataPieceworkForProduction.GET(DataCostByPiecework."Job No.","Comparative Quote Lines"."Piecework No.");
                                      DataPieceworkForProduction.SETRANGE("Budget Filter",Job."Current Piecework Budget");
                                      DataPieceworkForProduction.CALCFIELDS("Budget Measure");
                                      IF DataPieceworkForProduction."Budget Measure" <> 0 THEN
                                        DataCostByPiecework.VALIDATE("Performance By Piecework","Comparative Quote Lines".Quantity/DataPieceworkForProduction."Budget Measure")
                                      ELSE
                                      DataCostByPiecework.VALIDATE("Performance By Piecework","Comparative Quote Lines".Quantity);
                                      //JMMA cambio por nuevo campo estado estudio/obra
                                      //  IF RecLocOferta.Status=RecLocOferta.Status::Planning THEN
                                      IF RecLocOferta."Card Type"=RecLocOferta."Card Type"::Estudio THEN
                                         //DataCostByPiecework.VALIDATE("Direct Unitary Cost LCY","Comparative Quote Lines"."Lowest Price")
                                        DataCostByPiecework.VALIDATE("Direc Unit Cost","Comparative Quote Lines"."Lowest Price")
                                      ELSE
                                        //jmma si est  adjudicado me llevo el precio adjudicado DataCostByPiecework.VALIDATE("Direct Unitary Cost",0);
                                        //DataCostByPiecework.VALIDATE("Direct Unitary Cost LCY","Comparative Quote Lines"."Vendor Amount");
                                        DataCostByPiecework.VALIDATE("Direc Unit Cost","Comparative Quote Lines"."Purchase Price");
                                      Counter := Counter + 1;
                                      DataCostByPiecework."Cod. Budget" := Job."Current Piecework Budget";
                                      IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                                        DataCostByPiecework."Analytical Concept Direct Cost" := "Comparative Quote Lines"."Shortcut Dimension 1 Code";
                                      IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                                        DataCostByPiecework."Analytical Concept Direct Cost" := "Comparative Quote Lines"."Shortcut Dimension 2 Code";
                                      DataCostByPiecework.INSERT;
                                    END;
                                  END ELSE BEGIN 
                                   REPEAT //JMMA CAMBIO PARA QUE FUNCIONE CON PRODUCTO SIN UNIDAD DE OBRA Y ACTULICE TODAS LAS REPETICIONES DEL DESCOMPUESTO
                                    //JMMA CAMBIO POR NUEVO CAMPO ESTADO ESTUDIO/OBRA  IF RecLocOferta.Status=RecLocOferta.Status::Planning THEN BEGIN 
                                    IF RecLocOferta."Card Type"=RecLocOferta."Card Type"::Estudio THEN BEGIN 
                                      //JAV 10/08/19: - Se cambia el campo pues puede ir en divisas
                                      DataCostByPiecework.VALIDATE("Direc Unit Cost","Comparative Quote Lines"."Lowest Price");
                                      IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                                        DataCostByPiecework."Analytical Concept Direct Cost" := "Comparative Quote Lines"."Shortcut Dimension 1 Code";
                                      IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                                        DataCostByPiecework."Analytical Concept Direct Cost" := "Comparative Quote Lines"."Shortcut Dimension 2 Code";
                                    END ELSE BEGIN 
                                      //JAV 10/08/19: - Se cambia el campo pues puede ir en divisas
                                      //DataCostByPiecework.VALIDATE("Direct Unitary Cost LCY","Comparative Quote Lines"."Vendor Amount");
                                      DataCostByPiecework.VALIDATE("Direc Unit Cost","Comparative Quote Lines"."Purchase Price");
                                    END;
                                    Counter:=Counter+1;
                                    DataCostByPiecework.MODIFY;
                                   UNTIL DataCostByPiecework.NEXT=0;
                                  END;
                                  "Updated Budget" := TRUE;
                                  MODIFY;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                Window.CLOSE;
                                IF SeeMessages THEN
                                  MESSAGE(Text005,Counter);
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
//       Job@7001104 :
      Job: Record 167;
//       DataCostByPiecework@7001105 :
      DataCostByPiecework: Record 7207387;
//       ComparativeQuoteHeader@7001106 :
      ComparativeQuoteHeader: Record 7207412;
//       DataPieceworkForProduction@7001107 :
      DataPieceworkForProduction: Record 7207386;
//       FunctionQB@7001108 :
      FunctionQB: Codeunit 7207272;
//       Counter@7001103 :
      Counter: Integer;
//       LineNo@7001101 :
      LineNo: Integer;
//       Cost@7001102 :
      Cost: Decimal;
//       Window@7001100 :
      Window: Dialog;
//       Text001@7001113 :
      Text001: TextConst ENU='Generating decomposed',ESP='Generando descompuesto';
//       Text002@7001112 :
      Text002: TextConst ENU='Job       #1##########\',ESP='Proyecto        #1##########\';
//       Text003@7001111 :
      Text003: TextConst ENU='Job Unit  #2##########\',ESP='Unidad de obra  #2##########\';
//       Text004@7001110 :
      Text004: TextConst ENU='No.              #3######\',ESP='N§              #3######\';
//       Text005@7001109 :
      Text005: TextConst ENU='%1 breakdown lines upgraded',ESP='Se han actualizado %1 l¡neas de desglose';
//       SeeMessages@1100286000 :
      SeeMessages: Boolean;

    

trigger OnInitReport();    begin
                   SetMessages := TRUE;
                 end;



// procedure SetMessages (pMessages@1100286000 :
procedure SetMessages (pMessages: Boolean)
    begin
      SeeMessages := pMessages;
    end;

    /*begin
    end.
  */
  
}



