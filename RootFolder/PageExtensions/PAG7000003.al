pageextension 50253 MyExtension7000003 extends 7000003//7000002
{
layout
{
addafter("CategoryFilter")
{
    field("QB_DateFilter";"DateFilter")
    {
        
                CaptionML=ENU='Due Date Filter',ESP='Filtro Fecha Vto.';
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 10/04/22: - QB 1.10.34 Se cambia el campo "filtro fecha" para que sea "filtro fecha vto." y funcione correctamente
                             Rec.SETFILTER("Due Date", DateFilter);
                             CurrPage.UPDATE(TRUE);
                           END;


}
} addfirst("Control1")
{
    field("QB_ApprovalCheck1";rec."Approval Check 1")
    {
        
                Visible=vApp1;
                Editable=edAppAd ;
}
    field("QB_ApprovalCheck2";rec."Approval Check 2")
    {
        
                Visible=vApp2;
                Editable=edAppAd ;
}
    field("QB_ApprovalCheck3";rec."Approval Check 3")
    {
        
                Visible=vApp3;
                Editable=edAppAd ;
}
    field("QB_ApprovalCheck4";rec."Approval Check 4")
    {
        
                Visible=vApp4;
                Editable=edAppAd ;
}
    field("QB_ApprovalCheck5";rec."Approval Check 5")
    {
        
                Visible=vApp5;
                Editable=edAppAd ;
}
    field("QB_ApprovalStatus";rec."Approval Status")
    {
        
                StyleExpr=Style2 ;
}
    field("QB_CertificadosVencidos";"txtCert")
    {
        
                CaptionML=ESP='Certificados Vencidos';
                Editable=false;
                StyleExpr=Style3 ;
}
    field("Job No.";rec."Job No.")
    {
        
}
} addafter("Direct Debit Mandate ID")
{
    field("ObraliaLogEntry.GetResponsePagos";ObraliaLogEntry.GetResponsePagos)
    {
        
                CaptionML=ESP='Semaforo';
                Visible=vObralia;
                Editable=FALSE;
                StyleExpr=ObraliaStyle;
                
                              ;trigger OnAssistEdit()    VAR
                               ObraliaLogEntry : Record 7206904;
                             BEGIN
                               ObraliaLogEntry.ViewResponse(rec."Obralia Entry");
                             END;


}
} addafter("Document No.")
{
    field("QB_ExternalDocumentNo";rec."External Document No.")
    {
        
                ApplicationArea=Basic,Suite;
                StyleExpr=Style1 ;
}
    field("QB_Type";rec."Type")
    {
        
                Visible=False;
                StyleExpr=Style1 ;
}
} addafter("Account No.")
{
    field("QB_AccountName";"AccountName")
    {
        
                CaptionML=ENU='Account Name',ESP='Nombre';
                ToolTipML=ENU='Specifies the account name of the customer/vendor associated with this document.',ESP='Especifica el nombre de cuenta del cliente o el proveedor asociado a este documento.';
                ApplicationArea=Basic,Suite;
                Editable=FALSE;
                StyleExpr=Style1 ;
}
} addafter("Description")
{
    field("QB_CustVendorBankAccCode";rec."Cust./Vendor Bank Acc. Code")
    {
        
                StyleExpr=Style1 ;
}
    field("QB_PaymentBankNo";rec."QB Payment bank No.")
    {
        
                Editable=false ;
}
    field("QB_PaymentBankName";FunctionQB.GetBankName(rec."QB Payment bank No."))
    {
        
                CaptionML=ENU='Own Bank Name',ESP='Nombre del banco propio';
                Enabled=false ;
}
}


modify("Document Type")
{
StyleExpr=Style1 ;


}


modify("Collection Agent")
{
StyleExpr=Style1 ;


}


modify("Accepted")
{
StyleExpr=Style1 ;


}


modify("Posting Date")
{
StyleExpr=Style1 ;


}


modify("Due Date")
{
StyleExpr=Style1 ;


}


modify("Payment Method Code")
{
StyleExpr=Style1 ;


}


modify("Document No.")
{
StyleExpr=Style1 ;


}


modify("Account No.")
{
StyleExpr=Style1 ;


}


modify("No.")
{
StyleExpr=Style1 ;


}


modify("Description")
{
StyleExpr=Style1 ;


}


modify("Original Amount (LCY)")
{
StyleExpr=Style1 ;


}


modify("Original Amount")
{
StyleExpr=Style1 ;


}


modify("Remaining Amt. (LCY)")
{
StyleExpr=Style1 ;


}


modify("Remaining Amount")
{
StyleExpr=Style1 ;


}


modify("Currency Code")
{
StyleExpr=Style1 ;


}


modify("Place")
{
StyleExpr=Style1 ;


}


modify("Category Code")
{
StyleExpr=Style1 ;


}


modify("Entry No.")
{
StyleExpr=Style1 ;


}


modify("Direct Debit Mandate ID")
{
StyleExpr=Style1 ;


}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 cuApproval.SetCheckVisible(vApp1,vApp2,vApp3,vApp4,vApp5);
                 CategoryFilter := Rec.GETFILTER("Category Code");
                 UpdateStatistics;

                 //QB
                 FunctionQB.SetUserJobCarteraDocFilter(Rec);                 //JAV 26/01/21: - QB Filtro de proyectos permitidos para el usuario

                 //Q19458-
                 vObralia := (FunctionQB.AccessToObralia);                   //Obralia
                 //Q19458+
               END;


//trigger

var
      Text1100000 : TextConst ENU='Payable Bills cannot be printed.',ESP='No se pueden imprimir los efectos a pagar.';
      Text1100001 : TextConst ENU='Only Receivable Bills can be rejected.',ESP='S¢lo se pueden impagar efectos a cobrar.';
      Text1100002 : TextConst ENU='Only  Bills can be rejected.',ESP='S¢lo se pueden impagar efectos.';
      Doc : Record 7000002;
      CustLedgEntry : Record 21;
      SalesInvHeader : Record 112;
      PurchInvHeader : Record 122;
      CarteraManagement : Codeunit 7000000;
      CategoryFilter : Code[250];
      CurrTotalAmountLCY : Decimal;
      ShowCurrent : Boolean;
      CurrTotalAmountVisible : Boolean ;
      QBPagePublisher : Codeunit 7207348;
      DateFilter : Text[250];
      txtCert : Text;
      QualityManagement : Codeunit 7207293;
      Style1 : Text;
      Style2 : Text;
      Style3 : Text;
      "---------------------------- QB" : Integer;
      BankName : Text;
      FunctionQB : Codeunit 7207272;
      "---------------------------- Aprobaciones" : Integer;
      cuApproval : Codeunit 7206917;
      vApp1 : Boolean;
      vApp2 : Boolean;
      vApp3 : Boolean;
      vApp4 : Boolean;
      vApp5 : Boolean;
      edAppAd : Boolean;
      AccountName : Text[50];
      "----------------------------- Obralia" : Integer;
      Job : Record 167;
      vObralia : Boolean;
      aObralia : Boolean;
      ObraliaLogEntry : Record 7206904;
      ObraliaStyle : Text;

    

//procedure
//procedure UpdateStatistics();
//    begin
//      Doc.COPY(Rec);
//      CarteraManagement.UpdateStatistics(Doc,CurrTotalAmountLCY,ShowCurrent);
//      CurrTotalAmountVisible := ShowCurrent;
//    end;
//
//    //[External]
//procedure GetSelected(var NewDoc : Record 7000002);
//    begin
//      CurrPage.SETSELECTIONFILTER(NewDoc);
//    end;
//
//    //[External]
//procedure PrintDoc();
//    begin
//      CurrPage.SETSELECTIONFILTER(Doc);
//      if ( not Doc.FIND('-')  )then
//        exit;
//
//      if ( (Doc.Type <> Doc.Type::ivable) and (Doc."Document Type" = Doc."Document Type"::Bill)  )then
//        ERROR(Text1100000);
//
//      if ( Doc.Type = Doc.Type::ivable  )then begin
//        if ( Doc."Document Type" = Doc."Document Type"::Bill  )then begin
//          CustLedgEntry.RESET;
//          repeat
//            CustLedgEntry.GET(Doc."Entry No.");
//            CustLedgEntry.MARK(TRUE);
//          until Doc.NEXT = 0;
//
//          CustLedgEntry.MARKEDONLY(TRUE);
//          CustLedgEntry.PrintBill(TRUE);
//        end ELSE begin
//          SalesInvHeader.RESET;
//          repeat
//            SalesInvHeader.GET(Doc."Document No.");
//            SalesInvHeader.MARK(TRUE);
//          until Doc.NEXT = 0;
//
//          SalesInvHeader.MARKEDONLY(TRUE);
//          SalesInvHeader.PrintRecords(TRUE);
//        end;
//      end ELSE begin
//        PurchInvHeader.RESET;
//        repeat
//          PurchInvHeader.GET(Doc."Document No.");
//          PurchInvHeader.MARK(TRUE);
//        until Doc.NEXT = 0;
//
//        PurchInvHeader.MARKEDONLY(TRUE);
//        PurchInvHeader.PrintRecords(TRUE);
//      end;
//    end;
//
//    //[External]
//procedure Reject();
//    begin
//      if ( Doc.Type <> Doc.Type::ivable  )then
//        ERROR(Text1100001);
//      if ( Doc."Document Type" <> rec."Document Type"::Bill  )then
//        ERROR(Text1100002);
//
//      CurrPage.SETSELECTIONFILTER(Doc);
//      if ( not Doc.FIND('-')  )then
//        exit;
//
//      CustLedgEntry.RESET;
//      repeat
//        CustLedgEntry.GET(Doc."Entry No.");
//        CustLedgEntry.MARK(TRUE);
//      until Doc.NEXT = 0;
//
//      CustLedgEntry.MARKEDONLY(TRUE);
//      REPORT.RUNMODAL(REPORT::"Reject Docs.",TRUE,FALSE,CustLedgEntry);
//    end;
//Local procedure CategoryFilterOnAfterValidate();
//    begin
//      Rec.SETFILTER("Category Code",CategoryFilter);
//      CurrPage.UPDATE(FALSE);
//      UpdateStatistics;
//    end;
LOCAL procedure AfterGetCurrentRecord();
    var
      BankAccount : Record 270;
    begin
      xRec := Rec;
      UpdateStatistics;

      //Presentar los certificados vencidos y colores por aprobaciones
      QualityManagement.VendorCertificatesDued(rec."Account No.", TODAY, txtCert);

      Style1 := 'none';
      Style2 := 'none';
      Style3 := 'none';

      if ( (rec."Approval Status" IN [rec."Approval Status"::Open,rec."Approval Status"::"Pending Approval"])  )then begin
        Style1 := 'Attention';
        Style2 := 'Attention';
      end;

      if ( (rec."Approval Status" <> rec."Approval Status"::"Due Released") and (txtCert <> '')  )then begin
        Style1 := 'Attention';
        Style3 := 'Attention';
      end;

      if ( BankAccount.GET(rec."QB Payment bank No.")  )then
        BankName := BankAccount.Name
      ELSE
        BankName := '';

      //17589 CSM 05/07/22 Í Campo calculado Nombre Proveedor. -
      Rec.CALCFIELDS("Vendor Name", "Customer Name");
      if ( rec."Type" = rec."Type"::Payable  )then begin
        AccountName := rec."Vendor Name";
      end ELSE begin
        AccountName := rec."Customer Name";
      end;
      //17589 CSM 05/07/22 Í Campo calculado Nombre Proveedor. +

      //Q1958-
      if ( not ObraliaLogEntry.GET(rec."Obralia Entry")  )then
        ObraliaLogEntry.INIT
      ELSE
        ObraliaStyle := ObraliaLogEntry.GetResponseStyle;

      aObralia := FALSE;
      if ( Job.GET(rec."Job No.")  )then
        aObralia := (Job."Obralia Code" <> '');
      //Q19458+

      //JAV 28/06/22: - QB 1.10.54 Obtener si los checks adicionales son editables
      edAppAd := cuApproval.CheckEditables(Rec);
    end;

//procedure
}

