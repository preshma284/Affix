table 7207444 "Referent Types"
{
  
  
    CaptionML=ENU='Referent Types',ESP='Tipos de Referentes';
    LookupPageID="Referent Type List";
    DrillDownPageID="Referent Type List";
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n'; ;


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       txtQB000@1100286001 :
      txtQB000: TextConst ESP='No evaluado';

//     procedure GetClasification (Value@1100286000 :
    procedure GetClasification (Value: Decimal) : Text;
    var
//       QuoBuildingSetup@1100286001 :
      QuoBuildingSetup: Record 7207278;
    begin
      if (Value = 0) then exit(txtQB000);
      QuoBuildingSetup.GET;
      if (Value >= QuoBuildingSetup."Evaluation score 1") then exit(QuoBuildingSetup."Evaluation rating 1");
      if (Value >= QuoBuildingSetup."Evaluation score 2") then exit(QuoBuildingSetup."Evaluation rating 2");
      if (Value >= QuoBuildingSetup."Evaluation score 3") then exit(QuoBuildingSetup."Evaluation rating 3");
      if (Value >= QuoBuildingSetup."Evaluation score 4") then exit(QuoBuildingSetup."Evaluation rating 4");
      exit(QuoBuildingSetup."Evaluation rating 5");
    end;

    /*begin
    //{
//      JAV 15/08/19: - Se a¤ade el campo 3 "Weighing" que indica el peso en la evaluaci¢n final del proveedor, el campo 4 "Max Value" que indica el m ximo valor que admite el campo
//      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c lculo de las puntuaciones de las mismas
//      JAV 21/09/19: - Se a¤ade el campo 5 "Evaluation Type" y el campo 6 "Acumulate"
//    }
    end.
  */
}







