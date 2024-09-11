table 7207273 "Data Cost By Piecework Saved"
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
        field(2; "Cost Type"; Option)
        {
            OptionMembers = "Account","Resource","Resource Group","Item","Posting U.";
            CaptionML = ENU = 'Cost Type', ESP = 'Tipo coste';
            OptionCaptionML = ENU = 'Account,Resource,Resource Group,Item,Posting U.', ESP = 'Cuenta,Recurso,Familia,Producto,U. Auxiliar';



        }
        field(3; "No."; Code[20])
        {
            TableRelation = IF ("Cost Type" = CONST("Account")) "G/L Account" ELSE IF ("Cost Type" = CONST("Resource")) "Resource" ELSE IF ("Cost Type" = CONST("Resource Group")) "Resource Group" ELSE IF ("Cost Type" = CONST("Item")) "Item";
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(4; "Analytical Concept Direct Cost"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'Analytical Concept Direct Cost', ESP = 'Concep anal�tico coste directo';


        }
        field(5; "Performance By Piecework"; Decimal)
        {
            CaptionML = ENU = 'Performance By Piecework', ESP = 'Rendimiento por UO';
            DecimalPlaces = 0 : 6;


        }
        field(6; "Direct Unitary Cost (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Direct Unitary Cost LCY', ESP = 'Coste unitario directo (DL)';
            AutoFormatType = 2;


        }
        field(7; "Budget Cost"; Decimal)
        {
            CaptionML = ENU = 'Budget Cost', ESP = 'Importe Coste ppto.';
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
            TableRelation = IF ("Cost Type" = CONST("Item")) "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("No.")) ELSE IF ("Cost Type" = CONST("Resource")) "Resource Unit of Measure"."Code" WHERE("Resource No." = FIELD("No.")) ELSE
            "Unit of Measure";
            CaptionML = ENU = 'Cod. Measure Unit', ESP = 'Unidad medida U.O.';


        }
        field(10; "Analytical Concept Ind. Cost"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'Analytical Concept Ind. Cost', ESP = 'Concep anal�tico coste indirec';


        }
        field(11; "Indirect Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Indirect Unit Cost', ESP = 'Coste unitario indirecto';
            AutoFormatType = 2;


        }
        field(12; "New Amount By Piec(Prox Reest)"; Decimal)
        {
            CaptionML = ENU = 'New Amount By Piec(Prox Reest)', ESP = 'Nueva Cant por UO(Prox Reest)';
            DecimalPlaces = 0 : 6;


        }
        field(13; "New Unit Cost (Prox Reest)"; Decimal)
        {
            CaptionML = ENU = 'New Unit Cost (Prox Reest)', ESP = 'Nuevo Coste Unidad  (Prox Reest)';
            AutoFormatType = 2;


        }
        field(14; "Code Cost Database"; Code[20])
        {
            TableRelation = "Cost Database";
            CaptionML = ENU = 'Code Cost Database', ESP = 'C�d. preciario';


        }
        field(15; "Unique Code"; Code[30])
        {
            CaptionML = ENU = 'Unique Code', ESP = 'C�digo �nico';


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
            Editable = false;


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
        field(80; "Activity Code"; Code[20])
        {
            TableRelation = "Activity QB";
            CaptionML = ENU = 'Activity Code', ESP = 'C�d. actividad';


        }
        field(124; "No. DP Cost"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Data Cost By Piecework" WHERE("Job No." = FIELD("Job No."),
                                                                                                     "Piecework Code" = FIELD("Piecework Code"),
                                                                                                     "Use" = CONST("Cost")));
            CaptionML = ESP = 'N� Descompuestos coste';
            Description = 'QB 1.06.07 - JAV 24/04/20: - Cuantas l�neas de descompuestos de coste tiene';


        }
        field(125; "No. DP Sale"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Data Cost By Piecework" WHERE("Job No." = FIELD("Job No."),
                                                                                                     "Piecework Code" = FIELD("Piecework Code"),
                                                                                                     "Use" = CONST("Sales")));
            CaptionML = ESP = 'N� Descompuestos venta';
            Description = 'QB 1.06.07 - JAV 24/04/20: - Cuantas l�neas de descompuestos de venta tiene';


        }
        field(1000; "Direc Unit Cost"; Decimal)
        {
            CaptionML = ESP = 'Coste Unitario';


        }
        field(1001; "Indirect Unit Cost Currency"; Decimal)
        {
            CaptionML = ENU = 'Indirect Unit Cost Line Currency', ESP = 'Coste unitario indirecto en divisa l�nea';
            AutoFormatType = 2;


        }
        field(1002; "Budget Cost Currency"; Decimal)
        {
            CaptionML = ENU = 'Budget Cost Line Currency', ESP = 'Coste ppto. divisa l�nea';
            Editable = false;
            AutoFormatType = 1;


        }
        field(1003; "Direct Unitary Cost (DR)"; Decimal)
        {
            CaptionML = ENU = 'Direct Unitary Cost (PCY)', ESP = 'Coste unitario directo (DR)';
            Editable = false;
            AutoFormatType = 2;


        }
        field(1004; "Budget Cost (DR)"; Decimal)
        {
            CaptionML = ENU = 'Budget Cost', ESP = 'Coste ppto. (DR)';
            Editable = false;
            AutoFormatType = 1;


        }
        field(1005; "Indirect Unit Cost (DR)"; Decimal)
        {
            CaptionML = ENU = 'Indirect Unit Cost', ESP = 'Coste unitario indirecto (DR)';
            AutoFormatType = 2;


        }
        field(1023; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(1024; "Currency Date"; Date)
        {
            AccessByPermission = TableData 4 = R;
            CaptionML = ENU = 'Currency Date', ESP = 'Fecha divisa';


        }
        field(1025; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(50000; "Quantity"; Decimal)
        {
            CaptionML = ESP = 'Cantidad';


        }
        field(50001; "Qt. Measure Unit"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Cod. Measure Unit', ESP = 'Unidad medida cantidad';


        }
        field(50002; "Performance"; Decimal)
        {
            CaptionML = ENU = 'Performance', ESP = 'Rendimiento';


        }
        field(50003; "Conversion Factor"; Decimal)
        {
            CaptionML = ENU = 'Conversion Factor', ESP = 'Factor conversi�n';


        }
        field(50004; "Vendor"; Code[20])
        {
            TableRelation = "Vendor"."No.";
            CaptionML = ENU = 'Vendor', ESP = 'Proveedor';


        }
        field(50005; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor"."Name" WHERE("No." = FIELD("Vendor")));
            CaptionML = ESP = 'Nombre';
            Editable = false;


        }
        field(50006; "In Quote Price"; Decimal)
        {
            CaptionML = ESP = 'Precio Contrato';
            Editable = false;


        }
        field(50007; "Expected Hours"; Decimal)
        {
            CaptionML = ENU = 'Expected Hours', ESP = 'Horas previstas';


        }
        field(50008; "Executed Hours"; Decimal)
        {
            CaptionML = ENU = 'Executed Hours', ESP = 'Horas ejecutadas';


        }
        field(50009; "Executed Parties"; Integer)
        {
            CaptionML = ENU = 'Executed Parties', ESP = 'Partes ejecutados';


        }
        field(50010; "In Quote"; Boolean)
        {
            CaptionML = ESP = 'En Contrato';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Piecework Code", "Job No.")
        {
            SumIndexFields = "Direct Unitary Cost (LCY)";
        }
    }
    fieldgroups
    {
    }


    /*begin
    {
      JAV 25/07/19:  - Esta tabla es una copia de la 7207387, para guardar registros que se han modificado y se pueden volver a recuperar
    }
    end.
  */
}







