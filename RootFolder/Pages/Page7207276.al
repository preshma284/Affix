page 7207276 "QB Worksheet List Hist."
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Posted Worksheet List',ESP='Lista partes de trabajo Registrados';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7207292;
    SourceTableView=SORTING("No.");
    PageType=List;
    CardPageID="QB Worksheet Header Posted";
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Sheet Type";rec."Sheet Type")
    {
        
    }
    field("No. Resource /Job";rec."No. Resource /Job")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Description 2";rec."Description 2")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Posting Description";rec."Posting Description")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Comment";rec."Comment")
    {
        
    }
    field("Reason Code";rec."Reason Code")
    {
        
    }
    field("Pre-Assigned No. Series";rec."Pre-Assigned No. Series")
    {
        
    }
    field("No. Series";rec."No. Series")
    {
        
    }
    field("Sheet Date";rec."Sheet Date")
    {
        
    }
    field("Responsibility Center";rec."Responsibility Center")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part1";7207504)
    {
        SubPageLink="No."=FIELD("No.");
                Visible=TRUE;
    }
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
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Document',ESP='&Documento';
    action("action1")
    {
        ShortCutKey='Shift+F5';
                      CaptionML=ENU='Resource Card',ESP='Ficha Recurso';
                      Enabled=enResource;
                      Image=Resource;
                      
                                trigger OnAction()    VAR
                                 Resource : Record 156;
                                 ResourceCard : Page 76;
                               BEGIN
                                 IF rec."Sheet Type" = rec."Sheet Type"::"By Resource" THEN BEGIN
                                   Resource.GET(rec."No. Resource /Job");

                                   CLEAR(ResourceCard);
                                   ResourceCard.SETRECORD(Resource);
                                   ResourceCard.RUN;
                                 END;
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Job Card',ESP='Ficha Proyecto';
                      Enabled=enJob;
                      Image=Job;
                      
                                trigger OnAction()    VAR
                                 Job : Record 167;
                                 OperativeJobsCard : Page 7207478;
                               BEGIN
                                 IF rec."Sheet Type" = rec."Sheet Type"::"By Job" THEN BEGIN
                                   Job.GET(rec."No. Resource /Job");

                                   CLEAR(OperativeJobsCard);
                                   OperativeJobsCard.SETRECORD(Job);
                                   OperativeJobsCard.RUN;
                                 END;
                               END;


    }
    action("action3")
    {
        ShortCutKey='F7';
                      CaptionML=ENU='Statistics',ESP='Estad�sticas';
            //page removed in newer version - ELIMINAR
//                       RunObject=Page 7207278;
// RunPageLink="Period"=FIELD("No.");
                      Image=Statistics;
    }
    action("action4")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="No."=FIELD("No.");
                      Image=ViewComments ;
    }

}

}
area(Processing)
{

    action("action5")
    {
        Ellipsis=true;
                      CaptionML=ENU='&Print',ESP='&Imprimir';
                      Image=Print;
                      
                                trigger OnAction()    BEGIN
                                 WorksheetHeaderHist.RESET;
                                 WorksheetHeaderHist.SETRANGE("No.",rec."No.");
                                //  IF rec."Sheet Type" = rec."Sheet Type"::"By Resource" THEN
                                  //  REPORT.RUNMODAL(REPORT::"Resource Worksheet Hist.",TRUE,FALSE,WorksheetHeaderHist);
                                //  IF rec."Sheet Type" = rec."Sheet Type"::"By Job" THEN
                                  //  REPORT.RUNMODAL(REPORT::"Job Worksheet Hist.",TRUE,FALSE,WorksheetHeaderHist);
                               END;


    }
    action("action6")
    {
        CaptionML=ENU='&Navigate',ESP='&Navegar';
                      Image=Navigate;
                      
                                
    trigger OnAction()    BEGIN
                                 rec.Navigate;
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
}
  
trigger OnOpenPage()    BEGIN
                 rec.FunFilterResponsibility(Rec);
               END;

trigger OnAfterGetRecord()    BEGIN
                       enResource := (rec."Sheet Type" = rec."Sheet Type"::"By Resource");
                       enJob := (rec."Sheet Type" = rec."Sheet Type"::"By Job");
                     END;



    var
      WorksheetHeaderHist : Record 7207292;
      enResource : Boolean;
      enJob : Boolean;/*

    begin
    {
      CPA 28/03/22 Q16718 - Sacar el campo Importe en la Lista de Partes de Trabajo Registrados
    }
    end.*/
  

}








