page 7174497 "QuoFacturae entries"
{
  ApplicationArea=All;

CaptionML=ENU='Factura-e entries',ESP='Movimientos de factura-e';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7174369;
    SourceTableView=SORTING("Entry no.")
                    ORDER(Descending);
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry no.";rec."Entry no.")
    {
        
    }
    field("Document type";rec."Document type")
    {
        
    }
    field("Document no.";rec."Document no.")
    {
        
    }
    field("Datetime";rec."Datetime")
    {
        
    }
    field("Status";rec."Status")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Codigo Anulacion";rec."Codigo Anulacion")
    {
        
    }
    field("Estado Anulacion";rec."Estado Anulacion")
    {
        
    }
    field("Motivo Anulacion";rec."Motivo Anulacion")
    {
        
    }
    field("Codigo Tramitacion";rec."Codigo Tramitacion")
    {
        
    }
    field("Estado Tramitacion";rec."Estado Tramitacion")
    {
        
    }
    field("Motivo Tramitacion";rec."Motivo Tramitacion")
    {
        
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
area(FactBoxes)
{
    systempart(Notes;Notes)
    {
        ;
    }
    systempart(Links;Links)
    {
        ;
    }

}
}
  

    

/*begin
    end.
  
*/
}









