report 50099 "Regenerar Tabla 45"
{
  
  
    ProcessingOnly=true;
    UseRequestPage=false;
  
  dataset
{

DataItem("G/L Register";"G/L Register")
{

               ;
DataItem("R17";"G/L Entry")
{

               ;
DataItem("Rvat";"VAT Entry")
{

               ;
DataItem("R45";"G/L Register")
{

               
                                 ;
trigger OnPreDataItem();
    BEGIN 
                               CurrReport.SKIP;

                               i := 0;
                               R45.RESET;
                               u := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  CurrReport.BREAK;

                                  i+=1;
                                  w.UPDATE(1, 'Ajuste ' + FORMAT(i) + ' / ' + FORMAT(Rvat.COUNT));

                                  IF (R45."From VAT Entry No." = 0) THEN BEGIN 
                                    R45."From VAT Entry No." := u+1;
                                    R45."To VAT Entry No." := u;
                                    R45.MODIFY;
                                  END ELSE BEGIN 
                                    u := R45."To VAT Entry No." ;
                                  END;
                                END;


}
trigger OnPreDataItem();
    BEGIN 
                               CurrReport.SKIP;

                               i := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  CurrReport.BREAK;

                                  i+=1;
                                  w.UPDATE(1, 'IVA' + FORMAT(i) + ' / ' + FORMAT(Rvat.COUNT));

                                  R45.GET(Rvat."Transaction No.");
                                  IF (R45."From VAT Entry No." = 0) THEN
                                    R45."From VAT Entry No." := Rvat."Entry No.";

                                  R45."To VAT Entry No." := Rvat."Entry No.";
                                  R45.MODIFY;
                                END;


}
trigger OnPreDataItem();
    BEGIN 
                               CurrReport.SKIP;
                               R17.SETCURRENTKEY("Transaction No.");
                               i := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  CurrReport.BREAK;
                                  i+=1;
                                  w.UPDATE(1, 'MCon ' + FORMAT(i) + ' / ' + FORMAT(R17.COUNT));

                                  IF (R17."Transaction No." = R45."No.") THEN BEGIN 
                                    R45."To Entry No." := R17."Entry No.";
                                    R45.MODIFY;
                                  END ELSE BEGIN 
                                    R45.INIT;
                                    R45."No." := R17."Transaction No.";
                                    R45."From Entry No." := R17."Entry No.";
                                    R45."To Entry No." := R17."Entry No.";

                                    R45."Creation Date" := DT2DATE(R17."Last Modified DateTime");
                                    R45."Source Code" := R17."Source Code";
                                    R45."User ID" := R17."User ID";
                                    R45."Journal Batch Name" := R17."Journal Batch Name";
                                    R45."From VAT Entry No." := 0;
                                    R45."To VAT Entry No." := 0;
                                    R45.Reversed := R17.Reversed;
                                    R45."Creation Time" := DT2TIME(R17."Last Modified DateTime");
                                    R45."Posting Date" := R17."Posting Date";
                                    R45.INSERT;
                                  END;
                                END;


}
trigger OnAfterGetRecord();
    BEGIN 
                                  i += 1;
                                  w.UPDATE(1, 'Registro ' + FORMAT(i) + ' / ' + FORMAT("G/L Register".COUNT));
                                  IF "G/L Register"."No." = 360 THEN BEGIN 
                                  "G/L Register"."No."   := "G/L Register"."No.";
                                  END;
                                  GLEntry.SETRANGE("Entry No.","G/L Register"."From Entry No.","G/L Register"."To Entry No.");
                                  IF GLEntry.FINDSET THEN
                                    REPEAT
                                      GLEntry."Transaction No." := "G/L Register"."No.";
                                      GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
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
//       w@1100286000 :
      w: Dialog;
//       i@1100286001 :
      i: Integer;
//       u@1100286002 :
      u: Integer;
//       GLEntry@1100286003 :
      GLEntry: Record 17;

    

trigger OnPreReport();    begin
                  w.OPEN('#1############################################');
                end;



/*begin
    end.
  */
  
}



