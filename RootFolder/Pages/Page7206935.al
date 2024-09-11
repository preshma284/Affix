page 7206935 "QB Efectos Liquidados"
{
  ApplicationArea=All;

CaptionML=ESP='Efectos Liquidados';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206924;
    SourceTableView=SORTING("Relacion No.")
                    WHERE("Registrado"=CONST(true));
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









