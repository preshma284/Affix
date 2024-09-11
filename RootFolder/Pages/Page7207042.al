page 7207042 "QB Approval Circuit Lines"
{
CaptionML=ENU='Approval Circuit Lines',ESP='L¡neas del Circuito de Aprobaci¢n';
    SourceTable=7206987;
    SourceTableView=SORTING("Circuit Code","Approval Level");
    PageType=ListPart;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Circuit Code";rec."Circuit Code")
    {
        
                Visible=false ;
    }
    field("Line Code";rec."Line Code")
    {
        
    }
    field("Position";rec."Position")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("User";rec."User")
    {
        
                Enabled=edUser ;
    }
    field("Optional";rec."Optional")
    {
        
    }
    field("Approval Level";rec."Approval Level")
    {
        
    }
    field("Approval Limit";rec."Approval Limit")
    {
        
    }
    field("Approval Unlim.";rec."Approval Unlim.")
    {
        
    }

}

}
}
  trigger OnAfterGetCurrRecord()    BEGIN
                           QBApprovalCircuitHeader.GET(Rec."Circuit Code");
                           edUser := (QBApprovalCircuitHeader."Approval By" = QBApprovalCircuitHeader."Approval By"::User);
                         END;



    var
      QBApprovalCircuitHeader : Record 7206986;
      edUser : Boolean;/*

    begin
    {
      JAV 04/04/22: - QB 1.10.31 Nueva columna de usuario que aprueba
    }
    end.*/
  

}







