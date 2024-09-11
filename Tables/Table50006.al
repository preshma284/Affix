table 50006 "QBU N43 Conceptos Interbancarios"
{
  
  
  ;
  fields
{
    field(1;"Codigo";Code[2])
    {
        Description='REQ-05';


    }
    field(2;"Descripcion";Text[60])
    {
        Description='REQ-05' ;


    }
}
  keys
{
    key(key1;"Codigo")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV 15/09/20: - QB 1.06.14 Nuevo fichoer para la conciliaci¢n bancaria con norma 43
    }
    end.
  */
}







