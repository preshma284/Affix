page 7207379 "Transfers Between Jobs List"
{
  ApplicationArea=All;

Editable=false;
    CaptionML=ENU='Transfers Documents List',ESP='Lista Traspaso entre Proyectos';
    SourceTable=7207286;
    PageType=List;
    CardPageID="Transfers Between Jobs Card";
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
    field("Balance";rec."Balance")
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
        CaptionML=ENU='C&omments',ESP='C&omentarios';
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








