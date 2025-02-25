report 7207334 "Batch records of usage"
{
  
  
    CaptionML=ENU='Batch records documents',ESP='Reg. por lotes documentos';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Usage Header";"Usage Header")
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
                                  CLEAR(CURegisterUsage);
                                  CURegisterUsage.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                                  IF CURegisterUsage.RUN("Usage Header") THEN BEGIN 
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
//       UsageLine@7001110 :
      UsageLine: Record 7207363;
//       RentalElementsSetup@7001109 :
      RentalElementsSetup: Record 7207346;
//       CURegisterUsage@7001108 :
      CURegisterUsage: Codeunit 7207310;
//       Window@7001107 :
      Window: Dialog;
//       PostingDateReq@7001106 :
      PostingDateReq: Date;
//       CounterTotal@7001105 :
      CounterTotal: Integer;
//       Counter@7001104 :
      Counter: Integer;
//       CounterOK@7001103 :
      CounterOK: Integer;
//       ReplacePostingDate@7001102 :
      ReplacePostingDate: Boolean;
//       ReplaceDocumentDate@7001101 :
      ReplaceDocumentDate: Boolean;
//       CalcInvDisc@7001100 :
      CalcInvDisc: Boolean;
//       Text000@7001113 :
      Text000: TextConst ENU='Please enter the posting date.',ESP='Introduzca la fecha registro.';
//       Text001@7001112 :
      Text001: TextConst ENU='Posting invoices   #1########## @2@@@@@@@@@@@@@',ESP='Reg. facturas      #1########## @2@@@@@@@@@@@@@';
//       Text002@7001111 :
      Text002: TextConst ENU='%1 invoices out of a total of %2 have now been posted.',ESP='Se han registrado %1 facturas de un total de %2.';

    /*begin
    end.
  */
  
}



