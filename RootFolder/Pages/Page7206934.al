page 7206934 "QB Liquidar Efectos"
{
  ApplicationArea=All;

CaptionML=ESP='Liquidar Efectos';
    SourceTable=7206924;
    SourceTableView=SORTING("Relacion No.")
                    WHERE("Registrado"=CONST(false));
    CardPageID="QB Liq. Efectos Cabecera";
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Relacion No.";rec."Relacion No.")
    {
        
    }
    field("Posting Date";rec."Posting Date")
    {
        
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.OpenPagePaymentRelations;
               END;



    var
      FunctionQB : Codeunit 7207272;

    /*begin
    end.
  
*/
}









