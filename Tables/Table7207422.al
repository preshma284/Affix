table 7207422 "QBU Codes Evaluation"
{
  
  
    CaptionML=ENU='Codes Evaluation',ESP='C¢digos evaluaci¢n';
    LookupPageID="Codes Evaluation List";
    DrillDownPageID="Codes Evaluation List";
  
  fields
{
    field(1;"Code";Code[10])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[80])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Weighing";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Weighing',ESP='Peso';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='JAV 15/08/19: - Peso en la evaluaci¢n final del proveedor';


    }
    field(4;"Max Value";Integer)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Valor M ximo';
                                                   Description='JAV 17/08/19: - Valor m ximo que puede tomar el campo';

trigger OnValidate();
    BEGIN 
                                                                IF "Max Value" = 0 THEN
                                                                  ERROR(Txt000);
                                                              END;


    }
    field(5;"Evaluation Type";Option)
    {
        OptionMembers="Services","Items","Others";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Uso para evaluar';
                                                   OptionCaptionML=ENU='Services,Items,Others',ESP='Servicios,Productos,Otros';
                                                   
                                                   Description='JAV 21/09/19: - Uso para evaluar servicios, productos u otros';


    }
    field(6;"Acumulate";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Codes Evaluation"."Weighing" WHERE ("Evaluation Type"=FIELD("Evaluation Type")));
                                                   CaptionML=ESP='Acumulado';
                                                   Description='JAV 21/09/19: - Suma de los pesos del mismo tipo';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Evaluation Type","Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Txt000@1100286000 :
      Txt000: TextConst ESP='El valor m ximo no puede ser cero';
//       Txt001@1100286001 :
      Txt001: TextConst ESP='No evaluado';

//     procedure GetClasification (Value@1100286000 :
    procedure GetClasification (Value: Decimal) : Text;
    var
//       QuoBuildingSetup@1100286001 :
      QuoBuildingSetup: Record 7207278;
    begin
      if (Value = 0) then exit(Txt001);
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







