tableextension 50134 "QBU Sales Cr.Memo HeaderExt" extends "Sales Cr.Memo Header"
{
  
  DataCaptionFields="No.","Sell-to Customer Name";
    CaptionML=ENU='Sales Cr.Memo Header',ESP='Hist¢rico cab. abono venta';
    LookupPageID="Posted Sales Credit Memos";
    DrillDownPageID="Posted Sales Credit Memos";
  
  fields
{
    field(50002;"QBU G.E.W. mod.";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist("Sales Cr.Memo Line" WHERE ("Document No."=FIELD("No."),
                                                                                                 "G.E.W. mod."=CONST(true)));
                                                   CaptionML=ENU='G.E.W. mod.',ESP='Ret. B.E. modificada';
                                                   Description='BS::20668';
                                                   Editable=false;


    }
    field(50003;"QBU Certification Period";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certification Period',ESP='Periodo certificaci¢n';
                                                   Description='BS::21212';


    }
    field(50900;"QBU Several Customers Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Several Customers Name',ESP='Nombre clientes varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';
                                                   Editable=false;


    }
    field(50901;"QBU Several Customers VAT Reg. No.";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Several Cust. VAT Registration No.',ESP='CIF/NIF clientes varios';
                                                   Description='Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)';
                                                   Editable=false;


    }
    field(7174331;"QBU QuoSII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   

                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';

trigger OnValidate();
    VAR
//                                                                 SalesLine@7174331 :
                                                                SalesLine: Record 37;
                                                              BEGIN 
                                                              END;


    }
    field(7174332;"QBU QuoSII Sales Invoice Type QS";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SalesInvType"));
                                                   CaptionML=ENU='Invoice Type',ESP='Tipo Factura';
                                                   Description='QuoSII';


    }
    field(7174333;"QBU QuoSII Sales Cor. Inv. Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SalesInvType"));
                                                   CaptionML=ENU='Corrected Invoice Type',ESP='Tipo Factura Rectificativa';
                                                   Description='QuoSII';


    }
    field(7174334;"QBU QuoSII Sales Cr.Memo Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SalesInvType"));
                                                   CaptionML=ENU='Cr.Memo Type',ESP='Tipo Abono';
                                                   Description='QuoSII';


    }
    field(7174335;"QBU QuoSII Sales UE Inv Type";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("IntraKey"));
                                                   CaptionML=ENU='Sales UE Inv Type',ESP='Tipo Factura IntraComunitaria';
                                                   Description='QuoSII';


    }
    field(7174336;"QBU QuoSII Sales Special Regimen 1";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"));
                                                   CaptionML=ENU='Special Regimen 1',ESP='R‚gimen Especial 1';
                                                   Description='QuoSII';


    }
    field(7174337;"QBU QuoSII Sales Special Regimen 2";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"));
                                                   CaptionML=ENU='Special Regimen 2',ESP='R‚gimen Especial 2';
                                                   Description='QuoSII';


    }
    field(7174338;"QBU QuoSII Sales Special Regimen";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("KeySpecialSalesInv"));
                                                   CaptionML=ENU='Special Regimen',ESP='R‚gimen Especial';
                                                   Description='QuoSII';


    }
    field(7174339;"QBU QuoSII Bienes Description";Text[40])
    {
        CaptionML=ENU='Bienes Description',ESP='Descripci¢n Bienes';
                                                   Description='QuoSII';


    }
    field(7174340;"QBU QuoSII Operator Address";Text[120])
    {
        CaptionML=ENU='Operator Address',ESP='Direcci¢n Operador';
                                                   Description='QuoSII';


    }
    field(7174341;"QBU QuoSII Last Ticket No.";Code[20])
    {
        CaptionML=ENU='Last Ticket No.',ESP='éltimo N§ Ticket';
                                                   Description='QuoSII';


    }
    field(7174342;"QBU QuoSII Third Party";Boolean)
    {
        CaptionML=ENU='Third Party',ESP='Emitida por tercero';
                                                   Description='QuoSII';


    }
    field(7174343;"QBU QuoSII First Ticket No.";Code[20])
    {
        CaptionML=ENU='First Ticket No.',ESP='Primer N§ Ticket';
                                                   Description='QuoSII';


    }
    field(7174348;"QBU QuoSII Operation Date";Date)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='SII Entity',ESP='Fecha operaci¢n';
                                                   Description='QuoSII 1.5d   JAV 12/04/21 Fecha de la operaci¢n';

trigger OnValidate();
    VAR
//                                                                 QuoSII@7174331 :
                                                                QuoSII: Integer;
//                                                                 PurchaseLine@7174332 :
                                                                PurchaseLine: Record 39;
//                                                                 txtQuoSII000@1100286000 :
                                                                txtQuoSII000: TextConst ESP='No se puede cambiar el campo %1 cuando existen l¡neas.';
                                                              BEGIN 
                                                              END;


    }
    field(7174365;"QBU QFA Period Start Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Periodo de Facturaci¢n Inicio';
                                                   Description='QFA JAV 20/03/21 - Fecha de inicio del periodo de facturaci¢n,Q13694';


    }
    field(7174366;"QBU QFA Period End Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Periodo de Facturaci¢n Final';
                                                   Description='QFA JAV 20/03/21 - Fecha de fin del periodo de facturaci¢n,Q13694';


    }
    field(7207270;"QBU QW Cod. Withholding by GE";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("G.E"));
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='C¢d. retenci¢n por B.E.';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207271;"QBU QW Cod. Withholding by PIT";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("PIT"));
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='C¢d. retenci¢n por IRPF';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207272;"QBU QW Total Withholding GE";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line"."QW Withholding Amount by GE" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E.';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"QBU QW Total Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line"."QW Withholding Amount by PIT" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding PIT',ESP='Total retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207274;"QBU QW Total Receivable";Decimal)
    {
        CaptionML=ENU='Total Receivable',ESP='Total a cobrar';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207275;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='No. proyecto';
                                                   Description='QB 1.00 - QB2412';


    }
    field(7207276;"QBU Job Sale Doc. Type";Option)
    {
        OptionMembers="Standar","Equipament Advance","Advance by Store","Price Review";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job Sale Doc. Type',ESP='Tipo doc. venta proyecto';
                                                   OptionCaptionML=ENU='Standar,Equipament Advance,Advance by Store,Price Review',ESP='Estandar,Anticipo de maquinaria,Anticipo por acopios,Revisi¢n precios';
                                                   
                                                   Description='QB 1.00 - QB28123';


    }
    field(7207279;"QBU Payment bank No.";Code[20])
    {
        TableRelation="Bank Account"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment bank No.',ESP='N§ de banco de pago';
                                                   Description='QB 1.00 - Q3707';


    }
    field(7207282;"QBU QW Withholding mov liq.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Liquida mov. retenci¢n n§';
                                                   Description='QB 1.04 - JAV 26/05/20: Que movimiento de retenci¢n de garant¡a liquida esta factura';


    }
    field(7207289;"QBU Prepayment Data";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Datos del Anticipo Aplicado';
                                                   Description='QB 1.10.49 JAV 13/06/22: [TT] Indica el c¢digo de los datos aplicados del anticipo al documento';


    }
    field(7207296;"QBU QW Base Withholding GE";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line"."QW Base Withholding by GE" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Base retenci¢n B.E.';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207297;"QBU QW Base Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line"."QW Base Withholding by PIT" WHERE ("Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding PIT',ESP='Base retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207298;"QBU QW Total Withholding GE Before";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line".Amount WHERE ("Document No."=FIELD("No."),
                                                                                                      "QW Withholding by GE Line"=CONST(true)));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E. Fra.';
                                                   Description='QB 1.00 - JAV 23/10/19: - Se doblan los campos de la retenci¢n de B.E. para tener ambos importes disponibles';
                                                   Editable=false;


    }
    field(7207306;"QBU SII Year-Month";Text[7])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='SII Ejercicio-Periodo';
                                                   Description='QB 1.05 - JAV Ejercicio y periodo en que se declar  en el SII de Microsoft';
                                                   Editable=false;


    }
    field(7207307;"QBU Certification code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certification code',ESP='C¢d. certificaci¢n';
                                                   Description='QB 1.06 - Nro de la certificaci¢n generada';


    }
    field(7207313;"QBU QW Witholding Due Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Vto. Retenci¢n';
                                                   Description='QB 1.06.07 - JAV 30/07/20: - Fecha de vencimiento de la retenci¢n de buena ejecuci¢n' ;


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
   // key(key3;"Return Order No.")
  //  {
       /* ;
 */
   // }
   // key(key4;"Sell-to Customer No.")
  //  {
       /* ;
 */
   // }
   // key(key5;"Prepayment Order No.")
  //  {
       /* ;
 */
   // }
   // key(key6;"Bill-to Customer No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Sell-to Customer No.","Bill-to Customer No.","Posting Date","Posting Description")
   // {
       // 
   // }
   // fieldgroup(Brick;"No.","Sell-to Customer Name","Amount","Due Date","Amount Including VAT")
   // {
       // 
   // }
}
  
    var
//       SalesCommentLine@1001 :
      SalesCommentLine: Record 44;
//       CustLedgEntry@1002 :
      CustLedgEntry: Record 21;
//       ApprovalsMgmt@1004 :
      ApprovalsMgmt: Codeunit 1535;
//       DimMgt@1005 :
      DimMgt: Codeunit 408;
//       UserSetupMgt@1006 :
      UserSetupMgt: Codeunit 5700;
//       DocTxt@1000 :
      DocTxt: TextConst ENU='Credit Memo',ESP='Abono';

    
    


/*
trigger OnDelete();    var
//                PostedDeferralHeader@1002 :
               PostedDeferralHeader: Record 1704;
//                PostSalesDelete@1000 :
               PostSalesDelete: Codeunit 363;
//                DeferralUtilities@1001 :
               DeferralUtilities: Codeunit 1720;
             begin
               PostSalesDelete.IsDocumentDeletionAllowed("Posting Date");
               TESTFIELD("No. Printed");
               LOCKTABLE;
               PostSalesDelete.DeleteSalesCrMemoLines(Rec);

               SalesCommentLine.SETRANGE("Document Type",SalesCommentLine."Document Type"::"Posted Credit Memo");
               SalesCommentLine.SETRANGE("No.","No.");
               SalesCommentLine.DELETEALL;

               ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
               PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetSalesDeferralDocType,'','',
                 SalesCommentLine."Document Type"::"Posted Credit Memo","No.");
             end;

*/




/*
procedure SendRecords ()
    var
//       DocumentSendingProfile@1001 :
      DocumentSendingProfile: Record 60;
//       DummyReportSelections@1000 :
      DummyReportSelections: Record 77;
//       IsHandled@1002 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeSendRecords(DummyReportSelections,Rec,DocTxt,IsHandled);
      if IsHandled then
        exit;

      DocumentSendingProfile.SendCustomerRecords(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,DocTxt,"Bill-to Customer No.","No.",
        FIELDNO("Bill-to Customer No."),FIELDNO("No."));
    end;
*/


    
//     procedure SendProfile (var DocumentSendingProfile@1000 :
    
/*
procedure SendProfile (var DocumentSendingProfile: Record 60)
    var
//       DummyReportSelections@1002 :
      DummyReportSelections: Record 77;
//       IsHandled@1001 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeSendProfile(DummyReportSelections,Rec,DocTxt,IsHandled,DocumentSendingProfile);
      if IsHandled then
        exit;

      DocumentSendingProfile.Send(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,"No.","Bill-to Customer No.",
        DocTxt,FIELDNO("Bill-to Customer No."),FIELDNO("No."));
    end;
*/


    
//     procedure PrintRecords (ShowRequestPage@1000 :
    
/*
procedure PrintRecords (ShowRequestPage: Boolean)
    var
//       DocumentSendingProfile@1002 :
      DocumentSendingProfile: Record 60;
//       DummyReportSelections@1001 :
      DummyReportSelections: Record 77;
//       IsHandled@1003 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforePrintRecords(DummyReportSelections,Rec,ShowRequestPage,IsHandled);
      if IsHandled then
        exit;

      DocumentSendingProfile.TrySendToPrinter(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,FIELDNO("Bill-to Customer No."),ShowRequestPage);
    end;
*/


    
//     procedure EmailRecords (ShowRequestPage@1000 :
    
/*
procedure EmailRecords (ShowRequestPage: Boolean)
    var
//       DocumentSendingProfile@1002 :
      DocumentSendingProfile: Record 60;
//       DummyReportSelections@1001 :
      DummyReportSelections: Record 77;
//       IsHandled@1003 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeEmailRecords(DummyReportSelections,Rec,DocTxt,ShowRequestPage,IsHandled);
      if IsHandled then
        exit;

      DocumentSendingProfile.TrySendToEMail(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,FIELDNO("No."),DocTxt,FIELDNO("Bill-to Customer No."),ShowRequestPage);
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
procedure LookupAdjmtValueEntries ()
    var
//       ValueEntry@1000 :
      ValueEntry: Record 5802;
    begin
      ValueEntry.SETCURRENTKEY("Document No.");
      ValueEntry.SETRANGE("Document No.","No.");
      ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Credit Memo");
      ValueEntry.SETRANGE(Adjustment,TRUE);
      PAGE.RUNMODAL(0,ValueEntry);
    end;
*/


    
    
/*
procedure GetCustomerVATRegistrationNumber () : Text;
    begin
      exit("VAT Registration No.");
    end;
*/


    
    
/*
procedure GetCustomerVATRegistrationNumberLbl () : Text;
    begin
      exit(FIELDCAPTION("VAT Registration No."));
    end;
*/


    
    
/*
procedure GetCustomerGlobalLocationNumber () : Text;
    begin
      exit('');
    end;
*/


    
    
/*
procedure GetCustomerGlobalLocationNumberLbl () : Text;
    begin
      exit('');
    end;
*/


    
    
/*
procedure GetLegalStatement () : Text;
    var
//       SalesSetup@1000 :
      SalesSetup: Record 311;
    begin
      SalesSetup.GET;
      exit(SalesSetup.GetLegalStatement);
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
      if UserSetupMgt.GetSalesFilter <> '' then begin
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
        FILTERGROUP(0);
      end;
    end;
*/


    
    
/*
procedure GetDocExchStatusStyle () : Text;
    begin
      CASE "Document Exchange Status" OF
        "Document Exchange Status"::"not Sent":
          exit('Standard');
        "Document Exchange Status"::"Sent to Document Exchange Service":
          exit('Ambiguous');
        "Document Exchange Status"::"Delivered to Recipient":
          exit('Favorable');
        else
          exit('Unfavorable');
      end;
    end;
*/


    
    
/*
procedure ShowActivityLog ()
    var
//       ActivityLog@1000 :
      ActivityLog: Record 710;
    begin
      ActivityLog.ShowEntries(RECORDID);
    end;
*/


    
    
/*
procedure DocExchangeStatusIsSent () : Boolean;
    begin
      exit("Document Exchange Status" <> "Document Exchange Status"::"not Sent");
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
//       SalesInvHeader@1001 :
      SalesInvHeader: Record 112;
    begin
      CALCFIELDS(Cancelled);
      if not Cancelled then
        exit;

      if CancelledDocument.FindSalesCancelledCrMemo("No.") then begin
        SalesInvHeader.GET(CancelledDocument."Cancelled By Doc. No.");
        PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader);
      end;
    end;
*/


    
    
/*
procedure ShowCancelledInvoice ()
    var
//       CancelledDocument@1000 :
      CancelledDocument: Record 1900;
//       SalesInvHeader@1001 :
      SalesInvHeader: Record 112;
    begin
      CALCFIELDS(Corrective);
      if not Corrective then
        exit;

      if CancelledDocument.FindSalesCorrectiveCrMemo("No.") then begin
        SalesInvHeader.GET(CancelledDocument."Cancelled Doc. No.");
        PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader);
      end;
    end;
*/


    
    
/*
procedure GetWorkDescription () : Text;
    var
      TempBlob : Codeunit "Temp Blob";
Blob : OutStream;
InStr : InStream;

//       CR@1004 :
      CR: Text[1];
    begin
      CALCFIELDS("Work Description");
      if not "Work Description".HASVALUE then
        exit('');

      CR[1] := 10;
      // TempBlob.Blob := "Work Description";
//To be tested

TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
Blob.Write("Work Description");
      // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
//To be tested

TempBlob.CreateInStream(InStr, TextEncoding::Windows);
InStr.Read(CR);
exit(CR);
    end;
*/


    
//     LOCAL procedure OnBeforeEmailRecords (ReportSelections@1003 : Record 77;SalesCrMemoHeader@1002 : Record 114;DocTxt@1004 : Text;ShowDialog@1001 : Boolean;var IsHandled@1000 :
    
/*
LOCAL procedure OnBeforeEmailRecords (ReportSelections: Record 77;SalesCrMemoHeader: Record 114;DocTxt: Text;ShowDialog: Boolean;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforePrintRecords (ReportSelections@1003 : Record 77;SalesCrMemoHeader@1002 : Record 114;ShowRequestPage@1001 : Boolean;var IsHandled@1000 :
    
/*
LOCAL procedure OnBeforePrintRecords (ReportSelections: Record 77;SalesCrMemoHeader: Record 114;ShowRequestPage: Boolean;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeSendProfile (ReportSelections@1003 : Record 77;SalesCrMemoHeader@1002 : Record 114;DocTxt@1001 : Text;var IsHandled@1000 : Boolean;var DocumentSendingProfile@1004 :
    
/*
LOCAL procedure OnBeforeSendProfile (ReportSelections: Record 77;SalesCrMemoHeader: Record 114;DocTxt: Text;var IsHandled: Boolean;var DocumentSendingProfile: Record 60)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeSendRecords (ReportSelections@1000 : Record 77;SalesCrMemoHeader@1001 : Record 114;DocTxt@1002 : Text;var IsHandled@1003 :
    
/*
LOCAL procedure OnBeforeSendRecords (ReportSelections: Record 77;SalesCrMemoHeader: Record 114;DocTxt: Text;var IsHandled: Boolean)
    begin
    end;

    /*begin
    //{
//      QuoSII1.4 23/04/18 PEL - Cambiado primer semestre en Sales Invoice Type, Sales Invoice Type 1 y Sales Invoice Type 2
//      MCG 19/07/18: - Q3707 A¤adido campo "Payment bank No."
//      JAV 23/10/19: - Se a¤aden los campos "Base Withholding G.E", "Base Withholding PIT" y "Total Withholding G.E Before"
//      Q13694 QMD 23/06/21 - Errores y pendientes de QuoSII - Se a¤ade campos
//      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.).  NewFields: 50900, 50901
//      BS::20668 CSM 04/01/24 Í VEN027 Modificar importe retenci¢n en venta.
//      BS::21212 CSM 18/03/24 Í VEN017 Inf. Clientes previsi¢n tesorer¡a V3-CR.  New Field: 50003
//    }
    end.
  */
}





