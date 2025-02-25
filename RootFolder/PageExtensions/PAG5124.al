pageextension 50217 MyExtension5124 extends 5124//5092
{
layout
{
addfirst("content")
{group("Control1100286001")
{
        
                CaptionML=ENU='General',ESP='General';
}
} addafter("No.")
{
group("Control1100286000")
{
        
                CaptionML=ENU='General',ESP='QuoBuilding';
    field("QB_QuoteNo";rec."Quote No.")
    {
        
}
}
}

}

actions
{
addafter("Co&mments")
{
    action("QB_SeeQuote")
    {
        
                      CaptionML=ENU='See Quote',ESP='Mostrar estudio';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=quote;
                      
                                trigger OnAction()    VAR
                                 rJob : Record 167;
                               BEGIN
                                 IF rJob.GET(rec."Quote No.") THEN
                                   PAGE.RUN(PAGE::"Quotes Card",rJob);
                               END;


}
}

}

//trigger

//trigger

var
      Text001 : TextConst ENU='There is no sales quote assigned to this opportunity.',ESP='No hay ofertas de venta asignadas a esta oportunidad.';
      Text002 : TextConst ENU='Sales quote %1 doesn''t exist.',ESP='No existe la oferta de venta %1.';
      OppNo : Code[20];
      SalesCycleCodeEditable : Boolean ;
      SalesDocumentNoEditable : Boolean ;
      SalesDocumentTypeEditable : Boolean ;
      SalespersonCodeEditable : Boolean ;
      CampaignNoEditable : Boolean ;
      PriorityEditable : Boolean ;
      ContactNoEditable : Boolean ;
      Started : Boolean;
      OppInProgress : Boolean;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;

    
    

//procedure
//Local procedure UpdateEditable();
//    begin
//      Started := (rec."Status" <> rec."Status"::"not Started");
//      SalesCycleCodeEditable := rec."Status" = rec."Status"::"not Started";
//      SalespersonCodeEditable := rec."Status" < rec."Status"::Won;
//      CampaignNoEditable := rec."Status" < rec."Status"::Won;
//      PriorityEditable := rec."Status" < rec."Status"::Won;
//      ContactNoEditable := rec."Status" < rec."Status"::Won;
//      SalesDocumentNoEditable := rec."Status" = rec."Status"::"In Progress";
//      SalesDocumentTypeEditable := rec."Status" = rec."Status"::"In Progress";
//    end;
//Local procedure ContactNoOnAfterValidate();
//    begin
//      Rec.CALCFIELDS("Contact Name","Contact Company Name");
//    end;

//procedure
}

