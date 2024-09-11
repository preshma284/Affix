table 7207330 "QBU Withholding Group"
{
  
  
    CaptionML=ENU='Withholding Group',ESP='Grupo retenci¢n';
    LookupPageID="Withholding Group List";
    DrillDownPageID="Withholding Group List";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';
                                                   NotBlank=true;


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Percentage Withholding";Decimal)
    {
        CaptionML=ENU='Percentage Withholding',ESP='Porcentaje Retencion';


    }
    field(4;"Warranty Period";DateFormula)
    {
        CaptionML=ENU='Warranty Period',ESP='Tiempo Garant¡a';


    }
    field(5;"Withholding Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   

                                                   CaptionML=ENU='Withholding Account',ESP='Cuenta de Retenciones';

trigger OnValidate();
    BEGIN 
                                                                GLAccount.GET("Withholding Account");
                                                                IF GLAccount."Account Type" = GLAccount."Account Type"::Heading THEN
                                                                  ERROR(Text000);
                                                              END;


    }
    field(6;"Withholding Type";Option)
    {
        OptionMembers="G.E","PIT";

                                                   CaptionML=ENU='Withholding Type',ESP='Tipo Retenci¢n';
                                                   OptionCaptionML=ENU='G.E, PIT',ESP='B.E,IRPF';
                                                   

trigger OnValidate();
    BEGIN 
                                                                //JAV 25/02/20: - Si la retenci¢n es de IRPF el tipo ser  IRPF, si no lo es y tiene tipo IRPF lo borramos
                                                                CASE "Withholding Type" OF
                                                                  "Withholding Type"::"G.E" :
                                                                    BEGIN 
                                                                      "Withholding treating" := "Withholding treating"::"Payment Withholding";
                                                                      "Withholding Base" := "Withholding Base"::"Amount Including VAT";
                                                                      //JAV 27/10/21: - QB 1.09.24 Si es de Garant¡a, eliminar el contenido de estos campos que solo sirven para el IRPF
                                                                      QB_IRPFWithhType := '';
                                                                      QB_IRPFSpeciesYields := FALSE;
                                                                    END;
                                                                  "Withholding Type"::PIT :
                                                                    BEGIN 
                                                                      "Withholding treating" := "Withholding treating"::PIT;
                                                                      "Withholding Base" := "Withholding Base"::"Invoice Amount";
                                                                    END;
                                                                END;
                                                              END;


    }
    field(7;"Withholding Base";Option)
    {
        OptionMembers="Invoice Amount","Amount Including VAT";CaptionML=ENU='Withholding Base',ESP='Base de Retenci¢n';
                                                   OptionCaptionML=ENU='Invoice Amount,Amount Including VAT',ESP='Base Imponible,Total Factura';
                                                   
                                                   Description='JAV 07/03/19 Cambio caption por uno mas adecuado';


    }
    field(8;"Withholding treating";Option)
    {
        OptionMembers="Payment Withholding","Pending Invoice","PIT";

                                                   CaptionML=ENU='Withholding Treatment',ESP='Tratamiento de retenci¢n';
                                                   OptionCaptionML=ENU='Payment Withholding,Pending Invoice,PIT',ESP='Retenci¢n Pago,Pte. Factura,IRPF';
                                                   

trigger OnValidate();
    BEGIN 
                                                                //JAV 25/02/20: - Si la retenci¢n no es de pago, solo puede calcularse sobre la base imponible
                                                                IF ("Withholding treating" IN ["Withholding treating"::"Pending Invoice", "Withholding treating"::PIT]) THEN
                                                                  "Withholding Base" := "Withholding Base"::"Invoice Amount"
                                                                ELSE
                                                                  "Withholding Base" := "Withholding Base"::"Amount Including VAT";

                                                                //JAV 25/02/20: - Ajustar valores posibles de los campos seg£n los tipos
                                                                IF ("Withholding Type" = "Withholding Type"::PIT) THEN
                                                                  "Withholding treating" := "Withholding treating"::PIT
                                                                ELSE IF ("Withholding treating" = "Withholding treating"::PIT) THEN
                                                                  CLEAR("Withholding treating");
                                                              END;


    }
    field(9;"VAT Product Withholding Group";Code[10])
    {
        TableRelation="VAT Product Posting Group";
                                                   CaptionML=ENU='VAT Product Posting Group',ESP='Grupo IVA producto retenci¢n';


    }
    field(10;"Estimation Type";Option)
    {
        OptionMembers=" ","By Modules";CaptionML=ENU='Estimation Type',ESP='Tipo Estimacion';
                                                   OptionCaptionML=ENU='" ,By Modules"',ESP='" ,Por M¢dulos"';
                                                   


    }
    field(11;"Use in";Option)
    {
        OptionMembers="Booth","Customer","Vendor";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Uso';
                                                   OptionCaptionML=ENU='Booth,Customer,Vendor',ESP='Ambos,Clientes,Proveedores';
                                                   
                                                   Description='JAV 11/08/19: - Si se usa para clientes, proveedores o ambos';


    }
    field(12;"Payment Method Liberation";Code[20])
    {
        TableRelation="Payment Method";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Forma Pago para Liberar';
                                                   Description='QB 1.06.21 - JAV 19/10/20: - Que forma de pago se usr  para liberar esta retenci¢n por defecto, si se deja en blanco usar  la del documento original';


    }
    field(13;"Calc Due Date";Option)
    {
        OptionMembers="DocDate","WorkEnd","JobEnd";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Calc Due Date',ESP='C lculo del Vencimiento';
                                                   OptionCaptionML=ENU='Document Date,End of Work,End of Job',ESP='Por Fecha Documento,Por Fin de Trabajo,Por Fin de obra.';
                                                   
                                                   Description='Q13647';


    }
    field(14;"QB_IRPFWithhType";Code[10])
    {
        TableRelation="QB_TipoRetencionIRPF"."QB_Codigo";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo Ret. IRPF';
                                                   Description='QRE';


    }
    field(15;"QB_IRPFSpeciesYields";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='IRPF Rdtos. especie';
                                                   Description='QRE';


    }
    field(16;"QB_Unpaid Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cuenta de impagadas';
                                                   Description='QRE' ;


    }
}
  keys
{
    key(key1;"Withholding Type","Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       GLAccount@1100286000 :
      GLAccount: Record 15;
//       Text000@1100286001 :
      Text000: TextConst ENU='Account must be an assistant account',ESP='La cuenta debe ser auxiliar';

    /*begin
    {
      JAV 07/03/19: - Cambio caption del campo 7 "Withholding Base" por uno mas adecuado, pongo
                      "Base Imponible" y "Total Factura" en lugar de "Importe factura" y "Total IVA incluido"
      JAV 11/08/19: - Se a¤ade el campo 11 "Use in" que indica si se usa para clientes, proveedore o ambos
      JAV 25/02/20: - Si la retenci¢n es de IRPF el tipo ser  IRPF, si no lo es y tiene tipo IRPF lo borramos
                    - Si la retenci¢n no es de pago, solo puede calcularse sobre la base imponible
                    - Ajustar valores posibles de los campos seg£n los tipos
      JAV 19/10/20: - QB 1.06.21 se a¤ade el campo 12 "Payment Method Liberation" para indicar la forma de pago se usr  para liberar esta retenci¢n

      Q13647 MMS 30/06/21 Se crea el campo para mejorar las Retenciones.
      Q15406 MCM 05/10/21 - QRE - Se crean los campos QB_IRPFWithhType y QB_IRPFSpeciesYields
      Q15417 LCG 06/10/21 - QRE - Se crea campo QB_Unpaid Account
    }
    end.
  */
}







