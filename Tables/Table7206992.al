table 7206992 "QBU Job Responsible"
{
  
  
    CaptionML=ENU='Responsible',ESP='Responsable';
    LookupPageID="QB Job Responsibles List";
    DrillDownPageID="QB Job Responsibles List";
  
  fields
{
    field(1;"Type";Option)
    {
        OptionMembers="Job","Department","Piecework";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ENU='By Job,By Department,By Piecework',ESP='Por Proyecto,Por Departamento,Por Partida Presupuestaria';
                                                   
                                                   Description='Key 1 - JAV 23/10/20: - QB 1.07.00 Tipo de registro (Proyecto/Departamento)  QRE 1.00.15 16/05/22 Se a¤ade Piecework';


    }
    field(2;"Table Code";Code[20])
    {
        TableRelation=IF ("Type"=CONST("Job")) Job."No."                                                                 ELSE IF ("Type"=CONST("Department")) "QB Department"."Code"                                                                 ELSE IF ("Type"=CONST("Piecework")) Job."No.";
                                                   CaptionML=ENU='Job No.',ESP='C¢digo';
                                                   Description='Key 2 - C¢digo del proyecto o departamento';


    }
    field(3;"ID Register";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='ID';
                                                   Description='Key 4 - JAV 13/01/19: - Id del registro, se usa para poder tener registros con los cargos duplicados';


    }
    field(4;"Piecework No.";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Table Code"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='Key 3 -QPR 0.00.14 JAV 16/05/22: C¢digo de la partida presupuestaria';


    }
    field(10;"Position";Code[10])
    {
        TableRelation="QB Position";
                                                   

                                                   CaptionML=ENU='Position',ESP='Cargo';
                                                   Description='JAV 28/07/19: - Cambio el Name que no est  bien traducido';

trigger OnValidate();
    BEGIN 
                                                                IF QBPosition.GET(Position) THEN
                                                                  Rec."No in Approvals" := QBPosition."No in Approvals";

                                                                CALCFIELDS(Description);
                                                              END;


    }
    field(11;"Description";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("QB Position"."Description" WHERE ("Code"=FIELD("Position")));
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';
                                                   Editable=false;


    }
    field(12;"User ID";Code[50])
    {
        TableRelation="User Setup"."User ID";
                                                   

                                                   CaptionML=ENU='User ID',ESP='ID usuario';

trigger OnValidate();
    BEGIN 
                                                                //JAV 28/07/19 buscar el nombre
                                                                CALCFIELDS(Name);
                                                              END;


    }
    field(13;"Name";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("User"."Full Name" WHERE ("User Name"=FIELD("User ID")));
                                                   CaptionML=ENU='Name',ESP='Nombre Usuario';
                                                   Editable=false;


    }
    field(14;"No in Approvals";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No Aprueba';
                                                   Description='QB 1.10.36 JAV 22/04/22: [TT] Si se marca este campo, el usuario no interviene en las aprobaciones' ;


    }
}
  keys
{
    key(key1;"Type","Table Code","Piecework No.","ID Register")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       UserSetup@7001100 :
      UserSetup: Record 91;
//       Text005@1100286000 :
      Text005: TextConst ENU='You cannot have approval limits less than zero.',ESP='No puede tener l¡mites de aprobaci¢n inferiores a cero.';
//       QBPosition@1100286001 :
      QBPosition: Record 7206989;

//     procedure CopyFrom (pType@1100286005 : Option;pFrom@1100286006 : Code[20];pTo@1100286000 :
    procedure CopyFrom (pType: Option;pFrom: Code[20];pTo: Code[20])
    var
//       oResponsible@1100286002 :
      oResponsible: Record 7206992;
//       dResponsible@1100286001 :
      dResponsible: Record 7206992;
    begin
      //JAV 19/11/21: - QB 1.09.28 Copiar los responsables de un proyecto a otro

      //Los responsables
      oResponsible.RESET;
      oResponsible.SETRANGE(Type, pType);
      oResponsible.SETRANGE("Table Code", pFrom);
      if (oResponsible.FINDSET) then
        repeat
          dResponsible := oResponsible;
          dResponsible."Table Code" := pTo;
          dResponsible.INSERT;
        until oResponsible.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 12/07/19: - Se quita de la clave principal el cargo, dejando solo proyecto y usuario, y se a¤ade una segunda clave solo usuario.
//      JAV 28/07/19: - Se a¤aden campos 10, 12, 13, 14 y 15 para aprobaciones de compras y comparativos
//      JAV 09/09/19: - Se a¤ade el campo 9 "Internal Id" para identificar los registros un¡vocamente
//                    - Se a¤ade la key "Job No.","Level","Internal Id"
//      JAV 09/03/20: - Se a¤aden campos para los grupos y su inicializaci¢n
//      JAV 01/09/21: - QB 1.09.90 Se a¤aden campos 110, 111 y 112 mas una nueva key con el 110 para Aprobaci¢n de Presupuestos
//    }
    end.
  */
}







