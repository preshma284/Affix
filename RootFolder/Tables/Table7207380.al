table 7207380 "Cash MGT Rule Detail"
{
  
  
    CaptionML=ENU='Cash MGT Rule Detail',ESP='Detalle de regal de tesorer¡a';
    LookupPageID="Detail Job Payment";
    DrillDownPageID="Detail Job Payment";
  
  fields
{
    field(1;"Rule Code";Code[10])
    {
        TableRelation="Rules Job Treasury"."Analytic Concept" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Rule Code',ESP='Concepto anal¡tico';


    }
    field(2;"Fact No.";Integer)
    {
        

                                                   CaptionML=ENU='Fact No.',ESP='No. pago';

trigger OnValidate();
    BEGIN 
                                                                ERROR(Text74001);
                                                              END;


    }
    field(3;"Concept Code";Code[20])
    {
        TableRelation="Cash Flow Account";
                                                   CaptionML=ENU='Concept Code',ESP='Concepto tesorer¡a';


    }
    field(4;"Amount Type";Option)
    {
        OptionMembers="Collection","Payment";CaptionML=ESP='Tipo importe';
                                                   OptionCaptionML=ENU='Collection,Payment',ESP='Cobro,Pago';
                                                   


    }
    field(5;"% Amopunt";Decimal)
    {
        CaptionML=ENU='% Amopunt',ESP='% Importe';


    }
    field(6;"Due Method";Option)
    {
        OptionMembers="Fixed Date","Installments";CaptionML=ENU='Due Method',ESP='M‚todo de devengo';
                                                   OptionCaptionML=ENU='Fixed Date,Installments',ESP='Fecha fija,Plazos';
                                                   


    }
    field(7;"Fixed Day";Integer)
    {
        InitValue=0;
                                                   CaptionML=ENU='Fixed Day',ESP='D¡a de paso';
                                                   MinValue=0;
                                                   MaxValue=31;


    }
    field(8;"Period";DateFormula)
    {
        CaptionML=ENU='Period',ESP='Plazo';


    }
    field(9;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='No. proyecto';


    }
    field(10;"VAT Prod. Posting Group";Code[20])
    {
        TableRelation="VAT Product Posting Group";
                                                   CaptionML=ENU='VAT Prod. Posting Group',ESP='Grupo registro IVA prod.';
                                                   Description='QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


    }
    field(11;"Value Date Formula";DateFormula)
    {
        CaptionML=ENU='Value Date Formula',ESP='Formula fecha valor';


    }
    field(110;"VAT Bus. Posting Group";Code[20])
    {
        TableRelation="VAT Business Posting Group";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Bus. Posting Group',ESP='Grupo registro IVA neg.'; ;


    }
}
  keys
{
    key(key1;"Job No.","Rule Code","Fact No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       DaysFixedPaymentJob@7001100 :
      DaysFixedPaymentJob: Record 7207381;
//       Text74001@7001101 :
      Text74001: TextConst ENU='It cannot introduce in hand way',ESP='No puede introducirse de forma manual.';

    

trigger OnInsert();    begin
               if "Fact No." = 10000 then
                 "Fact No." := 1
               else
                 "Fact No." := "Fact No." - 9999;
             end;

trigger OnDelete();    begin
               if "Due Method" = "Due Method"::"Fixed Date" then begin
                 DaysFixedPaymentJob.RESET;
                 DaysFixedPaymentJob.SETRANGE("Job No.","Job No.");
                 DaysFixedPaymentJob.SETRANGE("Rule Code","Rule Code");
                 DaysFixedPaymentJob.SETRANGE("Fact No.","Fact No.");
                 if DaysFixedPaymentJob.FINDFIRST then
                   DaysFixedPaymentJob.DELETEALL;
               end;
             end;



/*begin
    end.
  */
}







