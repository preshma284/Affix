tableextension 50108 "QBU Cust. Ledger EntryExt" extends "Cust. Ledger Entry"
{
  
  
    CaptionML=ENU='Cust. Ledger Entry',ESP='Mov. cliente';
    LookupPageID="Customer Ledger Entries";
    DrillDownPageID="Customer Ledger Entries";
  
  fields
{
    field(50000;"QBU Several Customers Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Several Customers Name',ESP='Nombre clientes varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


    }
    field(50001;"QBU Several Customers VAT Reg. No.";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Several Customer VAT Registration No.',ESP='CIF/NIF clientes varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';


    }
    field(7174331;"QBU QuoSII Exported";Boolean)
    {
        CaptionML=ENU='SII Exported',ESP='Exportado SII';
                                                   Description='QuoSII';


    }
    field(7174332;"QBU QuoSII Sales Invoice Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SalesInvType"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Invoice Type',ESP='Tipo Factura';
                                                   Description='QuoSII';


    }
    field(7174333;"QBU QuoSII Sales Corrected In.Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SalesInvType"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Corrected Invoice Type',ESP='Tipo Factura Rectificativa';
                                                   Description='QuoSII';


    }
    field(7174334;"QBU QuoSII Sales Cr.Memo Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("CorrectedInvType"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Cr.Memo Type',ESP='Tipo Abono';
                                                   Description='QuoSII';


    }
    field(7174335;"QBU QuoSII Sales Special Regimen";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Special Regimen',ESP='R‚gimen Especial';
                                                   Description='QuoSII';


    }
    field(7174336;"QBU QuoSII Sales Special Regimen 1";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Special Regimen 1',ESP='R‚gimen Especial 1';
                                                   Description='QuoSII';


    }
    field(7174337;"QBU QuoSII Sales Special Regimen 2";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Special Regimen 2',ESP='R‚gimen Especial 2';
                                                   Description='QuoSII';


    }
    field(7174338;"QBU QuoSII Sales UE Inv Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("IntraKey"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Sales UE Inv Type',ESP='Tipo Factura IntraComunitaria';
                                                   Description='QuoSII';


    }
    field(7174339;"QBU QuoSII UE Country";Code[10])
    {
        TableRelation="Country/Region"."QuoSII Country Code";
                                                   CaptionML=ENU='UE Country',ESP='Estado Miembro';
                                                   Description='QuoSII';


    }
    field(7174340;"QBU QuoSII Bienes Description";Text[40])
    {
        CaptionML=ENU='Bienes Description',ESP='Descripci¢n Bienes';
                                                   Description='QuoSII';


    }
    field(7174341;"QBU QuoSII Operator Address";Text[120])
    {
        CaptionML=ENU='Operator Address',ESP='Direcci¢n Operador';
                                                   Description='QuoSII';


    }
    field(7174342;"QBU QuoSII Medio Cobro";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("PaymentMethod"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Receivable Method',ESP='Medio Cobro';
                                                   Description='QuoSII';


    }
    field(7174343;"QBU QuoSII CuentaMedioCobro";Text[34])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("PaymentMethod"));
                                                   CaptionML=ENU='Receivable Account',ESP='Cuenta Cobro';
                                                   Description='QuoSII';


    }
    field(7174344;"QBU QuoSII Last Ticket No.";Code[20])
    {
        CaptionML=ENU='Last Ticket No.',ESP='éltimo N§ Ticket';
                                                   Description='QuoSII';


    }
    field(7174345;"QBU QuoSII Third Party";Boolean)
    {
        CaptionML=ENU='Third Party',ESP='Emitida por tercero';
                                                   Description='QuoSII';


    }
    field(7174346;"QBU QuoSII Situacion Inmueble";Code[2])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("PropertyLocation"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Property Situation',ESP='Situacion Inmueble';
                                                   Description='QuoSII.007';


    }
    field(7174347;"QBU QuoSII Referencia Catastral";Code[25])
    {
        CaptionML=ENU='Cadastral Reference',ESP='Referencia Catastral';
                                                   Description='QuoSII.007';


    }
    field(7174348;"QBU QuoSII AEAT Status";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("SII Document Shipment Line"."AEAT Status" WHERE ("Entry No."=FIELD("Entry No."),
                                                                                                                        "Document Type"=FILTER('FE'|'CE'|'OI'|'CM')));
                                                   CaptionML=ENU='AEAT Status',ESP='Estado AEAT';
                                                   Description='QuoSII';
                                                   Editable=false;


    }
    field(7174349;"QBU QuoSII Ship No.";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("SII Document Shipment Line"."Ship No." WHERE ("Entry No."=FIELD("Entry No."),
                                                                                                                     "Document Type"=FILTER('FE'|'CE'|'OI'|'CM')));
                                                   CaptionML=ENU='Ship No.',ESP='N§ Env¡o';
                                                   Description='QuoSII';
                                                   Editable=false;


    }
    field(7174350;"QBU QuoSII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';


    }
    field(7174351;"QBU QuoSII First Ticket No.";Code[20])
    {
        CaptionML=ENU='First Ticket No.',ESP='Primer N§ Ticket';
                                                   Description='QuoSII';


    }
    field(7174376;"QBU QFA QuoFacturae Status";Option)
    {
        OptionMembers=" ","Posted","Posted in RCF","Payment mandatory posted","Paid","Refused","Canceled","Error";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Factura-e status',ESP='Estado Factura-e';
                                                   OptionCaptionML=ENU='" ,Posted,Posted in RCF,Payment mandatory posted,Paid,Refused,Canceled,Error"',ESP='" ,Registrada,Registrada en RCF,Contabilizada la obligaci¢n de pago,Pagada,Rechazada,Anulada,Error"';
                                                   
                                                   Description='QFA 0.1';


    }
    field(7174377;"QBU QFA Correction Reason Code";Option)
    {
        OptionMembers=" ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","80","81","82","83","84","85";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Reason Code',ESP='C¢digo motivo rectificativa';
                                                   OptionCaptionML=ESP='" ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,80,81,82,83,84,85"';
                                                   
                                                   Description='QFA 0.1';


    }
    field(7174378;"QBU QFA Correction Method Code";Option)
    {
        OptionMembers=" ","01","02","03","04";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Correction Method Code',ESP='C¢digo M‚todo Rectificativa';
                                                   OptionCaptionML=ENU='" ,01,02,03,04"',ESP='" ,01,02,03,04"';
                                                   
                                                   Description='QFA 0.1';


    }
    field(7174379;"QBU QFA Posting No. Facturae";Text[250])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Max("QuoFacturae Entry"."Description" WHERE ("Document type"=CONST("Sales invoice"),
                                                                                                          "Document no."=FIELD("Document no."),
                                                                                                          "Status"=FILTER(<>Error&<>Canceled)));
                                                   CaptionML=ESP='N£m. Registro Facturae';
                                                   Description='QFA 0.1';


    }
    field(7207270;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';
                                                   Description='QB 1.0';
                                                   Editable=false;


    }
    field(7207271;"QBU To Liquidate";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='To Liquidate',ESP='A liquidar';
                                                   Description='QB 1.06.15';


    }
    field(7207274;"QBU WIP Remaining Amount";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount" WHERE ("Cust. Ledger Entry No."=FIELD("Entry No."),
                                                                                                              "Posting Date"=FIELD("Date Filter")));
                                                   CaptionML=ENU='Remaining Amount',ESP='Importe pendiente de Obra en Curso';
                                                   Description='QB 1.07.09 - JAV 01/12/20: - Importe pendiente para el caso de que el tipo de moivimiento sea WIP';
                                                   Editable=false;
                                                   AutoFormatType=1;
                                                   AutoFormatExpression="Currency Code";


    }
    field(7207275;"QBU WIP Remaining Amt. (LCY)";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE ("Cust. Ledger Entry No."=FIELD("Entry No."),
                                                                                                                      "Posting Date"=FIELD("Date Filter")));
                                                   CaptionML=ENU='Remaining Amt. (LCY)',ESP='Importe pendiente Obra en Curso (DL)';
                                                   Description='QB 1.07.09 - JAV 01/12/20: - Importe pendiente para el caso de que el tipo de moivimiento sea WIP';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207276;"QBU Customer Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Customer"."Name" WHERE ("No."=FIELD("Customer No.")));
                                                   CaptionML=ESP='Nombre del Cliente';
                                                   Description='QB 1.10.27 JAV 23/03/22: - [TT: Nombre del cliente asociado al movimiento]';


    }
    field(7207277;"QBU Do not sent to SII";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No subir al SII';
                                                   Description='QB 1.10.40 - QuoSII 1.06.07  JAV 11/05/22: - Si se marca este campo, el movimiento no debe subir al SII de MS ni al QuoSII';


    }
    field(7207282;"QBU Receivable Bank No.";Code[20])
    {
        TableRelation="Bank Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Receivable Bank No.',ESP='N§ de banco de cobro';
                                                   Description='QB 1.00 - Q3707';


    }
    field(7207290;"QBU QW Withholding Entry";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Entry',ESP='M¢v. retenci¢n';
                                                   Description='QB 1.0 - QB3257';
                                                   Editable=false;


    }
    field(7207294;"QBU Prepayment";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='QB Prepayment',ESP='Prepago QB';
                                                   Description='QB 1.08.43,Q13154';


    }
    field(7207297;"QBU Confirming";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming',ESP='Confirming';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT: Indica si la operaci¢n ha provenido de un confirming]';


    }
    field(7207298;"QBU Confirming Dealing Type";Option)
    {
        OptionMembers=" ","Collection","Discount";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming Dealing Type',ESP='Confirming Tipo gesti¢n';
                                                   OptionCaptionML=ENU='" ,Collection,Discount"',ESP='" ,Cobro,Descuento"';
                                                   
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT: Indica el tipo de gesti¢n del confirming si la operaci¢n es de este tipo]';


    }
    field(7207500;"QBU Budget Item";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='QB 1.10.44 JAV 25/05/22: - Partida presupuestaria asociada al movimiento' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Customer No.","Posting Date","Currency Code")
  //  {
       /* SumIndexFields="Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)";
 */
   // }
   // key(No3;"Customer No.","Currency Code","Posting Date")
   // {
       /* ;
 */
   // }
   // key(key4;"Document No.")
  //  {
       /* ;
 */
   // }
   // key(key5;"External Document No.")
  //  {
       /* ;
 */
   // }
   // key(key6;"Customer No.","Open","Positive","Due Date","Currency Code")
  //  {
       /* ;
 */
   // }
   // key(key7;"Open","Due Date")
  //  {
       /* ;
 */
   // }
   // key(key8;"Document Type","Customer No.","Posting Date","Currency Code")
  //  {
       /* SumIndexFields="Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)";
 */
   // }
   // key(key9;"Salesperson Code","Posting Date")
  //  {
       /* ;
 */
   // }
   // key(key10;"Closed by Entry No.")
  //  {
       /* ;
 */
   // }
   // key(key11;"Transaction No.")
  //  {
       /* ;
 */
   // }
   // key(No12;"Customer No.","Open","Positive","Calculate Interest","Due Date")
   // {
       /* ;
 */
   // }
   // key(key13;"Customer No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date","Currency Code")
  //  {
       /* SumIndexFields="Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)","Pmt. Disc. Given (LCY)";
 */
   // }
   // key(key14;"Customer No.","Open","Global Dimension 1 Code","Global Dimension 2 Code","Positive","Due Date","Currency Code")
  //  {
       /* ;
 */
   // }
   // key(No15;"Open","Global Dimension 1 Code","Global Dimension 2 Code","Due Date")
   // {
       /* ;
 */
   // }
   // key(key16;"Document Type","Customer No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date","Currency Code")
  //  {
       /* ;
 */
   // }
   // key(key17;"Customer No.","Applies-to ID","Open","Positive","Due Date")
  //  {
       /* ;
 */
   // }
   // key(key18;"Customer No.","Open","Positive","Applies-to ID","Due Date")
  //  {
       /* ;
 */
   // }
   // key(key19;"Customer No.","Document Type","Document Situation","Document Status")
  //  {
       /* SumIndexFields="Remaining Amount (LCY) stats.","Amount (LCY) stats.";
 */
   // }
   // key(key20;"Document No.","Bill No.")
  //  {
       /* ;
 */
   // }
   // key(key21;"Document No.","Document Type","Customer No.")
  //  {
       /* ;
 */
   // }
   // key(key22;"Applies-to ID","Document Type","Document Situation","Document Status")
  //  {
       /* ;
 */
   // }
   // key(key23;"Document Type","Customer No.","Document Date","Currency Code")
  //  {
       /* ;
 */
   // }
   // key(key24;"Document Type","Posting Date")
  //  {
       /* SumIndexFields="Sales (LCY)";
 */
   // }
   // key(key25;"Document Type","Customer No.","Open","Due Date")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Entry No.","Description","Customer No.","Posting Date","Document Type","Document No.")
   // {
       // 
   // }
   // fieldgroup(Brick;"Document No.","Description","Remaining Amt. (LCY)","Due Date")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='must have the same sign as %1',ESP='debe tener el mismo signo que %1.';
//       Text001@1001 :
      Text001: TextConst ENU='must not be larger than %1',ESP='no debe ser mayor que %1.';
//       Text1100000@1100001 :
      Text1100000: TextConst ENU='Payment Discount (VAT Excl.)',ESP='% Dto. P.P. (IVA exclu¡do)';
//       Text1100001@1100002 :
      Text1100001: TextConst ENU='Payment Discount (VAT Adjustment)',ESP='% Dto. P.P. (IVA ajustado)';
//       DocMisc@1100000 :
      DocMisc: Codeunit 7000007;
//       CannotChangePmtMethodErr@1100003 :
      CannotChangePmtMethodErr: TextConst ENU='For Cartera-based bills and invoices, you cannot change the Payment Method Code to this value.',ESP='Para los efectos y las facturas basadas en Cartera, no puede modificar el C¢digo de forma de pago a este valor.';

    
    
/*
procedure ShowDoc () : Boolean;
    var
//       SalesInvoiceHdr@1003 :
      SalesInvoiceHdr: Record 112;
//       SalesCrMemoHdr@1002 :
      SalesCrMemoHdr: Record 114;
//       ServiceInvoiceHeader@1000 :
      ServiceInvoiceHeader: Record 5992;
//       ServiceCrMemoHeader@1001 :
      ServiceCrMemoHeader: Record 5994;
//       IssuedFinChargeMemoHeader@1004 :
      IssuedFinChargeMemoHeader: Record 304;
//       IssuedReminderHeader@1005 :
      IssuedReminderHeader: Record 297;
    begin
      CASE "Document Type" OF
        "Document Type"::Invoice:
          begin
            if SalesInvoiceHdr.GET("Document No.") then begin
              PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHdr);
              exit(TRUE);
            end;
            if ServiceInvoiceHeader.GET("Document No.") then begin
              PAGE.RUN(PAGE::"Posted Service Invoice",ServiceInvoiceHeader);
              exit(TRUE);
            end;
          end;
        "Document Type"::"Credit Memo":
          begin
            if SalesCrMemoHdr.GET("Document No.") then begin
              PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHdr);
              exit(TRUE);
            end;
            if ServiceCrMemoHeader.GET("Document No.") then begin
              PAGE.RUN(PAGE::"Posted Service Credit Memo",ServiceCrMemoHeader);
              exit(TRUE);
            end;
          end;
        "Document Type"::"Finance Charge Memo":
          if IssuedFinChargeMemoHeader.GET("Document No.") then begin
            PAGE.RUN(PAGE::"Issued Finance Charge Memo",IssuedFinChargeMemoHeader);
            exit(TRUE);
          end;
        "Document Type"::Reminder:
          if IssuedReminderHeader.GET("Document No.") then begin
            PAGE.RUN(PAGE::"Issued Reminder",IssuedReminderHeader);
            exit(TRUE);
          end;
      end;
    end;
*/


    
//     procedure DrillDownOnEntries (var DtldCustLedgEntry@1000 :
    
/*
procedure DrillDownOnEntries (var DtldCustLedgEntry: Record 379)
    var
//       CustLedgEntry@1001 :
      CustLedgEntry: Record 21;
    begin
      CustLedgEntry.RESET;
      DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
      DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Due Date",CustLedgEntry."Due Date");
      CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry.SETRANGE(Open,TRUE);
      OnBeforeDrillDownEntries(CustLedgEntry,DtldCustLedgEntry);
      PAGE.RUN(0,CustLedgEntry);
    end;
*/


    
//     procedure DrillDownOnOverdueEntries (var DtldCustLedgEntry@1000 :
    
/*
procedure DrillDownOnOverdueEntries (var DtldCustLedgEntry: Record 379)
    var
//       CustLedgEntry@1001 :
      CustLedgEntry: Record 21;
    begin
      CustLedgEntry.RESET;
      DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
      DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
      CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry.SETFILTER("Date Filter",'..%1',WORKDATE);
      CustLedgEntry.SETFILTER("Due Date",'<%1',WORKDATE);
      CustLedgEntry.SETFILTER("Remaining Amount",'<>%1',0);
      OnBeforeDrillDownOnOverdueEntries(CustLedgEntry,DtldCustLedgEntry);
      PAGE.RUN(0,CustLedgEntry);
    end;
*/


    
    
/*
procedure GetOriginalCurrencyFactor () : Decimal;
    begin
      if "Original Currency Factor" = 0 then
        exit(1);
      exit("Original Currency Factor");
    end;
*/


    
    
/*
procedure GetAdjustedCurrencyFactor () : Decimal;
    begin
      if "Adjusted Currency Factor" = 0 then
        exit(1);
      exit("Adjusted Currency Factor");
    end;
*/


    
    
/*
procedure ShowDimensions ()
    var
//       DimMgt@1000 :
      DimMgt: Codeunit 408;
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;
*/


//     procedure PrintBill (ShowRequestForm@1100000 :
    
/*
procedure PrintBill (ShowRequestForm: Boolean)
    var
//       CarteraReportSelection@1100001 :
      CarteraReportSelection: Record 7000013;
//       CustLedgEntry@1100002 :
      CustLedgEntry: Record 21;
    begin
      WITH CustLedgEntry DO begin
        COPY(Rec);
        CarteraReportSelection.SETRANGE(Usage,CarteraReportSelection.Usage::Bill);
        CarteraReportSelection.SETFILTER("Report ID",'<>0');
        CarteraReportSelection.FIND('-');
        repeat
          REPORT.RUNMODAL(CarteraReportSelection."Report ID",ShowRequestForm,FALSE,CustLedgEntry);
        until CarteraReportSelection.NEXT = 0;
      end;
    end;
*/


    
/*
procedure CheckBillSituation ()
    var
//       Doc@1100005 :
      Doc: Record 7000002;
//       Text1100100@1100006 :
      Text1100100: TextConst ENU='%1 cannot be applied, since it is included in a bill group.',ESP='%1 no se puede liquidar, ya que est  incluido en una remesa.';
//       Text1100101@1100007 :
      Text1100101: TextConst ENU=' Remove it from its bill group and try again.',ESP=' B¢rrelo de la remesa e int‚ntelo de nuevo.';
    begin
      if Doc.GET(Doc.Type::Receivable,Rec."Entry No.") then
        if Doc."Bill Gr./Pmt. Order No." <> '' then
          ERROR(
            Text1100100 +
            Text1100101,
            Rec.Description);
    end;
*/


    
    
/*
procedure SetStyle () : Text;
    begin
      if Open then begin
        if WORKDATE > "Due Date" then
          exit('Unfavorable')
      end else
        if "Closed at Date" > "Due Date" then
          exit('Attention');
      exit('');
    end;
*/


    
//     procedure SetApplyToFilters (CustomerNo@1000 : Code[20];ApplyDocType@1001 : Option;ApplyDocNo@1002 : Code[20];ApplyBillNo@1100000 : Code[20];ApplyAmount@1003 :
    
/*
procedure SetApplyToFilters (CustomerNo: Code[20];ApplyDocType: Option;ApplyDocNo: Code[20];ApplyBillNo: Code[20];ApplyAmount: Decimal)
    begin
      SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
      SETRANGE("Customer No.",CustomerNo);
      SETRANGE(Open,TRUE);
      SETFILTER("Document Situation",'<>%1',"Document Situation"::"Posted BG/PO");
      if ApplyDocNo <> '' then begin
        SETRANGE("Document Type",ApplyDocType);
        SETRANGE("Document No.",ApplyDocNo);
        if ApplyBillNo <> '' then
          SETRANGE("Bill No.",ApplyBillNo);
        if FINDFIRST then;
        SETRANGE("Document Type");
        SETRANGE("Document No.");
        SETRANGE("Bill No.");
      end else
        if ApplyDocType <> 0 then begin
          SETRANGE("Document Type",ApplyDocType);
          if FINDFIRST then;
          SETRANGE("Document Type");
        end else
          if ApplyAmount <> 0 then begin
            SETRANGE(Positive,ApplyAmount < 0);
            if FINDFIRST then;
            SETRANGE(Positive);
          end;
    end;
*/


    
//     procedure SetAmountToApply (AppliesToDocNo@1000 : Code[20];CustomerNo@1001 : Code[20];var AppliesToBillNo@1100000 :
    
/*
procedure SetAmountToApply (AppliesToDocNo: Code[20];CustomerNo: Code[20];var AppliesToBillNo: Code[20])
    begin
      SETCURRENTKEY("Document No.");
      SETRANGE("Document No.",AppliesToDocNo);
      SETRANGE("Customer No.",CustomerNo);
      SETRANGE(Open,TRUE);
      if FINDFIRST then begin
        AppliesToBillNo := "Bill No.";
        if "Amount to Apply" = 0 then begin
          CALCFIELDS("Remaining Amount");
          "Amount to Apply" := "Remaining Amount";
        end else
          "Amount to Apply" := 0;
        "Accepted Payment Tolerance" := 0;
        "Accepted Pmt. Disc. Tolerance" := FALSE;
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
      end;
    end;
*/


    
//     procedure CopyFromGenJnlLine (GenJnlLine@1000 :
    
/*
procedure CopyFromGenJnlLine (GenJnlLine: Record 81)
    begin
      "Customer No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Currency Code" := GenJnlLine."Currency Code";
      "Sales (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
      "Profit (LCY)" := GenJnlLine."Profit (LCY)";
      "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
      "Sell-to Customer No." := GenJnlLine."Sell-to/Buy-from No.";
      "Customer Posting Group" := GenJnlLine."Posting Group";
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Salesperson Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "On Hold" := GenJnlLine."On Hold";
      "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
      "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
      "Due Date" := GenJnlLine."Due Date";
      "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
      "Applies-to ID" := GenJnlLine."Applies-to ID";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "Direct Debit Mandate ID" := GenJnlLine."Direct Debit Mandate ID";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";
      "No. Series" := GenJnlLine."Posting No. Series";
      "IC Partner Code" := GenJnlLine."IC Partner Code";
      Prepayment := GenJnlLine.Prepayment;
      "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
      "Message to Recipient" := GenJnlLine."Message to Recipient";
      "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
      "Payment Method Code" := GenJnlLine."Payment Method Code";
      "Exported to Payment File" := GenJnlLine."Exported to Payment File";
      "Payment Terms Code" := GenJnlLine."Payment Terms Code";
      "Bill No." := GenJnlLine."Bill No.";
      "Applies-to Bill No." := GenJnlLine."Applies-to Bill No.";
      "Invoice Type" := GenJnlLine."Sales Invoice Type";
      "Cr. Memo Type" := GenJnlLine."Sales Cr. Memo Type";
      "Special Scheme Code" := GenJnlLine."Sales Special Scheme Code";
      "Correction Type" := GenJnlLine."Correction Type";
      "Corrected Invoice No." := GenJnlLine."Corrected Invoice No.";
      "Succeeded Company Name" := GenJnlLine."Succeeded Company Name";
      "Succeeded VAT Registration No." := GenJnlLine."Succeeded VAT Registration No.";

      OnAfterCopyCustLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    end;
*/


    
//     procedure CopyFromCVLedgEntryBuffer (var CVLedgerEntryBuffer@1000 :
    
/*
procedure CopyFromCVLedgEntryBuffer (var CVLedgerEntryBuffer: Record 382)
    begin
      TRANSFERFIELDS(CVLedgerEntryBuffer);
      Amount := CVLedgerEntryBuffer.Amount;
      "Amount (LCY)" := CVLedgerEntryBuffer."Amount (LCY)";
      "Remaining Amount" := CVLedgerEntryBuffer."Remaining Amount";
      "Remaining Amt. (LCY)" := CVLedgerEntryBuffer."Remaining Amt. (LCY)";
      "Original Amount" := CVLedgerEntryBuffer."Original Amount";
      "Original Amt. (LCY)" := CVLedgerEntryBuffer."Original Amt. (LCY)";

      OnAfterCopyCustLedgerEntryFromCVLedgEntryBuffer(Rec,CVLedgerEntryBuffer);
    end;
*/


    
//     procedure RecalculateAmounts (FromCurrencyCode@1001 : Code[10];ToCurrencyCode@1002 : Code[10];PostingDate@1003 :
    
/*
procedure RecalculateAmounts (FromCurrencyCode: Code[10];ToCurrencyCode: Code[10];PostingDate: Date)
    var
//       CurrExchRate@1004 :
      CurrExchRate: Record 330;
    begin
      if ToCurrencyCode = FromCurrencyCode then
        exit;

      "Remaining Amount" :=
        CurrExchRate.ExchangeAmount("Remaining Amount",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Remaining Pmt. Disc. Possible" :=
        CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Accepted Payment Tolerance" :=
        CurrExchRate.ExchangeAmount("Accepted Payment Tolerance",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Amount to Apply" :=
        CurrExchRate.ExchangeAmount("Amount to Apply",FromCurrencyCode,ToCurrencyCode,PostingDate);
    end;
*/


    
/*
LOCAL procedure ValidatePaymentMethod ()
    var
//       PaymentMethod@1100000 :
      PaymentMethod: Record 289;
    begin
      PaymentMethod.GET("Payment Method Code");
      if (("Document Type" = "Document Type"::Bill) and (not PaymentMethod."Create Bills")) or
         (("Document Type" = "Document Type"::Invoice) and (not PaymentMethod."Invoices to Cartera")) then
        ERROR(CannotChangePmtMethodErr);
    end;
*/


    
//     LOCAL procedure OnAfterCopyCustLedgerEntryFromGenJnlLine (var CustLedgerEntry@1000 : Record 21;GenJournalLine@1001 :
    
/*
LOCAL procedure OnAfterCopyCustLedgerEntryFromGenJnlLine (var CustLedgerEntry: Record 21;GenJournalLine: Record 81)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterCopyCustLedgerEntryFromCVLedgEntryBuffer (var CustLedgerEntry@1001 : Record 21;CVLedgerEntryBuffer@1000 :
    
/*
LOCAL procedure OnAfterCopyCustLedgerEntryFromCVLedgEntryBuffer (var CustLedgerEntry: Record 21;CVLedgerEntryBuffer: Record 382)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeDrillDownEntries (var CustLedgerEntry@1000 : Record 21;var DetailedCustLedgEntry@1001 :
    
/*
LOCAL procedure OnBeforeDrillDownEntries (var CustLedgerEntry: Record 21;var DetailedCustLedgEntry: Record 379)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeDrillDownOnOverdueEntries (var CustLedgerEntry@1000 : Record 21;var DetailedCustLedgEntry@1001 :
    
/*
LOCAL procedure OnBeforeDrillDownOnOverdueEntries (var CustLedgerEntry: Record 21;var DetailedCustLedgEntry: Record 379)
    begin
    end;

    /*begin
    //{
//      PEL 23/04/18: - QuoSII1.4 Cambiado primer semestre en Sales Invoice Type, Sales Invoice Type 1 y Sales Invoice Type 2
//      MCM 18/02/19: - QuoSII_1.4.02.042.13 Se cambia la propiedad CalcFormula de los campos "AEAT Status" y "Ship No."
//      PGM 21/09/20: - QB 1.06.15 - Creado los campos "To Liquidate" y "Liquidated"
//      JAV 23/03/22: - QB 1.10.27 Se incluye el campo 7207276 para el nombre
//      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)
//    }
    end.
  */
}





