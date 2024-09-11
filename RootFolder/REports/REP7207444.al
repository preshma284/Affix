report 7207444 "QB Generic Export"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='QB Generic Export',ESP='QB Exportaci¢n gen‚rica';
    ProcessingOnly=true;
    
  dataset
{

}
  requestpage
  {

    layout
{
area(content)
{
group("group934")
{
        
                  CaptionML=ENU='Option',ESP='Opciones';
    field("ExportCode";"ExportCode")
    {
        
                  CaptionML=ESP='Definici¢n de la Exportaci¢n';
                  TableRelation="QB Generic Import Header" 

    ;
    }

}

}
}
  }
  labels
{
}
  
    var
//       QBGenericImportHeader@1100286001 :
      QBGenericImportHeader: Record 7206940;
//       QBImportExport@1100286008 :
      QBImportExport: Codeunit 7206924;
//       ExportCode@1100286000 :
      ExportCode: Code[20];

    

trigger OnPreReport();    begin
                  QBImportExport.Export(ExportCode);
                end;



/*begin
    end.
  */
  
}




