table 7207433 "QBU Costsheet Header"
{


    CaptionML = ENU = 'Costsheet Header', ESP = 'Cab. Parte Costes';
    LookupPageID = "Costsheet List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'N� �nico seg�n el n� de serie (campo 107)';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    CUNoSeriesManagement.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            END;


        }
        field(2; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(3; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
            END;


        }
        field(4; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            END;


        }
        field(5; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Sheet"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(6; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(7; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';
            Description = 'Opcional. Permite numerar determinados grupos de apuntes con otra numeraci�n';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN BEGIN
                    QuoBuildingSetup.GET;
                    TestNoSeries;
                    CUNoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                //WITH CostsheetHeader DO BEGIN
                CostsheetHeader := Rec;
                QuoBuildingSetup.GET;
                TestNoSeries;
                IF CUNoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := CostsheetHeader;
                //END;
            END;


        }
        field(8; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';

            trigger OnValidate();
            BEGIN
                CreateDim(DATABASE::Job, "Job No.");
            END;


        }
        field(9; "Validated Sheet"; Boolean)
        {
            CaptionML = ENU = 'Validated Sheet', ESP = 'Parte validado';


        }
        field(10; "Responsability Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsability Center', ESP = 'Centro Responsabilidad';

            trigger OnValidate();
            VAR
                //                                                                 HasGotSalesUserSetup@7001101 :
                HasGotSalesUserSetup: Boolean;
                //                                                                 UserRespCenter@7001100 :
                UserRespCenter: Code[20];
                //                                                                 UserSetupManagement@7001102 :
                UserSetupManagement: Codeunit 5700;
            BEGIN
                FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
                IF NOT CUUserSetupManagement.CheckRespCenter(3, "Responsability Center") THEN
                    ERROR(Text027, ResponsibilityCenter.TABLECAPTION, UserRespCenter);
            END;


        }
        field(11; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
        field(12; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Costsheet Lines"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ESP = 'Importe Total';
            Description = 'QB 1.10.46 JAV 01/06/22: - Suma de importe de las l�neas';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Text003@7001107 :
        Text003: TextConst ENU = 'You cannot rename to %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text005@7001106 :
        Text005: TextConst ENU = 'You cannot modify a validated sheet', ESP = 'No se puede modificar un parte validado';
        //       text006@7001105 :
        text006: TextConst ENU = 'The project must have activated the management by production units', ESP = 'El proyecto debe tener activa la gesti�n por unidades de producci�n';
        //       text007@7001104 :
        text007: TextConst ENU = 'Project must be Operative', ESP = 'El proyecto debe ser Operativo';
        //       text008@7001103 :
        text008: TextConst ENU = 'You cannot change measurement type because measurement lines already exists %1', ESP = 'No puede cambiar el tipo de medici�n porque existen l�neas para la medici�n %1';
        //       Text004@7001102 :
        Text004: TextConst ENU = 'Yo cannot delete a validated sheet', ESP = 'No puede borrar un parte validado';
        //       Text027@7001101 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Text051@7001100 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n. \\ �Desea actualizar las l�neas?';
        //       QuoBuildingSetup@7001108 :
        QuoBuildingSetup: Record 7207278;
        //       CostsheetLines@7001109 :
        CostsheetLines: Record 7207434;
        //       CostsheetHeader@7001110 :
        CostsheetHeader: Record 7207433;
        //       QBCommentLine@7001111 :
        QBCommentLine: Record 7207270;
        //       CUNoSeriesManagement@7001112 :
        CUNoSeriesManagement: Codeunit "NoSeriesManagement";
        //       CUDimensionManagement@7001113 :
        CUDimensionManagement: Codeunit "DimensionManagement";
        CUDimensionManagement1: Codeunit "DimensionManagement1";
        //       Job@7001115 :
        Job: Record 167;
        //       CUUserSetupManagement@7001114 :
        CUUserSetupManagement: Codeunit 5700;
        //       ResponsibilityCenter@7001116 :
        ResponsibilityCenter: Record 5714;
        //       OldDimSetID@7001117 :
        OldDimSetID: Integer;
        //       FunctionQB@100000000 :
        FunctionQB: Codeunit 7207272;



    trigger OnInsert();
    begin
        //Aqui vamos a tomar cual es el contador desde el que vamos a generar n�meros de series.
        QuoBuildingSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            CUNoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord;

        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                VALIDATE("Job No.", GETRANGEMIN("Job No."));

        //Si entro en la tabla desde proyecto, heredo de forma autom�tica el proyecto desde el que vengo.
        FILTERGROUP(2);
        if (HASFILTER and (GETFILTER("Job No.") <> '')) then
            VALIDATE("Job No.", GETFILTER("Job No."));
        FILTERGROUP(0);
    end;

    trigger OnModify();
    begin
        if "Validated Sheet" = TRUE then
            ERROR(Text005);
    end;

    trigger OnDelete();
    begin
        if "Validated Sheet" = TRUE then
            ERROR(Text004);

        CostsheetLines.LOCKTABLE;

        //Se borran las l�neas asociadas al documento
        CostsheetLines.SETRANGE("Document No.", "No.");
        CostsheetLines.DELETEALL;

        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    procedure InitRecord()
    begin
        CUNoSeriesManagement.SetDefaultSeries("Posting No. Series", QuoBuildingSetup."Serie for Indirect Part Post");
        "Posting Date" := WORKDATE;
    end;

    //     procedure AssistEdit (CostsheetHeaderLoc@1000 :
    procedure AssistEdit(CostsheetHeaderLoc: Record 7207433): Boolean;
    begin
        QuoBuildingSetup.GET;
        TestNoSeries;
        if CUNoSeriesManagement.SelectSeries(GetNoSeriesCode, CostsheetHeaderLoc."No. Series", "No. Series") then begin
            QuoBuildingSetup.GET;
            TestNoSeries;
            CUNoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    LOCAL procedure TestNoSeries(): Boolean;
    begin
        QuoBuildingSetup.TESTFIELD("Serie for Indirect Part");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        exit(QuoBuildingSetup."Serie for Indirect Part");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        exit(QuoBuildingSetup."Serie for Indirect Part Post");
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        //Aqui estableceremos las condiciones de borrado de la cabecera, se llama a una funci�n que lo comprueba
        //PurchPost.TestDeleteHeader(Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,ReturnShptHeader);
        exit(TRUE);
    end;

    //     LOCAL procedure GetMaster (MaestraNo@1000 :
    LOCAL procedure GetMaster(MaestraNo: Code[20])
    begin
    end;

    procedure LinesExistDoc(): Boolean;
    begin
        CostsheetLines.RESET;
        CostsheetLines.SETRANGE("Document No.", "No.");
        exit(CostsheetLines.FIND('-'));
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 :
    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        //       SourceCodeSetup@1010 :
        SourceCodeSetup: Record 242;
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        CUDimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          CUDimensionManagement.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Job Journal", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and LinesExistDoc then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        CUDimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if LinesExistDoc then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure ResponsabilityFilters (var CostsheetHeaderFilter@1000000000 :
    procedure ResponsabilityFilters(var CostsheetHeaderFilter: Record 7207433)
    var
        //       UserSetupManagement@7001100 :
        UserSetupManagement: Codeunit 5700;
        //       HasGotSalesUserSetup@7001101 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001102 :
        UserRespCenter: Code[20];
    begin
        //declarar UserResponsibilityCenter en CU 5700, funcion getjobfilter/ variable
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        if UserRespCenter <> '' then begin
            CostsheetHeaderFilter.FILTERGROUP(2);
            CostsheetHeaderFilter.SETRANGE("Responsability Center", UserRespCenter);
            CostsheetHeaderFilter.FILTERGROUP(0);
        end;
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          CUDimensionManagement1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if LinesExistDoc then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;

        CostsheetLines.RESET;
        CostsheetLines.SETRANGE("Document No.", "No.");
        CostsheetLines.LOCKTABLE;
        if CostsheetLines.FIND('-') then
            repeat
                NewDimSetID := CUDimensionManagement.GetDeltaDimSetID(CostsheetLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if CostsheetLines."Dimension Set ID" <> NewDimSetID then begin
                    CostsheetLines."Dimension Set ID" := NewDimSetID;
                    CUDimensionManagement.UpdateGlobalDimFromDimSetID(
                      CostsheetLines."Dimension Set ID", CostsheetLines."Shortcut Dimension 1 Code", CostsheetLines."Shortcut Dimension 2 Code");
                    CostsheetLines.MODIFY;
                end;
            until CostsheetLines.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//      JAV 01/06/22: - QB 1.10.46 Se a�ade el campo Amount con la suma de las l�neas
//    }
    end.
  */
}







