table 7174388 "QM Session Table Data"
{
  
  
    DataPerCompany=false;
  
  fields
{
    field(2;"IDSesion";Integer)
    {
        DataClassification=ToBeClassified;
                                                   Description='Key 1: ID de la sesi¢n';


    }
    field(10;"OriginCompany";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   Description='Empresa de Origen';


    }
    field(11;"OriginSesion";Integer)
    {
        DataClassification=ToBeClassified;
                                                   Description='Sesi¢n desde la que se lanza';


    }
    field(12;"DestinationCompany";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   Description='Empresa de destino';


    }
    field(20;"Table";Integer)
    {
        DataClassification=ToBeClassified;


    }
    field(21;"RecID";RecordID)
    {
        DataClassification=ToBeClassified;


    }
    field(22;"Operation";Option)
    {
        OptionMembers="Ins","Mod","Del","Ren";DataClassification=ToBeClassified;
                                                   


    }
    field(23;"Process";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='Si se ejecuta el proceso o solo es la fase de prueba';


    }
    field(30;"ResultOk";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='Indica que la sesi¢n ha terminado sin errores' ;


    }
}
  keys
{
    key(key1;"IDSesion")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    procedure TxtNoError () : Text;
    begin
      exit('No Error');
    end;

    /*begin
    //{
//      JAV 12/02/22: - QB 1.00.06 Se reordenan los campos
//    }
    end.
  */
}







