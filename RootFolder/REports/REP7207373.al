report 7207373 "Load Vend. Cert. Template"
{
  
  
    CaptionML=ENU='Load Vendor Cert. Template',ESP='Cargar Plantilla certificados del proveedor';
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
group("group658")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("Template";"Template")
    {
        
                  CaptionML=ENU='Template',ESP='Plantilla';
                  TableRelation="Vendor Certificates Templates" 

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
//       Template@1100286000 :
      Template: Code[10];
//       Vendor@1100286003 :
      Vendor: Code[20];
//       VendorCertificates@1100286002 :
      VendorCertificates: Record 7207419;
//       VendorCertificatesTemplates@1100286001 :
      VendorCertificatesTemplates: Record 7207428;

    

trigger OnPreReport();    begin
                  VendorCertificatesTemplates.RESET;
                  VendorCertificatesTemplates.SETRANGE(Template, Template);
                  if VendorCertificatesTemplates.FINDSET(FALSE) then
                    repeat
                      //Busco si ya est  el certificado
                      VendorCertificates.RESET;
                      VendorCertificates.SETRANGE("Vendor No.", Vendor);
                      if (VendorCertificatesTemplates."Activity Code" <> '') then
                        VendorCertificates.SETRANGE("Activity Code", VendorCertificatesTemplates."Activity Code");
                      if (VendorCertificatesTemplates."Certificate Code" <> '') then
                        VendorCertificates.SETRANGE("Certificate Code", VendorCertificatesTemplates."Certificate Code");
                      if VendorCertificates.ISEMPTY then begin
                        //Si no lo encuentro, lo creo
                        VendorCertificates.INIT;
                        VendorCertificates."Vendor No." := Vendor;
                        VendorCertificates."Activity Code" := VendorCertificatesTemplates."Activity Code";
                        VendorCertificates."Certificate Code" := VendorCertificatesTemplates."Certificate Code";
                        VendorCertificates.Required := VendorCertificatesTemplates.Required;
                        VendorCertificates.INSERT(TRUE);
                      end;
                    until VendorCertificatesTemplates.NEXT = 0;
                end;



// procedure SetVendor (pVendor@1100286000 :
procedure SetVendor (pVendor: Code[20])
    begin
      Vendor := pVendor;
    end;

    /*begin
    end.
  */
  
}



