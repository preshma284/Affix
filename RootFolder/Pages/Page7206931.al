page 7206931 "QB Efectos Creados"
{
  ApplicationArea=All;

CaptionML=ESP='Relaciones de Efectos Registradas';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206922;
    SourceTableView=SORTING("Relacion No.")
                    WHERE("Registrada"=CONST(true));
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
    field("OrdenPago";rec."OrdenPago")
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









