report 7207296 "Post By Reestimation Batch"
{
  
  
    CaptionML=ENU='Post By Reestimation Batch',ESP='Reg. por lotes documentos';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Reestimation Header";"Reestimation Header")
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
                                  CLEAR(Postreestimation);
                                  Postreestimation.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                                  IF Postreestimation.RUN("Reestimation Header") THEN BEGIN 
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
//       ReestimationLines@7001100 :
      ReestimationLines: Record 7207316;
//       PurchasesPayablesSetup@7001101 :
      PurchasesPayablesSetup: Record 312;
//       Postreestimation@7001102 :
      Postreestimation: Codeunit 7207290;
//       Window@7001103 :
      Window: Dialog;
//       PostingDateReq@7001104 :
      PostingDateReq: Date;
//       CounterTotal@7001105 :
      CounterTotal: Integer;
//       Counter@7001106 :
      Counter: Integer;
//       CounterOK@7001107 :
      CounterOK: Integer;
//       ReplacePostingDate@7001108 :
      ReplacePostingDate: Boolean;
//       ReplaceDocumentDate@7001109 :
      ReplaceDocumentDate: Boolean;
//       CalcInvDisc@7001110 :
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



