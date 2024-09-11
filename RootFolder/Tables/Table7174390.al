table 7174390 "QM MasterData Setup"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='MasterData Setup',ESP='MasterData Configuraci¢n';
  
  fields
{
    field(1;"Primary Key";Code[10])
    {
        CaptionML=ENU='Primary Key',ESP='Clave principal';
                                                   Editable=false;


    }
    field(10;"Synchronize between companies";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Sincronizar entre empresas';
                                                   Description='GENERAL. MD 1.00.02 - JAV 09/09/20: - [TT] Si est  activa la sincronizaci¢n de datos de ciertas tablas entre empresas';

trigger OnValidate();
    VAR
//                                                                 QMMasterDataCompanies@1100286000 :
                                                                QMMasterDataCompanies: Record 7174391;
                                                              BEGIN 
                                                              END;


    }
    field(11;"Master Data Company";Text[50])
    {
        TableRelation="Company";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa Master Data';
                                                   Description='GENERAL. MD 1.00.02 - JAV 09/09/20: - [TT] Nombre de la empresa que ser  la Master Data del sistema de sincronizaci¢n';
                                                   Editable=false;


    }
    field(12;"Manual Active";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Sincronizaci¢n Manual Activa';
                                                   Description='JAV 22/04/22: - Si se permite la sincronizaci¢n manual';


    }
    field(13;"TimeOut";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Max. TimeOut (secs)',ESP='M ximo tiempo de espera (seg)';
                                                   Description='QM 1.00.06 JAV 14/09/22. [TT] M ximo tiempo de espera en los procesos de borrado en varias empresas hasta dar el error por TimeOut (en segundos)' ;


    }
}
  keys
{
    key(key1;"Primary Key")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QMMasterDataCompanies@1100286000 :
      QMMasterDataCompanies: Record 7174391;
//       Txt001@1100286001 :
      Txt001: TextConst ESP='No ha marcado la empresa Master';

    /*begin
    end.
  */
}







