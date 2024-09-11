page 7207511 "Piecework Amount Planning"
{
CaptionML=ENU='Piecework Amount Planning',ESP='Planificaci¢n importes unidad de obra';
    SourceTable=7207392;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Entry Type";rec."Entry Type")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Entry No.";rec."Entry No.")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Unit Type";rec."Unit Type")
    {
        
    }
    field("Piecework Code";rec."Piecework Code")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Analytical Concept";rec."Analytical Concept")
    {
        
    }
    field("Cod. Budget";rec."Cod. Budget")
    {
        
    }
    field("Expected Date";rec."Expected Date")
    {
        
    }
    field("Amount";rec."Amount")
    {
        
    }
    field("Code Cost Database";rec."Code Cost Database")
    {
        
    }
    field("Unique Code";rec."Unique Code")
    {
        
    }
    field("Performed";rec."Performed")
    {
        
    }
    field("Job Currency Amount";rec."Job Currency Amount")
    {
        
                Visible=useCurrencies ;
    }
    field("Amount (LCY)";rec."Amount (LCY)")
    {
        
                Visible=useCurrencies;
                Editable=FALSE ;
    }
    field("Amount (ACY)";rec."Amount (ACY)")
    {
        
                Visible=useCurrencies 

  ;
    }

}

}
}
  trigger OnInit()    BEGIN
             //JAV 08/04/20: - Si se usan las divisas en los proyectos
             JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
           END;



    var
      FunctionQB : Codeunit 7207272;
      useCurrencies : Boolean;
      JobCurrencyExchangeFunction : Codeunit 7207332;

    /*begin
    end.
  
*/
}







