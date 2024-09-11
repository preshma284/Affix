page 7206984 "QB Aux. Loc.Out. Shipment List"
{
  ApplicationArea=All;

CaptionML=ENU='Aux. Location Output Shipment List',ESP='Lista albaran salida almac�n auxiliar';
    InsertAllowed=false;
    SourceTable=7206951;
    PageType=List;
    CardPageID="QB Aux.Loc. Out. Shipm. Head";
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("table")
{
        
                Editable=False;
    field("No.";rec."No.")
    {
        
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Description";rec."Description")
    {
        
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Amount";rec."Amount")
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
}
  trigger OnOpenPage()    BEGIN
                 rec.FilterResponsability(Rec);
               END;



    var
      FunctionQB : Codeunit 7207272;

    /*begin
    end.
  
*/
}









