table 7206927 "QBU Job Task Data"
{
  
  
    CaptionML=ENU='Job Task Data',ESP='Datos de Tareas de Proyecto';
  
  fields
{
    field(1;"Job";Text[30])
    {
        TableRelation="Company";
                                                   CaptionML=ENU='Name',ESP='Proyecto';


    }
    field(2;"Period";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Periodo';
                                                   Editable=false;


    }
    field(3;"Task";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tarea';


    }
    field(10;"Date";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha';
                                                   Editable=false;


    }
    field(11;"User";Code[50])
    {
        

                                                   CaptionML=ENU='Display Name',ESP='Usuario';

trigger OnValidate();
    VAR
//                                                                 QBRelatedCompanies@1100286000 :
                                                                QBRelatedCompanies: Record 7206927;
                                                              BEGIN 
                                                              END;


    }
    field(12;"Comment";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Comentario';


    }
    field(20;"Performed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Ejecutada';


    }
}
  keys
{
    key(key1;"Job","Period","Task")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBRelatedCompanies@1100286000 :
      QBRelatedCompanies: Record 7206927;
//       QuoBuildingSetup@1100286001 :
      QuoBuildingSetup: Record 7207278;
//       Txt01@1100286002 :
      Txt01: TextConst ESP='No pude sincronizar manual en la empresa Master';

    /*begin
    end.
  */
}







