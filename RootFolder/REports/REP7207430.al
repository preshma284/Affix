report 7207430 "Job Management Report"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Job Management',ESP='Gesti¢n de obras';
    
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=WHERE("Card Type"=CONST("Proyecto operativo"));
               

               RequestFilterFields="No.";
Column(Label;Label)
{
//SourceExpr=Label;
}Column(DateFilter;DateFilter)
{
//SourceExpr=DateFilter;
}Column(SourceLbl;SourceLbl)
{
//SourceExpr=SourceLbl;
}Column(YearLbl;YearLbl)
{
//SourceExpr=YearLbl;
}Column(MonthLbl;MonthLbl)
{
//SourceExpr=MonthLbl;
}Column(JobNoLbl;JobNoLbl)
{
//SourceExpr=JobNoLbl;
}Column(JobDescription;JobDescription)
{
//SourceExpr=JobDescription;
}Column(CostConsumLbl;CostConsumLbl)
{
//SourceExpr=CostConsumLbl;
}Column(InvoicedLbl;InvoicedLbl)
{
//SourceExpr=InvoicedLbl;
}Column(ActualProductionLbl;ActualProductionLbl)
{
//SourceExpr=ActualProductionLbl;
}Column(ResultLbl;ResultLbl)
{
//SourceExpr=ResultLbl;
}Column(MarginLbl;MarginLbl)
{
//SourceExpr=MarginLbl;
}Column(ActualJobLbl;ActualJobLbl)
{
//SourceExpr=ActualJobLbl;
}Column(TotalLbl;TotalLbl)
{
//SourceExpr=TotalLbl;
}Column(No_Job;Job."No.")
{
//SourceExpr=Job."No.";
}Column(Description_Job;Job.Description)
{
//SourceExpr=Job.Description;
}Column(ActualProdMeasure1;ActualProdMeasure[1])
{
//SourceExpr=ActualProdMeasure[1];
}Column(UsageCost1;UsageCost[1])
{
//SourceExpr=UsageCost[1];
}Column(InvoicedPrice1;InvoicedPrice[1])
{
//SourceExpr=InvoicedPrice[1];
}Column(Result1;Result[1])
{
//SourceExpr=Result[1];
}Column(Margin1;Margin[1])
{
//SourceExpr=Margin[1];
}Column(ActualJob1;ActualJob[1])
{
//SourceExpr=ActualJob[1];
}Column(Acopios1;Acopios[1])
{
//SourceExpr=Acopios[1];
}Column(ActualProdMeasure2;ActualProdMeasure[2])
{
//SourceExpr=ActualProdMeasure[2];
}Column(UsageCost2;UsageCost[2])
{
//SourceExpr=UsageCost[2];
}Column(InvoicedPrice2;InvoicedPrice[2])
{
//SourceExpr=InvoicedPrice[2];
}Column(Result2;Result[2])
{
//SourceExpr=Result[2];
}Column(Margin2;Margin[2])
{
//SourceExpr=Margin[2];
}Column(ActualJob2;ActualJob[2])
{
//SourceExpr=ActualJob[2];
}Column(Acopios2;Acopios[2])
{
//SourceExpr=Acopios[2];
}Column(ActualProdMeasure3;ActualProdMeasure[3])
{
//SourceExpr=ActualProdMeasure[3];
}Column(UsageCost3;UsageCost[3])
{
//SourceExpr=UsageCost[3];
}Column(InvoicedPrice3;InvoicedPrice[3])
{
//SourceExpr=InvoicedPrice[3];
}Column(Result3;Result[3])
{
//SourceExpr=Result[3];
}Column(Margin3;Margin[3])
{
//SourceExpr=Margin[3];
}Column(ActualJob3;ActualJob[3])
{
//SourceExpr=ActualJob[3];
}Column(Acopios3;Acopios[3])
{
//SourceExpr=Acopios[3];
}Column(OriginDateFilter;OriginDateFilter)
{
//SourceExpr=OriginDateFilter;
}Column(YearDateFilter;YearDateFilter)
{
//SourceExpr=YearDateFilter;
}Column(MonthDateFilter;MonthDateFilter )
{
//SourceExpr=MonthDateFilter ;
}trigger OnPreDataItem();
    BEGIN 
                               DateFilter := FilterLbl + ': ' + FORMAT(InitialDate) + '..' + FORMAT(EndingDate);
                             END;

trigger OnAfterGetRecord();
    BEGIN 

                                  ActualProdMeasure[1] := 0;
                                  UsageCost[1] := 0;
                                  InvoicedPrice[1] := 0;
                                  Result[1] := 0;
                                  Margin[1] := 0;
                                  ActualJob[1] := 0;
                                  Acopios[1] := 0;

                                  ActualProdMeasure[2] := 0;
                                  UsageCost[2] := 0;
                                  InvoicedPrice[2] := 0;
                                  Result[2] := 0;
                                  Margin[2] := 0;
                                  ActualJob[2] := 0;
                                  Acopios[2] := 0;

                                  ActualProdMeasure[3] := 0;
                                  UsageCost[3] := 0;
                                  InvoicedPrice[3] := 0;
                                  Result[3] := 0;
                                  Margin[3] := 0;
                                  ActualJob[3] := 0;
                                  Acopios[3] := 0;

                                  //Origen
                                  Job.SETRANGE("Posting Date Filter", 0D, EndingDate);

                                  Job.CALCFIELDS("Actual Production Amount","Invoiced (LCY)", "Usage (Cost) (LCY)", "Invoiced Price (LCY)","Warehouse Availability Amount");
                                  //JMMA CORREGIDO POR ERROR ActualProdMeasure[1] := Job.Invoiced;
                                  ActualProdMeasure[1] := Job."Actual Production Amount";

                                  UsageCost[1] := Job."Usage (Cost) (LCY)";
                                  //JMMA corregido por incorrecto InvoicedPrice[1] := "Invoiced Price";
                                  InvoicedPrice[1] :=Job."Invoiced (LCY)";

                                  Result[1] := ActualProdMeasure[1] - UsageCost[1];
                                  IF ActualProdMeasure[1] <> 0 THEN
                                    Margin[1] := Result[1] / ActualProdMeasure[1];
                                  ActualJob[1] := ActualProdMeasure[1] - InvoicedPrice[1];
                                  Acopios[1] := Job."Warehouse Availability Amount";

                                  //A¤o
                                  //GAP999 MOD2 -
                                  //Job.SETRANGE("Posting Date Filter", CALCDATE('<-CY>', InitialDate), CALCDATE('<CY>', InitialDate));
                                  Job.SETRANGE("Posting Date Filter",CALCDATE('<-CY>',InitialDate),EndingDate);
                                  //GAP999  MOD2 +

                                  Job.CALCFIELDS("Actual Production Amount","Invoiced (LCY)", "Usage (Cost) (LCY)", "Invoiced Price (LCY)","Warehouse Availability Amount");
                                  //jmma CORREGIDO POR ERROR ActualProdMeasure[2] := Invoiced;
                                  ActualProdMeasure[2] := Job."Actual Production Amount";
                                  UsageCost[2] := "Usage (Cost) (LCY)";
                                  //jmma corregido por error InvoicedPrice[2] := "Invoiced Price";
                                  InvoicedPrice[2] := Job."Invoiced (LCY)";
                                  Result[2] := ActualProdMeasure[2] - UsageCost[2];
                                  IF ActualProdMeasure[2] <> 0 THEN
                                    Margin[2] := Result[2] / ActualProdMeasure[2];
                                  ActualJob[2] := ActualProdMeasure[2] - InvoicedPrice[2];
                                  Acopios[2] := "Warehouse Availability Amount";

                                  //Mes
                                  //GAP999 MOD2 -
                                  //Job.SETRANGE("Posting Date Filter", CALCDATE('<-CM>', InitialDate), CALCDATE('<CM>', InitialDate));
                                  Job.SETRANGE("Posting Date Filter",CALCDATE('<-CM>',EndingDate),CALCDATE('<CM>',EndingDate));
                                  //GAP99 MOD2 +

                                  Job.CALCFIELDS("Actual Production Amount","Invoiced (LCY)", "Usage (Cost) (LCY)", "Invoiced Price (LCY)");
                                  //JMMA ERROR CORREGIDO ActualProdMeasure[3] := Invoiced;
                                  ActualProdMeasure[3] :=Job."Actual Production Amount";
                                  UsageCost[3] := "Usage (Cost) (LCY)";
                                  //JMMA ERROR CORREGIDO InvoicedPrice[3] := "Invoiced Price";
                                  InvoicedPrice[3] := Job."Invoiced (LCY)";
                                  Result[3] := ActualProdMeasure[3] - UsageCost[3];
                                  IF ActualProdMeasure[3] <> 0 THEN
                                    Margin[3] := Result[3] / ActualProdMeasure[3];
                                  ActualJob[3] := ActualProdMeasure[3] - InvoicedPrice[3];
                                  Acopios[3] := "Warehouse Availability Amount";
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group842")
{
        
                  CaptionML=ENU='Filters',ESP='Filtros';
    field("TxtFilterDate";"TxtFilterDate")
    {
        
                  CaptionML=ENU='Date Filter',ESP='Filtro fecha';
                  
                              

    ;trigger OnValidate()    BEGIN
                               ApplicationManagement.MakeDateFilter(TxtFilterDate);

                               //GAP999 MOD2 -
                               //EVALUATE(InitialDate, COPYSTR(TxtFilterDate, 1,10));
                               //EVALUATE(InitialDate, COPYSTR(TxtFilterDate, 11,10));
                               Job.SETFILTER("Posting Date Filter",TxtFilterDate);
                               InitialDate := Job.GETRANGEMIN("Posting Date Filter");
                               EndingDate := Job.GETRANGEMAX("Posting Date Filter");
                               Job.RESET;
                               //GAP999 MOD2 +
                             END;


    }

}

}
}trigger OnInit()    BEGIN
               //GAP999 MOD2 -
            //    {
            //    InitialDate := CALCDATE('<-CY>', WORKDATE);
            //    EndingDate := CALCDATE('<CY>', WORKDATE);

            //    TxtFilterDate := FORMAT(InitialDate) + '..' + FORMAT(EndingDate);
            //    }
               //GAP999 MOD2 +
             END;


  }
  labels
{
}
  
    var
//       Label@1100286017 :
      Label: TextConst ENU='Job Management',ESP='Gesti¢n de obras';
//       FilterLbl@1100286016 :
      FilterLbl: TextConst ENU='Filter',ESP='Filtro';
//       SourceLbl@1100286001 :
      SourceLbl: TextConst ENU='Source',ESP='Origen';
//       YearLbl@1100286002 :
      YearLbl: TextConst ENU='Year',ESP='A¤o';
//       MonthLbl@1100286003 :
      MonthLbl: TextConst ENU='Month',ESP='Mes';
//       JobNoLbl@1100286000 :
      JobNoLbl: TextConst ENU='Job No.',ESP='No. obra';
//       JobDescription@1100286004 :
      JobDescription: TextConst ENU='Job Description',ESP='Descripci¢n obra';
//       CostConsumLbl@1100286006 :
      CostConsumLbl: TextConst ENU='Consumed Cost',ESP='Consumo coste';
//       InvoicedLbl@1100286007 :
      InvoicedLbl: TextConst ENU='Invoiced',ESP='Facturado';
//       ActualProductionLbl@1100286008 :
      ActualProductionLbl: TextConst ENU='Actual Production',ESP='Producci¢n real';
//       TotalLbl@1100286009 :
      TotalLbl: TextConst ENU='Total',ESP='Total';
//       InitialDate@1100286010 :
      InitialDate: Date;
//       EndingDate@1100286011 :
      EndingDate: Date;
//       DateFilter@1100286015 :
      DateFilter: Text;
//       ActualProdMeasure@1100286012 :
      ActualProdMeasure: ARRAY [3] OF Decimal;
//       UsageCost@1100286013 :
      UsageCost: ARRAY [3] OF Decimal;
//       InvoicedPrice@1100286014 :
      InvoicedPrice: ARRAY [3] OF Decimal;
//       ResultLbl@1100286005 :
      ResultLbl: TextConst ENU='Result',ESP='Resultado';
//       MarginLbl@1100286018 :
      MarginLbl: TextConst ENU='Margin %',ESP='Margen %';
//       ActualJobLbl@1100286019 :
      ActualJobLbl: TextConst ENU='Actual Job',ESP='Obra en curso';
//       Result@1100286020 :
      Result: ARRAY [3] OF Decimal;
//       Margin@1100286021 :
      Margin: ARRAY [3] OF Decimal;
//       ActualJob@1100286022 :
      ActualJob: ARRAY [3] OF Decimal;
//       JobLedgerEntry@1100286023 :
      JobLedgerEntry: Record 169;
//       ApplicationManagement@1100286025 :
      ApplicationManagement: Codeunit 41;
//       TxtFilterDate@1100286024 :
      TxtFilterDate: Text;
//       Acopios@1100286026 :
      Acopios: ARRAY [3] OF Decimal;
//       JobAux@1100286027 :
      JobAux: Record 167;
//       OriginDateFilter@100000000 :
      OriginDateFilter: Text;
//       YearDateFilter@100000001 :
      YearDateFilter: Text;
//       MonthDateFilter@100000002 :
      MonthDateFilter: Text;
//       DateFilterErr@100000003 :
      DateFilterErr: TextConst ENU='A date filter has not being established',ESP='No se ha establecido un filtro de fechas.';

    

trigger OnPreReport();    begin
                  if TxtFilterDate = '' then
                    ERROR(DateFilterErr);
                  OriginDateFilter := '0D..' + FORMAT(EndingDate);
                  YearDateFilter := FORMAT(CALCDATE('<-CY>',InitialDate)) + '..' + FORMAT(EndingDate);
                  MonthDateFilter := FORMAT(CALCDATE('<-CM>',EndingDate)) + '..' + FORMAT(CALCDATE('<CM>',EndingDate));
                end;



/*begin
    {
      //GAP999 MOD2 JDC 18/06/19 - Commented code in function "OnInit"
                              Modified how "Posting Data Filter" is populated
    }
    end.
  */
  
}




