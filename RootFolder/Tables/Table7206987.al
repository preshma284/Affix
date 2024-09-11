table 7206987 "QB Approval Circuit Lines"
{
  
  
    CaptionML=ENU='Approval Circuit Lines',ESP='L¡neas del Circuito de Aprobaci¢n';
  
  fields
{
    field(1;"Circuit Code";Code[20])
    {
        CaptionML=ENU='Circuit Code',ESP='C¢digo del Circuito';


    }
    field(2;"Line Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Line Code',ESP='C¢digo de l¡nea';
                                                   Description='JAV 13/01/19: - Id del registro, se usa para poder tener registros con los cargos duplicados';


    }
    field(10;"Position";Code[10])
    {
        TableRelation="QB Position";
                                                   

                                                   CaptionML=ENU='Charges',ESP='Cargo';
                                                   Description='JAV 28/07/19: - Cambio el Name que no est  bien traducido';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Approval Level" = 0) THEN
                                                                  IF QBPosition.GET(Position) THEN
                                                                    Rec."Approval Level" := QBPosition."Default Level";

                                                                Rec.CALCFIELDS(Description);
                                                              END;


    }
    field(11;"Description";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("QB Position"."Description" WHERE ("Code"=FIELD("Position")));
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';
                                                   Editable=false;


    }
    field(12;"Optional";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Optional',ESP='Opcional';


    }
    field(13;"User";Text[50])
    {
        TableRelation="User Setup";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Usuario';
                                                   Description='QB 1.10.31 JAV 04/04/22: - Para la aprobaci¢n por usuarios [TT] Indica el usuario que debe aprobar el documento a este nivel';


    }
    field(20;"Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n';


    }
    field(21;"Approval Limit";Decimal)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n';

trigger OnValidate();
    BEGIN 
                                                                IF "Approval Limit" < 0 THEN
                                                                  ERROR(Text005);
                                                              END;


    }
    field(22;"Approval Unlim.";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada';

trigger OnValidate();
    BEGIN 
                                                                IF "Approval Unlim." THEN
                                                                  "Approval Limit" := 0;
                                                              END;


    }
    field(31;"tmp User";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='NO UTILIZAR, solo de uso para un proceso';
                                                   Description='JAV 22/02/22: - Auxiliar solo para montar la tabla temporal, no usar en pantallas' ;


    }
}
  keys
{
    key(key1;"Circuit Code","Line Code")
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
//       QBPosition@7001101 :
      QBPosition: Record 7206989;
//       Text005@1100286000 :
      Text005: TextConst ENU='You cannot have approval limits less than zero.',ESP='No puede tener l¡mites de aprobaci¢n inferiores a cero.';

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
//      JAV 04/04/22: - QB 1.10.31 Se a¤ade el campo del usuario para la nueva aprobaci¢n por usuarios
//    }
    end.
  */
}







