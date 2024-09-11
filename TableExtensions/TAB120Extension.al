tableextension 50136 "QBU Purch. Rcpt. HeaderExt" extends "Purch. Rcpt. Header"
{
  
  DataCaptionFields="No.","Buy-from Vendor Name";
    CaptionML=ENU='Purch. Rcpt. Header',ESP='Hist¢rico cab. albar n compra';
    LookupPageID="Posted Purchase Receipts";
    DrillDownPageID="Posted Purchase Receipts";
  
  fields
{
    field(50005;"QBU Vendor Credit Exceeded";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Vendor Credit Exceeded',ESP='Cr‚dito proveedor superado';
                                                   Description='BS::20087';
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
    field(7207285;"QBU Contract";Boolean)
    {
        CaptionML=ENU='Contrato',ESP='Contrato';
                                                   Description='QB 1.00 - QB2515';


    }
    field(7207289;"QBU Receive in FRIS";Boolean)
    {
        CaptionML=ENU='Receive in FRIS',ESP='Recibir en FRIS';
                                                   Description='QB 1.00 - QB2517';
                                                   Editable=false;


    }
    field(7207292;"QBU Cancelled";Boolean)
    {
        CaptionML=ENU='Voided',ESP='Anulado';
                                                   Description='QB 1.00';
                                                   Editable=false;


    }
    field(7207293;"QBU No. Receipt Cancel";Code[20])
    {
        CaptionML=ENU='No. Recieving Void',ESP='N§ albaran que anula';
                                                   Description='QB 1.00';


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
    field(7207330;"QBU Have Proforms";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Exist("QB Proform Header" WHERE ("Order No."=FIELD("Order No.")));
                                                   CaptionML=ESP='Tiene proformas';
                                                   Description='QB 1.08.48 - JAV 06/06/21 Si el documento tiene proformas generadas';
                                                   Editable=false;


    }
    field(7207333;"QBU Total Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.10.11 - JAV 21/01/22 Temporal para el informe, se calcula en el momento. Importe total del albar n';


    }
    field(7207334;"QBU Invoiced Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.10.11 - JAV 21/01/22 Temporal para el informe, se calcula en el momento. Importe facturado del albar n';


    }
    field(7207335;"QBU Accounted Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.10.11 - JAV 21/01/22 Temporal para el informe, se calcula en el momento. Importe contabilziado';


    }
    field(7207339;"QBU Canceled By";Code[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Usuario que lo cancel¢';
                                                   Description='QB 1.10.38 - JAV 28/04/22: [TT] Indica el usuario que cancel¢ completamente el albar n';
                                                   Editable=false;


    }
    field(7207340;"QBU Canceled in Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha en que se Cancel¢';
                                                   Description='QB 1.10.38 - JAV 28/04/22: [TT] Indica la fecha en que se cancel¢ completamente el albar n';
                                                   Editable=false;


    }
    field(7207341;"QBU Canceled With Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha con la que se Cancel¢';
                                                   Description='QB 1.10.38 - JAV 28/04/22: [TT] Indica la fecha con la que se cancel¢ completamente el albar n';
                                                   Editable=false;


    }
    field(7207700;"QBU Stocks New Functionality";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='New_Functionality',ESP='Nueva Funcionalidad Stocks';
                                                   Description='QB_ST01';


    }
    field(7238177;"QBU Budget item";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='QPR' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Order No.")
  //  {
       /* ;
 */
   // }
   // key(key3;"Pay-to Vendor No.")
  //  {
       /* ;
 */
   // }
   // key(key4;"Buy-from Vendor No.")
  //  {
       /* ;
 */
   // }
   // key(key5;"Posting Date")
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
//       PurchRcptHeader@1000 :
      PurchRcptHeader: Record 120;
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
//                PostPurchDelete@1000 :
               PostPurchDelete: Codeunit 364;
             begin
               LOCKTABLE;
               PostPurchDelete.DeletePurchRcptLines(Rec);

               PurchCommentLine.SETRANGE("Document Type",PurchCommentLine."Document Type"::Receipt);
               PurchCommentLine.SETRANGE("No.","No.");
               PurchCommentLine.DELETEALL;
               ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
             end;

*/



// procedure PrintRecords (ShowRequestForm@1000 :

/*
procedure PrintRecords (ShowRequestForm: Boolean)
    var
//       ReportSelection@1001 :
      ReportSelection: Record 77;
    begin
      WITH PurchRcptHeader DO begin
        COPY(Rec);
        ReportSelection.PrintWithGUIYesNoVendor(
          ReportSelection.Usage::"P.Receipt",PurchRcptHeader,ShowRequestForm,FIELDNO("Buy-from Vendor No."));
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

    /*begin
    //{
//      JAV 21/01/22: - QB 1.10.11 Se eliminan campos relacionados con el contrato que no son utilizados en el programa para nada
//                                 Se a¤aden campos con totales para el informe
//      AML 22/02/03 QB_ST01 Se a¤ade campo New_Functionality
//      BS::20087 CSM 09/11/23 Í COM039 Env¡o correo a proveedor Superaci¢n Cr‚dito M ximo. New Field: 50005.
//    }
    end.
  */
}





