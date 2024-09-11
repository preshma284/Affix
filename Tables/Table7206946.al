table 7206946 "QBU Confirming Lines"
{
  
  
    DataPerCompany=false;
  
  fields
{
    field(1;"Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo';


    }
    field(10;"Description";Text[50])
    {
        DataClassification=ToBeClassified;


    }
    field(20;"Amount Limit";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡mite del confirming';


    }
    field(21;"Amount Disposed";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Dispuesto';
                                                   Editable=false;


    }
    field(30;"Total Limit";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Confirming Lines"."Amount Limit");


    }
    field(31;"Total Disposed";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Confirming Lines"."Amount Disposed") ;


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







