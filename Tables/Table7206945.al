table 7206945 "QBU Job Task Month"
{
  
  
    CaptionML=ENU='Job Task Month',ESP='Meses para Tareas de Proyectos';
  
  fields
{
    field(1;"Job";Text[30])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Name',ESP='Proyecto';


    }
    field(2;"Year";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='A¤o';

trigger OnValidate();
    BEGIN 
                                                                VALIDATE(Period);
                                                              END;


    }
    field(3;"Month";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Mes';

trigger OnValidate();
    BEGIN 
                                                                VALIDATE(Period);
                                                              END;


    }
    field(10;"Period";Code[10])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Periodo';
                                                   Editable=false ;

trigger OnValidate();
    BEGIN 
                                                                Period := QBJobTaskManagement.GetPeriod(DMY2DATE(1,Month, Year));
                                                              END;


    }
}
  keys
{
    key(key1;"Job","Year","Month")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBJobTaskManagement@1100286000 :
      QBJobTaskManagement: Codeunit 7206902;

    

trigger OnInsert();    begin
               VALIDATE(Period);
             end;

trigger OnModify();    begin
               VALIDATE(Period);
             end;



/*begin
    end.
  */
}







