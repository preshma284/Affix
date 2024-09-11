page 7206947 "QB External Worksheet Card"
{
CaptionML=ENU='Work Sheet Header',ESP='Cab. partes de trabajo';
    SourceTable=7206933;
    PopulateAllFields=true;
    PageType=Document;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
group("General")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
                CaptionML=ENU='No. Resource';
                CaptionClass=TipoOrigen;
                Enabled=verCodigo ;
    }
    field("Sheet Date";rec."Sheet Date")
    {
        
    }
    field("Allocation Term";rec."Allocation Term")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Posting Description";rec."Posting Description")
    {
        
    }
    field("Approval Status";rec."Approval Status")
    {
        
    }
    field("Approval Situation";rec."Approval Situation")
    {
        
    }
    field("Approval Coment";rec."Approval Coment")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part2";7207505)
    {
        SubPageLink="No."=FIELD("Vendor No.");
                Visible=TRUE;
    }
    systempart(Links;Links)
    {
        
                Visible=TRUE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=TRUE;
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Sheet',ESP='&Parte';
    action("action1")
    {
        ShortCutKey='Shift+F5';
                      CaptionML=ENU='Vendor Card List',ESP='Ficha Proveedor';
                      RunObject=Page 26;
// RunPageLink="No."=FIELD("Field31");
                      Image=EditLines ;
    }
    action("action2")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="Document Type"=CONST("Sheet"), "No."=FIELD("Vendor No.");
                      Image=ViewComments ;
    }
    action("action3")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensions';
                      Image=Dimensions;
                      
                                trigger OnAction()    BEGIN
                                 rec.ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;


    }

}
group("group6")
{
        CaptionML=ENU='&Actions',ESP='&Aprobaciones';
    action("action4")
    {
        CaptionML=ESP='Aprobaciones';
                      Image=Approvals;
                      
                                trigger OnAction()    VAR
                                 recApprovalEntry : Record 454;
                                 ApprovalEntries : Page 658;
                               BEGIN
                                 ApprovalEntries.Setfilters(DATABASE::"Worksheet Header qb",recApprovalEntry."QB Document Type"::PaymentDueCert,rec."No.");
                                 ApprovalEntries.RUN;
                               END;


    }
    action("action5")
    {
        CaptionML=ENU='Send Approval Request',ESP='Enviar solicitud a&probaci�n';
                      Image=SendApprovalRequest;
                      
                                trigger OnAction()    BEGIN
                                 //IF WorkflowEventsQB.CheckWorksheetApprovalPossible(Rec) THEN
                                 //  QBApprovalPublisher.OnSendWorksheetDocForApproval(Rec);
                               END;


    }
    action("action6")
    {
        CaptionML=ENU='Cancel Approval Request',ESP='&Cancelar solicitud aprobaci�n';
                      Image=Reject;
                      
                                trigger OnAction()    BEGIN
                                 //QBApprovalPublisher.OnCancelWorksheetApprovalRequest(Rec);
                               END;


    }
    action("action7")
    {
        CaptionML=ENU='Release',ESP='Lanzar';
                      Image=ReleaseDoc;
                      
                                trigger OnAction()    VAR
                                 ReleaseWorksheet : Codeunit 7207301;
                               BEGIN
                                 //ReleaseWorksheet.PerformManualRelease(Rec);
                               END;


    }
    action("action8")
    {
        CaptionML=ENU='Open',ESP='Volver a abrir';
                      Image=ReOpen;
                      
                                trigger OnAction()    VAR
                                 ReleaseWorksheet : Codeunit 7207301;
                               BEGIN
                                 //ReleaseWorksheet.PerformManualReopen(Rec);
                               END;


    }

}

}
area(Processing)
{

group("group13")
{
        CaptionML=ENU='P&osting',ESP='&Registro';
    action("Register")
    {
        
                      ShortCutKey='F9';
                      CaptionML=ENU='P&ost',ESP='Registrar';
                      Image=Post;
                      
                                trigger OnAction()    VAR
                                 PostWorksheet : Codeunit 7207270;
                               BEGIN
                                 IF CONFIRM(Text001,FALSE, rec."No.") THEN BEGIN
                                   CLEAR(PostWorksheet);
                                   PostWorksheet.ExternalWorksheet_Post(Rec);
                                 END;
                               END;


    }

}
group("group15")
{
        CaptionML=ENU='P&osting',ESP='Importar';
    action("action10")
    {
        CaptionML=ESP='Importar Excel';
                      Image=ImportExcel;
                      
                                
    trigger OnAction()    VAR
                                //  ImportExcel : Report 7207441;
                               BEGIN
                                 //JAV 18/10/19: - Nueva acci�n para importar desde Excel los datos
                                 //CLEAR(ImportExcel);
                                 //ImportExcel.SetFilters(Rec);
                                 //ImportExcel.RUN;
                               END;


    }

}

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Register_Promoted; Register)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
            }
            group(Category_Category4)
            {
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 //FunFilterResponsibility(Rec);
               END;

trigger OnFindRecord(Which: Text): Boolean    BEGIN
                   IF Rec.FIND(Which) THEN
                     EXIT(TRUE)
                   ELSE BEGIN
                     Rec.SETRANGE("No.");
                     EXIT(Rec.FIND(Which));
                   END;
                 END;

trigger OnNewRecord(BelowxRec: Boolean)    VAR
                  HasGotSalesUserSetup : Boolean;
                  UserRespCent : Code[20];
                BEGIN
                  FunctionQB.GetJobFilter(HasGotSalesUserSetup,rec."Responsibility Center");
                END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(rec.ConfirmDeletion);
                   END;



    var
      FunctionQB : Codeunit 7207272;
      TipoOrigen : Text;
      verCodigo : Boolean;
      Text001 : TextConst ESP='Confirme que desea registrar el documento %1';
      Text002 : TextConst ESP='Confirme que desea registrar todos los documentos pendientes';

    /*begin
    end.
  
*/
}








