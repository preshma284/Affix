report 50069 "OLD_Confirming Caja Mar"
{
  
  
    Permissions=TableData 7000020=rimd;
    CaptionML=ENU='Payment order - Export N34',ESP='Confirming Caja Mar';
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
                                  GenerateElectronicsPayments.Generate("Payment Order"."No.", 50069, Text001, Opciones);
                                END;


}
}
  requestpage
  {
SaveValues=true;
    layout
{
area(content)
{
group("group183")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("DeliveryDate";"DeliveryDate")
    {
        
                  CaptionML=ENU='Delivery Date',ESP='Fecha de emisi¢n';
    }

}

}
}
  }
  labels
{
}
  
    var
//       GenerateElectronicsPayments@100000003 :
      GenerateElectronicsPayments: Codeunit 7206908;
//       Opciones@100000002 :
      Opciones: ARRAY [5] OF Text;
//       "----------------------------- Par metros"@100000000 :
      "----------------------------- Par metros": Integer;
//       DeliveryDate@100000001 :
      DeliveryDate: Date;
//       Text001@100000005 :
      Text001: TextConst ESP='ConfirmingCajaMar.txt';

    /*begin
    {
      QB2000 SE MODIFICA PARA QUE EL NéMERO DE DOCUMENTO SEA EL VENDOR INVOICE NO.
      QVE5203 PGM 21/11/2018 - Se a¤ade un control para que el proceso se pare en caso de que el campo 'C¢d. banco cliente/prov.' no est‚ informado.
    }
    end.
  */
  
}



