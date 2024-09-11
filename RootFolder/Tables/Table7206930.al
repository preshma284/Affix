table 7206930 "QB Payments Phases Lines"
{
  
  
    CaptionML=ENU='Payments Phases Lines',ESP='L¡neas de las Fases de Pago';
  
  fields
{
    field(1;"Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo';


    }
    field(4;"Line No.";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ L¡nea';

trigger OnValidate();
    BEGIN 
                                                                IF ("Line No." = 0) THEN BEGIN 
                                                                  QBPaymentsPhasesLines.RESET;
                                                                  QBPaymentsPhasesLines.SETRANGE(Code, Code);
                                                                  IF (QBPaymentsPhasesLines.FINDLAST) THEN
                                                                    "Line No." := QBPaymentsPhasesLines."Line No." + 1
                                                                  ELSE
                                                                    "Line No." := 1;
                                                                END;
                                                              END;


    }
    field(10;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n';


    }
    field(11;"% Payment";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Pago';


    }
    field(12;"Total %";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Payments Phases Lines"."% Payment" WHERE ("Code"=FIELD("Code")));
                                                   CaptionML=ESP='Total % Pago';
                                                   Editable=false;


    }
    field(14;"Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe';


    }
    field(15;"Total Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("QB Payments Phases Lines"."Amount" WHERE ("Code"=FIELD("Code")));
                                                   CaptionML=ESP='Total Importe';
                                                   Editable=false;


    }
    field(21;"Cald Date";Option)
    {
        OptionMembers="Calculated","Document","Manual";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Calculo de Fecha';
                                                   OptionCaptionML=ENU='Calculated,Document,Manual',ESP='Calculada,Del Documento,Manual';
                                                   
                                                   Description='QB 1.07.19 JAV 05/01/20: - Como se calcula la fecha';


    }
    field(22;"Date Formula";DateFormula)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='F¢rmula Fecha';
                                                   Description='QB 1.07.19 JAV 05/01/20: - F¢rmula para calcular la fecha';


    }
    field(23;"Calculated Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Calculada';
                                                   Description='QB 1.07.19 JAV 05/01/20: - Fecha fija';


    }
    field(30;"Payment Terms Code";Code[10])
    {
        TableRelation="Payment Terms";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Terms Code',ESP='C¢d. t‚rminos pago';


    }
    field(31;"Payment Method Code";Code[10])
    {
        TableRelation="Payment Method";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Method Code',ESP='C¢d. forma pago';


    }
    field(32;"QB Calc Due Date";Option)
    {
        OptionMembers="Standar","Document","Reception","Approval";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Calculo Vencimientos';
                                                   OptionCaptionML=ENU='Standar,Document,Reception,Approval',ESP='Estandar,Fecha del Documento,Fecha de Recepci¢n,Fecha de Aprobaci¢n';
                                                   
                                                   Description='QB 1.06 - JAV 12/07/20: - A partir de que fecha se calcula el vto de las fras de compra, GAP12 ROIG CyS,ORTIZ';

trigger OnValidate();
    BEGIN 
                                                                IF ("QB Calc Due Date" <> "QB Calc Due Date"::Reception) THEN
                                                                  "QB No. Days Calc Due Date" := 0;
                                                              END;


    }
    field(33;"QB No. Days Calc Due Date";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ d¡as tras Recepci¢n';
                                                   Description='QB 1.06 - JAV 12/07/20: - d¡as adicionales para el c lculo del vto de las fras de compra, ORTIZ' ;


    }
}
  keys
{
    key(key1;"Code","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBPaymentsPhasesLines@1100286000 :
      QBPaymentsPhasesLines: Record 7206930;

    

trigger OnInsert();    begin
               VALIDATE("Line No.");
             end;

trigger OnModify();    begin
               VALIDATE("Line No.");
             end;



/*begin
    end.
  */
}







