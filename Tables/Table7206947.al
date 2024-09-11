table 7206947 "QBU Confirming Bank Accounts"
{
  
  
    DataPerCompany=false;
  
  fields
{
    field(1;"Confirming Line";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡nea de Confirming';


    }
    field(2;"Company";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa';


    }
    field(3;"Bank Account";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cuenta';


    }
    field(10;"Description";Text[50])
    {
        DataClassification=ToBeClassified;


    }
    field(11;"Active";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Activo';


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


    }
}
  keys
{
    key(key1;"Confirming Line","Company","Bank Account")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    procedure SetAmountUsed ()
    var
//       PostedCarteraDoc@1100286000 :
      PostedCarteraDoc: Record 7000003;
    begin
      PostedCarteraDoc.RESET;
      PostedCarteraDoc.CHANGECOMPANY(Company);
      PostedCarteraDoc.SETCURRENTKEY("Confirming Line");
      PostedCarteraDoc.SETRANGE("Bank Account No.", "Bank Account");
      PostedCarteraDoc.SETRANGE("Confirming Line", "Confirming Line");
      PostedCarteraDoc.CALCSUMS("Remaining Amount");
      "Amount Disposed" := PostedCarteraDoc."Remaining Amount";
      MODIFY;
    end;

    /*begin
    end.
  */
}







