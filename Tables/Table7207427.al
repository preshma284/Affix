table 7207427 "QBU Vendor Certificates Types"
{
  
  
    CaptionML=ENU='Vendor Certificates Types',ESP='Tipos de Certificados de proveedor';
    LookupPageID="Vendor Certificates Types List";
    DrillDownPageID="Vendor Certificates Types List";
  
  fields
{
    field(1;"No.";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No.',ESP='C¢digo';


    }
    field(2;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Type of Certificate";Option)
    {
        OptionMembers="Quality","Item Quality","Current Payment","Other";CaptionML=ENU='Type Certificate',ESP='Tipo de certificado';
                                                   OptionCaptionML=ENU='Quality,Item Quality,Current Payment,Other',ESP='Calidad,Calidad Producto,Corriente de Pago,Otros';
                                                   


    }
}
  keys
{
    key(key1;"No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      GAP019
      JAV 04/11/2019: - Se pasa al vertical
                      - Se cambian las opciones del tipo de certificado
    }
    end.
  */
}







