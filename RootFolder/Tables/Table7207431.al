table 7207431 "Units Posting Group"
{
  
  
    CaptionML=ENU='Units Posting Group',ESP='Grupo contable unidades';
    LookupPageID="Units Posting Group List";
    DrillDownPageID="Units Posting Group List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Cost Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Cost Account',ESP='Cuenta coste';


    }
    field(4;"Cost Analytic Concept";Code[20])
    {
        

                                                   CaptionML=ENU='Cost Analytic Concept',ESP='Cost analytic concept';

trigger OnValidate();
    BEGIN 
                                                                FunctionQB.ValidateCA("Cost Analytic Concept");
                                                              END;

trigger OnLookup();
    BEGIN 
                                                              FunctionQB.LookUpCA("Cost Analytic Concept",FALSE);
                                                            END;


    }
    field(5;"Entry Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Entry Account',ESP='Cuenta ingreso';


    }
    field(6;"Entry Analytic Concept";Code[20])
    {
        

                                                   CaptionML=ENU='Entry Analytic Concept',ESP='Concepto anal¡tico ingreso';

trigger OnValidate();
    BEGIN 
                                                                FunctionQB.ValidateCA("Entry Analytic Concept")
                                                              END;

trigger OnLookup();
    BEGIN 
                                                              FunctionQB.LookUpCA("Entry Analytic Concept",FALSE);
                                                            END;


    }
    field(7;"Account Per. Applicaction Acc.";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Account Per. Applicaction Acc.',ESP='Cta. contrapartida periodificable'; ;


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
  
    var
//       FunctionQB@60000 :
      FunctionQB: Codeunit 7207272;
//       CodeCA@60001 :
      CodeCA: Code[20];
//       CodeCaing@60002 :
      CodeCaing: Code[20];

    /*begin
    end.
  */
}







