table 7174653 "QBU DragDrop File"
{
  
  
    CaptionML=ENU='DragDrop File',ESP='Log Transmisi¢n de ficheros a Sharepoint';
  
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
    field(3;"File Content";BLOB)
    {
        CaptionML=ENU='File Content',ESP='Contenido Fichero (blob)';


    }
    field(4;"Dictionary SP";BLOB)
    {
        CaptionML=ENU='Dictionary SP',ESP='Metadatos del fichero';


    }
    field(5;"Sharepoint Site Definition";Code[20])
    {
        CaptionML=ENU='Sharepoint Site Definition',ESP='No. Site Sharepoint';


    }
    field(6;"Creation Date";DateTime)
    {
        CaptionML=ENU='Creation Date',ESP='Fecha creaci¢n';


    }
    field(7;"User";Text[50])
    {
        CaptionML=ENU='User',ESP='Usuario';


    }
    field(8;"Send";Boolean)
    {
        CaptionML=ENU='Send',ESP='Enviado';


    }
    field(9;"Send Date";DateTime)
    {
        CaptionML=ENU='Send Date',ESP='Fecha env¡o a SP';


    }
    field(10;"Url";Text[250])
    {
        CaptionML=ENU='Url (interno)',ESP='Url';


    }
    field(11;"Library Title";Text[250])
    {
        CaptionML=ENU='Library Title',ESP='Titulo de la libreria SP';


    }
    field(12;"PK RecordID";RecordID)
    {
        CaptionML=ESP='PK RecordID';


    }
    field(13;"Response SP";BLOB)
    {
        CaptionML=ESP='Respuesta SP';


    }
    field(14;"Update Metadata Only";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='S¢lo actualizar metadatos';
                                                   Description='17160. CPA 25-05-22. Factboxes de D&D en facturas de compra y venta' ;


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
      QUONEXT 20.07.17 DRAG&DROP. Se guardan los ficheros a subir a Sharepoint con los metadatos, blob ficheros, ruta....
      QUONEXT 20.07.17 DRAG&DROP. Se utiliza como log y para proceso subida de ficheros en batch.
      QUONEXT 20.07.17 DRAG&DROP. Se utiliza de forma temporal para mostrar los ficheros cargados en un site (Factbox)

      17160. CPA 25-05-22. Factboxes de D&D en facturas de compra y venta
    }
    end.
  */
}







