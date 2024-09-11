page 7207041 "QB Approval Circuit Header"
{
CaptionML=ENU='Approval Circuit Header',ESP='Circuito de Aprobaci¢n';
    SourceTable=7206986;
    PageType=Card;
    
  layout
{
area(content)
{
group("General")
{
        
    field("Circuit Code";rec."Circuit Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Document Type";rec."Document Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;


    }
    field("Approval By";rec."Approval By")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetEditable;
                           END;


    }
group("group31")
{
        
                CaptionML=ESP='Condicionantes';
    field("Job No.";rec."Job No.")
    {
        
                Enabled=byJob ;
    }
    field("CA";rec."CA")
    {
        
                Enabled=byJob ;
    }
    field("Department";rec."Department")
    {
        
                Enabled=byDep ;
    }

}

}

}
area(FactBoxes)
{
    systempart(Links;Links)
    {
        
                Visible=TRUE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=TRUE;
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
      byJob : Boolean;
      byDep : Boolean;

    LOCAL procedure SetEditable();
    begin
      byJob := Rec."Approval By" = Rec."Approval By"::Job;
      byDep := Rec."Approval By" = Rec."Approval By"::Department;
    end;

    // begin
    /*{
      JAV 21/03/22: - QB 1.10.26 Se a¤ade el campo 12 rec."Approval By" para el tipo de condicionantes de la aprobaci¢n proyecto o departamento
    }*///end
}







