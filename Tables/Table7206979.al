table 7206979 "QBU IRPF VAT Statement Line"
{
  
  
  ;
  fields
{
    field(1;"QB_IRPF Declaration";Code[10])
    {
        TableRelation="QB_IRPF Statement Names";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Declaraci¢n IRPF';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(2;"QB_No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(3;"QB_Withholding Filter";Text[250])
    {
        TableRelation="Withholding Group"."Code";
                                                   

                                                   ValidateTableRelation=false;
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Filtro retenci¢n';
                                                   Description='QPR 0.00.33 Q15408';

trigger OnLookup();
    VAR
//                                                               WithholdingGroup@1100286001 :
                                                              WithholdingGroup: Record 7207330;
//                                                               pgWithholdGrpLst@1100286000 :
                                                              pgWithholdGrpLst: Page 7207401;
//                                                               vFilter@1100286002 :
                                                              vFilter: Text[250];
                                                            BEGIN 
                                                            END;


    }
    field(4;"QB_Position";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Position';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(5;"QB_Length";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Longitud';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(6;"QB_Withholding Field";Integer)
    {
        TableRelation=Field."No." WHERE ("TableNo"=CONST(7207329));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Campo de retenci¢n';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(7;"QB_IRPF Withh. Type Filter";Text[250])
    {
        TableRelation="QB_TipoRetencionIRPF"."QB_Codigo";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Filtro Tipo retenc. IRPF';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(8;"QB_Row Totaling";Text[250])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Filas a totalizar';
                                                   Description='QPR 0.00.33 Q15408';

trigger OnValidate();
    BEGIN 
                                                                CLEAR(WithholdingTreating);
                                                                IF QB_Type = QB_Type::"Row Totaling" THEN
                                                                  IF "QB_Row Totaling" <> '' THEN
                                                                    WithholdingTreating.CalculateSumOfLines(Rec)
                                                                  ELSE
                                                                    QB_Value := '';
                                                              END;


    }
    field(9;"QB_Application Type";Option)
    {
        OptionMembers=" ","Vendor","Customer";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo aplicaci¢n';
                                                   OptionCaptionML=ESP='" ,Proveedor,Cliente"';
                                                   
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(10;"QB_Type";Option)
    {
        OptionMembers="Alphanumerical","Numerical","Fix","Ask","Counter","Row Totaling";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ESP='Alfanum‚rico,Num‚rico,Fijo,Preguntar,Contador,Total l¡nea';
                                                   
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(11;"QB_Subtype";Option)
    {
        OptionMembers=" ","Integer and Decimal Part","Integer Part","Decimal Part";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Subtipo';
                                                   OptionCaptionML=ESP='" ,Parte entera y decimal,Parte entera,Parte decimal"';
                                                   
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(12;"QB_Description";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Descripci¢n';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(13;"QB_Value";Text[250])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Valor';
                                                   Description='QPR 0.00.33 Q15408';

trigger OnValidate();
    VAR
//                                                                 QB_IRPFVATStatementLine@1100286000 :
                                                                QB_IRPFVATStatementLine: Record 7206979;
                                                              BEGIN 
                                                                //QRE-LCG-Q15408-141021-INI
                                                                IF Rec.QB_Type IN [Rec.QB_Type::Alphanumerical,Rec.QB_Type::Counter,Rec.QB_Type::Numerical,Rec.QB_Type::"Row Totaling"] THEN
                                                                  ERROR(Text002Err,Rec.FIELDCAPTION(QB_Value),FORMAT(Rec.QB_Type::Ask),FORMAT(Rec.QB_Type::Fix));

                                                                IF (QB_Type = QB_Type::"Row Totaling") AND (QB_Value <> '') THEN
                                                                  ERROR(Text001Err,Rec.FIELDCAPTION(QB_Type),Rec.QB_Type::"Row Totaling");
                                                                //QRE-LCG-Q15408-151021-INI
                                                                CLEAR(WithholdingTreating);
                                                                IF Rec.QB_Type IN [Rec.QB_Type::Numerical,Rec.QB_Type::Ask] THEN
                                                                  BEGIN 
                                                                    QB_IRPFVATStatementLine.RESET();
                                                                    QB_IRPFVATStatementLine.SETRANGE(QB_Type,QB_IRPFVATStatementLine.QB_Type::"Row Totaling");
                                                                    IF QB_IRPFVATStatementLine.FINDSET() THEN
                                                                      REPEAT
                                                                        IF STRPOS(QB_IRPFVATStatementLine."QB_Row Totaling",FORMAT(Rec."QB_No.")) <> 0 THEN
                                                                          BEGIN 
                                                                            QB_IRPFVATStatementLine.QB_Value := WithholdingTreating.UpdateSumOfRowTotaling(QB_IRPFVATStatementLine,xRec.QB_Value,Rec.QB_Value);
                                                                            QB_IRPFVATStatementLine.MODIFY();
                                                                          END;

                                                                      UNTIL QB_IRPFVATStatementLine.NEXT() = 0;
                                                                  END;
                                                                //QRE-LCG-Q15408-151021-FIN
                                                              END;


    }
    field(14;"QB_Print";Boolean)
    {
        InitValue=true;
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Imprimir';
                                                   Description='QPR 0.00.33 Q15408';


    }
    field(15;"QB_Print with";Option)
    {
        OptionMembers="Sign","Opposite Sign";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Imprime con';
                                                   OptionCaptionML=ESP='Signo,Cambiar signo';
                                                   
                                                   Description='QPR 0.00.33 Q15408' ;


    }
}
  keys
{
    key(key1;"QB_IRPF Declaration","QB_No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Text001Err@1100286000 :
      Text001Err: TextConst ESP='No puede modificar el campo valor, si el %1 es %2';
//       WithholdingTreating@1100286001 :
      WithholdingTreating: Codeunit 7207306;
//       Text002Err@1100286002 :
      Text002Err: TextConst ESP='S¢lo puede modificar el valor de %1, si el campo es %2 o %3';

    /*begin
    {
      CEI-15408-LCG-051021- Crear tabla y campos

      QRE15408-LCG-141021- A¤adir campo QB_Row Totaling eliminando el n§ 8 - "IRPF Species Yields Filter". A¤adir a QB_Type nuevo valor: Row Totaling
      QRE-LCG-Q15408-151021- Calcular Value si se modifica para una fila tipo Num‚rico o Preguntar
    }
    end.
  */
}







