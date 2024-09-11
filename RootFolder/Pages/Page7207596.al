page 7207596 "QB Objectives Text Card"
{
SourceTable=7207404;
    
  layout
{
area(content)
{
group("group21")
{
        
                CaptionML=ESP='Comentario';
    field("CText";"CText")
    {
        
                ToolTipML=ESP='Si deja en blanco el texto para venta, se usar� el de coste para la misma';
                MultiLine=true;
                
                            ;trigger OnValidate()    BEGIN
                             rec.SetComment(CText);
                             CurrPage.UPDATE;
                           END;


    }
    field("Comments Size";rec."Comments Size")
    {
        
                Editable=false 

  ;
    }

}

}
}
  trigger OnAfterGetCurrRecord()    BEGIN
                           CText := rec.GetComment;
                         END;



    var
      CText : Text;
      QBObjectivesLine : Record 7207404;

    /*begin
    end.
  
*/
}







