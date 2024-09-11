table 7174393 "QM MasterData Table Field"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='MasterData Table Field',ESP='MasterData Campos de la Tabla';
  
  fields
{
    field(1;"Table No.";Integer)
    {
        TableRelation=AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST("Table"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tabla';


    }
    field(2;"Field No.";Integer)
    {
        TableRelation=Field."No." WHERE ("TableNo"=FIELD("Table No."));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Campo';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS("Field Name");
                                                              END;


    }
    field(11;"Field Name";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Field"."Field Caption" WHERE ("TableNo"=FIELD("Table No."),
                                                                                                   "No."=FIELD("Field No.")));
                                                   CaptionML=ESP='Descripci¢n de Campo';
                                                   Editable=false;


    }
    field(12;"PK";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Clave Primaria';
                                                   Description='QM 1.00.00 JAV 22/04/22: - [TT] Si el campo es parte de la clave primaria';
                                                   Editable=false;


    }
    field(13;"FlowFilter";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist(Field WHERE ("TableNo"=FIELD("Table No."),
                                                                                  "No."=FIELD("Field No."),
                                                                                  "Class"=CONST("FlowFilter")));
                                                   CaptionML=ESP='Campo Filtro';
                                                   Description='QM 1.00.01 JAV 22/04/22: - [TT] Si el campo es usado solo para filtros (no es un campo sincronizable)';
                                                   Editable=false;


    }
    field(14;"FlowField";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist(Field WHERE ("TableNo"=FIELD("Table No."),
                                                                                  "No."=FIELD("Field No."),
                                                                                  "Class"=CONST("FlowField")));
                                                   CaptionML=ESP='Campo Calculado';
                                                   Description='QM 1.00.01 JAV 22/04/22: - [TT] Si el campo es de tipo calculado (no es un campo sincronizable)';
                                                   Editable=false;


    }
    field(15;"Date Variable";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha variable';
                                                   Description='QM 1.00.01 JAV 22/04/22: - [TT] Este campo indica si la fecha puede ser la de alta o la de £ltima modificaci¢n, que deben marcarse siempre como editables en destino para evitar problemas de cambios sobre cambios';
                                                   Editable=false;


    }
    field(16;"Relation Table No.";Integer)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Field"."RelationTableNo" WHERE ("TableNo"=FIELD("Table No."),
                                                                                                   "No."=FIELD("Field No.")));
                                                   CaptionML=ESP='Relacionado con tabla';
                                                   Description='QM 1.00.01 JAV 22/04/22: - [TT] Este valor indica con que tabla se relaciona este campo';
                                                   Editable=false;


    }
    field(17;"Relation Table Name";Text[250])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("AllObjWithCaption"."Object Caption" WHERE ("Object Type"=CONST("Table"),
                                                                                                                "Object ID"=FIELD("Relation Table No.")));
                                                   CaptionML=ESP='Relacionado con Nombre Tabla';
                                                   Description='MD 1.00.03 JAV 27/04/22 - Se ampl¡a la longitud para que pueda salir correctamente [TT] Este valor indica el nombre de la tabla con la que se relaciona este campo';
                                                   Editable=false;


    }
    field(41;"Not editable in destination";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No editable en destino';
                                                   Description='QM 1.00.01 JAV 10/09/20: - [TT] En la sicronizaci¢n por tablas, incica si el campo no ser  editable en la empresa de destino de la sincronizaci¢n';

trigger OnValidate();
    BEGIN 
                                                                IF (Rec."Not editable in destination") AND (Rec."Date Variable") THEN
                                                                  MESSAGE(Text01, Rec."Field No.");
                                                              END;


    }
    field(42;"MD Relation Table Sync";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist("QM MasterData Table" WHERE ("Table No."=FIELD("Relation Table No."),
                                                                                                  "Sync"=FILTER(true)));
                                                   CaptionML=ESP='Tabla Relacionada se Sincroniza';
                                                   Description='QM 1.00.01 JAV 22/04/22: - [TT] Este campo indica que la tabla relacionada est  incluida entre las tablas que se sincronizan y est  activada su sincornizaci¢n';
                                                   Editable=false;


    }
    field(51;"Syncronization";Option)
    {
        OptionMembers="Yes","OnlyQB","No";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Sincronizar';
                                                   OptionCaptionML=ESP='Siempre,Solo para QuoBuilding,No Sincronizar';
                                                   
                                                   Description='QM 1.00.02 JAV 23/04/22: - [TT] Informa de cuando se sincronizar  este campo en la empresa de destino, siempre, nunca, solo si la empresa tiene marcado QuoBuilding';


    }
    field(52;"CN Relation Table Sync";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist("QM MasterData Conf. Tables" WHERE ("Table No."=FIELD("Relation Table No.")));
                                                   CaptionML=ESP='Tabla Relacionada se Sincroniza';
                                                   Description='QM 1.00.01 JAV 22/04/22: - [TT] Este campo indica que la tabla relacionada est  incluida entre las tablas que se traspasan con la Configuraci¢n';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Table No.","Field No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Text01@1100286000 :
      Text01: TextConst ESP='El campo %1 es posiblemente una fecha de creaci¢n o de £ltima modificaci¢n, si lo marca puede producir errores, aseg£rese bien de lo que ha marcado.';

//     procedure CreateFields (pTabla@1100286002 :
    procedure CreateFields (pTabla: Integer)
    var
//       tbObject@1100286005 :
      tbObject: Record 2000000001;
//       tbFields@1100286000 :
      tbFields: Record 2000000041;
//       QMMasterDataTable@1100286006 :
      QMMasterDataTable: Record 7174392;
//       QMMasterDataTableField@1100286001 :
      QMMasterDataTableField: Record 7174393;
//       QMMasterDataManagement@1100286008 :
      QMMasterDataManagement: Codeunit 7174368;
//       rRef@1100286007 :
      rRef: RecordRef;
//       t1@1100286003 :
      t1: Boolean;
//       t2@1100286004 :
      t2: Boolean;
    begin
      //JAV 22/04/22: - MD 1.00.02 Crear los campos que no existan de la tabla en el registro de campos
      tbFields.RESET;
      tbFields.SETRANGE(TableNo, pTabla);
      tbFields.SETRANGE(Enabled, TRUE);
      if (tbFields.FINDSET(FALSE)) then
        repeat
          if (not QMMasterDataTableField.GET(pTabla, tbFields."No.")) then begin
            QMMasterDataTableField.INIT;
            QMMasterDataTableField."Table No." := pTabla;
            QMMasterDataTableField."Field No." := tbFields."No.";
            QMMasterDataTableField.Syncronization := QMMasterDataTableField.Syncronization::Yes;   //JAV 23/04/22: - MD 1.00.02 Los nuevos campos los a¤ado con su valor por defecto
            QMMasterDataTableField.INSERT;
          end;

          //JAV 22/04/22: - MD 1.00.02 Revisar si hay cambios en los campos
          rRef.OPEN(pTabla);
          QMMasterDataTableField.PK := QMMasterDataManagement.IsPrimaryKeyField(rRef, QMMasterDataTableField."Field No.");
          rRef.CLOSE;

          if (tbFields.Type IN [tbFields.Type::Date, tbFields.Type::DateTime]) then begin
            t1 := (STRPOS(UPPERCASE(tbFields.FieldName),'CREATION') <> 0) or (STRPOS(UPPERCASE(tbFields.FieldName),'LAST') <> 0);
            t2 := (STRPOS(UPPERCASE(tbFields.FieldName),'DATE') <> 0)     or (STRPOS(UPPERCASE(tbFields.FieldName),'MODIFIED') <> 0);
            QMMasterDataTableField."Date Variable" := t1 and t2;
          end;

          QMMasterDataTableField.CALCFIELDS(FlowFilter,FlowField);

          //Para la MasterData
          if (QMMasterDataTableField.PK) then
            QMMasterDataTableField."not editable in destination" := TRUE;
          if (QMMasterDataTableField.FlowFilter) or (QMMasterDataTableField.FlowField) then
            QMMasterDataTableField."not editable in destination" := FALSE;

          //JAV 23/04/22: - MD 1.00.02 Para la configuraci¢n
          if (QMMasterDataTableField.FlowFilter) or (QMMasterDataTableField.FlowField) then
            QMMasterDataTableField.Syncronization := QMMasterDataTableField.Syncronization::No
          else if (QMMasterDataTableField.PK) or (pTabla < 71000000) then
            QMMasterDataTableField.Syncronization := QMMasterDataTableField.Syncronization::Yes
          else
            QMMasterDataTableField.Syncronization := QMMasterDataTableField.Syncronization::OnlyQB;


          QMMasterDataTableField.MODIFY;

        until (tbFields.NEXT = 0);

      //JAV 22/04/22: - MD 1.00.02 Eliminar los registros de campos eliminados
      QMMasterDataTableField.RESET;
      QMMasterDataTableField.SETRANGE("Table No.", pTabla);
      if (QMMasterDataTableField.FINDSET(FALSE)) then
        repeat
          if not tbFields.GET(pTabla, QMMasterDataTableField."Field No.") then
            QMMasterDataTableField.DELETE;
        until (QMMasterDataTableField.NEXT = 0);
    end;

    /*begin
    end.
  */
}







