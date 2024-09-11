table 7207356 "Header Delivery/Return Element"
{


    CaptionML = ENU = 'Header Delivery/Return Element', ESP = 'Cab. entrega/devol elemen';
    LookupPageID = "Element Delivery List";

    fields
    {
        field(1; "Contract Code"; Code[20])
        {
            TableRelation = "Element Contract Header"."No." WHERE("Customer/Vendor No." = FIELD("Customer/Vendor No."),
                                                                                                      "Job No." = CONST('Job No.'),
                                                                                                      "Document Status" = CONST("Released"));


            CaptionML = ENU = 'Contract Code', ESP = 'Cod. contrato';

            trigger OnValidate();
            BEGIN
                // Traemos todos los datos que queramos de la Maestra Primaria
                GetRecHeaderContract("Contract Code");

                Description := ElementContractHeader.Description;
                "Description 2" := ElementContractHeader."Description 2";
                IF ElementContractHeader."No." <> '' THEN BEGIN
                    "Contract Type" := ElementContractHeader."Contract Type";
                    "Customer/Vendor No." := ElementContractHeader."Customer/Vendor No.";
                    "Job No." := ElementContractHeader."Job No.";

                END;
                IF "Contract Type" = "Contract Type"::Customer THEN
                    CreateDim(DATABASE::Customer, "Customer/Vendor No.",
                              DATABASE::Job, "Job No.")
                ELSE
                    CreateDim(DATABASE::Vendor, "Customer/Vendor No.",
                              DATABASE::Job, "Job No.");

                CopyDimensionsContract("Contract Code", "No.");

                ExistLine(Rec);
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
                    "Series No." := '';
                END;
            END;


        }
        field(3; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(4; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(5; "Document Type"; Option)
        {
            OptionMembers = "Delivery","Return";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Delivery,Return', ESP = 'Entrega,Devoluci�n';



        }
        field(6; "Order Date"; Date)
        {
            CaptionML = ENU = 'Order Date', ESP = 'Fecha pedido';


        }
        field(7; "Rent Effective Date"; Date)
        {
            CaptionML = ENU = 'Rent Effective Date', ESP = 'Fecha efectiva alquiler';


        }
        field(8; "Customer/Vendor No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Customer" ELSE IF ("Contract Type" = CONST("Vendor")) "Vendor";


            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'No. Cliente/Proveedor';

            trigger OnValidate();
            BEGIN
                ExistLine(Rec);
                "Job No." := '';
                "Contract Code" := '';
                IF "Contract Type" = "Contract Type"::Customer THEN
                    CreateDim(DATABASE::Customer, "Customer/Vendor No.",
                             DATABASE::Job, "Job No.")
                ELSE
                    CreateDim(DATABASE::Vendor, "Customer/Vendor No.",
                             DATABASE::Job, "Job No.");
            END;


        }
        field(9; "Job No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Vendor")) "Job" ELSE IF ("Contract Type" = CONST("Customer")) "Job";


            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';

            trigger OnValidate();
            BEGIN
                ExistLine(Rec);
                "Contract Code" := '';
                IF "Contract Type" = "Contract Type"::Customer THEN
                    CreateDim(DATABASE::Job, "Job No.",
                      DATABASE::Customer, "Customer/Vendor No.")
                ELSE
                    CreateDim(DATABASE::Job, "Job No.",
                      DATABASE::Vendor, "Customer/Vendor No.");
            END;


        }
        field(10; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(11; "Posting Date"; Date)
        {


            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';

            trigger OnValidate();
            BEGIN
                "Rent Effective Date" := "Posting Date";
            END;


        }
        field(12; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Descripción registro';


        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(15; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';


        }
        field(16; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(17; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Line Delivery/Return Element" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(18; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Line Delivery/Return Element"."Unit Price" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = CurrencyCode;


        }
        field(19; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. registro';


        }
        field(20; "Series No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Series No.', ESP = 'No. series';
            Editable = false;


        }
        field(21; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting No. Series', ESP = 'No. series registro';

            trigger OnValidate();
            BEGIN
                IF "Posting No. Series" <> '' THEN BEGIN
                    RentalElementsSetup.GET;
                    TestNoSeries;
                    NoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH HeaderDeliveryReturnElement DO BEGIN
                HeaderDeliveryReturnElement := Rec;
                RentalElementsSetup.GET;
                TestNoSeries;
                IF NoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") THEN
                    VALIDATE("Posting No. Series");
                Rec := HeaderDeliveryReturnElement;
                // END;
            END;


        }
        field(22; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(23; "Weight to Handle"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Line Delivery/Return Element"."Weight to Manipulate" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Weight to Handle', ESP = 'Peso a manipular';
            Editable = false;


        }
        field(24; "Elements Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Line Delivery/Return Element"."Quantity" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Elements Quantity', ESP = 'Cantidad de elementos';
            Editable = false;


        }
        field(25; "Dimensions Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimensions Set ID', ESP = 'Id. grupo dimensiones';
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
        //       CurrencyCode@7001100 :
        CurrencyCode: Text;
        //       RentalElementsSetup@7001101 :
        RentalElementsSetup: Record 7207346;
        //       NoSeriesManagement@7001102 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       ElementContractHeader@7001103 :
        ElementContractHeader: Record 7207353;
        //       LineDeliveryReturnElement@7001104 :
        LineDeliveryReturnElement: Record 7207357;
        //       LinesCommenDelivRetElement@7001105 :
        LinesCommenDelivRetElement: Record 7207358;
        //       Text003@7001106 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       HeaderDeliveryReturnElement@7001107 :
        HeaderDeliveryReturnElement: Record 7207356;
        //       OldDimSetID@7001108 :
        OldDimSetID: Integer;
        //       DimensionManagement@7001109 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       Text004@7001110 :
        Text004: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n. \\ �Desea actualizar las l�neas?';



    trigger OnInsert();
    begin
        // Aqui vamos a tomar cual es el contador desde el que vamos a generar n�meros de series.
        RentalElementsSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."Series No.", "Posting Date", "No.", "Series No.");
        end;

        InitRecord;
        if GETFILTER("Contract Code") <> '' then begin
            if GETRANGEMIN("Contract Code") = GETRANGEMAX("Contract Code") then begin
                "Contract Code" := GETRANGEMIN("Contract Code");
                GetRecHeaderContract("Contract Code");

                if ElementContractHeader."No." <> '' then begin
                    "Contract Type" := ElementContractHeader."Contract Type";
                    "Customer/Vendor No." := ElementContractHeader."Customer/Vendor No.";
                    "Job No." := ElementContractHeader."Job No.";
                end;
                VALIDATE("Contract Code");
            end;
        end else begin
            if GETFILTER("Customer/Vendor No.") <> '' then
                if GETRANGEMIN("Customer/Vendor No.") = GETRANGEMAX("Customer/Vendor No.") then
                    VALIDATE("Customer/Vendor No.", GETRANGEMIN("Customer/Vendor No."));

            if GETFILTER("Job No.") <> '' then
                if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                    VALIDATE("Job No.", GETRANGEMIN("Job No."));
        end;
    end;

    trigger OnDelete();
    begin
        LineDeliveryReturnElement.LOCKTABLE;

        //Se borran las l�neas asociadas al documento
        LineDeliveryReturnElement.SETRANGE("Document No.", "No.");
        LineDeliveryReturnElement.DELETEALL;


        LinesCommenDelivRetElement.SETRANGE("No.", "No.");
        LinesCommenDelivRetElement.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure TestNoSeries(): Boolean;
    begin
        if "Document Type" = "Document Type"::Delivery then
            RentalElementsSetup.TESTFIELD(RentalElementsSetup."Nº Serie Delivery")
        else
            RentalElementsSetup.TESTFIELD(RentalElementsSetup."Nº Serie Delivery");
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        if "Document Type" = "Document Type"::Delivery then
            exit(RentalElementsSetup."Nº Serie Delivery")
        else
            exit(RentalElementsSetup."No. Serie Returns")
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        if "Document Type" = "Document Type"::Delivery then
            exit(RentalElementsSetup."No. Serie Post. Delivery")
        else
            exit(RentalElementsSetup."No. Serie Post. Return")
    end;

    procedure InitRecord()
    begin
        if "Document Type" = "Document Type"::Delivery then
            NoSeriesManagement.SetDefaultSeries("Posting No. Series", RentalElementsSetup."No. Serie Post. Delivery")
        else
            NoSeriesManagement.SetDefaultSeries("Posting No. Series", RentalElementsSetup."No. Serie Post. Return");

        "Posting Date" := WORKDATE;
        "Order Date" := WORKDATE;
        "Rent Effective Date" := WORKDATE;

        "Posting Description" := "No.";
    end;

    //     LOCAL procedure GetRecHeaderContract (MaestraNo@7001100 :
    LOCAL procedure GetRecHeaderContract(MaestraNo: Code[20])
    begin
        if MaestraNo <> ElementContractHeader."No." then
            ElementContractHeader.GET(MaestraNo);
    end;

    //     procedure CreateDim (Type1@7001103 : Integer;No1@7001102 : Code[20];Type2@7001101 : Integer;No2@7001100 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        //       SourceCodeSetup@7001104 :
        SourceCodeSetup: Record 242;
        //       TableID@7001106 :
        TableID: ARRAY[10] OF Integer;
        //       No@7001105 :
        No: ARRAY[10] OF Code[20];
        //Adding the argument as needed for GetDefaultDimID method
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        OldDimSetID := "Dimensions Set ID";
        "Dimensions Set ID" :=
          DimensionManagement.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Rent Delivery", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimensions Set ID") and ExistLinesDoc then begin
            MODIFY;
            UpdateAllLineDim("Dimensions Set ID", OldDimSetID);
        end;

        CopyDimensionsContract("Contract Code", "No.");
    end;

    //     procedure CopyDimensionsContract (ContractCode@7001100 : Code[20];DeliveryCode@7001101 :
    procedure CopyDimensionsContract(ContractCode: Code[20]; DeliveryCode: Code[20])
    var
        //       HeaderDeliveryReturnElement@7001102 :
        HeaderDeliveryReturnElement: Record 7207356;
        //       FunctionQB@7001103 :
        FunctionQB: Codeunit 7207272;
        //       DimensionSetEntry@7001104 :
        DimensionSetEntry: Record 480 TEMPORARY;
    begin
        if not HeaderDeliveryReturnElement.GET(DeliveryCode) then
            exit;

        DimensionSetEntry.DELETEALL;  //JAV 21/09/21: - QB 1.09.19 Se pasa la tabla a temporal
        DimensionManagement.GetDimensionSet(DimensionSetEntry, "Dimensions Set ID");
        if DimensionSetEntry.FINDSET then
            repeat
                FunctionQB.UpdateDimSet(DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code", "Dimensions Set ID");
                DimensionManagement.UpdateGlobalDimFromDimSetID("Dimensions Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            until DimensionSetEntry.NEXT = 0;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@7001101 : Integer;var ShortcutDimCode@7001100 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OldDimSetID := "Dimensions Set ID";
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimensions Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimensions Set ID" then begin
            MODIFY;
            if ExistLinesDoc then
                UpdateAllLineDim("Dimensions Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    begin
        OldDimSetID := "Dimensions Set ID";
        "Dimensions Set ID" :=
          DimensionManagement1.EditDimensionSet2(
            "Dimensions Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimensions Set ID" then begin
            MODIFY;
            if ExistLinesDoc then
                UpdateAllLineDim("Dimensions Set ID", OldDimSetID);
        end;
    end;

    //     procedure AssistEdit (PHeaderDeliveryReturnElement@7001100 :
    procedure AssistEdit(PHeaderDeliveryReturnElement: Record 7207356): Boolean;
    begin
        RentalElementsSetup.GET;
        TestNoSeries;
        if NoSeriesManagement.SelectSeries(GetNoSeriesCode, PHeaderDeliveryReturnElement."Series No.", "Series No.") then begin
            RentalElementsSetup.GET;
            TestNoSeries;
            NoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        //Aqui estableceremos las condiciones de borrado de la cabecera, se llama a una funci�n que lo comprueba
        exit(TRUE);
    end;

    procedure ExistLinesDoc(): Boolean;
    begin
        LineDeliveryReturnElement.RESET;
        LineDeliveryReturnElement.SETRANGE("Document No.", "No.");
        exit(LineDeliveryReturnElement.FIND('-'));
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

        LineDeliveryReturnElement.RESET;
        LineDeliveryReturnElement.SETRANGE("Document No.", "No.");
        LineDeliveryReturnElement.LOCKTABLE;
        if LineDeliveryReturnElement.FIND('-') then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(LineDeliveryReturnElement."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if LineDeliveryReturnElement."Dimension Set ID" <> NewDimSetID then begin
                    LineDeliveryReturnElement."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                      LineDeliveryReturnElement."Dimension Set ID", LineDeliveryReturnElement."Shortcut Dimensios 1 Code", LineDeliveryReturnElement."Shortcut Dimension 2 Code");
                    LineDeliveryReturnElement.MODIFY;
                end;
            until LineDeliveryReturnElement.NEXT = 0;
    end;

    //     procedure ExistLine (PHeaderDeliveryReturnElement@7001100 :
    procedure ExistLine(PHeaderDeliveryReturnElement: Record 7207356)
    var
        //       Text0100@7001101 :
        Text0100: TextConst ENU = 'The shipping document can not be modified because it has associated lines', ESP = 'No puede modificarse el documento de env�o porque tiene l�neas asociadas';
        //       VLineDeliveryReturnElement@7001102 :
        VLineDeliveryReturnElement: Record 7207357;
    begin
        VLineDeliveryReturnElement.SETRANGE(VLineDeliveryReturnElement."Document No.", PHeaderDeliveryReturnElement."No.");
        if VLineDeliveryReturnElement.FINDFIRST then
            ERROR(Text0100);
    end;

    /*begin
    //{
//      - Al no haber "Document Type" tomamos el tipo 6 que es blanco
//      - dar de alta tipo nuevo en la tabla 357
//      - codigo de origen nuevo en T242- Conf de codigos de origen
//
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//    }
    end.
  */
}







