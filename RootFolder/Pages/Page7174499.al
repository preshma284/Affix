page 7174499 "QuoFacturae Entry FactBox"
{
InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7174369;
    SourceTableView=SORTING("Entry no.")
                    ORDER(Descending);
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Datetime";rec."Datetime")
    {
        
                StyleExpr=color ;
    }
    field("Status";rec."Status")
    {
        
                StyleExpr=color ;
    }
    field("Description";rec."Description")
    {
        
                StyleExpr=color ;
    }
    field("Codigo Anulacion";rec."Codigo Anulacion")
    {
        
                StyleExpr=color ;
    }
    field("Estado Anulacion";rec."Estado Anulacion")
    {
        
                StyleExpr=color ;
    }
    field("Motivo Anulacion";rec."Motivo Anulacion")
    {
        
                StyleExpr=color ;
    }
    field("Codigo Tramitacion";rec."Codigo Tramitacion")
    {
        
                StyleExpr=color ;
    }
    field("Estado Tramitacion";rec."Estado Tramitacion")
    {
        
                StyleExpr=color ;
    }
    field("XMLe";rec."viewXML")
    {
        
                CaptionML=ENU='Session Id',ESP='XML';
                
                          

  ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           rec.GetXMLSend;
                         END;


    }

}

}
}
  

trigger OnAfterGetRecord()    BEGIN
                       SetColores;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetColores;
                         END;



    var
      Color : Text;
      ToFile : Text;
      txt : Text;
      xmlFile : File;
      QuoFacturaeSession : Record 7174372;
      TempBlob : Codeunit "Temp Blob";
      txtXML : Text;

    

LOCAL procedure SetColores();
    begin
      Color := 'Standar';
      if (rec.Status = rec.Status::Posted) then
        Color := 'Favorable';
      if (rec.Status = rec.Status::Error) then
        Color := 'Unfavorable';
    end;

    // begin//end
}








