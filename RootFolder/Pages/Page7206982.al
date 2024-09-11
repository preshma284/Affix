page 7206982 "QB Aux.Loc. Out. Shipm. Head"
{
CaptionML=ENU='Aux. Location Output Shipment Heading',ESP='Cabecera albaran salida almac�n auxiliar';
    SourceTable=7206951;
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
                StyleExpr=TRUE;
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF rec.AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;


    }
    field("Request Date";rec."Request Date")
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
    part("LinDoc";7206983)
    {
        SubPageLink="Document No."=FIELD("No.");
                UpdatePropagation=Both ;
    }
group("group18")
{
        
                CaptionML=ENU='Posting',ESP='Registro';
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;


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
        CaptionML=ENU='Shipment',ESP='Albar�n';
    action("action1")
    {
        ShortCutKey='F7';
                      CaptionML=ENU='Statistics',ESP='Estad�sticas';
                      Visible=false;
                      Image=Statistics;
                      
                                trigger OnAction()    BEGIN
                                 // Tomamos la configuraci�n del area funcional del documento.
                                 PAGE.RUNMODAL(PAGE::"Posted Output Shipment List",Rec);
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Comments',ESP='Comentarios';
                      RunObject=Page 7207273;
RunPageLink="No."=FIELD("No."), "Document Type"=CONST("Receipt");
                      Image=ViewComments ;
    }
    action("action3")
    {
        ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      Image=Dimensions;
                      
                                trigger OnAction()    BEGIN
                                 rec.ShowDocDim;
                               END;


    }

}

}
area(Processing)
{

group("group7")
{
        CaptionML=ENU='Posting',ESP='Registro';
    action("action4")
    {
        ShortCutKey='F9';
                      CaptionML=ENU='Post',ESP='Registrar';
                      RunObject=Codeunit 7206926;
                      Image=Post;
                      
                                
    trigger OnAction()    VAR
                                 RecAuxOutShipLine : Record 7206952;
                               BEGIN
                               END;


    }

}

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 rec.FilterResponsability(Rec);
               END;

trigger OnFindRecord(Which: Text): Boolean    BEGIN
                   IF Rec.FIND(Which) THEN
                     EXIT(TRUE)
                   ELSE BEGIN
                     Rec.SETRANGE("No.");
                     EXIT(Rec.FIND(Which));
                   END;
                 END;

trigger OnNewRecord(BelowxRec: Boolean)    begin
                  /*{
                  FunctionQB.GetJobFilter(HasGotSalesUserSetup,UserRespCenter);
                  "Responsability Center" := UserRespCenter ;
                  }*/
                END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(rec.ConfirmDeletion);
                   END;



    var
      FunctionQB : Codeunit 7207272;

    

LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
    end;

    // begin
    /*{
      JAV 09/07/19: - Se cambia la propiedad de propagaci�n de las l�neas para que sea en ambos sentidos
    }*///end
}








