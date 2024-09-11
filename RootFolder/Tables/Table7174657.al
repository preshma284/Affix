table 7174657 "DragDrop File Factbox"
{
  
  
    CaptionML=ENU='DragDrop File',ESP='Log ficheros SP';
  
  fields
{
    field(1;"Entry No.";Integer)
    {
        AutoIncrement=true;
                                                   CaptionML=ENU='Entry No.',ESP='No. Mov.';


    }
    field(2;"File Name";Text[250])
    {
        CaptionML=ENU='File Name',ESP='Nombre fichero';


    }
    field(3;"Creation Date";DateTime)
    {
        CaptionML=ESP='Fecha creaci¢n';


    }
    field(5;"Sharepoint Site Definition";Code[20])
    {
        TableRelation="Site Sharepoint Definition"."No.";
                                                   CaptionML=ENU='Sharepoint Site Definition',ESP='No. Site Sharepoint';


    }
    field(6;"Url";Text[250])
    {
        CaptionML=ENU='Url (interno)',ESP='Url';


    }
    field(7;"Library Title";Text[250])
    {
        CaptionML=ENU='Library Title',ESP='Titulo de la libreria SP';


    }
    field(8;"PK RecordID";RecordID)
    {
        CaptionML=ESP='PK RecordID';


    }
    field(9;"Filter";Text[250])
    {
        CaptionML=ESP='Filtro';


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      QUONEXT 20.07.17 DRAG&DROP. Se utiliza para mostrar los ficheros cargados en un site (Factbox)
    }
    end.
  */
}







