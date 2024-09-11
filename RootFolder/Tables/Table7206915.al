table 7206915 "TAux General Categories"
{
  
  
    CaptionML=ENU='General Categories',ESP='Categorias Generales';
    LookupPageID="TAux General Categories List";
    DrillDownPageID="TAux General Categories List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[100])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Use In";Option)
    {
        OptionMembers="All","Customers","Vendors","Contacts";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Usar Para';
                                                   OptionCaptionML=ENU='All,Customers,Vendors,Contacts',ESP='Todos,Clientes,Proveedores,Contactos';
                                                   


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    end.
  */
}







