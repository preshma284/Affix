table 7206950 "QB Factoring Customer"
{
  
  
    DataPerCompany=false;
  
  fields
{
    field(1;"Factoring Line";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡nea de Factoring';


    }
    field(2;"VAT Registration No.";Text[20])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Registration No.',ESP='CIF/NIF';

trigger OnValidate();
    BEGIN 
                                                                "VAT Registration No." := UPPERCASE("VAT Registration No.");
                                                              END;


    }
    field(3;"Company";Text[50])
    {
        TableRelation="Company";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa';


    }
    field(4;"Customer Account";Code[20])
    {
        TableRelation="Customer";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cliente';

trigger OnValidate();
    VAR
//                                                                 Customer@1100286000 :
                                                                Customer: Record 18;
//                                                                 QBFactoringCustomer@1100286001 :
                                                                QBFactoringCustomer: Record 7206950;
                                                              BEGIN 
                                                                Customer.CHANGECOMPANY(Company);
                                                                IF (Customer.GET("Customer Account")) THEN BEGIN 
                                                                  Name := Customer.Name;
                                                                  "VAT Registration No." := Customer."VAT Registration No.";

                                                                  IF ("VAT Registration No." <> '') AND (NOT QBFactoringCustomer.GET("Factoring Line", "VAT Registration No.", '', '')) THEN BEGIN 
                                                                    QBFactoringCustomer.INIT;
                                                                    QBFactoringCustomer."Factoring Line" := "Factoring Line";
                                                                    QBFactoringCustomer."VAT Registration No." := "VAT Registration No.";
                                                                    QBFactoringCustomer.Name := Customer.Name;
                                                                    QBFactoringCustomer.INSERT;
                                                                  END;
                                                                END;
                                                              END;


    }
    field(10;"Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Nombre';


    }
    field(11;"Active";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Activo';


    }
    field(20;"Amount Limit";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡mite del Factoring';


    }
    field(21;"Amount Disposed";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Dispuesto';


    }
}
  keys
{
}
  fieldgroups
{
}
  
    var
//       QBFactoringCustomer1@1100286001 :
      QBFactoringCustomer1: Record 7206950;
//       QBFactoringCustomer2@1100286000 :
      QBFactoringCustomer2: Record 7206950;

    procedure SetAmountUsed ()
    var
//       PostedCarteraDoc@1100286000 :
      PostedCarteraDoc: Record 7000003;
    begin
      PostedCarteraDoc.RESET;
      PostedCarteraDoc.CHANGECOMPANY(Company);
      PostedCarteraDoc.SETCURRENTKEY("Factoring Line","Account No.");
      PostedCarteraDoc.SETRANGE("Factoring Line", "Factoring Line");
      PostedCarteraDoc.SETRANGE("Account No.", Company);
      PostedCarteraDoc.CALCSUMS("Remaining Amount");
      "Amount Disposed" := PostedCarteraDoc."Remaining Amount";
      MODIFY;

      QBFactoringCustomer1.RESET;
      QBFactoringCustomer1.SETRANGE("Factoring Line", "Factoring Line");
      QBFactoringCustomer1.SETRANGE("VAT Registration No.", "VAT Registration No.");
      QBFactoringCustomer1.SETFILTER(Company,'<>%1','');
      QBFactoringCustomer1.SETFILTER("Customer Account",'<>%1','');
      QBFactoringCustomer1.CALCSUMS("Amount Disposed");

      if QBFactoringCustomer2.GET("Factoring Line", "VAT Registration No.", '', '') then begin
        QBFactoringCustomer2."Amount Disposed" := QBFactoringCustomer1."Amount Disposed";
        QBFactoringCustomer2.MODIFY;
      end;
    end;

    /*begin
    end.
  */
}







