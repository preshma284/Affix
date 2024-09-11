table 7207332 "Invoice Milestone Comments"
{
  
  
    CaptionML=ENU='Invoice Milestone Comments',ESP='Comentario Hitos Facturaci¢n';
    LookupPageID="Invoice Milestone Comments";
    DrillDownPageID="Invoice Milestone Comments";
  
  fields
{
    field(1;"Line No.";Integer)
    {
        CaptionML=ENU='Line No.',ESP='N§ l¡nea';


    }
    field(2;"Type";Option)
    {
        OptionMembers="Proyecto","Hito";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='Proyecto,Hito',ESP='Proyecto,Hito';
                                                   


    }
    field(3;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(4;"Milestone No.";Code[10])
    {
        TableRelation="Invoice Milestone"."Milestone No." WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Milestone No.',ESP='N§ hito';


    }
    field(5;"Comment";Text[50])
    {
        CaptionML=ENU='Comment',ESP='Comentario'; ;


    }
}
  keys
{
    key(key1;"Type","Job No.","Milestone No.","Line No.")
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







