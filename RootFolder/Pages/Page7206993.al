page 7206993 "OLD_QB Approval User Setup"
{
CaptionML=ENU='Approval User Setup',ESP='Config. usuario aprobaci�n';
    SourceTable=91;
    PageType=ListPart;
    UsageCategory=Administration;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("User ID";rec."User ID")
    {
        
                ToolTipML=ENU='Specifies the ID of the user who posted the entry, to be used, for example, in the change log.',ESP='Especifica el identificador del usuario que registr� el movimiento, que se usar�, por ejemplo, en el registro de cambios.';
                ApplicationArea=Suite;
    }
    field("E-Mail";rec."E-Mail")
    {
        
                ExtendedDatatype=EMail;
                ToolTipML=ENU='Specifies the email address of the approver that you can use if you want to send approval mail notifications.',ESP='Especifica la direcci�n de correo electr�nico del aprobador que puede usar si desea enviar notificaciones de aprobaci�n por correo.';
                ApplicationArea=Suite;
    }
    field("View all Jobs";rec."View all Jobs")
    {
        
    }
    field("Approval Administrator";rec."Approval Administrator")
    {
        
                ToolTipML=ENU='Specifies the user who has rights to unblock approval workflows, for example, by delegating approval requests to new substitute approvers and deleting overdue approval requests.',ESP='Especifica el usuario que tiene derechos para desbloquear los flujos de trabajo de aprobaci�n, por ejemplo, al delegar solicitudes de aprobaci�n en aprobadores sustitutos y eliminar solicitudes de aprobaci�n vencidas.';
                ApplicationArea=Suite;
    }
    field("Substitute";rec."Substitute")
    {
        
                ToolTipML=ENU='Specifies the User ID of the user who acts as a substitute for the original approver.',ESP='Especifica el id. de usuario de quien act�a como sustituto del aprobador original.';
                ApplicationArea=Suite;
    }
    field("Substitute from date";rec."Substitute from date")
    {
        
    }
    field("Substitute to date";rec."Substitute to date")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("Notification Setup")
    {
        
                      CaptionML=ENU='Notification Setup',ESP='Configuraci�n de notificaci�n';
                      ToolTipML=ENU='Specify how the user receives notifications, for example about approval workflow steps.',ESP='Especifica c�mo recibe el usuario las notificaciones, por ejemplo, sobre pasos de flujo de trabajo de aprobaci�n.';
                      ApplicationArea=Suite;
                      RunObject=Page 1512;
RunPageLink="User ID"=FIELD("User ID");
                      Promoted=true;
                      Image=Setup;
                      PromotedCategory=Process ;
    }
    action("Delegate")
    {
        
                      CaptionML=ESP='Delegar';
                      
                                
    trigger OnAction()    BEGIN
                                 DelegateAll;
                               END;


    }

}
}
  trigger OnOpenPage()    BEGIN
                 rec.HideExternalUsers;
               END;




    LOCAL procedure DelegateAll();
    var
      // QBApprovalSubstitute : Report 7207410;
    begin
      // CLEAR(QBApprovalSubstitute);
      // QBApprovalSubstitute.RUN;
    end;

    // begin
    /*{
      Q2431 NZG 27/06/2018 Se a�ade el campo "Purchaser Code"
    }*///end
}







