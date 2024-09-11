report 50061 "OLD_Confirming Santander 2"
{
  
  
    ProcessingOnly=true;
  
  dataset
{

DataItem("Payment Order";"Payment Order")
{

               

               RequestFilterFields="No.";
trigger OnAfterGetRecord();
    BEGIN 
                                  Opciones[1] := '';
                                  Opciones[2] := '';
                                  Opciones[3] := '';
                                  Opciones[4] := '';
                                  Opciones[5] := '';
                                  GenerateElectronicsPayments.Generate("Payment Order"."No.", 50061, Text001, Opciones);
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       GenerateElectronicsPayments@1100286018 :
      GenerateElectronicsPayments: Codeunit 7206908;
//       Opciones@1100286017 :
      Opciones: ARRAY [5] OF Text;
//       Text001@1100286000 :
      Text001: TextConst ESP='ConfirmingSantander.txt';

    /*begin
    {
      PGM 14/03/19: Genera un archivo de texto plano para Confirming de Santander
    }
    end.
  */
  
}



