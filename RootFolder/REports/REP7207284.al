report 7207284 "QB Vendor PIT Retentions"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Vendor PIT Retentions',ESP='Retenciones de IRPF de Proveedores';
  
  dataset
{

DataItem("Withholding Movements";"Withholding Movements")
{

               DataItemTableView=SORTING("Entry No.")
                                 WHERE("Withholding Type"=CONST("PIT"),"Type"=CONST("Vendor"));
               

               RequestFilterFields="Type","Posting Date";
Column(FORMAT_TODAY;FORMAT(TODAY,0,4))
{
//SourceExpr=FORMAT(TODAY,0,4);
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(CurrReport_PAGENO;CurrReport.PAGENO)
{
//SourceExpr=CurrReport.PAGENO;
}Column(USERID;USERID)
{
//SourceExpr=USERID;
}Column(Vendor_Name;vendor.Name)
{
//SourceExpr=vendor.Name;
}Column(Vendor_VatRegistrationNo;vendor.FIELDCAPTION("VAT Registration No.")+': '+vendor."VAT Registration No.")
{
//SourceExpr=vendor.FIELDCAPTION("VAT Registration No.")+': '+vendor."VAT Registration No.";
}Column(Tax_Retention_Entry_Posting_Group;"Withholding Code")
{
//SourceExpr="Withholding Code";
}Column(Tax_Retention_Entry_Posting_Date;"Posting Date")
{
//SourceExpr="Posting Date";
}Column(Tax_Retention_Entry_Document_No;"Document No.")
{
//SourceExpr="Document No.";
}Column(Tax_Retention_Entry_Type;Type)
{
//SourceExpr=Type;
}Column(Tax_Retention_Entry_No;"No.")
{
//SourceExpr="No.";
}Column(Tax_Retention_Entry_Description;Description)
{
//SourceExpr=Description;
}Column(Tax_Retention_Entry_Base_IRPF;"Withholding Base")
{
//SourceExpr="Withholding Base";
}Column(Tax_Retention_Entry_Base_No_IRPF;0)
{
//SourceExpr=0;
}Column(Tax_Retention_Entry_Porc_IRPF;PorcIRPF)
{
//SourceExpr=PorcIRPF;
}Column(Tax_Retention_Entry_Retencion_IRPF;"Withholding Movements".Amount)
{
//SourceExpr="Withholding Movements".Amount;
}Column(Tax_Retention_Entry_Entry_No_;"Entry No.")
{
//SourceExpr="Entry No.";
}Column(myTotal3;myTotal3)
{
//SourceExpr=myTotal3;
}Column(myTotal2;myTotal2)
{
//SourceExpr=myTotal2;
}Column(myTotal;myTotal)
{
//SourceExpr=myTotal;
}Column(CAPTION_Report;Movimientos_de_Retenciones_de_IRPFCaptionLbl)
{
//SourceExpr=Movimientos_de_Retenciones_de_IRPFCaptionLbl;
}Column(CAPTION_PAGENO;CurrReport_PAGENOCaptionLbl)
{
//SourceExpr=CurrReport_PAGENOCaptionLbl;
}Column(CAPTION_TotalFor_Posting_Group;TotalFor + FIELDCAPTION("Withholding Code"))
{
//SourceExpr=TotalFor + FIELDCAPTION("Withholding Code");
}Column(CAPTION_Posting_Date;FIELDCAPTION("Posting Date"))
{
//SourceExpr=FIELDCAPTION("Posting Date");
}Column(CAPTION_Document_No;FIELDCAPTION("Document No."))
{
//SourceExpr=FIELDCAPTION("Document No.");
}Column(CAPTION_Type;FIELDCAPTION(Type))
{
//SourceExpr=FIELDCAPTION(Type);
}Column(CAPTION_No;FIELDCAPTION("No."))
{
//SourceExpr=FIELDCAPTION("No.");
}Column(CAPTION_Description;FIELDCAPTION(Description))
{
//SourceExpr=FIELDCAPTION(Description);
}Column(CAPTION_Base_IRPF;FIELDCAPTION("Withholding Base"))
{
//SourceExpr=FIELDCAPTION("Withholding Base");
}Column(CAPTION_Base_No_IRPF;'')
{
//SourceExpr='';
}Column(CAPTION_IRPFn;WithholdingGroup.FIELDCAPTION("Percentage Withholding"))
{
//SourceExpr=WithholdingGroup.FIELDCAPTION("Percentage Withholding");
}Column(CAPTION_Retencion_IRPF;"Withholding Movements".FIELDCAPTION(Amount))
{
//SourceExpr="Withholding Movements".FIELDCAPTION(Amount);
}Column(CAPTION_Posting_Group;FIELDCAPTION("Withholding Code"))
{
//SourceExpr=FIELDCAPTION("Withholding Code");
}Column(CAPTION_Total;'Total' )
{
//SourceExpr='Total' ;
}trigger OnPreDataItem();
    BEGIN 
                               LastFieldNo := FIELDNO("Withholding Movements"."No.");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  myTotal  += ROUND("Withholding Movements".Amount);
                                  myTotal2 += 0;
                                  myTotal3 += ROUND("Withholding Movements"."Withholding Base");

                                  IF NOT vendor.GET("No.") THEN
                                    CLEAR(vendor);

                                  PorcIRPF := 0;
                                  IF WithholdingGroup.GET("Withholding Movements"."Withholding Type", "Withholding Movements"."Withholding Code") THEN
                                    PorcIRPF := WithholdingGroup."Percentage Withholding";
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
}
  
    var
//       LastFieldNo@1100000 :
      LastFieldNo: Integer;
//       FooterPrinted@1100001 :
      FooterPrinted: Boolean;
//       TotalFor@1100002 :
      TotalFor: TextConst ESP='Total para ';
//       myTotal@1100003 :
      myTotal: Decimal;
//       myTotal2@1100004 :
      myTotal2: Decimal;
//       myTotal3@1100005 :
      myTotal3: Decimal;
//       Movimientos_de_Retenciones_de_IRPFCaptionLbl@1105424 :
      Movimientos_de_Retenciones_de_IRPFCaptionLbl: TextConst ESP='Movimientos de Retenciones de IRPF';
//       CurrReport_PAGENOCaptionLbl@1103005 :
      CurrReport_PAGENOCaptionLbl: TextConst ESP='P gina';
//       vendor@1000000000 :
      vendor: Record 23;
//       PorcIRPF@1100286000 :
      PorcIRPF: Decimal;
//       WithholdingGroup@1100286001 :
      WithholdingGroup: Record 7207330;

    /*begin
    end.
  */
  
}




