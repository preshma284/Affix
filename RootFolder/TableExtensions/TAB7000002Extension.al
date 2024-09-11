tableextension 50222 "MyExtension50222" extends "Cartera Doc."
{
  
  /*
Permissions=TableData 7000002 rm;
*/
    CaptionML=ENU='Cartera Doc.',ESP='Doc. cartera';
    LookupPageID="Cartera Documents";
    DrillDownPageID="Cartera Documents";
  
  fields
{
    field(50011;"Comentarios filtro";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Comment Filter',ESP='Comentarios filtro';
                                                   Description='BS::19798';
                                                   Editable=false;


    }
    field(50012;"Notas filtro";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Notas filtro',ESP='Notas filtro';
                                                   Description='BS::19798';
                                                   Editable=false;


    }
    field(7207273;"Unrisk Amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Riesgo no asegurado';
                                                   Description='QB 1.06.15 - JAV 23/09/20 Parte del riesgo de la factura no cubierta por el Factoring';
                                                   Editable=false;


    }
    field(7207274;"Category";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Customer"."QB Category" WHERE ("No."=FIELD("Account No.")));
                                                   CaptionML=ESP='Categor¡a';
                                                   Description='QB 1.06.15 - PGR 28/09/20: - Categor¡a del cliente';
                                                   CaptionClass='7206910,18,7207284';


    }
    field(7207275;"Sub-Category";Code[20])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Customer"."QB Sub-Category" WHERE ("No."=FIELD("Account No.")));
                                                   CaptionML=ESP='Sub-Categor¡a';
                                                   Description='QB 1.06.15 - PGR 28/09/20: - Sub-Categor¡a del cliente';
                                                   CaptionClass='7206910,18,7207306';


    }
    field(7207276;"Document Date";Date)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("G/L Entry"."Document Date" WHERE ("Document No."=FIELD("Document No."),
                                                                                                         "External Document No."=FILTER(<>'')));
                                                   CaptionML=ENU='External Document',ESP='Fecha del Documento';
                                                   Description='QB 1.06.19 - JAV 08/10/20: - Fecha de la factura de compra';
                                                   Editable=false;


    }
    field(7207279;"QB Payment bank No.";Code[20])
    {
        TableRelation="Bank Account"."No.";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Payment bank No.',ESP='N§ de banco de cobro o pago';
                                                   Description='QB 1.00 - Q3707';

trigger OnValidate();
    VAR
//                                                                 QBCodeunitSubscriber@1100286000 :
                                                                QBCodeunitSubscriber: Codeunit 7207353;
                                                              BEGIN 
                                                                //Si cambiamos el banco lo cambio en la factura, en el movimiento y en cartera
                                                                //JAV 31/03/22: - QB 1.10.29 Se a¤ade par metro en la llamada a la funci¢n
                                                                QBCodeunitSubscriber.ChangeVendorBank("Document No.", xRec."QB Payment bank No.", "QB Payment bank No.", TRUE, FALSE);
                                                              END;


    }
    field(7207290;"Job No.";Code[20])
    {
        CaptionML=ENU='Job No.',ESP='No. Proyecto';
                                                   Description='QB 1.00 - JAV 08/03/20: - N£mero del proyecto';
                                                   Editable=false;


    }
    field(7207291;"External Document No.";Code[35])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("G/L Entry"."External Document No." WHERE ("Document No."=FIELD("Document No."),
                                                                                                                 "External Document No."=FILTER(<>'')));
                                                   CaptionML=ENU='External Document',ESP='No. Documento Externo';
                                                   Description='QB 1.00 - JAV 08/03/20: - N£mero de documento externo de la factura de compra';
                                                   Editable=false;


    }
    field(7207292;"Customer Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Customer"."Name" WHERE ("No."=FIELD("Account No.")));
                                                   CaptionML=ENU='Customer Name',ESP='Nombre Cliente';
                                                   Description='QB 1.00 - JAV 12/03/20: - DP17a Nombre del cliente';
                                                   Editable=false;


    }
    field(7207293;"Vendor Name";Text[50])
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Vendor"."Name" WHERE ("No."=FIELD("Account No.")));
                                                   CaptionML=ENU='Vendor Name',ESP='Nombre Proveedor';
                                                   Description='QB 1.00 - JAV 12/03/20: - DP17a Nombre del proveedor';
                                                   Editable=false;


    }
    field(7207295;"Obralia Entry";Integer)
    {
        TableRelation="Obralia Log Entry";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Obralia User ID',ESP='Obralia';
                                                   Description='QB 1.05.06 - JAV 23/07/20 : - Entrada en el registro de Obralia';
                                                   Editable=false;

trigger OnValidate();
    VAR
//                                                                 ObraliaLogEntry@1100286000 :
                                                                ObraliaLogEntry: Record 7206904;
//                                                                 PurchasesPayablesSetup@1100286001 :
                                                                PurchasesPayablesSetup: Record 312;
//                                                                 ApprovalCarteraDoc@1100286002 :
                                                                ApprovalCarteraDoc: Codeunit 7206917;
                                                              BEGIN 
                                                                ObraliaLogEntry.GET("Obralia Entry");
                                                                PurchasesPayablesSetup.GET;

                                                                IF (ObraliaLogEntry.IsSemaphorGreen) AND ("OLD_Approval Coment" = txtQB000) THEN BEGIN 
                                                                  IF NOT (Rec."Approval Status" IN [Rec."Approval Status"::"Pending Approval",Rec."Approval Status"::"Due Pending Approval"]) THEN
                                                                    ApprovalCarteraDoc.PerformManualReopen(Rec);
                                                                  "OLD_Approval Situation" := Rec."OLD_Approval Situation"::Pending;
                                                                  "OLD_Approval Coment" := '';
                                                                END;

                                                                IF (ObraliaLogEntry.IsSemaphorRed) THEN BEGIN 
                                                                  IF NOT (Rec."Approval Status" IN [Rec."Approval Status"::"Pending Approval",Rec."Approval Status"::"Due Pending Approval"]) THEN
                                                                    ApprovalCarteraDoc.PerformManualReopen(Rec);
                                                                  "OLD_Approval Situation" := Rec."OLD_Approval Situation"::Rejected;
                                                                  "OLD_Approval Coment" := txtQB000;
                                                                END;

                                                                MODIFY;
                                                              END;


    }
    field(7207298;"Approval Status";Option)
    {
        OptionMembers="Open","Released","Pending Approval","Due Open","Due Released","Due Pending Approval";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Status',ESP='Estado Aprobaci¢n';
                                                   OptionCaptionML=ENU='Open,Released,Pending Approval,Due Open,Due Released,Due Pending Approval',ESP='Abierto,Lanzado,Aprobaci¢n pendiente,Cert.Ven. Abierto,Cert.Ven. Lanzado,Cert.Ven. Aprobaci¢n pendiente';
                                                   
                                                   Description='QB 1.00 - JAV 14/10/19: - Se a¤ade el campo de Status a partir de QBAPP   JAV 02/03/20: - Aprobaci¢n para certificados vencidos';
                                                   Editable=false;


    }
    field(7207299;"OLD_Approval Situation";Option)
    {
        OptionMembers="Pending","Approved","Rejected","Withheld";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Status',ESP='Situaci¢n de la Aprobaci¢n';
                                                   OptionCaptionML=ESP='Pendiente,Aprobado,Rechazado,Retenido';
                                                   
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207300;"OLD_Approval Coment";Text[80])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Comentario Aprobaci¢n';
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207301;"OLD_Approval Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha aprobaci¢n';
                                                   Description='###ELIMINAR### no se usa';


    }
    field(7207302;"Approval Check 1";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n, Check 1';
                                                   Description='QB 1.05 - Aprobaciones';
                                                   CaptionClass='7206910,7000002,7207302';


    }
    field(7207303;"Approval Check 2";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n, Check 2';
                                                   Description='QB 1.05 - Aprobaciones';
                                                   CaptionClass='7206910,7000002,7207303';


    }
    field(7207304;"Approval Check 3";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n, Check 3';
                                                   Description='QB 1.05 - Aprobaciones';
                                                   CaptionClass='7206910,7000002,7207304';


    }
    field(7207305;"Approval Check 4";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n, Check 4';
                                                   Description='QB 1.05 - Aprobaciones';
                                                   CaptionClass='7206910,7000002,7207305';


    }
    field(7207306;"Approval Check 5";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Aprobaci¢n, Check 5';
                                                   Description='QB 1.05 - Aprobaciones';
                                                   CaptionClass='7206910,7000002,7207306';


    }
    field(7207336;"QB Approval Circuit Code";Code[20])
    {
        TableRelation="QB Approval Circuit Header" WHERE ("Document Type"=CONST("Payments"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Approval Circuit Code',ESP='Circuito de Aprobaci¢n';
                                                   Description='QB 1.10.22 - Aprobaciones';


    }
    field(7238177;"QB Budget item";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Account Type"=FILTER("Unit"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='QB 1.10.22 - Aprobaciones' ;


    }
}
  keys
{
   // key(key1;"Type","Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Type","Document No.")
  //  {
       /* ;
 */
   // }
   // key(key3;"Type","Collection Agent","Bill Gr./Pmt. Order No.","Currency Code","Accepted","Due Date","Place")
  //  {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(key4;"Type","Bill Gr./Pmt. Order No.","Category Code","Currency Code","Accepted","Due Date")
  //  {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(No5;"Type","Bill Gr./Pmt. Order No.","Global Dimension 1 Code","Global Dimension 2 Code","Currency Code","Accepted","Due Date","Place")
   // {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(No6;"Type","Bill Gr./Pmt. Order No.","Global Dimension 1 Code","Global Dimension 2 Code","Category Code","Currency Code","Accepted","Due Date")
   // {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(key7;"Type","Bill Gr./Pmt. Order No.","Category Code","Currency Code","Account No.","Due Date","Document Type")
  //  {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(key8;"Type","Bill Gr./Pmt. Order No.","Category Code","Currency Code","Accepted","Account No.","Due Date","Document Type")
  //  {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(key9;"Type","Collection Agent","Bill Gr./Pmt. Order No.","Currency Code","Accepted","Due Date","Place","Document Type")
  //  {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(key10;"Type","Bill Gr./Pmt. Order No.","Collection Agent","Due Date","Global Dimension 1 Code","Global Dimension 2 Code","Category Code","Posting Date","Document No.","Accepted","Currency Code","Document Type","Payment Method Code")
  //  {
       /* SumIndexFields="Remaining Amount","Remaining Amt. (LCY)";
 */
   // }
   // key(key11;"Type","Bill Gr./Pmt. Order No.","Transfer Type")
  //  {
       /* ;
 */
   // }
   // key(key12;"Type","Bill Gr./Pmt. Order No.","Transfer Type","Account No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       BillGr@1100002 :
      BillGr: Record 7000005;
//       PmtOrd@1100003 :
      PmtOrd: Record 7000020;
//       ElectPmtMgmt@1100000 :
      ElectPmtMgmt: Codeunit 10701;
//       Text001@1100001 :
      Text001: TextConst ENU='%1 is more than the legal limit of %2 days after the document date %3 for the original document',ESP='%1 es superior al l¡mite legal de %2 d¡as despu‚s de la fecha de documento %3 del documento original';
//       "----------------------- QB"@1100286000 :
      "----------------------- QB": TextConst;
//       txtQB000@1100286001 :
      txtQB000: TextConst ESP='Rechazado por Obralia';

    


/*
trigger OnInsert();    begin
               if Type = Type::Payable then
                 ElectPmtMgmt.GetTransferType("Account No.","Remaining Amount","Transfer Type",FALSE);
             end;


*/

/*
trigger OnModify();    begin
               TESTFIELD("Elect. Pmts Exported",FALSE);
             end;


*/

/*
trigger OnDelete();    var
//                CarteraManagement@1100000 :
               CarteraManagement: Codeunit 7000000;
             begin
               TESTFIELD("Elect. Pmts Exported",FALSE);
               SETRANGE(Type,Type);
               SETRANGE("Entry No.","Entry No.");

               //JAV No dar error si no est  en una relaci¢n
               if ("Bill Gr./Pmt. Order No." <> '') then
                 CASE Type OF
                   Type::Payable:
                     CarteraManagement.RemovePayableDocs(Rec);
                   Type::Receivable:
                     CarteraManagement.RemoveReceivableDocs(Rec);
                 end;
             end;


*/

/*
trigger OnRename();    begin
               TESTFIELD("Elect. Pmts Exported",FALSE);
             end;

*/




/*
procedure ResetNoPrinted ()
    begin
      if "Bill Gr./Pmt. Order No." <> '' then
        if Type = Type::Receivable then begin
          BillGr.GET("Bill Gr./Pmt. Order No.");
          BillGr."No. Printed" := 0;
          BillGr.MODIFY;
        end else begin
          PmtOrd.GET("Bill Gr./Pmt. Order No.");
          PmtOrd."No. Printed" := 0;
          PmtOrd.MODIFY;
        end;
    end;
*/


    
/*
procedure ShowDimensions ()
    var
//       DimMgt@1100000 :
      DimMgt: Codeunit 408;
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',Type,"Entry No.","Document No."));
    end;
*/


    
/*
procedure CheckDueDate ()
    var
//       InvoiceSplitPayment@1100004 :
      InvoiceSplitPayment: Codeunit 7000005;
//       DocumentDate@1100006 :
      DocumentDate: Date;
//       MaxNoOfDaysTillDueDate@1100000 :
      MaxNoOfDaysTillDueDate: Integer;
    begin
      GetDocumentDates(DocumentDate,MaxNoOfDaysTillDueDate);

      if not InvoiceSplitPayment.CheckDueDate("Due Date",DocumentDate,MaxNoOfDaysTillDueDate) then
        FIELDERROR("Due Date",STRSUBSTNO(Text001,"Due Date",MaxNoOfDaysTillDueDate,DocumentDate));
    end;
*/


//     LOCAL procedure GetDocumentDates (var DocumentDate@1100000 : Date;var MaxNoOfDaysTillDueDate@1100006 :
    
/*
LOCAL procedure GetDocumentDates (var DocumentDate: Date;var MaxNoOfDaysTillDueDate: Integer)
    var
//       PaymentTerms@1100005 :
      PaymentTerms: Record 3;
//       SalesInvoiceHeader@1100004 :
      SalesInvoiceHeader: Record 112;
//       ServiceInvoiceHeader@1100003 :
      ServiceInvoiceHeader: Record 5992;
//       PurchInvHeader@1100002 :
      PurchInvHeader: Record 122;
    begin
      CASE Type OF
        Type::Receivable:
          begin
            if SalesInvoiceHeader.GET("Document No.") then begin
              PaymentTerms.GET(SalesInvoiceHeader."Payment Terms Code");
              DocumentDate := SalesInvoiceHeader."Document Date";
            end else
              if ServiceInvoiceHeader.GET("Document No.") then begin
                PaymentTerms.GET(ServiceInvoiceHeader."Payment Terms Code");
                DocumentDate := ServiceInvoiceHeader."Document Date";
              end;
          end;
        Type::Payable:
          if PurchInvHeader.GET("Document No.") then begin
            PaymentTerms.GET(PurchInvHeader."Payment Terms Code");
            DocumentDate := PurchInvHeader."Document Date";
          end;
      end;

      MaxNoOfDaysTillDueDate := PaymentTerms."Max. No. of Days till Due Date";
    end;
*/


//     procedure UpdatePaymentMethodCode (DocumentNo@1100000 : Code[20];AccountNo@1100001 : Code[20];BillNo@1100002 : Code[20];PaymentMethodCode@1100003 :
    
/*
procedure UpdatePaymentMethodCode (DocumentNo: Code[20];AccountNo: Code[20];BillNo: Code[20];PaymentMethodCode: Code[10])
    var
//       CarteraDoc@1100004 :
      CarteraDoc: Record 7000002;
    begin
      WITH CarteraDoc DO begin
        SETRANGE("Document No.",DocumentNo);
        SETRANGE("Account No.",AccountNo);
        if  BillNo <> '' then begin
          SETRANGE("Document Type","Document Type"::Bill);
          SETRANGE("No.",BillNo);
        end else
          SETRANGE("Document Type","Document Type"::Invoice);
        if FINDFIRST and ("Bill Gr./Pmt. Order No." = '') then begin
          VALIDATE("Payment Method Code",PaymentMethodCode);
          MODIFY(TRUE);
        end;
      end;
    end;

    /*begin
    //{
//      PEL 13/06/18: - QB2395 Se crea nuevo campo --> Eliminado con las nuevas aprobaciones
//      PEL 19/03/19: - OBR Creados campos de Obralia
//      JAV 12/07/19: - Se aumenta de 20 a 35 el campo 50003 "External DocumentNo."
//      JAV 14/10/19: - Se a¤ade el campo de Status a partir de QBAPP
//      JAV 31/03/22: - QB 1.10.29 Se a¤ade par metro en la llamada a la funci¢n
//      CSM 05/07/22: - QB 1.11.00 (Q17589) Campo calculado Nombre Proveedor. Se cambia el caption en ingl‚s del nombre del cliente que era err¢neo
//      BS::19798 CSM 20/10/23  Í Campos filtrables Êcomentarios filtroË y Ênotas filtroË.  New Fields: 50011, 50012.
//    }
    end.
  */
}




