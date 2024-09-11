page 7207006 "QB Receipt/Transfer Card"
{
CaptionML=ENU='Receipt/Transfer Card',ESP='Ficha Recepci�n/Traspaso';
    SourceTable=7206970;
    PageType=Card;
    
  layout
{
area(content)
{
group("General")
{
        
    field("No.";rec."No.")
    {
        
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF rec.AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;


    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Type";rec."Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             IF (rec.Type <> rec.Type::Transfer) THEN
                               rec."Destination Location" := '';

                             SetEditable;
                           END;


    }
    field("Location";rec."Location")
    {
        
    }
    field("Destination Location";rec."Destination Location")
    {
        
                Enabled=edDestination ;
    }
    field("Allow Ceded";rec."Allow Ceded")
    {
        
    }
    field("Allow Deposit";rec."Allow Deposit")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Service Order No.";rec."Service Order No.")
    {
        
    }
    field("Diverse Entrance";rec."Diverse Entrance")
    {
        
    }
group("group17")
{
        
                CaptionML=ENU='Comments',ESP='Comentarios';
    field("Comments";rec."Comments")
    {
        
                Importance=Additional;
                MultiLine=true;
                ShowCaption=false ;
    }

}

}
    part("part1";7207007)
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
area(Creation)
{
//CaptionML=ENU='General';
    action("Post")
    {
        
                      CaptionML=ENU='Post',ESP='Registrar';
                      Image=Post;
                      trigger OnAction() VAR
                                 PostReceiptTransfer : Codeunit 7206909;
                                 ConfirmLbl : TextConst ENU='Is going to proceed to register the document Do you want to continue?',ESP='Se va a proceder a registrar el documento �Desea continuar?';
                               BEGIN
                                 IF CONFIRM(ConfirmLbl) THEN
                                   PostReceiptTransfer.Post(Rec,FALSE);
                               END;
    }
    action("Post&Print")
    {
        
                      CaptionML=ENU='Post & Print',ESP='Registar e imprimir';
                      Image=PostPrint;
                      
                                trigger OnAction()    VAR
                                 PostReceiptTransfer : Codeunit 7206909;
                               BEGIN
                                 IF CONFIRM(ConfirmLbl) THEN
                                   PostReceiptTransfer.Post(Rec,TRUE);
                               END;


    }
    action("ItemsByLocation")
    {
        
                      AccessByPermission=TableData 14=R;
                      CaptionML=ENU='Items b&y Location',ESP='Disponibilidad prestados';
                      ToolTipML=ENU='Show a list of items grouped by location.',ESP='Muestra una lista de productos agrupados por ubicaci�n.';
                      ApplicationArea=Advanced;
                      Image=ItemAvailbyLoc;
                      
                                
    trigger OnAction()    VAR
                                 rItem : Record 27;
                               BEGIN
                                 PAGE.RUN(PAGE::"QB Items by Location",rItem);
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ItemsByLocation_Promoted; ItemsByLocation)
                {
                }
                actionref(Post_Promoted; Post)
                {
                }
                actionref("Post&Print_Promoted"; "Post&Print")
                {
                }
            }
        }
}
  
trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           SetEditable;
                         END;



    var
      ConfirmLbl : TextConst ESP='�Confirma que desea registrar el documento?';
      edDestination : Boolean;

    LOCAL procedure SetEditable();
    begin
      edDestination := (rec.Type = rec.Type::Transfer);
    end;

    // begin//end
}







