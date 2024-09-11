table 7207274 "QB Text Saved"
{
  
  
    CaptionML=ENU='QuoBuilding Text',ESP='Textos para QuoBuilding';
  
  fields
{
    field(1;"Table";Option)
    {
        OptionMembers="Preciario","Job";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tabla';
                                                   OptionCaptionML=ESP='Preciario,Proyecto';
                                                   
                                                   Description='QB 1.0';


    }
    field(2;"Key1";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Clave 1';
                                                   Description='QB 1.0';


    }
    field(3;"Key2";Code[30])
    {
        CaptionML=ENU='No.',ESP='Clave 2';
                                                   Description='QB 1.0';


    }
    field(4;"Key3";Code[20])
    {
        CaptionML=ENU='No.',ESP='Clave 3';
                                                   Description='QB 1.0';


    }
    field(10;"Cost Text";BLOB)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Extended description',ESP='Texto Coste';
                                                   Description='QB 1.0';
                                                   SubType=Memo;


    }
    field(11;"Cost Size";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tama¤o Texto Coste';
                                                   Description='QB 1.0';
                                                   Editable=false;


    }
    field(12;"Sales Text";BLOB)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Extended description',ESP='Texto Venta';
                                                   Description='QB 1.0';
                                                   SubType=Memo;


    }
    field(13;"Sales Size";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tama¤o Texto Venta';
                                                   Description='QB 1.0';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Table","Key1","Key2","Key3")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 25/07/19: - Esta tabla es una copia de la 7207387, para guardar registros que se han modificado y se pueden volver a recuperar
    }
    end.
  */
}







