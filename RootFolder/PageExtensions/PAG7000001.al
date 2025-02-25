pageextension 50251 MyExtension7000001 extends 7000001//7000002
{
layout
{
addafter("Account No.")
{
    field("Category";rec."Category")
    {
        
}
    field("Sub-Category";rec."Sub-Category")
    {
        
}
} addafter("Entry No.")
{
    field("QB_VendorName";rec."Customer Name")
    {
        
}
    field("QB_JobNo";rec."Job No.")
    {
        
}
    field("QB_PaymentBankNo";rec."QB Payment bank No.")
    {
        
}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payment bank No."))
    {
        
                CaptionML=ENU='Own Bank Name',ESP='Nombre del banco propio';
                Enabled=false ;
}
}

}

actions
{


}

//trigger

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
      "---------------------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;

    

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
//Local procedure AfterGetCurrentRecord();
//    begin
//      xRec := Rec;
//      UpdateStatistics;
//    end;

//procedure
}

