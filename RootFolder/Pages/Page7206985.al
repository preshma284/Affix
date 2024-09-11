page 7206985 "Post. Aux. Loc. Out. Ship. Hdr"
{
Editable=false;
    CaptionML=ENU='Posted Aux. Location Output Shipment Header',ESP='Hist. Cabecera albaran salida almac�n auxiliar';
    InsertAllowed=false;
    SourceTable=7206953;
    PageType=Document;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
group("General")
{
        
                CaptionML=ENU='Generla',ESP='General';
    field("No.";rec."No.")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Request Filter";rec."Request Filter")
    {
        
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Posting Description";rec."Posting Description")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Stock Regulation";rec."Stock Regulation")
    {
        
                Editable=False ;
    }

}
    part("LinDoc";7206986)
    {
        SubPageLink="Document No."=FIELD("No.");
    }
group("group18")
{
        
                CaptionML=ENU='Posting',ESP='Registro';
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
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
        ShortCutKey='F7';
                      CaptionML=ENU='Statistics',ESP='Estad�sticas';
                      RunObject=Page 7207320;
RunPageLink="No."=FIELD("No.");
                      Promoted=true;
                      Image=Statistics;
                      PromotedCategory=Process ;
    }
    action("action2")
    {
        CaptionML=ENU='Co&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="Document Type"=CONST("Receipt Hist."), "No."=FIELD("No.");
                      Image=ViewComments ;
    }
    action("action3")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      Image=Dimensions;
                      
                                trigger OnAction()    BEGIN
                                 rec.ShowDimensions;
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
                                 PostedOutputShipmentHeader.RESET;
                                 PostedOutputShipmentHeader.SETRANGE("No.",rec."No.");
                                //  REPORT.RUNMODAL(REPORT::"Posted Output Shipment Header",TRUE,FALSE,PostedOutputShipmentHeader);
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
                 rec.FilterResponsability(Rec);
               END;



    var
      PostedOutputShipmentHeader : Record 7207310;
      FunctionQB : Codeunit 7207272;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
    end;

    // begin//end
}








