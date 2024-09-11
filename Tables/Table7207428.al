table 7207428 "QBU Vendor Certificates Templates"
{
  
  
    CaptionML=ENU='Vendor Certificates Templates',ESP='Plantillas de Certificados de Proveedor';
    LookupPageID="Vendor Certificates Templ. Lis";
    DrillDownPageID="Vendor Certificates Templ. Lis";
  
  fields
{
    field(1;"Template";Code[10])
    {
        CaptionML=ENU='Vendor No.',ESP='Plantilla';


    }
    field(2;"Template Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ L¡nea';
                                                   Editable=false;


    }
    field(10;"Activity Code";Code[20])
    {
        TableRelation="Activity QB";
                                                   CaptionML=ENU='Activity Code',ESP='C¢d. actividad';


    }
    field(11;"Activity Description";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Activity QB"."Description" WHERE ("Activity Code"=FIELD("Activity Code")));
                                                   CaptionML=ESP='Descripci¢n Actividad';
                                                   Editable=false;


    }
    field(12;"Certificate Code";Code[10])
    {
        TableRelation="Vendor Certificates Types";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certificate',ESP='Cod.Certificado';


    }
    field(14;"Required";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Obligatorio';


    }
}
  keys
{
    key(key1;"Template","Template Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
    fieldgroup(DropDown;"Template","Certificate Code","Required","Activity Code")
    {
        
    }
}
  
    var
//       VendorCertificatesTemplates@1100286000 :
      VendorCertificatesTemplates: Record 7207428;

    

trigger OnInsert();    begin
               VendorCertificatesTemplates.RESET;
               VendorCertificatesTemplates.SETRANGE(Template, Template);
               if (VendorCertificatesTemplates.FINDLAST) then
                 "Template Line No." := VendorCertificatesTemplates."Template Line No." + 1
               else
                 "Template Line No." := 1;
             end;



/*begin
    {
      JAV 06/11/19: - Nueva tabla de plantillas de certificados del proveedor
    }
    end.
  */
}







