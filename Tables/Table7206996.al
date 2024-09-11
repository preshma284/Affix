table 7206996 "QBU Job Status Changes"
{
  
  
    CaptionML=ENU='Job Status Changes',ESP='Cambios de estado de proyectos';
  
  fields
{
    field(1;"Job";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job',ESP='Proyecto';


    }
    field(2;"Entry No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Entry No.',ESP='Nro. Reg';


    }
    field(10;"Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Date',ESP='Fecha';


    }
    field(11;"User";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Usuario';


    }
    field(12;"Job Status Type";Option)
    {
        OptionMembers=" ","Estudio","Proyecto operativo","Promocion","Presupuesto";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage',ESP='Tipo de proyecto';
                                                   OptionCaptionML=ENU='" ,Planning,Project,Real State,Budget"',ESP='" ,Estudio,Proyecto operativo,Promoci¢n,Presupuesto"';
                                                   
                                                   Description='Tipo de proyecto seg£n la tabla de estados';


    }
    field(13;"Job Status Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Estado del Proyecto';
                                                   Description='Estado del proyecto seg£n la tabla de estados' ;


    }
}
  keys
{
    key(key1;"Job","Entry No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBJobStatusChanges@1100286000 :
      QBJobStatusChanges: Record 7206996;

    

trigger OnInsert();    begin
               QBJobStatusChanges.RESET;
               QBJobStatusChanges.SETRANGE(Job, Rec.Job);
               if (QBJobStatusChanges.FINDLAST) then
                 Rec."Entry No." := QBJobStatusChanges."Entry No." + 1
               else
                 Rec."Entry No." := 1;
               Rec.Date := TODAY;
               Rec.User := USERID;
             end;



/*begin
    {
      JAV 10/10/22: - QB 1.12.00 Se elimina el uso de esta tabla, se puede reutilizar
    }
    end.
  */
}







