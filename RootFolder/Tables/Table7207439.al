table 7207439 "Unitary Cost By Job"
{
  
  
    CaptionML=ENU='Unitary Cost By Job',ESP='Costos unitarios por proyecto';
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='No. proyecto';


    }
    field(2;"Type";Option)
    {
        OptionMembers="Item","Resource","Machine","Others";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='Item,Resource,Machine,Others',ESP='Producto,Recurso,Maquina,Otros';
                                                   


    }
    field(3;"No.";Code[20])
    {
        TableRelation=IF ("Type"=CONST("Item")) Item."No."                                                                 ELSE IF ("Type"=CONST("Resource")) Resource."No." WHERE ("Type"=CONST("Person"))                                                                 ELSE IF ("Type"=CONST("Machine")) Resource."No." WHERE ("Type"=CONST("Machine"))                                                                 ELSE IF ("Type"=CONST("Others")) Resource."No." WHERE ("Type"=CONST("Subcontracting"));
                                                   

                                                   CaptionML=ENU='No.',ESP='No.';

trigger OnValidate();
    BEGIN 
                                                                CASE Type OF
                                                                  Type::Item: BEGIN 
                                                                    IF Item.GET("No.") THEN BEGIN 
                                                                      VALIDATE("Unit Cost",Item."Last Direct Cost");
                                                                    END;
                                                                  END;
                                                                  Type::Machine: BEGIN 
                                                                    IF Resource.GET("No.") THEN BEGIN 
                                                                      VALIDATE("Potency (HP)",Resource."Potency (PH)");
                                                                      VALIDATE("Current Cost",Resource."Actual Cost");
                                                                      VALIDATE("Consumed Litres x HP",Resource."Usage (ITS/HR x HP)");
                                                                    END;
                                                                  END;
                                                                END;
                                                              END;


    }
    field(4;"Unit Cost";Decimal)
    {
        

                                                   CaptionML=ENU='Unit Cost',ESP='Coste unitario';
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Item THEN BEGIN 
                                                                  CalculateItem
                                                                END;
                                                              END;


    }
    field(5;"Coefficient";Decimal)
    {
        InitValue=1;
                                                   

                                                   CaptionML=ENU='Coefficient',ESP='Coeficiente';
                                                   DecimalPlaces=0:5;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Item THEN BEGIN 
                                                                  CalculateItem
                                                                END;
                                                              END;


    }
    field(6;"Adjusted Unit Cost";Decimal)
    {
        CaptionML=ENU='Adjusted Unit Cost',ESP='Coste unitario ajustado';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(7;"Transport Km";Decimal)
    {
        

                                                   CaptionML=ENU='Transport Km',ESP='Km transporte';
                                                   DecimalPlaces=0:5;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Item THEN BEGIN 
                                                                  CalculateItem
                                                                END;
                                                              END;


    }
    field(8;"Transport Unit Cost";Decimal)
    {
        CaptionML=ENU='Transport Unit Cost',ESP='Coste unitario transporte';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(9;"Transport Cost";Decimal)
    {
        CaptionML=ENU='Transport Cost',ESP='Coste transporte';
                                                   Editable=false;


    }
    field(10;"% M y A";Decimal)
    {
        

                                                   CaptionML=ENU='% M y A',ESP='% M y A';
                                                   MinValue=0;
                                                   MaxValue=100;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Item THEN BEGIN 
                                                                  CalculateItem;
                                                                END;
                                                              END;


    }
    field(11;"Cost M y A";Decimal)
    {
        CaptionML=ENU='Cost M y A',ESP='Coste M y A';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(12;"% Lost";Decimal)
    {
        

                                                   CaptionML=ENU='% Lost',ESP='% P‚rdidas';
                                                   MinValue=0;
                                                   MaxValue=100;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Item THEN BEGIN 
                                                                  CalculateItem;
                                                                END;
                                                              END;


    }
    field(13;"Lost Cost";Decimal)
    {
        CaptionML=ENU='Lost Cost',ESP='Coste p‚rdidas';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(14;"Total Cost";Decimal)
    {
        CaptionML=ENU='Total Cost',ESP='Coste total';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(15;"Base Salary";Decimal)
    {
        

                                                   CaptionML=ENU='Base Salary',ESP='Salario b sico';
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Resource THEN BEGIN 
                                                                  CalculatePerson
                                                                END;
                                                              END;


    }
    field(16;"Social Charges";Decimal)
    {
        CaptionML=ENU='Social Charges',ESP='cargas sociales';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(17;"Basic Cost";Decimal)
    {
        CaptionML=ENU='Basic Cost',ESP='Coste basico';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(18;"Other 1";Decimal)
    {
        CaptionML=ENU='Other 1',ESP='Otros 1';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(19;"Other 2";Decimal)
    {
        CaptionML=ENU='Other 2',ESP='Otros 2';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(20;"Direct Cost";Decimal)
    {
        CaptionML=ENU='Direct Cost',ESP='Coste directo';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(21;"Set Sum";Decimal)
    {
        

                                                   CaptionML=ENU='Set Sum',ESP='Suma fija';
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Resource THEN BEGIN 
                                                                  CalculatePerson;
                                                                END;
                                                              END;


    }
    field(22;"Cost per Hour";Decimal)
    {
        CaptionML=ENU='Cost per Hour',ESP='Coste por hora';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(23;"Work Hours";Decimal)
    {
        

                                                   CaptionML=ENU='Work Hours',ESP='Horas trabajo';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Resource THEN BEGIN 
                                                                  CalculatePerson
                                                                END;
                                                              END;


    }
    field(24;"Cost per Day";Decimal)
    {
        CaptionML=ENU='Cost per Day',ESP='Coste por d¡a';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(25;"% Assistance";Decimal)
    {
        CaptionML=ENU='% Assistance',ESP='% Asistencia';


    }
    field(26;"% Social Charges";Decimal)
    {
        

                                                   CaptionML=ENU='% Social Charges',ESP='% Cargas sociales';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Resource THEN BEGIN 
                                                                  CalculatePerson;
                                                                END;
                                                              END;


    }
    field(27;"% Other 1";Decimal)
    {
        

                                                   CaptionML=ENU='% Other 1',ESP='% Otros 1';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Resource THEN BEGIN 
                                                                  CalculatePerson;
                                                                END;
                                                              END;


    }
    field(28;"% Other 2";Decimal)
    {
        

                                                   CaptionML=ENU='% Other 2',ESP='% Otros 2';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Resource THEN BEGIN 
                                                                  CalculatePerson
                                                                END;
                                                              END;


    }
    field(29;"Potency (HP)";Decimal)
    {
        

                                                   CaptionML=ENU='Potency (HP)',ESP='Potency (CV)';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Machine THEN BEGIN 
                                                                  CalculateEquipament;
                                                                END;
                                                              END;


    }
    field(30;"Current Cost";Decimal)
    {
        CaptionML=ENU='Current Cost',ESP='Coste actual';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(31;"Equipament Coefficient";Decimal)
    {
        

                                                   CaptionML=ENU='Equipament Coefficient',ESP='Coeficiente maquin ria';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Machine THEN BEGIN 
                                                                  CalculateEquipament;
                                                                END;
                                                              END;


    }
    field(32;"Updated Cost";Decimal)
    {
        CaptionML=ENU='Updated Cost',ESP='Coste actualizado';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(33;"Residual Value";Decimal)
    {
        CaptionML=ENU='Residual Value',ESP='Valor residual';
                                                   Editable=false;
                                                   AutoFormatType=1;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(34;"Useful Life in Hours";Decimal)
    {
        

                                                   CaptionML=ENU='Useful Life in Hours',ESP='Vida util en horas';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Machine THEN BEGIN 
                                                                  CalculateEquipament;
                                                                END;
                                                              END;


    }
    field(35;"Annual Use in Hours";Decimal)
    {
        CaptionML=ENU='Annual Use in Hours',ESP='Uso anual en horas';


    }
    field(36;"Amortization Time";Decimal)
    {
        CaptionML=ENU='Amortization Time',ESP='Amortizaci¢n horas';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(37;"Interests Hours";Decimal)
    {
        CaptionML=ENU='Interests Hours',ESP='Intereses horas';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(38;"Sum Hours";Decimal)
    {
        CaptionML=ENU='Sum Hours',ESP='Suma hora';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(39;"Repairs and Spare Parts Hours";Decimal)
    {
        CaptionML=ENU='Repairs and Spare Parts Hours',ESP='Reparaciones y repuestos hora';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(40;"Combustible Type";Option)
    {
        OptionMembers=" ","Naphtha","Diesel";

                                                   CaptionML=ENU='Combustible Type',ESP='Tipo combustible';
                                                   OptionCaptionML=ENU='" ,Naphtha,Diesel"',ESP='" ,Nafta,Gasoil"';
                                                   

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Machine THEN BEGIN 
                                                                  Job.GET("Job No.");
                                                                  IF "Combustible Type" = "Combustible Type"::Naphtha THEN
                                                                    VALIDATE("Unitary Price Litres",Job."Unitary Cost Naphta");
                                                                  IF "Combustible Type" = "Combustible Type"::Diesel THEN
                                                                    VALIDATE("Unitary Price Litres",Job."Unitary Cost Diesel");
                                                                  IF "Combustible Type" = "Combustible Type"::" " THEN
                                                                    VALIDATE("Unitary Price Litres",0);
                                                                END;
                                                              END;


    }
    field(41;"Unitary Price Litres";Decimal)
    {
        

                                                   CaptionML=ENU='Unitary Price Litres',ESP='Precio unitario litros';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Machine THEN BEGIN 
                                                                  CalculateEquipament
                                                                END;
                                                              END;


    }
    field(42;"Consumed Litres x HP";Decimal)
    {
        

                                                   CaptionML=ENU='Consumed Litres x HP',ESP='Consumo litros x CV';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Machine THEN BEGIN 
                                                                  CalculateEquipament;
                                                                END;
                                                              END;


    }
    field(43;"Consumed Cost";Decimal)
    {
        CaptionML=ENU='Consumed Cost',ESP='Coste consumo';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(44;"Grease Hour";Decimal)
    {
        CaptionML=ENU='Grease Hour',ESP='Lubricante hora';
                                                   Editable=false;
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(45;"Q. Combustible and Grease H.";Decimal)
    {
        CaptionML=ENU='Q. Combustible and Grease H.',ESP='C. combustible y lubricante h.';
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;


    }
    field(46;"Contract Price";Decimal)
    {
        

                                                   CaptionML=ENU='Contract Price',ESP='Precio contrato';
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency;

trigger OnValidate();
    BEGIN 
                                                                Job.GET("Job No.");
                                                                GetCurrency;
                                                                "Sales Price (Base)" := ROUND(("Contract Price" * (1+(Job."General Expenses / Other"/100)+(Job."Industrial Benefit"/100)) *
                                                                                                                    (1-(Job."Low Coefficient"/100)) *
                                                                                                                    (1-(Job."Quality Deduction"/100)))
                                                                                                                    ,Currency."Unit-Amount Rounding Precision");
                                                              END;


    }
    field(47;"Sales Price (Base)";Decimal)
    {
        CaptionML=ENU='Sales Price (Base)',ESP='Precio venta (base)';
                                                   AutoFormatType=2;
                                                   AutoFormatExpression=GetCurrency ;


    }
}
  keys
{
    key(key1;"Job No.","Type","No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Currency@7001100 :
      Currency: Record 4;
//       Item@7001101 :
      Item: Record 27;
//       Resource@7001102 :
      Resource: Record 156;
//       CurrencyExchangeRate@7001104 :
      CurrencyExchangeRate: Record 330;
//       Text001@7001105 :
      Text001: TextConst ENU='Do you want to update the cost of this bill of item in the piecework in which it appears?',ESP='¨Desea actualizar el coste de este descompuesto en la unidades de obra en las que aparezca?';
//       Job@7001106 :
      Job: Record 167;

    procedure GetCurrency () : Code[10];
    var
//       LJob@1100240000 :
      LJob: Record 167;
    begin
      if LJob.GET("Job No.") then begin
        CLEAR(Currency);
        if LJob."Currency Code" <> '' then
          Currency.GET(LJob."Currency Code");
        Currency.InitRoundingPrecision;
        exit(Currency.Code);
      end else begin
        CLEAR(Currency);
        Currency.InitRoundingPrecision;
        exit(Currency.Code);
      end;
    end;

    procedure Description () : Text[50];
    var
//       Item@1100240000 :
      Item: Record 27;
//       Resource@1100240001 :
      Resource: Record 156;
    begin
      if Type = Type::Item then begin
        if Item.GET("No.") then
          exit(Item.Description)
        else
          exit('');
      end else begin
        if Resource.GET("No.") then
          exit(Resource.Name)
        else
          exit('');
      end;
    end;

    procedure CalculateItem ()
    begin
      if Type = Type::Item then begin
        GetCurrency;
        if GetCurrency <> '' then
          CurrencyExchangeRate.ExchangeAmtLCYToFCY(TODAY,GetCurrency,"Transport Unit Cost",CurrencyExchangeRate.ExchangeRate(TODAY,GetCurrency));
        "Adjusted Unit Cost" := ROUND("Unit Cost" * Coefficient,Currency."Unit-Amount Rounding Precision");
        "Transport Cost" := ROUND("Transport Unit Cost" * "Transport Km", Currency."Unit-Amount Rounding Precision");
        "Cost M y A" := ROUND(("Adjusted Unit Cost" + "Transport Unit Cost") * "% M y A"/100, Currency."Unit-Amount Rounding Precision");
        "Lost Cost" := ROUND(("Adjusted Unit Cost" + "Transport Unit Cost") * "% Lost"/100, Currency."Unit-Amount Rounding Precision");
        "Total Cost" := "Adjusted Unit Cost" + "Transport Cost" + "Cost M y A" + "Lost Cost";
        UpdateBillofItem;
      end;
    end;

    procedure UpdateBillofItem ()
    var
//       LDataCostByPiecework@1100240000 :
      LDataCostByPiecework: Record 7207387;
//       LJob@1100240001 :
      LJob: Record 167;
    begin
      if not CONFIRM(Text001,FALSE) then
        exit;

      LJob.GET("Job No.");
      LDataCostByPiecework .SETRANGE("Job No.","Job No.");
      LDataCostByPiecework.SETRANGE("Cod. Budget",LJob."Initial Budget Piecework");
      CASE Type OF
        Type::Item:begin
          LDataCostByPiecework.SETRANGE("Cost Type",LDataCostByPiecework."Cost Type"::Item);
          LDataCostByPiecework.SETRANGE("No.","No.");
          if LDataCostByPiecework.FINDSET then begin
            repeat
              LDataCostByPiecework.VALIDATE("Direct Unitary Cost (JC)","Total Cost");
              LDataCostByPiecework.MODIFY;
            until LDataCostByPiecework.NEXT = 0;
          end;
        end;
        Type::Resource,Type::Machine:begin
          LDataCostByPiecework.SETRANGE("Cost Type",LDataCostByPiecework."Cost Type"::Resource);
          LDataCostByPiecework.SETRANGE("No.","No.");
          if LDataCostByPiecework.FINDSET then begin
            repeat
              LDataCostByPiecework.VALIDATE("Direct Unitary Cost (JC)","Total Cost");
              LDataCostByPiecework.MODIFY;
            until LDataCostByPiecework.NEXT = 0;
          end;
        end;
      end;
    end;

    procedure CalculatePerson ()
    begin
      if Type = Type::Resource then begin
        GetCurrency;
        "Other 1" := ROUND("Base Salary" * "% Other 1"/100,Currency."Unit-Amount Rounding Precision");
        "Other 2" := ROUND("Base Salary" * "% Other 2"/100,Currency."Unit-Amount Rounding Precision");
        "Social Charges" := ROUND("Base Salary" * "% Social Charges"/100,Currency."Unit-Amount Rounding Precision");
        "Basic Cost" := "Base Salary" + "Social Charges";

        "Direct Cost" := "Basic Cost" + "Other 1" + "Other 2";
        "Cost per Hour" := "Direct Cost" + "Set Sum";
        "Total Cost" := "Cost per Hour";
        "Cost per Day" := ROUND("Cost per Hour" * "Work Hours",Currency."Unit-Amount Rounding Precision");
        UpdateBillofItem;
      end;
    end;

    procedure CalculateEquipament ()
    begin
      if Type = Type::Machine then begin
        Job.GET("Job No.");
        GetCurrency;
        "Updated Cost" := ROUND("Current Cost" * "Equipament Coefficient",Currency."Unit-Amount Rounding Precision");
        "Residual Value" := ROUND("Updated Cost" * Job."% Residual Value"/100,Currency."Unit-Amount Rounding Precision");
        if "Useful Life in Hours" <> 0 then begin
          "Amortization Time" := ROUND(("Updated Cost" - "Residual Value")/"Useful Life in Hours",
                                 Currency."Unit-Amount Rounding Precision");
        end else begin
          "Amortization Time" := 0;
        end;
      // Falta el calcilo de intereses
        "Sum Hours" := "Amortization Time" + "Interests Hours";
        Job.GET("Job No.");
        "Repairs and Spare Parts Hours" := ROUND(Job."% Repairs and Spare Parts" * "Sum Hours"/100,
                                                 Currency."Unit-Amount Rounding Precision");
        "Total Cost" := "Sum Hours" + "Repairs and Spare Parts Hours" + "Q. Combustible and Grease H.";

        "Consumed Cost" := ROUND("Unitary Price Litres" * "Consumed Litres x HP" * "Potency (HP)",
                           Currency."Unit-Amount Rounding Precision");
        "Grease Hour" := ROUND("Consumed Cost" * Job."% Grease"/100);
        "Q. Combustible and Grease H." := "Consumed Cost" + "Grease Hour";
        "Total Cost" := "Sum Hours" + "Repairs and Spare Parts Hours" + "Q. Combustible and Grease H.";
        UpdateBillofItem;
      end;
    end;

    /*begin
    end.
  */
}







