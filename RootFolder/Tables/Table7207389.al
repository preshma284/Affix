table 7207389 "TMP Expected Time Unit Data"
{
  
  
    CaptionML=ENU='TMP Expected Time Unit Data',ESP='TMP Datos previsi¢n unid. tiempo';
    LookupPageID="Schedule MSP";
    DrillDownPageID="Schedule MSP";
  
  fields
{
    field(1;"Job No.";Code[20])
    {
        CaptionML=ENU='Job No.',ESP='N§ Proyecto';


    }
    field(2;"Expected Date";Date)
    {
        CaptionML=ENU='Expected Date',ESP='Fecha prevista';


    }
    field(3;"Expected Measured Amount";Decimal)
    {
        

                                                   CaptionML=ENU='Expected Measured Amount',ESP='Cantidad medici¢n prevista';

trigger OnValidate();
    BEGIN 
                                                                //[controlamos que al insertar el primer registro y la fecha es cero cargar la fecha inicial del proyecto o la de hoy]
                                                                IF "Expected Date" = 0D THEN BEGIN 
                                                                  Job.GET("Job No.");
                                                                  IF "Budget Code" <> '' THEN
                                                                    "Budget Code":="Budget Code"
                                                                  ELSE BEGIN 
                                                                    IF Job."Current Piecework Budget" <> '' THEN
                                                                      "Budget Code":= Job."Current Piecework Budget"
                                                                    ELSE
                                                                      "Budget Code":= Job."Initial Budget Piecework";
                                                                  END;

                                                                  JobBudgetCurrent.GET("Job No.","Budget Code");

                                                                  IF Job."Starting Date" <> 0D THEN
                                                                    "Expected Date":=Job."Starting Date"
                                                                  ELSE
                                                                    "Expected Date":=TODAY;

                                                                  IF "Expected Date" < JobBudgetCurrent."Budget Date" THEN
                                                                    "Expected Date" := JobBudgetCurrent."Budget Date";
                                                                END;

                                                                //[controlamos que al insertar el primer registro calcular el imp.vta.ppto=cantidad medici¢n ppto * pv de la tabla DU]
                                                                // DataPieceworkForProduction.GET("Job No.","Piecework Code");
                                                                // "Budget Sale Amount"  :="Expected Measured Amount" * (DataPieceworkForProduction.PriceSales);
                                                                //
                                                                // PriceSale := DataPieceworkForProduction.ProductionPrice;
                                                                // PriceCost := DataPieceworkForProduction.CostPrice;
                                                                // "Expected Cost Amount" := "Expected Measured Amount" * PriceCost;
                                                                // "Expected Production Amount" := "Expected Measured Amount" * PriceSale;
                                                              END;


    }
    field(4;"Budget Code";Code[20])
    {
        TableRelation="Job Budget"."Cod. Budget" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Budget Code',ESP='C¢d. Presupuesto';


    }
    field(5;"Piecework Code";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   CaptionML=ENU='Piecework Code',ESP='C¢d. unidad de obra';


    }
    field(6;"Entry No.";Integer)
    {
        CaptionML=ENU='Entry No.',ESP='N§ Mov';


    }
    field(7;"Unit Type";Option)
    {
        OptionMembers="Piecework","Cost Unit","Investment Unit","Certification";CaptionML=ENU='Unit Type',ESP='Tipo unidad';
                                                   OptionCaptionML=ENU='Piecework,Cost Unit,Investment Unit,Certification',ESP='Unidad de obra,Unidad de coste,Unidad de inversi¢n,Certificaci¢n';
                                                   


    }
    field(8;"Incluided In Dispatch";Boolean)
    {
        CaptionML=ENU='Incluided In Dispatch',ESP='Incluido en parte';


    }
    field(9;"Doc. Dispatch No.";Code[20])
    {
        CaptionML=ENU='Doc. Dispatch No.',ESP='N§ doc. parte';


    }
    field(10;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(11;"Cost Database Code";Code[20])
    {
        TableRelation="Cost Database";
                                                   CaptionML=ENU='Cost Database Code',ESP='C¢d. preciario';


    }
    field(12;"Unique Code";Code[30])
    {
        CaptionML=ENU='Unique Code',ESP='C¢digo £nico';
                                                   Description='QB- Ampliado para importar m s niveles en BC3';


    }
    field(13;"Performed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Performed',ESP='Realizado';


    }
    field(14;"Record No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Record No.',ESP='N§ Expediente';


    }
    field(15;"U. Posting Code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='U. Posting Code',ESP='Cod. U. Auxiliar';


    }
    field(16;"Budget Sale Amount";Decimal)
    {
        CaptionML=ENU='Budget Sale Amount',ESP='Imp. vta. ppto';
                                                   Description='Campo solo en la temporal';


    }
    field(17;"Budget Cost Amount";Decimal)
    {
        CaptionML=ENU='Budget Cost Amount',ESP='Imp. coste ppto';
                                                   Description='Campo solo en la temporal';


    }
    field(18;"New Piecework Code";Boolean)
    {
        CaptionML=ENU='New Piecework Code',ESP='Cod. unidad de obra nueva';
                                                   Description='Campo solo en la temporal';


    }
    field(19;"Expected Cost Amount";Decimal)
    {
        

                                                   CaptionML=ENU='Expected Cost Amount',ESP='Importe coste previsto';
                                                   Description='Campo solo en la temporal';

trigger OnValidate();
    BEGIN 
                                                                Job.GET("Job No.");
                                                                IF "Budget Code" <> '' THEN
                                                                  "Budget Code":="Budget Code"
                                                                ELSE BEGIN 
                                                                  IF Job."Current Piecework Budget" <> '' THEN
                                                                    "Budget Code":= Job."Current Piecework Budget"
                                                                  ELSE
                                                                    "Budget Code":= Job."Initial Budget Piecework";
                                                                END;

                                                                JobBudgetCurrent.GET("Job No.","Budget Code");

                                                                DataPieceworkForProduction.GET("Job No.","Piecework Code");
                                                                DataPieceworkForProduction.SETRANGE("Budget Filter","Budget Code");
                                                                PriceSale := DataPieceworkForProduction.ProductionPrice;
                                                                PriceCost := DataPieceworkForProduction.CostPrice;
                                                                IF "Expected Date" < JobBudgetCurrent."Budget Date" THEN
                                                                  "Expected Date" := JobBudgetCurrent."Budget Date";

                                                                VALIDATE("Expected Measured Amount", ("Expected Cost Amount"/PriceCost));
                                                              END;


    }
    field(20;"Expected Production Amount";Decimal)
    {
        

                                                   CaptionML=ENU='Expected Production Amount',ESP='Importe producci¢n previsto';
                                                   Description='Campo solo en la temporal';

trigger OnValidate();
    BEGIN 
                                                                Job.GET("Job No.");
                                                                IF "Budget Code" <> '' THEN
                                                                  "Budget Code":="Budget Code"
                                                                ELSE BEGIN 
                                                                  IF Job."Current Piecework Budget" <> '' THEN
                                                                    "Budget Code":= Job."Current Piecework Budget"
                                                                  ELSE
                                                                    "Budget Code":= Job."Initial Budget Piecework";
                                                                END;

                                                                JobBudgetCurrent.GET("Job No.","Budget Code");

                                                                DataPieceworkForProduction.GET("Job No.","Piecework Code");
                                                                DataPieceworkForProduction.SETRANGE("Budget Filter","Budget Code");
                                                                PriceSale := DataPieceworkForProduction.ProductionPrice;
                                                                PriceCost := DataPieceworkForProduction.CostPrice;
                                                                IF "Expected Date" < JobBudgetCurrent."Budget Date" THEN
                                                                  "Expected Date" := JobBudgetCurrent."Budget Date";

                                                                VALIDATE("Expected Measured Amount", ("Expected Production Amount"/PriceSale));
                                                              END;


    }
    field(21;"Expected Percentage";Decimal)
    {
        

                                                   CaptionML=ENU='Expected Percentage',ESP='Porcentaje previsto';
                                                   Description='Campo solo en la temporal';

trigger OnValidate();
    BEGIN 
                                                                VALIDATE("Expected Measured Amount", Rec."Budget Measure" * "Expected Percentage" / 100);
                                                              END;


    }
    field(22;"Budget Measure";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Medici¢n ppto.';
                                                   Description='Campo solo en la temporal' ;


    }
}
  keys
{
    key(key1;"Entry No.")
    {
        Clustered=true;
    }
    key(key2;"Job No.","Piecework Code","Budget Code","Expected Date")
    {
        SumIndexFields="Expected Measured Amount","Budget Sale Amount","Expected Production Amount","Expected Percentage";
    }
    key(key3;"Job No.","Piecework Code","Expected Date")
    {
        SumIndexFields="Expected Measured Amount","Budget Sale Amount","Expected Cost Amount","Expected Production Amount","Expected Percentage";
    }
}
  fieldgroups
{
}
  
    var
//       TMPExpectedTimeUnitData@1100286000 :
      TMPExpectedTimeUnitData: Record 7207389;
//       DataPieceworkForProduction@7001100 :
      DataPieceworkForProduction: Record 7207386;
//       Job@7001101 :
      Job: Record 167;
//       JobBudgetCurrent@7001102 :
      JobBudgetCurrent: Record 7207407;
//       PriceSale@7001103 :
      PriceSale: Decimal;
//       PriceCost@7001104 :
      PriceCost: Decimal;
//       Decimales@1100286001 :
      Decimales: Decimal;
//       nrReg@1100286002 :
      nrReg: Integer;

    

trigger OnInsert();    begin
               SetData;
             end;

trigger OnModify();    begin
               SetData;
             end;



// procedure CostBudgetAmount (var LExpectedTimeUnitData@7001100 :
procedure CostBudgetAmount (var LExpectedTimeUnitData: Record 7207388) : Decimal;
    begin
      DataPieceworkForProduction.RESET;
      DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Job No.",LExpectedTimeUnitData."Job No.");
      DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction."Piecework Code",LExpectedTimeUnitData."Piecework Code");
      DataPieceworkForProduction.SETRANGE("Budget Filter",LExpectedTimeUnitData."Budget Code");
      if DataPieceworkForProduction.FINDFIRST then
        DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Aver. Cost Price Pend. Budget");

      exit("Expected Measured Amount" * DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
    end;

    procedure SetData ()
    begin
      //-Q19133 Original copiado como SetDAtaBAK
      //AML se cambia porque ciertos importes no son correctos para poder comprobar los informes. Las mediciones son correctas. Los importes no siempre

      Decimales := 0.0001;
      if (Rec."Unit Type" = Rec."Unit Type"::Certification) then begin
        Rec."Expected Measured Amount" := ROUND(Rec."Expected Measured Amount", 0.01);
        if (Rec."Budget Measure" <> 0) then
          Rec."Expected Percentage" := ROUND(100 * Rec."Expected Measured Amount" / Rec."Budget Measure", Decimales)
        else
          Rec."Expected Percentage" := 0;

      end else begin
        Rec."Expected Measured Amount" := ROUND(Rec."Expected Measured Amount", Decimales);

        if (Rec."Entry No." = 0) then begin
          TMPExpectedTimeUnitData.RESET;
          if TMPExpectedTimeUnitData.FINDLAST then
            Rec."Entry No." := TMPExpectedTimeUnitData."Entry No." + 1
          else
            Rec."Entry No." := 1;
        end;

        DataPieceworkForProduction.GET("Job No.", "Piecework Code");
        if (DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading) then begin
          Rec."Budget Measure"     := 0;
          Rec."Budget Sale Amount" := 0;
          Rec."Budget Cost Amount" := 0;
        end else begin
          DataPieceworkForProduction.SETFILTER("Budget Filter","Budget Code");
          DataPieceworkForProduction.CALCFIELDS("Budget Measure","Amount Production Budget","Amount Cost Budget (JC)");
          Rec."Budget Measure"     := DataPieceworkForProduction."Budget Measure";
          Rec."Budget Sale Amount" := DataPieceworkForProduction."Amount Production Budget";
          Rec."Budget Cost Amount" := DataPieceworkForProduction."Amount Cost Budget (JC)";
        end;

        if (Rec."Budget Measure" <> 0) then begin
          //-Q19133
          DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
          //Performed Rec."Expected Cost Amount"       := ROUND(Rec."Budget Cost Amount" * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
          if not Rec.Performed then Rec."Expected Cost Amount"       := ROUND("Expected Measured Amount" * DataPieceworkForProduction."Aver. Cost Price Pend. Budget",Decimales);
          if Rec.Performed then Rec."Expected Cost Amount"       := CalcCosteReal;
          //+Q19133
          Rec."Expected Production Amount" := ROUND(Rec."Budget Sale Amount" * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
          Rec."Expected Percentage"        := ROUND(100                      * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
        end else begin
          Rec."Expected Cost Amount" := 0;
          Rec."Expected Production Amount" := 0;
          Rec."Expected Percentage" := 0;
        end;
      end;
    end;

    procedure SetDataBAK ()
    begin
      Decimales := 0.0001;
      if (Rec."Unit Type" = Rec."Unit Type"::Certification) then begin
        Rec."Expected Measured Amount" := ROUND(Rec."Expected Measured Amount", 0.01);
        if (Rec."Budget Measure" <> 0) then
          Rec."Expected Percentage" := ROUND(100 * Rec."Expected Measured Amount" / Rec."Budget Measure", Decimales)
        else
          Rec."Expected Percentage" := 0;

      end else begin
        Rec."Expected Measured Amount" := ROUND(Rec."Expected Measured Amount", Decimales);

        if (Rec."Entry No." = 0) then begin
          TMPExpectedTimeUnitData.RESET;
          if TMPExpectedTimeUnitData.FINDLAST then
            Rec."Entry No." := TMPExpectedTimeUnitData."Entry No." + 1
          else
            Rec."Entry No." := 1;
        end;

        DataPieceworkForProduction.GET("Job No.", "Piecework Code");
        if (DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading) then begin
          Rec."Budget Measure"     := 0;
          Rec."Budget Sale Amount" := 0;
          Rec."Budget Cost Amount" := 0;
        end else begin
          DataPieceworkForProduction.SETFILTER("Budget Filter","Budget Code");
          DataPieceworkForProduction.CALCFIELDS("Budget Measure","Amount Production Budget","Amount Cost Budget (JC)");
          Rec."Budget Measure"     := DataPieceworkForProduction."Budget Measure";
          Rec."Budget Sale Amount" := DataPieceworkForProduction."Amount Production Budget";
          Rec."Budget Cost Amount" := DataPieceworkForProduction."Amount Cost Budget (JC)";
        end;

        if (Rec."Budget Measure" <> 0) then begin
          Rec."Expected Cost Amount"       := ROUND(Rec."Budget Cost Amount" * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
          Rec."Expected Production Amount" := ROUND(Rec."Budget Sale Amount" * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
          Rec."Expected Percentage"        := ROUND(100                      * Rec."Expected Measured Amount" / Rec."Budget Measure",Decimales);
        end else begin
          Rec."Expected Cost Amount" := 0;
          Rec."Expected Production Amount" := 0;
          Rec."Expected Percentage" := 0;
        end;
      end;
    end;

    LOCAL procedure CalcCosteReal () : Decimal;
    var
//       JobLedgerEntry@1100286001 :
      JobLedgerEntry: Record 169;
    begin
      //Q19133 Para calcular el coste de lo realizado.
      JobLedgerEntry.SETRANGE("Job No.","Job No.");
      JobLedgerEntry.SETRANGE("Entry Type",JobLedgerEntry."Entry Type"::Usage);
      JobLedgerEntry.SETRANGE("Piecework No.","Piecework Code");
      JobLedgerEntry.SETRANGE("Posting Date",0D,"Expected Date");
      JobLedgerEntry.CALCSUMS("Total Cost (LCY)");
      exit(JobLedgerEntry."Total Cost (LCY)");
    end;

    /*begin
    //{
//      Q19133 AML 20/07/23 Modificaciones en el c lculo de importes. Se modifica la funcion SetDATA y se crea la funcion CalcCosteReal
//    }
    end.
  */
}







