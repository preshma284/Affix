tableextension 50178 "QBU Approval EntryExt" extends "Approval Entry"
{
  
  
    CaptionML=ENU='Approval Entry',ESP='Movimiento aprobaci¢n';
  
  fields
{
    field(50000;"QBU Fecha Recepci¢n";Date)
    {
        DataClassification=ToBeClassified;
                                                   Description='Q20198';


    }
    field(50001;"QBU Journal Template Name";Code[10])
    {
        TableRelation="Gen. Journal Template";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Journal Template Name',ESP='Nombre libro diario';
                                                   Description='QB::20411';
                                                   Editable=false;


    }
    field(50002;"QBU Journal Batch Name";Code[10])
    {
        TableRelation="Gen. Journal Batch"."Name" WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Journal Batch Name',ESP='Nombre secci¢n diario';
                                                   Description='QB::20411';
                                                   Editable=false;


    }
    field(50003;"QBU Journal Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Line No.',ESP='N§ l¡nea diario';
                                                   Description='QB::20411';
                                                   Editable=false;


    }
    field(50004;"QBU Cust/Vendor No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Customer / Vendor No.',ESP='Filtro N§ Cliente / Proveedor';
                                                   Description='Q21733';
                                                   Editable=false;


    }
    field(50005;"QBU Cust/Vendor Name";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Customer / Vendor Name',ESP='Filtro Nombre Cliente / Proveedor';
                                                   Description='Q21733';
                                                   Editable=false;


    }
    field(50006;"QBU Job Description";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Job"."Description" WHERE ("No."=FIELD("Job No.")));
                                                   CaptionML=ENU='Job Description',ESP='Descripci¢n Proyecto';
                                                   Description='Q21733';
                                                   Editable=false;


    }
    field(50007;"QBU Piecework Desc.";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Data Piecework For Production"."Description" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Piecework Code"=FIELD("QB_Piecework No.")));
                                                   CaptionML=ENU='Piecework Desc.',ESP='Desc. Unidad Obra';
                                                   Description='Q21733';
                                                   Editable=false;


    }
    field(7207270;"QBU Posted Sheet";Boolean)
    {
        CaptionML=ENU='Posted Sheet',ESP='Parte registrado';
                                                   Description='QB 1.00 - QB2713';


    }
    field(7207271;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Proyecto/Departamento';
                                                   Description='QB 1.00 - JAV 09/09/19: - Para conocer el proyecto o el departamento de origen de la aprobaci¢n';
                                                   Editable=false;


    }
    field(7207272;"QBU Payment Terms Code";Code[10])
    {
        TableRelation="Payment Terms";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Terms Code',ESP='C¢d. t‚rminos pago';
                                                   Description='QB 1.00 - JAV 11/09/19: - T‚rminos de pago del documento';
                                                   Editable=false;


    }
    field(7207273;"QBU Payment Method Code";Code[10])
    {
        TableRelation="Payment Method";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment Method Code',ESP='C¢d. forma pago';
                                                   Description='QB 1.00 - JAV 11/09/19: - Forma de pago del documento';
                                                   Editable=false;


    }
    field(7207274;"QBU Type";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de aprobaci¢n';
                                                   Description='QB 1.00 - JAV 16/03/20: - Se a¤ade el campo Type, que indica el tipo de aprobaci¢n a mostrar en la pantalla';


    }
    field(7207275;"QBU Withholding";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Retenido';
                                                   Description='QB 1.03 - JAV 09/05/20: - Pago retenido';


    }
    field(7207276;"QBU Document Type";Option)
    {
        OptionMembers=" ","Job","Comparative","Payment","PaymentDueCert","Worksheet","Expense","Measeurement","Transfer","Purchase","PurchaseInvoice","Payment Order","PurchaseCredirMemo","Budget","Prepayment","Withholding","Efect Ratio";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Type',ESP='Tipo documento QuoBuilding';
                                                   OptionCaptionML=ENU='" ,Job,Comparative Quotes,Payment,Certificate Due Payment,Worksheet,Expense Note,Measurement,Transfer into Jobs,Purchase Order,Purchase Invoice,Payment Order,Purchase Credit Memo,Budgets,Prepayment,Withholding,Efect Ratio"',ESP='" ,Proyecto,Compartivo de ofertas,Pago,Pago con Cert. Vencido,Parte de trabajo,Nota de gasto,Medici¢n,Tanspaso entre proyectos,Pedido de Compra,Factura de Compra,Orden de Pago,Abono de Compra,Presupuesto,Anticipo,Retenci¢n,Relaci¢n de efectos"';
                                                   
                                                   Description='QB 1.03 - JAV 10/05/20: - Nuevo campo con las tablas que se aprueban en QuoBuilding  JAV 23/10/20 QB 1.07.00 Se a¤ade la Orden de Pago  JAV 29/03/22 QB 1.10.29 Se a¤aden anticipos';


    }
    field(7207277;"QBU Substituted";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Substituido';
                                                   Description='QB 1.07.17 JAV 24/12/20: - Se ha substituido el aprobado';


    }
    field(7207278;"QBU Original Approver";Code[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobador Original';
                                                   Description='QB 1.07.17 JAV 24/12/20: - Aprobador original antes de substituir';


    }
    field(7207279;"QBU Position";Code[10])
    {
        TableRelation="QB Position";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Cargo';
                                                   Description='QB 1.10.22 JAV 02/03/22: - Cargo de la persona que aprueba';


    }
    field(7238210;"QBU Piecework No.";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢d. U.O./Partida Pres.';
                                                   Description='QB 1.10.22 JAV 02/03/22: - QRE15411  JAV 03/11/22 QB 1.12.12 Se cambia el caption' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Record ID to Approve","Workflow Step Instance ID","Sequence No.")
  //  {
       /* ;
 */
   // }
   // key(key3;"Table ID","Document Type","Document No.","Sequence No.","Record ID to Approve")
  //  {
       /* ;
 */
   // }
   // key(key4;"Approver ID","Status","Due Date","Date-Time Sent for Approval")
  //  {
       /* ;
 */
   // }
   // key(key5;"Sender ID")
  //  {
       /* ;
 */
   // }
   // key(key6;"Due Date")
  //  {
       /* ;
 */
   // }
   // key(key7;"Table ID","Record ID to Approve","Status","Workflow Step Instance ID","Sequence No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       UserMgt@1000 :
      UserMgt: Codeunit 418;
//       PageManagement@1001 :
      PageManagement: Codeunit 700;
//       RecNotExistTxt@1002 :
      RecNotExistTxt: TextConst ENU='The record does not exist.',ESP='El registro no existe.';
//       ChangeRecordDetailsTxt@1003 :
      ChangeRecordDetailsTxt: 
// "Prefix = Record information %1 = field caption %2 = old value %3 = new value. Example: Customer 123455; Credit Limit changed from 100.00 to 200.00"
TextConst ENU='; %1 changed from %2 to %3',ESP='; %1 cambiado de %2 a %3';

    
    


/*
trigger OnModify();    begin
               "Last Date-Time Modified" := CREATEDATETIME(TODAY,TIME);
               "Last Modified By User ID" := USERID;
             end;


*/

/*
trigger OnDelete();    var
//                NotificationEntry@1000 :
               NotificationEntry: Record 1511;
             begin
               NotificationEntry.SETRANGE(Type,NotificationEntry.Type::Approval);
               NotificationEntry.SETRANGE("Triggered By Record",RECORDID);
               NotificationEntry.DELETEALL(TRUE);
             end;

*/




/*
procedure ShowRecord ()
    var
//       RecRef@1000 :
      RecRef: RecordRef;
    begin
      if not RecRef.GET("Record ID to Approve") then
        exit;
      RecRef.SETRECFILTER;
      PageManagement.PageRun(RecRef);
    end;
*/


    
    
/*
procedure RecordCaption () : Text;
    var
//       AllObjWithCaption@1000 :
      AllObjWithCaption: Record 2000000058;
//       RecRef@1002 :
      RecRef: RecordRef;
//       PageNo@1001 :
      PageNo: Integer;
    begin
      if not RecRef.GET("Record ID to Approve") then
        exit;
      PageNo := PageManagement.GetPageID(RecRef);
      if PageNo = 0 then
        exit;
      AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Page,PageNo);
      exit(STRSUBSTNO('%1 %2',AllObjWithCaption."Object Caption","Document No."));
    end;
*/


    
    
/*
procedure RecordDetails () Details : Text;
    var
//       SalesHeader@1001 :
      SalesHeader: Record 36;
//       PurchHeader@1000 :
      PurchHeader: Record 38;
//       RecRef@1002 :
      RecRef: RecordRef;
//       ChangeRecordDetails@1003 :
      ChangeRecordDetails: Text;
    begin
      if not RecRef.GET("Record ID to Approve") then
        exit(RecNotExistTxt);

      ChangeRecordDetails := GetChangeRecordDetails;

      CASE RecRef.NUMBER OF
        DATABASE::"Sales Header":
          begin
            RecRef.SETTABLE(SalesHeader);
            SalesHeader.CALCFIELDS(Amount);
            Details :=
              STRSUBSTNO(
                '%1 ; %2: %3',SalesHeader."Sell-to Customer Name",SalesHeader.FIELDCAPTION(Amount),SalesHeader.Amount);
          end;
        DATABASE::"Purchase Header":
          begin
            RecRef.SETTABLE(PurchHeader);
            PurchHeader.CALCFIELDS(Amount);
            Details :=
              STRSUBSTNO(
                '%1 ; %2: %3',PurchHeader."Buy-from Vendor Name",PurchHeader.FIELDCAPTION(Amount),PurchHeader.Amount);
          end;
        else
          Details := FORMAT("Record ID to Approve",0,1) + ChangeRecordDetails;
      end;

      OnAfterGetRecordDetails(RecRef,ChangeRecordDetails,Details);
    end;
*/


    
    
/*
procedure IsOverdue () : Boolean;
    begin
      exit((Status IN [Status::Created,Status::Open]) and ("Due Date" < TODAY));
    end;
*/


    
//     procedure GetCustVendorDetails (var CustVendorNo@1002 : Code[20];var CustVendorName@1003 :
    
/*
procedure GetCustVendorDetails (var CustVendorNo: Code[20];var CustVendorName: Text[50])
    var
//       PurchaseHeader@1000 :
      PurchaseHeader: Record 38;
//       SalesHeader@1001 :
      SalesHeader: Record 36;
//       Customer@1005 :
      Customer: Record 18;
//       RecRef@1004 :
      RecRef: RecordRef;
    begin
      if not RecRef.GET("Record ID to Approve") then
        exit;

      CASE "Table ID" OF
        DATABASE::"Purchase Header":
          begin
            RecRef.SETTABLE(PurchaseHeader);
            CustVendorNo := PurchaseHeader."Pay-to Vendor No.";
            CustVendorName := PurchaseHeader."Pay-to Name";
          end;
        DATABASE::"Sales Header":
          begin
            RecRef.SETTABLE(SalesHeader);
            CustVendorNo := SalesHeader."Bill-to Customer No.";
            CustVendorName := SalesHeader."Bill-to Name";
          end;
        DATABASE::Customer:
          begin
            RecRef.SETTABLE(Customer);
            CustVendorNo := Customer."No.";
            CustVendorName := Customer.Name;
          end;
      end;
    end;
*/


    
    
/*
procedure GetChangeRecordDetails () ChangeDetails : Text;
    var
//       WorkflowRecordChange@1000 :
      WorkflowRecordChange: Record 1525;
//       OldValue@1001 :
      OldValue: Text;
//       NewValue@1002 :
      NewValue: Text;
    begin
      WorkflowRecordChange.SETRANGE("Record ID","Record ID to Approve");
      WorkflowRecordChange.SETRANGE("Workflow Step Instance ID","Workflow Step Instance ID");

      if WorkflowRecordChange.FINDSET then
        repeat
          WorkflowRecordChange.CALCFIELDS("Field Caption");
          NewValue := WorkflowRecordChange.GetFormattedNewValue(TRUE);
          OldValue := WorkflowRecordChange.GetFormattedOldValue(TRUE);
          ChangeDetails += STRSUBSTNO(ChangeRecordDetailsTxt,WorkflowRecordChange."Field Caption",
              OldValue,NewValue);
        until WorkflowRecordChange.NEXT = 0;
    end;
*/


    
    
/*
procedure CanCurrentUserEdit () : Boolean;
    var
//       UserSetup@1000 :
      UserSetup: Record 91;
    begin
      if not UserSetup.GET(USERID) then
        exit(FALSE);
      exit((UserSetup."User ID" IN ["Sender ID","Approver ID"]) or UserSetup."Approval Administrator");
    end;
*/


    
    
/*
procedure MarkAllWhereUserisApproverOrSender ()
    var
//       UserSetup@1000 :
      UserSetup: Record 91;
    begin
      if UserSetup.GET(USERID) and UserSetup."Approval Administrator" then
        exit;
      FILTERGROUP(-1); // Used to support the cross-column search
      SETRANGE("Approver ID",USERID);
      SETRANGE("Sender ID",USERID);
      if FINDSET then
        repeat
          MARK(TRUE);
        until NEXT = 0;
      MARKEDONLY(TRUE);
      FILTERGROUP(0);
    end;

    [Integration(TRUE)]
*/

//     LOCAL procedure OnAfterGetRecordDetails (RecRef@1001 : RecordRef;ChangeRecordDetails@1000 : Text;var Details@1002 :
    
/*
LOCAL procedure OnAfterGetRecordDetails (RecRef: RecordRef;ChangeRecordDetails: Text;var Details: Text)
    begin
    end;

    /*begin
    //{
//      JAV 09/09/19: - Se a¤ade el campo 7207271 "Job No." para conocer el proyecto de origen de la aprobaci¢n
//      JAV 11/09/19:-  Se a¤aden los campos 7207272 "Payment Terms Code" y 7207273 "Payment Method Code"
//      JAV 14/10/19: - QMD 22/05/19 QBAPG Aprobaciones para QB, se a¤ade a la lista de tipos de documento el valor "Cartera Doc"
//      JAV 16/03/20: - Se a¤ade el campo Type, que indica el tipo de aprobaci¢n a mostrar en la pantalla
//      JAV 02/03/22: - QB 1.10.22 Se a¤aden la columna "QB Position"
//      JAV 29/03/22: - QB 1.10.29 Se a¤aden anticipos al option de documento para QB
//      JAV 27/10/22: - QB 1.12.09 Se a¤ade la columna "QB_Piecework No." que estaba en ya en los clientes
//      JAV 03/11/22: - QB 1.12.12 Se cambia el caption del campo 7238210 "QB_Piecework No."
//      JAV 13/12/22: - QB 1.12.26 Se a¤ade el tipo para Retenciones en "QB Document Type"
//      PGM 11/05/23: 19400 A¤adido una opci¢n mas en el campo "QB Document Type"
//      BS::20411 CSM 22/01/24 Í PYC028 Estado de aprobaci¢n en l¡neas de diarios pagos.
//      JDC 15/03/24  - Q21733 Added field 50004 "Cust/Vendor No."
//                             Added field 50005 "Cust/Vendor Name"
//                             Added field 50006 "Job Description"
//                             Added field 50007 "Piecework Desc."
//    }
    end.
  */
}





