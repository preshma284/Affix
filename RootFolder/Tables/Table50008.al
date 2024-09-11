table 50008 "Assets Maintenance"
{
  
  
    CaptionML=ENU='Assets Maintenance',ESP='Mantenimiento activos';
  
  fields
{
    field(1;"Asset No.";Code[20])
    {
        TableRelation="Fixed Asset"."No.";
                                                   CaptionML=ENU='Asset No.',ESP='N§ Activo';


    }
    field(2;"Line No.";Integer)
    {
        CaptionML=ENU='Line No.',ESP='N§ l¡nea';


    }
    field(3;"Type";Option)
    {
        OptionMembers="Technical Detail","Certification","Status Control";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='Technical Detail,Certification,Status Control',ESP='Ficha T‚cnica,Certificaci¢n,Control de estado';
                                                   


    }
    field(4;"Description";Text[250])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(5;"Posting DateTime";DateTime)
    {
        CaptionML=ENU='Posting DateTime',ESP='Fecha y hora de registro';


    }
    field(6;"Certification Date";Date)
    {
        CaptionML=ENU='Certification Date',ESP='Fecha certificaci¢n';


    }
    field(7;"Status Control Date";Date)
    {
        CaptionML=ENU='Status Control Date',ESP='Fecha control de estado';


    }
    field(8;"Next Control Date";Date)
    {
        CaptionML=ENU='Next Control Date',ESP='Fecha pr¢ximo control'; ;


    }
}
  keys
{
    key(key1;"Asset No.","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       CertifBool@1100286000 :
      CertifBool: Boolean;

    /*begin
    end.
  */
}







