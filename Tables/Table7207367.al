table 7207367 "QBU Activation Header"
{


    CaptionML = ENU = 'Header Activation', ESP = 'Cabecera activaci�n';
    LookupPageID = "Activation Line";

    fields
    {
        field(1; "Element Code"; Code[20])
        {
            TableRelation = "Rental Elements";


            CaptionML = ENU = 'Element Code', ESP = 'Cod. elemento';

            trigger OnValidate();
            BEGIN
                GetRecElement("Element Code");

                Description := RentalElements.Description;
                "Description 2" := RentalElements."Description 2";

                CreateDim(DATABASE::"Rental Elements", "Element Code");
            END;


        }
        field(2; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    RentalElementsSetup.GET;
                    NoSeriesManagement.TestManual(GetNoSeriesCode);
                    "Serial No." := '';
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
            CaptionML = ENU = 'Posting Description', ESP = 'Descripci�n Registro';


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
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';


        }
        field(10; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(11; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Activation Comments Line" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(12; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Activation Line"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatExpression = "Currency Code";


        }
        field(13; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(14; "Serial No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serial No.', ESP = 'No. serie';
            Editable = false;


        }
        field(15; "Posting Serial No."; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting Serial No.', ESP = 'No. serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting Serial No." <> '' THEN BEGIN
                    RentalElementsSetup.GET;
                    TestNoSeries;
                    NoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting Serial No.");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH ActivationHeader DO BEGIN
                ActivationHeader := Rec;
                RentalElementsSetup.GET;
                TestNoSeries;
                IF NoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting Serial No.") THEN
                    VALIDATE("Posting Serial No.");
                Rec := ActivationHeader;
                // END;
            END;


        }
        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(17; "Variant"; Code[10])
        {
            TableRelation = "Item Variant"."Item No." WHERE("Item No." = FIELD("Item"));
            CaptionML = ENU = 'Variant', ESP = 'Variante';


        }
        field(18; "Item"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Rental Elements"."Related Product" WHERE("No." = FIELD("Element Code")));
            CaptionML = ENU = 'Item', ESP = 'Producto';


        }
        field(19; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimension';
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
            ;
        }
        key(key2; "Element Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       RentalElementsSetup@7001100 :
        RentalElementsSetup: Record 7207346;
        //       ActivationLine@7001102 :
        ActivationLine: Record 7207368;
        //       RentalElements@7001105 :
        RentalElements: Record 7207344;
        //       ActivationHeader@7001109 :
        ActivationHeader: Record 7207367;
        //       ActivationCommentsLine@7001103 :
        ActivationCommentsLine: Record 7207369;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       Text003@7001104 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       DimensionManagement@7001107 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       OldDimSetID@7001106 :
        OldDimSetID: Integer;
        //       Text051@7001108 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado la dimensi�n.\\�Desea actualizar las l�neas?';



    trigger OnInsert();
    begin
        RentalElementsSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."Serial No.", "Posting Date", "No.", "Serial No.");
        end;

        InitRecord;
        if GETFILTER("Element Code") <> '' then
            if GETRANGEMIN("Element Code") = GETRANGEMAX("Element Code") then
                VALIDATE("Element Code", GETRANGEMIN("Element Code"));
    end;

    trigger OnDelete();
    begin
        ActivationLine.LOCKTABLE;

        ActivationLine.SETRANGE("Document No.", "No.");
        ActivationLine.DELETEALL;

        ActivationCommentsLine.SETRANGE("No.", "No.");
        ActivationCommentsLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    procedure InitRecord()
    begin
        NoSeriesManagement.SetDefaultSeries("Posting Serial No.", RentalElementsSetup."No. Serie Post. Activation");
        "Posting Date" := WORKDATE;
        "Posting Description" := "No.";
    end;

    //     procedure AssistEdit (ActivationHeader2@1000 :
    procedure AssistEdit(ActivationHeader2: Record 7207367): Boolean;
    begin
        RentalElementsSetup.GET;
        TestNoSeries;
        if NoSeriesManagement.SelectSeries(GetNoSeriesCode, ActivationHeader2."Serial No.", "Serial No.") then begin
            RentalElementsSetup.GET;
            TestNoSeries;
            NoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    LOCAL procedure TestNoSeries(): Boolean;
    begin
        RentalElementsSetup.TESTFIELD(RentalElementsSetup."No. Serie Activation");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        exit(RentalElementsSetup."No. Serie Activation");
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        exit(RentalElementsSetup."No. Serie Post. Activation");
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        exit(TRUE);
    end;

    //     LOCAL procedure GetRecElement (MaestraNo@1000 :
    LOCAL procedure GetRecElement(MaestraNo: Code[20])
    begin
        if MaestraNo <> RentalElements."No." then
            RentalElements.GET(MaestraNo);
    end;

    procedure ExistLineDoc(): Boolean;
    begin
        ActivationLine.RESET;
        ActivationLine.SETRANGE("Document No.", "No.");
        exit(ActivationLine.FIND('-'));
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
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Elements Activation", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistLineDoc then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
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
            if ExistLineDoc then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
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
            if ExistLineDoc then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@1002 :
        NewDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;

        ActivationLine.RESET;
        ActivationLine.SETRANGE("Document No.", "No.");
        ActivationLine.LOCKTABLE;
        if ActivationLine.FIND('-') then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(ActivationLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ActivationLine."Dimension Set ID" <> NewDimSetID then begin
                    ActivationLine."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                      ActivationLine."Dimension Set ID", ActivationLine."Shortcut Dimension 1 Code", ActivationLine."Shortcut Dimension 2 Code");
                    ActivationLine.MODIFY;
                end;
            until ActivationLine.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//    }
    end.
  */
}







