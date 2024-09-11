page 7206987 "Post. Aux. Loc.Out. Ship. List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Posted Aux. Location Output Shipment List',ESP='Hist. Lista albaran salida almac�n auxiliar';
    SourceTable=7206953;
    PageType=List;
    CardPageID="Post. Aux. Loc. Out. Ship. Hdr";
  layout
{
area(content)
{
repeater("table")
{
        
                Editable=False;
    field("No.";rec."No.")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Posting Description";rec."Posting Description")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }

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
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Document',ESP='&Documento';
    action("action1")
    {
        ShortCutKey='Shift+F7';
                      CaptionML=ENU='Card',ESP='Ficha';
                      Image=EditLines;
                      
                                trigger OnAction()    BEGIN
                                 PAGE.RUNMODAL(PAGE::"Posted Output Shipment Header",Rec);
                               END;


    }
    action("action2")
    {
        ShortCutKey='F7';
                      CaptionML=ENU='Statistics',ESP='Estad�sticas';
                      RunObject=Page 7207320;
RunPageLink="No."=FIELD("No.");
                      Image=Statistics;
    }
    action("action3")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="Document Type"=CONST("Receipt Hist."), "No."=FIELD("No.");
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
                                 PostedOutputShipmentHeader.RESET;
                                 PostedOutputShipmentHeader.SETRANGE("No.",rec."No.");
                                //  REPORT.RUNMODAL(REPORT::"Posted Output Shipment Header",TRUE,FALSE,PostedOutputShipmentHeader);
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
  
    var
      PostedOutputShipmentHeader : Record 7207310;/*

    begin
    {
      JAV 30/05/19: - Se a�ade el campo rec."Posting Description"
    }
    end.*/
  

}









