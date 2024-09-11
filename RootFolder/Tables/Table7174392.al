table 7174392 "QM MasterData Table"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='MasterData Table',ESP='MasterData Tablas';
  
  fields
{
    field(1;"Table No.";Integer)
    {
        TableRelation=AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST("Table"));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Table',ESP='N§ de Tabla';

trigger OnValidate();
    BEGIN 
                                                                //JAV 28/04/22: - QM 1.00.03 Al crear una nueva tabla marcamos si hay dimensiones predeterminadas para la tabla
                                                                QMMasterDataTableField.CreateFields("Table No.");
                                                                Dimensions := HaveDefaultDimension("Table No.");
                                                              END;


    }
    field(10;"Table Name";Text[250])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("AllObjWithCaption"."Object Caption" WHERE ("Object Type"=CONST("Table"),
                                                                                                                "Object ID"=FIELD("Table No.")));
                                                   CaptionML=ESP='Nombre de la Tabla';
                                                   Description='MD 1.00.03 JAV 27/04/22 - Se ampl¡a la longitud para que pueda salir correctamente';
                                                   Editable=false;


    }
    field(11;"Sync";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Sincronizar';
                                                   Description='MD 1.00.02 JAV 22/04/22: - [TT] Si es una tabla a sincronizar desde la empresa Master';


    }
    field(12;"Dimensions";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Dimensions',ESP='Sincronizar Dimensiones';
                                                   Description='MD 1.00.04 JAV 28/04/22: - [TT] Si se desean sincronizar las dimensiones por defecto asociadas a la tabla';

trigger OnValidate();
    BEGIN 
                                                                QMMasterDataTableField.RESET;
                                                                QMMasterDataTableField.SETRANGE("Table No.", "Table No.");
                                                                QMMasterDataTableField.SETRANGE(PK, TRUE);
                                                                IF (QMMasterDataTableField.COUNT <> 1) THEN
                                                                  ERROR('Esta tabla no admite dimensiones por defecto');
                                                              END;


    }
    field(13;"Is Default Dimension Table";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='MD 1.00.04 JAV 28/04/22: Es la tabla de dimeniones por defecto, no se puede eliminar';


    }
    field(14;"Modification in Destination";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Modificaciones en destino';
                                                   Description='MD 1.00.05 JAV 22/07/22: Indica que se permiten Altas, Bajas y Modificaciones en destino, que se retrasmite a todas las empresas' ;


    }
}
  keys
{
    key(key1;"Table No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       DefaultDimension@1100286006 :
      DefaultDimension: Record 352;
//       QMMasterDataCompanies@1100286009 :
      QMMasterDataCompanies: Record 7174391;
//       QMMasterDataTable@1100286007 :
      QMMasterDataTable: Record 7174392;
//       QMMasterDataTableField@1100286002 :
      QMMasterDataTableField: Record 7174393;
//       QMMasterDataManagement@1100286003 :
      QMMasterDataManagement: Codeunit 7174368;
//       QMMasterDataCompanieTable@1100286008 :
      QMMasterDataCompanieTable: Record 7174394;
//       QMMasterDataConfTables@1100286005 :
      QMMasterDataConfTables: Record 7174389;
//       rRef@1100286000 :
      rRef: RecordRef;
//       fRef@1100286004 :
      fRef: FieldRef;
//       cp@1100286001 :
      cp: Text;

    

trigger OnDelete();    begin
               if ("Is Default Dimension Table") then
                 ERROR('No puede eliminar la tabla de dimensiones por defecto');

               //Si lo eliminamos de aqu¡ y no hay registro en la de tablas para configuraci¢n eliminamos los campos
               if (not QMMasterDataConfTables.GET(Rec."Table No.")) then begin
                 QMMasterDataTableField.RESET;
                 QMMasterDataTableField.SETRANGE("Table No.", Rec."Table No.");
                 QMMasterDataTableField.DELETEALL;
               end;
             end;

trigger OnRename();    begin
               ERROR('No puede cambiar la tabla, cree una nueva y elimine esta');
             end;



procedure GetTableCaption () : Text;
    begin
      if ("Table No." = 0) then
        exit('')
      else begin
        rRef.OPEN("Table No.");
        cp := rRef.CAPTION;
        rRef.CLOSE;
        exit(cp);
      end;
    end;

//     procedure HaveDefaultDimension (pTable@1100286000 :
    procedure HaveDefaultDimension (pTable: Integer) : Boolean;
    begin
      //JAV 28/04/22: - QM 1.00.03 Retorna si hay registros para dimensiones predeterminadas para una tabla dada en la empresa Master
      DefaultDimension.RESET;
      DefaultDimension.CHANGECOMPANY(QMMasterDataManagement.GetMaster);
      DefaultDimension.SETRANGE("Table ID", "Table No.");
      exit (not DefaultDimension.ISEMPTY);
    end;

    procedure InsertDefaultDimension ()
    begin
      QMMasterDataTable.INIT;
      QMMasterDataTable."Table No." := DATABASE::"Default Dimension";
      QMMasterDataTable.Sync := TRUE;
      QMMasterDataTable."Is Default Dimension Table" := TRUE;
      QMMasterDataTable.Dimensions := FALSE;
      if not QMMasterDataTable.INSERT then;

      QMMasterDataTableField.CreateFields(QMMasterDataTable."Table No.");

      QMMasterDataTableField.RESET;
      QMMasterDataTableField.SETRANGE("Table No.", QMMasterDataTable."Table No.");
      if (QMMasterDataTableField.FINDSET) then
        repeat
          QMMasterDataTableField.CALCFIELDS(FlowFilter, FlowField);
          QMMasterDataTableField.VALIDATE("not editable in destination", not (QMMasterDataTableField.FlowFilter or QMMasterDataTableField.FlowField));
          QMMasterDataTableField.MODIFY;
        until (QMMasterDataTableField.NEXT = 0);


      QMMasterDataCompanies.RESET;
      QMMasterDataCompanies.SETFILTER(Company, '<>%1', QMMasterDataManagement.GetMaster);
      if (QMMasterDataCompanies.FINDSET) then
        repeat
          QMMasterDataCompanieTable.INIT;
          QMMasterDataCompanieTable.Company := QMMasterDataCompanies.Company;
          QMMasterDataCompanieTable."Table No." := QMMasterDataTable."Table No.";
          QMMasterDataCompanieTable.Sync := QMMasterDataCompanieTable.Sync::Automatic;
          if not QMMasterDataCompanieTable.MODIFY then
            QMMasterDataCompanieTable.INSERT;

        until (QMMasterDataCompanies.NEXT = 0);
    end;

    /*begin
    //{
//      JAV 28/04/22: - QM 1.00.03 Al crear una nueva tabla marcamos si hay dimensiones predeterminadas para la tabla
//                                 Nueva funci¢n que retorna si hay registros para dimensiones predeterminadas para una tabla dada en la empresa MASTER
//    }
    end.
  */
}







