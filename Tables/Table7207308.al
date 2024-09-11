table 7207308 "QBU Output Shipment Header"
{


    CaptionML = ENU = 'Warehouse Shipment Header', ESP = 'Cabecera Salida Almac�n Obra';
    LookupPageID = "Output Shipment List";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'No. Proyecto';

            trigger OnValidate();
            BEGIN
                // Datemos un error si se va a modificar un proyecto y existen l�neas.
                IF "Job No." <> xRec."Job No." THEN BEGIN
                    OutputShipmentLines.RESET;
                    OutputShipmentLines.SETRANGE("Document No.", "No.");
                    IF OutputShipmentLines.FINDFIRST THEN
                        ERROR(Text002);
                END;

                // Traemos todos los datos que queramos de la tabla maestra (proyecto)
                GetJob("Job No.");

                Description := Job.Description;
                "Description 2" := Job."Description 2";

                CreateDim(DATABASE::Job, "Job No.");

                GetCAGroupJob;
            END;


        }
        field(2; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';
            Description = 'Key 1';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    //QuoBuildingSetup.GET;  //JAV se traslada al TestSerieNo y a GetNoSeriesCode
                    NoSeriesManagement.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
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
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'Cod. dim. acceso dire. 1';
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
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Receipt"),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(10; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Output Shipment Lines"."Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;


        }
        field(11; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'C�digo auditor�a';


        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. Series', ESP = 'No. serie';
            Editable = false;


        }
        field(13; "Posting Series No."; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ENU = 'Posting Series No.', ESP = 'N� serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting Series No." <> '' THEN BEGIN
                    //QuoBuildingSetup.GET;  //JAV se traslada al TestSerieNo y a GetNoSeriesCode
                    TestSerieNo;
                    NoSeriesManagement.TestSeries(GetNoSeriesCode, "Posting Series No.");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH OutputShipmentHeading DO BEGIN
                OutputShipmentHeading := Rec;
                //QuoBuildingSetup.GET;  //JAV se traslada al TestSerieNo y a GetNoSeriesCode
                TestSerieNo;
                IF NoSeriesManagement.LookupSeries(GetNoSeriesCode, "Posting Series No.") THEN
                    VALIDATE("Posting Series No.");
                Rec := OutputShipmentHeading;
                // END;
            END;


        }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(15; "Request Date"; Date)
        {
            CaptionML = ENU = 'Request Date', ESP = 'Fecha solicitud';


        }
        field(16; "Stock Regulation"; Boolean)
        {
            CaptionML = ENU = 'Stock Regulation', ESP = 'Regulaci�n stock';


        }
        field(17; "Sales Shipment Origin"; Boolean)
        {
            CaptionML = ENU = 'Sales Shipment Origin', ESP = 'Origen albar�n ventas';
            Editable = false;


        }
        field(18; "Sales Document No."; Code[20])
        {
            CaptionML = ENU = 'Sales Document No.', ESP = 'No. documento ventas';


        }
        field(19; "Documnet Type"; Option)
        {
            OptionMembers = "Shipment","Invoice","Credir Memo","Receipt.Return";
            CaptionML = ENU = 'Documnet Type', ESP = 'Tipo de documento';
            OptionCaptionML = ENU = 'Shipment,Invoice,Credir Memo,Receipt.Return', ESP = 'Albaran,Factura,Abono,Recep.Devolucion';



        }
        field(20; "Total Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Output Shipment Lines"."Total Cost" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';


        }
        field(21; "Total Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Output Shipment Lines"."Quantity" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Quantity', ESP = 'Cantidad total';


        }
        field(22; "Responsability Center"; Code[10])
        {
            TableRelation = "Responsibility Center";


            CaptionML = ENU = 'Responsability Center', ESP = 'Centro responsabiidad';

            trigger OnValidate();
            VAR
                //                                                                 HasGotSalesUserSetup@7001100 :
                HasGotSalesUserSetup: Boolean;
                //                                                                 UserRespCenter@7001101 :
                UserRespCenter: Code[10];
            BEGIN
                IF NOT UserSetupManagement.CheckRespCenter(3, "Responsability Center") THEN BEGIN
                    FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
                    ERROR(Text027, ResponsibilityCenter.TABLECAPTION, HasGotSalesUserSetup);
                END;
            END;


        }
        field(23; "Automatic Shipment"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Automatic Shipment', ESP = 'Albar�n autom�tico';
            Description = 'QB 1.08.32 Si viene de un albar�n de compra';
            Editable = false;


        }
        field(24; "Purchase Rcpt. No."; Code[20])
        {
            TableRelation = "Purch. Rcpt. Header";
            CaptionML = ENU = 'Purchase Shipment No.', ESP = 'No. albar�n compra';
            Editable = false;


        }
        field(25; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimesnion Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
        field(52; "Cancellation"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cancellation', ESP = 'Cancelaci�n';
            Description = 'AML QB_ST01';


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
        key(key2; "Job No.")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@1100286000 :
        QuoBuildingSetup: Record 7207278;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       OutputShipmentLines@7001102 :
        OutputShipmentLines: Record 7207309;
        //       Text003@7001103 :
        Text003: TextConst ENU = 'You cann�t rename a %1', ESP = 'No se puede cambiar el nombre a %1';
        //       QBCommentLine@7001104 :
        QBCommentLine: Record 7207270;
        //       Text002@7001105 :
        Text002: TextConst ENU = 'To change the job, you must delete the outgoing delivery lines', ESP = 'Para cambiar el proyecto debe de eliminar las l�neas de albar�n de salida';
        //       Job@7001106 :
        Job: Record 167;
        //       OutputShipmentHeading@7001107 :
        OutputShipmentHeading: Record 7207308;
        //       UserSetupManagement@7001108 :
        UserSetupManagement: Codeunit 5700;
        //       Text027@7001109 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 to %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 a %2.';
        //       ResponsibilityCenter@7001110 :
        ResponsibilityCenter: Record 5714;
        //       Text001@7001111 :
        Text001: TextConst ENU = 'Output shipment: %1', ESP = 'Albar�n de salida: %1';
        //       CJob@7001112 :
        CJob: Code[20];
        //       OldDimSetID@7001113 :
        OldDimSetID: Integer;
        //       DimensionManagement@7001114 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       JobPostingGroup@7001115 :
        JobPostingGroup: Record 208;
        //       FunctionQB@7001116 :
        FunctionQB: Codeunit 7207272;
        //       Text051@7001117 :
        Text051: TextConst ENU = 'You may have changed a dimension.\Do you want to update the lines?', ESP = 'Es posible que haya cambiado una dimensi�n. \ �Desea actualizar las l�neas?';
        //       InventoryPostingSetup@1100286001 :
        InventoryPostingSetup: Record 5813;



    trigger OnInsert();
    begin
        // Aqui vamos a tomar cual es el contador desde el qe vamos a generar n�meros de series.
        //QuoBuildingSetup.GET;   //JAV se traslada al TestSerieNo y a GetNoSeriesCode
        if "No." = '' then begin
            TestSerieNo;
            NoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord;
        //JAV 09/07/19: - Se traslada esto a una funci�n
        // if GETFILTER("Job No.") <> '' then
        //  if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
        //    VALIDATE("Job No.",GETRANGEMIN("Job No."));
        //
        // // Si entro en la tabla desde proyecto, heredo de forma autom�tica el proyecto desde el que vengo.
        // FILTERGROUP(2);
        // if (HASFILTER and  (GETFILTER("Job No.") <> '')) then
        //  VALIDATE("Job No.",GETFILTER("Job No."));
        // FILTERGROUP(0);
        GetJobNo;
    end;

    trigger OnDelete();
    begin
        OutputShipmentLines.LOCKTABLE;

        // Se borran las l�neas asociadas al documento
        OutputShipmentLines.SETRANGE("Document No.", "No.");
        OutputShipmentLines.DELETEALL;

        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        ERROR(Text003, TABLECAPTION);
    end;



    LOCAL procedure TestSerieNo(): Boolean;
    begin
        //JAV 09/07/19: - Se toma la serie del proyecto o de la configuraci�n de inventario
        QuoBuildingSetup.GET;
        if (QuoBuildingSetup."Series for Job") then begin
            GetJobNo;
            Job.GET("Job No.");
            Job.TESTFIELD("Serie Registro Salida Almacen");
        end else begin
            QuoBuildingSetup.TESTFIELD("Serie for Output Shipmen");
        end;
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
        //JAV 09/07/19: - Se toma la serie del proyecto o de la configuraci�n de inventario
        QuoBuildingSetup.GET;
        if (QuoBuildingSetup."Series for Job") then begin
            GetJobNo;
            Job.GET("Job No.");
            exit(Job."Serie Registro Salida Almacen");
        end else begin
            exit(QuoBuildingSetup."Serie for Output Shipmen");
        end;
    end;

    procedure InitRecord()
    begin
        // QuoBuildingSetup.GET;

        //JAV 09/07/19: - Se cambia a la llamada de la funci�n que nos da la erie de registro
        //NoSeriesManagement.SetDefaultSeries("Posting Series No.",QuoBuildingSetup."Output Ship. Posting Serie No.");
        NoSeriesManagement.SetDefaultSeries("Posting Series No.", GetNoSeriesCode);

        "Posting Date" := WORKDATE;
        // Vamos a rellenar la descripci�n ALB-Salida: N� de serie
        "Posting Description" := STRSUBSTNO(Text001, "No.");
        "Request Date" := WORKDATE;
    end;

    //     LOCAL procedure GetJob (PJob@7001100 :
    LOCAL procedure GetJob(PJob: Code[20])
    begin
        if PJob <> Job."No." then
            Job.GET(PJob);
    end;

    //     procedure CreateDim (Type1@7001100 : Integer;No1@7001101 :
    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        //       SourceCodeSetup@7001102 :
        SourceCodeSetup: Record 242;
        //       TableID@7001103 :
        TableID: ARRAY[10] OF Integer;
        //       No@7001104 :
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
        "Dimension Set ID" := DimensionManagement.GetDefaultDimID(DefaultDimSource, SourceCodeSetup.Purchases, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistLinShipmentOutput then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure GetCAGroupJob()
    begin
        // Proponemos e CA Vta del GCProy varLocal: GCProy
        if Job.GET("Job No.") then begin
            ;
            //JAV 22/09/21: - QB 1.09.19 Se usa el valor correcto para el CA, el que usaba era el de unidades de venta que no tiene sentido, lo dejo en blanco y lo pongo desde las l�neas.
            //Job.TESTFIELD("Job Posting Group");
            //JobPostingGroup.GET(Job."Job Posting Group");
            //FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA,JobPostingGroup."Sales Analytic Concept","Dimension Set ID");

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, '', "Dimension Set ID");


            DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        end;
    end;

    //     procedure ValidateShortcutDimCode (FieldNumber@7001100 : Integer;var ShortcurDimCode@7001101 :
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcurDimCode: Code[20])
    begin
        OldDimSetID := "Dimension Set ID";
        DimensionManagement.ValidateShortcutDimValues(FieldNumber, ShortcurDimCode, "Dimension Set ID");
        if "No." <> '' then
            MODIFY;

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLinShipmentOutput then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    var
        //       OldDimSetID@7001100 :
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimensionManagement1.EditDimensionSet2(
                                             "Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."),
                                             "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if ExistLinShipmentOutput then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    //     procedure AssistEdit (OutputShipmentHeading@7001100 :
    procedure AssistEdit(OutputShipmentHeading: Record 7207308): Boolean;
    begin
        //QuoBuildingSetup.GET;  //JAV se traslada al TestSerieNo y a GetNoSeriesCode
        TestSerieNo;
        if NoSeriesManagement.SelectSeries(GetNoSeriesCode, OutputShipmentHeading."No. Series", "No. Series") then begin
            //QuoBuildingSetup.GET;  //JAV se traslada al TestSerieNo y a GetNoSeriesCode
            TestSerieNo;
            NoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        // Aqu� establecemos las condiciones de borrado de la cabecera, se llama a una funci�n que lo comprueba

        exit(TRUE);
    end;

    procedure ExistLinShipmentOutput(): Boolean;
    begin
        OutputShipmentLines.RESET;
        OutputShipmentLines.SETRANGE("Document No.", "No.");
        exit(OutputShipmentLines.FINDFIRST);
    end;

    //     LOCAL procedure UpdateAllLineDim (NewParentDimSetID@7001100 : Integer;OldParentDimSetID@7001101 :
    LOCAL procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        //       NewDimSetID@7001102 :
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text051) then
            exit;
        OutputShipmentLines.RESET;
        OutputShipmentLines.SETRANGE("Document No.", "No.");
        OutputShipmentLines.LOCKTABLE;
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if OutputShipmentLines.FINDSET(TRUE,FALSE) then
        if OutputShipmentLines.FINDSET(TRUE) then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(OutputShipmentLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if OutputShipmentLines."Dimension Set ID" <> NewDimSetID then begin
                    OutputShipmentLines."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                      OutputShipmentLines."Dimension Set ID", OutputShipmentLines."Shortcut Dimension 1 Code", OutputShipmentLines."Shortcut Dimension 2 Code");
                    OutputShipmentLines.MODIFY;
                end;
            until OutputShipmentLines.NEXT = 0;
    end;

    //     procedure FilterResponsability (var ShipmentFilter@7001100 :
    procedure FilterResponsability(var ShipmentFilter: Record 7207308)
    var
        //       HasGotSalesUserSetup@7001101 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001102 :
        UserRespCenter: Code[10];
    begin
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);

        if UserRespCenter <> '' then begin
            ShipmentFilter.FILTERGROUP(2);
            ShipmentFilter.SETRANGE("Responsability Center", UserRespCenter);
            ShipmentFilter.FILTERGROUP(0);
        end;
    end;

    LOCAL procedure GetJobNo()
    var
        //       txtFilter@1100286000 :
        txtFilter: Text;
    begin
        //JAV 09/07/19: - Se traslada a este lugar
        if ("Job No." = '') then begin
            if GETFILTER("Job No.") <> '' then
                if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then
                    VALIDATE("Job No.", GETRANGEMIN("Job No."));

            // Si entro en la tabla desde proyecto, heredo de forma autom�tica el proyecto desde el que vengo.
            FILTERGROUP(2);
            txtFilter := GETFILTER("Job No.");
            if (STRLEN(txtFilter) <= MAXSTRLEN("Job No.")) then
                if (Job.GET(txtFilter)) then
                    VALIDATE("Job No.", GETFILTER("Job No."));
            FILTERGROUP(0);

        end;
    end;

    /*begin
    //{
//      JAV 09/07/19: - Se usa una serie por cada proyecto si est� configurado, se elimina la funci�n "GetPostingNoSeriesCode" que estaba duplicada
//                    - Se crea una funci�n para obtener el c�digo del proyecto
//      JAV 03/07/21: - QB 1.09.04 Se amplia el retorno de la funci�n GetNoSeriesCode de 10 a 20
//
//      CPA 03-12-21: - QB 1.10.23 (Q15921). Errores detectados en almacenes de obras. Se a�ade la clave "Purchase Rcpt. No."
//      AML 24/03/22 QB_ST01 A�adido campo cancelado.
//    }
    end.
  */
}







