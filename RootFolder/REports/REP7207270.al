report 7207270 "Record by Document Lots"
{
  
  
    CaptionML=ENU='Record by Document Lots',ESP='Reg. por lotes documentos';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Worksheet Header qb";"Worksheet Header qb")
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
                                  Window.UPDATE(2,"No.");
                                  Window.UPDATE(1,ROUND(Counter / CounterTotal * 10000,1));
                                  CLEAR(PostWorksheet);
                                  PostWorksheet.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                                  IF PostWorksheet.RUN("Worksheet Header qb") THEN BEGIN 
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
//       PostWorksheet@7001108 :
      PostWorksheet: Codeunit 7207270;
//       Window@7001104 :
      Window: Dialog;
//       PostingDateReq@7001101 :
      PostingDateReq: Date;
//       CounterTotal@7001103 :
      CounterTotal: Integer;
//       Counter@7001107 :
      Counter: Integer;
//       CounterOK@7001106 :
      CounterOK: Integer;
//       ReplacePostingDate@7001100 :
      ReplacePostingDate: Boolean;
//       Text000@7001102 :
      Text000: TextConst ENU='Please enter the posting date.',ESP='Introduzca la fecha de registro.';
//       Text001@7001105 :
      Text001: TextConst ENU='Posting invoices   #1########## @2@@@@@@@@@@@@@',ESP='"Registrando:  @2@@@@@@@@@@@@@/Parte: #1########## "';
//       ReplaceDocumentDate@7001109 :
      ReplaceDocumentDate: Boolean;
//       Text002@7001110 :
      Text002: TextConst ENU='%1 invoices out of a total of %2 have now been posted.',ESP='Se han registrado %1 partes de un total de %2.';

    /*begin
    end.
  */
  
}



