tableextension 50140 "QBU Purch. Cr. Memo Hdr.Ext" extends "Purch. Cr. Memo Hdr."
{
  
  DataCaptionFields="No.","Buy-from Vendor Name";
    CaptionML=ENU='Purch. Cr. Memo Hdr.',ESP='Hist¢rico cab. abono compra';
    LookupPageID="Posted Purchase Credit Memos";
    DrillDownPageID="Posted Purchase Credit Memos";
  
  fields
{
    field(50001;"QBU Job Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Job"."Description" WHERE ("No."=FIELD("Job No.")));
                                                   CaptionML=ESP='Nombre Proyecto';
                                                   Description='Q19224';
                                                   Editable=false;


    }
    field(50002;"QBU Budget Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Data Piecework For Production"."Description" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Piecework Code"=FIELD("QB Budget item")));
                                                   CaptionML=ESP='Descripci¢n P.Presup.';
                                                   Description='Q19224';
                                                   Editable=false;


    }
    field(50012;"QBU Notas filtro";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Notas filtro',ESP='Notas filtro';
                                                   Description='BS::19798';


    }
    field(50900;"QBU Several Vendors Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Several Vendors Name',ESP='Nombre proveedores varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


    }
    field(50901;"QBU Several Vendors VAT Reg. No.";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Several Vendors VAT Registration No.',ESP='CIF/NIF proveedores varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


    }
    field(7174331;"QBU QuoSII Auto Posting Date";Date)
    {
        CaptionML=ENU='SII Auto Posting Date',ESP='SII Fecha Registro Auto';
                                                   Description='QuoSII_1.3.03.006';


    }
    field(7174332;"QBU QuoSII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   

                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';

trigger OnValidate();
    VAR
//                                                                 QuoSII@7174331 :
                                                                QuoSII: Integer;
//                                                                 PurchaseLine@7174332 :
                                                                PurchaseLine: Record 39;
                                                              BEGIN 
                                                              END;


    }
    field(7174336;"QBU QuoSII Purch. Invoice Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("PurchInvType"));
                                                   CaptionML=ENU='Invoice Type',ESP='Tipo Factura';
                                                   Description='QuoSII';


    }
    field(7174337;"QBU QuoSII Purch. Cor. Inv. Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("PurchInvType"));
                                                   CaptionML=ENU='Corrected Invoice Type',ESP='Tipo Factura Rectificativa';
                                                   Description='QuoSII';


    }
    field(7174338;"QBU QuoSII Purch. Cr.Memo Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("CorrectedInvType"));
                                                   CaptionML=ENU='Cr. Memo Type',ESP='Tipo Abono';
                                                   Description='QuoSII';


    }
    field(7174339;"QBU QuoSII Purch Special Regimen";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialPurchInv"));
                                                   CaptionML=ENU='Special Regimen',ESP='R‚gimen Especial';
                                                   Description='QuoSII';


    }
    field(7174340;"QBU QuoSII Purch. UE Inv Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("IntraKey"));
                                                   CaptionML=ENU='Purch. UE Inv Type',ESP='Tipo Factura IntraComunitaria';
                                                   Description='QuoSII';


    }
    field(7174341;"QBU QuoSII Purch Special Regimen 1";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialPurchInv"));
                                                   CaptionML=ENU='Special Regimen 1',ESP='R‚gimen Especial 1';
                                                   Description='QuoSII';


    }
    field(7174342;"QBU QuoSII Purch Special Regimen 2";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialPurchInv"));
                                                   CaptionML=ENU='Special Regimen 2',ESP='R‚gimen Especial 2';
                                                   Description='QuoSII';


    }
    field(7174343;"QBU QuoSII Bienes Description";Text[40])
    {
        CaptionML=ENU='Possessions Description',ESP='Descripci¢n Bienes';
                                                   Description='QuoSII';


    }
    field(7174344;"QBU QuoSII Operator Address";Text[120])
    {
        CaptionML=ENU='Operator Address',ESP='Direcci¢n Operador';
                                                   Description='QuoSII';


    }
    field(7174345;"QBU QuoSII Last Ticket No.";Code[20])
    {
        CaptionML=ENU='Last Ticket No.',ESP='éltimo N§ Ticket';
                                                   Description='QuoSII';


    }
    field(7174346;"QBU QuoSII Third Party";Boolean)
    {
        CaptionML=ENU='Third Party',ESP='Emitida por tercero';
                                                   Description='QuoSII';


    }
    field(7174360;"QBU DP Force Not Use Prorrata";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Apply prorrata',ESP='Forzar no aplicar';
                                                   Description='DP 1.00.00 PRORRATA JAV 21/06/22: [TT] Si se marca este campo no se aplicar  la prorrata en ning£in caso, aunque el sistema calcule que si debe usarse';
                                                   Editable=false;


    }
    field(7174361;"QBU DP Apply Prorrata Type";Option)
    {
        OptionMembers="No","General","Especial";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Apply prorrata',ESP='Tipo de Prorrata Aplicable';
                                                   OptionCaptionML=ENU='No,General,Special',ESP='No,General,Especial';
                                                   
                                                   Description='DP 1.00.00 PRORRATA';
                                                   Editable=false;


    }
    field(7174362;"QBU DP Prorrata %";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Prorrata Aplicada';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='DP 1.00.00 PRORRATA';
                                                   Editable=false;


    }
    field(7174363;"QBU DP Definitive Prorrata %";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Prorrata Definitiva';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='DP 1.00.00 PRORRATA : CEI14253 MMS 30/09/21 a¤dido campo por Automatizaci¢n del c lculo de la prorrata definitiva';
                                                   Editable=false;


    }
    field(7174364;"QBU DP Non Deductible VAT Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."DP Non Deductible VAT amount" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ESP='IVA no deducible';
                                                   Description='DP 1.00.00 PRORRATA : JAV 21/06/22: [TT] Este campo indica el importe total de IVA no deducible del documento';
                                                   Editable=false;


    }
    field(7174365;"QBU DP Deductible VAT Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."DP Deductible VAT amount" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ESP='IVA deducible';
                                                   Description='DP 1.00.00 PRORRATA : JAV 21/06/22: [TT] Este campo indica el importe total de IVA deducible del documento';
                                                   Editable=false;


    }
    field(7207270;"QBU QW Cod. Withholding by GE";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("G.E"),
                                                                                                 "Use in"=FILTER('Booth'|'Vendor'));
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='C¢d. retenci¢n por B.E.';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207271;"QBU QW Cod. Withholding by PIT";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("PIT"),
                                                                                                 "Use in"=FILTER('Booth'|'Vendor'));
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='C¢d. retenci¢n por IRPF';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207272;"QBU QW Total Withholding GE";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."QW Withholding Amount by GE" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E.';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"QBU QW Total Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."QW Withholding Amount by PIT" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding PIT',ESP='Total retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207275;"QBU Order To";Option)
    {
        OptionMembers="Job","Location";CaptionML=ENU='Order To',ESP='Pedido contra';
                                                   OptionCaptionML=ENU='Job,Location',ESP='Proyecto,Almac‚n';
                                                   
                                                   Description='QB 1.00 - QB2514';


    }
    field(7207276;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';
                                                   Description='QB 1.00 - QB2514';


    }
    field(7207278;"QBU Receipt Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Recepci¢n';
                                                   Description='QB 1.00 - JAV 08/01/20: ROIG_CYS GAP12 - Recepci¢n de documentos, fecha de recepci¢n';


    }
    field(7207279;"QBU Total document amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Documento';
                                                   Description='QB 1.00 - JAV 08/01/20: ROIG_CYS GAP12 - Recepci¢n de documentos, importe del documento';


    }
    field(7207280;"QBU Operation date SII";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha operaci¢n II';
                                                   Description='QB 1.00 - QB5555 JAV 04/07/19: Fecha de operaci¢n para el SII';


    }
    field(7207282;"QBU QW Withholding mov liq.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Liquida mov. retenci¢n n§';
                                                   Description='QB 1.04 - JAV 26/05/20: Que movimiento de retenci¢n de garant¡a liquida esta factura';


    }
    field(7207285;"QBU Contract";Boolean)
    {
        CaptionML=ENU='Contrato',ESP='Contrato';
                                                   Description='QB 1.00 - QB2515';


    }
    field(7207289;"QBU Receive in FRIS";Boolean)
    {
        CaptionML=ENU='Receive in FRIS',ESP='Recibir en FRIS';
                                                   Description='QB 1.00 - QB2517';


    }
    field(7207295;"QBU Contract No.";Code[20])
    {
        TableRelation="Purchase Header"."No." WHERE ("Document Type"=CONST("Order"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Order to Cancel',ESP='N§ Contrato';
                                                   Description='QB 1.00 - JAV 15/06/19: - Sobre que contrato estamos trabajando';


    }
    field(7207296;"QBU QW Base Withholding GE";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."QW Base Withholding by GE" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Base retenci¢n B.E.';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207297;"QBU QW Base Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."QW Base Withholding by PIT" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding PIT',ESP='Base retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207298;"QBU QW Total Withholding GE Before";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."Amount" WHERE ("Document No."=FIELD("No."),
                                                                                                        "QW Withholding by GE Line"=CONST(true)));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E. Fra.';
                                                   Description='QB 1.00 - JAV 23/10/19: - Se doblan los campos de la retenci¢n de B.E. para tener ambos importes disponibles';
                                                   Editable=false;


    }
    field(7207300;"QBU Last Proform";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='éltima proforma';
                                                   Description='ARPADAD COMGAP039';
                                                   Editable=false;


    }
    field(7207302;"QBU Approval Situation";Option)
    {
        OptionMembers="Pending","Approved","Rejected","Withheld";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Status',ESP='Situaci¢n de la Aprobaci¢n';
                                                   OptionCaptionML=ESP='Pendiente,Aprobado,Rechazado,Retenido';
                                                   
                                                   Description='QB 1.03 - JAV 14/10/19: - Situaci¢n de la aprobaci¢n';
                                                   Editable=false;


    }
    field(7207303;"QBU Approval Coment";Text[80])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Comentario Aprobaci¢n';
                                                   Description='QB 1.03 - JAV 14/10/19: - éltimo comentario de la aprobaci¢n, retenci¢n o rechazo';
                                                   Editable=false;


    }
    field(7207304;"QBU Approval Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha aprobaci¢n';
                                                   Description='QB 1.03 - JAV 14/10/19: - Feha de la aprobaci¢n, retenci¢n o rechazo';
                                                   Editable=false;


    }
    field(7207305;"QBU Approval Circuit";Option)
    {
        OptionMembers="General","Materiales","Subcontratas";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Circuito de Aprobaci¢n';
                                                   OptionCaptionML=ESP='General,Materiales,Subcontratas';
                                                   
                                                   Description='QB 1.04 - JAV';
                                                   Editable=false;


    }
    field(7207306;"QBU SII Year-Month";Text[7])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='SII Ejercicio-Periodo';
                                                   Description='QB 1.05 - JAV Ejercicio y periodo en que se declar  en el SII de Microsoft';
                                                   Editable=false;


    }
    field(7207307;"QBU Payment Phases";Code[20])
    {
        TableRelation="QB Payments Phases";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fases de Pago';
                                                   Description='QB 1.06 - JAV 06/07/20: - Si el pago se hacer por fases de pago';


    }
    field(7207309;"QBU Calc Due Date";Option)
    {
        OptionMembers="Standar","Document","Reception","Approval";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Calculo Vencimientos';
                                                   OptionCaptionML=ENU='Standar,Document,Reception,Approval',ESP='Estandar,Fecha del Documento,Fecha de Recepci¢n,Fecha de Aprobaci¢n';
                                                   
                                                   Description='QB 1.06 - JAV 12/07/20: - A partir de que fecha se calcula el vto de las fras de compra, GAP12 ROIG CyS,ORTIZ';


    }
    field(7207310;"QBU No. Days Calc Due Date";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ d¡as tras Recepci¢n';
                                                   Description='QB 1.06 - JAV 12/07/20: - d¡as adicionales para el c lculo del vto de las fras de compra,ORTIZ';


    }
    field(7207311;"QBU Due Date Base";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Base Calculo Vto.';
                                                   Description='QB 1.06 - JAV 12/07/20: - Fecha base para el c clulo de los vencimientos de las fras de compra,ORTIZ';


    }
    field(7207313;"QBU QW Witholding Due Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Vto. Retenci¢n';
                                                   Description='QB 1.06.07 - JAV 30/07/20: - Fecha de vencimiento de la retenci¢n de buena ejecuci¢n';


    }
    field(7207320;"QBU Prepayment Use";Option)
    {
        OptionMembers="No","Prepayment","Application";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Prepayment',ESP='Uso del Anticipo';
                                                   OptionCaptionML=ENU='No,Prepayment,Application',ESP='No,Anticipo,Aplicaci¢n';
                                                   
                                                   Description='Q12879';


    }
    field(7207322;"QBU Prepayment Apply";Decimal)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Prepayment Amount to Apply',ESP='Descontar Anticipo';
                                                   Description='Q12879';

trigger OnValidate();
    VAR
//                                                                 QBPrepayments@1100286000 :
                                                                QBPrepayments: Codeunit 7207300;
//                                                                 ExceedAmtErr@1100286001 :
                                                                ExceedAmtErr: TextConst ENU='The amount of the prepayment cannot exceed the pending.',ESP='El importe del anticipo no puede ser superior al pendiente.';
                                                              BEGIN 
                                                              END;


    }
    field(7207323;"QBU Prepayment Description";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Prepayment Description',ESP='Descripci¢n del Anticipo';
                                                   Description='Q12879';

trigger OnValidate();
    VAR
//                                                                 QBPrepayments@1100286000 :
                                                                QBPrepayments: Codeunit 7207300;
//                                                                 TotalSettlementMsg@1100286001 :
                                                                TotalSettlementMsg: TextConst ENU='Total settlement of the prepayment',ESP='Liquidaci¢n total del anticipo';
//                                                                 PartialSettlementMsg@1100286002 :
                                                                PartialSettlementMsg: TextConst ENU='Partial settlement of the prepayment',ESP='Liquidaci¢n parcial del anticipo';
                                                              BEGIN 
                                                              END;


    }
    field(7207326;"QBU Prepayment Type";Option)
    {
        OptionMembers="No","Invoice","Bill";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Tipo de Prepago';
                                                   OptionCaptionML=ENU='No,Invoice,Bill',ESP='No,Factura,Pago';
                                                   
                                                   Description='QB 1.08.43 - Tipo de prepago a generar';


    }
    field(7207332;"QBU Payment Bank No.";Code[20])
    {
        TableRelation="Bank Account"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Bank No.',ESP='N§ de banco de cobro';
                                                   Description='QB 1.10.00 JAV 23/11/21 Banco por el que se espera cobrar el documento';


    }
    field(7207342;"QBU Prepayment Data";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Datos del Anticipo Aplicado';
                                                   Description='QB 1.10.49 JAV 13/06/22: [TT] Indica el c¢digo de los datos aplicados del anticipo al documento';


    }
    field(7238177;"QBU Budget item";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Account Type"=FILTER("Unit"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='QPR, Q19224' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Pre-Assigned No.")
  //  {
       /* ;
 */
   // }
   // key(key3;"Vendor Cr. Memo No.","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key4;"Return Order No.")
  //  {
       /* ;
 */
   // }
   // key(key5;"Buy-from Vendor No.")
  //  {
       /* ;
 */
   // }
   // key(key6;"Prepayment Order No.")
  //  {
       /* ;
 */
   // }
   // key(key7;"Pay-to Vendor No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Buy-from Vendor No.","Pay-to Vendor No.","Posting Date","Posting Description")
   // {
       // 
   // }
}
  
    var
//       PurchCrMemoHeader@1000 :
      PurchCrMemoHeader: Record 124;
//       PurchCommentLine@1001 :
      PurchCommentLine: Record 43;
//       VendLedgEntry@1002 :
      VendLedgEntry: Record 25;
//       DimMgt@1004 :
      DimMgt: Codeunit 408;
//       ApprovalsMgmt@1008 :
      ApprovalsMgmt: Codeunit 1535;
//       UserSetupMgt@1005 :
      UserSetupMgt: Codeunit 5700;

    


/*
trigger OnDelete();    var
//                PostedDeferralHeader@1000 :
               PostedDeferralHeader: Record 1704;
//                PostPurchDelete@1002 :
               PostPurchDelete: Codeunit 364;
//                DeferralUtilities@1001 :
               DeferralUtilities: Codeunit 1720;
             begin
               PostPurchDelete.IsDocumentDeletionAllowed("Posting Date");
               LOCKTABLE;
               PostPurchDelete.DeletePurchCrMemoLines(Rec);

               PurchCommentLine.SETRANGE("Document Type",PurchCommentLine."Document Type"::"Posted Credit Memo");
               PurchCommentLine.SETRANGE("No.","No.");
               PurchCommentLine.DELETEALL;

               ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
               PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetPurchDeferralDocType,'','',
                 PurchCommentLine."Document Type"::"Posted Credit Memo","No.");
             end;

*/



// procedure PrintRecordsAutoCrMemo (ShowRequestForm@1100000 :

/*
procedure PrintRecordsAutoCrMemo (ShowRequestForm: Boolean)
    var
//       ReportSelection@1100001 :
      ReportSelection: Record 77;
    begin
      WITH PurchCrMemoHeader DO begin
        COPY(Rec);
        ReportSelection.SETRANGE(Usage,ReportSelection.Usage::"P.AutoCr.Memo");
        ReportSelection.SETFILTER("Report ID",'<>0');
        ReportSelection.FIND('-');
        repeat
          REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,PurchCrMemoHeader);
        until ReportSelection.NEXT = 0;
      end;
    end;
*/


    
//     procedure PrintRecords (ShowRequestForm@1000 :
    
/*
procedure PrintRecords (ShowRequestForm: Boolean)
    var
//       ReportSelection@1001 :
      ReportSelection: Record 77;
    begin
      WITH PurchCrMemoHeader DO begin
        COPY(Rec);
        ReportSelection.PrintWithGUIYesNoVendor(
          ReportSelection.Usage::"P.Cr.Memo",PurchCrMemoHeader,ShowRequestForm,FIELDNO("Buy-from Vendor No."));
      end;
    end;
*/


    
    
/*
procedure Navigate ()
    var
//       NavigateForm@1000 :
      NavigateForm: Page 344;
    begin
      NavigateForm.SetDoc("Posting Date","No.");
      NavigateForm.RUN;
    end;
*/


    
    
/*
procedure ShowDimensions ()
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    end;
*/


    
    
/*
procedure SetSecurityFilterOnRespCenter ()
    begin
      if UserSetupMgt.GetPurchasesFilter <> '' then begin
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
        FILTERGROUP(0);
      end;
    end;
*/


    
    
/*
procedure ShowCanceledOrCorrInvoice ()
    begin
      CALCFIELDS(Cancelled,Corrective);
      CASE TRUE OF
        Cancelled:
          ShowCorrectiveInvoice;
        Corrective:
          ShowCancelledInvoice;
      end;
    end;
*/


    
    
/*
procedure ShowCorrectiveInvoice ()
    var
//       CancelledDocument@1000 :
      CancelledDocument: Record 1900;
//       PurchInvHeader@1001 :
      PurchInvHeader: Record 122;
    begin
      CALCFIELDS(Cancelled);
      if not Cancelled then
        exit;

      if CancelledDocument.FindPurchCancelledCrMemo("No.") then begin
        PurchInvHeader.GET(CancelledDocument."Cancelled By Doc. No.");
        PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
      end;
    end;
*/


    
    
/*
procedure ShowCancelledInvoice ()
    var
//       CancelledDocument@1000 :
      CancelledDocument: Record 1900;
//       PurchInvHeader@1001 :
      PurchInvHeader: Record 122;
    begin
      CALCFIELDS(Corrective);
      if not Corrective then
        exit;

      if CancelledDocument.FindPurchCorrectiveCrMemo("No.") then begin
        PurchInvHeader.GET(CancelledDocument."Cancelled Doc. No.");
        PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
      end;
    end;

    /*begin
    //{
//      QuoSII_1.1 - 16/08/2017 - Se crean los campos 7174332 y 7174334. Se eliminan los campos 7174337 y 7174338
//      QuoSII_1.3.03.006 21/11/17 MCM - Se incluye el campo para importarlo como Fecha de Registro contable
//      QuoSII1.4 23/04/18 PEL - Cambiado primer semestre en Purch. Invoice Type, Purch. Invoice Type 1 y Purch. Invoice Type 2
//
//      NZG 15/06/18: - Q2395 Se crean nuevos campos.
//      JAV 15/06/19: - Se a¤ade el campo de pedido a cancelar, para el control de contratos
//      JAV 04/07/19: - Se a¤ade el campo de fecha operaci¢n SII
//      JAV 23/10/19: - Se a¤aden los campos "Base Withholding G.E", "Base Withholding PIT" y "Total Withholding G.E Before"
//      JAV 21/01/22: - QB 1.10.11 Se eliminan campos relacionados con el contrato que no son utilizados en el programa para nada
//      JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
//                                    7174360 "DP Force not Use Prorrata"
//                                    7174361 "DP Apply Prorrata Type"
//                                    7174362 "DP Prorrata %"
//                                    7174363 "DP Definitive Prorrata %"
//                                    7174365 "DP Deductible VAT Amount"
//      JJEP 19/04/2023: - Q19224 - COM034 - NOMBRE DE PROYECTO EN FICHAS DE COMPRAS
//      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)
//      BS::19798 CSM 20/10/23  Í Campos filtrables Êcomentarios filtroË y Ênotas filtroË.  New Field: 50012. Modify Field: 46.
//    }
    end.
  */
}





