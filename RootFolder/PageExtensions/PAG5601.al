pageextension 50231 MyExtension5601 extends 5601//5600
{
layout
{
addafter("Acquired")
{
    field("QB_Job";rec."Asset Allocation Job")
    {
        
                CaptionML=ESP='Proyecto';
                ApplicationArea=FixedAssets;
                TableRelation=Job ;
}
    field("QB_Piecework";rec."Piecework Code")
    {
        
                CaptionML=ESP='Unidad de Obra';
                ApplicationArea=FixedAssets;
                TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=field("FA Location Code")) ;
}
}

}

actions
{
addafter("Co&mments")
{
    action("QB_AnaliticalDistribution")
    {
        
                      CaptionML=ENU='Job Distribution',ESP='Distribuci¢n Por Proyecto';
                      ToolTipML=ESP='Distribuci¢n de la amortizaci¢n por Proyecto/UO-Partida Presupuestaria';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Track;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    VAR
                                 pgAnaliticalDistr : Page 7206996;
                               BEGIN
                                 pgAnaliticalDistr.SetFA(rec."No.");
                                 pgAnaliticalDistr.RUNMODAL;

                                 CurrPage.UPDATE(TRUE);
                               END;


}
group("QB_MaintenanceLists")
{
        
                      CaptionML=ENU='Maintenance Lists',ESP='Mantenimiento';
                      Image=FixedAssets ;
    action("QB_AssetsMaintenance")
    {
        CaptionML=ENU='Assets Maintenance',ESP='Mantenimiento Activos fijos';
                      RunObject=Page 50054;
RunPageLink="No."=field("No.");
                      Promoted=true;
                      Image=FixedAssetLedger;
                      PromotedCategory=Process;
}
    action("QB_TechnicalDetails")
    {
        CaptionML=ENU='Technical Details',ESP='Ficha t‚cnica';
                      RunObject=Page 50055;
RunPageLink="Asset No."=field("No.");
                      Image=FixedAssetLedger;
}
    action("QB_Certificatios")
    {
        CaptionML=ENU='Certificatios',ESP='Certificaciones';
                      RunObject=Page 50056;
RunPageLink="Asset No."=field("No.");
                      Image=FixedAssetLedger;
}
    action("QB_Status Control")
    {
        CaptionML=ENU='Status Control',ESP='Control de estado';
                      RunObject=Page 50057;
RunPageLink="Asset No."=field("No.");
                      Image=FixedAssetLedger;
}
}
}

}

//trigger
trigger OnAfterGetRecord()    BEGIN
                       QB_LoadDepreciationBook;
                     END;


//trigger

var
      "------------------------------- QB" : Integer;
      FADepreciationBook : Record 5612;

    
    

//procedure
LOCAL procedure "--------------------------------- QB"();
    begin
    end;
LOCAL procedure QB_LoadDepreciationBook();
    begin
      FADepreciationBook.RESET;
      FADepreciationBook.SETRANGE("FA No.",rec."No.");
      if ( (not FADepreciationBook.FINDFIRST)  )then
        CLEAR(FADepreciationBook);
    end;

//procedure
}

