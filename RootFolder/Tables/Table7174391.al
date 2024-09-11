table 7174391 "QM MasterData Companies"
{
  
  
    DataPerCompany=false;
    CaptionML=ENU='MasterData Companies',ESP='MasterData Empresas';
  
  fields
{
    field(1;"Company";Text[50])
    {
        TableRelation="Company";
                                                   CaptionML=ENU='Name',ESP='Empresa';


    }
    field(10;"Master Data";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa Master';
                                                   Description='Marcamos la empresa que es master data';

trigger OnValidate();
    BEGIN 
                                                                //Si marcamos o quitamos esta empresa como la master
                                                                IF ("Master Data") THEN BEGIN 
                                                                  //Desmarcar si hay otras empresas marcadas
                                                                  QMMasterDataCompanies.RESET;
                                                                  QMMasterDataCompanies.SETFILTER(Company, '<>%1', Company);
                                                                  QMMasterDataCompanies.MODIFYALL("Master Data", FALSE);
                                                                  QMMasterDataCompanies.MODIFYALL("Is Not Master", TRUE);
                                                                END;

                                                                //Guardarla en la configuraci¢n, as¡ no la buscamos cada vez que la necesitamos
                                                                QMMasterDataConfiguration.GET;
                                                                QMMasterDataConfiguration.VALIDATE("Master Data Company", Company);
                                                                QMMasterDataConfiguration.MODIFY;

                                                                //Guardar el campo para ordenar
                                                                VALIDATE("Is Not Master");
                                                              END;


    }
    field(12;"Is Not Master";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   Description='QM 1.00.01 JAV 22/04/22: - Para uso interno, necesario solo para ordenar las empresas, al ser una clave no puede ser flowfield';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                //Guardar el campo para ordenar
                                                                "Is Not Master" := (NOT "Master Data");
                                                              END;


    }
    field(30;"Last Date Conf. Sync.";DateTime)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Ultima sincronziaci¢n config.';
                                                   Description='QM 1.00.02 - JAV 25/04/22: - [TT] Indica cuando fue la £ltima vez que se sincronizaron los datos de las tablas de configuraci¢n en esta empresa' ;


    }
}
  keys
{
    key(key1;"Company")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QMMasterDataConfiguration@1100286001 :
      QMMasterDataConfiguration: Record 7174390;
//       Txt01@1100286002 :
      Txt01: TextConst ESP='No pude sincronizar la empresa Master';
//       QMMasterDataCompanies@1100286000 :
      QMMasterDataCompanies: Record 7174391;
//       FunctionQB@1100286003 :
      FunctionQB: Codeunit 7207272;

    

trigger OnInsert();    begin
               VALIDATE("Is not Master");
             end;

trigger OnModify();    begin
               VALIDATE("Is not Master");
             end;



/*begin
    end.
  */
}







