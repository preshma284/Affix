table 7207287 "Transfers Between Jobs Lines"
{


    CaptionML = ENU = 'Transfers Between Jobs Lines', ESP = 'Lineas de Traspasos entre Proyectos';
    LookupPageID = "Transfers Between Jobs Lines";
    DrillDownPageID = "Transfers Between Jobs Lines";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Documento No.', ESP = 'No. documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. Line';


        }
        field(10; "Document Type"; Option)
        {
            OptionMembers = "Costs","Invoiced";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Cost,Invoiced', ESP = 'Costes,Facturaci�n';


            trigger OnValidate();
            BEGIN
                QuoBuildingSetup.GET;
                IF "Document Type" = "Document Type"::Costs THEN
                    VALIDATE("Allocation Account of Transfe", QuoBuildingSetup."Transfers Account Expense")
                ELSE
                    VALIDATE("Allocation Account of Transfe", QuoBuildingSetup."Transfers Account Sales");
            END;


        }
        field(11; "Allocation Account of Transfe"; Code[20])
        {
            TableRelation = "G/L Account"."No.";


            CaptionML = ENU = 'Allocation Account of Transfe', ESP = 'Cta. de imputaci�n de traspaso';

            trigger OnValidate();
            BEGIN
                TransferCostandInvoiceLine := Rec;

                GetMasterHeader;

                IF "Allocation Account of Transfe" <> '' THEN BEGIN
                    GLAccount.GET("Allocation Account of Transfe");
                    GLAccount.CheckGLAcc;
                    GLAccount.TESTFIELD("Direct Posting", TRUE);
                    GLAccount.TESTFIELD("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
                    Description := GLAccount.Name;
                END;

                CreateDim;
            END;


        }
        field(12; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(14; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Transfer an Amount', ESP = 'Importe a traspasar';


        }
        field(20; "Origin Job No."; Code[20])
        {
            TableRelation = Job."No." WHERE("Status" = FILTER("Open"));


            CaptionML = ENU = 'Origin Job No.', ESP = 'No. proyecto origen';

            trigger OnValidate();
            BEGIN
                TransferCostandInvoiceLineDocument := Rec;

                GetMasterHeader;
                Job.GET("Origin Job No.");
                ControlStatisticsTypeLock("Origin Job No.");
                Job.ControlJob(Job);
                AssignedDepartamentJob(0);

                CreateDim;
            END;


        }
        field(21; "Origin Departament"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Origin Departament', ESP = 'Dpto. Origen';

            trigger OnValidate();
            BEGIN
                CreateDim;
            END;


        }
        field(22; "Origin C.A."; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'C.A. Origin', ESP = 'C.A origen';

            trigger OnValidate();
            BEGIN
                CheckAC("Origin C.A.");
                CreateDim;
            END;


        }
        field(23; "Origin Piecework"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Origin Job No."));
            CaptionML = ENU = 'Origin Piecework', ESP = 'Unidad de obra origen';


        }
        field(24; "Origin Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Origin Job No."));
            CaptionML = ENU = 'Origin Task No.', ESP = 'No. tarea origen';


        }
        field(25; "Origin Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones Origen';
            Editable = false;


        }
        field(30; "Destination Job No."; Code[20])
        {
            TableRelation = Job."No." WHERE("Status" = FILTER("Open"));


            CaptionML = ENU = 'Destination Job No.', ESP = 'No. proyecto destino';

            trigger OnValidate();
            BEGIN
                TransferCostandInvoiceLineDocument := Rec;

                GetMasterHeader;
                Job.GET("Destination Job No.");
                ControlStatisticsTypeLock("Destination Job No.");
                Job.ControlJob(Job);
                AssignedDepartamentJob(1);

                CreateDim;
            END;


        }
        field(31; "Destination Departament"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Destination Departament', ESP = 'Dpto. destino';

            trigger OnValidate();
            BEGIN
                CreateDim;
            END;


        }
        field(32; "Destination C.A."; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'C.A. Destination', ESP = 'C.A. destino';

            trigger OnValidate();
            BEGIN
                CheckAC("Destination C.A.");
                CreateDim;
            END;


        }
        field(33; "Destination Piecework"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Destination Job No."));
            CaptionML = ENU = 'Destination Piecework', ESP = 'Unidad de obra destino';


        }
        field(34; "Destination Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Destination Job No."));
            CaptionML = ENU = 'Destination Task No.', ESP = 'No. tarea destino';


        }
        field(35; "Destination Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID 2', ESP = 'Id. grupo dimensiones Destino';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       HeaderTransCostsInvoice@7001100 :
        HeaderTransCostsInvoice: Record 7207286;
        //       QuoBuildingSetup@7001102 :
        QuoBuildingSetup: Record 7207278;
        //       Job@7001103 :
        Job: Record 167;
        //       Text002@7001105 :
        Text002: TextConst ENU = 'The Job Status must be Order.', ESP = 'El Estado del proyecto debe ser Pedido';
        //       Text003@7001104 :
        Text003: TextConst ENU = 'The job is locked', ESP = 'El proyecto est� bloqueado';
        //       FunctionQB@7001106 :
        FunctionQB: Codeunit 7207272;
        //       TransferCostandInvoiceLine2@7001107 :
        TransferCostandInvoiceLine2: Record 7207287;
        //       DimensionValue@7001108 :
        DimensionValue: Record 349;
        //       DimensionManagement@7001110 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       Text000@7001111 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       TransferCostandInvoiceLine@7001112 :
        TransferCostandInvoiceLine: Record 7207287;
        //       GLAccount@7001113 :
        GLAccount: Record 15;
        //       Text50001@7001114 :
        Text50001: TextConst ENU = 'You can not use an analytical concept of Expenses for billing transfers', ESP = 'Solo puede usar un concepto anal�tico de Gastos para traspasos de costes';
        //       TransferCostandInvoiceLineDocument@7001116 :
        TransferCostandInvoiceLineDocument: Record 7207287;
        //       Text50002@1100286001 :
        Text50002: TextConst ENU = 'You can not use an analytical concept of Income for charges and discharges', ESP = 'Solo puede usar un concepto anal�tico de Ingresos para traspaso de facturaci�n';
        //       Text50004@1100286000 :
        Text50004: TextConst ENU = 'The analytical concepts of all lines must be of the same type', ESP = 'No existe el conceptos analitico';

    LOCAL procedure GetMasterHeader()
    begin
        HeaderTransCostsInvoice.GET("Document No.");
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        //Funci�n para el capti�n de la tabla, es lo que mostrar� el formulario
        Field.GET(DATABASE::"WorkSheet Lines qb", FieldNo);
        exit(Field."Field Caption");
    end;

    //     procedure ControlStatisticsTypeLock (CJob@1100231000 :
    procedure ControlStatisticsTypeLock(CJob: Code[20])
    begin
        Job.GET(CJob);
        if Job.Status <> Job.Status::Open then
            ERROR(Text002);
        if Job.Blocked <> Job.Blocked::" " then
            ERROR(Text003);
    end;

    //     procedure AssignedDepartamentJob (Column@1100231000 :
    procedure AssignedDepartamentJob(Column: Integer)
    var
        //       Job2@1000000000 :
        Job2: Record 167;
    begin
        //Se asigna a la l�nea el Dpto del proyecto
        if Column = 0 then begin
            if Job2.GET("Origin Job No.") then begin
                if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 then
                    VALIDATE("Origin Departament", Job2."Global Dimension 1 Code");

                if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 then
                    VALIDATE("Origin Departament", Job2."Global Dimension 2 Code");
            end;
        end;
        if Column = 1 then begin
            if Job2.GET("Destination Job No.") then begin
                if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 then
                    VALIDATE("Destination Departament", Job2."Global Dimension 1 Code");

                if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 2 then
                    VALIDATE("Destination Departament", Job2."Global Dimension 2 Code");
            end;
        end;
    end;

    procedure CreateDim()
    var
        //       SourceCodeSetup@1006 :
        SourceCodeSetup: Record 242;
        //       TableID@1007 :
        TableID: ARRAY[10] OF Integer;
        //       No@1008 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource2: List of [Dictionary of [Integer, Code[20]]];
        //       D1@1100286000 :
        D1: Code[20];
        //       D2@1100286001 :
        D2: Code[20];
        //       D3@1100286002 :
        D3: Code[20];
        //       D4@1100286003 :
        D4: Code[20];
    begin
        //if not INSERT(TRUE) then
        //  MODIFY;

        SourceCodeSetup.GET;
        GetMasterHeader;

        TableID[1] := DATABASE::"G/L Account";
        No[1] := "Allocation Account of Transfe";



        TableID[2] := DATABASE::Job;
        No[2] := "Origin Job No.";
        D1 := "Origin Departament";
        D2 := "Origin C.A.";
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        "Origin Dimension Set ID" := DimensionManagement.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Charges and Discharge", "Origin Departament", "Origin C.A.", 0, DATABASE::Job);
        ValidateGlobalDimCode(1, D1, "Origin Dimension Set ID");
        ValidateGlobalDimCode(2, D2, "Origin Dimension Set ID");
        "Origin Departament" := D1;
        "Origin C.A." := D2;

        TableID[2] := DATABASE::Job;
        No[2] := "Destination Job No.";
        D1 := "Destination Departament";
        D2 := "Destination C.A.";
        /*To Be Tested*/
        DimensionManagement.AddDimSource(DefaultDimSource2, TableID[1], No[1]);
        DimensionManagement.AddDimSource(DefaultDimSource2, TableID[2], No[2]);
        "Destination Dimension Set ID" := DimensionManagement.GetDefaultDimID(DefaultDimSource2, SourceCodeSetup."Charges and Discharge", "Destination Departament", "Destination C.A.", 0, DATABASE::Job);
        ValidateGlobalDimCode(1, D1, "Destination Dimension Set ID");
        ValidateGlobalDimCode(2, D2, "Destination Dimension Set ID");
        "Destination Departament" := D1;
        "Destination C.A." := D2;
    end;

    //     LOCAL procedure ValidateGlobalDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 : Code[20];var DimensionSetID@1100286000 :
    LOCAL procedure ValidateGlobalDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]; var DimensionSetID: Integer)
    var
        //       OldDimSetID@1005 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := DimensionSetID;
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, DimensionSetID);
        if (OldDimSetID <> DimensionSetID) then
            MODIFY;
    end;

    procedure ShowDimensionsOrigin()
    begin
        "Origin Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Origin Dimension Set ID", STRSUBSTNO('%1 %2', "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Origin Dimension Set ID", "Origin Departament", "Origin C.A.");
    end;

    procedure ShowDimensionsDestination()
    begin
        "Destination Dimension Set ID" :=
          DimensionManagement.EditDimensionSet("Destination Dimension Set ID", STRSUBSTNO('%1 %2', "Document No.", "Line No."));
        DimensionManagement.UpdateGlobalDimFromDimSetID("Destination Dimension Set ID", "Destination Departament", "Destination C.A.");
    end;

    //     LOCAL procedure CheckAC (pAC@1100286000 :
    LOCAL procedure CheckAC(pAC: Code[20])
    begin
        if (not DimensionValue.GET(FunctionQB.ReturnDimCA, pAC)) then
            ERROR(Text50004);

        if ("Document Type" = "Document Type"::Costs) and (DimensionValue.Type <> DimensionValue.Type::Expenses) then
            ERROR(Text50001);
        if ("Document Type" = "Document Type"::Invoiced) and (DimensionValue.Type <> DimensionValue.Type::Income) then
            ERROR(Text50002);
    end;

    /*begin
    //{
//      JAV 28/10/19: - Se cambia el name y caption de la tabla para que sea mas significativo del contenido
//                    - Se elimina el campo "Document Type" de la clave, pasa a ser un campo mas
//      JAV 27/01/21: - QB 1.08.06 Se simplifican llamadas que solo se usan una vez
//    }
    end.
  */
}







