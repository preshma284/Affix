pageextension 50225 MyExtension537 extends 537//349
{
layout
{
addafter("Consolidation Code")
{
    field("Type";rec."Type")
    {
        
                CaptionML=ESP='Tipo';
                Visible=seeCA ;
}
    field("Jobs desviation";rec."Jobs desviation")
    {
        
                Visible=seeDpto ;
}
    field("Jobs Not Assigned";rec."Jobs Not Assigned")
    {
        
                Visible=seeDpto ;
}
    field("Job Structure Warehouse";rec."Job Structure Warehouse")
    {
        
                Visible=seeDpto ;
}
    field("Reestimation Date";rec."Reestimation Date")
    {
        
                Visible=seeReestimation ;
}
    field("Account Budget E Reestimations";rec."Account Budget E Reestimations")
    {
        
                Visible=seeCA ;
}
    field("Cash MGT Rule Code";rec."Cash MGT Rule Code")
    {
        
                Visible=seeCA ;
}
    field("QB Department";rec."QB Department")
    {
        
                Visible=seeDpto ;
}
    field("DP Prorrata Non deductible";rec."DP Prorrata Non deductible")
    {
        
                Visible=seeProrrata ;
}
}

}

actions
{
addfirst("Processing")
{group("Reestimations")
{
        
                      CaptionML=ESP='Reestimaci¢n';
    action("QB_CreateReestimationsValue")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='Generate Reestimations Code',ESP='Generar c¢digo reestimaciones';
                      RunPageOnRec=true;
                      Promoted=true;
                      Visible=seeReestimation;
                      PromotedIsBig=true;
                      Image=CreateMovement;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 // QB.begin
                                //  REPORT.RUNMODAL(REPORT::"Generate Reestimation Code");
                                 CurrPage.UPDATE(FALSE);
                                 // QB.end
                               END;


}
}
} addfirst("F&unctions")
{
    action("Action1100286000")
    {
        CaptionML=ENU='Indent Dimension Values',ESP='Indent. valores dimensi¢n';
                      ToolTipML=ENU='Indent dimension values between a Begin-Total and the matching End-Total one level to make the list easier to read.',ESP='Permite aplicar sangr¡a a valores de dimensi¢n entre un Inicio-Total y el Fin-Total correspondiente para que la lista sea m s f cil de leer.';
                      ApplicationArea=Dimensions;
                      RunObject=Codeunit 409;
                      RunPageOnRec=true;
                      Image=Indent;
}
    action("QB_Value-Indent")
    {
        CaptionML=ESP='Indent. valores por longitud';
                      ToolTipML=ESP='Permite aplicar sangr¡a a valores de dimensi¢n seg£n las longitudes de los valores de la dimensi¢n.';
                      ApplicationArea=Dimensions;
                      RunPageOnRec=true;
                      Image=IndentChartOfAccounts;
}
    action("QB_Value-Indent_Void")
    {
        CaptionML=ESP='Anular Indentaci¢n';
                      ToolTipML=ESP='Anular la Indentaci¢n';
                      ApplicationArea=Dimensions;
                      RunPageOnRec=true;
                      Image=CancelIndent;
}
}

}

//trigger
trigger OnOpenPage()    VAR
                 DimensionCode : Code[20];
               BEGIN
                 IF Rec.GETFILTER("Dimension Code") <> '' THEN
                   DimensionCode := Rec.GETRANGEMIN("Dimension Code");
                 IF DimensionCode <> '' THEN BEGIN
                   Rec.FILTERGROUP(2);
                   Rec.SETRANGE("Dimension Code",DimensionCode);
                   Rec.FILTERGROUP(0);
                 END;

                 // JAV 06/10/20: - QB 1.06.18 Solo es visible el bot¢n de reestimaciones si es la dimensi¢n de reestimaci¢n
                 seeReestimation := (FunctionQB.ReturnDimReest = rec."Dimension Code");
                 //JAV 02/04/21: - QB 1.08.32 Columnas visibles en funci¢n del tipo de dimensi¢n
                 //JAV 25/06/22: - QB 1.10.54 Se mejora el filtro de entrada haciendo que tome el valor del filtro de entrada, as¡ funciona en mas casos
                 seeCA := (FunctionQB.ReturnDimCA = DimensionCode);
                 seeDpto := (FunctionQB.ReturnDimDpto = DimensionCode);
                 seeProrrata := DPManagement.DimensionForProrrata() = DimensionCode;
               END;


//trigger

var
      Emphasize : Boolean ;
      NameIndent : Integer ;
      "------------------------- QB" : Integer;
      seeCA : Boolean;
      seeDpto : Boolean;
      seeReestimation : Boolean;
      FunctionQB : Codeunit 7207272;
      "------------------------ Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;

    
    

//procedure
//Local procedure FormatLine();
//    begin
//      Emphasize := rec."Dimension Value Type" <> rec."Dimension Value Type"::Standard;
//      NameIndent := rec."Indentation";
//    end;

//procedure
}

