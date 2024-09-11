page 7206952 "QB External Worksheet List Pos"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Posted Worksheet List',ESP='Lista partes de trabajo Registrados';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206935;
    SourceTableView=SORTING("Vendor No.");
    PageType=List;
    CardPageID="QB External Worksheet Card Pos";
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Vendor No.";rec."Vendor No.")
    {
        
    }
    field("Vendor Name";rec."Vendor Name")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Posting Description";rec."Posting Description")
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
        SubPageLink="No."=FIELD("Vendor No.");
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
                      CaptionML=ENU='Card',ESP='Ficha';
                      Image=EditLines;
                      
                                trigger OnAction()    BEGIN
                                 PAGE.RUNMODAL(PAGE::"QB Worksheet Header Posted",Rec,rec."No.")
                               END;


    }
    action("action2")
    {
        ShortCutKey='F7';
                      CaptionML=ENU='Statistics',ESP='Estad�sticas';
                      //Page removed in new version - ELIMINAR
//                       RunObject=Page 7207278;
// RunPageLink="Period"=FIELD("Vendor No.");
                      Image=Statistics;
    }
    action("action3")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="No."=FIELD("Vendor No.");
                      Image=ViewComments ;
    }

}

}
area(Processing)
{

    action("action4")
    {
        Ellipsis=true;
                      CaptionML=ENU='&Print',ESP='&Imprimir';
                      Image=Print;
                      
                                trigger OnAction()    BEGIN
                                //  REPORT.RUNMODAL(REPORT::"Resource Worksheet Hist.",TRUE,FALSE,Rec);
                               END;


    }
    action("action5")
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
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.AccessToWSReports;
                 ////FunFilterResponsibility(Rec);
               END;



    var
      FunctionQB : Codeunit 7207272;

    /*begin
    end.
  
*/
}









