report 7207306 "Budget Offer Item"
{
  
  
    CaptionML=ENU='Budget Offer Item',ESP='Oferta presupuesto por Item';
  
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               PrintOnlyIfDetail=false;
               

               RequestFilterFields="No.";
Column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
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
}Column(CompanyInformation_Picture;CompanyInformation.Picture)
{
//SourceExpr=CompanyInformation.Picture;
}Column(CustomerName;CustomerName)
{
//SourceExpr=CustomerName;
}Column(Job__No__;"No.")
{
//SourceExpr="No.";
}Column(Job_Description;Description)
{
//SourceExpr=Description;
}Column(Job_Description2;Job."Description 2")
{
//SourceExpr=Job."Description 2";
}Column(Job__Search_Description_;"Search Description")
{
//SourceExpr="Search Description";
}Column(Job__Starting_Date_;"Starting Date")
{
//SourceExpr="Starting Date";
}Column(Job__Person_Responsible_;"Person Responsible")
{
//SourceExpr="Person Responsible";
}Column(Resource_Name;Resource.Name)
{
//SourceExpr=Resource.Name;
}Column(Job__Global_Dimension_1_Code_;"Global Dimension 1 Code")
{
//SourceExpr="Global Dimension 1 Code";
}Column(Job__Starting_Date__Control31;"Starting Date")
{
//SourceExpr="Starting Date";
}Column(ExpDuration;ExpDuration)
{
//SourceExpr=ExpDuration;
}Column(PriceAmountvta;PriceAmountvta)
{
//SourceExpr=PriceAmountvta;
}Column(TradeName;TradeName)
{
//SourceExpr=TradeName;
}Column(ProjectBudgerCaption;ProjectBudger)
{
//SourceExpr=ProjectBudger;
}Column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaption)
{
//SourceExpr=CurrReport_PAGENOCaption;
}Column(CustomerCaption;CustomerCaption)
{
//SourceExpr=CustomerCaption;
}Column(Offer_N_Caption;Offer_N_Caption)
{
//SourceExpr=Offer_N_Caption;
}Column(Job_DescriptionCaption;FIELDCAPTION(Description))
{
//SourceExpr=FIELDCAPTION(Description);
}Column(Job__Search_Description_Caption;FIELDCAPTION("Search Description"))
{
//SourceExpr=FIELDCAPTION("Search Description");
}Column(Job__Starting_Date_Caption;FIELDCAPTION("Starting Date"))
{
//SourceExpr=FIELDCAPTION("Starting Date");
}Column(ResponsibleCaption;ResponsibleCaption)
{
//SourceExpr=ResponsibleCaption;
}Column(Job__Global_Dimension_1_Code_Caption;FIELDCAPTION("Global Dimension 1 Code"))
{
//SourceExpr=FIELDCAPTION("Global Dimension 1 Code");
}Column(Expected_DurationCaption;Expected_DurationCaption)
{
//SourceExpr=Expected_DurationCaption;
}Column(Months_Caption;Months_Caption)
{
//SourceExpr=Months_Caption;
}Column(ExpectedstartdateCaption;ExpectedstartdateCaption)
{
//SourceExpr=ExpectedstartdateCaption;
}Column(SalesPriceCaption;SalesPriceCaption)
{
//SourceExpr=SalesPriceCaption;
}Column(TOTALCaption;TOTALCaption)
{
//SourceExpr=TOTALCaption;
}Column(BusinessManagerCaption;BusinessManagerCaption)
{
//SourceExpr=BusinessManagerCaption;
}Column(ProjectManagerCaption;ProjectManagerCaption)
{
//SourceExpr=ProjectManagerCaption;
}Column(DateSignatureCaption;DateSignatureCaption)
{
//SourceExpr=DateSignatureCaption;
}Column(DateSignatureCaption_Control58;DateSignatureCaption_Control58)
{
//SourceExpr=DateSignatureCaption_Control58;
}Column(ObservationsCaption;ObservationsCaption)
{
//SourceExpr=ObservationsCaption;
}Column(N_directhoursCaption;N_directhoursCaption)
{
//SourceExpr=N_directhoursCaption;
}Column(Unitprice_E_hCaption;Unitprice_E_hCaption)
{
//SourceExpr=Unitprice_E_hCaption;
}Column(TOTALCaption_Control28;TOTALCaption_Control28)
{
//SourceExpr=TOTALCaption_Control28;
}Column(TOTAL_AnalyticalconceptCaption;TOTAL_AnalyticalconceptCaption)
{
//SourceExpr=TOTAL_AnalyticalconceptCaption;
}Column(ObservationsCaption_Control59;ObservationsCaption_Control59)
{
//SourceExpr=ObservationsCaption_Control59;
}Column(TOTALCaption_Control60;TOTALCaption_Control60)
{
//SourceExpr=TOTALCaption_Control60;
}Column(Unit_Amounto_Estimated_priceCaption;Unit_Amounto_Estimated_priceCaption)
{
//SourceExpr=Unit_Amounto_Estimated_priceCaption;
}Column(Numberunits_or_setCaption;Numberunits_or_setCaption)
{
//SourceExpr=Numberunits_or_setCaption;
}Column(ConceptCaption;ConceptCaption)
{
//SourceExpr=ConceptCaption;
}Column(Analytical_concept_caption;Analytical_concept_caption)
{
//SourceExpr=Analytical_concept_caption;
}Column(FinalAmount;FinalAmount)
{
//SourceExpr=FinalAmount;
}Column(sumAmount1;SumAmount1)
{
//SourceExpr=SumAmount1;
}Column(sumAmount2;sumAmount2)
{
//SourceExpr=sumAmount2;
}Column(Discount;Discount)
{
//SourceExpr=Discount;
}DataItem("Job Planning Line";"Job Planning Line")
{

               DataItemTableView=SORTING("Job No.","Analytical concept","Job Task No.");
DataItemLink="Job No."= FIELD("No.");
Column(Job_Planning_Line__Total_Price_;"Total Price")
{
//SourceExpr="Total Price";
}Column(Job_Planning_Line__Unit_Price_;"Unit Price")
{
//SourceExpr="Unit Price";
}Column(Job_Planning_Line_Quantity;Quantity)
{
//SourceExpr=Quantity;
}Column(Job_Planning_Line_Description;Description)
{
//SourceExpr=Description;
}Column(Job_Planning_Line_Analytical_concept;"Analytical concept")
{
//SourceExpr="Analytical concept";
}Column(Job_Planning_Line__Total_Price__Control39;"Total Price")
{
//SourceExpr="Total Price";
}Column(Job_Planning_Line_Quantity_Control41;Quantity)
{
//SourceExpr=Quantity;
}Column(Job_Planning_Line_Job_No_;"Job No.")
{
//SourceExpr="Job No.";
}Column(Job_Planning_Line_Job_Task_No_;"Job Task No.")
{
//SourceExpr="Job Task No.";
}Column(Job_Planning_Line_Line_No_;"Line No.")
{
//SourceExpr="Line No.";
}DataItem("Linppto2";"Job Planning Line")
{

               DataItemTableView=SORTING("Job No.","Analytical concept","Job Task No.")
                                 WHERE("Total Price (LCY)"=FILTER(<>0));
DataItemLink="Job No."= FIELD("No.");
Column(Linppto2__Total_Price_;"Total Price")
{
//SourceExpr="Total Price";
}Column(Linppto2__Unit_Price_;"Unit Price")
{
//SourceExpr="Unit Price";
}Column(Linppto2_Quantity;Quantity)
{
//SourceExpr=Quantity;
}Column(Linppto2_Description;Description)
{
//SourceExpr=Description;
}Column(Linppto2_Job_No_;"Job No.")
{
//SourceExpr="Job No.";
}Column(Linppto2_Job_Task_No_;"Job Task No.")
{
//SourceExpr="Job Task No.";
}Column(Linppto2_Line_No_;"Line No." )
{
//SourceExpr="Line No." ;
}trigger OnPreDataItem();
    BEGIN 
                               CurrReport.CREATETOTALS("Job Planning Line"."Total Price (LCY)","Total Price (LCY)");
                               CurrReport.CREATETOTALS(PriceAmountvta,TotalAmount1,Discount);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  TotalAmount1 := TotalAmount1 + "Total Price (LCY)";
                                  SumAmount1:= SumAmount1 + TotalAmount1;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               CurrReport.CREATETOTALS(Linppto2."Total Price (LCY)","Total Price (LCY)",TotalAmount2,PriceAmountvta);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF NOT DimensionValue.GET(FunctionQB.ReturnDimCA,"No.")  THEN
                                    CurrReport.SKIP;
                                  TotalAmount2 := TotalAmount2 + "Total Price (LCY)";
                                  sumAmount2 := sumAmount2 + TotalAmount2;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               CompanyInformation.GET;
                               CompanyInformation.CALCFIELDS(Picture);

                               CurrReport.CREATETOTALS("Job Planning Line"."Total Price (LCY)",
                                                       Linppto2."Total Price (LCY)");
                               CurrReport.CREATETOTALS(TotalAmount1,TotalAmount2,PriceAmountvta,Discount);
                               JobsSetup.GET;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF Customer.GET("Bill-to Customer No.") THEN
                                    CustomerName := Customer.Name;

                                  ExpDuration := ("Ending Date" - "Starting Date");
                                  IF ExpDuration <= 31 THEN
                                    ExpDuration := "Ending Date" - "Starting Date"
                                  ELSE
                                    ExpDuration := ABS(ROUND(("Ending Date" - "Starting Date")/30,1));

                                  IF Resource.GET("Income Statement Responsible") THEN
                                    TradeName := Resource.Name;

                                  //FinalAmount := TotalAmount1 + TotalAmount2;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                FinalAmount := SumAmount1 + sumAmount2;
                                PriceAmountvta :=  FinalAmount - ABS(Discount);
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
//       Customer@7001113 :
      Customer: Record 18;
//       CustomerName@7001112 :
      CustomerName: Text[30];
//       ExpDuration@7001111 :
      ExpDuration: Decimal;
//       Discount@7001110 :
      Discount: Decimal;
//       PriceAmountvta@7001109 :
      PriceAmountvta: Decimal;
//       TotalAmount1@7001108 :
      TotalAmount1: Decimal;
//       Resource@7001107 :
      Resource: Record 156;
//       TradeName@7001106 :
      TradeName: Text[30];
//       JobsSetup@7001105 :
      JobsSetup: Record 315;
//       TotalAmount2@7001104 :
      TotalAmount2: Decimal;
//       FinalAmount@7001103 :
      FinalAmount: Decimal;
//       DimensionValue@7001102 :
      DimensionValue: Record 349;
//       FunctionQB@7001101 :
      FunctionQB: Codeunit 7207272;
//       CompanyInformation@7001100 :
      CompanyInformation: Record 79;
//       ProjectBudger@7001137 :
      ProjectBudger: TextConst ENU='PROJECT BUDGET',ESP='PRESUPUESTO PROYECTO';
//       CurrReport_PAGENOCaption@7001136 :
      CurrReport_PAGENOCaption: TextConst ENU='page',ESP='p gina';
//       CustomerCaption@7001135 :
      CustomerCaption: TextConst ENU='Customer',ESP='Cliente';
//       Offer_N_Caption@7001134 :
      Offer_N_Caption: TextConst ENU='N§ OFFER',ESP='OFERTA N§';
//       ResponsibleCaption@7001133 :
      ResponsibleCaption: TextConst ENU='Responsible',ESP='Responsable';
//       Expected_DurationCaption@7001132 :
      Expected_DurationCaption: TextConst ENU='EXPECTED DURATION',ESP='Duraci¢n prevista';
//       Months_Caption@7001131 :
      Months_Caption: TextConst ENU='Months',ESP='Meses';
//       ExpectedstartdateCaption@7001130 :
      ExpectedstartdateCaption: TextConst ENU='Expected Start Date',ESP='Fecha inicio prevista';
//       SalesPriceCaption@7001129 :
      SalesPriceCaption: TextConst ENU='SALES PRICE',ESP='PRECIO DE VENTA';
//       TOTALCaption@7001128 :
      TOTALCaption: TextConst ENU='TOTAL',ESP='TOTAL';
//       BusinessManagerCaption@7001127 :
      BusinessManagerCaption: TextConst ENU='Business Manager',ESP='Responsable Comercial';
//       ProjectManagerCaption@7001126 :
      ProjectManagerCaption: TextConst ENU='Project Manager',ESP='Responsable Dpto.';
//       DateSignatureCaption@7001125 :
      DateSignatureCaption: TextConst ENU='Date and Signature',ESP='Fecha y Firma';
//       DateSignatureCaption_Control58@7001124 :
      DateSignatureCaption_Control58: TextConst ENU='Date and Signature',ESP='Fecha y Firma';
//       N_directhoursCaption@7001123 :
      N_directhoursCaption: TextConst ENU='Direct Hours Number',ESP='N§ Horas directas';
//       Unitprice_E_hCaption@7001122 :
      Unitprice_E_hCaption: TextConst ENU='Unit Price ° / h ',ESP='Precio unitario ° / h';
//       TOTALCaption_Control28@7001121 :
      TOTALCaption_Control28: TextConst ENU='TOTAL',ESP='TOTAL';
//       ObservationsCaption@7001120 :
      ObservationsCaption: TextConst ENU='Observations',ESP='Observaciones';
//       TOTAL_AnalyticalconceptCaption@7001119 :
      TOTAL_AnalyticalconceptCaption: TextConst ENU='TOTAL ANALYTICAL CONCEPT',ESP='TOTAL CONCEPTOS ANALÖTICOS';
//       ObservationsCaption_Control59@7001118 :
      ObservationsCaption_Control59: TextConst ENU='Observations',ESP='Observaciones';
//       TOTALCaption_Control60@7001117 :
      TOTALCaption_Control60: TextConst ENU='TOTAL',ESP='TOTAL';
//       Unit_Amounto_Estimated_priceCaption@7001116 :
      Unit_Amounto_Estimated_priceCaption: TextConst ENU='Unit Amount or Estimated Price',ESP='Precio unitario o precio estimado';
//       Numberunits_or_setCaption@7001115 :
      Numberunits_or_setCaption: TextConst ENU='Number units or Set',ESP='N§ unidades o conjunto';
//       ConceptCaption@7001114 :
      ConceptCaption: TextConst ENU='Concept',ESP='Concepto';
//       sumAmount2@7001138 :
      sumAmount2: Decimal;
//       SumAmount1@7001139 :
      SumAmount1: Decimal;
//       Analytical_concept_caption@7001140 :
      Analytical_concept_caption: TextConst ENU='Analytical concept',ESP='Concepto anal¡tico';

    /*begin
    end.
  */
  
}



