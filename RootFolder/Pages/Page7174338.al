page 7174338 "SII Error"
{
CaptionML=ENU='Answers Log',ESP='Hist¢rico de respuestas';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7174332;
    SourceTableView=SORTING("HoraEnvio")
                    ORDER(Descending);
    PageType=ListPart;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Document No.";rec."Document No.")
    {
        
    }
    field("AEAT Status";rec."AEAT Status")
    {
        
    }
    field("Error Desc";rec."Error Desc")
    {
        
    }
    field("HoraEnvio";rec."HoraEnvio")
    {
        
    }
    field("Tipo Entorno";rec."Tipo Entorno")
    {
        
    }

}

}
}
  

    /*begin
    end.
  
*/
}








