page 7206957 "QB Framework Contr. Card"
{
CaptionML=ENU='Blanket Purchase',ESP='Contrato Marco';
    SourceTable=7206937;
    PageType=Document;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
group("group14")
{
        
                CaptionML=ENU='General',ESP='General';
    field("No.";rec."No.")
    {
        
                ToolTipML=ENU='Specifies the number of the involved entry or record, according to the specified number series.',ESP='Especifica el n�mero de la entrada o el registro relacionado, seg�n la serie num�rica especificada.';
                ApplicationArea=Suite;
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
                CaptionML=ENU='Vendor No.',ESP='N.� de proveedor';
                ToolTipML=ENU='Specifies the number of the vendor who delivers the products.',ESP='Especifica el n�mero del proveedor que envi� los productos.';
                ApplicationArea=Suite;
                NotBlank=true;
                
                            ;trigger OnValidate()    BEGIN
                             rec.OnAfterValidateBuyFromVendorNo(Rec,xRec);
                             CurrPage.UPDATE;
                           END;


    }
    field("Vendor Name";rec."Vendor Name")
    {
        
                CaptionML=ENU='Vendor Name',ESP='Nombre del proveedor';
                ToolTipML=ENU='Specifies the name of the vendor who delivers the products.',ESP='Permite especificar el nombre del proveedor que envi� los productos.';
                ApplicationArea=Suite;
                Importance=Promoted;
                
                            ;trigger OnValidate()    BEGIN
                             rec.OnAfterValidateBuyFromVendorNo(Rec,xRec);

                             CurrPage.UPDATE;
                           END;


    }
    field("Contact No.";rec."Contact No.")
    {
        
                CaptionML=ENU='Contact',ESP='Contacto';
                ToolTipML=ENU='Specifies the name of the person to contact about shipment of the item from this vendor.',ESP='Especifica el nombre de la persona con quien contactarse acerca del env�o del art�culo de este proveedor.';
                ApplicationArea=Suite;
                Editable=rec."Vendor No." <> '' ;
    }
    field("Purchaser Code";rec."Purchaser Code")
    {
        
                ToolTipML=ENU='Specifies which purchaser is assigned to the vendor.',ESP='Especifica el comprador asignado al proveedor.';
                ApplicationArea=Suite;
    }
    field("Use In";rec."Use In")
    {
        
    }
    field("Init Date";rec."Init Date")
    {
        
                ToolTipML=ENU='Specifies the date when the related document was created.',ESP='Especifica la fecha en la que se cre� el documento correspondiente.';
                ApplicationArea=Suite;
    }
    field("End Date";rec."End Date")
    {
        
    }
    field("Status";rec."Status")
    {
        
                ToolTipML=ENU='Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the Rec.NEXT stage of processing.',ESP='Especifica si el registro est� abierto, en espera de aprobaci�n, facturado para prepago o ha pasado a la etapa siguiente de procesamiento.';
                ApplicationArea=Suite;
    }
group("group24")
{
        
                CaptionML=ESP='Datos';
    field("Generic";rec."Generic")
    {
        
    }
    field("QB_ActivityCode";rec."Activity code")
    {
        
    }
    field("QB_TypeOfOrder";rec."Type of Order")
    {
        
    }
    field("Currency Code";rec."Currency Code")
    {
        
                ToolTipML=ENU='Specifies the currency that is used on the entry.',ESP='Especifica la divisa usada en el movimiento.';
                ApplicationArea=Suite;
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Payment Terms Code";rec."Payment Terms Code")
    {
        
                ToolTipML=ENU='Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.',ESP='Especifica una f�rmula que calcula la fecha de vencimiento del pago, la fecha de descuento por pronto pago y el importe de descuento por pronto pago.';
                ApplicationArea=Suite;
                Importance=Promoted;
                ShowMandatory=TRUE ;
    }
    field("Payment Method Code";rec."Payment Method Code")
    {
        
                ToolTipML=ENU='Specifies how to make payment, such as with bank transfer, cash, or check.',ESP='Especifica c�mo realizar el pago, por ejemplo transferencia bancaria, en efectivo o con cheque.';
                ApplicationArea=Suite;
                ShowMandatory=TRUE ;
    }
    field("QB_CodWithholdingByGE";rec."Cod. Withholding by G.E")
    {
        
    }
    field("QB_CodWithholdingByPIT";rec."Cod. Withholding by PIT")
    {
        
    }
    field("VAT Bus. Posting Group";rec."VAT Bus. Posting Group")
    {
        
                ToolTipML=ENU='Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.',ESP='Indica la especificaci�n de IVA del cliente o el proveedor relacionado para vincular las transacciones realizadas para este registro con la cuenta de contabilidad general correspondiente de acuerdo con la configuraci�n de registro de IVA.';
                ApplicationArea=Suite;
    }

}

}
    part("PurchLines";7206958)
    {
        
                ApplicationArea=Suite;SubPageLink="Document No."=FIELD("No.");
                UpdatePropagation=Both ;
    }

}
area(FactBoxes)
{
    part("Attached Documents";1174)
    {
        
                CaptionML=ENU='Attachments',ESP='Datos adjuntos';
                ApplicationArea=All;SubPageLink="Table ID"=CONST(7206937), "No."=FIELD("No.");
    }
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
        CaptionML=ENU='O&rder',ESP='&Pedido';
                      Image=Order ;
    action("action1")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      ToolTipML=ENU='View or edit detailed information about the vendor on the purchase document.',ESP='Permite ver o editar la informaci�n detallada sobre el proveedor en el documento de compra.';
                      ApplicationArea=Suite;
                      RunObject=Page 26;
RunPageLink="No."=FIELD("Vendor No.");
                      Image=EditLines ;
    }
    action("action2")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      ToolTipML=ENU='View or add comments for the record.',ESP='Permite ver o agregar comentarios para el registro.';
                      ApplicationArea=Suite;
                      RunObject=Page 66;
RunPageLink="Document Type"=CONST("Blanket Order"), "No."=FIELD("No."), "Document Line No."=CONST(0);
                      Image=ViewComments ;
    }
    action("DocAttach")
    {
        
                      CaptionML=ENU='Attachments',ESP='Datos adjuntos';
                      ToolTipML=ENU='Add a file as an attachment. You can attach images as well as documents.',ESP='Permite agregar un archivo como adjunto. Puede adjuntar im�genes y documentos.';
                      ApplicationArea=All;
                      Image=Attach;
                      
                                trigger OnAction()    VAR
                                 DocumentAttachmentDetails : Page 1173;
                                 RecRef : RecordRef;
                               BEGIN
                                 RecRef.GETTABLE(Rec);
                                 DocumentAttachmentDetails.OpenForRecRef(RecRef);
                                 DocumentAttachmentDetails.RUNMODAL;
                               END;


    }

}

}
area(Processing)
{

group("group7")
{
        CaptionML=ENU='F&unctions',ESP='Acci&ones';
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

                                 //JAV 10/08/22: - QB 1.11.01 Se cambia el campo Aprobaci�n por el de estado y el propio estado
                                 //"OLD_Approval Situation" := "OLD_Approval Situation"::Approved;
                                 rec.Status := rec.Status::Operative;
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
                                 //JAV 10/08/22: - QB 1.11.01 Se cambia el campo Aprobaci�n por el de estado y el propio estado
                                 //"OLD_Approval Situation" := "OLD_Approval Situation"::Pending;
                                 rec.Status := rec.Status::"Non-operational";
                               END;


    }

}
    action("QB_PrintContract")
    {
        
                      Ellipsis=true;
                      CaptionML=ENU='&Print Contract',ESP='Imprimir Contrato';
                      ToolTipML=ENU='Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.',ESP='Preparar el documento para imprimirlo. Se abre una ventana de solicitud de informe para el documento, donde puede especificar qu� incluir en la impresi�n.';
                      ApplicationArea=Suite;
                      Image=Print;
                      
                                trigger OnAction()    BEGIN
                                 //JAV 14/03/19: - Imprimir en el formato adecuado para QuoBuilding
                                 /////QBPagePublisher.PurchaseContractPrint("No.");
                               END;


    }
    action("ShowCompanies")
    {
        
                      CaptionML=ENU='Companies',ESP='Empresas';
                      Image=Company;
                      
                                trigger OnAction()    BEGIN
                                 //Q12867 -
                                 rec.ShowCompanyList(Rec)
                                 //Q12867 +
                               END;


    }
    action("CloseBlanketPurchase")
    {
        
                      CaptionML=ENU='Close Blanket Purchase',ESP='Cerrar contrato marco';
                      Image=Close;
                      
                                
    trigger OnAction()    BEGIN
                                 //Q12867 -
                                 rec.CloseBlanketPurch(Rec);
                                 CurrPage.UPDATE;
                                 //Q12867 +
                               END;


    }

}
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Procesar';

                actionref(ShowCompanies_Promoted; ShowCompanies)
                {
                }
                actionref(CloseBlanketPurchase_Promoted; CloseBlanketPurchase)
                {
                }
                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
                actionref(DocAttach_Promoted; DocAttach)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Report', ESP = 'Informe';

                actionref(QB_PrintContract_Promoted; QB_PrintContract)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Approve', ESP = 'Aprobar';
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Request Approval', ESP = 'Solicitar aprobaci�n';
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 IF (rec.Status = rec.Status::Closed) THEN
                   CurrPage.EDITABLE(FALSE);
               END;

trigger OnAfterGetRecord()    BEGIN
                       IF (rec.Status = rec.Status::Closed) THEN
                         CurrPage.EDITABLE(FALSE);
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN

                  IF (rec."No." = '') THEN
                    rec.SetBuyFromVendorFromFilter;
                END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     CurrPage.SAVERECORD;
                   END;



    var
      QBPagePublisher : Codeunit 7207348;
      QB_verPaymentPhases : Boolean;
      FunctionQB : Codeunit 7207272;
      QB_verVtos : Boolean;
      QB_edVtos : Boolean;/*

    begin
    {
      Q12867 JDC 25/02/21 - Modified PageAction "ShowCompanies"
                            Added PageAction "CloseBlanketPurchase"
                            Modified property "SourceTableView"
      JAV 10/08/22: - QB 1.11.01 Se cambia el campo Aprobaci�n por el de estado y el propio estado
    }
    end.*/
  

}








