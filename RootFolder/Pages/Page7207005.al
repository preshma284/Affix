page 7207005 "QB Receipt/Transfer List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Receipt/Transfer Inesco List',ESP='Lista Recepci�n/Traspaso';
    SourceTable=7206970;
    SourceTableView=WHERE("Posted"=CONST(false));
    PageType=List;
    CardPageID="QB Receipt/Transfer Card";
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Type";rec."Type")
    {
        
    }
    field("Location";rec."Location")
    {
        
    }
    field("Destination Location";rec."Destination Location")
    {
        
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
//Name=General;
    action("Post")
    {
        
                      CaptionML=ENU='Post',ESP='Registrar';
                      Image=Post;
                      
                                trigger OnAction()    VAR
                                 PostReceiptTransfer : Codeunit 7206909;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Rec);
                                 IF CONFIRM(ConfirmLbl) THEN
                                   PostReceiptTransfer.Post(Rec,FALSE);

                                 Rec.RESET;
                                 Rec.SETRANGE(Posted,FALSE);
                                 CurrPage.UPDATE;
                               END;


    }
    action("Post&Print")
    {
        
                      CaptionML=ENU='Post & Print',ESP='Registar e imprimir';
                      Image=PostPrint;
                      
                                
    trigger OnAction()    VAR
                                 ReceiptTransferHdr : Record 7206970;
                                 PostReceiptTransfer : Codeunit 7206909;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Rec);
                                 IF CONFIRM(ConfirmLbl) THEN
                                   PostReceiptTransfer.Post(Rec,TRUE);

                                 Rec.RESET;
                                 Rec.SETRANGE(Posted,FALSE);
                                 CurrPage.UPDATE;
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Post_Promoted; Post)
                {
                }
                actionref("Post&Print_Promoted"; "Post&Print")
                {
                }
            }
        }
}
  
    var
      ConfirmLbl : TextConst ENU='Is going to proceed to register the document Do you want to continue?',ESP='Se va a proceder a un registrar el documento �Desea continuar?';

    /*begin
    end.
  
*/
}








