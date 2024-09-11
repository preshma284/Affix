table 7174351 "DP Prorrata Percentajes"
{
  
  
    CaptionML=ENU='Prorrata Percentage Setup',ESP='Configuraci¢n Porcentajes  Prorrata';
  
  fields
{
    field(1;"Starting Date";Date)
    {
        

                                                   CaptionML=ENU='Starting Date',ESP='Fecha inicial';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                //CEI14253 +
                                                                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                                                                  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
                                                                //CEI14253 -
                                                              END;


    }
    field(2;"Ending Date";Date)
    {
        

                                                   CaptionML=ENU='Ending Date',ESP='Fecha final';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                //CEI14253 +
                                                                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                                                                  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
                                                                //CEI14253 -
                                                              END;


    }
    field(3;"Prorrata %";Decimal)
    {
        CaptionML=ENU='Prorrata %',ESP='% Prorrata Provisional';
                                                   DecimalPlaces=0:0;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   BlankZero=true;


    }
    field(4;"Final Prorrata";Boolean)
    {
        CaptionML=ENU='Final Prorrata Applied',ESP='Prorrata definitiva Aplicada';
                                                   Editable=false;


    }
    field(5;"Final Prorrata %";Decimal)
    {
        CaptionML=ENU='Final Prorrata %',ESP='% Prorrata definitiva';
                                                   DecimalPlaces=0:0;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=false;


    }
    field(10;"Final Prorrata Calculated";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Final Prorrata Calculated',ESP='Se ha calculado la prorrata definitiva';
                                                   Description='DP 1.00.03 JAV 05/07/22 Indica que se ha efectuado el c�lculo del porcentaje de la prorrata definitiva';
                                                   Editable=false;


    }
    field(11;"New Prorrata Type";Option)
    {
        OptionMembers=" ","General","Special";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='prorrata Calc. Type',ESP='Nuevo Tipo de prorrata';
                                                   OptionCaptionML=ENU='" ,General,Special"',ESP='" ,General,Especial"';
                                                   
                                                   Description='DP 1.00.03 JAV 05/07/22 Indica el nuevo tipo de progrrata que se aplicar� seg�n los c�lculos';
                                                   Editable=false;

trigger OnValidate();
    VAR
//                                                                 OtherProrrataSetup@1100286000 :
                                                                OtherProrrataSetup: Record 7174351;
//                                                                 ThreeYearsLess@1100286001 :
                                                                ThreeYearsLess: Integer;
//                                                                 FilterYears@1100286002 :
                                                                FilterYears: Text;
//                                                                 LastYear@1100286003 :
                                                                LastYear: Integer;
//                                                                 ExistLastYear@1100286004 :
                                                                ExistLastYear: Boolean;
//                                                                 countr@1100286005 :
                                                                countr: Integer;
//                                                                 counterYears@1100286006 :
                                                                counterYears: Integer;
                                                              BEGIN 
                                                                //CEI14253 -
                                                                counterYears:=0;
                                                                LastYear := 0;
                                                                countr := 0;
                                                                IF (Rec."Prorrata Calc. Type" <> xRec."Prorrata Calc. Type") THEN BEGIN //hay un cambio manual
                                                                  IF (Rec."Prorrata Calc. Type" = Rec."Prorrata Calc. Type"::" ") THEN //no se puede cambiar a " "
                                                                    EXIT;
                                                                  //Si se intenta cambiar de ÊSpecialË a ÊGeneralË,
                                                                  IF (xRec."Prorrata Calc. Type" = xRec."Prorrata Calc. Type"::Special) AND (Rec."Prorrata Calc. Type" = Rec."Prorrata Calc. Type"::General) THEN BEGIN 
                                                                    // primero se verificar  si General prorrata AmountË > ÊSpecial prorrata AmountË * 1,1 en cuyo caso
                                                                    IF ("General prorrata Amount" > ("Special prorrata Amount" * 1.1)) THEN BEGIN 
                                                                      ERROR(TxtError03);//se mostrar  el mensaje de ERROR
                                                                    END ELSE BEGIN //si este importe fuera menor,
                                                                      FOR countr := 1 TO 3 DO// se buscar  cu l es el ÊApplication Year Ê, de entre los tres a¤os anteriores al actual,
                                                                        BEGIN 
                                                                          OtherProrrataSetup.RESET;
                                                                          LastYear := ("Application Year" - countr);
                                                                          OtherProrrataSetup.SETFILTER("Starting Date",'%1..%2',DMY2DATE(1,1,LastYear), DMY2DATE(31,12,LastYear));
                                                                          ExistLastYear := OtherProrrataSetup.FINDFIRST;
                                                                          IF ExistLastYear THEN BEGIN 
                                                                            IF OtherProrrataSetup."Prorrata Calc. Type" = OtherProrrataSetup."Prorrata Calc. Type"::Special THEN // con valor ÊSpecialË,
                                                                              counterYears += 1;
                                                                          END;
                                                                          //
                                                                        END;
                                                                      ;
                                                                      IF (counterYears > 0 ) AND (counterYears < countr) THEN
                                                                        ERROR(TxtError04, OtherProrrataSetup."Application Year");
                                                                    END;
                                                                  END;
                                                                END ELSE BEGIN 
                                                                  counterYears:=0;
                                                                  LastYear := 0;
                                                                  countr := 0;
                                                                  LastYear := ("Application Year"-1);
                                                                  OtherProrrataSetup.RESET;
                                                                  OtherProrrataSetup.SETFILTER("Starting Date",'%1..%2',DMY2DATE(1,1,LastYear), DMY2DATE(31,12,LastYear));
                                                                  ExistLastYear := OtherProrrataSetup.FINDFIRST;
                                                                  //Si la l¡nea de configuraci¢n del a¤o anterior no existe(primer a¤o que se aplica prorrata)o tiene el valor ÊGeneralË,
                                                                  IF NOT ExistLastYear OR (OtherProrrataSetup."Prorrata Calc. Type" =  OtherProrrataSetup."Prorrata Calc. Type"::General) THEN BEGIN 
                                                                    //se comprobar  si ÊGeneral prorrata AmountË > ÊSpecial prorrata AmountË * 1,1. En caso de que sea mayor,
                                                                    IF ("General prorrata Amount" > ("Special prorrata Amount" * 1.1)) THEN BEGIN //se seleccionar  la opci¢n ÊSpecialË;
                                                                      "Prorrata Calc. Type" := "Prorrata Calc. Type"::Special;
                                                                    END ELSE BEGIN //  si no, se seleccionar  la opci¢n ÊGeneralË.
                                                                      "Prorrata Calc. Type" := "Prorrata Calc. Type"::General;
                                                                    END;
                                                                  END;
                                                                  counterYears := 0;
                                                                  //Si la l¡nea de configuraci¢n del a¤o anterior tiene el valor ÊSpecialË, se mirar  cu ntas l¡neas de los tres a¤os anteriores hay con valor ÊSpecialË,
                                                                  IF OtherProrrataSetup."Prorrata Calc. Type" = OtherProrrataSetup."Prorrata Calc. Type"::Special THEN BEGIN 
                                                                    FOR countr := 1 TO 3 DO//si no hay al menos tres l¡neas (las del a¤o anterior, dos a¤os anteriores y tres a¤os anteriores
                                                                      BEGIN 
                                                                        OtherProrrataSetup.RESET;
                                                                        LastYear := ("Application Year" - countr);
                                                                        OtherProrrataSetup.SETFILTER("Starting Date",'%1..%2',DMY2DATE(1,1,LastYear), DMY2DATE(31,12,LastYear));
                                                                        ExistLastYear := OtherProrrataSetup.FINDFIRST;
                                                                        IF ExistLastYear THEN BEGIN 
                                                                          IF OtherProrrataSetup."Prorrata Calc. Type" = OtherProrrataSetup."Prorrata Calc. Type"::Special THEN
                                                                            counterYears += 1;
                                                                        END;
                                                                        //
                                                                      END;
                                                                    ;
                                                                    IF counterYears  <>  countr THEN BEGIN //no se realizar  el c lculo y se mantendr  el valor ÊSpecialË.
                                                                      "Prorrata Calc. Type" := "Prorrata Calc. Type"::Special;
                                                                    END ELSE BEGIN //si las tres anteriores tienen valor ÊSpecialË, se comprobar  si ÊGeneral prorrata AmountË > ÊSpecial prorrata AmountË * 1,1.
                                                                      IF ("General prorrata Amount" > ("Special prorrata Amount" * 1.1)) THEN BEGIN //En caso de que sea mayor, se seleccionar  la opci¢n ÊSpecialË
                                                                        "Prorrata Calc. Type" := "Prorrata Calc. Type"::Special;
                                                                      END ELSE BEGIN // si no, se seleccionar  la opci¢n ÊGeneralË.
                                                                        "Prorrata Calc. Type" := "Prorrata Calc. Type"::General;
                                                                      END;
                                                                    END;
                                                                  END;
                                                                END;
                                                                //CEI14253 +
                                                              END;


    }
    field(12;"Final Prorrata % Manual";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Final Prorrata % Manual',ESP='% Prorrata Definitiva a Aplicar';
                                                   Description='DP 1.00.03 JAV 05/07/22 Indica el porcentaje de prorrata definitiva que se aplicar�, si no est� informado se usar� el campo "% Prorrata definitiva"';


    }
    field(100;"Application Year";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Application Year',ESP='A¤o aplicaci¢n';
                                                   Description='CEI14253';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                //CEI14253 +
                                                                VALIDATE("Starting Date",DMY2DATE(1,1,"Application Year"));
                                                                VALIDATE("Ending Date",DMY2DATE(31,12,"Application Year"));
                                                                //CEI14253 -
                                                              END;


    }
    field(101;"Deductible Sales";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Deductible Sales',ESP='Ventas deducibles';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(102;"Total Sales";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Total Sales',ESP='Ventas totales';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(103;"Deductible Base Purchases";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Deductible Base Purchases',ESP='Base Compras deducibles';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(104;"Deductible Purchases General";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Deductible Purchases Genera',ESP='Compras deducibles General';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(105;"Deductible Purchases Special";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Deductible Purchases Specia',ESP='Compras deducibles Especial';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(106;"Non-deductible Base Purchases";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Non-deductible Base Purchases',ESP='Base Compras no deducibles';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(107;"Non-deductible Purchases Gral.";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Non-deductible Purchases General',ESP='Compras no deducibles General';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(108;"Joint Base Purchases";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Joint Base Purchases',ESP='Base Compras conjuntas';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(109;"Joint Purchases";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Joint Purchases',ESP='Compras conjuntas';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(110;"General prorrata Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='General prorrata Amount',ESP='Importe prorrata general';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(111;"Special prorrata Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Special prorrata Amount',ESP='Importe prorrata especial';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(112;"Prorrata Calc. Type";Option)
    {
        OptionMembers=" ","General","Special";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='prorrata Calc. Type',ESP='Tipo de C lculo prorrata';
                                                   OptionCaptionML=ENU='" ,General,Special"',ESP='" ,General,Especial"';
                                                   
                                                   Description='CEI14253';

trigger OnValidate();
    VAR
//                                                                 OtherProrrataSetup@1100286000 :
                                                                OtherProrrataSetup: Record 7174351;
//                                                                 ThreeYearsLess@1100286001 :
                                                                ThreeYearsLess: Integer;
//                                                                 FilterYears@1100286002 :
                                                                FilterYears: Text;
//                                                                 LastYear@1100286003 :
                                                                LastYear: Integer;
//                                                                 ExistLastYear@1100286004 :
                                                                ExistLastYear: Boolean;
//                                                                 countr@1100286005 :
                                                                countr: Integer;
//                                                                 counterYears@1100286006 :
                                                                counterYears: Integer;
                                                              BEGIN 
                                                                //CEI14253 -
                                                                counterYears:=0;
                                                                LastYear := 0;
                                                                countr := 0;
                                                                IF (Rec."Prorrata Calc. Type" <> xRec."Prorrata Calc. Type") THEN BEGIN //hay un cambio manual
                                                                  IF (Rec."Prorrata Calc. Type" = Rec."Prorrata Calc. Type"::" ") THEN //no se puede cambiar a " "
                                                                    EXIT;
                                                                  //Si se intenta cambiar de ÊSpecialË a ÊGeneralË,
                                                                  IF (xRec."Prorrata Calc. Type" = xRec."Prorrata Calc. Type"::Special) AND (Rec."Prorrata Calc. Type" = Rec."Prorrata Calc. Type"::General) THEN BEGIN 
                                                                    // primero se verificar  si General prorrata AmountË > ÊSpecial prorrata AmountË * 1,1 en cuyo caso
                                                                    IF ("General prorrata Amount" > ("Special prorrata Amount" * 1.1)) THEN BEGIN 
                                                                      ERROR(TxtError03);//se mostrar  el mensaje de ERROR
                                                                    END ELSE BEGIN //si este importe fuera menor,
                                                                      FOR countr := 1 TO 3 DO// se buscar  cu l es el ÊApplication Year Ê, de entre los tres a¤os anteriores al actual,
                                                                        BEGIN 
                                                                          OtherProrrataSetup.RESET;
                                                                          LastYear := ("Application Year" - countr);
                                                                          OtherProrrataSetup.SETFILTER("Starting Date",'%1..%2',DMY2DATE(1,1,LastYear), DMY2DATE(31,12,LastYear));
                                                                          ExistLastYear := OtherProrrataSetup.FINDFIRST;
                                                                          IF ExistLastYear THEN BEGIN 
                                                                            IF OtherProrrataSetup."Prorrata Calc. Type" = OtherProrrataSetup."Prorrata Calc. Type"::Special THEN // con valor ÊSpecialË,
                                                                              counterYears += 1;
                                                                          END;
                                                                          //
                                                                        END;
                                                                      ;
                                                                      IF (counterYears > 0 ) AND (counterYears < countr) THEN
                                                                        ERROR(TxtError04, OtherProrrataSetup."Application Year");
                                                                    END;
                                                                  END;
                                                                END ELSE BEGIN 
                                                                  counterYears:=0;
                                                                  LastYear := 0;
                                                                  countr := 0;
                                                                  LastYear := ("Application Year"-1);
                                                                  OtherProrrataSetup.RESET;
                                                                  OtherProrrataSetup.SETFILTER("Starting Date",'%1..%2',DMY2DATE(1,1,LastYear), DMY2DATE(31,12,LastYear));
                                                                  ExistLastYear := OtherProrrataSetup.FINDFIRST;
                                                                  //Si la l¡nea de configuraci¢n del a¤o anterior no existe(primer a¤o que se aplica prorrata)o tiene el valor ÊGeneralË,
                                                                  IF NOT ExistLastYear OR (OtherProrrataSetup."Prorrata Calc. Type" =  OtherProrrataSetup."Prorrata Calc. Type"::General) THEN BEGIN 
                                                                    //se comprobar  si ÊGeneral prorrata AmountË > ÊSpecial prorrata AmountË * 1,1. En caso de que sea mayor,
                                                                    IF ("General prorrata Amount" > ("Special prorrata Amount" * 1.1)) THEN BEGIN //se seleccionar  la opci¢n ÊSpecialË;
                                                                      "Prorrata Calc. Type" := "Prorrata Calc. Type"::Special;
                                                                    END ELSE BEGIN //  si no, se seleccionar  la opci¢n ÊGeneralË.
                                                                      "Prorrata Calc. Type" := "Prorrata Calc. Type"::General;
                                                                    END;
                                                                  END;
                                                                  counterYears := 0;
                                                                  //Si la l¡nea de configuraci¢n del a¤o anterior tiene el valor ÊSpecialË, se mirar  cu ntas l¡neas de los tres a¤os anteriores hay con valor ÊSpecialË,
                                                                  IF OtherProrrataSetup."Prorrata Calc. Type" = OtherProrrataSetup."Prorrata Calc. Type"::Special THEN BEGIN 
                                                                    FOR countr := 1 TO 3 DO//si no hay al menos tres l¡neas (las del a¤o anterior, dos a¤os anteriores y tres a¤os anteriores
                                                                      BEGIN 
                                                                        OtherProrrataSetup.RESET;
                                                                        LastYear := ("Application Year" - countr);
                                                                        OtherProrrataSetup.SETFILTER("Starting Date",'%1..%2',DMY2DATE(1,1,LastYear), DMY2DATE(31,12,LastYear));
                                                                        ExistLastYear := OtherProrrataSetup.FINDFIRST;
                                                                        IF ExistLastYear THEN BEGIN 
                                                                          IF OtherProrrataSetup."Prorrata Calc. Type" = OtherProrrataSetup."Prorrata Calc. Type"::Special THEN
                                                                            counterYears += 1;
                                                                        END;
                                                                        //
                                                                      END;
                                                                    ;
                                                                    IF counterYears  <>  countr THEN BEGIN //no se realizar  el c lculo y se mantendr  el valor ÊSpecialË.
                                                                      "Prorrata Calc. Type" := "Prorrata Calc. Type"::Special;
                                                                    END ELSE BEGIN //si las tres anteriores tienen valor ÊSpecialË, se comprobar  si ÊGeneral prorrata AmountË > ÊSpecial prorrata AmountË * 1,1.
                                                                      IF ("General prorrata Amount" > ("Special prorrata Amount" * 1.1)) THEN BEGIN //En caso de que sea mayor, se seleccionar  la opci¢n ÊSpecialË
                                                                        "Prorrata Calc. Type" := "Prorrata Calc. Type"::Special;
                                                                      END ELSE BEGIN // si no, se seleccionar  la opci¢n ÊGeneralË.
                                                                        "Prorrata Calc. Type" := "Prorrata Calc. Type"::General;
                                                                      END;
                                                                    END;
                                                                  END;
                                                                END;
                                                                //CEI14253 +
                                                              END;


    }
    field(113;"Provisional VAT deducted";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Provisional VAT deducted',ESP='IVA deducido provisional';
                                                   Description='CEI14253';
                                                   Editable=false;


    }
    field(114;"Application difference";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Application difference',ESP='Diferencia de aplicaci¢n';
                                                   Description='CEI14253';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Starting Date")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Text000@1100287000 :
      Text000: TextConst ENU='%1 cannot be after %2',ESP='%1 no puede ser posterior %2';
//       TxtError01@1100286000 :
      TxtError01: TextConst ENU='Final prorrata has already been calculated.',ESP='"La prorrata definitiva ya ha sido calculada "';
//       TxtError02@1100286001 :
      TxtError02: TextConst ENU='The year must be indicated.',ESP='Debe indicarse el a¤o.';
//       TxtError03@1100286002 :
      TxtError03: TextConst ENU='The general prorrata amount exceeds the special prorrata amount by more than 10%',ESP='El importe de prorrata general supera en m s de un 10% al importe de prorrata especial. No se puede cambiar.';
//       TxtError04@1100286003 :
      TxtError04: TextConst ENU='The special Prorrata must be applied 3 years from %1',ESP='La prorrata especial se debe aplicar 3 a¤os desde %1';

    

trigger OnDelete();    begin
               //CEI14253 +
               if "Final Prorrata" then
                 ERROR(TxtError01);
               //CEI14253 -
             end;



/*begin
    {
      JAV 21/06/22: - DP 1.00.00 Se a�ade nueva tabla para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    }
    end.
  */
}







