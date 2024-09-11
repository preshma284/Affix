page 7174391 "QM MasterData Setup Companyes"
{
  ApplicationArea=All;

CaptionML=ENU='Related Companies',ESP='Master Data Empresas';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7174391;
    PageType=Card;
    
  layout
{
area(content)
{
group("group17")
{
        
                CaptionML=ESP='Empresas';
repeater("By_Company")
{
        
    field("Company";rec."Company")
    {
        
                Editable=FALSE;
                Style=Strong;
                StyleExpr=IsMaster ;
    }
    field("TB_Master Data";rec."Master Data")
    {
        
    }
    field("IsQuoBuilding";"IsQuoBuilding")
    {
        
                CaptionML=ENU='QuoBuilding Company',ESP='Empresa QuoBuilding';
                Enabled=false 

  ;
    }

}

}

}
}
  trigger OnOpenPage()    BEGIN
                 //Leer la configuraci�n, si no existe la creo
                 IF NOT QMMasterDataConfiguration.GET THEN BEGIN
                   QMMasterDataConfiguration.INIT;
                   QMMasterDataConfiguration.INSERT;
                 END;

                 //Eliminamos de la lista las empresas que ya no existan
                 Rec.RESET;
                 IF (Rec.FINDSET) THEN
                   REPEAT
                     IF NOT recCompany.GET(Rec.Company) THEN
                       Rec.DELETE;
                   UNTIL Rec.NEXT = 0;

                 //A�adimos las empresas que no existan en la tabla
                 recCompany.RESET;
                 IF recCompany.FINDSET(FALSE) THEN
                   REPEAT
                     IF NOT Rec.GET(recCompany.Name) THEN BEGIN
                       Rec.INIT;
                       Rec.VALIDATE(Company, recCompany.Name);
                       Rec.INSERT;
                     END;
                     Rec.MODIFY;
                   UNTIL (recCompany.NEXT = 0);

                 //JAV 28/04/22: - QM 1.00.04 Crear los datos de la tabla de dimensiones
                 QMMasterDataTable.InsertDefaultDimension;

                 Rec.RESET;
                 IF NOT Rec.FINDFIRST THEN;
               END;

trigger OnAfterGetRecord()    BEGIN
                       IsMaster := rec."Master Data";
                       IsQuoBuilding := FunctionQB.IsQuoBuildingCompany(rec.Company);
                     END;



    var
      QMMasterDataConfiguration : Record 7174390;
      QMMasterDataTable : Record 7174392;
      recCompany : Record 2000000006;
      FunctionQB : Codeunit 7207272;
      IsMaster : Boolean;
      IsQuoBuilding : Boolean;/*

    begin
    {
      JAV 28/04/22: - QM 1.00.04 Crear los datos de la tabla de dimensiones
    }
    end.*/
  

}









