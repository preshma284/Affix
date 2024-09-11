table 7206999 "QB FA Analitical Distribution"
{


    CaptionML = ENU = 'Analitical Distribution', ESP = 'Distribuci�n anal�tica';

    fields
    {
        field(1; "AF Code"; Code[20])
        {
            TableRelation = "Fixed Asset";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'AF Code', ESP = 'C�digo Aactivo fijo';
            NotBlank = true;

            trigger OnValidate();
            BEGIN
                IF "AF Code" = xRec."AF Code" THEN
                    EXIT;

                IF NOT Rec.ISTEMPORARY THEN
                    ErrorIfDuplicated;

                UpdateDimensions;
            END;


        }
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Entry No.', ESP = 'N� Movimiento';


        }
        field(4; "Distribution %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Distribution %', ESP = '% distribuci�n';


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = "Job";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';

            trigger OnValidate();
            VAR
                //                                                                 tempDimensionSetEntry@1100286003 :
                tempDimensionSetEntry: Record 480 TEMPORARY;
                //                                                                 DefaultDimension@1100286004 :
                DefaultDimension: Record 352;
            BEGIN
                IF "Job No." = xRec."Job No." THEN
                    EXIT;

                IF NOT Rec.ISTEMPORARY THEN
                    ErrorIfDuplicated;

                UpdateDimensions;
            END;


        }
        field(10; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Job Unit', ESP = 'N� unidad de obra';

            trigger OnValidate();
            BEGIN
                IF "Piecework Code" = xRec."Piecework Code" THEN
                    EXIT;

                IF NOT Rec.ISTEMPORARY THEN
                    ErrorIfDuplicated;

                UpdateDimensions;
            END;


        }
        field(12; "Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Data Piecework For Production"."Description" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Piecework Code" = FIELD("Piecework Code")));
            Editable = false;


        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1),
                                                                                               "Blocked" = CONST(false));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2),
                                                                                               "Blocked" = CONST(false));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnValidate();
            BEGIN
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            END;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(7207348; "QB CA Code"; Code[20])
        {
            TableRelation = "Dimension";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Concepto Anal�tico Dim.';
            Description = 'QB 1.10.42 JAV 21/05/22: - Campo de uso interno que Contiene el c�digo de la dimensi�n para Concepto anal�tico, se usa para filtrar el siguiente campo';

            trigger OnValidate();
            BEGIN
                "QB CA Code" := FunctionQB.ReturnDimCA;
            END;


        }
        field(7207349; "QB CA Value"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Dimension Code" = FIELD("QB CA Code"),
                                                                                               "Dimension Value Type" = CONST("Standard"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Concepto Anal�tico';
            Description = 'QB 1.10.42 JAV 21/05/22: - Contiene el Concepto anal�tico que se va a asociar a la l�nea. Se utiliza en lugar de la dimensi�n para independizarnos de su n�mero';

            trigger OnValidate();
            BEGIN
                VALIDATE("QB CA Code");
                FunctionQB.SetDimensionIDWithGlobals("QB CA Code", "QB CA Value", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID");
            END;


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       DimMgt@1100286000 :
        DimMgt: Codeunit "DimensionManagement";
        DimMgt1: Codeunit "DimensionManagement1";
        //       "--------------------------------------------- QB"@1100286002 :
        "--------------------------------------------- QB": Integer;
        //       FunctionQB@1100286001 :
        FunctionQB: Codeunit 7207272;
        //       ErrorDupicatedRecord@1100286003 :
        ErrorDupicatedRecord: TextConst ENU = 'Ya existe una l�nea de distribuci�n con la misma combinaci�n de proyecto (%1), unidad de obra (%2) y valores de dimensi�n';




    trigger OnInsert();
    begin
        if not Rec.ISTEMPORARY then
            ErrorIfDuplicated;
    end;

    trigger OnModify();
    begin
        if not Rec.ISTEMPORARY then
            ErrorIfDuplicated;
    end;



    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2 %3', Rec."AF Code", Rec."Job No.", Rec."Piecework Code"),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    LOCAL procedure ErrorIfDuplicated()
    var
        //       AnaliticalDistrib@1100286000 :
        AnaliticalDistrib: Record 7206999;
    begin
        AnaliticalDistrib.RESET;
        AnaliticalDistrib.SETFILTER("Entry No.", '<>%1', "Entry No.");
        AnaliticalDistrib.SETRANGE("AF Code", "AF Code");
        AnaliticalDistrib.SETRANGE("Job No.", "Job No.");
        AnaliticalDistrib.SETRANGE("Piecework Code", "Piecework Code");
        AnaliticalDistrib.SETRANGE("Dimension Set ID", "Dimension Set ID");

        if not AnaliticalDistrib.ISEMPTY then
            ERROR(ErrorDupicatedRecord, "Job No.", "Piecework Code");
    end;

    LOCAL procedure UpdateDimensions()
    var
        //       tempDimensionSetEntry@1100286001 :
        tempDimensionSetEntry: Record 480 TEMPORARY;
        //       DefaultDimension@1100286000 :
        DefaultDimension: Record 352;
        //       DataPieceworkForProduction@1100286002 :
        DataPieceworkForProduction: Record 7207386;
        //       FA@1100286003 :
        FA: Record 5600;
        //       Job@1100286004 :
        Job: Record 167;
    begin
        DimMgt.GetDimensionSet(tempDimensionSetEntry, "Dimension Set ID");

        if FA.GET("AF Code") then
            UpdatetempDimensionSetEntry(DATABASE::"Fixed Asset", FA."No.", tempDimensionSetEntry);

        if Job.GET("Job No.") then
            UpdatetempDimensionSetEntry(DATABASE::Job, Job."No.", tempDimensionSetEntry);

        if DataPieceworkForProduction.GET("Job No.", "Piecework Code") then
            UpdatetempDimensionSetEntry(DATABASE::"Data Piecework For Production", DataPieceworkForProduction."Unique Code", tempDimensionSetEntry);

        VALIDATE("Dimension Set ID", DimMgt.GetDimensionSetID(tempDimensionSetEntry));
    end;

    //     LOCAL procedure UpdatetempDimensionSetEntry (TableNo@1100286002 : Integer;No@1100286003 : Code[20];var tempDimensionSetEntry@1100286000 :
    LOCAL procedure UpdatetempDimensionSetEntry(TableNo: Integer; No: Code[20]; var tempDimensionSetEntry: Record 480 TEMPORARY)
    var
        //       DefaultDimension@1100286001 :
        DefaultDimension: Record 352;
    begin
        DefaultDimension.RESET;
        DefaultDimension.SETRANGE("Table ID", TableNo);
        DefaultDimension.SETRANGE("No.", No);
        //Q17292-
        DefaultDimension.SETFILTER("Dimension Value Code", '<>%1', '');
        //Q17292+
        if DefaultDimension.FINDSET then
            repeat
                if not tempDimensionSetEntry.GET("Dimension Set ID", DefaultDimension."Dimension Code") then begin
                    tempDimensionSetEntry.INIT;
                    tempDimensionSetEntry.VALIDATE("Dimension Set ID", "Dimension Set ID");
                    tempDimensionSetEntry.VALIDATE("Dimension Code", DefaultDimension."Dimension Code");
                    tempDimensionSetEntry.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                    tempDimensionSetEntry.INSERT(TRUE);
                end else begin
                    tempDimensionSetEntry.VALIDATE("Dimension Value Code", DefaultDimension."Dimension Value Code");
                    tempDimensionSetEntry.MODIFY(TRUE);
                end;
            until DefaultDimension.NEXT = 0;
    end;

    /*begin
    //{
//      PSM 10/10/23: Q17292 S�lo actualizar las dimensiones por defecto del proyecto que tengan un valor
//    }
    end.
  */
}







