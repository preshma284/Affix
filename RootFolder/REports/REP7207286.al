report 7207286 "Output Shipment Reg. Batch"
{
  
  
    CaptionML=ENU='Output Shipment Reg. Batch',ESP='Albaran de salida reg. lotes';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Output Shipment Header";"Output Shipment Header")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
trigger OnPreDataItem();
    BEGIN 
                               CounterTotal := COUNT;
                               Window.OPEN(Text001);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  Counter := Counter + 1;
                                  Window.UPDATE(1,"No.");
                                  Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                                  CLEAR(PostPurchaseRcptOutput);
                                  IF PostPurchaseRcptOutput.RUN("Output Shipment Header") THEN BEGIN 
                                    CounterOK := CounterOK + 1;
                                    IF MARKEDONLY THEN
                                      MARK(FALSE);
                                  END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                Window.CLOSE;
                                MESSAGE(Text002,CounterOK,CounterTotal);
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
//       CounterTotal@7001100 :
      CounterTotal: Integer;
//       Window@7001101 :
      Window: Dialog;
//       Text001@7001102 :
      Text001: TextConst ENU='Reg. shipment      #1########## @2@@@@@@@@@@@@@',ESP='Reg. albaranes      #1########## @2@@@@@@@@@@@@@';
//       Counter@7001103 :
      Counter: Integer;
//       PostPurchaseRcptOutput@7001104 :
      PostPurchaseRcptOutput: Codeunit 7207276;
//       CounterOK@7001105 :
      CounterOK: Integer;
//       Text002@7001106 :
      Text002: TextConst ENU='%1 delivery notes have been registered for a total of %2.',ESP='Se han registrado %1 albaranes de un total de %2.';

    /*begin
    end.
  */
  
}



