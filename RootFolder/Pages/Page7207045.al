page 7207045 "QB Job Responsibles SubPage"
{
CaptionML=ENU='Responsible',ESP='Responsable';
    SourceTable=7206992;
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("ID Register";rec."ID Register")
    {
        
    }
    field("Position";rec."Position")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("User ID";rec."User ID")
    {
        
    }
    field("Name";rec."Name")
    {
        
    }
    field("No in Approvals";rec."No in Approvals")
    {
        
                ToolTipML=ESP='Si se marca este campo, el usuario no interviene en las aprobaciones';
    }

}

}
}actions
{
area(Processing)
{

    action("CargarPlantilla")
    {
        
                      CaptionML=ENU='Charge Template',ESP='Cargar Plantilla';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=CopyCostBudget;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 Process := FALSE;
                                 IF (Rec.COUNT = 0) THEN
                                   Process := TRUE
                                 ELSE IF (isUsuarioAprobacion) THEN
                                   Process := CONFIRM(Text00, TRUE)
                                 ELSE
                                   MESSAGE(Text01);

                                 //JAV 26/10/20: - QB 1.07.00 Se a¤ade el manejo de departamentos
                                 IF (Process) THEN
                                   QBApprovalManagement.CreateResponsiblesFromTemplate(rec.Type, rec."Table Code", TRUE );
                               END;


    }
    action("AñadirPlantilla")
    {
        
                      CaptionML=ENU='Charge Template',ESP='A�adir Plantilla';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=CopyCostBudget;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 Process := FALSE;
                                 IF (Rec.COUNT = 0) THEN
                                   Process := TRUE
                                 ELSE IF (isUsuarioAprobacion) THEN
                                   Process := CONFIRM(Text01, TRUE)
                                 ELSE
                                   MESSAGE(Text01);

                                 //JAV 26/10/20: - QB 1.07.00 Se a¤ade el manejo de departamentos
                                 IF (Process) THEN
                                   QBApprovalManagement.CreateResponsiblesFromTemplate(rec.Type, rec."Table Code", FALSE );
                               END;


    }
    action("VerCircuitos")
    {
        
                      Promoted=true;
                      Image=List;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    VAR
                                 QBJobResponsiblevsCircuit : Page 7206907;
                               BEGIN
                                 CLEAR(QBJobResponsiblevsCircuit);
                                 QBJobResponsiblevsCircuit.SetJob(Rec.Type::Job, Rec."Table Code");
                                 QBJobResponsiblevsCircuit.RUNMODAL;
                               END;


    }

}
}
  

trigger OnOpenPage()    BEGIN
                 //Miro si el usuario es administrador de aprobaciones
                 UserSetup.GET(USERID);
                 isUsuarioAprobacion := UserSetup."Approval Administrator";
                 CurrPage.EDITABLE := isUsuarioAprobacion;
               END;



    var
      Text00 : TextConst ESP='Ya existen registros de responsables, si contin£a se eliminar n, ¨desea continuar?';
      gType : Option;
      UserSetup : Record 91;
      isUsuarioAprobacion : Boolean;
      Process : Boolean;
      QBApprovalManagement : Codeunit 7207354;
      Text01 : TextConst ESP='Ya existen registros de responsables, si contin£a se a�adir�n nuevos cargos o cambiar�n los responsables, ¨desea continuar?';
      Text02 : TextConst ESP='Ya hay responsables definidos, para cambiarlos debe hacerlo el responsable de aprobaciones';

    /*begin
    end.
  
*/
}







