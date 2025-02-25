report 50038 "Vesta: Production Measur. Reg."
{
  
  
    CaptionML=ENU='Product. Measurement',ESP='Vesta: Relaci¢n Valorada Registrada';
    
  dataset
{

DataItem("Hist. Prod. Measure Header";"Hist. Prod. Measure Header")
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
}Column(ProdMeasureHeader_N;"Hist. Prod. Measure Header"."No.")
{
//SourceExpr="Hist. Prod. Measure Header"."No.";
}Column(ProdMeasureHeader_Job;"Hist. Prod. Measure Header"."Job No." + ' ' + "Hist. Prod. Measure Header".Description + ' ' + "Hist. Prod. Measure Header"."Description 2")
{
//SourceExpr="Hist. Prod. Measure Header"."Job No." + ' ' + "Hist. Prod. Measure Header".Description + ' ' + "Hist. Prod. Measure Header"."Description 2";
}Column(ProdMeasureHeader_MeasureDate;"Hist. Prod. Measure Header"."Measure Date")
{
//SourceExpr="Hist. Prod. Measure Header"."Measure Date";
}Column(ProdMeasureHeader_MeasureReference;"Hist. Prod. Measure Header"."Measurement No.")
{
//SourceExpr="Hist. Prod. Measure Header"."Measurement No.";
}Column(ProdMeasureHeader_MeasureText;"Hist. Prod. Measure Header"."Measurement Text")
{
//SourceExpr="Hist. Prod. Measure Header"."Measurement Text";
}Column(ProdMeasureHeader_Customer;"Hist. Prod. Measure Header"."Customer No." + ' ' + Customer.Name)
{
//SourceExpr="Hist. Prod. Measure Header"."Customer No." + ' ' + Customer.Name;
}Column(CustomerCaption;CustomerCaptionLbl)
{
//SourceExpr=CustomerCaptionLbl;
}Column(ProdMeasureCaption;ProdMeasureCaptionLbl)
{
//SourceExpr=ProdMeasureCaptionLbl;
}Column(ProdMeasureHeader_JobN_Caption;"Hist. Prod. Measure Header".FIELDCAPTION("Job No."))
{
//SourceExpr="Hist. Prod. Measure Header".FIELDCAPTION("Job No.");
}Column(ProdMeasureHeader_MeasureDate_Caption;"Hist. Prod. Measure Header".FIELDCAPTION("Measure Date"))
{
//SourceExpr="Hist. Prod. Measure Header".FIELDCAPTION("Measure Date");
}Column(ProdMeasureHeader_MeasureReference_Caption;"Hist. Prod. Measure Header".FIELDCAPTION("Measurement No."))
{
//SourceExpr="Hist. Prod. Measure Header".FIELDCAPTION("Measurement No.");
}Column(ProdMeasureHeader_MeasureText_Caption;"Hist. Prod. Measure Header".FIELDCAPTION("Measurement Text"))
{
//SourceExpr="Hist. Prod. Measure Header".FIELDCAPTION("Measurement Text");
}DataItem("Hist. Prod. Measure Lines";"Hist. Prod. Measure Lines")
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
}Column(ProdMeasureLines_Source_Measure;"Measure Source")
{
//SourceExpr="Measure Source";
}Column(ProdMeasureLines_Measute_Term;"Measure Term")
{
//SourceExpr="Measure Term";
}Column(ProdMeasureLines_PEC_Price;"PROD Price")
{
//SourceExpr="PROD Price";
}Column(ProdMeasureLines_PEC_Amount_Term;"PROD Amount Term")
{
//SourceExpr="PROD Amount Term";
}Column(ProdMeasureLines_PEC_Amount_To_Source;"PROD Amount to Source")
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
                            "Key1"= FIELD("Piecework Code");
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
                                  IF DataPieceworkForProduction.GET("Hist. Prod. Measure Lines"."Job No.", "Hist. Prod. Measure Lines"."Piecework No.") THEN BEGIN 
                                    //JAV 24/06/22: - QB 1.10.52 Se cambia PEC por COST y se eliminan campos PEM que es mas apropiado
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
                                  IF NOT Customer.GET("Hist. Prod. Measure Header"."Customer No.") THEN
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



