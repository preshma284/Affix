table 7174395 "QBU QM MasterData Data Sync. Log"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='MasterData Data Register',ESP='MasterData Registros de Datos';
  
  fields
{
    field(1;"Table";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tabla';


    }
    field(2;"RecordID";RecordID)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='RecordID';


    }
    field(3;"With Company";Text[50])
    {
        TableRelation="Company"."Name";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa Destino';

trigger OnValidate();
    BEGIN 
                                                                IF (NOT Company.GET("With Company")) THEN
                                                                  ERROR(txtMD000, "With Company");

                                                                IF ("With Company" = QMMasterDataManagement.GetMaster) THEN
                                                                  ERROR(txtMD001);
                                                              END;


    }
    field(5;"Code 1";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo 1';
                                                   Description='C¢digo 1 de la tabla';


    }
    field(10;"Creation Date";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha de Creaci¢n';
                                                   Description='Fecha en que se cre¢ el registro desde la master data';
                                                   Editable=false;


    }
    field(11;"Update Date";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha éltima Actualizaci¢n';
                                                   Description='Fecha en que se actualiz¢';
                                                   Editable=false;


    }
    field(12;"Modified in Destination";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Modificada en Destino';
                                                   Description='Si han modificado el registro en la empresa de destino';
                                                   Editable=false;


    }
    field(13;"Not in Master";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No existe en la empresa Master';
                                                   Description='QM 1.00.05 JAV 20/05/22';


    }
    field(20;"From Company";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa Origen';
                                                   Description='Empresas desde la que se ha creado el registro' ;


    }
}
  keys
{
    key(key1;"Table","RecordID","With Company")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Company@1100286000 :
      Company: Record 2000000006;
//       txtMD000@1100286004 :
      txtMD000: TextConst ESP='No existe la empresa %1';
//       txtMD001@1100286001 :
      txtMD001: TextConst ESP='No puede sincronizar en la empresa master.';
//       QMMasterDataManagement@1100286003 :
      QMMasterDataManagement: Codeunit 7174368;

    

trigger OnInsert();    begin
               SetCodesFromRId(Rec.RecordID);
             end;



// procedure ExistCompany (DataSyncronization@1100286000 :
procedure ExistCompany (DataSyncronization: Record 7174395) : Boolean;
    begin
      //Retorna si existe la empresa de destino en la base de datos
      if (DataSyncronization."With Company" <> '') then
        exit(QMMasterDataManagement.ExistCompany(DataSyncronization."With Company"))
      else
        exit(FALSE);
    end;

//     procedure ExistCodeInCompany (DataSyncronization@1100286001 :
    procedure ExistCodeInCompany (DataSyncronization: Record 7174395) : Boolean;
    var
//       rRef@1100286007 :
      rRef: RecordRef;
//       fRef@1100286008 :
      fRef: FieldRef;
//       Exist@1100286009 :
      Exist: Boolean;
//       nf@1100286000 :
      nf: Integer;
    begin
      //Retorna si existe el registro en la empresa de destino
      if (DataSyncronization."With Company" <> '') then
        exit(QMMasterDataManagement.ExistCodeInCompany(DataSyncronization.RecordID, DataSyncronization."With Company"))
      else
        exit(FALSE);
    end;

//     procedure SyncUp (pRecordID@1100286000 :
    procedure SyncUp (pRecordID: RecordID)
    begin
      //Sincroniza un registro de la master entre las empresas relacionadas
      QMMasterDataManagement.SyncUp(pRecordID, TRUE);
    end;

//     procedure UpdateFields (pRecordID@1100286001 :
    procedure UpdateFields (pRecordID: RecordID)
    begin
      //Actualizar los campos de la master en todas las empresas
      QMMasterDataManagement.UpdateFields(pRecordID, TRUE);
    end;

//     procedure SetCodesFromRId (pRecordID@1100286000 :
    procedure SetCodesFromRId (pRecordID: RecordID)
    var
//       TxtAux@1100286001 :
      TxtAux: Text;
//       i@1100286002 :
      i: Integer;
    begin
      TxtAux := FORMAT(RecordID);
      i := STRPOS(TxtAux,' ');
      if (i>0) then
        TxtAux := COPYSTR(TxtAux, i+1);

      Rec."Code 1" := TxtAux;
    end;

    /*begin
    end.
  */
}







