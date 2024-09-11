table 7207408 "QBU Header Regularization Stock"
{


    CaptionML = ENU = 'Header Regularization Stock', ESP = 'Cab. regularizaci�n stock';
    LookupPageID = "Regularization Stock List";
    DrillDownPageID = "Regularization Stock List";

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            TableRelation = "Location";


            CaptionML = ENU = 'Location Code', ESP = 'Cod. almac�n';

            trigger OnValidate();
            BEGIN
                IF "Location Code" <> xRec."Location Code" THEN BEGIN
                    LineRegularizationStock.RESET;
                    LineRegularizationStock.SETRANGE("Document No.", "No.");
                    IF LineRegularizationStock.FINDFIRST THEN
                        ERROR(Text002);
                END;

                GetLocation("Location Code");
                Description := Location.Name;
                "Description 2" := Location."Name 2";

                GetDepartmentLocation;
            END;


        }
        field(2; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesManagement.TestManual(GetNoSeriesCode);
                    "Serie No." := '';
                END;
            END;


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(5; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(6; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Descripci�n registro';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
            END;


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
            END;


        }
        field(9; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Regular"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(10; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Line Regularization Stock"."Total Cost" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;


        }
        field(11; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(12; "Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie No.', ESP = 'No. serie';
            Editable = false;


        }
        field(13; "Posting Serie No."; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting Serie No.', ESP = 'No. serie registro';

            trigger OnValidate();
            BEGIN
                //se generar�n los hist. como albaranes de salida
                IF "Posting Serie No." <> '' THEN BEGIN
                    QuoBuildingSetup.GET;
                    TestNoSeries;
                    NoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting Serie No.");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH HeaderRegularizationStock DO BEGIN 
                HeaderRegularizationStock := Rec;
                QuoBuildingSetup.GET;
                TestNoSeries;
                IF NoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting Serie No.") THEN
                    VALIDATE("Posting Serie No.");
                Rec := HeaderRegularizationStock;
                // END;
            END;


        }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(15; "Regularization Date"; Date)
        {
            CaptionML = ENU = 'Regularization Date', ESP = 'Fecha regularizaci�n';


        }
        field(16; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


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
        //       QuoBuildingSetup@7001100 :
        QuoBuildingSetup: Record 7207278;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       Text001@7001102 :
        Text001: TextConst ENU = 'Stock regul.: %1', ESP = 'Regul. stock: %1';
        //       LineRegularizationStock@7001103 :
        LineRegularizationStock: Record 7207409;
        //       Text003@7001104 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text002@7001105 :
        Text002: TextConst ENU = 'To change the store you must delete the lines', ESP = 'Para cambiar el almac�n debe de eliminar las l�neas';
        //       Location@7001106 :
        Location: Record 14;
        //       FunctionQB@7001107 :
        FunctionQB: Codeunit 7207272;
        //       OldDimSetID@7001108 :
        OldDimSetID: Integer;
        //       DimensionManagement@7001109 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       Text004@7001110 :
        Text004: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n. \\ �Desea actualizar las l�neas?';
        //       HeaderRegularizationStock@7001111 :
        HeaderRegularizationStock: Record 7207408;



    trigger OnInsert();
    begin
        //Aqui vamos a tomar cual es el contador desde el que vamos a generar n�meros de series.

        QuoBuildingSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."Serie No.", "Posting Date", "No.", "Serie No.");
        end;

        InitRecord;
        if GETFILTER("Location Code") <> '' then
            if GETRANGEMIN("Location Code") = GETRANGEMAX("Location Code") then
                VALIDATE("Location Code", GETRANGEMIN("Location Code"));


        //Si entro en la tabla desde proyecto, heredo de forma autom�tica el almac�n del proyecto desde el que vengo.
        FILTERGROUP(2);
        if (HASFILTER and (GETFILTER("Location Code") <> '')) then
            VALIDATE("Location Code", GETFILTER("Location Code"));
        FILTERGROUP(0);
    end;

    trigger OnDelete();
    begin
        LineRegularizationStock.LOCKTABLE;

        // Se borran las l�neas asociadas al documento
        LineRegularizationStock.SETRANGE("Document No.", "No.");
        LineRegularizationStock.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure TestNoSeries(): Boolean;
    begin
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD(QuoBuildingSetup."Serie for Stock Regularization");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        QuoBuildingSetup.GET;
        exit(QuoBuildingSetup."Serie for Stock Regularization");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        // Regulariaci�n de stock no genera hist�ricos
        //exit(PurchSetup."N� serie registro alb. salida");
    end;

    procedure InitRecord()
    begin
        QuoBuildingSetup.GET;
        NoSeriesManagement.SetDefaultSeries("Posting Serie No.", QuoBuildingSetup."Serie for Stock Regularization");

        "Posting Date" := WORKDATE;
        "Posting Description" := STRSUBSTNO(Text001, "No.");
        "Regularization Date" := TODAY;
    end;

    //     LOCAL procedure GetLocation (PLocation@1000 :
    LOCAL procedure GetLocation(PLocation: Code[20])
    begin
        if PLocation <> Location.Code then
            Location.GET(PLocation);
    end;

    procedure GetDepartmentLocation()
    begin
        GetLocation("Location Code");
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 then
            "Shortcut Dimension 1 Code" := Location."QB Departament Code"
        else
            "Shortcut Dimension 2 Code" := Location."QB Departament Code";
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLinesShipmentOutput then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ExistLinesShipmentOutput(): Boolean;
    begin
        LineRegularizationStock.RESET;
        LineRegularizationStock.SETRANGE("Document No.", "No.");
        exit(LineRegularizationStock.FINDFIRST);
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
        if not CONFIRM(Text004) then
            exit;

        LineRegularizationStock.RESET;
        LineRegularizationStock.SETRANGE("Document No.", "No.");
        LineRegularizationStock.LOCKTABLE;
        if LineRegularizationStock.FIND('-') then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(LineRegularizationStock."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if LineRegularizationStock."Dimension Set ID" <> NewDimSetID then begin
                    LineRegularizationStock."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                      LineRegularizationStock."Dimension Set ID", LineRegularizationStock."Shortcut Dimension 1 Code", LineRegularizationStock."Shortcut Dimension 2 Code");
                    LineRegularizationStock.MODIFY;
                end;
            until LineRegularizationStock.NEXT = 0;
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@1000 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimensionManagement1.EditDimensionSet2(
            "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLinesShipmentOutput then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure AssistEdit (HeaderRegularizationStockOld@1000 :
    procedure AssistEdit(HeaderRegularizationStockOld: Record 7207408): Boolean;
    begin
        QuoBuildingSetup.GET;
        TestNoSeries;
        if NoSeriesManagement.SelectSeries(GetNoSeriesCode, HeaderRegularizationStockOld."Serie No.", "Serie No.") then begin
            QuoBuildingSetup.GET;
            TestNoSeries;
            NoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    /*begin
    //{
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//    }
    end.
  */
}







