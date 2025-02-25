report 7207276 "Post. by Measurement Batch"
{
  
  
    CaptionML=ENU='Post. by Measurement Batch',ESP='Reg. por lotes medici¢n';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Measurement Header";"Measurement Header")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               RequestFilterHeadingML=ENU='Document',ESP='Document';
               

               RequestFilterFields="No.";
trigger OnPreDataItem();
    BEGIN 
                               IF ReplacePostingDate AND (PostingDateReq = 0D) THEN
                                 ERROR(Text000);
                               CounterTotal := COUNT;
                               Window.OPEN(Text001)
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  Counter := Counter + 1;
                                  Window.UPDATE(1,"No.");
                                  Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                                  CLEAR(cduRegDoc);
                                  cduRegDoc.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                                  IF cduRegDoc.RUN("Measurement Header") THEN BEGIN 
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
//       recLinDoc@7001113 :
      recLinDoc: Record 7207337;
//       PurchSetup@7001112 :
      PurchSetup: Record 312;
//       cduRegDoc@7001111 :
      cduRegDoc: Codeunit 7207274;
//       Window@7001110 :
      Window: Dialog;
//       PostingDateReq@7001109 :
      PostingDateReq: Date;
//       CounterTotal@7001108 :
      CounterTotal: Integer;
//       Counter@7001107 :
      Counter: Integer;
//       CounterOK@7001106 :
      CounterOK: Integer;
//       ReplacePostingDate@7001105 :
      ReplacePostingDate: Boolean;
//       ReplaceDocumentDate@7001104 :
      ReplaceDocumentDate: Boolean;
//       CalcInvDisc@7001103 :
      CalcInvDisc: Boolean;

    /*begin
    end.
  */
  
}



