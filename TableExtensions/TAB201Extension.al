tableextension 50150 "QBU Resource PriceExt" extends "Resource Price"
{
  
  
    CaptionML=ENU='Resource Price',ESP='Precio venta recurso';
    LookupPageID="Resource Prices";
    DrillDownPageID="Resource Prices";
  
  fields
{
    field(7207270;"QBU Job No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ proyecto';
                                                   Description='QB 1.00' ;


    }
}
  keys
{
    //key(Extkey1;"Type","Code","Work Type Code","Currency Code","Job No.")
   // {
        /*  Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='cannot be specified when %1 is %2',ESP='No se puede indicar cuando %1 es %2.';

    /*begin
    end.
  */
}





