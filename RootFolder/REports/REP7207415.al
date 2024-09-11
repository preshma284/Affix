report 7207415 "Budget Expenditure Report"
{
  ApplicationArea=All;

  
  
    CaptionML=ESP='Informe gastos por ppto nivel';
    
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.")
                                 ORDER(Ascending);
               ;
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
}DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 ORDER(Ascending)
                                 WHERE("Type"=CONST("Piecework"));
DataItemLink="Job No."= FIELD("No.");
Column(Data_Piecework;"Data Piecework For Production"."Piecework Code")
{
//SourceExpr="Data Piecework For Production"."Piecework Code";
}Column(Description_Data_Piecework;"Data Piecework For Production".Description)
{
//SourceExpr="Data Piecework For Production".Description;
}DataItem("Job Ledger Entry";"Job Ledger Entry")
{

               DataItemTableView=SORTING("Entry No.")
                                 ORDER(Ascending);
DataItemLink="Job No."= FIELD("Job No."),
                            "Piecework No."= FIELD("Piecework Code");
Column(PostingDate;"Job Ledger Entry"."Posting Date")
{
//SourceExpr="Job Ledger Entry"."Posting Date";
}Column(Type;"Job Ledger Entry".Type)
{
//SourceExpr="Job Ledger Entry".Type;
}Column(DocNo;"Job Ledger Entry"."Document No.")
{
//SourceExpr="Job Ledger Entry"."Document No.";
}Column(SourceName;"Job Ledger Entry"."Source Name")
{
//SourceExpr="Job Ledger Entry"."Source Name";
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
                               //-Q15522 QB 1.09.22 Estaba mal el filtro
                               // IF LastDate<>0D THEN
                               //  "Job Ledger Entry".SETFILTER("Posting Date",'%1..%2',FirstDate,LastDate)
                               // ELSE
                               //  "Job Ledger Entry".SETFILTER("Posting Date",'%1..',FirstDate);
                               IF LastDate<>0D THEN
                                 SETFILTER("Posting Date",'%1..%2',FirstDate,LastDate)
                               ELSE
                                 SETFILTER("Posting Date",'%1..',FirstDate);

                               //+Q15522
                             END;


}trigger OnAfterGetRecord();
    BEGIN 
                                  JobLedgerEntry.SETRANGE("Job No.",Job."No.");
                                  JobLedgerEntry.SETRANGE("Piecework No.","Data Piecework For Production"."Piecework Code");

                                  IF LastDate<>0D THEN
                                    JobLedgerEntry.SETFILTER("Posting Date",'%1..%2',FirstDate,LastDate)
                                  ELSE
                                    JobLedgerEntry.SETFILTER("Posting Date",'%1..',FirstDate);

                                  IF JobLedgerEntry.ISEMPTY THEN
                                    CurrReport.SKIP;
                                END;


}trigger OnPreDataItem();
    BEGIN 
                               Job.SETRANGE("No.",JobNo);
                               IF (Job.COUNT <> 1) THEN
                                 ERROR('No ha seleccionado un £nico proyecto v lido.');
                             END;


}
}
  requestpage
  {

    layout
{
area(content)
{
    field("Proyecto N§";"JobNo")
    {
        
                  CaptionML=ENU='JobNo',ESP='Proyecto N§';
                  TableRelation=Job ;
    }
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
TotalGeneral='Total General/';
Part='Part No./ N§ Parte/';
Report='Report expenditures by budget and level for range and date:/ INFORME GASTOS POR PPTO Y NIVEL para el rango de fechas:/';
VendorName='Vendor Name/ Nombre proveedor/';
}
  
    var
//       JobNo@7001109 :
      JobNo: Code[20];
//       FirstDate@7001107 :
      FirstDate: Date;
//       LastDate@7001106 :
      LastDate: Date;
//       CompanyInfo@7001102 :
      CompanyInfo: Record 79;
//       JobLedgerEntry@7001100 :
      JobLedgerEntry: Record 169;

    

trigger OnInitReport();    begin
                   CompanyInfo.GET;
                   CompanyInfo.CALCFIELDS(Picture);
                 end;



// procedure SetParameters (pJob@1100286000 : Code[20];pFini@1100286002 : Date;pFfin@1100286003 :
procedure SetParameters (pJob: Code[20];pFini: Date;pFfin: Date)
    begin
      //JAV 25/07/19: - Nuevo par metro de proyecto y fechas a imprimir
      JobNo := pJob;
      FirstDate := pFini;
      LastDate := pFfin;
    end;

    /*begin
    //{
//      DCA 14/10/21: - Q15522 QB 1.09.22 Estaba mal el filtro de fechas de los movimientos
//      Q17285 CSM 19/07/22 - Mostrar el nombre del proveedor.
//    }
    end.
  */
  
}




