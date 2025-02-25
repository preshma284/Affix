report 7207280 "Output Shipment Batrch Records"
{
  
  
    CaptionML=ENU='Output Shipment Batrch Records',ESP='Reg. por lotes documentos';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Output Shipment Header";"Output Shipment Header")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               RequestFilterHeadingML=ENU='Document',ESP='Documento';
               

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
                                  CLEAR(PostPurchaseRcptOutput);
                                  PostPurchaseRcptOutput.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
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
//       Text000@7001102 :
      Text000: TextConst ENU='Please enter the posting date.',ESP='Introduzca la fecha registro.';
//       Text001@7001101 :
      Text001: TextConst ENU='Posting invoices   #1########## @2@@@@@@@@@@@@@',ESP='Reg. facturas      #1########## @2@@@@@@@@@@@@@';
//       Text002@7001100 :
      Text002: TextConst ENU='%1 invoices out of a total of %2 have now been posted.',ESP='Se han registrado %1 facturas de un total de %2.';
//       ReplacePostingDate@7001103 :
      ReplacePostingDate: Boolean;
//       PostingDateReq@7001104 :
      PostingDateReq: Date;
//       CounterTotal@7001105 :
      CounterTotal: Integer;
//       Window@7001106 :
      Window: Dialog;
//       Counter@7001107 :
      Counter: Integer;
//       PostPurchaseRcptOutput@7001108 :
      PostPurchaseRcptOutput: Codeunit 7207276;
//       ReplaceDocumentDate@7001109 :
      ReplaceDocumentDate: Boolean;
//       CounterOK@7001110 :
      CounterOK: Integer;

    /*begin
    end.
  */
  
}



