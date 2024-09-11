page 7207575 "Codes Evaluation List"
{
  ApplicationArea=All;

CaptionML=ENU='Codes Evaluation List',ESP='C¢digos de evaluaci¢n de proveedores';
    SourceTable=7207422;
    PageType=List;
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Evaluation Type";rec."Evaluation Type")
    {
        
    }
    field("Code";rec."Code")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Max Value";rec."Max Value")
    {
        
    }
    field("Weighing";rec."Weighing")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             //JAV 21/09/19: - Se a¤aden los campos Uso y acumulado, actualizando la p gina cuando se cambia el peso
                             CurrPage.UPDATE;
                           END;


    }
    field("Acumulate";rec."Acumulate")
    {
        
    }

}

}
}
  /*

    begin
    {
      JAV 15/08/19: - Se a¤ade el campo 3 rec."Weighing" que indica el peso en la evaluaci¢n final del proveedor
      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c lculo de las puntuaciones de las mismas
      JAV 21/09/19: - Se a¤aden los campos Uso y acumulado, actualizando la p gina cuando se cambia el peso
    }
    end.*/
  

}








