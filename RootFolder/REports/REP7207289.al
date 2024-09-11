report 7207289 "Allocate Pending Purch. Rcpt."
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Allocate Pending Purch. Rcpt.',ESP='Imputar albaranes pendientes';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Purch. Rcpt. Header";"Purch. Rcpt. Header")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
trigger OnPreDataItem();
    BEGIN 
                               Window.OPEN(Text006);

                               n1 := 0;
                               n2 := "Purch. Rcpt. Header".COUNT;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  n1 += 1;
                                  Window.UPDATE(1,ROUND(n1*10000/n2, 1));
                                  PurchaseRcptPendingInvoice.ActivatePurchaseRcpt("Purch. Rcpt. Header", PostingDate);
                                END;

trigger OnPostDataItem();
    BEGIN 
                                MESSAGE(Text004);
                              END;


}
}
  requestpage
  {

    layout
{
area(content)
{
    field("Posting Date";"PostingDate")
    {
        
                  CaptionML=ENU='Posting Date',ESP='Fecha de Registro';
    }

}
}
  }
  labels
{
}
  
    var
//       Text000@7001105 :
      Text000: TextConst ENU='Must be entered a Posting Date',ESP='Debe indicar la fecha de registro';
//       PostingDate@7001136 :
      PostingDate: Date;
//       Text006@7001137 :
      Text006: TextConst ENU='Processing Purch. Rcpt. Lines \\',ESP='Procesando @1@@@@@@@@@@@@@@@@@@@@';
//       n1@1100286000 :
      n1: Integer;
//       n2@1100286001 :
      n2: Integer;
//       Text004@1100286002 :
      Text004: TextConst ESP='Finalizado';
//       Window@1100286027 :
      Window: Dialog;
//       PurchaseRcptPendingInvoice@1100286008 :
      PurchaseRcptPendingInvoice: Codeunit 7207295;

    

trigger OnPreReport();    begin
                  if PostingDate = 0D then
                    ERROR(Text000);
                end;



/*begin
    end.
  */
  
}




