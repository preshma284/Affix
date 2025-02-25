report 7207350 "Generate Broken Down Purch. L"
{
  
  
    CaptionML=ENU='Generate Broken Down Purch. L',ESP='Generar descompuesto l¡n. comp';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Purchase Line";"Purchase Line")
{

               DataItemTableView=SORTING("Document Type","Document No.","Line No.")
                                 WHERE("Document Type"=CONST("Order"),"Type"=FILTER("Item"|"Resource"));
               

               RequestFilterFields="Document No.";
trigger OnPreDataItem();
    BEGIN 
                               Window.OPEN(Text001 +
                                            Text002 +
                                            Text003 +
                                            Text004 );
                               Counter := 0;

                               DataCostByPiecework.RESET;
                             END;

trigger OnAfterGetRecord();
    VAR
//                                   RecLocOferta@1100251000 :
                                  RecLocOferta: Record 167;
                                BEGIN 
                                  Window.UPDATE(1,"Purchase Line"."Job No.");
                                  Window.UPDATE(2,"Purchase Line"."Piecework No.");
                                  Window.UPDATE(3,"Purchase Line"."No.");
                                  TESTFIELD("Piecework No.");
                                  Job.GET("Purchase Line"."Job No.");
                                  CASE Type OF
                                    "Purchase Line".Type::Item:BEGIN 
                                      //-Q18970.1 Sustituimos el GET
                                      DataCostByPiecework.SETRANGE("Job No.","Job No.");
                                      DataCostByPiecework.SETRANGE("Piecework Code","Piecework No.");
                                      DataCostByPiecework.SETRANGE("Cod. Budget",'');
                                      DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Item);
                                      DataCostByPiecework.SETRANGE("No.","No.");
                                      ExistRecord := DataCostByPiecework.FINDFIRST;
                                      //ExistRecord := DataCostByPiecework.GET("Job No.","Piecework No.",'',DataCostByPiecework."Cost Type"::Item,"No.")
                                      //+Q18970.1
                                    END;
                                    "Purchase Line".Type::Resource:BEGIN 
                                      //-Q18970.1 Sustituimos el GET
                                      DataCostByPiecework.SETRANGE("Job No.","Job No.");
                                      DataCostByPiecework.SETRANGE("Piecework Code","Piecework No.");
                                      DataCostByPiecework.SETRANGE("Cod. Budget",'');
                                      DataCostByPiecework.SETRANGE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
                                      DataCostByPiecework.SETRANGE("No.","No.");
                                      ExistRecord := DataCostByPiecework.FINDFIRST;
                                      //ExistRecord := DataCostByPiecework.GET("Job No.","Piecework No.",'',DataCostByPiecework."Cost Type"::Resource,"No.")
                                      //+Q18970.1
                                    END;
                                  END;
                                  DataCostByPiecework.SETRANGE(DataCostByPiecework."Job No.",Job."No.");
                                  DataCostByPiecework.SETRANGE(DataCostByPiecework."Piecework Code","Purchase Line"."Piecework No.");
                                  DataCostByPiecework.SETRANGE(DataCostByPiecework."Cod. Budget",Job."Current Piecework Budget");
                                  IF Type = Type::Item THEN
                                    DataCostByPiecework.SETRANGE(DataCostByPiecework."Cost Type",DataCostByPiecework."Cost Type"::Item);
                                  IF Type = Type::Resource THEN
                                    DataCostByPiecework.SETRANGE(DataCostByPiecework."Cost Type",DataCostByPiecework."Cost Type"::Resource);
                                  DataCostByPiecework.SETRANGE(DataCostByPiecework."No.","Purchase Line"."No.");

                                  IF NOT DataCostByPiecework.FINDFIRST THEN BEGIN 
                                    PurchaseHeader.GET("Purchase Line"."Document Type","Purchase Line"."Document No.");
                                    DataCostByPiecework.INIT;
                                    DataCostByPiecework.VALIDATE("Job No.","Purchase Line"."Job No.");
                                    DataCostByPiecework.VALIDATE("Piecework Code","Purchase Line"."Piecework No.");
                                    IF Type = Type::Item THEN
                                      DataCostByPiecework.VALIDATE("Cost Type",DataCostByPiecework."Cost Type"::Item);
                                    IF Type = Type::Resource THEN
                                      DataCostByPiecework.VALIDATE("Cost Type",DataCostByPiecework."Cost Type"::Resource);
                                    DataCostByPiecework.VALIDATE("No.","No.");
                                    DataPieceworkForProduction.GET(DataCostByPiecework."Job No.","Purchase Line"."Piecework No.");
                                    CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) OF
                                      1 : DataCostByPiecework.VALIDATE("Analytical Concept Direct Cost", "Purchase Line"."Shortcut Dimension 1 Code");
                                      2 : DataCostByPiecework.VALIDATE("Analytical Concept Direct Cost", "Purchase Line"."Shortcut Dimension 2 Code");
                                    END;

                                    DataCostByPiecework.VALIDATE("Performance By Piecework", "Purchase Line".Quantity);
                                    DataCostByPiecework.VALIDATE("Direct Unitary Cost (JC)", "Purchase Line"."Unit Cost (LCY)");

                                    DataCostByPiecework."Cod. Budget" := Job."Current Piecework Budget";
                                    DataCostByPiecework.INSERT;
                                    Counter := Counter + 1;

                                    IF (CrePiecework <> '') THEN
                                      CrePiecework += '|' ;
                                    CrePiecework += DataCostByPiecework."Piecework Code";
                                    IF (CreNo <> '') THEN
                                      CreNo += '|' ;
                                    CreNo += DataCostByPiecework."No.";
                                  END;

                                  "Updated budget" := TRUE;
                                  MODIFY;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                Window.CLOSE;
                                IF (Counter = 0) THEN
                                  MESSAGE(Text006)
                                ELSE BEGIN 
                                  MESSAGE(Text005,Counter);
                                  COMMIT;
                                  DataCostByPiecework.RESET;
                                  DataCostByPiecework.SETRANGE("Job No.", "Purchase Line"."Job No.");
                                  DataCostByPiecework.SETFILTER("Piecework Code", CrePiecework);
                                  DataCostByPiecework.SETFILTER("No.", CreNo);
                                  CLEAR(PiecewxJobBillofItemList);
                                  PiecewxJobBillofItemList.SETTABLEVIEW(DataCostByPiecework);
                                  PiecewxJobBillofItemList.RUNMODAL;
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
//       Job@7001104 :
      Job: Record 167;
//       DataCostByPiecework@7001105 :
      DataCostByPiecework: Record 7207387;
//       ComparativeQuoteHeader@7001106 :
      ComparativeQuoteHeader: Record 7207412;
//       DataPieceworkForProduction@7001107 :
      DataPieceworkForProduction: Record 7207386;
//       PurchaseHeader@7001115 :
      PurchaseHeader: Record 38;
//       FunctionQB@7001108 :
      FunctionQB: Codeunit 7207272;
//       Counter@7001103 :
      Counter: Integer;
//       LineNo@7001101 :
      LineNo: Integer;
//       Cost@7001102 :
      Cost: Decimal;
//       ExistRecord@7001114 :
      ExistRecord: Boolean;
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
      Text005: TextConst ENU='%1 breakdown lines upgraded',ESP='Se han actualizado %1 l¡neas de descompuesto, revise cantidades y precios de las mismas';
//       Text006@100000000 :
      Text006: TextConst ESP='No se ha creado nuevos descompuestos';
//       PiecewxJobBillofItemList@100000001 :
      PiecewxJobBillofItemList: Page 7207526;
//       CrePiecework@100000002 :
      CrePiecework: Text;
//       CreNo@100000003 :
      CreNo: Text;

    /*begin
    {
      AML 12/06/23 Q18970.1 Adaptaciones por la nueva clave de Data Cost by Piecework
    }
    end.
  */
  
}



