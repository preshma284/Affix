table 7207313 "OLD_Responsible"
{
  
  
    CaptionML=ENU='Responsible',ESP='Responsable';
  
  fields
{
    field(1;"Table Code";Code[20])
    {
        TableRelation=IF ("Type"=CONST("Job")) Job."No."                                                                 ELSE IF ("Type"=CONST("Department")) "Dimension Value"."Code";
                                                   CaptionML=ENU='Job No.',ESP='C¢digo';


    }
    field(2;"Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='ID';
                                                   Description='JAV 13/01/19: - Id del registro, se usa para poder tener registros con los cargos duplicados';


    }
    field(3;"Type";Option)
    {
        OptionMembers="Job","Department","Budget";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ENU='Job,Department,Budget',ESP='Proyecto,Departamento,Presupuestos';
                                                   
                                                   Description='JAV 23/10/20: - QB 1.07.00 Tipo de registro (Proyecto/Departamento)';


    }
    field(11;"Position";Code[10])
    {
        TableRelation="OLD_Charge";
                                                   CaptionML=ENU='Charges',ESP='Cargo';
                                                   Description='JAV 28/07/19: - Cambio el Name que no est  bien traducido';


    }
    field(12;"Description";Text[80])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';
                                                   Editable=false;


    }
    field(14;"User ID";Code[50])
    {
        TableRelation="User Setup"."User ID";
                                                   CaptionML=ENU='User ID',ESP='ID usuario';


    }
    field(15;"Name";Text[80])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("User"."Full Name" WHERE ("User Name"=FIELD("User ID")));
                                                   CaptionML=ENU='Name',ESP='Nombre';
                                                   Editable=false;


    }
    field(20;"Jobs Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='1 Estudios Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Estudios';


    }
    field(21;"Jobs Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='1 Estudios Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de Estudios';


    }
    field(22;"Jobs Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='1 Estudios Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de Estudios';


    }
    field(30;"Comparative Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='2 Comparativos Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de comparativos';


    }
    field(31;"Comparative Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Request Amount Approval Limit',ESP='2 Comparativos Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - L¡mite de aprobaci¢n de comparativos';


    }
    field(32;"Comparative Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='2 Comparativos Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de comparativos';


    }
    field(40;"Purchase 1 Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='3a Compras Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Compras';


    }
    field(41;"Purchase 1 Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='3a Compras Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de compras';


    }
    field(42;"Purchase 1 Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='3a Compras Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de compras';


    }
    field(45;"Purchase Inv.1 Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='4a Fac.Compra Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Facturas Compra circuito 1';


    }
    field(46;"Purchase Inv.1 Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='4a Fac.Compra Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de facturas de compra circuito 1';


    }
    field(47;"Purchase Inv.1 Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='4a Fac.Compra Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n  ilimitada de Facturas de compra circuito 1';


    }
    field(50;"Payment Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='6 Pagos Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Pagos';


    }
    field(51;"Payment Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='6 Pagos Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - L¡mite de aprobaci¢n de pagos';


    }
    field(52;"Payment Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='6 Pagos Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de Pagos';


    }
    field(53;"Payment Due Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='6 Pagos Cert. Vencido Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Pagos con certificado vencido';


    }
    field(60;"Measurement Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='5 Mediciones Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Mediciones';


    }
    field(61;"Measurement Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='5 Mediciones Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - L¡mite de aprobaci¢n de Mediciones';


    }
    field(62;"Measurement Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='5 Mediciones  Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de Mediciones';


    }
    field(65;"Expense Note Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='7 Nota Gastos Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Notas de gastos';


    }
    field(66;"Expense Note Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='7 Nota Gastos Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de Notas de gastos';


    }
    field(67;"Expense Note Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='7 Nota Gastos Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de Notas de gastos';


    }
    field(70;"WorkSheet Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='8 Hoja Horas Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Hojas de horas';


    }
    field(71;"WorkSheet Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Request Amount Approval Limit',ESP='8 Hoja Horas Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - L¡mite de aprobaci¢n de Hojas de horas';


    }
    field(72;"WorkSheet Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='8 Hoja Horas Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de Hojas de horas';


    }
    field(75;"Transfers Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='9 Traspasos Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Traspasos';


    }
    field(76;"Transfers Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='9 Traspasos Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de Traspasos';


    }
    field(77;"Transfers Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='9 Traspasos Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de Traspasos';


    }
    field(80;"Purchase Inv.2 Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='4b Fac.Compra Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Facturas Compra circuito 2';


    }
    field(81;"Purchase Inv.2 Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='4b Fac.Compra Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de facturas de compra circuito 2';


    }
    field(82;"Purchase Inv.2 Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='4b Fac.Compra Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n  ilimitada de Facturas de compra circuito 2';


    }
    field(85;"Purchase Inv.3 Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='4c Fac.Compra Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Facturas Compra circuito 3';


    }
    field(86;"Purchase Inv.3 Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='4c Fac.Compra Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de facturas de compra circuito 3';


    }
    field(87;"Purchase Inv.3 Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='4c Fac.Compra Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n  ilimitada de Facturas de compra circuito 3';


    }
    field(90;"Purchase 2 Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='3b Compras Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Compras';


    }
    field(91;"Purchase 2 Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='3b Compras Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de compras';


    }
    field(92;"Purchase 2 Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='3b Compras Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de compras';


    }
    field(95;"Purchase 3 Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='3c Compras Nivel';
                                                   Description='JAV 11/12/19: - Nivel para aprobaci¢n de Compras';


    }
    field(96;"Purchase 3 Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='3c Compras Importe';
                                                   BlankZero=true;
                                                   Description='JAV 28/07/19: - Limite de aprobaci¢n de compras';


    }
    field(97;"Purchase 3 Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='3c Compras Ap.ilimitada';
                                                   Description='JAV 28/07/19: - Aprobaci¢n ilimitada de compras';


    }
    field(100;"Payment Order Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='10 Orden de Pago Nivel';
                                                   Description='JAV 23/10/20: - QB 1.07.00 Nivel para aprobaci¢n de Ordenes de Pago';


    }
    field(101;"Payment Order Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='10 Orden de Pago  Importe';
                                                   BlankZero=true;
                                                   Description='JAV 23/10/20: - QB 1.07.00 Limite de aprobaci¢n de Ordenes de Pago';


    }
    field(102;"Payment Order Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='10 Orden de Pago  Ap.ilimitada';
                                                   Description='JAV 23/10/20: - QB 1.07.00 Aprobaci¢n ilimitada de Ordenes de Pago';


    }
    field(105;"Purch. CrMemo Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='A Abono de compra Nivel';
                                                   Description='JAV 23/10/20: - QB 1.08.38 Nivel para aprobaci¢n de Abonos de compra';


    }
    field(106;"Purch. CrMemo Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='A Abono de compra Importe';
                                                   BlankZero=true;
                                                   Description='JAV 23/10/20: - QB 1.08.38 L¡mite para aprobaci¢n de Abonos de compra';


    }
    field(107;"Purch. CrMemo Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='A Abono de compra Ap.Ilimitada';
                                                   Description='JAV 23/10/20: - QB 1.08.38 Aprobaci¢n ilimitada de Abonos de compra';


    }
    field(110;"Budget Approval Level";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='B Presupuesto Nivel';
                                                   Description='JAV 01/09/21: - QB 1.09.90 Nivel para aprobaci¢n de Presupuesto';


    }
    field(111;"Budget Approval Limit";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Purchase Amount Approval Limit',ESP='B Presupuesto Importe';
                                                   BlankZero=true;
                                                   Description='JAV 01/09/21: - QB 1.09.90 Limite de aprobaci¢n de Presupuesto';


    }
    field(112;"Budget Approval Unlim.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Unlimited Request Approval',ESP='B Presupuesto Ap.Ilimitada';
                                                   Description='JAV 01/09/21: - QB 1.09.90 Aprobaci¢n ilimitada de Presupuesto';


    }
    field(113;"QB_Piecework No. Ap";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Table Code"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Piecework No.',ESP='CÂ¢d. unidad de obra';
                                                   Description='QRE15411' ;


    }
}
  keys
{
    key(key1;"Type","Table Code","Code")
    {
        Clustered=true;
    }
    key(key2;"Jobs Approval Level")
    {
        ;
    }
    key(key3;"Comparative Approval Level")
    {
        ;
    }
    key(key4;"Purchase 1 Approval Level")
    {
        ;
    }
    key(key5;"Purchase 2 Approval Level")
    {
        ;
    }
    key(key6;"Purchase 3 Approval Level")
    {
        ;
    }
    key(key7;"Payment Approval Level")
    {
        ;
    }
    key(key8;"Measurement Approval Level")
    {
        ;
    }
    key(key9;"Purchase Inv.1 Approval Level")
    {
        ;
    }
    key(key10;"Purchase Inv.2 Approval Level")
    {
        ;
    }
    key(key11;"Purchase Inv.3 Approval Level")
    {
        ;
    }
    key(key12;"Payment Due Approval Level")
    {
        ;
    }
    key(key13;"WorkSheet Approval Level")
    {
        ;
    }
    key(key14;"Expense Note Approval Level")
    {
        ;
    }
    key(key15;"Transfers Approval Level")
    {
        ;
    }
    key(key16;"Payment Order Approval Level")
    {
        ;
    }
}
  fieldgroups
{
}
  

    /*begin
    {
      JAV/07/9: - Se quita de la clave principal el cargo, dejando solo proyecto y usuario, y se a¤ade una segunda clave solo usuario
      JAV8/07/9: - Se a¤aden campos0,,,4 y5 para aprobaciones de compras y comparativos
      JAV 09/09/9: - Se a¤ade el campo 9 "Internal Id" para identificar los registros un¡vocamente
                    - Se a¤ade la key "Job No","Level","Internal Id"
      JAV 09/0/0: - Se a¤aden campos para los grupos y su inicializaci¢n
      JAV 0/09/: - QB0990 Se a¤aden campos, y una nueva key  para Aprobaci¢n de Presupuestos

      JAV 25/02/22: - QB 1.10.22 ELIMINADO, se pasa al nuevo sistema de aprobaciones. No se borra porque se usa en el proceso de cambios de versiones
    }
    end.
  */
}







