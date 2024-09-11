page 7207274 "QB Worksheet Header Posted"
{
CaptionML=ENU='Posted  Worksheet Header',ESP='Cab. parte de trabajo Registrado';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7207292;
    SourceTableView=SORTING("No.");
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
    field("Sheet Type";rec."Sheet Type")
    {
        
    }
    field("No. Resource /Job";rec."No. Resource /Job")
    {
        
    }
    field("Sheet Date";rec."Sheet Date")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Posting Description";rec."Posting Description")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Rental Machinery";rec."Rental Machinery")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part2";7207504)
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
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="Document Type"=CONST("Sheet Hist."), "No."=FIELD("No.");
                      Image=ViewComments ;
    }
    action("action2")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      Image=Dimensions;
                      
                                trigger OnAction()    BEGIN
                                 rec.ShowDimensions;
                               END;


    }
    action("action3")
    {
        CaptionML=ENU='Approvals',ESP='Aprobaciones';
                      Image=Approvals;
                      
                                trigger OnAction()    VAR
                                 PostedApprovalEntries : Page 659;
                               BEGIN
                                 PostedApprovalEntries.Setfilters(DATABASE::"Worksheet Header Hist.",rec."No.");
                                 PostedApprovalEntries.RUN;
                               END;


    }

}

}
area(Processing)
{

    action("action4")
    {
        Ellipsis=true;
                      CaptionML=ENU='&Print',ESP='&Imprimir';
                      Promoted=true;
                      Image=Print;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 recWorksheetHeaderHist.RESET;
                                 recWorksheetHeaderHist.SETRANGE("No.",rec."No.");
                                //  REPORT.RUNMODAL(REPORT::"Resource Worksheet Hist.",TRUE,FALSE,recWorksheetHeaderHist);
                               END;


    }
    action("action5")
    {
        CaptionML=ENU='&Navigate',ESP='&Navegar';
                      Promoted=true;
                      Image=Navigate;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    BEGIN
                                 rec.Navigate;
                               END;


    }

}
}
  trigger OnOpenPage()    BEGIN
                 rec.FunFilterResponsibility(Rec);
               END;



    var
      recWorksheetHeaderHist : Record 7207292;

    /*begin
    end.
  
*/
}







