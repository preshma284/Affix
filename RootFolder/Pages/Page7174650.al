page 7174650 "DragDrop SP Setup"
{
  ApplicationArea=All;

CaptionML=ENU='DragDrop SP Setup',ESP='Config. Arrastrar y soltar Sharepoint';
    SourceTable=7174650;
    PageType=Card;
    
  layout
{
area(content)
{
group("General")
{
        
    field("Enable Integration";rec."Enable Integration")
    {
        
    }
    field("Batch Synchronization";rec."Batch Synchronization")
    {
        
    }
    field("User";rec."User")
    {
        
    }
    field("Pass";rec."Pass")
    {
        
                ExtendedDatatype=Masked;
    }
    field("Url Sharepoint";rec."Url Sharepoint")
    {
        
    }
    field("Debug Level";rec."Debug Level")
    {
        
    }
    field("Def. Sharepoint Nos.";rec."Def. Sharepoint Nos.")
    {
        
    }
    field("Library Name Default";rec."Library Name Default")
    {
        
    }
    field("Serie No. Internal Name";rec."Serie No. Internal Name")
    {
        
    }
    field("Master Setup Company";rec."Master Setup Company")
    {
        
                
                            

  ;trigger OnValidate()    VAR
                             Company : Record 2000000006;
                             DDSetup : Record 7174650;
                             DDSetupOriginal : Record 7174650;
                             SiteDef : Record 7174651;
                             SiteDefOriginal : Record 7174651;
                             SiteDefMetadadta : Record 7174652;
                             SiteDefMetadadtaOriginal : Record 7174652;
                           BEGIN
                             IF rec."Master Setup Company" THEN BEGIN

                               IF NOT CONFIRM('Se va a copiar la configuraci¢n de Sharepoint, as¡ como la de los sitios al resto de empresas. Est  seguro?') THEN
                                 EXIT;


                               Company.RESET;
                               Company.SETFILTER(Name, '<>%1', COMPANYNAME);
                               IF Company.FINDSET AND (COPYSTR(Company.Name, 1, 1) <> 'Z') THEN REPEAT
                                 DDSetup.RESET;
                                 DDSetup.CHANGECOMPANY(Company.Name);
                                 IF DDSetup.GET THEN BEGIN
                                   IF DDSetup."Master Setup Company" THEN
                                     ERROR(MasterCompanyExists, Company.Name);
                                 END;

                                 DDSetup.DELETEALL;

                                 MESSAGE('Procesando ' + Company.Name);

                                 DDSetupOriginal.GET;
                                 DDSetup.INIT;
                                 DDSetup.TRANSFERFIELDS(DDSetupOriginal);
                                 DDSetup."Master Setup Company" := FALSE;
                                 DDSetup.INSERT;

                                 SiteDef.RESET;
                                 SiteDef.CHANGECOMPANY(Company.Name);
                                 SiteDef.DELETEALL;
                                 IF SiteDefOriginal.FINDSET THEN REPEAT
                                   SiteDef.TRANSFERFIELDS(SiteDefOriginal);
                                   SiteDef.INSERT;

                                   SiteDefMetadadta.RESET;
                                   SiteDefMetadadta.CHANGECOMPANY(Company.Name);
                                   SiteDefMetadadta.DELETEALL;
                                   SiteDefMetadadtaOriginal.RESET;
                                   IF SiteDefMetadadtaOriginal.FINDSET THEN REPEAT
                                     SiteDefMetadadta.TRANSFERFIELDS(SiteDefMetadadtaOriginal);
                                     SiteDefMetadadta.INSERT;
                                   UNTIL SiteDefMetadadtaOriginal.NEXT = 0;
                                 UNTIL SiteDefOriginal.NEXT = 0;
                               UNTIL Company.NEXT = 0;
                             END;
                           END;


    }

}

}
}
  
trigger OnOpenPage()    BEGIN
                 Rec.RESET;
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;
               END;



    var
      MasterCompanyExists : TextConst ESP='Ya existe una configuraci¢n maestra en la empresa %1, desactive la configuraci¢n maestra en la empresa %1 antes de activarla en esta';/*

    

begin
    {
      QUONEXT 20.07.17. DRAG&DROP. Configuraci¢n de los datos b sicos del proceso.
    }
    end.*/
  

}









