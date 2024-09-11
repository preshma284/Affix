table 7207361 "QBU Rental Planning Information"
{
  
  
    CaptionML=ENU='Rental Planning Information',ESP='Datos Planificaci¢n alquiler';
    LookupPageID="Elements Rental Forecast";
    DrillDownPageID="Elements Rental Forecast";
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(2;"Expected Date";Date)
    {
        CaptionML=ENU='Expected Date',ESP='Fecha prevista';


    }
    field(3;"Number Of Items";Decimal)
    {
        

                                                   CaptionML=ENU='Number Of Items',ESP='Cantidad elementos';

trigger OnValidate();
    VAR
//                                                                 Job@7001100 :
                                                                Job: Record 167;
//                                                                 DataJobUnitForProduction@7001101 :
                                                                DataJobUnitForProduction: Record 7207386;
                                                              BEGIN 
                                                                   //controlamos que al insertar el primer registro y la fecha es cero cargar la fecha inicial del proyecto o la de hoy
                                                                   IF "Expected Date" = 0D THEN BEGIN 
                                                                     Job.GET("Job No.");
                                                                     "Budget Code" := Job."Latest Reestimation Code";
                                                                     IF Job."Starting Date" <> 0D THEN
                                                                       "Expected Date" := Job."Starting Date"
                                                                     ELSE
                                                                       "Expected Date" := TODAY;
                                                                   END;
                                                                   IF DataJobUnitForProduction.GET("Job No.","Piecework Code") THEN BEGIN 
                                                                     "Cost Database Code" := DataJobUnitForProduction."Code Cost Database";
                                                                     "Unique Code" := DataJobUnitForProduction."Unique Code";
                                                                   END;
                                                              END;


    }
    field(4;"Budget Code";Code[20])
    {
        TableRelation="Job Budget"."Cod. Budget" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Budget Code',ESP='C¢d. presupuesto';


    }
    field(5;"Piecework Code";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Piecework Code',ESP='C¢d. unidad de obra';


    }
    field(6;"Entry No.";Integer)
    {
        CaptionML=ENU='Entry No.',ESP='N§ Mov.';


    }
    field(8;"Unit Type";Option)
    {
        OptionMembers="Unidad de obra","Unidad de coste";CaptionML=ENU='Unit Type',ESP='Tipo unidad';
                                                   OptionCaptionML=ENU='Unidad de obra,Unidad de coste',ESP='Unidad de obra,Unidad de coste';
                                                   


    }
    field(9;"Included In Part";Boolean)
    {
        CaptionML=ENU='Included In Part',ESP='Incluido en parte';


    }
    field(10;"Doc. Party No.";Code[20])
    {
        CaptionML=ENU='Doc. Party No.',ESP='N§ doc. parte';


    }
    field(11;"Decription";Text[50])
    {
        CaptionML=ENU='Decription',ESP='Descripci¢n';


    }
    field(12;"Cost Database Code";Code[20])
    {
        TableRelation="Cost Database";
                                                   CaptionML=ENU='Cost Database Code',ESP='C¢d. preciario';


    }
    field(13;"Unique Code";Code[20])
    {
        CaptionML=ENU='Unique Code',ESP='C¢digo £nico';


    }
    field(14;"Realized";Boolean)
    {
        CaptionML=ENU='Performed',ESP='Realizado'; ;


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        Clustered=true;
    }
    key(key2;"Job No.","Piecework Code","Budget Code")
    {
        SumIndexFields="Number Of Items";
    }
    key(key3;"Job No.","Piecework Code","Budget Code","Expected Date")
    {
        SumIndexFields="Number Of Items";
    }
    key(key4;"Job No.","Piecework Code","Expected Date")
    {
        SumIndexFields="Number Of Items";
    }
}
  fieldgroups
{
}
  

    /*begin
    end.
  */
}







