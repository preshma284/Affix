table 7207344 "QBU Rental Elements"
{


    CaptionML = ENU = 'Rental Elements', ESP = 'Elementos de alquiler';
    LookupPageID = "Rental Elements List";
    DrillDownPageID = "Rental Elements List";

    fields
    {
        field(1; "No."; Code[20])
        {


            CaptionML = ENU = 'No.', ESP = 'No.';

            trigger OnValidate();
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesManagement.TestManual(RentalElementsSetup."Element No. Series");
                    "Serie No." := '';
                END;
                //configuraci�n
            END;


        }
        field(2; "Description"; Text[50])
        {


            CaptionML = ENU = 'Description', ESP = 'Descripci�n';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Description);

                IF (Alias = UPPERCASE(xRec.Description)) OR (Alias = '') THEN
                    Alias := Description;
            END;


        }
        field(3; "Alias"; Code[50])
        {
            CaptionML = ENU = 'Alias', ESP = 'Alias';


        }
        field(4; "Description 2"; Text[50])
        {


            CaptionML = ENU = 'Description 2', ESP = 'Descripci�n 2';

            trigger OnValidate();
            BEGIN
                // Ejemplo de validate de campo que esta en funci�n de otro y se ejecuta desde el formulario, ver plantilla
                // maestra con borrador.
                IF Description = '' THEN
                    ERROR(Text000);
            END;


        }
        field(5; "Base Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Base Unit of Measure', ESP = 'Unidad de medida base';


        }
        field(6; "Product Posting Group"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
            CaptionML = ENU = 'Product Posting Group', ESP = 'Grupo contable producto';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(7; "Product VAT Posting Group"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            CaptionML = ENU = 'Product VAT Posting Group', ESP = 'Grupo registro IVA prod.';
            Description = 'QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(8; "Rent Price/Time Unit"; Decimal)
        {
            CaptionML = ENU = 'Rent Price/Time Unit', ESP = 'Precio alquiler/und. tiempo';
            MinValue = 0;
            AutoFormatType = 2;


        }
        field(9; "Posting Group"; Code[10])
        {
            TableRelation = "Element Posting Group";
            CaptionML = ENU = 'Posting Group', ESP = 'Familia';


        }
        field(10; "Element Type"; Option)
        {
            OptionMembers = "Single","Element List";
            CaptionML = ENU = 'Element Type', ESP = 'Tipo de elemento';
            OptionCaptionML = ENU = 'Single,Element List', ESP = 'Individual,Lista de elementos';



        }
        field(11; "Element List Handle"; Option)
        {
            OptionMembers = " ","Area","Volume","Unit";
            CaptionML = ENU = 'Element List Handle', ESP = 'Gesti�n lista elementos';
            OptionCaptionML = ENU = '" ,Area,Volume,Unit"', ESP = '" ,Superficie,Volumen,Unitario"';



        }
        field(12; "Element Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Element Serie No.', ESP = 'No. serie elementos';


        }
        field(13; "Related Product"; Code[20])
        {
            TableRelation = "Item";


            CaptionML = ENU = 'Related Product', ESP = 'Producto relacionado';

            trigger OnValidate();
            BEGIN
                IF "Related Product" <> xRec."Related Product" THEN BEGIN
                    IF xRec."Related Product" <> '' THEN BEGIN
                        Item.GET(xRec."Related Product");
                        Item."QB Rent Element Code" := '';
                        Item."QB Rentable" := FALSE;
                        Item.MODIFY;
                    END;
                    IF "Related Product" <> '' THEN BEGIN
                        Item.GET("Related Product");
                        Item."QB Rent Element Code" := "No.";
                        Item."QB Rentable" := TRUE;
                        Item.MODIFY;
                    END;
                END;
            END;


        }
        field(14; "Bill of Materials"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Rent Element LM" WHERE("Rent Elements Code" = FIELD("No.")));
            CaptionML = ENU = 'Bill of Materials', ESP = 'Lista de Materiales';


        }
        field(15; "Global Dimensions 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));


            CaptionML = ENU = 'Global Dimesnions 1 Code', ESP = 'Cod. dimensi�n global 1';
            CaptionClass = '1,1,1';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(1, "Global Dimensions 1 Code");
                MODIFY;
            END;


        }
        field(16; "Global Dimensions 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            CaptionML = ENU = 'Global Dimensions 2 Code', ESP = 'Cod. dimensi�n global 2';
            CaptionClass = '1,1,2';

            trigger OnValidate();
            BEGIN
                ValidateShortcutDimCode(2, "Global Dimensions 2 Code");
                MODIFY;
            END;


        }
        field(17; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("IC Partner"),
                                                                                           "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(18; "Blocked"; Boolean)
        {
            CaptionML = ENU = 'Blocked', ESP = 'Bloqueado';


        }
        field(19; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified', ESP = 'Fecha �lt. modificaci�n';
            Editable = false;


        }
        field(20; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(21; "Global Dimension 1 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Global Dimension 1 Filter', ESP = 'Filtro dimensi�n global 1';
            CaptionClass = '1,3,1';


        }
        field(22; "Global Dimension 2 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Global Dimension 2 Filter', ESP = 'Filtro dimensi�n global 2';
            CaptionClass = '1,3,2';


        }
        field(23; "Serie No."; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Serie No.', ESP = 'No. Serie';
            Editable = false;


        }
        field(24; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Elements Entries"."Unit Price" WHERE("Element No." = FIELD("No."),
                                                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter")));
            CaptionML = ENU = 'Total Amount', ESP = 'Importe total';


        }
        field(25; "Delivered Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Elements Entries"."Quantity" WHERE("Element No." = FIELD("No."),
                                                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                                                             "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                                             "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                                             "Entry Type" = CONST("Delivery"),
                                                                                                             "Customer No." = FIELD("Customer Filter"),
                                                                                                             "Job No." = FIELD("Job Filter"),
                                                                                                             "Contract No." = FIELD("Contract Filter")));
            CaptionML = ENU = 'Delivered Quantity', ESP = 'Cantidad entregadas';


        }
        field(26; "Entry Type Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Entry Type Filter', ESP = 'Filtro tipo movimiento';


        }
        field(27; "Filter Code"; Code[20])
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Filter Code', ESP = 'C�digo Filtro';


        }
        field(28; "Invoicing Resource"; Code[20])
        {
            TableRelation = "Resource";
            CaptionML = ENU = 'Invoicing Resource', ESP = 'Recurso facturaci�n';


        }
        field(29; "Time Average Unit"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Time Average Unit', ESP = 'Unidad media tiempo';
            Editable = false;


        }
        field(30; "Element Unit Weight"; Decimal)
        {
            CaptionML = ENU = 'Element Unit Weight', ESP = 'Peso unitrio elemento';


        }
        field(31; "Return Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Rental Elements Entries"."Quantity" WHERE("Element No." = FIELD("No."),
                                                                                                              "Posting Date" = FIELD("Date Filter"),
                                                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                                              "Entry Type" = CONST("Return"),
                                                                                                              "Customer No." = FIELD("Customer Filter"),
                                                                                                              "Job No." = FIELD("Job Filter"),
                                                                                                              "Contract No." = FIELD("Contract Filter")));
            CaptionML = ENU = 'Return Quantity', ESP = 'Cantidad devuelta';


        }
        field(32; "Quantity Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Rental Elements Entries"."Quantity" WHERE("Element No." = FIELD("No."),
                                                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                                                             "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                                             "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                                             "Customer No." = FIELD("Customer Filter"),
                                                                                                             "Job No." = FIELD("Job Filter"),
                                                                                                             "Contract No." = FIELD("Contract Filter")));
            CaptionML = ENU = 'Quantity Balance', ESP = 'Saldo cantidad';


        }
        field(33; "Job Filter"; Code[20])
        {
            FieldClass = FlowFilter;

            TableRelation = "Job";
            CaptionML = ENU = 'Job Filter', ESP = 'Filtro proyecto';


        }
        field(34; "Contract Filter"; Code[20])
        {
            FieldClass = FlowFilter;

            TableRelation = "Element Contract Header";
            CaptionML = ENU = 'Contract Filter', ESP = 'Filtro contrato';


        }
        field(35; "Customer Filter"; Code[20])
        {
            FieldClass = FlowFilter;

            TableRelation = "Customer";
            CaptionML = ENU = 'Customer Filter', ESP = 'Filtro cliente';


        }
        field(36; "Work Type"; Code[10])
        {
            TableRelation = "Resource Cost"."Work Type Code" WHERE("Type" = CONST("Resource"),
                                                                                                         "Code" = FIELD("Invoicing Resource"));
            CaptionML = ENU = 'Work Type', ESP = 'Tipo trabajo';


        }
        field(37; "Billing Rate Type"; Option)
        {
            OptionMembers = "Calendar Day","Weekday","Month";

            CaptionML = ENU = 'Billing Rate Type', ESP = 'Tipo de tarifa de facturaci�n';
            OptionCaptionML = ENU = 'Calendar Day,Weekday,Month', ESP = 'D�a natural,D�a laborable,Mes';


            trigger OnValidate();
            BEGIN
                RentalElementsSetup.GET;
                CASE "Billing Rate Type" OF
                    "Billing Rate Type"::"Calendar Day":
                        BEGIN
                            RentalElementsSetup.TESTFIELD("Calendar Day Time Avg. Unit");
                            "Time Average Unit" := RentalElementsSetup."Calendar Day Time Avg. Unit";
                        END;
                    "Billing Rate Type"::Weekday:
                        BEGIN
                            RentalElementsSetup.TESTFIELD("Weekday Time Average Unit");
                            "Time Average Unit" := RentalElementsSetup."Weekday Time Average Unit";
                        END;
                    "Billing Rate Type"::Month:
                        BEGIN
                            RentalElementsSetup.TESTFIELD("Month Time Average Unit");
                            "Time Average Unit" := RentalElementsSetup."Month Time Average Unit";
                        END;
                END;
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
        //       RentalElementsSetup@7001100 :
        RentalElementsSetup: Record 7207346;
        //       NoSeriesManagement@7001101 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       DimensionManagement@7001102 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       RentalElements@7001103 :
        RentalElements: Record 7207344;
        //       CommentLine@7001104 :
        CommentLine: Record 97;
        //       Text000@7001105 :
        Text000: TextConst ENU = 'You must first fill in the description to be able to fill in the description 2.', ESP = 'Debe rellenar primero la descripci�n para poder rellenar la descripci�n 2.';
        //       Item@7001106 :
        Item: Record 27;



    trigger OnInsert();
    begin
        if "No." = '' then begin
            // Configuraci�n
            RentalElementsSetup.GET;
            RentalElementsSetup.TESTFIELD("Element No. Series");
            NoSeriesManagement.InitSeries(RentalElementsSetup."Element No. Series", xRec."Serie No.", 0D, "No.", "Serie No.");
        end;

        DimensionManagement.UpdateDefaultDim(
          DATABASE::"Rental Elements", "No.",
          "Global Dimensions 1 Code", "Global Dimensions 2 Code");

        RentalElementsSetup.GET;
        RentalElementsSetup.TESTFIELD("Calendar Day Time Avg. Unit");
        "Time Average Unit" := RentalElementsSetup."Calendar Day Time Avg. Unit";
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnDelete();
    begin
        // Eliminar comentarios
        CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::"IC Partner");
        CommentLine.SETRANGE("No.", "No.");
        CommentLine.DELETEALL;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
    end;



    // procedure ValidateShortcutDimCode (PFieldNo@7001100 : Integer;var ShortcutDimCode@7001101 :
    procedure ValidateShortcutDimCode(PFieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimensionManagement.ValidateDimValueCode(PFieldNo, ShortcutDimCode);
        DimensionManagement.SaveDefaultDim(DATABASE::"Rental Elements", "No.", PFieldNo, ShortcutDimCode);
        MODIFY;
    end;

    //     procedure AssistEdit (RentalElementsMaestra@7001100 :
    procedure AssistEdit(RentalElementsMaestra: Record 7207344): Boolean;
    begin
        /*To be Tested*/
        // WITH RentalElements DO begin
        RentalElements := Rec;
        RentalElementsSetup.GET;
        RentalElementsSetup.TESTFIELD("Element No. Series");
        if NoSeriesManagement.SelectSeries(RentalElementsSetup."Element No. Series", RentalElementsMaestra."Serie No.", "Serie No.") then begin
            RentalElementsSetup.GET;
            RentalElementsSetup.TESTFIELD("Element No. Series");
            NoSeriesManagement.SetSeries("No.");
            Rec := RentalElements;
            exit(TRUE);
        end;
        // end;
    end;

    //     procedure GenerateResourceInvoiced (var PRentalElements@7001100 :
    procedure GenerateResourceInvoiced(var PRentalElements: Record 7207344)
    var
        //       Resource@7001101 :
        Resource: Record 156;
        //       ResourceUnitofMeasure@7001102 :
        ResourceUnitofMeasure: Record 205;
        //       VRentalElementsSetup@7001103 :
        VRentalElementsSetup: Record 7207346;
        //       VJob@7001104 :
        VJob: Record 167;
        //       Text000@7001105 :
        Text000: TextConst ENU = 'Resource already exists %1 - %2', ESP = 'Ya existe el recurso %1 - %2';
        //       Text001@7001106 :
        Text001: TextConst ENU = 'Resource %1 was generated.', ESP = '"Se ha generado el recurso %1 "';
        //       Text002@7001107 :
        Text002: TextConst ENU = 'Resource %1 was generated and job %2', ESP = 'Se ha generado el recurso %1 y el proyecto %2';
    begin
        // Genera recurso desde un elemento de alquiler
        if not Resource.GET("No.") then begin
            Resource.INIT;
            Resource."No." := PRentalElements."No.";
            Resource.Type := Resource.Type::Machine;
            Resource.VALIDATE(Name, PRentalElements.Description);
            Resource.VALIDATE("Name 2", PRentalElements."Description 2");
            PRentalElements."Invoicing Resource" := PRentalElements."No.";
            PRentalElements.MODIFY;
            ResourceUnitofMeasure.SETRANGE(ResourceUnitofMeasure."Resource No.", Resource."No.");
            ResourceUnitofMeasure.SETRANGE(ResourceUnitofMeasure.Code, PRentalElements."Time Average Unit");
            if not ResourceUnitofMeasure.FINDFIRST then begin
                ResourceUnitofMeasure."Resource No." := Resource."No.";
                ResourceUnitofMeasure.VALIDATE(Code, PRentalElements."Time Average Unit");
                ResourceUnitofMeasure.VALIDATE("Qty. per Unit of Measure", 1);
                ResourceUnitofMeasure.INSERT;
            end;
            Resource.VALIDATE("Base Unit of Measure", PRentalElements."Time Average Unit");
            Resource.VALIDATE("Gen. Prod. Posting Group", PRentalElements."Product Posting Group");
            Resource.VALIDATE("VAT Prod. Posting Group", PRentalElements."Product VAT Posting Group");
            Resource.VALIDATE("Unit Price", "Rent Price/Time Unit");
            Resource.INSERT(TRUE);
            VRentalElementsSetup.GET;
            if VRentalElementsSetup."Create Job Desviataion" then begin
                VJob."No." := Resource."No.";
                VJob.Description := Resource.Name;
                VJob."Creation Date" := WORKDATE;
                VJob."Job Type" := VJob."Job Type"::Deviations;
                VJob.Status := VJob.Status::Open;
                VJob.INSERT(TRUE);
                VJob.VALIDATE("Global Dimension 1 Code", Resource."Global Dimension 1 Code");
                VJob.VALIDATE("Global Dimension 2 Code", Resource."Global Dimension 2 Code");
                VJob.MODIFY;
                Resource.VALIDATE("Jobs Deviation", VJob."No.");
                Resource.MODIFY;
            end;
            if VJob."No." <> '' then
                MESSAGE(Text002, Resource."No.", VJob."No.")
            else
                MESSAGE(Text001, Resource."No.");
        end else
            ERROR(Text000, PRentalElements."No.", PRentalElements.Description);
    end;

    /*begin
    end.
  */
}







