table 7207325 "Expense Concept"
{
  
  
    CaptionML=ENU='Expense Concept',ESP='Concepto de gasto';
    LookupPageID="Expense Concept List";
    DrillDownPageID="Expense Concept List";
  
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
    field(3;"Expense Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Expense Account',ESP='Cuenta de Gastos';
                                                   Description='JAV 24/01/22: - Se amplia de 10 a 20 para que no de error de longitud';


    }
    field(4;"Analytical Concept";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Analytical Concept',ESP='Concepto Analitico';

trigger OnValidate();
    BEGIN 
                                                                FunctionQB.ValidateCA("Analytical Concept");
                                                              END;

trigger OnLookup();
    BEGIN 
                                                              FunctionQB.LookUpCA("Analytical Concept",FALSE);
                                                            END;


    }
    field(5;"Currency Code";Code[10])
    {
        TableRelation="Currency";
                                                   CaptionML=ENU='Currency Code',ESP='C¢digo Divisa';


    }
    field(6;"Total Unit Price";Decimal)
    {
        CaptionML=ENU='Total Unit Price',ESP='Precio Unitario total';


    }
    field(7;"Price Subject Withholding";Decimal)
    {
        

                                                   CaptionML=ENU='Price Subject Deduction',ESP='Precio Sujeto a retenci¢n'; ;

trigger OnValidate();
    BEGIN 
                                                                IF "Price Subject Withholding" > "Total Unit Price" THEN
                                                                  ERROR(Text000);
                                                              END;


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
//       FunctionQB@1100286001 :
      FunctionQB: Codeunit 7207272;
//       Text000@1100286002 :
      Text000: TextConst ENU='Price not subject withholding must be less or equal to total unit price',ESP='El precio no sujeto a retenci¢n debe ser menor o igual al precio unitario total.';

    /*begin
    end.
  */
}







