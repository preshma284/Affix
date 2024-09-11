page 7207524 "QB Location Assistant Loc."
{
CaptionML=ESP='Almacenes';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=14;
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Code";rec."Code")
    {
        
                Editable=false ;
    }
    field("Name";rec."Name")
    {
        
    }
    field("QB Departament Code";rec."QB Departament Code")
    {
        
    }
    field("QB Job Location";rec."QB Job Location")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       CLEARALL;
                     END;




    /*begin
    end.
  
*/
}







