table 7206902 "QBU Job Task"
{
  
  
    CaptionML=ENU='Job Task',ESP='Tareas de Proyectos';
  
  fields
{
    field(1;"Code";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='CÂ¢digo';


    }
    field(10;"Job Type";Option)
    {
        OptionMembers="QB","QPR","QRE";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de Proyecto';
                                                   OptionCaptionML=ENU='QB,QPR,QRE',ESP='QB,QPR,QRE';
                                                   


    }
    field(11;"Status";Option)
    {
        OptionMembers="Active","Inactive";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Estado';
                                                   OptionCaptionML=ENU='Active,Inactive',ESP='Activo,No Activo';
                                                   


    }
    field(12;"Order";Integer)
    {
        CaptionML=ENU='Use in',ESP='àrden';


    }
    field(13;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='DescripciÂ¢n';


    }
    field(16;"Approval Circuit";Code[20])
    {
        TableRelation="QB Approval Circuit Header" WHERE ("Document Type"=CONST("JobTask"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Circuito de Aprobaci¢n';


    }
    field(17;"Mandatory before the rest";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Obligatoria antes del resto';


    }
    field(18;"Erasable with Next";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Borrable con siguiente';


    }
    field(20;"Perform Type";Option)
    {
        OptionMembers="Check","CU","RP";CaptionML=ENU='User ID',ESP='Realizar Tipo';
                                                   OptionCaptionML=ENU='Check,Codeunit,Report',ESP='Check,Codeunit,Report';
                                                   


    }
    field(21;"Perform Object";Integer)
    {
        CaptionML=ENU='Name',ESP='Realizar Objeto';
                                                   BlankZero=true;


    }
    field(22;"Cancel Type";Option)
    {
        OptionMembers="Check","CU","RP";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User ID',ESP='Cancelar Tipo';
                                                   OptionCaptionML=ENU='Check,Codeunit,Report',ESP='Check,Codeunit,Report';
                                                   


    }
    field(23;"Cancel Object";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Name',ESP='Cancelar Objeto';
                                                   BlankZero=true ;


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBJobTask@1100286000 :
      QBJobTask: Record 7206902;
//       i@1100286001 :
      i: Integer;

    

trigger OnInsert();    begin
               if (Code = 0) then begin
                 QBJobTask.RESET;
                 if (QBJobTask.FINDLAST) then
                   Code := QBJobTask.Code + 1
                 else
                   Code := 1;
               end;
             end;



/*begin
    {
      JAV 11/08/22: - QB 1.11.02 Nueva tabla de configuraci¢n de Tareas de Proyecto
    }
    end.
  */
}







