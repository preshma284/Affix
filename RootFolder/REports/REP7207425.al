report 7207425 "Obralia Cartera Doc Queue"
{
  
  
    CaptionML=ENU='JobQueue Obralia',ESP='JobQueue Obralia';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Cartera Doc.";"Cartera Doc.")
{

               DataItemTableView=SORTING("Type","Entry No.")
                                 WHERE("Type"=FILTER("Payable"));
               

               RequestFilterFields="Due Date","Job No.","Account No.";
trigger OnPreDataItem();
    BEGIN 
                               IF GUIALLOWED THEN
                                 v.OPEN(text000 + '\' + text001);
                             END;

trigger OnAfterGetRecord();
    VAR
//                                   Obralia@1100286000 :
                                  Obralia: Codeunit 7206901;
//                                   Response@1100286001 :
                                  Response: Text;
//                                   rVendor@1100286002 :
                                  rVendor: Record 23;
//                                   PurchInvHeader@100000000 :
                                  PurchInvHeader: Record 122;
//                                   PROCESS@100000001 :
                                  PROCESS: Text;
//                                   vError@100000002 :
                                  vError: Text;
                                BEGIN 
                                  IF GUIALLOWED THEN BEGIN 
                                    v.UPDATE(1,"Cartera Doc."."Job No.");
                                    v.UPDATE(2,"Cartera Doc."."Document No.");
                                  END;

                                  IF (Job.GET("Job No.")) THEN BEGIN 
                                    IF (Job."Obralia Code" <> '') THEN BEGIN 
                                      //rVendor.GET("Cartera Doc."."Account No.");
                                      //IF rVendor.Obralia THEN BEGIN 
                                        CLEAR(Obralia);
                                        "Cartera Doc.".VALIDATE("Obralia Entry",Obralia.SemaforoRequest_CarteraDoc("Cartera Doc.", FALSE));
                                      //END;
                                    END;
                                  END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                IF GUIALLOWED THEN
                                  v.CLOSE;
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
//       Job@1100286000 :
      Job: Record 167;
//       v@100000001 :
      v: Dialog;
//       text000@1100286001 :
      text000: TextConst ESP='Proyecto     #1##############';
//       text001@100000002 :
      text001: TextConst ESP='Documento #2##############';

    /*begin
    {
      QUONEXT PER 28.05.19 Proceso para comprobar el estado de los documentos en cartera en Obralia.
    }
    end.
  */
  
}



