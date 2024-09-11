table 7207387 "Data Cost By Piecework"
{


    CaptionML = ENU = 'Data Cost By JU', ESP = 'Datos coste por UO';
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
        field(2; "Cost Type"; Enum "Purchase Line Type")
        {
            // OptionMembers = "Account","Resource","Resource Group","Item","Posting U.";

            CaptionML = ENU = 'Cost Type', ESP = 'Tipo coste';
            //OptionCaptionML = ENU = 'Account,Resource,Resource Group,Item,Posting U.', ESP = 'Cuenta,Recurso,Familia,Producto,U. Auxiliar';


            trigger OnValidate();
            BEGIN
                IF ("Cost Type" = "Cost Type"::"Posting U.") AND ("Assistant U. Code" <> '') THEN
                    ERROR(Text000, FIELDCAPTION("Cost Type"), FORMAT("Cost Type"::"Posting U."), FIELDCAPTION("Assistant U. Code"),
                      FORMAT("Assistant U. Code"));

                CheckClosed;
            END;


        }
        field(3; "No."; Code[20])
        {
            TableRelation = IF ("Cost Type" = CONST("Account")) "G/L Account" ELSE IF ("Cost Type" = CONST("Resource")) "Resource" ELSE IF ("Cost Type" = CONST("Resource Group")) "Resource Group" ELSE IF ("Cost Type" = CONST("Item")) "Item";


            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'QB 1.06.10 JAV 20/08/20: - No pueden ser trabajadores externos';

            trigger OnValidate();
            BEGIN
                Job.GET("Job No.");
                CASE "Cost Type" OF
                    "Cost Type"::Account:
                        BEGIN
                            GLAccount.GET("No.");
                            Description := GLAccount.Name;
                            IF Job."Budget Status" = Job."Budget Status"::Blocked THEN BEGIN
                                "Direct Unitary Cost (JC)" := 0;
                                "Indirect Unit Cost" := 0;
                                "Budget Cost" := 0;
                            END;
                        END;
                    "Cost Type"::Resource:
                        BEGIN
                            Resource.GET("No.");
                            IF (Resource.Type = Resource.Type::ExternalWorker) THEN
                                ERROR(Text006);
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

                            IF Job."Budget Status" = Job."Budget Status"::Blocked THEN BEGIN
                                "Direct Unitary Cost (JC)" := 0;
                                "Indirect Unit Cost" := 0;
                                "Budget Cost" := 0;
                            END ELSE BEGIN
                                IF Job."Use Unit Price Ratio" THEN BEGIN
                                    IF Resource.Type <> Resource.Type::Subcontracting THEN BEGIN
                                        UnitaryCostByJob.SETRANGE("Job No.", "Job No.");
                                        UnitaryCostByJob.SETRANGE("No.", "No.");
                                        IF UnitaryCostByJob.FINDFIRST THEN
                                            VALIDATE("Direct Unitary Cost (JC)", UnitaryCostByJob."Total Cost")
                                    END;
                                END ELSE
                                    VALIDATE("Direct Unitary Cost (JC)", ResourceCost."Direct Unit Cost");
                            END;

                            //JAV 14/08/20: - La actividad sale de la ficha
                            "Activity Code" := Item."QB Activity Code";

                            //JAV 14/08/20: - Si la ficha tiene un CA de directos o de indirectos se usa este, si no el que tenga en el registro de coste del recurso
                            IF (Resource."Cod. C.A. Direct Costs" <> '') THEN
                                VALIDATE("Analytical Concept Direct Cost", Resource."Cod. C.A. Direct Costs")
                            ELSE
                                VALIDATE("Analytical Concept Direct Cost", ResourceCost."C.A. Direct Cost Allocation");
                            IF (Resource."Cod. C.A. Indirect Costs" <> '') THEN
                                VALIDATE("Analytical Concept Direct Cost", Resource."Cod. C.A. Indirect Costs")
                            ELSE
                                VALIDATE("Analytical Concept Ind. Cost", ResourceCost."C.A. Indirect Cost Allocation");
                            IF "Analytical Concept Direct Cost" = '' THEN BEGIN
                                DefaultDimension.SETRANGE("Table ID", DATABASE::Resource);
                                DefaultDimension.SETRANGE("No.", Resource."No.");
                                DefaultDimension.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                                IF DefaultDimension.FINDFIRST THEN
                                    VALIDATE("Analytical Concept Direct Cost", DefaultDimension."Dimension Value Code");
                            END;
                            IF ("Analytical Concept Ind. Cost" = '') AND ("Indirect Unit Cost" <> 0) THEN BEGIN
                                DefaultDimension.SETRANGE("No.", Resource."No.");
                                DefaultDimension.SETRANGE("Dimension Code", FunctionQB.ReturnDimCA);
                                IF DefaultDimension.FINDFIRST THEN
                                    VALIDATE("Analytical Concept Ind. Cost", DefaultDimension."Dimension Value Code");
                            END;
                        END;

                    "Cost Type"::Item:
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
                            IF Job."Budget Status" = Job."Budget Status"::Blocked THEN BEGIN
                                "Direct Unitary Cost (JC)" := 0;
                                "Indirect Unit Cost" := 0;
                                "Budget Cost" := 0;
                            END ELSE BEGIN
                                IF UnitaryCostByJob.FINDFIRST THEN
                                    VALIDATE("Direct Unitary Cost (JC)", UnitaryCostByJob."Total Cost")
                                ELSE
                                    VALIDATE("Direct Unitary Cost (JC)", Item."Unit Cost");
                                VALIDATE("Indirect Unit Cost", 0);
                            END;

                            //JAV 14/08/20 Si tiene un CA en la ficha se usa, si no lo saca del grupo contable de inventario asociado
                            IF (Item."QB Cod. C.A. Direct Costs" <> '') THEN
                                "Analytical Concept Direct Cost" := Item."QB Cod. C.A. Direct Costs"
                            ELSE IF InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group") THEN
                                "Analytical Concept Direct Cost" := InventoryPostingSetup."Analytic Concept";

                            //La actividad sale de la ficha
                            "Activity Code" := Item."QB Activity Code";

                            VALIDATE("Cod. Measure Unit", Item."Base Unit of Measure");
                        END;

                    "Cost Type"::"Resource Group":
                        BEGIN
                            ResourceGroup.GET("No.");
                            Description := ResourceGroup.Name;
                            ResourceCost.GET(ResourceCost.Type::"Group(Resource)", "No.", '');
                            IF Job."Budget Status" = Job."Budget Status"::Blocked THEN BEGIN
                                "Direct Unitary Cost (JC)" := 0;
                                "Indirect Unit Cost" := 0;
                                "Budget Cost" := 0;
                            END ELSE BEGIN
                                VALIDATE("Direct Unitary Cost (JC)", ResourceCost."Direct Unit Cost");
                                VALIDATE("Indirect Unit Cost", ResourceCost."Unit Cost" - ResourceCost."Direct Unit Cost");
                            END;
                            VALIDATE("Analytical Concept Direct Cost", ResourceCost."C.A. Direct Cost Allocation");
                            VALIDATE("Analytical Concept Ind. Cost", ResourceCost."C.A. Indirect Cost Allocation");
                        END;

                    "Cost Type"::"Posting U.":
                        BEGIN
                            DataPieceworkForProduction2.RESET;
                            DataPieceworkForProduction2.SETRANGE(DataPieceworkForProduction2."Job No.", "Job No.");
                            DataPieceworkForProduction2.SETRANGE(DataPieceworkForProduction2."Code U. Posting", "No.");
                            IF DataPieceworkForProduction2.FINDSET THEN BEGIN
                                DataPieceworkForProduction2.CALCFIELDS("Aver. Cost Price Pend. Budget");
                                VALIDATE("Direct Unitary Cost (JC)", DataPieceworkForProduction2."Aver. Cost Price Pend. Budget");
                                Description := DataPieceworkForProduction2.Description;
                                VALIDATE("Piecework Code", DataPieceworkForProduction2."Piecework Code");
                                VALIDATE("Analytical Concept Direct Cost", DataPieceworkForProduction2."Global Dimension 2 Code");
                            END;
                        END;
                END;

                CheckClosed;

                VALIDATE("Activity Code");
            END;


        }
        field(4; "Analytical Concept Direct Cost"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Type" = CONST("Expenses"));


            CaptionML = ENU = 'Analytical Concept Direct Cost', ESP = 'Concep anal�tico coste directo';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateCA("Analytical Concept Direct Cost");
                CheckClosed;
            END;

            trigger OnLookup();
            BEGIN
                IF FunctionQB.LookUpCA("Analytical Concept Direct Cost", FALSE) THEN
                    VALIDATE("Analytical Concept Direct Cost");
            END;


        }
        field(5; "Performance By Piecework"; Decimal)
        {


            CaptionML = ENU = 'Performance By Piecework', ESP = 'Rendimiento por UO';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                //JMMA CAMBIO REDONDEO VALIDATE("Budget Cost",ROUND(("Performance By Piecework"*"Direct Unitary Cost") +
                //                             ("Performance By Piecework"*"Indirect Unit Cost"),Currency."Unit-Amount Rounding Precision"));
                VALIDATE("Budget Cost", ROUND(("Performance By Piecework" * "Direct Unitary Cost (JC)") +
                                             ("Performance By Piecework" * "Indirect Unit Cost"), Currency."Unit-Amount Rounding Precision"));

                CheckClosed;
            END;


        }
        field(6; "Direct Unitary Cost (JC)"; Decimal)
        {


            CaptionML = ENU = 'Direct Unitary Cost JC', ESP = 'Coste unitario directo (DP)';
            Description = 'JAV 25/07/19: - Se hace no editable, se debe cambiar desde el campo "Direct Unit Cost" pues este va en divisa local//30/08/19JMMA SE MODIFICA PORQUE NO FUNCIONA CORRECTAMENTE AL TRAER PRECIARIO';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                //JMMA CAMBIO EN REDONDEO VALIDATE("Budget Cost",ROUND(("Performance By Piecework"*"Direct Unitary Cost") +
                //                             ("Performance By Piecework"*"Indirect Unit Cost"),Currency."Unit-Amount Rounding Precision"));
                VALIDATE("Budget Cost", ROUND(("Performance By Piecework" * "Direct Unitary Cost (JC)") +
                                             ("Performance By Piecework" * "Indirect Unit Cost"), Currency."Unit-Amount Rounding Precision"));

                CheckClosed;
            END;


        }
        field(7; "Budget Cost"; Decimal)
        {


            CaptionML = ENU = 'Budget Cost', ESP = 'Importe Coste ppto.';
            Description = 'JAV 25/07/19: - Se cambia el caption para indicar que es el Importe';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                IF ("Direct Unitary Cost (JC)" <> xRec."Direct Unitary Cost (JC)") OR
                   ("Indirect Unit Cost" <> xRec."Indirect Unit Cost") THEN BEGIN
                    CLEAR(Job);
                    Job.JobStatus("Job No.");
                END;

                IF DataPieceworkForProduction.GET("Job No.", "Piecework Code") THEN BEGIN
                    IF (DataPieceworkForProduction.Type = DataPieceworkForProduction.Type::"Cost Unit") THEN BEGIN
                        IF DataPieceworkForProduction."Subtype Cost" <> DataPieceworkForProduction."Subtype Cost"::"Current Expenses" THEN BEGIN
                            IF ("Budget Cost" <> 1) AND ("Budget Cost" <> 0) THEN
                                ERROR(Text002);
                        END;
                    END;
                END;

                IF MODIFY THEN BEGIN
                    IF DataPieceworkForProduction.GET("Job No.", "Piecework Code") THEN BEGIN
                        DataPieceworkForProduction.VALIDATE("% Of Margin");
                        DataPieceworkForProduction.MODIFY;
                    END;
                END;
            END;


        }
        field(8; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
            Editable = false;


        }
        field(9; "Cod. Measure Unit"; Code[10])
        {
            TableRelation = IF ("Cost Type" = CONST("Item")) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No.")) ELSE IF ("Cost Type" = CONST("Resource")) "Resource Unit of Measure"."Code" WHERE("Resource No." = FIELD("No.")) ELSE
            "Unit of Measure";


            CaptionML = ENU = 'Cod. Measure Unit', ESP = 'Unidad medida U.O.';
            Description = 'JAV 25/07/19: - Se cambia el caption para indicar que es el de la Unidad de Obra';

            trigger OnValidate();
            BEGIN
                Job.GET("Job No.");
                CASE "Cost Type" OF
                    "Cost Type"::Resource:
                        BEGIN
                            Resource.GET("No.");
                            IF "Cod. Measure Unit" <> xRec."Cod. Measure Unit" THEN BEGIN
                                VALIDATE("Direct Unitary Cost (JC)", 0);
                                VALIDATE("Indirect Unit Cost", 0);
                            END;
                        END;
                    "Cost Type"::Item:
                        BEGIN
                            ItemUnitofMeasure.GET("No.", "Cod. Measure Unit");
                            Item.GET("No.");

                            UnitaryCostByJob.SETRANGE("Job No.", "Job No.");
                            UnitaryCostByJob.SETRANGE("No.", "No.");
                            IF NOT UnitaryCostByJob.FINDFIRST THEN BEGIN
                                StockkeepingUnit.SETRANGE("Location Code", Job."Job Location");
                                StockkeepingUnit.SETRANGE("Item No.", "No.");
                                IF StockkeepingUnit.FINDFIRST THEN BEGIN
                                    VALIDATE("Direct Unitary Cost (JC)", StockkeepingUnit."Unit Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                                END ELSE BEGIN
                                    VALIDATE("Direct Unitary Cost (JC)", Item."Unit Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                                END;
                            END ELSE
                                VALIDATE("Direct Unitary Cost (JC)", UnitaryCostByJob."Total Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                        END;
                END;

                CheckClosed;
            END;


        }
        field(10; "Analytical Concept Ind. Cost"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Analytical Concept Ind. Cost', ESP = 'Concep anal�tico coste indirec';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateCA("Analytical Concept Ind. Cost");

                CheckClosed;
            END;

            trigger OnLookup();
            BEGIN
                IF FunctionQB.LookUpCA("Analytical Concept Ind. Cost", FALSE) THEN
                    VALIDATE("Analytical Concept Ind. Cost");
            END;


        }
        field(11; "Indirect Unit Cost"; Decimal)
        {


            CaptionML = ENU = 'Indirect Unit Cost', ESP = 'Coste unitario indirecto';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
                VALIDATE("Budget Cost", ROUND(("Performance By Piecework" * "Direct Unitary Cost (JC)") +
                                             ("Performance By Piecework" * "Indirect Unit Cost"), Currency."Unit-Amount Rounding Precision"));
            END;


        }
        field(12; "New Amount By Piec(Prox Reest)"; Decimal)
        {


            CaptionML = ENU = 'New Amount By Piec(Prox Reest)', ESP = 'Nueva Cant por UO(Prox Reest)';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                VALIDATE("Budget Cost", ROUND(("Performance By Piecework" * "Direct Unitary Cost (JC)") +
                                             ("Performance By Piecework" * "Indirect Unit Cost"), Currency."Unit-Amount Rounding Precision"));
            END;


        }
        field(13; "New Unit Cost (Prox Reest)"; Decimal)
        {


            CaptionML = ENU = 'New Unit Cost (Prox Reest)', ESP = 'Nuevo Coste Unidad  (Prox Reest)';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                VALIDATE("Budget Cost", ROUND(("Performance By Piecework" * "Direct Unitary Cost (JC)") +
                                             ("Performance By Piecework" * "Indirect Unit Cost"), Currency."Unit-Amount Rounding Precision"));
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
        field(16; "Cod. Budget"; Code[20])
        {
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Cod. Budget', ESP = 'C�d. Presupuesto';
            Editable = false;


        }
        field(17; "Filter Date"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Filter Date', ESP = 'Filtro fecha';


        }
        field(18; "Measure Product Exec."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                      "Type" = CONST("Item"),
                                                                                                      "No." = FIELD("No."),
                                                                                                      "Piecework No." = FIELD("Piecework Code"),
                                                                                                      "Entry Type" = CONST("Usage"),
                                                                                                      "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Measure Product Exec.', ESP = 'Med. ejec. producto';


        }
        field(19; "Measure Resource Exec."; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Quantity" WHERE("Job No." = FIELD("Job No."),
                                                                                                      "Type" = FILTER(<> "Item"),
                                                                                                      "No." = FIELD("No."),
                                                                                                      "Piecework No." = FIELD("Piecework Code"),
                                                                                                      "Entry Type" = CONST("Usage"),
                                                                                                      "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Measure Resource Exec.', ESP = 'Med. ejec. recurso';


        }
        field(20; "Product Exec. Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Type" = CONST("Item"),
                                                                                                                "No." = FIELD("No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Entry Type" = CONST("Usage"),
                                                                                                                "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Product Exec. Cost', ESP = 'Coste. ejec. producto';
            AutoFormatType = 1;


        }
        field(21; "Resource Exec. Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                                                "Type" = FILTER(<> "Item"),
                                                                                                                "No." = FIELD("No."),
                                                                                                                "Piecework No." = FIELD("Piecework Code"),
                                                                                                                "Entry Type" = CONST("Usage"),
                                                                                                                "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Resource Exec. Cost', ESP = 'Coste. ejec. recurso';
            AutoFormatType = 1;


        }
        field(22; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripción';

            trigger OnValidate();
            BEGIN
                CheckClosed;
            END;


        }
        field(23; "Assistant U. Code"; Code[20])
        {
            CaptionML = ENU = 'Assistant U. Code', ESP = 'C�d. U. Auxiliar';


        }
        field(24; "Redetermination Increment"; Decimal)
        {
            CaptionML = ENU = 'Redetermination Increment', ESP = 'Incremento redeterminaci�n';


        }
        field(25; "Applied Index"; Decimal)
        {
            CaptionML = ENU = 'Applied Index', ESP = '�ndice aplicado';


        }
        field(26; "Sale Price Redetermined"; Decimal)
        {
            CaptionML = ENU = 'Sale Price Redetermined', ESP = 'Precio venta redeterminado';


        }
        field(27; "Sale Price (Base)"; Decimal)
        {
            CaptionML = ENU = 'Sale Price (Base)', ESP = 'Precio venta (base)';


        }
        field(28; "Contract Price"; Decimal)
        {
            CaptionML = ENU = 'Contract Price', ESP = 'Precio contrato';


        }
        field(29; "Budget Quantity"; Decimal)
        {
            CaptionML = ENU = 'Budget Quantity', ESP = 'Cantidad ppto.';
            Editable = false;


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
        field(31; "Subcontrating"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.02 - Si se ha modificado por subcontrataci�n';


        }
        field(32; "Use"; Option)
        {
            OptionMembers = "Cost","Sales";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Uso';
            OptionCaptionML = ENU = 'Cost,Sales', ESP = 'Coste,Venta';

            Description = 'QB 1.06.07 - JAV 24/07/20: - Si se usa en coste o en venta';


        }
        field(33; "QB Framework Contr. No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Contrato Marco';
            Description = 'QB 1.06.20 - N� Contrato Marco';
            Editable = false;


        }
        field(34; "QB Framework Contr. Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� L�nea del Contrato Marco';
            Description = 'QB 1.08.18 - N� de l�nea del Contrato Marco';
            Editable = false;


        }
        field(40; "Order No."; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Orden';
            Description = 'Q18970 AML Campo A�adido Para poder importar los productos repetidos de un preciario';


        }
        field(80; "Activity Code"; Code[20])
        {
            TableRelation = "Activity QB";


            CaptionML = ENU = 'Activity Code', ESP = 'C�d. actividad';
            Description = 'QB 1.01 - Para guardarlo desde el diario de necesidades';

            trigger OnValidate();
            BEGIN
                IF ("Activity Code" = '') THEN BEGIN
                    CASE "Cost Type" OF
                        "Cost Type"::Resource:
                            BEGIN
                                IF Resource.GET("No.") THEN
                                    "Activity Code" := Resource."Activity Code";
                            END;
                        "Cost Type"::Item:
                            BEGIN
                                IF Item.GET("No.") THEN
                                    "Activity Code" := "Activity Code";
                            END;
                    END;
                END;
            END;


        }
        field(1000; "Direc Unit Cost"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Coste Unitario';
            Description = 'DIVISA DESCOMPUESTO';

            trigger OnValidate();
            BEGIN
                IF ("Direc Unit Cost" <> xRec."Direc Unit Cost") THEN BEGIN
                    UpdateCurrencyFactor;
                    UpdateUnitCost;
                    //JAV 13/11/20: - QB 1.07.05 Si el precio no es cero y antes tampoco era cero, es que ha cambiado el precio y debo preguntar si desea cambiarlo en todas las U.O.
                    IF ("Direc Unit Cost" <> 0) AND (xRec."Direc Unit Cost" <> 0) THEN
                        ChangeAllPrices;
                END;
            END;


        }
        field(1001; "Indirect Unit Cost Currency"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Indirect Unit Cost Line Currency', ESP = 'Coste unitario indirecto en divisa l�nea';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                //GEN004-01 16/04/19 JAV: Cambios en los campos de divisas. No duplicar c�digo
                UpdateBudgetCost;
            END;


        }
        field(1002; "Budget Cost Currency"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Cost Line Currency', ESP = 'Coste ppto. divisa l�nea';
            Editable = false;
            AutoFormatType = 1;


        }
        field(1003; "Direct Unitary Cost (DR)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unitary Cost (PCY)', ESP = 'Coste unitario directo (DR)';
            Description = 'Q8136: Precio en la divisa reporting del proyecto';
            Editable = false;
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                //GEN004-01 16/04/19 JAV: Cambios en los campos de divisas. No duplicar c�digo
                UpdateBudgetCost;
            END;


        }
        field(1004; "Budget Cost (DR)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Cost', ESP = 'Coste ppto. (DR)';
            Description = 'Q8136';
            Editable = false;
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                IF ("Direct Unitary Cost (JC)" <> xRec."Direct Unitary Cost (JC)") OR
                   ("Indirect Unit Cost" <> xRec."Indirect Unit Cost") THEN BEGIN
                    CLEAR(Job);
                    Job.JobStatus("Job No.");
                END;

                IF DataPieceworkForProduction.GET("Job No.", "Piecework Code") THEN BEGIN
                    IF (DataPieceworkForProduction.Type = DataPieceworkForProduction.Type::"Cost Unit") THEN BEGIN
                        IF DataPieceworkForProduction."Subtype Cost" <> DataPieceworkForProduction."Subtype Cost"::"Current Expenses" THEN BEGIN
                            IF ("Budget Cost" <> 1) AND ("Budget Cost" <> 0) THEN
                                ERROR(Text002);
                        END;
                    END;
                END;

                IF MODIFY THEN BEGIN
                    IF DataPieceworkForProduction.GET("Job No.", "Piecework Code") THEN BEGIN
                        DataPieceworkForProduction.VALIDATE("% Of Margin");
                        DataPieceworkForProduction.MODIFY;
                    END;
                END;

                /////////////////////////// VALIDATE("Direc Unitary Cost Currency", 0); //GEN004-01 zzz
            END;


        }
        field(1005; "Indirect Unit Cost (DR)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Indirect Unit Cost', ESP = 'Coste unitario indirecto (DR)';
            Description = 'Q8136';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                //GEN004-01 16/04/19 JAV: Cambios en los campos de divisas. No duplicar c�digo
                UpdateBudgetCost;
            END;


        }
        field(1023; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';

            trigger OnValidate();
            begin
                //{
                //                                                                ValidateModification(xRec."Currency Code" <> "Currency Code");
                //
                //                                                                UpdateCurrencyFactor;
                //                                                                UpdateAllAmounts;
                //                                                                }
                UpdateCurrencyFactor;
                UpdateUnitCost;
            END;


        }
        field(1024; "Currency Date"; Date)
        {


            AccessByPermission = TableData 4 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Date', ESP = 'Fecha divisa';

            trigger OnValidate();
            BEGIN

                UpdateCurrencyFactor;
                UpdateUnitCost;
            END;


        }
        field(1025; "Currency Factor"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;

            trigger OnValidate();
            begin
                //{
                //
                //                                                                ValidateModification(xRec."Currency Factor" <> "Currency Factor");
                //
                //                                                                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                //                                                                  FIELDERROR("Currency Factor",STRSUBSTNO(CurrencyFactorErr,FIELDCAPTION("Currency Code")));
                //                                                                UpdateAllAmounts;
                //                                                                }
            END;


        }
        field(1100; "Qty. In Contract"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Quantity" WHERE("Document Type" = FILTER('Order' | 'Blanket Order'),
                                                                                                   "Type" = FILTER('Item' | 'Resource'),
                                                                                                   "No." = FIELD("No."),
                                                                                                   "Job No." = FIELD("Job No."),
                                                                                                   "Piecework No." = FIELD("Piecework Code")));
            CaptionML = ENU = 'Qty. in Contract', ESP = 'Cantidad en Contratos';
            Editable = false;


        }
        field(1102; "Qty. Invoiced"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Quantity" WHERE("Type" = FILTER('Item' | 'Resource'),
                                                                                                      "No." = FIELD("No."),
                                                                                                      "Job No." = FIELD("Job No."),
                                                                                                      "Piecework No." = FIELD("Piecework Code"),
                                                                                                      "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Qty. Invoiced', ESP = 'Cantidad Facturada';
            Editable = false;


        }
        field(1103; "Amount In Contract"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount" WHERE("Document Type" = FILTER('Order' | 'Blanket Order'),
                                                                                                 "Type" = FILTER('Item' | 'Resource'),
                                                                                                 "No." = FIELD("No."),
                                                                                                 "Job No." = FIELD("Job No."),
                                                                                                 "Piecework No." = FIELD("Piecework Code")));
            CaptionML = ENU = 'Amount In Contract', ESP = 'Importe en Contratos';
            Editable = false;


        }
        field(1104; "Amount Invoiced"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Amount" WHERE("Type" = FILTER('Item' | 'Resource'),
                                                                                                    "No." = FIELD("No."),
                                                                                                    "Job No." = FIELD("Job No."),
                                                                                                    "Piecework No." = FIELD("Piecework Code"),
                                                                                                    "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Amount Invoiced', ESP = 'Importe facturado';


        }
        field(1105; "Qty. CreditMemo"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Cr. Memo Line"."Quantity" WHERE("Type" = FILTER('Item' | 'Resource'),
                                                                                                          "No." = FIELD("No."),
                                                                                                          "Job No." = FIELD("Job No."),
                                                                                                          "Piecework No." = FIELD("Piecework Code"),
                                                                                                          "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Qty. CreditMemo', ESP = 'Cantidad Abonos';


        }
        field(1106; "Amount CreditMemo"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Cr. Memo Line"."Amount" WHERE("Type" = FILTER('Item' | 'Resource'),
                                                                                                        "No." = FIELD("No."),
                                                                                                        "Job No." = FIELD("Job No."),
                                                                                                        "Piecework No." = FIELD("Piecework Code"),
                                                                                                        "Posting Date" = FIELD("Filter Date")));
            CaptionML = ENU = 'Amount CreditMemo', ESP = 'Importe Abonos';


        }
        field(50000; "Quantity"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad';
            Description = 'QCPM_GAP07';

            trigger OnValidate();
            BEGIN
                CalcPerformance; //QCPM_GAP07
            END;


        }
        field(50001; "Qt. Measure Unit"; Code[10])
        {
            TableRelation = "Unit of Measure";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Measure Unit', ESP = 'Unidad medida cantidad';
            Description = 'QCPM_GAP07';

            trigger OnValidate();
            BEGIN
                Job.GET("Job No.");
                CASE "Cost Type" OF
                    "Cost Type"::Resource:
                        BEGIN
                            Resource.GET("No.");
                            IF "Cod. Measure Unit" <> xRec."Cod. Measure Unit" THEN BEGIN
                                VALIDATE("Direct Unitary Cost (JC)", 0);
                                VALIDATE("Indirect Unit Cost", 0);
                            END;
                        END;
                    "Cost Type"::Item:
                        BEGIN
                            ItemUnitofMeasure.GET("No.", "Cod. Measure Unit");
                            Item.GET("No.");

                            UnitaryCostByJob.SETRANGE("Job No.", "Job No.");
                            UnitaryCostByJob.SETRANGE("No.", "No.");
                            IF NOT UnitaryCostByJob.FINDFIRST THEN BEGIN
                                StockkeepingUnit.SETRANGE("Location Code", Job."Job Location");
                                StockkeepingUnit.SETRANGE("Item No.", "No.");
                                IF StockkeepingUnit.FINDFIRST THEN BEGIN
                                    VALIDATE("Direct Unitary Cost (JC)", StockkeepingUnit."Unit Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                                END ELSE BEGIN
                                    VALIDATE("Direct Unitary Cost (JC)", Item."Unit Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                                END;
                            END ELSE
                                VALIDATE("Direct Unitary Cost (JC)", UnitaryCostByJob."Total Cost" * ItemUnitofMeasure."Qty. per Unit of Measure");
                        END;
                END;

                CheckClosed;
            END;


        }
        field(50002; "Performance"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Performance', ESP = 'Rendimiento';
            Description = 'QCPM_GAP07';

            trigger OnValidate();
            BEGIN
                CalcPerformance; //QCPM_GAP07
            END;


        }
        field(50003; "Conversion Factor"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Conversion Factor', ESP = 'Factor conversi�n';
            Description = 'QCPM_GAP07';

            trigger OnValidate();
            BEGIN
                CalcPerformance; //QCPM_GAP07
            END;


        }
        field(50004; "Vendor"; Code[20])
        {
            TableRelation = "Vendor"."No.";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor', ESP = 'Proveedor';
            Description = 'QCPM_GAP06';

            trigger OnValidate();
            BEGIN
                //JAV 17/10/19: - Se a�ade el nombre del proveedor
                CALCFIELDS("Vendor Name");
            END;


        }
        field(50005; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor")));
            CaptionML = ESP = 'Nombre';
            Description = 'JAV 17/10/19: - Se a�ade el nombre del proveedor';
            Editable = false;


        }
        field(50006; "In Quote Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio Contrato';
            Description = 'JAV 05/12/19: - Si se ha incluido ya en un contrato, Precio del contrato';
            Editable = false;


        }
        field(50010; "In Quote"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'En Contrato';
            Description = 'JAV 05/12/19: - Si se ha incluido ya en un contrato';
            Editable = false;


        }
    }
    keys
    {
        key(key1;"Job No.","Piecework Code","Cod. Budget","Cost Type","No.","Order No.")
        {
            SumIndexFields="Budget Cost";
            Clustered=true;
        }
        key(key2; "Piecework Code", "Job No.")
        {
            SumIndexFields = "Direct Unitary Cost (JC)";
        }
        key(key3; "Job No.", "Piecework Code", "Cost Type", "No.")
        {
            ;
        }
        key(key4; "Job No.", "Piecework Code", "Analytical Concept Direct Cost", "Cod. Budget", "Assistant U. Code")
        {
            SumIndexFields = "Budget Cost";
        }

    }
    fieldgroups
    {
    }

    var
        //       DataPieceworkForProduction@7001100 :
        DataPieceworkForProduction: Record 7207386;
        //       Currency@7001102 :
        Currency: Record 4;
        //       Job@7001103 :
        Job: Record 167;
        //       Text000@7001104 :
        Text000: TextConst ENU = '%1 can not count %2 when %3 = %4.', ESP = '%1 no puede valer %2 cuando %3=%4.';
        //       GLAccount@7001105 :
        GLAccount: Record 15;
        //       Resource@7001106 :
        Resource: Record 156;
        //       UnitaryCostByJob@7001107 :
        UnitaryCostByJob: Record 7207439;
        //       Text001@1100286006 :
        Text001: TextConst ENU = 'You can not allocate a decomposed unit of work / cost of greater', ESP = 'No se puede asignar un descompuesto a una unidad de obra/coste de mayor';
        //       ResourceCost@7001109 :
        ResourceCost: Record 202;
        //       FunctionQB@7001110 :
        FunctionQB: Codeunit 7207272;
        //       DefaultDimension@7001111 :
        DefaultDimension: Record 352;
        //       Item@7001112 :
        Item: Record 27;
        //       StockkeepingUnit@7001113 :
        StockkeepingUnit: Record 5700;
        //       InventoryPostingSetup@7001114 :
        InventoryPostingSetup: Record 5813;
        //       ResourceGroup@7001115 :
        ResourceGroup: Record 152;
        //       DataPieceworkForProduction2@7001116 :
        DataPieceworkForProduction2: Record 7207386;
        //       CCA@7001117 :
        CCA: Code[20];
        //       Text002@7001118 :
        Text002: TextConst ENU = 'In indirect costs other than current costs, the cost can only be 0 if the item does not apply or 1 if applicable', ESP = 'En los indirectos que no sean gastos correientes el coste solo puede ser 0 si la partida no aplica o 1 en caso de aplicar';
        //       ItemUnitofMeasure@7001119 :
        ItemUnitofMeasure: Record 5404;
        //       JobBudget@7001120 :
        JobBudget: Record 7207407;
        //       Text003@1100286007 :
        Text003: TextConst ENU = 'There is no cost determination for the selected bill of item', ESP = 'No existe determinaci�n de costes para el descompuesto seleccionado';
        //       Text004@7001121 :
        Text004: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
        //       CurrExchRate@1100286001 :
        CurrExchRate: Record 330;
        //       CurrencyDate@1100286000 :
        CurrencyDate: Date;
        //       vCodeBudget@1100286002 :
        vCodeBudget: Code[20];
        //       JobCurExchange@1100286003 :
        JobCurExchange: Codeunit 7207332;
        //       Text005@1100286004 :
        Text005: TextConst ESP = 'Ha cambiado el precio �desea cambiarlo en los otros %1 descompuestos iguales a este del proyecto?';
        //       OnChange@1100286005 :
        OnChange: Boolean;
        //       Text006@1100286008 :
        Text006: TextConst ESP = 'No puede usar trabajadores externos en los descompuestos.';



    trigger OnInsert();
    begin
        if DataPieceworkForProduction.GET("Job No.", "Piecework Code") then begin
            if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Heading then
                ERROR(Text001);
            if DataPieceworkForProduction.Type = DataPieceworkForProduction.Type::Piecework then begin
                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
                if DataPieceworkForProduction."% Of Margin" <> 0 then
                    DataPieceworkForProduction."Initial Produc. Price" := ROUND((DataPieceworkForProduction."Aver. Cost Price Pend. Budget" + "Budget Cost")
                                                      * (1 + DataPieceworkForProduction."% Of Margin" / 100), Currency."Unit-Amount Rounding Precision")
                else begin
                    DataPieceworkForProduction."Initial Produc. Price" := ROUND(DataPieceworkForProduction."Aver. Cost Price Pend. Budget" + "Budget Cost",
                                                            Currency."Unit-Amount Rounding Precision");
                end;
                if DataPieceworkForProduction."Initial Produc. Price" <> 0 then
                    DataPieceworkForProduction."Gross Profit Percentage" :=
                         ROUND(((DataPieceworkForProduction."Initial Produc. Price" - (DataPieceworkForProduction."Aver. Cost Price Pend. Budget" + "Budget Cost"))
                              / DataPieceworkForProduction."Initial Produc. Price") * 100, Currency."Unit-Amount Rounding Precision")
                else
                    DataPieceworkForProduction."Gross Profit Percentage" := 0;
            end else begin
                DataPieceworkForProduction."% Of Margin" := 0;
                DataPieceworkForProduction."Initial Produc. Price" := 0;
            end;
            DataPieceworkForProduction.MODIFY;
        end;
    end;

    trigger OnModify();
    begin
        if ("Direct Unitary Cost (JC)" <> xRec."Direct Unitary Cost (JC)") or ("Indirect Unit Cost" <> xRec."Indirect Unit Cost") then
            Job.JobStatus("Job No.");
    end;

    trigger OnDelete();
    begin
        if ("Direct Unitary Cost (JC)" <> 0) or ("Indirect Unit Cost" <> 0) then
            Job.JobStatus("Job No.");

        VALIDATE("Performance By Piecework", 0); //JAV 26/02/21: QB 1.08.16 Ponemos la cantidad a cero para que la reste del importe de la unidad de obra
    end;



    procedure BillOfItemsDescription(): Text[50];
    var
        //       GLAccount@1100231000 :
        GLAccount: Record 15;
        //       Resource@1100231001 :
        Resource: Record 156;
        //       Item@1100231002 :
        Item: Record 27;
        //       ResourceGroup@1100231003 :
        ResourceGroup: Record 152;
    begin
        CASE "Cost Type" OF
            "Cost Type"::Account:
                begin
                    if GLAccount.GET("No.") then
                        exit(GLAccount.Name)
                    else
                        exit('');
                end;
            "Cost Type"::Item:
                begin
                    if Item.GET("No.") then
                        exit(Item.Description)
                    else
                        exit('');
                end;
            "Cost Type"::Resource:
                begin
                    if Resource.GET("No.") then
                        exit(Resource.Name)
                    else
                        exit('');
                end;
            "Cost Type"::"Resource Group":
                begin
                    if ResourceGroup.GET("No.") then
                        exit(ResourceGroup.Name)
                    else
                        exit('');
                end;
        end;
    end;

    procedure UnitDescription(): Text[50];
    var
        //       DataJobUnitForProduction@1100251000 :
        DataJobUnitForProduction: Record 7207386;
    begin
        if DataJobUnitForProduction.GET("Job No.", "Piecework Code") then
            exit(DataJobUnitForProduction.Description)
        else
            exit('');
    end;

    procedure CheckClosed()
    var
        //       Text020@7001100 :
        Text020: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
    begin
        JobBudget.RESET;
        JobBudget.SETRANGE("Job No.", "Job No.");
        //QUO 11.02.19 ERROR AL INTRODUCIR PRECIARIO, ESTANDO LA VERSI�N INICIAL CERRADA
        if vCodeBudget <> '' then
            JobBudget.SETRANGE("Cod. Budget", vCodeBudget)
        else
            //FIN QUO 11.02.19
            JobBudget.SETRANGE("Cod. Budget", "Cod. Budget");
        if JobBudget.FINDFIRST then
            if JobBudget.Status = JobBudget.Status::Close then
                ERROR(Text020);
    end;

    procedure UpdateCurrencyFactor()
    begin

        "Currency Factor" := 0;
        CurrencyDate := "Currency Date";
        if Job.GET("Job No.") then
            JobCurExchange.CalculateCurrencyValue("Job No.", "Direc Unit Cost", "Currency Code", Job."Currency Code", CurrencyDate, 0, "Direct Unitary Cost (JC)", "Currency Factor");
    end;

    LOCAL procedure UpdateUnitCost()
    begin

        CurrencyDate := "Currency Date";
        if Job.GET("Job No.") then
            JobCurExchange.CalculateCurrencyValue("Job No.", "Direc Unit Cost", "Currency Code", Job."Currency Code", CurrencyDate, 0, "Direct Unitary Cost (JC)", "Currency Factor");
        VALIDATE("Direct Unitary Cost (JC)");
    end;

    //     procedure CurrentCodeBudget (pCodeBudget@7001100 :
    procedure CurrentCodeBudget(pCodeBudget: Code[20])
    begin
        vCodeBudget := pCodeBudget;
    end;

    procedure UpdateCost()
    var
        //       JobCurrencyExchangeFunction@1100286000 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       AssignedAmount@1100286001 :
        AssignedAmount: Decimal;
        //       CurrencyFactor@1100286002 :
        CurrencyFactor: Decimal;
        //       AssignedAmount_DR@1100286003 :
        AssignedAmount_DR: Decimal;
        //       GeneralLedgerSetup@100000000 :
        GeneralLedgerSetup: Record 98;
    begin
        //GEN004-01: Esta funci�n reemplaza las anteriores
        Job.GET("Job No.");
        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("LCY Code");

        JobCurrencyExchangeFunction.CalculateCurrencyValue("Job No.", "Direc Unit Cost", "Currency Code", Job."Currency Code", "Currency Date", 0, AssignedAmount, CurrencyFactor);
        VALIDATE("Direct Unitary Cost (JC)", AssignedAmount);
        "Currency Factor" := CurrencyFactor;
        //-Q8136
        JobCurrencyExchangeFunction.CalculateCurrencyValue("Job No.", "Direc Unit Cost", "Currency Code", Job."Aditional Currency", "Currency Date", 0, AssignedAmount_DR, CurrencyFactor);
        VALIDATE("Direct Unitary Cost (DR)", AssignedAmount_DR);
        //+Q8136
        UpdateBudgetCost;
    end;

    procedure UpdateCurrencyCode()
    begin
        //GEN004-01 16/04/19 JAV: Cambios en los campos de divisas
        //-PEL: Poder dejar en blanco divisa y fecha divisa.
        // if ("Currency Code" = '') then begin
        //  Job.GET("Job No.");
        //  "Currency Code" := Job."Currency Code";
        // end;
        // if ("Currency Date" = 0D) then
        //  "Currency Date" := TODAY;
        //+PEL
        if ("Currency Code" <> '') then begin  //GEN004-01 06/05/19 PER: Error, si la divisa es blanco (EUR) al traer preciario y al realizar multiples procesos en el aplicativo.
            Currency.GET("Currency Code");
            Currency.InitRoundingPrecision;
        end;
    end;

    LOCAL procedure UpdateBudgetCost()
    begin
        //GEN004-01 16/04/19 JAV: Cambios en los campos de divisas
        UpdateCurrencyCode;
        VALIDATE("Budget Cost", ROUND(("Performance By Piecework" * "Direct Unitary Cost (JC)") +
                                     ("Performance By Piecework" * "Indirect Unit Cost"),
                                     Currency."Unit-Amount Rounding Precision"));

        VALIDATE("Budget Cost Currency", ROUND(("Performance By Piecework" * "Direc Unit Cost") +
                                               ("Performance By Piecework" * "Indirect Unit Cost Currency"),
                                               Currency."Unit-Amount Rounding Precision"));

        //-Q8136
        VALIDATE("Budget Cost (DR)", ROUND(("Performance By Piecework" * "Direct Unitary Cost (DR)") +
                                     ("Performance By Piecework" * "Indirect Unit Cost (DR)"),
                                     Currency."Unit-Amount Rounding Precision"));
    end;

    LOCAL procedure CalcPerformance()
    var
        //       DataPieceworkForProduction@100000001 :
        DataPieceworkForProduction: Record 7207386;
        //       Perf@100000000 :
        Perf: Decimal;
    begin
        //QCPM_GAP07

        if (Quantity = 0) and (Performance = 0) and ("Conversion Factor" = 0) then
            exit;

        Perf := Quantity;

        if Performance <> 0 then
            Perf := Perf * Performance;

        if "Conversion Factor" <> 0 then
            Perf := Perf * "Conversion Factor";

        VALIDATE("Performance By Piecework", Perf);
    end;

    procedure GetMeasurePerformed(): Decimal;
    var
        //       rJob@1000000000 :
        rJob: Record 167;
        //       datapieceworkforprod@1000000001 :
        datapieceworkforprod: Record 7207386;
    begin
        if rJob.GET("Job No.") then begin
            datapieceworkforprod.RESET;
            datapieceworkforprod.SETRANGE("Job No.", "Job No.");
            datapieceworkforprod.SETRANGE("Piecework Code", "Piecework Code");
            datapieceworkforprod.SETFILTER("Budget Filter", rJob."Current Piecework Budget");
            datapieceworkforprod.SETFILTER("Filter Date", '%1..%2', GETRANGEMIN("Filter Date"), GETRANGEMAX("Filter Date"));
            if datapieceworkforprod.FINDFIRST then
                datapieceworkforprod.CALCFIELDS("Total Measurement Production");
            exit(datapieceworkforprod."Total Measurement Production");
        end;
    end;

    procedure GetTotalMeasure(): Decimal;
    var
        //       rJob@1000000000 :
        rJob: Record 167;
        //       datapieceworkforprod@1000000001 :
        datapieceworkforprod: Record 7207386;
    begin
        if rJob.GET("Job No.") then begin
            datapieceworkforprod.RESET;
            datapieceworkforprod.SETRANGE("Job No.", "Job No.");
            datapieceworkforprod.SETRANGE("Piecework Code", "Piecework Code");
            datapieceworkforprod.SETFILTER("Budget Filter", rJob."Current Piecework Budget");
            if datapieceworkforprod.FINDFIRST then
                datapieceworkforprod.CALCFIELDS("Budget Measure");
            exit(datapieceworkforprod."Budget Measure");
        end;
    end;

    procedure GetUnitofMeasure(): Code[10];
    var
        //       rJob@1000000000 :
        rJob: Record 167;
        //       datapieceworkforprod@1000000001 :
        datapieceworkforprod: Record 7207386;
    begin
        if rJob.GET("Job No.") then begin
            datapieceworkforprod.RESET;
            datapieceworkforprod.SETRANGE("Job No.", "Job No.");
            datapieceworkforprod.SETRANGE("Piecework Code", "Piecework Code");
            datapieceworkforprod.SETFILTER("Budget Filter", rJob."Current Piecework Budget");
            if datapieceworkforprod.FINDFIRST then
                exit(datapieceworkforprod."Unit Of Measure");
        end;
    end;

    LOCAL procedure ChangeAllPrices()
    var
        //       DataCostByPiecework@1100286000 :
        DataCostByPiecework: Record 7207387;
    begin
        //JAV 28/10/20: - QB 1.07.01 Cambiar el precio en todas las unidades iguales a la actual en el proyecto y presupuestos actuales
        if (OnChange) then begin
            OnChange := FALSE;
            exit;
        end;

        if ("Direc Unit Cost" = 0) then
            exit;

        DataCostByPiecework.RESET;
        DataCostByPiecework.SETRANGE("Job No.", "Job No.");
        DataCostByPiecework.SETRANGE("Cod. Budget", "Cod. Budget");
        DataCostByPiecework.SETRANGE("Cost Type", "Cost Type");
        DataCostByPiecework.SETRANGE("No.", "No.");
        if (DataCostByPiecework.COUNT > 1) then       //Si solo hay un descompuesto es el actual
            if CONFIRM(Text005, FALSE, DataCostByPiecework.COUNT - 1) then begin
                DataCostByPiecework.FINDSET(TRUE);
                repeat
                    if (DataCostByPiecework.RECORDID <> RECORDID) then begin  //No me cambio a mi mismo
                        DataCostByPiecework.SetOnChange;
                        DataCostByPiecework.VALIDATE("Direc Unit Cost", "Direc Unit Cost");
                        DataCostByPiecework.MODIFY(TRUE);
                    end;
                until (DataCostByPiecework.NEXT = 0);
            end;
    end;

    procedure SetOnChange()
    begin
        OnChange := TRUE;
    end;

    /*begin
    //{
//      JAV 25/07/19:  - Se cambia el caption del campo 7 "Budget Cost" para indicar que es el Importe de coste
//                     - Se hace no editable el campo 6 "Direct Unitary Cost LCY", se debe cambiar desde el campo "Direct Unit Cost" pues este va en divisa local
//      JMMA 30/08/19: - SE anula el cambio anterior PORQUE NO FUNCIONA CORRECTAMENTE AL TRAER PRECIARIO
//      PEL 29/04/19:  - QCPM_GAP07 Nuevos campos y c�lculo de rendimiento
//      JAV 17/10/19:  - Se a�ade el nombre del proveedor
//      QMD 18/09/19:  - KALAM VSTS 7528 GAP018. Coeficiente de paso - A�adir campos
//      QMD 20/09/19:  - KALAM VSTS 7594 GAP014. Descompuestos - Unidades de medida - Informe importaci�n Excel
//      JAV 05/12/19:  - Se a�aden campos para saber si est� en un contrato y el precio del contrato
//      PGM 30/10/19:  - Q8101 Se comenta lo que hab�a y se pasa como par�metro a la funci�n el valor actual para que se pueda posicionar en ese valor al hacer el lookup
//      IMPORTANTE: Esta tabla se ha duplicado en la 7207273 pero solo a nivel de campos, si se altera esta tabla hay que tenerlo en cuenta en la otra
//
//      CPA 29/03/22: Q16867 - Mejora de rendimiento
//          - Nueva clave: Job No.,Piecework Code,Analytical Concept Direct Cost,Cod. Budget,Assistant U. Code
//      Q18970 Q18970.1 AML 31/05/23 A�adido campo No Orden y a�adido a claver Primaria, habr� que evitar los GET.
//      Q20266 AML 09/10/23  Campo Analytical Concept Direct Cost Solo permite CA de tipo expenses.
//    }
    end.
  */
}







