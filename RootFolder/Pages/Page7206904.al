page 7206904 "Tran. Between Jobs Post Card"
{
CaptionML=ENU='Post. Proyects Transfers',ESP='Traspaso entre proyectos Registrados';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7207288;
    PopulateAllFields=true;
    SourceTableView=SORTING("No.");
    PageType=Document;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
group("General")
{
        
                CaptionML=ENU='General',ESP='General';
    field("No.";rec."No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Posting Date";rec."Posting Date")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Approval Status";rec."Approval Status")
    {
        
    }

}
    part("LinDoc";7206905)
    {
        SubPageLink="Document No."=FIELD("No.");
    }

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        ;
    }
    systempart(Notes;Notes)
    {
        ;
    }

}
}actions
{
area(Processing)
{

group("group2")
{
        CaptionML=ENU='P&osting',ESP='&Registro';
    action("action1")
    {
        CaptionML=ENU='P&ost',ESP='Navegar';
                      Image=Navigate;
                      
                                trigger OnAction()    VAR
                                 Navigate : Page 344;
                               BEGIN
                                 Navigate.SetDoc(rec."Posting Date", rec."No.");
                                 Navigate.RUNMODAL;
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="Document Type"=CONST("Sheet"), "No."=FIELD("No.");
                      Image=ViewComments 
    ;
    }

}

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  trigger OnFindRecord(Which: Text): Boolean    BEGIN
                   IF Rec.FIND(Which) THEN
                     EXIT(TRUE)
                   ELSE BEGIN
                     Rec.SETRANGE("No.");
                     EXIT(Rec.FIND(Which));
                   END;
                 END;



    var
      UserSetupManagement : Codeunit 5700;
      HasGotSalesUserSetup : Boolean;
      UserRespCenter : Code[20];/*

    begin
    {
      JAV 28/10/19: - Se cambia el name y caption para que sea mas significativo del contenido
    }
    end.*/
  

}








