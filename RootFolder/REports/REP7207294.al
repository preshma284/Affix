report 7207294 "Overdue Milestones Proj List"
{
  
  
    
  dataset
{

DataItem("Job";"Job")
{

               ;
Column(Picture;TablaCompInformation.Picture)
{
//SourceExpr=TablaCompInformation.Picture;
}Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(CurrReport_PAGENO;CurrReport.PAGENO)
{
//SourceExpr=CurrReport.PAGENO;
}Column(USERID;USERID)
{
//SourceExpr=USERID;
}Column(FORMAT_TODAY_0_4;FORMAT(TODAY,0,4))
{
//SourceExpr=FORMAT(TODAY,0,4);
}Column(ProjFilt;ProjFilt)
{
//SourceExpr=ProjFilt;
}Column(MilestoneFilt;MilestoneFilt)
{
//SourceExpr=MilestoneFilt;
}Column(AmountLCY_InvoiceMilestone_;"Invoice Milestone"."Amount (LCY)")
{
//SourceExpr="Invoice Milestone"."Amount (LCY)";
}Column(Milestone_Proj_List_CAPTION;Milestone_Proj_List_CaptionLbl)
{
//SourceExpr=Milestone_Proj_List_CaptionLbl;
}Column(Page_CAPTION;Page_CaptionLbl)
{
//SourceExpr=Page_CaptionLbl;
}Column(ProyectFilter_CAPTION;ProyectFilter_CaptionLbl)
{
//SourceExpr=ProyectFilter_CaptionLbl;
}Column(MilestoneFilter_CAPTION;MilestoneFilter_CaptionLbl)
{
//SourceExpr=MilestoneFilter_CaptionLbl;
}Column(EstimatedDate_CAPTION;EstimatedDate_CaptionLbl)
{
//SourceExpr=EstimatedDate_CaptionLbl;
}Column(Description_CAPTION;Description_CaptionLbl)
{
//SourceExpr=Description_CaptionLbl;
}Column(Amount_CAPTION;Amount_CaptionLbl)
{
//SourceExpr=Amount_CaptionLbl;
}Column(CustomerNo_CAPTION;CustomerNo_CaptionLbl)
{
//SourceExpr=CustomerNo_CaptionLbl;
}Column(MilestoneNo_CAPTION;MilestoneNo_CaptionLbl)
{
//SourceExpr=MilestoneNo_CaptionLbl;
}Column(AmountLCY_InvoiceMilestone_CAPTION;"Invoice Milestone".FIELDCAPTION("Amount (LCY)"))
{
//SourceExpr="Invoice Milestone".FIELDCAPTION("Amount (LCY)");
}Column(Alias_CAPTION;Alias_CaptionLbl)
{
//SourceExpr=Alias_CaptionLbl;
}Column(CurrencyCode_CAPTION;CurrencyCode_CaptionLbl)
{
//SourceExpr=CurrencyCode_CaptionLbl;
}Column(ReportTotal_CAPTION;ReportTotal_CaptionLbl)
{
//SourceExpr=ReportTotal_CaptionLbl;
}Column(Job_No;Job."No.")
{
//SourceExpr=Job."No.";
}DataItem("Invoice Milestone";"Invoice Milestone")
{

               ;
Column(Job_Description;Job.Description)
{
//SourceExpr=Job.Description;
}Column(Job_No_;Job."No.")
{
//SourceExpr=Job."No.";
}Column(EstimatedDate_InvoiceMilestone;"Invoice Milestone"."Estimated Date")
{
//SourceExpr="Invoice Milestone"."Estimated Date";
}Column(Amount_InvoiceMilestone;"Invoice Milestone".Amount)
{
//SourceExpr="Invoice Milestone".Amount;
}Column(CustomerCode_InvoiceMilestone;"Invoice Milestone"."Customer Code")
{
//SourceExpr="Invoice Milestone"."Customer Code";
}Column(MilestoneNo_InvoiceMilestone;"Invoice Milestone"."Milestone No.")
{
//SourceExpr="Invoice Milestone"."Milestone No.";
}Column(Comments_InvoiceMilestone;"Invoice Milestone".Comments)
{
//SourceExpr="Invoice Milestone".Comments;
}Column(AmountLCY_InvoiceMilestone;"Invoice Milestone"."Amount (LCY)")
{
//SourceExpr="Invoice Milestone"."Amount (LCY)";
}Column(CustomerAlias;CustomerAlias)
{
//SourceExpr=CustomerAlias;
}Column(CurrencyCode_InvoiceMilestone;"Invoice Milestone"."Currency Code")
{
//SourceExpr="Invoice Milestone"."Currency Code";
}Column(AmountLCY_InvoiceMilestone_Control30;"Invoice Milestone"."Amount (LCY)")
{
//SourceExpr="Invoice Milestone"."Amount (LCY)";
}Column(ProjectTotal_CaptionLbl;ProjectTotal_CaptionLbl)
{
//SourceExpr=ProjectTotal_CaptionLbl;
}Column(JobNo_InvoiceMilestone;"Invoice Milestone"."Job No." )
{
//SourceExpr="Invoice Milestone"."Job No." ;
}trigger OnPreDataItem();
    BEGIN 
                               CurrReport.CREATETOTALS(Amount,"Amount (LCY)");
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF TablaCustomer.GET(TablaCustomer."No.") THEN
                                    CustomerAlias := TablaCustomer."Search Name"
                                  ELSE
                                    CustomerAlias := '';

                                  "Invoice Milestone".CALCFIELDS(Comments);
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               CurrReport.CREATETOTALS("Invoice Milestone".Amount,"Invoice Milestone"."Amount (LCY)");
                               TablaCompInformation.GET;
                               TablaCompInformation.CALCFIELDS(Picture);
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
ReportName='Overdue Milestones Proj. List/ Listado Proy. Hitos Vencidos/';
PagNo='Page/ P g./';
}
  
    var
//       ProjFilt@7001100 :
      ProjFilt: Text;
//       MilestoneFilt@7001101 :
      MilestoneFilt: Text;
//       CustomerAlias@7001102 :
      CustomerAlias: Text;
//       TablaCustomer@7001103 :
      TablaCustomer: Record 18;
//       TablaCompInformation@7001104 :
      TablaCompInformation: Record 79;
//       Milestone_Proj_List_CaptionLbl@7001117 :
      Milestone_Proj_List_CaptionLbl: TextConst ENU='Milestones Project List.',ESP='Listado Hitos proyectos.';
//       Page_CaptionLbl@7001116 :
      Page_CaptionLbl: TextConst ENU='Page.',ESP='P g.';
//       ProyectFilter_CaptionLbl@7001115 :
      ProyectFilter_CaptionLbl: TextConst ENU='Project Filters: ',ESP='Filtros Proyecto : ';
//       MilestoneFilter_CaptionLbl@7001114 :
      MilestoneFilter_CaptionLbl: TextConst ENU='Milestone Filters: ',ESP='Filtros Hitos : ';
//       EstimatedDate_CaptionLbl@7001113 :
      EstimatedDate_CaptionLbl: TextConst ENU='Estimated date',ESP='Fecha estimada';
//       Description_CaptionLbl@7001112 :
      Description_CaptionLbl: TextConst ENU='Description',ESP='Descripci¢n';
//       Amount_CaptionLbl@7001111 :
      Amount_CaptionLbl: TextConst ENU='Amount',ESP='Importe';
//       CustomerNo_CaptionLbl@7001110 :
      CustomerNo_CaptionLbl: TextConst ENU='Customer No.',ESP='C¢d. Cliente';
//       MilestoneNo_CaptionLbl@7001109 :
      MilestoneNo_CaptionLbl: TextConst ENU='Milestone No. ',ESP='N§ de Hito';
//       Alias_CaptionLbl@7001108 :
      Alias_CaptionLbl: TextConst ENU='Alias',ESP='Alias';
//       CurrencyCode_CaptionLbl@7001107 :
      CurrencyCode_CaptionLbl: TextConst ENU='Currency code',ESP='C¢d. divisa';
//       ReportTotal_CaptionLbl@7001106 :
      ReportTotal_CaptionLbl: TextConst ENU='Report Total',ESP='Total Informe';
//       ProjectTotal_CaptionLbl@7001105 :
      ProjectTotal_CaptionLbl: TextConst ENU='Project Total',ESP='"Total Proyecto "';

    

trigger OnPreReport();    begin
                  if Job.GETFILTERS <> '' then
                    ProjFilt:= Job.GETFILTERS
                  else
                    ProjFilt:= 'Todos';

                  if "Invoice Milestone".GETFILTERS <> '' then
                    MilestoneFilt := "Invoice Milestone".GETFILTERS
                  else
                    MilestoneFilt := 'Todos';
                end;



/*begin
    end.
  */
  
}



