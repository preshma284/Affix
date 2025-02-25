report 7207330 "Batch Post Delivery/Return Ele"
{
  
  
    CaptionML=ENU='Batch Post Delivery/Return Ele',ESP='Reg. por lotes documentos';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Header Delivery/Return Element";"Header Delivery/Return Element")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               RequestFilterHeadingML=ENU='Delivery',ESP='Entrega';
               

               RequestFilterFields="No.";
trigger OnPreDataItem();
    BEGIN 
                               IF ReplacePostingDate AND (PostingDateReq = 0D) THEN
                                 ERROR(Text000);
                               CounterTotal := COUNT;
                               Window.OPEN(Text001);
                             END;

trigger OnAfterGetRecord();
    BEGIN 

                                  Counter := Counter + 1;
                                  Window.UPDATE(1,"No.");
                                  Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                                  CLEAR(RecordDeliveryReturnElement);
                                  RecordDeliveryReturnElement.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                                  IF RecordDeliveryReturnElement.RUN("Header Delivery/Return Element") THEN BEGIN 
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
//       ReplacePostingDate@7001100 :
      ReplacePostingDate: Boolean;
//       PostingDateReq@7001101 :
      PostingDateReq: Date;
//       Text000@7001103 :
      Text000: TextConst ENU='Please enter the posting date.',ESP='Introduzca la fecha registro.';
//       Text001@7001102 :
      Text001: TextConst ENU='Posting invoices   #1########## @2@@@@@@@@@@@@@',ESP='Reg. Entrega    #1########## @2@@@@@@@@@@@@@';
//       CounterTotal@7001104 :
      CounterTotal: Integer;
//       Window@7001105 :
      Window: Dialog;
//       Counter@7001106 :
      Counter: Integer;
//       RecordDeliveryReturnElement@7001107 :
      RecordDeliveryReturnElement: Codeunit 7207312;
//       ReplaceDocumentDate@7001108 :
      ReplaceDocumentDate: Boolean;
//       CounterOK@7001109 :
      CounterOK: Integer;
//       Text002@7001110 :
      Text002: TextConst ENU='%1 invoices out of a total of %2 have now been posted.',ESP='Se han registrado %1 Entregas de un total de %2.';

    /*begin
    end.
  */
  
}



