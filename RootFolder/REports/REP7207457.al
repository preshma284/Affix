report 7207457 "QB Review Job Purchases"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Review Job Purchases',ESP='Revisi¢n Compras de Proyectos';
    
  dataset
{

DataItem("CABF";"Purch. Inv. Header")
{

               DataItemTableView=SORTING("No.");
               ;
Column(COMPANYNAME;COMPANYNAME)
{
//SourceExpr=COMPANYNAME;
}Column(Filters;Filters)
{
//SourceExpr=Filters;
}Column(ALB_Type;TRUE)
{
//SourceExpr=TRUE;
}Column(DocumentNo;"No.")
{
//SourceExpr="No.";
}Column(PostingDate;"Posting Date")
{
//SourceExpr="Posting Date";
}Column(JobNo;"Job No.")
{
//SourceExpr="Job No.";
}Column(VendorNo;"Buy-from Vendor No.")
{
//SourceExpr="Buy-from Vendor No.";
}Column(VendorName;Vendor.Name)
{
//SourceExpr=Vendor.Name;
}Column(TFactura;TFactura)
{
//SourceExpr=TFactura;
}Column(TProyecto;TProyecto)
{
//SourceExpr=TProyecto;
}Column(TDiferencia;TDiferencia )
{
//SourceExpr=TDiferencia ;
}trigger OnPreDataItem();
    BEGIN 
                               IF (DateFilter <> '') THEN
                                 CABF.SETFILTER("Posting Date", DateFilter);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF NOT Vendor.GET("Buy-from Vendor No.") THEN
                                    Vendor.INIT;

                                  CABF.CALCFIELDS(Amount);
                                  TFactura := CABF.Amount;
                                  IF (TFactura = 0) THEN
                                    CurrReport.SKIP;

                                  TProyecto := 0;
                                  JobLedgerEntry.RESET;
                                  JobLedgerEntry.SETRANGE("Document No.", CABF."No.");
                                  IF (JobLedgerEntry.FINDSET(FALSE)) THEN
                                    REPEAT
                                      TProyecto += JobLedgerEntry."Total Cost";
                                    UNTIL (JobLedgerEntry.NEXT = 0);

                                  TDiferencia := ABS(TFactura - TProyecto);
                                  IF (TProyecto <> 0) AND (NOT SeeAll) THEN
                                    CurrReport.SKIP;
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group978")
{
        
    field("opcDfecha";"opcDfecha")
    {
        
                  CaptionML=ESP='Desde fecha';
    }
    field("opcHfecha";"opcHfecha")
    {
        
                  CaptionML=ESP='Hasta fecha';
    }
    field("SeeAll";"SeeAll")
    {
        
                  CaptionML=ESP='Ver Todos';
    }

}

}
}
  }
  labels
{
NameReport='Invoiced Pending Shipments/ Cuadre Albaranes-Contabilidad/';
PageNo='Page No./ P g./';
Doc='Document N§/ N§ Doc./';
FReg='Posting Date/ Fecha Registro/';
}
  
    var
//       PurchInvLine@1000000000 :
      PurchInvLine: Record 123;
//       PurchRcptLine@1100286000 :
      PurchRcptLine: Record 121;
//       JobLedgerEntry@1100286011 :
      JobLedgerEntry: Record 169;
//       Job@7001103 :
      Job: Record 167;
//       Vendor@7001102 :
      Vendor: Record 23;
//       Filters@7001100 :
      Filters: Text;
//       TFactura@7001106 :
      TFactura: Decimal;
//       TProyecto@1100286001 :
      TProyecto: Decimal;
//       TDiferencia@1000000001 :
      TDiferencia: Decimal;
//       txtAux@1100286008 :
      txtAux: Text;
//       DateFilterTxt@1100286016 :
      DateFilterTxt: Text;
//       DateFilter@1100286002 :
      DateFilter: Text;
//       "------------------------- Opciones"@1100286010 :
      "------------------------- Opciones": Integer;
//       opcDfecha@1100286012 :
      opcDfecha: Date;
//       opcHfecha@1100286013 :
      opcHfecha: Date;
//       SeeAll@1100286014 :
      SeeAll: Boolean;

    

trigger OnPreReport();    begin
                  DateFilter := '';
                  if (opcDfecha <> 0D) then
                    DateFilter += FORMAT(opcDfecha,0,'<Day,2><Month,2><Year>');
                  if (opcDfecha <> 0D) or (opcHfecha <> 0D) then
                    DateFilter += '..';
                  if (opcHfecha <> 0D) then
                    DateFilter += FORMAT(opcHfecha,0,'<Day,2><Month,2><Year>');

                  DateFilterTxt := '';
                  if (opcDfecha <> 0D) then
                    DateFilterTxt += ' Desde ' + FORMAT(opcDfecha);
                  if (opcHfecha <> 0D) then
                    DateFilterTxt += ' Hasta ' + FORMAT(opcHfecha);
                  if (DateFilter = '') then
                    DateFilterTxt := 'Todas';

                  Filters := 'Filtros = Fechas: ' + DateFilterTxt ;
                end;



/*begin
    end.
  */
  
}




