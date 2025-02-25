report 50009 "Costes Albaranes Compra"
{
  
  
    UseSystemPrinter=true;
    
  dataset
{

DataItem("Purch. Rcpt. Header";"Purch. Rcpt. Header")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
Column(CAB_Logo;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(CAB_VendorName;Vendor.Name)
{
//SourceExpr=Vendor.Name;
}Column(CAB_JobDescription;rJob.Description)
{
//SourceExpr=rJob.Description;
}Column(CAB_PostingDate;"Purch. Rcpt. Header"."Posting Date")
{
//SourceExpr="Purch. Rcpt. Header"."Posting Date";
}Column(CAB_OrderNo;"Purch. Rcpt. Header"."Order No.")
{
//SourceExpr="Purch. Rcpt. Header"."Order No.";
}DataItem("Purch. Rcpt. Line";"Purch. Rcpt. Line")
{

               DataItemTableView=SORTING("Document No.","Line No.");
DataItemLink="Document No."= FIELD("No.");
Column(LIN_Part;Part)
{
//SourceExpr=Part;
}Column(LIN_Code;Code_)
{
//SourceExpr=Code_;
}Column(LIN_MeasureUnit;MeasureUnit)
{
//SourceExpr=MeasureUnit;
}Column(LIN_ShortDescription;ShortDescription)
{
//SourceExpr=ShortDescription;
}Column(LIN_LargeDescription;LargeDescription)
{
//SourceExpr=LargeDescription;
}Column(LIN_UnitPrice;UnitPrice)
{
//SourceExpr=UnitPrice;
}Column(LIN_ContractMeasure;ContractMeasure)
{
//SourceExpr=ContractMeasure;
}Column(LIN_ContractAmount;ContractAmount)
{
//SourceExpr=ContractAmount;
}Column(LIN_MeasOrigin;MeasOrigin)
{
//SourceExpr=MeasOrigin;
}Column(LIN_MeasBefore;MeasBefore)
{
//SourceExpr=MeasBefore;
}Column(LIN_MeasMonth;MeasMonth)
{
//SourceExpr=MeasMonth;
}Column(LIN_ImportOrigin;ImportOrigin)
{
//SourceExpr=ImportOrigin;
}Column(LIN_ImportBefore;ImportBefore)
{
//SourceExpr=ImportBefore;
}Column(LIN_ImportMonth;ImportMonth)
{
//SourceExpr=ImportMonth;
}Column(LIN_WorkMeasure;WorkMeasure)
{
//SourceExpr=WorkMeasure;
}Column(LIN_WorkAmount;WorkAmount)
{
//SourceExpr=WorkAmount;
}Column(LIN_ContractAmountTotal;ContractAmountTotal)
{
//SourceExpr=ContractAmountTotal;
}Column(LIN_ImportOriginTotal;ImportOriginTotal)
{
//SourceExpr=ImportOriginTotal;
}Column(LIN_ImportBeforeTotal;ImportBeforeTotal)
{
//SourceExpr=ImportBeforeTotal;
}Column(LIN_ImportMonthTotal;ImportMonthTotal)
{
//SourceExpr=ImportMonthTotal;
}Column(LIN_WorkAmountTotal;WorkAmountTotal )
{
//SourceExpr=WorkAmountTotal ;
}trigger OnAfterGetRecord();
    BEGIN 
                                  //Q12868 -
                                  "Purch. Rcpt. Line".CALCFIELDS("Qty. Origin");

                                  PurchaseLine.RESET;
                                  PurchaseLine.SETRANGE("Document No.", "Purch. Rcpt. Line"."Order No.");
                                  PurchaseLine.SETRANGE("Line No.", "Purch. Rcpt. Line"."Order Line No.");
                                  IF PurchaseLine.FINDFIRST THEN;

                                  //Q12868 MOD02 -

                                  //{QBText.RESET;
//                                  QBText.SETRANGE(Table, 1);
//                                  QBText.SETRANGE(Key1, "Purch. Rcpt. Line"."Job No.");
//                                  QBText.SETRANGE(Key2, "Purch. Rcpt. Line"."Piecework N§");
//                                  IF QBText.FINDFIRST THEN BEGIN 
//                                    QBText.CALCFIELDS("Cost Text");
//                                    LargeDescription := GetWorkDescriptionWorkDescriptionCalculated;
//                                  END;}

                                  QBText.RESET;
                                  QBText.SETRANGE(Table, QBText.Table::Contrato);
                                  QBText.SETRANGE(Key1, "Purch. Rcpt. Line"."Document No.");
                                  QBText.SETRANGE(Key2, FORMAT("Purch. Rcpt. Line"."Line No."));
                                  IF QBText.FINDFIRST THEN BEGIN 
                                    LargeDescription := QBText.GetCostText();
                                  END ELSE BEGIN 
                                    QBText.RESET;
                                    QBText.SETRANGE(Table, QBText.Table::Job);
                                    QBText.SETRANGE(Key1, "Purch. Rcpt. Line"."Job No.");
                                    QBText.SETRANGE(Key2, "Purch. Rcpt. Line"."Piecework NÂº");
                                    IF QBText.FINDFIRST THEN BEGIN 
                                      LargeDescription := QBText.GetCostText();
                                    END;
                                  END;

                                  //Q12868 MOD02 +

                                  //Q12868 MOD01 -
                                  //Part                := "Purch. Rcpt. Line"."Budgeted FA No.";
                                  Part                := "Purch. Rcpt. Line"."Piecework NÂº";
                                  //Q12868 MOD01 +
                                  Code_                := "Purch. Rcpt. Line"."No.";
                                  MeasureUnit         := "Purch. Rcpt. Line"."Unit of Measure";
                                  ShortDescription    := "Purch. Rcpt. Line".Description;
                                  UnitPrice           := "Purch. Rcpt. Line"."Direct Unit Cost";
                                  ContractMeasure     := PurchaseLine.Quantity;
                                  ContractAmount      := PurchaseLine."Amount Including VAT";
                                  MeasOrigin          := "Purch. Rcpt. Line"."Qty. Origin";
                                  MeasMonth           := "Purch. Rcpt. Line".Quantity;
                                  MeasBefore          := MeasOrigin - MeasMonth;
                                  //Q12868 MOD01 -
                                  //{ImportOrigin        := "Purch. Rcpt. Line"."Qty. Origin" * "Purch. Rcpt. Line"."Direct Unit Cost";
//                                  ImportMonth         := "Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost";
//                                  ImportBefore        := ImportOrigin - ImportMonth;}
                                  ImportOrigin        := ROUND("Purch. Rcpt. Line"."Qty. Origin" * "Purch. Rcpt. Line"."Direct Unit Cost");
                                  ImportMonth         := ROUND("Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost");
                                  ImportBefore        := ROUND(ImportOrigin - ImportMonth);
                                  //Q12868 MOD01 +
                                  WorkMeasure         := ContractMeasure - MeasOrigin;
                                  WorkAmount          := ContractAmount - ImportOrigin;

                                  ContractAmountTotal += ContractAmount;
                                  ImportOriginTotal   += ImportOrigin;
                                  ImportBeforeTotal   += ImportBefore;
                                  ImportMonthTotal    += ImportMonth;
                                  WorkAmountTotal     += WorkAmount;
                                  //Q12868 -
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               CLEAR(Part);
                               CLEAR(LargeDescription);
                               CLEAR(Code_);
                               CLEAR(MeasureUnit);
                               CLEAR(ShortDescription);
                               CLEAR(UnitPrice);
                               CLEAR(ContractMeasure);
                               CLEAR(ContractAmount);
                               CLEAR(MeasOrigin);
                               CLEAR(MeasBefore);
                               CLEAR(MeasMonth);
                               CLEAR(ImportOrigin);
                               CLEAR(ImportBefore);
                               CLEAR(ImportMonth);
                               CLEAR(WorkMeasure);
                               CLEAR(WorkAmount);
                               CLEAR(ContractAmountTotal);
                               CLEAR(ImportOriginTotal);
                               CLEAR(ImportBeforeTotal);
                               CLEAR(ImportMonthTotal);
                               CLEAR(WorkAmountTotal);
                               //Q12868 -
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  //Q12868 -

                                  IF NOT rJob.GET("Purch. Rcpt. Header"."Job No.") THEN
                                    rJob.INIT;

                                  IF NOT Vendor.GET("Purch. Rcpt. Header"."Buy-from Vendor No.") THEN
                                    Vendor.INIT;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
LBLPart='PART/ PARTIDA/';
LBLCode='CODE/ CàDIGO/';
LBLUM='U.M./ U.M./';
LBLDescription='DESCRIPTION/ DESCRIPCIàN/';
LBLPrice='UNIT PRICE/ PRECIO UNITARIO/';
LBLContrating='CONTRATING/ CONTRATACIàN/';
LBLMeasure='MEASUREMENT/ MEDICIàN/';
LBLAmount='AMOUNT/ IMPORTE/';
LBLPendingWork='PENDING WORK/ OBRA PENDIENTE/';
LBLOrigin='ORIGIN/ ORIGEN/';
LBLBefore='BEFORE/ ANTERIOR/';
LBLMonth='MONTH/ MES/';
LBLWork='Work/ Obra/';
LBLSubContract='Subcontract Name/ Subcontratista/';
LBLContractDate='Contract Date/ Fecha contrato/';
LBLContract='Contract/ Contrato/';
LBLRelationTitle='SUB CONTRACT PRE INVOICE RELATION/ RELACIàN PROFORMA DE SUBCONTRATISTA/';
LBLTotals='TOTALS/ TOTALES/';
LBLSignWorkChief='"Sign of Wrk Chief: "/ "Firma del jefe de obra: "/';
}
  
    var
//       Part@1000000000 :
      Part: Code[20];
//       MeasureUnit@1000000002 :
      MeasureUnit: Code[20];
//       ShortDescription@1000000003 :
      ShortDescription: Text;
//       LargeDescription@1000000004 :
      LargeDescription: Text;
//       UnitPrice@1000000005 :
      UnitPrice: Decimal;
//       ContractMeasure@1000000006 :
      ContractMeasure: Decimal;
//       ContractAmount@1000000007 :
      ContractAmount: Decimal;
//       MeasOrigin@1000000008 :
      MeasOrigin: Decimal;
//       MeasBefore@1000000011 :
      MeasBefore: Decimal;
//       MeasMonth@1000000010 :
      MeasMonth: Decimal;
//       ImportOrigin@1000000009 :
      ImportOrigin: Decimal;
//       ImportBefore@1000000015 :
      ImportBefore: Decimal;
//       ImportMonth@1000000014 :
      ImportMonth: Decimal;
//       WorkMeasure@1000000013 :
      WorkMeasure: Decimal;
//       WorkAmount@1000000012 :
      WorkAmount: Decimal;
//       PurchaseHeader@1000000016 :
      PurchaseHeader: Record 38;
//       PurchaseLine@1000000017 :
      PurchaseLine: Record 39;
//       QBText@1000000018 :
      QBText: Record 7206918;
//       Code_@1100286004 :
      Code_: Text;
//       Vendor@1100286005 :
      Vendor: Record 23;
//       ContractAmountTotal@1100286028 :
      ContractAmountTotal: Decimal;
//       ImportOriginTotal@1100286027 :
      ImportOriginTotal: Decimal;
//       ImportBeforeTotal@1100286026 :
      ImportBeforeTotal: Decimal;
//       ImportMonthTotal@1100286025 :
      ImportMonthTotal: Decimal;
//       WorkAmountTotal@1100286024 :
      WorkAmountTotal: Decimal;
//       CompanyInformation@1100286030 :
      CompanyInformation: Record 79;
//       rJob@1100286000 :
      rJob: Record 167;

    

trigger OnPreReport();    begin

                  //Q12868 -

                  if CompanyInformation.GET then
                    CompanyInformation.CALCFIELDS(Picture);

                  //Q12868 +
                end;



/*begin
    {

      Q12868 HAN 23/02/21 Nuevo report costes albaranes
      Q12868 MOD01 HAN 10/03/21 Corrections of requisites
      Q12868 MOD02 HAN 11/03/21 More corrections
    }
    end.
  */
  
}



