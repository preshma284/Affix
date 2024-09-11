table 7207331 "QBU Invoice Milestone"
{
  
  
    CaptionML=ENU='Invoice Milestone',ESP='Hitos de Facturaci¢n';
    LookupPageID="Invoice Milestone List";
    DrillDownPageID="Invoice Milestone List";
  
  fields
{
    field(1;"Milestone No.";Code[10])
    {
        CaptionML=ENU='Milestone No.',ESP='N§ de hito';


    }
    field(2;"Customer Code";Code[20])
    {
        TableRelation="Customer";
                                                   

                                                   CaptionML=ENU='Customer Code',ESP='C¢d. Cliente';

trigger OnValidate();
    BEGIN 
                                                                IF Customer.GET("Customer Code") THEN BEGIN 
                                                                  "Currency Code" := Customer."Currency Code";
                                                                  IF Amount <> 0 THEN
                                                                    VALIDATE("Currency Code","Currency Code");
                                                                END;
                                                              END;


    }
    field(3;"Currency Code";Code[20])
    {
        TableRelation="Currency";
                                                   

                                                   CaptionML=ENU='Currency Code',ESP='C¢d. divisa';

trigger OnValidate();
    BEGIN 
                                                                Currency.InitRoundingPrecision;
                                                                IF "Currency Code" <> '' THEN
                                                                  "Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrencyExchangeRate.ExchangeAmtFCYToLCY("Estimated Date","Currency Code",Amount,
                                                                       CurrencyExchangeRate.ExchangeRate("Estimated Date","Currency Code")),Currency."Amount Rounding Precision")
                                                                ELSE
                                                                  "Amount (LCY)" := ROUND(Amount,Currency."Amount Rounding Precision");
                                                              END;


    }
    field(4;"Estimated Date";Date)
    {
        CaptionML=ENU='Estimated Date',ESP='Fecha estimada';


    }
    field(5;"Amount";Decimal)
    {
        

                                                   CaptionML=ENU='Amount',ESP='Importe';

trigger OnValidate();
    BEGIN 
                                                                Currency.InitRoundingPrecision;
                                                                IF "Currency Code" <> '' THEN
                                                                  "Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrencyExchangeRate.ExchangeAmtFCYToLCY("Estimated Date","Currency Code",Amount,
                                                                       CurrencyExchangeRate.ExchangeRate("Estimated Date","Currency Code")),Currency."Amount Rounding Precision")
                                                                ELSE
                                                                  "Amount (LCY)" := ROUND(Amount,Currency."Amount Rounding Precision");
                                                              END;


    }
    field(6;"Amount (LCY)";Decimal)
    {
        CaptionML=ENU='Amount (LCY)',ESP='Importe (DL)';


    }
    field(7;"Draft Invoice No.";Code[20])
    {
        TableRelation="Sales Header"."No." WHERE ("No."=FIELD("Draft Invoice No."),
                                                                                           "Document Type"=CONST("Invoice"));
                                                   CaptionML=ENU='Draft Invoice No.',ESP='N§ borrador factura';


    }
    field(8;"Posted Invoice No.";Code[20])
    {
        TableRelation="Sales Invoice Header"."No." WHERE ("No."=FIELD("Posted Invoice No."));
                                                   CaptionML=ENU='Posted Invoice No.',ESP='N§ factura registrada';


    }
    field(9;"Completion Date";Date)
    {
        CaptionML=ENU='Completion Date',ESP='Fecha cumplimentaci¢n';


    }
    field(10;"Comments";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Invoice Milestone Comments"."Comment" WHERE ("Type"=CONST("Hito"),
                                                                                                                  "Job No."=FIELD("Job No."),
                                                                                                                  "Milestone No."=FIELD("Milestone No.")));
                                                   CaptionML=ENU='Comments',ESP='Comentarios';
                                                   Editable=false;


    }
    field(11;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(20;"Payment Terms Code";Code[10])
    {
        TableRelation="Payment Terms";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Terms Code',ESP='C¢d. t‚rminos pago';


    }
    field(21;"Payment Method Code";Code[10])
    {
        TableRelation="Payment Method";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Method Code',ESP='C¢d. forma pago'; ;

trigger OnValidate();
    VAR
//                                                                 PaymentMethod@1000 :
                                                                PaymentMethod: Record 289;
                                                              BEGIN 
                                                              END;


    }
}
  keys
{
    key(key1;"Job No.","Milestone No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Customer@7001100 :
      Customer: Record 18;
//       Currency@7001101 :
      Currency: Record 4;
//       CurrencyExchangeRate@7001102 :
      CurrencyExchangeRate: Record 330;

    /*begin
    end.
  */
}







