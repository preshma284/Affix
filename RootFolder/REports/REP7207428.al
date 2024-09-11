report 7207428 "Jobs expenses without units"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='jobs expenses without units',ESP='Informe gastos por obra sin unidades';
    
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               RequestFilterFields="No.";
Column(No_Job;Job."No.")
{
//SourceExpr=Job."No.";
}Column(JobDescription2;Job."Description 2")
{
//SourceExpr=Job."Description 2";
}Column(Job_Description;Job.Description)
{
//SourceExpr=Job.Description;
}Column(Budget;Job."Budgeted Amount")
{
//SourceExpr=Job."Budgeted Amount";
}Column(Company_Name;CompanyInfo.Name)
{
//SourceExpr=CompanyInfo.Name;
}Column(Picture;CompanyInfo.Picture)
{
//SourceExpr=CompanyInfo.Picture;
}Column(FDate;FirstDate)
{
//SourceExpr=FirstDate;
}Column(LDate;LastDate)
{
//SourceExpr=LastDate;
}DataItem("Job Ledger Entry";"Job Ledger Entry")
{

               DataItemTableView=SORTING("Job No.","Posting Date")
                                 ORDER(Ascending)
                                 WHERE("Entry Type"=CONST("Usage"));
DataItemLink="Job No."= FIELD("No.");
Column(PostingDate;"Job Ledger Entry"."Posting Date")
{
//SourceExpr="Job Ledger Entry"."Posting Date";
}Column(Type;"Job Ledger Entry".Type)
{
//SourceExpr="Job Ledger Entry".Type;
}Column(DocNo;"Job Ledger Entry"."Document No.")
{
//SourceExpr="Job Ledger Entry"."Document No.";
}Column(No;"Job Ledger Entry"."No.")
{
//SourceExpr="Job Ledger Entry"."No.";
}Column(Description_Entry;"Job Ledger Entry".Description)
{
//SourceExpr="Job Ledger Entry".Description;
}Column(UnitOfMeasureCod;"Job Ledger Entry"."Unit of Measure Code")
{
//SourceExpr="Job Ledger Entry"."Unit of Measure Code";
}Column(Quantity;"Job Ledger Entry".Quantity)
{
//SourceExpr="Job Ledger Entry".Quantity;
}Column(UnitCost;"Job Ledger Entry"."Unit Cost (LCY)")
{
//SourceExpr="Job Ledger Entry"."Unit Cost (LCY)";
}Column(TotalCost;"Job Ledger Entry"."Total Cost (LCY)" )
{
//SourceExpr="Job Ledger Entry"."Total Cost (LCY)" ;
}trigger OnPreDataItem();
    BEGIN 
                               IF LastDate<>0D THEN
                                 "Job Ledger Entry".SETFILTER("Posting Date",'%1..%2',FirstDate,LastDate)
                               ELSE
                                 "Job Ledger Entry".SETFILTER("Posting Date",'%1..',FirstDate);
                             END;


}
}
}
  requestpage
  {

    layout
{
area(content)
{
    field("Fecha Inicio";"FirstDate")
    {
        
    }
    field("Fecha Fin";"LastDate")
    {
        
    }

}
}
  }
  labels
{
Title='REPORT EXPENDITURES BY BUDGET AND LEVEL/ IMPORTE GASTO POR PTTs Y NIVEL/';
Page='Page/ P gina/';
Date='Date/ Fecha/';
TypeCost='Type of cost/ Tipo de Coste/';
Delivery='Delivery Note/ Albar n/';
Resource='Resource/ Recurso/';
Item='Item Name/ Nombre de art¡culo/';
Unit='Unit/ Unidad/';
Quantitys='Quantity/ Cantidad/';
UnitCosts='Unit Cost/ Precio Coste/';
AmountWorks='Amount for works/ Importe para Obras/';
Works='WORKS/ OBRA/';
TotaLevel='Total Level/ Total Nivel/';
Part='Part No./ N§ Parte/';
Report='Report expenditures by budget and level for range and date:/ INFORME GASTOS POR PPTO Y NIVEL para el rango de fechas:/';
}
  
    var
//       FirstDate@7001107 :
      FirstDate: Date;
//       LastDate@7001106 :
      LastDate: Date;
//       CompanyInfo@7001102 :
      CompanyInfo: Record 79;

    

trigger OnInitReport();    begin
                   CompanyInfo.GET;
                   CompanyInfo.CALCFIELDS(Picture);
                 end;



/*begin
    end.
  */
  
}




