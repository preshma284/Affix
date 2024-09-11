table 7207434 "QBU Costsheet Lines"
{


    CaptionML = ENU = 'Costsheet Lines', ESP = 'L�neas Partes Costes';
    PasteIsValid = false;
    LookupPageID = "Costsheet Lines Subform.";
    DrillDownPageID = "Costsheet Lines Subform.";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(3; "Unit Cost No."; Text[20])
        {


            CaptionML = ENU = 'Unit Cost No.', ESP = 'No. unidad de coste';

            trigger OnValidate();
            BEGIN
                GetMasterHeader;
                DataPieceworkForProduction.GET(CostsheetHeader."Job No.", "Unit Cost No.");
                VALIDATE("Invoicing Job", DataPieceworkForProduction."Job Billing Structure");

                //Asigna el CA coste del GrContable coste de la unidad de coste
                AsigCA;
            END;

            trigger OnLookup();
            BEGIN
                DataPieceworkForProduction.RESET;
                GetMasterHeader;
                DataPieceworkForProduction.SETRANGE("Job No.", CostsheetHeader."Job No.");
                DataPieceworkForProduction.SETRANGE(DataPieceworkForProduction.Type, DataPieceworkForProduction.Type::"Cost Unit");

                IF PAGE.RUNMODAL(PAGE::"Data Piecework List", DataPieceworkForProduction) = ACTION::LookupOK THEN
                    VALIDATE("Unit Cost No.", DataPieceworkForProduction."Piecework Code");
            END;


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(6; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = true;
            AutoFormatType = 1;


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;


        }
        field(9; "Invoicing Job"; Code[20])
        {
            TableRelation = Job."No." WHERE("Job Type" = CONST("Structure"));


            CaptionML = ENU = 'Billing project', ESP = 'Proyecto facturaci�n';

            trigger OnValidate();
            BEGIN
                VALIDATE("Shortcut Dimension 1 Code", CostsheetHeader."Shortcut Dimension 1 Code");
                VALIDATE("Shortcut Dimension 2 Code", CostsheetHeader."Shortcut Dimension 2 Code");

                CreateDim(DATABASE::Job, "Invoicing Job");
                AsigCA;

                IF Job.GET("Invoicing Job") THEN
                    Description := Job.Description
                ELSE
                    Description := '';

                GetMasterHeader;
                //CalcAmount;  //JAV 25/04/20: - El importe lo ha calculado el proceso externo, aunque cambiemos el proyecto de imputaci�n no tiene que cambiar el importe
            END;


        }
        field(10; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount";
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CostsheetHeader@7001100 :
        CostsheetHeader: Record 7207433;
        //       CostsheetLines@7001101 :
        CostsheetLines: Record 7207434;
        //       CostsheetLines2@7001102 :
        CostsheetLines2: Record 7207434;
        //       Currency@7001103 :
        Currency: Record 4;
        //       StandardText@7001104 :
        StandardText: Record 7;
        //       GeneralLedgerSetup@7001105 :
        GeneralLedgerSetup: Record 98;
        //       CUDimensionManagement@7001106 :
        CUDimensionManagement: Codeunit "DimensionManagement";
        //       GLSetupRead@7001107 :
        GLSetupRead: Boolean;
        //       DataPieceworkForProduction@7001108 :
        DataPieceworkForProduction: Record 7207386;
        //       CostsheetLinesHist@7001109 :
        CostsheetLinesHist: Record 7207436;
        //       HistPeriodQty@7001110 :
        HistPeriodQty: Decimal;
        //       MeasurementLines@7001111 :
        MeasurementLines: Decimal;
        //       Job@7001112 :
        Job: Record 167;
        //       UnitsPostingGroup@7001113 :
        UnitsPostingGroup: Record 7207431;
        //       CUFunctionQB@7001114 :
        CUFunctionQB: Codeunit 7207272;
        //       Amount_@7001115 :
        Amount_: Decimal;
        //       DataPieceworkForProduction2@7001116 :
        DataPieceworkForProduction2: Record 7207386;
        //       Text000@7001119 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text002@7001118 :
        Text002: TextConst ENU = 'You cannot modify a validated sheet.', ESP = 'No se puede modificar un parte validado.';
        //       Text003@7001117 :
        Text003: TextConst ENU = 'You cannot delete a validated sheet.', ESP = 'No se puede borrar un parte validado.';
    //       ProposeCostsheet@100000000 :
    //ProposeCostsheet: Report 7207348;



    trigger OnInsert();
    begin
        LOCKTABLE;
        CostsheetHeader."No." := '';
        GetMasterHeader;
    end;

    trigger OnModify();
    begin
        GetMasterHeader;
        if CostsheetHeader."Validated Sheet" = TRUE then
            ERROR(Text002);
    end;

    trigger OnDelete();
    begin
        GetMasterHeader;
        if CostsheetHeader."Validated Sheet" = TRUE then
            ERROR(Text003);

        DeselectCostsheet;
    end;

    trigger OnRename();
    begin
        ERROR(Text000, TABLECAPTION);
    end;



    LOCAL procedure GetMasterHeader()
    begin
        //Trae los valores de la cabecera del documento.
        TESTFIELD("Document No.");
        CostsheetHeader.GET("Document No.");
    end;

    procedure ShowDimensions()
    begin
        //Muestra el contenido de las dimensiones seleccionadas de la l�nea.
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        "Dimension Set ID" :=
          CUDimensionManagement.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
        CUDimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 :
    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        //       SourceCodeSetup@1008 :
        SourceCodeSetup: Record 242;
        //       TableID@1009 :
        TableID: ARRAY[10] OF Integer;
        //       No@1010 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];

    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        CUDimensionManagement.AddDimSource(DefaultDimSource, Type1, No1);
        //CUDimensionManagement.AddDimSource(DefaultDimSource, Database::Location, SourceCodeSetup."Job Journal");
        GetMasterHeader;

        //{
        //      "Dimension Set ID" :=
        //        CUDimensionManagement.GetDefaultDimID(
        //          TableID,No,SourceCodeSetup."Job Journal","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
        //          CostsheetHeader."Dimension Set ID",DATABASE::Job);
        //      }
        /*To be Tested*/
        "Dimension Set ID" :=
          CUDimensionManagement.GetDefaultDimID(
            DefaultDimSource, SourceCodeSetup."Job Journal", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            0, DATABASE::Job);
        CUDimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;



    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Valida que la dimensi�n introducida es coherente, es decir existe dicho valor de dimensi�n.
        CUDimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //Busca el valor de las dimensiones por defecto
        CUDimensionManagement.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :
    procedure ShowShortcutDimCode(var ShortcutDimCode: ARRAY[8] OF Code[20])
    begin
        //Toma las dimensiones por defecto, como m�ximo ser�n 8
        CUDimensionManagement.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        //Funci�n para el caption de la tabla, es lo que mostrar� el formulario
        Field.GET(DATABASE::"Costsheet Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    LOCAL procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GeneralLedgerSetup.GET;
        GLSetupRead := TRUE;
    end;

    LOCAL procedure AsigCA()
    begin
        DataPieceworkForProduction2.RESET;
        if DataPieceworkForProduction2.GET(CostsheetHeader."Job No.", "Unit Cost No.") and (DataPieceworkForProduction2.Type = DataPieceworkForProduction2.Type::"Cost Unit") then begin
            DataPieceworkForProduction2.TESTFIELD(DataPieceworkForProduction2."Posting Group Unit Cost");
            UnitsPostingGroup.GET(DataPieceworkForProduction2."Posting Group Unit Cost");
            CUFunctionQB.UpdateDimSet(CUFunctionQB.ReturnDimCA, UnitsPostingGroup."Cost Analytic Concept", "Dimension Set ID");
            CUDimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        end;
    end;

    procedure CalcAmount()
    var
        //       LOCExpectedTimeUnitData@1000000000 :
        LOCExpectedTimeUnitData: Record 7207388;
        //       LOCCostsheetLinesHist@1000000001 :
        LOCCostsheetLinesHist: Record 7207436;
        //       LOCCostsheetHeaderHist@1000000002 :
        LOCCostsheetHeaderHist: Record 7207435;
    begin
        // //Se propone el importe con la suma de los datos de previsi�n + el hist. l�neas parte coste
        // Amount_ := 0;
        // LOCExpectedTimeUnitData.RESET;
        // LOCExpectedTimeUnitData.SETRANGE("Job No.",CostsheetHeader."Job No.");
        // LOCExpectedTimeUnitData.SETRANGE("Unit Type",LOCExpectedTimeUnitData."Unit Type"::"Cost Unit");
        // LOCExpectedTimeUnitData.SETRANGE("Piecework Code","Unit Cost No.");
        // LOCExpectedTimeUnitData.SETRANGE("Incluided In Dispatch",FALSE);
        // LOCExpectedTimeUnitData.SETFILTER("Expected Date",'<=%1',CostsheetHeader."Posting Date");
        // if LOCExpectedTimeUnitData.FINDSET(TRUE,FALSE) then
        //  repeat
        //    Amount_ := Amount_ + LOCExpectedTimeUnitData.CostAmountBudget(LOCExpectedTimeUnitData);  //----------------------------FALTA FUNCION
        //    LOCExpectedTimeUnitData."Incluided In Dispatch" := TRUE;
        //    LOCExpectedTimeUnitData."Doc. Dispatch No." := "Document No.";
        //    LOCExpectedTimeUnitData.MODIFY;
        //  until LOCExpectedTimeUnitData.NEXT=0;
        //
        // LOCCostsheetLinesHist.RESET;
        // LOCCostsheetLinesHist.SETRANGE("Job No.","Invoicing Job");
        // LOCCostsheetLinesHist.SETRANGE("Piecework No.","Unit Cost No.");
        // if LOCCostsheetLinesHist.FINDSET(TRUE,FALSE) then
        //  repeat
        //    if (LOCCostsheetHeaderHist.GET(LOCCostsheetLinesHist."Document No.")) and
        //       (LOCCostsheetHeaderHist."Posting Date" <= CostsheetHeader."Posting Date") then
        //      Amount_ := Amount_ + LOCCostsheetLinesHist.Amount;
        //  until LOCCostsheetLinesHist.NEXT=0;
        //
        // Amount := Amount_;

        //Calcular el importe a aplicar
        // CLEAR(ProposeCostsheet);
        // ProposeCostsheet.CalcLine(Rec, DataPieceworkForProduction, CostsheetHeader."Posting Date");
    end;

    procedure DeselectCostsheet()
    var
        //       LOCExpectedTimeUnitData@1000000000 :
        LOCExpectedTimeUnitData: Record 7207388;
    begin
        //Cuando se elimina una linea del borrador desmarcar en la tabla 72004
        LOCExpectedTimeUnitData.RESET;
        LOCExpectedTimeUnitData.SETRANGE("Doc. Dispatch No.", "Document No.");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if LOCExpectedTimeUnitData.FINDSET(TRUE,FALSE) then
        if LOCExpectedTimeUnitData.FINDSET(TRUE) then
            repeat
                LOCExpectedTimeUnitData."Doc. Dispatch No." := '';
                LOCExpectedTimeUnitData."Incluided In Dispatch" := FALSE;
                LOCExpectedTimeUnitData.MODIFY;
            until LOCExpectedTimeUnitData.NEXT = 0;
    end;

    /*begin
    end.
  */
}







