page 7174333 "SII Document Ship List"
{
  ApplicationArea=All;

CaptionML=ENU='SII Document Ship List',ESP='Lista de Env¡os SII';
    ModifyAllowed=false;
    SourceTable=7174335;
    PageType=List;
    CardPageID="SII Document Ship Card";
    RefreshOnActivate=true;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Ship No.";rec."Ship No.")
    {
        
    }
    field("Shipment DateTime";rec."Shipment DateTime")
    {
        
    }
    field("Shipment Status";rec."Shipment Status")
    {
        
    }
    field("Shipment Type Name";rec."Shipment Type Name")
    {
        
    }
    field("AEAT Status";rec."AEAT Status")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
    }
    field("Tipo Entorno";rec."Tipo Entorno")
    {
        
    }
    field("SII Entity";rec."SII Entity")
    {
        
    }

}

}
}
  /*

    begin
    {
      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
    }
    end.*/
  

}









