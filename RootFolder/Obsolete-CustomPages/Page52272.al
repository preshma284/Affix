page 52272 "Outlook Synch. Entity List"
{
Editable=false;
    CaptionML=ENU='Outlook Synchronization Entities',ESP='Entidades de sincronizaci¢n con Outlook';
    SourceTable=51280;
    PageType=List;
    // CardPageID="Outlook Synch. Entity";
    
  layout
{
area(content)
{
repeater("Control1")
{
        
    field("Code";rec."Code")
    {
        
                ToolTipML=ENU='Specifies a unique identifier for each entry in the Outlook Synch. Entity table.',ESP='Especifica un identificador exclusivo para cada movimiento de la tabla Entidad sinc. Outlook.';
                ApplicationArea=Basic,Suite;
    }
    field("Description";rec."Description")
    {
        
                ToolTipML=ENU='Specifies a short description of the synchronization entity that you create.',ESP='Describe brevemente la entidad de sincronizaci¢n que se crea.';
                ApplicationArea=Basic,Suite;
    }
    field("Table Caption";rec."Table Caption")
    {
        
                ToolTipML=ENU='Specifies the name of the Dynamics 365 table to synchronize. The program fills in this field every time you specify a table number in the Table No. field.',ESP='Especifica el nombre de la tabla de Dynamics 365 que se va a sincronizar. El programa rellena este campo cada vez que se especifica un n£mero de tabla en el campo N.§ÿtabla.';
                ApplicationArea=Basic,Suite;
    }
    field("Outlook Item";rec."Outlook Item")
    {
        
                Lookup=false;
                ToolTipML=ENU='Specifies the name of the Outlook item that corresponds to the Dynamics 365 table which you specified in the Table No. field.',ESP='Especifica el nombre del elemento de Outlook correspondiente a la tabla de Dynamics 365 que se especific¢ en el campo N.§ÿtabla.';
                ApplicationArea=Basic,Suite;
                Visible=FALSE ;
    }

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        
                Visible=FALSE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=FALSE;
    }

}
}actions
{
area(Navigation)
{

group("group13")
{
        CaptionML=ENU='S&ynch. Entity',ESP='Entidad s&inc.';
                      Image="OutlookSyncFields";
    action("Action15")
    {
        CaptionML=ENU='Fields',ESP='Campos';
                      ToolTipML=ENU='View the fields to be synchronized.',ESP='Muestra los campos que se van a sincronizar.';
                      ApplicationArea=Basic,Suite;
                      RunObject=Page 52274;
RunPageLink="Synch. Entity Code"=field("Code"), "Element No."=CONST(0);
                      Image="OutlookSyncFields";
    }
    action("Action16")
    {
        Ellipsis=true;
                      CaptionML=ENU='Reset to Defaults',ESP='Restaurar valores predeterminados';
                      ToolTipML=ENU='Insert the default information.',ESP='Inserta la informaci¢n predeterminada.';
                      ApplicationArea=Basic,Suite;
                      Image="Restore";
                      
                                trigger OnAction()    VAR
                                 OutlookSynchSetupDefaults : Codeunit 50859;
                               BEGIN
                                 OutlookSynchSetupDefaults.ResetEntity(rec."Code");
                               END;


    }
    action("Action19")
    {
        Ellipsis=true;
                      CaptionML=ENU='Register in Change Log &Setup',ESP='Registrar en &Config. log cambio';
                      ToolTipML=ENU='Activate the change log to enable tracking of the changes that you made to the synchronization entities.',ESP='Activa el registro de cambios para habilitar el seguimiento de los cambios realizados en las entidades de sincronizaci¢n.';
                      ApplicationArea=Basic,Suite;
                      Image="ImportLog";
                      
                                
    trigger OnAction()    VAR
                                 OSynchEntity : Record 51280;
                               BEGIN
                                 OSynchEntity := Rec;
                                 OSynchEntity.SETRECFILTER;
                                //  REPORT.RUN(REPORT::"Outlook Synch. Change Log Set.",TRUE,FALSE,OSynchEntity);
                               END;


    }

}

}
}
  trigger OnOpenPage()    VAR
                 OutlookSynchSetupDefaults : Codeunit 50859;
               BEGIN
                 OutlookSynchSetupDefaults.InsertOSynchDefaults;
               END;



    /*begin
    end.
  */
}







