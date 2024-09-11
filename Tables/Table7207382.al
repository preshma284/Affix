table 7207382 "QBU Planning Job Special"
{
  
  
    CaptionML=ENU='Planning Job Special',ESP='Planificaci¢n especial proyecto';
    LookupPageID="Special Planning";
    DrillDownPageID="Special Planning";
  
  fields
{
    field(1;"Rule Code";Code[20])
    {
        TableRelation="Rules Job Treasury"."Analytic Concept" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Rule Code',ESP='Concepto anal¡tico';
                                                   Description='QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


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
        OptionMembers="Collection","Payment";CaptionML=ENU='Amount Type',ESP='Tipo de importe';
                                                   OptionCaptionML=ENU='Collection,Payment',ESP='Cobro,Pago';
                                                   


    }
    field(5;"% Amount";Decimal)
    {
        CaptionML=ENU='% Amount',ESP='% Importe';


    }
    field(6;"Date";Date)
    {
        CaptionML=ENU='Fixed Day',ESP='Fecha';


    }
    field(7;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='No. proyecto'; ;


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
//       Text74001@7001100 :
      Text74001: TextConst ENU='It cannot introduce in hand way',ESP='No puede introducirse de forma manual.';

    

trigger OnInsert();    begin
               if "Fact No." = 10000 then
                 "Fact No." := 1
               else
                 "Fact No." := "Fact No." - 9999;
             end;



procedure CalculateAmount () : Decimal;
    var
//       LRulesJobTreasury@1100251000 :
      LRulesJobTreasury: Record 7207379;
    begin
      LRulesJobTreasury.GET("Job No.","Rule Code");
      exit((LRulesJobTreasury.CaculateBudgetJob * "% Amount")/100);
    end;

    /*begin
    end.
  */
}







