table 7206955 "QBU Expenses Type"
{
  
  
    CaptionML=ENU='Expenses Type',ESP='Tipo de gasto';
    LookupPageID="QB Expenses Type List";
    DrillDownPageID="QB Expenses Type List";
  
  fields
{
    field(1;"No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No.',ESP='N§';


    }
    field(2;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Account No.";Code[20])
    {
        TableRelation="G/L Account"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Account No.',ESP='N§ de cuenta'; ;


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
    end.
  */
}







