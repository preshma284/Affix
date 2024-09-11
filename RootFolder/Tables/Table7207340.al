table 7207340 "Data Cost By Piecework Cert."
{


    CaptionML = ENU = 'Data Cost By Piecework Cert.', ESP = 'Descompuestos de venta';
    LookupPageID = "Piecework Cost List";
    DrillDownPageID = "Piecework Cost List";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';
            Editable = false;


        }
        field(2; "Line Type"; Option)
        {
            OptionMembers = "Account","Resource","Resource Group","Item","Posting U.";

            CaptionML = ENU = 'Cost Type', ESP = 'Tipo L�nea';
            OptionCaptionML = ENU = 'Account,Resource,Resource Group,Item', ESP = 'Cuenta,Recurso,Familia,Producto';


            trigger OnValidate();
            BEGIN
                CheckClosed;
            END;


        }
        field(3; "No."; Code[20])
        {
            TableRelation = IF ("Line Type" = CONST("Account")) "G/L Account" ELSE IF ("Line Type" = CONST("Resource")) Resource WHERE("Type" = FILTER(<> "ExternalWorker")) ELSE IF ("Line Type" = CONST("Resource Group")) "Resource Group" ELSE IF ("Line Type" = CONST("Item")) Item;


            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'QB 1.06.10 JAV 20/08/20: - No pueden ser trabajadores externos';

            trigger OnValidate();
            BEGIN
                CheckClosed;

                Job.GET("Job No.");
                CASE "Line Type" OF
                    "Line Type"::Account:
                        BEGIN
                            GLAccount.GET("No.");
                            Description := GLAccount.Name;
                            VALIDATE("Sale Price", 0);
                        END;
                    "Line Type"::Resource:
                        BEGIN
                            Resource.GET("No.");
                            IF (Resource.Type = Resource.Type::ExternalWorker) THEN
                                ERROR(Text000);
                            Description := Resource.Name;
                            VALIDATE("Cod. Measure Unit", Resource."Base Unit of Measure");

                            IF NOT ResourceCost.GET(ResourceCost.Type::Resource, "No.", '') THEN BEGIN
                                CLEAR(ResourceCost);
                                ResourceCost."Direct Unit Cost" := Resource."Direct Unit Cost";
                                ResourceCost."Unit Cost" := Resource."Unit Cost";
                                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                                    ResourceCost."C.A. Direct Cost Allocation" := Resource."Global Dimension 1 Code";
                                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                                    ResourceCost."C.A. Direct Cost Allocation" := Resource."Global Dimension 2 Code";
                                ResourceCost."C.A. Indirect Cost Allocation" := Resource."Cod. C.A. Indirect Costs";
                            END;

                            IF Job."Use Unit Price Ratio" THEN BEGIN
                                IF Resource.Type <> Resource.Type::Subcontracting THEN BEGIN
                                    UnitaryCostByJob.SETRANGE("Job No.", "Job No.");
                                    UnitaryCostByJob.SETRANGE("No.", "No.");
                                    IF UnitaryCostByJob.FINDFIRST THEN
                                        VALIDATE("Sale Price (LCY)", UnitaryCostByJob."Total Cost")
                                END;
                            END ELSE
                                VALIDATE("Sale Price (LCY)", ResourceCost."Direct Unit Cost");
                        END;

                    "Line Type"::Item:
                        BEGIN
                            IF Job."Use Unit Price Ratio" THEN BEGIN
                                UnitaryCostByJob.SETRANGE("Job No.", "Job No.");
                                UnitaryCostByJob.SETRANGE("No.", "No.");
                                IF NOT UnitaryCostByJob.FINDFIRST THEN
                                    ERROR(Text003);
                            END;

                            Item.GET("No.");
                            Description := Item.Description;

                            StockkeepingUnit.SETRANGE("Location Code", Job."Job Location");
                            StockkeepingUnit.SETRANGE("Item No.", "No.");
                            IF UnitaryCostByJob.FINDFIRST THEN
                                VALIDATE("Sale Price (LCY)", UnitaryCostByJob."Total Cost")
                            ELSE
                                VALIDATE("Sale Price (LCY)", Item."Unit Cost");

                            VALIDATE("Cod. Measure Unit", Item."Base Unit of Measure");
                        END;

                    "Line Type"::"Resource Group":
                        BEGIN
                            ResourceGroup.GET("No.");
                            Description := ResourceGroup.Name;
                            ResourceCost.GET(ResourceCost.Type::"Group(Resource)", "No.", '');
                            VALIDATE("Sale Price (LCY)", ResourceCost."Direct Unit Cost");
                        END;

                END;
            END;


        }
        field(5; "Performance By Piecework"; Decimal)
        {


            CaptionML = ENU = 'Performance By Piecework', ESP = 'Rendimiento por UO';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                CheckClosed;
                UpdateTotals;
            END;


        }
        field(6; "Sale Price (LCY)"; Decimal)
        {


            CaptionML = ENU = 'Direct Unitary Cost LCY', ESP = 'Precio venta (DL)';
            Description = 'JAV 25/07/19: - Se hace no editable, se debe cambiar desde el campo "Sale Price" pues este va en divisa local//30/08/19JMMA SE MODIFICA PORQUE NO FUNCIONA CORRECTAMENTE AL TRAER PRECIARIO';
            Editable = false;
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CheckClosed;

                //Calculo en importe en la divisa de la linea
                JobCurrencyExchangeFunction.CalculateCurrencyValue("Job No.", "Sale Price (LCY)", '', "Currency Code", "Currency Date", 0, AssignedAmount, CurrencyFactor);
                VALIDATE("Sale Price", AssignedAmount);
            END;


        }
        field(7; "Sale Amount (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Budget Cost', ESP = 'Importe Venta (DL)';
            Description = 'JAV 25/07/19: - Se cambia el caption para indicar que es el Importe';
            Editable = false;
            AutoFormatType = 1;


        }
        field(8; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
            Editable = false;


        }
        field(9; "Cod. Measure Unit"; Code[10])
        {
            TableRelation = IF ("Line Type" = CONST("Item")) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No.")) ELSE IF ("Line Type" = CONST("Resource")) "Resource Unit of Measure"."Code" WHERE("Resource No." = FIELD("No.")) ELSE
            "Unit of Measure";


            CaptionML = ENU = 'Cod. Measure Unit', ESP = 'Unidad medida';

            trigger OnValidate();
            BEGIN
                CheckClosed;

                Job.GET("Job No.");
                CASE "Line Type" OF
                    "Line Type"::Resource:
                        BEGIN
                            Resource.GET("No.");
                            IF "Cod. Measure Unit" <> xRec."Cod. Measure Unit" THEN BEGIN
                                VALIDATE("Sale Price", 0);
                            END;
                        END;
                    "Line Type"::Item:
                        BEGIN
                            ItemUnitofMeasure.GET("No.", "Cod. Measure Unit");
                            Item.GET("No.");

                            UnitaryCostByJob.SETRANGE("Job No.", "Job No.");
                            UnitaryCostByJob.SETRANGE("No.", "No.");
                            IF NOT UnitaryCostByJob.FINDFIRST THEN BEGIN
                                StockkeepingUnit.SETRANGE("Location Code", Job."Job Location");
                                StockkeepingUnit.SETRANGE("Item No.", "No.");
                                IF StockkeepingUnit.FINDFIRST THEN BEGIN
                                    VALIDATE("Sale Price (LCY)", StockkeepingUnit."Unit Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                                END ELSE BEGIN
                                    VALIDATE("Sale Price (LCY)", Item."Unit Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                                END;
                            END ELSE
                                VALIDATE("Sale Price (LCY)", UnitaryCostByJob."Total Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                        END;
                END;
            END;


        }
        field(14; "Code Cost Database"; Code[20])
        {
            TableRelation = "Cost Database";
            CaptionML = ENU = 'Code Cost Database', ESP = 'C�d. preciario';


        }
        field(15; "Unique Code"; Code[30])
        {
            CaptionML = ENU = 'Unique Code', ESP = 'C�digo �nico';
            Description = 'QB- Ampliado para importar m�s niveles en BC3';


        }
        field(16; "No. Record"; Code[20])
        {
            TableRelation = "Records"."No.";
            CaptionML = ENU = 'Cod. Budget', ESP = 'C�d. Expediente';
            Editable = false;


        }
        field(22; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripción';

            trigger OnValidate();
            BEGIN
                CheckClosed;
            END;


        }
        field(23; "Description 2"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripción 2';

            trigger OnValidate();
            BEGIN
                CheckClosed;
            END;


        }
        field(30; "Has Additional Text"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Text" WHERE("Table" = CONST("Job"),
                                                                                      "Key1" = FIELD("Job No."),
                                                                                      "Key2" = FIELD("Piecework Code"),
                                                                                      "Key3" = FIELD("No.")));


            CaptionML = ENU = 'Additional Text', ESP = 'Texto Adicional';
            Description = 'QB 1.02';
            Editable = false;

            trigger OnLookup();
            VAR
                //                                                               QBText@1100286000 :
                QBText: Record 7206918;
                //                                                               QBTextCard@1100286001 :
                QBTextCard: Page 7206929;
            BEGIN
                IF NOT QBText.GET(QBText.Table::Job, "Job No.", "Piecework Code", "No.") THEN BEGIN
                    QBText.InsertSalesText('', QBText.Table::Job, "Job No.", "Piecework Code", "No.");
                    COMMIT;
                END;
                CLEAR(QBTextCard);
                QBTextCard.SETRECORD(QBText);
                QBTextCard.RUNMODAL;
                CALCFIELDS("Has Additional Text");
            END;


        }
        field(40; "Order No."; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Orden';
            Description = 'AML Campo A�adido Para poder importar los productos repetidos de un preciario';


        }
        field(1000; "Sale Price"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio Venta';
            Description = 'En la DIVISA del DESCOMPUESTO';

            trigger OnValidate();
            BEGIN
                CheckClosed;

                IF DataPieceworkForProduction.GET("Job No.", "Piecework Code") THEN
                    IF (DataPieceworkForProduction.Type = DataPieceworkForProduction.Type::"Cost Unit") THEN
                        ERROR(Text002);

                UpdatePrices;
            END;


        }
        field(1002; "Sale Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Cost Line Currency', ESP = 'Importe Venta';
            Description = 'Importe en la DIVISA del DESCOMPUESTO';
            Editable = false;
            AutoFormatType = 1;


        }
        field(1003; "Sale Price (DR)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unitary Cost (PCY)', ESP = 'Coste unitario directo (DR)';
            Description = 'Q8136: Precio en la divisa reporting del proyecto';
            Editable = false;
            AutoFormatType = 2;


        }
        field(1004; "Sale Amount (DR)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Cost', ESP = 'Coste ppto. (DR)';
            Description = 'Q8136: Importe en la divisa reporting del proyecto';
            Editable = false;
            AutoFormatType = 1;


        }
        field(1023; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';

            trigger OnValidate();
            BEGIN
                UpdatePrices;
            END;


        }
        field(1024; "Currency Date"; Date)
        {


            AccessByPermission = TableData 4 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Date', ESP = 'Fecha divisa';

            trigger OnValidate();
            BEGIN
                UpdatePrices;
            END;


        }
        field(1025; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(1030; "Contract Price (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Contract Price', ESP = 'Precio contrato (DL)';
            Description = 'Precio de contrato en DL';


        }
        field(1031; "Contract Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio Contrato';
            Description = 'Precio de contrato en la divisa de la linea';


        }
        field(1032; "Contract Price (DR)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unitary Cost (PCY)', ESP = 'Precio Contrato (DR)';
            Description = 'Precio de contrato en DR';
            Editable = false;
            AutoFormatType = 2;


        }
    }
    keys
    {
        key(key1; "Piecework Code", "Job No.")
        {
            SumIndexFields = "Sale Price (LCY)";
        }
    }
    fieldgroups
    {
    }

    var
        //       DataPieceworkForProduction@7001100 :
        DataPieceworkForProduction: Record 7207386;
        //       Text000@1100286004 :
        Text000: TextConst ESP = 'No puede usar trabajadores externos para un descompuesto.';
        //       Text001@7001101 :
        Text001: TextConst ENU = 'You can not allocate a decomposed unit of work / cost of greater', ESP = 'No se puede asignar un descompuesto a una unidad de obra/coste de mayor';
        //       DataCostByPieceworkCert@1100286001 :
        DataCostByPieceworkCert: Record 7207340;
        //       Currency@7001102 :
        Currency: Record 4;
        //       Job@7001103 :
        Job: Record 167;
        //       GLAccount@7001105 :
        GLAccount: Record 15;
        //       Resource@7001106 :
        Resource: Record 156;
        //       UnitaryCostByJob@7001107 :
        UnitaryCostByJob: Record 7207439;
        //       Text003@7001108 :
        Text003: TextConst ENU = 'There is no cost determination for the selected bill of item', ESP = 'No existe determinaci�n de costes para el descompuesto seleccionado';
        //       ResourceCost@7001109 :
        ResourceCost: Record 202;
        //       Item@7001112 :
        Item: Record 27;
        //       StockkeepingUnit@7001113 :
        StockkeepingUnit: Record 5700;
        //       InventoryPostingSetup@7001114 :
        InventoryPostingSetup: Record 5813;
        //       ResourceGroup@7001115 :
        ResourceGroup: Record 152;
        //       Text002@7001118 :
        Text002: TextConst ENU = 'In indirect costs other than current costs, the cost can only be 0 if the item does not apply or 1 if applicable', ESP = 'No puede usar descompuestos de venta para unidades de indirecto';
        //       ItemUnitofMeasure@7001119 :
        ItemUnitofMeasure: Record 5404;
        //       Text004@7001121 :
        Text004: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
        //       JobCurrencyExchangeFunction@1100286006 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       FunctionQB@1100286005 :
        FunctionQB: Codeunit 7207272;
        //       CurrencyDate@1100286000 :
        CurrencyDate: Date;
        //       AssignedAmount@1100286002 :
        AssignedAmount: Decimal;
        //       CurrencyFactor@1100286008 :
        CurrencyFactor: Decimal;
        //       Precio@1100286003 :
        Precio: Decimal;



    trigger OnInsert();
    begin
        if DataPieceworkForProduction.GET("Job No.", "Piecework Code") then
            if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then
                ERROR(Text001);

        UpdatePiecework(0);
    end;

    trigger OnModify();
    begin
        UpdatePiecework(1);
    end;

    trigger OnDelete();
    begin
        UpdatePiecework(2);
    end;



    LOCAL procedure CheckClosed()
    var
        //       Text020@7001100 :
        Text020: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
    begin
        Job.JobStatus("Job No.");
    end;

    LOCAL procedure UpdatePrices()
    begin
        //Calcula los precios en otras divisas
        Job.GET("Job No.");

        JobCurrencyExchangeFunction.CalculateCurrencyValue("Job No.", "Sale Price", "Currency Code", '', "Currency Date", 0, AssignedAmount, CurrencyFactor);
        "Sale Price (LCY)" := AssignedAmount;
        "Currency Factor" := CurrencyFactor;

        JobCurrencyExchangeFunction.CalculateCurrencyValue("Job No.", "Sale Price", "Currency Code", Job."Aditional Currency", "Currency Date", 0, AssignedAmount, CurrencyFactor);
        "Sale Price (DR)" := AssignedAmount;

        UpdateTotals;
    end;

    LOCAL procedure UpdateTotals()
    begin
        //Calcula los importes totales
        Currency.InitRoundingPrecision;

        VALIDATE("Sale Amount (LCY)", ROUND(("Performance By Piecework" * "Sale Price (LCY)"), Currency."Unit-Amount Rounding Precision"));
        VALIDATE("Sale Amount", ROUND(("Performance By Piecework" * "Sale Price"), Currency."Unit-Amount Rounding Precision"));
        VALIDATE("Sale Amount (DR)", ROUND(("Performance By Piecework" * "Sale Price (DR)"), Currency."Unit-Amount Rounding Precision"));
    end;

    //     LOCAL procedure UpdatePiecework (pType@1100286000 :
    LOCAL procedure UpdatePiecework(pType: Option "Insert","Modify","Delet")
    begin
        if (not DataPieceworkForProduction.GET("Job No.", "Piecework Code")) then
            exit;

        if (pType = pType::Insert) then  //Todav�a no lo he dado de alta
            Precio := "Sale Amount"
        else
            Precio := 0;

        DataCostByPieceworkCert.RESET;
        DataCostByPieceworkCert.SETRANGE("Job No.", "Job No.");
        DataCostByPieceworkCert.SETRANGE("Piecework Code", "Piecework Code");
        DataCostByPieceworkCert.SETRANGE("No. Record", "No. Record");
        if (DataCostByPieceworkCert.FINDSET(FALSE)) then
            repeat
                if (pType = pType::Modify) and (DataCostByPieceworkCert."Line Type" = "Line Type") and (DataCostByPieceworkCert."No." = "No.") then //Si estoy modificando uso los datos de la l�nea
                    Precio += "Sale Amount"
                else
                    Precio += DataCostByPieceworkCert."Sale Amount";
            until (DataCostByPieceworkCert.NEXT = 0);

        DataPieceworkForProduction.VALIDATE("Contract Price", Precio);
        DataPieceworkForProduction.MODIFY;
    end;

    /*begin
    //{
//      QB 1.06.09 - JAV 17/08/20: - Nueva tabla para descompuestos de venta
//      Q18970 AML 31/05/23 A�adido campo No Orden y a�adido a claver Primaria
//    }
    end.
  */
}







