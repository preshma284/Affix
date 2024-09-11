table 7207443 "Guarantee Type"
{
  
  
    LookupPageID="Guarantees Types";
    DrillDownPageID="Guarantees Types";
  
  fields
{
    field(1;"Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo';


    }
    field(10;"Description";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n';


    }
    field(11;"Type";Option)
    {
        OptionMembers="Cash","GuaranteeWith","GuaranteeWithout","Insurance";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ENU='Cash, Bank guarantee with retention, Bank guarantee without retention, Credit insurance',ESP='"Efectivo,Aval Bancario con retenci¢n,Aval Bancario sin retenci¢n,Seguro de cr‚dito "';
                                                   


    }
    field(12;"Bank Account No.";Code[20])
    {
        TableRelation="Bank Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Bank Account No.',ESP='Banco';


    }
    field(20;"Destination Type";Option)
    {
        OptionMembers=" ","G/L Account","Bank Account";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo Destino';
                                                   OptionCaptionML=ESP='" ,Cuenta,Banco"';
                                                   


    }
    field(21;"Destination No.";Code[20])
    {
        TableRelation=IF ("Destination Type"=CONST("G/L Account")) "G/L Account"                                                                 ELSE IF ("Destination Type"=CONST("Bank Account")) "Bank Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Destino';


    }
    field(22;"Retention %";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Retenci¢n';
                                                   MinValue=0;
                                                   MaxValue=100;


    }
    field(30;"Account for Initial Expenses";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cta. Gastos constituci¢n';


    }
    field(31;"Account for Expenses";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cta. Gastos';


    }
    field(32;"Account for Forecast Expenses";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cta. Previsi¢n Gastos';


    }
    field(33;"Account for Final Expenses";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cta. Gastos cancelaci¢n';


    }
    field(40;"Account for Seizure";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cta. Incautaci¢n';


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    end.
  */
}







