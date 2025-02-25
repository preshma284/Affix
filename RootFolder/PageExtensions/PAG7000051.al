pageextension 50268 MyExtension7000051 extends 7000051//7000020
{
layout
{
addafter("Elect. Pmts Exported")
{
    field("QB_Confirming";rec."Confirming")
    {
        
                Visible=seeConfirming ;
}
    field("QB_ConfirmingLine";rec."Confirming Line")
    {
        
                Visible=seeConfirming ;
}
    field("QB_Department";rec."QB Department")
    {
        
}
    field("QB_ApprovalSituation";rec."Approval Status")
    {
        
}
}

}

actions
{
addafter("Post and &Print")
{
group("INESCO_Confirming")
{
        
                      CaptionML=ESP='rec."Confirming"';
                      Visible=seeInesco;
                      Image=ElectronicDoc ;
    action("INESCO_Confirming La Caixa")
    {
        
                      CaptionML=ESP='Confirming La Caixa';
                      
                                trigger OnAction()    BEGIN
                                 Rec.SETRECFILTER;
                                //  REPORT.RUN(REPORT::"Confirming La Caixa Inesco",TRUE,FALSE,Rec);
                                 Rec.RESET;
                                 CurrPage.UPDATE;
                               END;


}
    action("INESCO_Confirming Bankia")
    {
        
                      CaptionML=ESP='Confirming Bankia';
                      
                                trigger OnAction()    BEGIN
                                 Rec.SETRECFILTER;
                                //  REPORT.RUN(REPORT::"Confirming Bankia Inesco",TRUE,FALSE,Rec);
                                 Rec.RESET;
                                 CurrPage.UPDATE;
                               END;


}
    action("INESCO_Confirming BBVA")
    {
        
                      CaptionML=ESP='Confirming BBVA';
                      
                                trigger OnAction()    BEGIN
                                 Rec.SETRECFILTER;
                                //  REPORT.RUN(REPORT::"Confirming BBVA Inesco",TRUE,FALSE,Rec);
                                 Rec.RESET;
                                 CurrPage.UPDATE;
                               END;


}
    action("INESCO_Confirming Santander")
    {
        
                      CaptionML=ESP='Confirming Santander';
                      
                                trigger OnAction()    BEGIN
                                 Rec.SETRECFILTER;
                                //  REPORT.RUN(REPORT::"Confirming Santander Inesco",TRUE,FALSE,Rec);
                                 Rec.RESET;
                                 CurrPage.UPDATE;
                               END;


}
    action("INESCO_Confirming Deutsche Bank")
    {
        
                      CaptionML=ESP='Confirming Deutsche Bank';
                      
                                trigger OnAction()    BEGIN
                                 Rec.SETRECFILTER;
                                //  REPORT.RUN(REPORT::"Confirming DeutscheBank Inesco",TRUE,FALSE,Rec);
                                 Rec.RESET;
                                 CurrPage.UPDATE;
                               END;


}
    action("INESCO_Confirming Bankinter")
    {
        
                      CaptionML=ESP='Confirming Bankinter';
                      
                                trigger OnAction()    BEGIN
                                 Rec.SETRECFILTER;
                                //  REPORT.RUN(REPORT::"Confirminet Bankinter Inesco",TRUE,FALSE,Rec);
                                 Rec.RESET;
                                 CurrPage.UPDATE;
                               END;


}
}
}


//modify("Post")
//{
//
//
//}
//

//modify("Post and &Print")
//{
//
//
//}
//
}

//trigger
trigger OnOpenPage()    BEGIN
                 //rec."Confirming"
                 seeConfirming := (QBCartera.IsFactoringActive);

                 //JAV 04/03/22: - QB 1.10.23 Manejo de las customizacines de los clientes
                 seeInesco := (FunctionQB.IsClient('INE'));
               END;


//trigger

var
      PmtOrd : Record 7000020;
      PostBGPO : Codeunit 7000003;
      "------------------------------ QB" : Integer;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;
      cuApproval : Codeunit 7206927;
      FunctionQB : Codeunit 7207272;
      seeInesco : Boolean;

    

//procedure

//procedure
}

