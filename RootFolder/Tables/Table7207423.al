table 7207423 "Data Vendor Evaluation"
{
  
  
    CaptionML=ENU='Data Vendor Evaluation',ESP='Datos Evaluacion Proveedor';
    LookupPageID="Vendor Evaluations List";
    DrillDownPageID="Vendor Evaluations List";
  
  fields
{
    field(1;"Evaluation No.";Code[20])
    {
        CaptionML=ENU='Evaluation No.',ESP='N§ evaluaci¢n';
                                                   Description='JAV 24/01/22: - Se amplia a 20 para que cuadre con las longitudes de contadores';
                                                   Editable=false;


    }
    field(3;"Activity Code";Code[20])
    {
        TableRelation="Activity QB";
                                                   CaptionML=ENU='Activity Code',ESP='C¢d. Actividad';
                                                   NotBlank=true;


    }
    field(4;"Code";Code[10])
    {
        TableRelation="Codes Evaluation"."Code" WHERE ("Evaluation Type"=FIELD("Evaluation Type"));
                                                   

                                                   CaptionML=ENU='Code',ESP='C¢digo';
                                                   NotBlank=true;

trigger OnValidate();
    VAR
//                                                                 CodesEvaluation@1100286000 :
                                                                CodesEvaluation: Record 7207422;
                                                              BEGIN 
                                                                //JAV 21/09/19: - Se a¤ade el campo a la b£squeda del c¢digo de evaluaci¢n
                                                                CodesEvaluation.GET("Evaluation Type", Code);
                                                                Description := CodesEvaluation.Description;
                                                                Weighing := CodesEvaluation.Weighing;
                                                                "Max Value" := CodesEvaluation."Max Value";
                                                              END;


    }
    field(5;"Evaluation Type";Option)
    {
        OptionMembers="Services","Items","Others";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo evaluaci¢n';
                                                   OptionCaptionML=ENU='Services,Items,Others',ESP='Servicios,Productos,Otros';
                                                   
                                                   Description='JAV 21/09/19: - Para distinguir entre evaluar servicios, productos u otros';


    }
    field(10;"Description";Text[30])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';
                                                   Editable=false;


    }
    field(11;"Vendor No.";Code[20])
    {
        TableRelation=Vendor WHERE ("QB Employee"=CONST(false));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Proveedor';
                                                   Editable=false;


    }
    field(12;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';


    }
    field(20;"Value";Decimal)
    {
        

                                                   CaptionML=ENU='Value',ESP='Valor';
                                                   MinValue=0;

trigger OnValidate();
    BEGIN 
                                                                IF (Value < 0) OR (Value > "Max Value") THEN
                                                                  ERROR(Err001,"Max Value");
                                                                IF ("Max Value" = 0) THEN
                                                                  ERROR(Err002);

                                                                QuoBuildingSetup.GET();
                                                                IF (QuoBuildingSetup."Evaluation Value" = 0) THEN
                                                                  ERROR(Err003);

                                                                "Weighing Value" := ROUND(Value * 100 / "Max Value", 0.01);                                    // Promediamos sobre el m ximo del valor
                                                                "Weighing Value" := ROUND("Weighing Value" * Weighing / 100, 0.01);                            // Promediamos sobre el peso del valor
                                                                "Weighing Value" := ROUND("Weighing Value" * QuoBuildingSetup."Evaluation Value" / 100, 0.01); // Ajustamos al m ximo de la evaluaci¢n
                                                              END;


    }
    field(21;"Weighing";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Weighing',ESP='Peso';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='JAV 15/08/19: -  Peso en la evaluaci¢n final del proveedor';
                                                   Editable=false;


    }
    field(22;"Weighing Value";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Valor Ponderado';
                                                   Description='JAV 15/08/19: -  Valor ponderador';
                                                   Editable=false;


    }
    field(23;"Max Value";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='valor M ximo';
                                                   Description='JAV 17/08/19: - Valor m ximo del campo';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Evaluation No.","Activity Code","Evaluation Type","Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Err001@1100286000 :
      Err001: TextConst ESP='El valor de la evaluaci¢n no puede ser menor de cero ni mayor de %1';
//       Err002@1100286001 :
      Err002: TextConst ESP='El valor m ximo no puede ser cero';
//       QuoBuildingSetup@1100286002 :
      QuoBuildingSetup: Record 7207278;
//       Err003@1100286003 :
      Err003: TextConst ESP='No ha definido el valor de la evaluaci¤on e la configuraci¢n de QuoBuilding';

//     procedure CheckVendor (VendorNo@1000000000 :
    procedure CheckVendor (VendorNo: Code[20])
    var
//       Text001@1000000002 :
      Text001: TextConst ENU='Vendor is Blocked',ESP='El proveedor est  bloqueado';
//       Text002@1000000003 :
      Text002: TextConst ENU='Vendor is a Employee',ESP='El proveedor no puede ser un empleado';
//       Vendor@1100286000 :
      Vendor: Record 23;
    begin
      if Vendor.GET(VendorNo) then
        begin
          if Vendor.Blocked = Vendor.Blocked::All  then
            ERROR(Text001);
          if Vendor."QB Employee" = TRUE then
            ERROR(Text002);
        end;
    end;

    /*begin
    //{
//      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c lculo de las puntuaciones de las mismas
//      JAV 21/09/19: - Se a¤ade el campo 5 "Evaluation Type" y a la key principal que queda "Evaluation No.,Activity Code,Evaluation Type,Code"
//                    - Se a¤ade el campo a la b£squeda del c¢digo de evaluaci¢n
//    }
    end.
  */
}







