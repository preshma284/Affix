page 7206956 "QB Framework Contracts"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Blanket Purchase List',ESP='Lista de contratos marco';
    SourceTable=7206937;
    SourceTableView=WHERE("Status"=CONST("Operative"));
    PageType=List;
    CardPageID="QB Framework Contr. Card";
    RefreshOnActivate=true;
    PromotedActionCategoriesML=ENU='New,Process,Report,Request Approval',ESP='Nuevo,Procesar,Informe,Solicitar aprobaci�n';
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("No.";rec."No.")
    {
        
                ToolTipML=ENU='Specifies the number of the involved entry or record, according to the specified number series.',ESP='Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                ApplicationArea=Suite;
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
                ToolTipML=ENU='Specifies the name of the vendor who delivered the items.',ESP='Especifica el nombre del proveedor que envi� los art�culos.';
                ApplicationArea=Suite;
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
                ToolTipML=ENU='Specifies the name of the vendor who delivered the items.',ESP='Especifica el nombre del proveedor que envi� los art�culos.';
                ApplicationArea=Suite;
    }
    field("Generic";rec."Generic")
    {
        
    }
    field("Init Date";rec."Init Date")
    {
        
                ToolTipML=ENU='Specifies the date when the posting of the purchase document will be recorded.',ESP='Especifica la fecha en que se registrar� el registro del documento de compra.';
                ApplicationArea=Suite;
    }
    field("End Date";rec."End Date")
    {
        
    }
    field("Purchaser Code";rec."Purchaser Code")
    {
        
                ToolTipML=ENU='Specifies which purchaser is assigned to the vendor.',ESP='Especifica el comprador asignado al proveedor.';
                ApplicationArea=Suite;
                Visible=FALSE ;
    }
    field("Currency Code";rec."Currency Code")
    {
        
                ToolTipML=ENU='Specifies the code of the currency of the amounts on the purchase lines.',ESP='Especifica el c�digo de divisa de los importes de las l�neas de compra.';
                ApplicationArea=Suite;
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
        ;
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='O&rder',ESP='Pedid&o';
                      Image=Order ;
    action("action1")
    {
        CaptionML=ENU='Co&mments',ESP='Co&mentarios';
                      ToolTipML=ENU='View or add comments for the record.',ESP='Permite ver o agregar comentarios para el registro.';
                      ApplicationArea=Suite;
                      RunObject=Page 66;
RunPageLink="Document Type"=CONST("Blanket Order"), "No."=FIELD("No."), "Document Line No."=CONST(0);
                      Image=ViewComments ;
    }
    action("Approvals")
    {
        
                      AccessByPermission=TableData 454=R;
                      CaptionML=ENU='Approvals',ESP='Aprobaciones';
                      ToolTipML=ENU='View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.',ESP='Permite ver una lista de los registros en espera de aprobaci�n. Por ejemplo, puede ver qui�n ha solicitado la aprobaci�n del registro, cu�ndo se envi� y la fecha de vencimiento de la aprobaci�n.';
                      ApplicationArea=Suite;
                      Image=Approvals;
                      
                                trigger OnAction()    VAR
                                 WorkflowsEntriesBuffer : Record 832;
                               BEGIN
                                 /////WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;


    }

}

}
area(Processing)
{

group("group6")
{
        CaptionML=ENU='F&unctions',ESP='F&unciones';
                      Image=Action ;
    action("Release")
    {
        
                      ShortCutKey='Ctrl+F9';
                      CaptionML=ENU='Re&lease',ESP='Lan&zar';
                      ToolTipML=ENU='Release the document to the Rec.NEXT stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.',ESP='Lance el documento a la siguiente etapa de procesamiento. Cuando se lanza un documento, este se incluir� en todos los c�lculos de disponibilidad a partir de la fecha de recepci�n esperada de los productos. Debe volver a abrir el documento antes de realizar cambios en �l.';
                      ApplicationArea=Suite;
                      Image=ReleaseDoc;
                      
                                trigger OnAction()    VAR
                                 ReleasePurchDoc : Codeunit 415;
                               BEGIN
                                 /////ReleasePurchDoc.PerformManualRelease(Rec);
                               END;


    }
    action("Reopen")
    {
        
                      CaptionML=ENU='Re&open',ESP='&Volver a abrir';
                      ToolTipML=ENU='Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed',ESP='Permite volver a abrir el documento para cambiarlo una vez que se haya aprobado. Los documentos aprobados tienen el estado Lanzado y se deben abrir para poder cambiarlos.';
                      ApplicationArea=Suite;
                      Image=ReOpen;
                      
                                trigger OnAction()    VAR
                                 ReleasePurchDoc : Codeunit 415;
                               BEGIN
                                 /////ReleasePurchDoc.PerformManualReopen(Rec);
                               END;


    }

}
group("group9")
{
        CaptionML=ENU='Request Approval',ESP='Aprobaci�n solic.';
    action("SendApprovalRequest")
    {
        
                      CaptionML=ENU='Send A&pproval Request',ESP='Enviar solicitud a&probaci�n';
                      ToolTipML=ENU='Request approval of the document.',ESP='Permite solicitar la aprobaci�n del documento.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Enabled=NOT OpenApprovalEntriesExist;
                      PromotedIsBig=true;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 ApprovalsMgmt : Codeunit 1535;
                               BEGIN
                                 /////IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                 /////  ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;


    }
    action("CancelApprovalRequest")
    {
        
                      CaptionML=ENU='Cancel Approval Re&quest',ESP='&Cancelar solicitud aprobaci�n';
                      ToolTipML=ENU='Cancel the approval request.',ESP='Cancela la solicitud de aprobaci�n.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=true;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=true;
                      
                                trigger OnAction()    VAR
                                 ApprovalsMgmt : Codeunit 1535;
                               BEGIN
                                 /////ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                               END;


    }

}
    action("QB_PrintContract")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='&Print',ESP='Imprimir Contrato';
                      ToolTipML=ENU='Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.',ESP='Preparar el documento para imprimirlo. Se abre una ventana de solicitud de informe para el documento, donde puede especificar qu� incluir en la impresi�n.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      Image=Print;
                      PromotedCategory=Report;
                      
                                
    trigger OnAction()    VAR
                                 QBPagePublisher : Codeunit 7207348;
                               BEGIN
                                 //JAV 14/03/19: - Imprimir en el formato adecuado para QuoBuilding
                                 /////QBPagePublisher.PurchaseContractPrint("No.");
                               END;


    }

}
}
  
trigger OnOpenPage()    BEGIN
                 //ERROR('Funcionalidad en desarrollo no completado');

                 rec.SetSecurityFilterOnRespCenter;

                 rec.CopyBuyFromVendorFilter;
               END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetControlAppearance;
                         END;



    var
      DocPrint : Codeunit 229;
      OpenApprovalEntriesExist : Boolean;
      CanCancelApprovalForRecord : Boolean;

    LOCAL procedure SetControlAppearance();
    var
      ApprovalsMgmt : Codeunit 1535;
    begin
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(rec.RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(rec.RECORDID);
    end;

    // begin
    /*{
      //JAV 14/03/19: - Imprimir en el formato adecuado para QuoBuilding, se cambia la acci�n Print
      Q12867 JDC 25/02/21 - Modified property "SourceTableView"
      JAV 10/08/22: - QB 1.11.01 Se cambia el campo estado y el propio estado
    }*///end
}









