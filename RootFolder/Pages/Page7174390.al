page 7174390 "QM MasterData Setup"
{
  ApplicationArea=All;

CaptionML=ENU='Master Data Setup',ESP='Master Data Configuraci¢n';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7174390;
    PageType=Card;
    
  layout
{
area(content)
{
group("group12")
{
        
                CaptionML=ESP='Configuraci¢n';
    field("Synchronize between companies";rec."Synchronize between companies")
    {
        
    }
    field("Master Data Company";rec."Master Data Company")
    {
        
    }
    field("TimeOut";rec."TimeOut")
    {
        
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 //Leer la configuraci¢n, si no existe la creo
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;
               END;




    /*begin
    end.
  
*/
}









