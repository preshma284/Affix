page 7207380 "Tran. Between Jobs Post List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Posted Doc. Transfers List',ESP='Lista hist. doc. traspasos';
    SourceTable=7207288;
    SourceTableView=SORTING("No.");
    PageType=List;
    CardPageID="Tran. Between Jobs Post Card";
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Posting Date";rec."Posting Date")
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
        CaptionML=ENU='&Document',ESP='&L¡nea';
    action("action1")
    {
        CaptionML=ENU='CO&mments',ESP='C&omentarios';
                      RunObject=Page 7207273;
RunPageLink="Document Type"=CONST("Sheet"), "No."=FIELD("No.");
                      Image=ViewComments ;
    }

}

}
area(Processing)
{


}
}
  /*

    begin
    {
      JAV 28/10/19: - Se cambia el name y caption para que sea mas significativo del contenido
    }
    end.*/
  

}








