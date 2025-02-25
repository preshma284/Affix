report 50037 "Vesta: Production Measurement"
{
  
  
    CaptionML=ENU='Product. Measurement',ESP='Vesta: Relaci¢n Valorada';
    
  dataset
{

DataItem("Prod. Measure Header";"Prod. Measure Header")
{

               DataItemTableView=SORTING("No.");
               RequestFilterHeadingML=ENU='Product. Measurement',ESP='Medici¢n producci¢n';
               

               RequestFilterFields="No.";
Column(ProdMeasureHeader_N_;"No.")
{
//SourceExpr="No.";
}Column(Picture_CompanyInformation;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(ProdMeasureHeader_N;"Prod. Measure Header"."No.")
{
//SourceExpr="Prod. Measure Header"."No.";
}Column(ProdMeasureHeader_Job;"Prod. Measure Header"."Job No." + ' ' + "Prod. Measure Header".Description + ' ' + "Prod. Measure Header"."Description 2")
{
//SourceExpr="Prod. Measure Header"."Job No." + ' ' + "Prod. Measure Header".Description + ' ' + "Prod. Measure Header"."Description 2";
}Column(ProdMeasureHeader_MeasureDate;"Prod. Measure Header"."Measure Date")
{
//SourceExpr="Prod. Measure Header"."Measure Date";
}Column(ProdMeasureHeader_MeasureReference;"Prod. Measure Header"."Measurement No.")
{
//SourceExpr="Prod. Measure Header"."Measurement No.";
}Column(ProdMeasureHeader_MeasureText;"Prod. Measure Header"."Measurement Text")
{
//SourceExpr="Prod. Measure Header"."Measurement Text";
}Column(ProdMeasureHeader_Customer;"Prod. Measure Header"."Customer No." + ' ' + Customer.Name)
{
//SourceExpr="Prod. Measure Header"."Customer No." + ' ' + Customer.Name;
}Column(CustomerCaption;CustomerCaptionLbl)
{
//SourceExpr=CustomerCaptionLbl;
}Column(ProdMeasureCaption;ProdMeasureCaptionLbl)
{
//SourceExpr=ProdMeasureCaptionLbl;
}Column(ProdMeasureHeader_JobN_Caption;"Prod. Measure Header".FIELDCAPTION("Job No."))
{
//SourceExpr="Prod. Measure Header".FIELDCAPTION("Job No.");
}Column(ProdMeasureHeader_MeasureDate_Caption;"Prod. Measure Header".FIELDCAPTION("Measure Date"))
{
//SourceExpr="Prod. Measure Header".FIELDCAPTION("Measure Date");
}Column(ProdMeasureHeader_MeasureReference_Caption;"Prod. Measure Header".FIELDCAPTION("Measurement No."))
{
//SourceExpr="Prod. Measure Header".FIELDCAPTION("Measurement No.");
}Column(ProdMeasureHeader_MeasureText_Caption;"Prod. Measure Header".FIELDCAPTION("Measurement Text"))
{
//SourceExpr="Prod. Measure Header".FIELDCAPTION("Measurement Text");
}DataItem("Prod. Measure Lines";"Prod. Measure Lines")
{

               DataItemTableView=SORTING("Document No.","Line No.");
DataItemLink="Document No."= FIELD("No.");
Column(ProdMeasureLines_Piecework_N;"Piecework No.")
{
//SourceExpr="Piecework No.";
}Column(ProdMeasureLines_Description;Description + ' ' + "Description 2")
{
//SourceExpr=Description + ' ' + "Description 2";
}Column(ProdMeasureLines_ProgressToSource;"% Progress To Source")
{
//SourceExpr="% Progress To Source";
}Column(ProdMeasureLines_Measute_Term;"Measure Term")
{
//SourceExpr="Measure Term";
}Column(ProdMeasureLines_Source_Measure;"Measure Source")
{
//SourceExpr="Measure Source";
}Column(ProdMeasureLines_Sales_Price;"PROD Price")
{
//SourceExpr="PROD Price";
}Column(ProdMeasureLines_Amount;"PROD Amount Term")
{
//SourceExpr="PROD Amount Term";
}Column(ProdMeasureLines_Amount_To_Source;"PROD Amount to Source")
{
//SourceExpr="PROD Amount to Source";
}Column(ProdMeasureLines_Document_N;"Document No.")
{
//SourceExpr="Document No.";
}Column(ProdMeasureLines_Line_N;"Line No.")
{
//SourceExpr="Line No.";
}Column(ProdMeasureLines_Job_N;"Job No.")
{
//SourceExpr="Job No.";
}Column(ProdMeasureLines_NotSignedAmount;NotSignedAmount)
{
//SourceExpr=NotSignedAmount;
}DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 ORDER(Ascending);
DataItemLink="Job No."= FIELD("Job No."),
                            "Piecework Code"= FIELD("Piecework No.");
Column(DataPieceworkForProduction_Job_N;"Job No.")
{
//SourceExpr="Job No.";
}Column(DataPieceworkForProduction_Piecework_Code;"Piecework Code")
{
//SourceExpr="Piecework Code";
}Column(DataPieceworkForProduction_Unique_Code;"Unique Code")
{
//SourceExpr="Unique Code";
}DataItem("QB Text";"QB Text")
{

               DataItemTableView=SORTING("Table","Key1","Key2")
                                 WHERE("Table"=CONST("Job"));
DataItemLink="Key1"= FIELD("Job No."),
                            "Key2"= FIELD("Piecework Code");
Column(textLineExtended;textLineExtended )
{
//SourceExpr=textLineExtended ;
}trigger OnPreDataItem();
    BEGIN 
                               IF NOT boolTxtAdic THEN
                                 CurrReport.BREAK;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  textLineExtended := "QB Text".GetCostText;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               IF NOT boolTxtAdic THEN
                                 CurrReport.BREAK;
                             END;


}trigger OnAfterGetRecord();
    BEGIN 
                                  //JAV 24/06/22: - QB 1.10.52 Se cambia PEC por COST y se eliminan campos PEM que es mas apropiado
                                  IF DataPieceworkForProduction.GET("Prod. Measure Lines"."Job No.", "Prod. Measure Lines"."Piecework No.") THEN BEGIN 
                                    SignedAmount := ROUND("PROD Amount Term" * DataPieceworkForProduction."% Processed Production" / 100, 0.01);
                                    NotSignedAmount := "PROD Amount Term" - SignedAmount;
                                  END ELSE BEGIN 
                                    SignedAmount := 0;
                                    NotSignedAmount := 0;
                                  END;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               LastFieldNo := FIELDNO("No.");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF NOT Customer.GET("Prod. Measure Header"."Customer No.") THEN
                                    CLEAR(Customer);
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
AmoutMeasure_Caption='Total Measure/ Imp. Periodo/';
AmoutOrigin_Caption='Imp. Origen/';
TotalMeasureSource_Caption='Totales/';
CustomerLabel='Cliente/';
CodeLabel='C¢digo Medici¢n/';
UOLabel='U.O./';
DesLabel='Descripci¢n/';
PorLabel='% Orig./';
MOLabel='M.Orig./';
MPLabel='M.Per./';
PVPLabel='P.V.Calc./';
IPLabel='Imp. Per./';
IOLabel='Imp. Origen/';
NotSignedLabel='No Firmado/';
}
  
    var
//       Customer@1100286006 :
      Customer: Record 18;
//       ExtendedTextLine@1100286005 :
      ExtendedTextLine: Record 280;
//       DataPieceworkForProduction@1100286004 :
      DataPieceworkForProduction: Record 7207386;
//       LastFieldNo@7001105 :
      LastFieldNo: Integer;
//       FooterPrinted@7001104 :
      FooterPrinted: Boolean;
//       boolTxtAdic@7001102 :
      boolTxtAdic: Boolean;
//       textLineExtended@7001100 :
      textLineExtended: Text[150];
//       ProdMeasureCaptionLbl@7001109 :
      ProdMeasureCaptionLbl: TextConst ENU='Production Measurement',ESP='Medici¢n producci¢n';
//       CustomerCaptionLbl@7001108 :
      CustomerCaptionLbl: TextConst ENU='CUSTOMER',ESP='CLIENTE';
//       CurrReport_PAGENOCaptionLbl@7001107 :
      CurrReport_PAGENOCaptionLbl: TextConst ENU='Page',ESP='P g.';
//       CompanyInformation@1000000000 :
      CompanyInformation: Record 79;
//       SignedAmount@1100286000 :
      SignedAmount: Decimal;
//       NotSignedAmount@1100286001 :
      NotSignedAmount: Decimal;

    

trigger OnInitReport();    begin
                   CompanyInformation.CALCFIELDS(Picture);
                 end;



/*begin
    {
      PGM 17/09/19: - QVE7808 A¤adido el logotipo en la cabecera y el pie de p g. est ndar de VESTA
      JAV 08/10/19: - Se transforma en un report solo para Vesta
      JAV 24/06/22: - QB 1.10.52 Se cambia PEC por COST y se eliminan campos PEM que es mas apropiado
    }
    end.
  */
  
}



