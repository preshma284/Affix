page 7206930 "QB Crear Efectos"
{
  ApplicationArea=All;

CaptionML=ESP='Relaci¢n de Efectos';
    SourceTable=7206922;
    SourceTableView=SORTING("Relacion No.")
                    WHERE("Registrada"=CONST(false));
    CardPageID="QB Crear Efectos Cabecera";
    
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
    field("Bank Account No.";rec."Bank Account No.")
    {
        
    }
    field("Bank Account Name";rec."Bank Account Name")
    {
        
    }
    field("Bank Payment Type";rec."Bank Payment Type")
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









