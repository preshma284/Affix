table 7206917 "QBU Job Currency Exchange"
{
  
  
    CaptionML=ENU='Job Currency Exchange',ESP='Cambios de divisas por proyectos';
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job"."No.";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';

trigger OnValidate();
    BEGIN 
                                                                Job.GET("Job No.");

                                                                IF "Future Currency" THEN
                                                                  VALIDATE(Date, 0D)
                                                                ELSE
                                                                  VALIDATE(Date, WORKDATE);

                                                                // Job.TESTFIELD("Currency Code");
                                                                // VALIDATE("Currency Code", Job."Currency Code");
                                                              END;


    }
    field(2;"Currency Code";Code[10])
    {
        TableRelation="Currency";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Currency Code',ESP='C¢d. divisa';
                                                   NotBlank=true;

trigger OnValidate();
    BEGIN 
                                                                Currency.GET("Currency Code");
                                                                Currency.TESTFIELD("Amount Rounding Precision");
                                                              END;


    }
    field(3;"Future Currency";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Future Currency',ESP='Divisa a futuro';

trigger OnValidate();
    BEGIN 
                                                                VALIDATE(Date, 0D)
                                                              END;


    }
    field(4;"Date";Date)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Date',ESP='Fecha';

trigger OnValidate();
    BEGIN 
                                                                IF Date = 0D THEN
                                                                  TESTFIELD("Future Currency", TRUE)
                                                                ELSE
                                                                  TESTFIELD("Future Currency", FALSE);
                                                              END;


    }
    field(5;"Cost Amount";Decimal)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cost Amount',ESP='Importe coste';
                                                   DecimalPlaces=0:15;

trigger OnValidate();
    BEGIN 
                                                                IF "Sales Amount" = 0 THEN
                                                                  VALIDATE("Sales Amount", "Cost Amount");
                                                              END;


    }
    field(6;"Sales Amount";Decimal)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Sales Amount',ESP='Importe ventas';
                                                   DecimalPlaces=0:15 ;

trigger OnValidate();
    BEGIN 
                                                                IF "Cost Amount" = 0 THEN
                                                                  VALIDATE("Cost Amount", "Sales Amount");
                                                              END;


    }
}
  keys
{
    key(key1;"Job No.","Currency Code","Future Currency","Date")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       GeneralLedgerSetup@1100286001 :
      GeneralLedgerSetup: Record 98;
//       Job@1100286003 :
      Job: Record 167;
//       Currency@1100286002 :
      Currency: Record 4;
//       ERRORLCY@1100286004 :
      ERRORLCY: TextConst ENU='%1 %2 can''t be the same as %3 setup in %4.',ESP='%1 %2 no puede ser igual al campo %3 configurado en %4.';

    

trigger OnInsert();    begin
               // if "Future Currency" then
               //  VALIDATE(Date, 0D)
               // else
               //  VALIDATE(Date, WORKDATE);

               GeneralLedgerSetup.GET;
               Job.GET("Job No.");
               Currency.GET("Currency Code");

               if Currency.Code = GeneralLedgerSetup."LCY Code" then
                 ERROR(ERRORLCY, FIELDCAPTION("Currency Code"), Currency.Code, GeneralLedgerSetup.FIELDCAPTION("LCY Code"), GeneralLedgerSetup.TABLECAPTION);
             end;

trigger OnModify();    begin

               GeneralLedgerSetup.GET;
               Job.GET("Job No.");
               Currency.GET("Currency Code");

               if Currency.Code = GeneralLedgerSetup."LCY Code" then
                 ERROR(ERRORLCY, FIELDCAPTION("Currency Code"), Currency.Code, GeneralLedgerSetup.FIELDCAPTION("LCY Code"), GeneralLedgerSetup.TABLECAPTION);
             end;



/*begin
    end.
  */
}







