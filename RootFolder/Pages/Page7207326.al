page 7207326 "QB Detailed Job Entry"
{
CaptionML=ENU='Detailed Job Entry',ESP='Movimientos detallados de proyecto';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7207328;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Job Ledger Entry No.";rec."Job Ledger Entry No.")
    {
        
    }
    field("Applied Job Ledger Entry No.";rec."Applied Job Ledger Entry No.")
    {
        
    }
    field("Entry Type";rec."Entry Type")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Document No.";rec."Document No.")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Amount (LCY)";rec."Amount (LCY)")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Currency Code";rec."Currency Code")
    {
        
    }
    field("User ID";rec."User ID")
    {
        
    }
    field("Source Code";rec."Source Code")
    {
        
    }
    field("Reason Code";rec."Reason Code")
    {
        
    }

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        ShortCutKey='Return';
                      CaptionML=ENU='Edit Daily',ESP='Editar diario';
                      Image=OpenJournal;
                      
                                
    trigger OnAction()    BEGIN
                                 //ProductionDayManage.TemplateSelectionFromBatch(Rec);
                               END;


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
  

    /*begin
    end.
  
*/
}







