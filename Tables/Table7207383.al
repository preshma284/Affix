table 7207383 "QBU QPR Amounts"
{
  
  
    CaptionML=ENU='Budget Amounts',ESP='Importes Presupuesto';
    LookupPageID="QPR Budget Data Amounts";
    DrillDownPageID="QPR Budget Data Amounts";
  
  fields
{
    field(1;"Entry No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Registro';


    }
    field(2;"Expected Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Expected Date',ESP='Fecha prevista';
                                                   Description='QR15703';


    }
    field(10;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(11;"Budget Code";Code[20])
    {
        CaptionML=ENU='Line No.',ESP='N§ Presupuesto';


    }
    field(12;"Piecework code";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Cod. unidad de obra',ESP='C¢d. unidad de obra';


    }
    field(13;"Type";Option)
    {
        OptionMembers="Cost","Sales";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ENU='Cost,Sales',ESP='Gastos,Ingresos';
                                                   


    }
    field(20;"Cost Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Coste';


    }
    field(21;"Sale Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Venta';


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        Clustered=true;
    }
    key(key2;"Job No.","Budget Code","Piecework code","Type")
    {
        ;
    }
}
  fieldgroups
{
}
  

    

trigger OnInsert();    begin
               if "Expected Date"=0D then
                 "Expected Date":=TODAY;
             end;



/*begin
    end.
  */
}







