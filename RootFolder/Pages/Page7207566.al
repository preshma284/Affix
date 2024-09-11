page 7207566 "Vendor Certificates Templ. Lis"
{
CaptionML=ENU='Vendor Certificates Templ. Lis',ESP='Lista de Plantillas de certificados del proveedor';
    SourceTable=7207428;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Template";rec."Template")
    {
        
    }
    field("Template Line No.";rec."Template Line No.")
    {
        
                Visible=False ;
    }
    field("Required";rec."Required")
    {
        
    }
    field("Certificate Code";rec."Certificate Code")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             GetType;
                           END;


    }
    field("VendorCertificatesTypes.Description";VendorCertificatesTypes.Description)
    {
        
                CaptionML=ESP='Descripci¢n certificado';
                Editable=false ;
    }
    field("VendorCertificatesTypes.Type of Certificate";VendorCertificatesTypes."Type of Certificate")
    {
        
                CaptionML=ENU='Type Certificate',ESP='Tipo certificado';
                Editable=false ;
    }
    field("Activity Code";rec."Activity Code")
    {
        
    }
    field("Activity Description";rec."Activity Description")
    {
        
    }

}

}
}
  

trigger OnAfterGetRecord()    BEGIN
                       GetType;
                     END;



    var
      VendorCertificatesTypes : Record 7207427;

    LOCAL procedure GetType();
    begin
      if not VendorCertificatesTypes.GET(rec."Certificate Code") then
        VendorCertificatesTypes.INIT;
    end;

    // begin//end
}







