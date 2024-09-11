table 7207353 "QBU Element Contract Header"
{


    CaptionML = ENU = 'Element Contract Header', ESP = 'Cabecera contrato elemento';
    LookupPageID = "Rough Copy Contract Elemen Lis";
    DrillDownPageID = "Rough Copy Contract Elemen Lis";

    fields
    {
        field(1; "Document Status"; Option)
        {
            OptionMembers = "Open","Released";
            CaptionML = ENU = 'Document Status', ESP = 'Estado documento';
            OptionCaptionML = ENU = 'Open,Released', ESP = 'Abierto,Lanzado';

            Editable = false;


        }
        field(2; "Customer/Vendor No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Customer")) "Customer" ELSE IF ("Contract Type" = CONST("Vendor")) "Vendor";


            CaptionML = ENU = 'Customer/Vendor No.', ESP = 'No. Cliente/Proveedor';

            trigger OnValidate();
            BEGIN
                //Traemos todos los datos que queramos de la Maestra Primaria
                GetMaestra("Customer/Vendor No.");
                IF "Contract Type" = "Contract Type"::Customer THEN BEGIN
                    Description := Customer.Name;
                    "Description 2" := Customer."Name 2";
                    VALIDATE("Job No.", '');

                    CreateDim(DATABASE::Customer, "Customer/Vendor No.",
                              DATABASE::Job, "Job No.");
                END ELSE BEGIN
                    Description := Vendor.Name;
                    "Description 2" := Vendor."Name 2";
                    VALIDATE("Job No.", '');

                    CreateDim(DATABASE::Vendor, "Customer/Vendor No.",
                              DATABASE::Job, "Job No.");

                END;
            END;


        }
        field(3; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN

                IF "No." <> xRec."No." THEN BEGIN
                    RentalElementsSetup.GET;
                    NoSeriesManagement.TestManual(GetNoSeriesCode);
                    "Serie No." := '';
                END;
            END;


        }
        field(4; "Job No."; Code[20])
        {
            TableRelation = IF ("Contract Type" = CONST("Vendor")) "Job" ELSE IF ("Contract Type" = CONST("Customer")) "Job";


            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';

            trigger OnValidate();
            BEGIN
                IF ExistenLineasDoc THEN
                    ERROR(text021);
                IF "Contract Type" = "Contract Type"::Customer THEN
                    CreateDim(DATABASE::Customer, "Customer/Vendor No.",
                              DATABASE::Job, "Job No.")
                ELSE
                    CreateDim(DATABASE::Vendor, "Customer/Vendor No.",
                              DATABASE::Job, "Job No.");
            END;


        }
        field(5; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripci�n';

            trigger OnValidate();
            BEGIN

                //No se permite dejar la descripci�n vacia
                TESTFIELD(Description);
            END;


        }
        field(6; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';


        }
        field(7; "Contract Date"; Date)
        {
            CaptionML = ENU = 'Contract Date', ESP = 'Fecha contrato';


        }
        field(8; "Contract Type"; Option)
        {
            OptionMembers = "Customer","Vendor";
            CaptionML = ENU = 'Contract Type', ESP = 'Tipo contrato';
            OptionCaptionML = ENU = 'Customer,Vendor', ESP = 'Cliente,Proveedor';



        }
        field(9; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(10; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Descripci�n registro';


        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
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
        field(12; "Shortcut Dimension 2 Code"; Code[20])
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
        field(13; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';


        }
        field(14; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            Editable = false;


        }
        field(15; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Lines Commen Deliv/Ret Element" WHERE("No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(16; "Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Element Contract Lines"."Rent Price" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(17; "Reason Code"; Code[20])
        {
            TableRelation = "Reason Code";
            CaptionML = ENU = 'Reason Code', ESP = 'Cod. auditor�a';


        }
        field(18; "Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie No.', ESP = 'No. serie';
            Editable = false;


        }
        field(19; "Posting Serie No."; Code[20])
        {
            TableRelation = "No. Series";


            CaptionML = ESP = 'No. serie registro';

            trigger OnValidate();
            BEGIN
                IF "Posting Serie No." <> '' THEN BEGIN
                    RentalElementsSetup.GET;
                    TestNoSeries;
                    NoSeriesManagement.TestSeries(GetPostingNoSeriesCode, "Posting Serie No.");
                END;
            END;

            trigger OnLookup();
            BEGIN
                /*To be Tested*/
                // WITH ElementContractHeader DO BEGIN
                ElementContractHeader := Rec;
                RentalElementsSetup.GET;
                TestNoSeries;
                IF NoSeriesManagement.LookupSeries(GetPostingNoSeriesCode, "Posting Serie No.") THEN
                    VALIDATE("Posting Serie No.");
                Rec := ElementContractHeader;
                // END;
            END;


        }
        field(20; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(21; "Vendor Contract Code"; Code[20])
        {
            CaptionML = ENU = 'Vendor Contract Code', ESP = 'C�digo contrato proveedor';


        }
        field(22; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDocDim;
            END;


        }
        field(24; "Elements Situation Line No."; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Rental Elements" WHERE("Contract Filter" = FIELD("No."),
                                                                                              "Delivered Quantity" = FILTER(<> 0)));
            CaptionML = ENU = 'Elements Situation Line No.', ESP = 'No. l�neas situaci�n elemento';
            ;


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
        //       RentalElementsSetup@7001101 :
        RentalElementsSetup: Record 7207346;
        //       NoSeriesManagement@7001102 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       Job@7001100 :
        Job: Record 167;
        //       ElementContractLines@7001103 :
        ElementContractLines: Record 7207354;
        //       Customer@7001104 :
        Customer: Record 18;
        //       Vendor@7001105 :
        Vendor: Record 23;
        //       OldDimSetID@7001106 :
        OldDimSetID: Integer;
        //       DimensionManagement@7001107 :
        DimensionManagement: Codeunit "DimensionManagement";
        DimensionManagement1: Codeunit "DimensionManagement1";
        //       Text051@7001108 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Es posible que haya cambiado la dimensi�n. \\ �Desea actualizar las l�neas?';
        //       Text004@7001109 :
        Text004: TextConst ENU = 'You can not delete a contract with delivery lines. if it is fully returned, file it', ESP = 'No se puede borrar un contrato con lineas entregadas. Si esta totalmente devuelto archivelo';
        //       ElementContractCommentLines@7001110 :
        ElementContractCommentLines: Record 7207355;
        //       text021@7001111 :
        text021: TextConst ENU = 'You can not change the job because there are lines in the contract', ESP = 'No se puede cambiar el proyecto porque hay l�neas en el contrato';
        //       ElementContractHeader@7001112 :
        ElementContractHeader: Record 7207353;



    trigger OnInsert();
    begin
        //Aqui vamos a tomar cual es el contador desde el que vamos a generar n�meros de series.
        RentalElementsSetup.GET;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesManagement.InitSeries(GetNoSeriesCode, xRec."Serie No.", "Posting Date", "No.", "Serie No.");
        end;

        InitializeRecord;
        if GETFILTER("Customer/Vendor No.") <> '' then
            if GETRANGEMIN("Customer/Vendor No.") = GETRANGEMAX("Customer/Vendor No.") then
                VALIDATE("Customer/Vendor No.", GETRANGEMIN("Customer/Vendor No."));

        if GETFILTER("Job No.") <> '' then
            if GETRANGEMIN("Job No.") = GETRANGEMAX("Job No.") then begin
                Job.GET(GETRANGEMIN("Job No."));
                VALIDATE("Customer/Vendor No.", Job."Bill-to Customer No.");
                VALIDATE("Job No.", GETRANGEMIN("Job No."));
            end;

        "Contract Type" := "Contract Type"::Vendor;
    end;

    trigger OnDelete();
    begin
        // Se borran las dimenciones asociadas al documento
        ElementContractLines.LOCKTABLE;
        // Se borran las l�neas asociadas al documento
        ElementContractLines.SETRANGE("Document No.", "No.");
        if ElementContractLines.FINDSET then
            repeat
                ElementContractLines.CALCFIELDS("Delivered Quantity", "Return Quantity");
                if (ElementContractLines."Delivered Quantity" - ElementContractLines."Return Quantity") <> 0 then
                    ERROR(Text004);
            until ElementContractLines.NEXT = 0;
        if ElementContractLines.FINDSET then
            ElementContractLines.DELETEALL;

        //Se borran los comentarios asociados
        ElementContractCommentLines.SETRANGE("No.", "No.");
        ElementContractCommentLines.DELETEALL;
    end;



    LOCAL procedure TestNoSeries()
    begin
    end;

    LOCAL procedure GetNoSeriesCode(): Code[20];
    begin
    end;

    LOCAL procedure GetPostingNoSeriesCode(): Code[20];
    begin
        exit(RentalElementsSetup."No. Serie Contract");
    end;

    LOCAL procedure InitializeRecord()
    begin
    end;

    //     procedure AssistEdit (PElementContractHeader@1000 :
    procedure AssistEdit(PElementContractHeader: Record 7207353): Boolean;
    begin
        RentalElementsSetup.GET;
        TestNoSeries;
        if NoSeriesManagement.SelectSeries(GetNoSeriesCode, PElementContractHeader."Serie No.", "Serie No.") then begin
            RentalElementsSetup.GET;
            TestNoSeries;
            NoSeriesManagement.SetSeries("No.");
            exit(TRUE);
        end;
    end;

    procedure ConfirmDeletion(): Boolean;
    begin
        //Aqui estableceremos las condiciones de borrado de la cabecera, se llama a una funci�n que lo comprueba
        //PurchPost.TestDeleteHeader(Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,ReturnShptHeader);

        exit(TRUE);
    end;

    //     LOCAL procedure GetMaestra (MasterNo@1000 :
    LOCAL procedure GetMaestra(MasterNo: Code[20])
    begin
        if "Contract Type" = "Contract Type"::Customer then
            Customer.GET(MasterNo)
        else
            Vendor.GET(MasterNo);
    end;

    procedure ExistenLineasDoc(): Boolean;
    begin
        ElementContractLines.RESET;
        ElementContractLines.SETRANGE("Document No.", "No.");
        exit(ElementContractLines.FINDSET);
    end;

    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1100251001 : Integer;No2@1100251000 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
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
        TableID[2] := Type2;
        No[2] := No2;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimensionManagement.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimensionManagement.GetDefaultDimID(DefaultDimSource, SourceCodeSetup."Rent Delivery", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ExistenLineasDoc then begin
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
            if ExistenLineasDoc then
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
            if ExistenLineasDoc then
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

        ElementContractLines.RESET;
        ElementContractLines.SETRANGE("Document No.", "No.");
        ElementContractLines.LOCKTABLE;
        if ElementContractLines.FIND('-') then
            repeat
                NewDimSetID := DimensionManagement.GetDeltaDimSetID(ElementContractLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ElementContractLines."Dimension Set ID" <> NewDimSetID then begin
                    ElementContractLines."Dimension Set ID" := NewDimSetID;
                    DimensionManagement.UpdateGlobalDimFromDimSetID(
                      ElementContractLines."Dimension Set ID", ElementContractLines."Shortcut Dimension 1 Code", ElementContractLines."Shortcut Dimension 2 Code");
                    ElementContractLines.MODIFY;
                end;
            until ElementContractLines.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 15/09/21: - QB 1.09.17 se amplia el retorno de las funciones GetNoSeriesCode y GetPostingNoSeriesCode de 10 a 20
//    }
    end.
  */
}







