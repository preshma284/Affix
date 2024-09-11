page 7174500 "Quofacturae endpoints"
{
CaptionML=ENU='Quofacturae endpoints',ESP='Puntos de entrada de Quofacturae';
    SourceTable=7174373;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
    }
    field("URL";rec."URL")
    {
        
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
  trigger OnOpenPage()    BEGIN
                 CreateOne('FACE-PRUEBAS', 'https://se-face-webservice.redsara.es/facturasspp?wsdl');
                 CreateOne('FACE', 'https://webservice.face.gob.es/facturasspp?wsdl');
                 CreateOne('PUEF', 'https://juntadeandalucia.e-factura.net/puef/services/SSPPWebServiceProxyService.wsdl');
                 CreateOne('OSAKIDETZA', 'https://posb.osakidetza.net/osakidetza/negocio/gestion/ecofin/ServiciosPortal_v1/ServiciosPortalWS?wsd');
               END;




    LOCAL procedure CreateOne(pCod : Text;pURL : Text);
    var
      QuoFacturaeendpoint : Record 7174373;
    begin
      if not QuoFacturaeendpoint.GET(pCod) then begin
        QuoFacturaeendpoint.INIT;
        QuoFacturaeendpoint.Code:= pCod;
        QuoFacturaeendpoint.URL := pURL;
        QuoFacturaeendpoint.INSERT;
      end;
    end;

    // begin//end
}








