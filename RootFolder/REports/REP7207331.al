report 7207331 "Rec. by Activation Batch"
{
  
  
    CaptionML=ENU='Rec. by Documents Batch',ESP='Reg. por lotes documentos';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Activation Header";"Activation Header")
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
                                  CLEAR(RecordActivation);
                                  RecordActivation.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                                  IF RecordActivation.RUN("Activation Header") THEN BEGIN 
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
//       RecordActivation@7001108 :
      RecordActivation: Codeunit 7207307;
//       PostingDateReq@7001101 :
      PostingDateReq: Date;
//       Window@7001106 :
      Window: Dialog;
//       CounterTotal@7001105 :
      CounterTotal: Integer;
//       Counter@7001107 :
      Counter: Integer;
//       CounterOK@7001110 :
      CounterOK: Integer;
//       ReplacePostingDate@7001100 :
      ReplacePostingDate: Boolean;
//       Text000@7001104 :
      Text000: TextConst ENU='Please enter the posting date.',ESP='Introduzca la fecha registro.';
//       Text001@7001103 :
      Text001: TextConst ENU='Posting invoices   #1########## @2@@@@@@@@@@@@@',ESP='Reg. facturas      #1########## @2@@@@@@@@@@@@@';
//       Text002@7001102 :
      Text002: TextConst ENU='%1 invoices out of a total of %2 have now been posted.',ESP='Se han registrado %1 facturas de un total de %2.';
//       ReplaceDocumentDate@7001109 :
      ReplaceDocumentDate: Boolean;

    /*begin
    end.
  */
  
}



