report 7207398 "QB Posted Location Adjust"
{
  
  
    
  dataset
{

DataItem("QB Posted Receipt/Trans.Header";"QB Posted Receipt/Trans.Header")
{

               RequestFilterFields="No.";
Column(No_PostedReceiptHeader;"QB Posted Receipt/Trans.Header"."No.")
{
//SourceExpr="QB Posted Receipt/Trans.Header"."No.";
}Column(PostingDate_PostedReceiptHeader;"QB Posted Receipt/Trans.Header"."Posting Date")
{
//SourceExpr="QB Posted Receipt/Trans.Header"."Posting Date";
}Column(Type_PostedReceiptHeader;"QB Posted Receipt/Trans.Header".Type)
{
//SourceExpr="QB Posted Receipt/Trans.Header".Type;
}Column(OriginLocation_PostedReceiptHeader;"QB Posted Receipt/Trans.Header".Location)
{
//SourceExpr="QB Posted Receipt/Trans.Header".Location;
}Column(DestinationLocation_PostedReceiptHeader;"QB Posted Receipt/Trans.Header"."Destination Location")
{
//SourceExpr="QB Posted Receipt/Trans.Header"."Destination Location";
}Column(JobNo_PostedReceiptHeader;"QB Posted Receipt/Trans.Header"."Job No.")
{
//SourceExpr="QB Posted Receipt/Trans.Header"."Job No.";
}Column(Name_CompanyInformation;CompanyInformation.Name)
{
//SourceExpr=CompanyInformation.Name;
}Column(Name2_CompanyInformation;CompanyInformation."Name 2")
{
//SourceExpr=CompanyInformation."Name 2";
}DataItem("QB Posted Receipt/Trans.Lines";"QB Posted Receipt/Trans.Lines")
{

DataItemLink="Document No."= FIELD("No.");
Column(ItemNo_PostedReceiptLine;"QB Posted Receipt/Trans.Lines"."Item No.")
{
//SourceExpr="QB Posted Receipt/Trans.Lines"."Item No.";
}Column(Description_PostedReceiptLine;"QB Posted Receipt/Trans.Lines".Description)
{
//SourceExpr="QB Posted Receipt/Trans.Lines".Description;
}Column(UnitMeasure_PostedReceiptLine;"QB Posted Receipt/Trans.Lines"."Unit of Measure Code")
{
//SourceExpr="QB Posted Receipt/Trans.Lines"."Unit of Measure Code";
}Column(Quantity_PostedReceiptLine;"QB Posted Receipt/Trans.Lines".Quantity)
{
//SourceExpr="QB Posted Receipt/Trans.Lines".Quantity;
}Column(UnitCost_PostedReceiptLine;"QB Posted Receipt/Trans.Lines"."Unit Cost")
{
//SourceExpr="QB Posted Receipt/Trans.Lines"."Unit Cost";
}Column(TotalCost_PostedReceiptLine;"QB Posted Receipt/Trans.Lines"."Total Cost" )
{
//SourceExpr="QB Posted Receipt/Trans.Lines"."Total Cost" ;
}
}
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
AjusteAlmacenLbl='Location Adjust/ Ajustes Almac‚n/';
PagLbl='Page/ P g./';
JobNoLbl='Job No.:/ N§ Proyecto:/';
PostingDateLbl='Posting Date:/ Fecha registro:/';
TypeLbl='Type:/ Tipo:/';
NLbl='No.:/ N§:/';
OLocationLbl='Origin Location:/ Almac‚n origen:/';
DLocationLbl='Destination Location:/ Almac‚n destino:/';
ItemNoLbl='Item No./ N§ Prod./';
DescrLbl='Description/ Descripci¢n/';
UMLbl='UM/ UM/';
QuantityLbl='Quantity/ Cantidad/';
UnitCostLbl='Unit Cost/ Coste unitario/';
TotalCostLbl='Total Cost/ Coste total/';
TotalLbl='TOTAL/ TOTAL/';
}
  
    var
//       CompanyInformation@1100286000 :
      CompanyInformation: Record 79;

    

trigger OnInitReport();    begin
                   CompanyInformation.GET;
                 end;



/*begin
    end.
  */
  
}



