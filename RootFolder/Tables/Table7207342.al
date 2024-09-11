table 7207342 "Hist. Certification Lines"
{


    CaptionML = ENU = 'Hist. Certification Lines', ESP = 'Hist. l�neas certificaci�n';
    LookupPageID = "Post. Certification Lines Subf";
    DrillDownPageID = "Post. Certification Lines Subf";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'No. documento';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. linea';


        }
        field(3; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Customer Certification Unit" = CONST(true));
            CaptionML = ENU = 'Piecework No.', ESP = 'No. unidad de obra';


        }
        field(4; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Descripticon 2', ESP = 'Descripci�n 2';


        }
        field(6; "Term Contract Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';
            Description = 'Importe PEC Periodo';
            AutoFormatExpression = GetCurrencyCode;


        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shorcut Dimension 1 Code', ESP = 'Cod. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shorcut Dimension 2 Code', ESP = 'Cod. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'Cod. divisa';
            Editable = false;


        }
        field(10; "OLD_Term Measure"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measure Quantity', ESP = 'Medici�n Periodo';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';


        }
        field(11; "Contract Price"; Decimal)
        {
            CaptionML = ENU = 'Sale Price', ESP = 'Precio E.C.';
            Description = 'Precio PEC';


        }
        field(12; "OLD_Certificated Quantity"; Decimal)
        {
            CaptionML = ENU = 'Certificated Amount', ESP = 'Cantidad certificada';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';


        }
        field(13; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(15; "OLD_Term Certification"; Decimal)
        {
            CaptionML = ENU = 'Quantity', ESP = 'Certificaci�n del Periodo';
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';


        }
        field(17; "Sale Price"; Decimal)
        {
            CaptionML = ENU = 'Contract Price', ESP = 'Precio E.M.';
            Description = 'Precio PEM';
            Editable = false;


        }
        field(18; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(19; "Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Post. Certifications"."Posting Date" WHERE("No." = FIELD("Document No.")));
            CaptionML = ESP = 'Fecha Registro';
            Description = 'QB 1.08.42 - JAV 18/05/21 Obtiene la fecha de la cabecera';


        }
        field(20; "Adjustment Redeterm. Prices"; Decimal)
        {
            CaptionML = ENU = 'Adjustment Redeterm. Prices', ESP = 'Ajuste Redeterminacion Precios';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(21; "OLD_Certific. Amount (base)"; Decimal)
        {
            CaptionML = ENU = 'Certification Amount (base)', ESP = 'Importe a PEC';
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(22; "Measurement Adjustment"; Decimal)
        {
            CaptionML = ENU = 'Measurement Adjustment', ESP = 'Medici�n Ajuste';
            DecimalPlaces = 2 : 4;
            Editable = false;


        }
        field(23; "Previous Redetermined Price"; Decimal)
        {
            CaptionML = ENU = 'Previous Redetermined Price', ESP = 'Precio redeterminado anterior';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(24; "Last Price Redetermined"; Decimal)
        {
            CaptionML = ENU = 'Last Price Redetermined', ESP = '�ltimo precio redeterminado';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";


        }
        field(25; "Certification Type"; Option)
        {
            OptionMembers = "Normal","Price adjustment";
            FieldClass = FlowField;
            CalcFormula = Lookup("Hist. Measurements"."Certification Type" WHERE("No." = FIELD("Document No.")));
            CaptionML = ENU = 'Certification Type', ESP = 'Tipo de certificaci�n';
            OptionCaptionML = ENU = 'Normal,Price adjustment', ESP = 'Normal,Ajuste precios';

            Editable = false;


        }
        field(28; "OLD_Source Certification"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Source Measure', ESP = 'Certificaci�n a origen';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';


        }
        field(32; "Certification Date"; Date)
        {
            CaptionML = ENU = 'Fecha certificacion', ESP = 'Fecha certificaci�n';


        }
        field(34; "OLD_Measurement No."; Code[20])
        {
            CaptionML = ENU = 'No. medicion', ESP = 'N� medici�n';
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';
            Editable = true;


        }
        field(42; "Certif. Quantity Not Inv."; Decimal)
        {
            CaptionML = ENU = 'Certif. Quantity Not Inv.', ESP = 'Cant. certif. no facturada';
            DecimalPlaces = 2 : 4;
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';


        }
        field(43; "Invoiced Quantity"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Quantity', ESP = 'Cantidad facturada';
            DecimalPlaces = 2 : 4;


        }
        field(44; "Invoiced Certif."; Boolean)
        {
            CaptionML = ENU = 'Invoiced Certif.', ESP = 'Certificaci�n facturada';
            Editable = false;


        }
        field(45; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'N� cliente';
            Description = '[ Utilizado para facturar certificaciones]';


        }
        field(48; "Term PEC Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio del Periodo a PEC';
            Description = 'JAV 15/09/21: - QB 1.09.18 Precio del periodo, se calcula para absorver las diferencias de precio anteriores con la actual';


        }
        field(49; "Term PEM Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio del Periodo a PEM';
            Description = 'JAV 15/09/21: - QB 1.09.18 Precio del periodo a PEM, se calcula para absorver las diferencias de precio anteriores con la actual';


        }
        field(50; "Is Cancel Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Es l�nea de cancelaci�n';
            Description = 'QB 1.09.20 JAV 28/09/21 Si esta l�nea es de una cancelaci�n';


        }
        field(80; "Document Filter"; Code[20])
        {
            FieldClass = FlowFilter;


        }
        field(106; "Record"; Code[20])
        {
            TableRelation = Records."No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Expediente';
            Description = 'QB 1.10.14 JAV 25/01/22 Nro del expediente relacionado con la l�nea';
            Editable = false;


        }
        field(107; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';


        }
        field(109; "OLD_Term Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe PEM';
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';
            Editable = false;


        }
        field(111; "OLD_Source Amount PEM"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification Amount (base)', ESP = 'Imp. Origen a PEM';
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(112; "OLD_Source Amount PEC"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount', ESP = 'Imp. Origen a PEC';
            Description = '### ELIMINAR ### Se cambia por los campos 200-212';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(120; "Tmp Quantity Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB. 1.06.07 - JAV 26/07/20: - Lo calcula el informe de certificaci�n para imprimir';


        }
        field(121; "Tmp Quantity Previous"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB. 1.06.07 - JAV 26/07/20: - Lo calcula el informe de certificaci�n para imprimir';


        }
        field(122; "Tmp Piecework Header"; Option)
        {
            OptionMembers = "Header","Data","Med","Total";
            DataClassification = ToBeClassified;

            Description = 'QB. 1.06.07 - JAV 26/07/20: - Lo calcula el informe de certificaci�n para imprimir';


        }
        field(123; "Tmp Origin amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB. 1.06.07 - JAV 26/07/20: - Lo calcula el informe de certificaci�n para imprimir';


        }
        field(124; "Tmp Previous amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB. 1.06.07 - JAV 26/07/20: - Lo calcula el informe de certificaci�n para imprimir';


        }
        field(140; "Grouping Code"; Code[20])
        {
            TableRelation = "QB Grouping Code"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Grouping Code', ESP = 'C�d. Agrupaci�n';
            Description = 'Q13152';


        }
        field(141; "VAT Prod. Posting Group"; Code[20])
        {
            TableRelation = "VAT Product Posting Group";
            CaptionML = ENU = 'VAT Prod. Posting Group', ESP = 'Grupo registro IVA prod.';
            Description = 'Q13152  QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


        }
        field(200; "Cert Medition No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Medici�n Certificada';
            Editable = false;


        }
        field(201; "Cert Medition Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� L�nea Medici�n Certificada';
            Editable = false;


        }
        field(202; "Cert Pend. Medition Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici�n Pte. del periodo';
            Editable = false;


        }
        field(203; "Cert Pend. Medition Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici�n a origen';
            Description = 'JAV 22/03/21 Se cambia el caption';
            Editable = false;


        }
        field(204; "Cert % to Certificate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% de medicion', ESP = '% a certificar';
            DecimalPlaces = 2 : 6;
            MinValue = -100;
            MaxValue = 100;


        }
        field(205; "Cert Quantity to Term"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cantidad a certificar', ESP = 'Cantidad certificada periodo';
            DecimalPlaces = 2 : 4;
            Description = 'JAV 22/03/21 Se cambia el caption';


        }
        field(206; "Cert Quantity to Origin"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cantidad a certificar', ESP = 'Cantidad certificada Origen';
            DecimalPlaces = 2 : 4;
            Description = 'JAV 22/03/21 Se cambia el caption';


        }
        field(207; "Cert Term PEM amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe periodo a PEM';


        }
        field(208; "Cert Term PEC amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe periodo a PEC';


        }
        field(209; "Cert Term RED amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe periodo a P.Redeterminaci�n';


        }
        field(210; "Cert Source PEM amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a PEM';


        }
        field(211; "Cert Source PEC amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a PEC';


        }
        field(212; "Cert Source RED amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Origen a P.Redeterminaci�n';


        }
        field(500; "Facturado"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Invoice Line" WHERE("QB Certification code" = FIELD("Document No.")));
            Description = 'Q19447';


        }
    }
    keys
    {
        key(key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Term Contract Amount";
            Clustered = true;
        }
        key(key2; "Job No.", "Piecework No.", "Certification Date", "Invoiced Certif.")
        {
            SumIndexFields = "Sale Price", "Term Contract Amount", "Cert Quantity to Term", "Invoiced Quantity";
        }
        key(key3; "Document No.", "VAT Prod. Posting Group", "Grouping Code")
        {
            ;
        }
    }
    fieldgroups
    {
    }

    var
        //       PostCert@7001101 :
        PostCert: Record 7207341;
        //       HistCertificationLines@7001106 :
        HistCertificationLines: Record 7207342;
        //       HistMeasurements@1100286003 :
        HistMeasurements: Record 7207338;
        //       HistMeasureLines@1100286000 :
        HistMeasureLines: Record 7207339;
        //       NewCertification@1100286002 :
        NewCertification: Boolean;
        //       AmountTotal@1100286001 :
        AmountTotal: Decimal;
        //       Text000@1100286004 :
        Text000: TextConst ESP = 'Ya tiene cantidades facturadas, no puede eliminar la certificaci�n.';



    trigger OnDelete();
    begin
        //JAV 22/02/21: - Si elimino una l�nea devuelvo la cantidad certificada a la medici�n
        if ("Invoiced Quantity" <> 0) then
            ERROR(Text000);

        if ("Cert Quantity to Term" <> 0) then begin
            if (HistMeasureLines.GET("Cert Medition No.", "Cert Medition Line No.")) then begin
                HistMeasureLines."Certificated Quantity" -= "Cert Quantity to Term";
                HistMeasureLines."Quantity Measure not Cert" += "Cert Quantity to Term";
                HistMeasureLines.MODIFY;

                //Desmarco la medici�n como completamente certificada
                if (HistMeasurements.GET("Cert Medition No.")) then begin
                    HistMeasurements."Certification Completed" := FALSE;
                    HistMeasurements.MODIFY;
                end;
            end;
        end;
    end;



    procedure GetCurrencyCode(): Code[10];
    var
        //       PurchInvHeader@1000 :
        PurchInvHeader: Record 122;
    begin
        if ("Document No." = PurchInvHeader."No.") then
            exit(PurchInvHeader."Currency Code")
        else
            if PurchInvHeader.GET("Document No.") then
                exit(PurchInvHeader."Currency Code")
            else
                exit('');
    end;

    //     LOCAL procedure GetFieldCaption (FieldNo@1000 :
    LOCAL procedure GetFieldCaption(FieldNo: Integer): Text[30];
    var
        //       Field@1001 :
        Field: Record 2000000041;
    begin
        Field.GET(DATABASE::"Hist. Certification Lines", FieldNo);
        exit(Field."Field Caption");
    end;

    procedure CalcInvoiceAmount()
    var
        //       locrecCurrency@1100251000 :
        locrecCurrency: Record 4;
    begin
        AmountTotal := 0;

        PostCert.GET("Document No.");
        CLEAR(locrecCurrency);
        if PostCert."Currency Code" = '' then
            locrecCurrency.InitRoundingPrecision
        else begin
            locrecCurrency.GET(PostCert."Currency Code");
            locrecCurrency.InitRoundingPrecision;
        end;
        HistCertificationLines.RESET;
        HistCertificationLines.SETRANGE("Document No.", "Document No.");
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if HistCertificationLines.FINDSET(FALSE,FALSE) then
        if HistCertificationLines.FINDSET(FALSE) then
            repeat
                //JAV 20/02/21: QB 1.8.14 Retonar el importe de Ejecuci�n material, no el de contrato
                //AmountTotal += ROUND(HistCertificationLines."Sale Price" * HistCertificationLines."Certif. Quantity not Inv.", locrecCurrency."Amount Rounding Precision")
                AmountTotal += ROUND(HistCertificationLines."Sale Price" * HistCertificationLines."Certif. Quantity not Inv.", locrecCurrency."Amount Rounding Precision")
            until HistCertificationLines.NEXT = 0;
    end;

    procedure ShowDimensions()
    var
        //       DimensionManagement@7001100 :
        DimensionManagement: Codeunit "DimensionManagement";
    begin

        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', TABLECAPTION, "Document No.", "Line No."));
    end;

    //     procedure MontarTemporal (var pTabla@1100286005 : Record 7207342;var pTotales@1100286006 : ARRAY [20] OF Decimal;var pLevel0@1100286012 : Integer;var pMarcaFinal@1100286022 : Text;pNro@1100286007 : Code[20];pDetMedicion@1100286009 : Boolean;pPrice@1100286010 :
    procedure MontarTemporal(var pTabla: Record 7207342; var pTotales: ARRAY[20] OF Decimal; var pLevel0: Integer; var pMarcaFinal: Text; pNro: Code[20]; pDetMedicion: Boolean; pPrice: Option "Venta","Contrato")
    var
        //       PostCertifications1@1100286015 :
        PostCertifications1: Record 7207341;
        //       PostCertifications@1100286014 :
        PostCertifications: Record 7207341;
        //       Job@1100286018 :
        Job: Record 167;
        //       Customer@1100286019 :
        Customer: Record 18;
        //       VATPostingSetup@1100286020 :
        VATPostingSetup: Record 325;
        //       WithholdingGroup@1100286021 :
        WithholdingGroup: Record 7207330;
        //       HistCertifications@1100286008 :
        HistCertifications: Record 7207342;
        //       tmpDataPieceworkForProduction@1100286004 :
        tmpDataPieceworkForProduction: Record 7207386 TEMPORARY;
        //       DataPieceworkForProduction@1100286016 :
        DataPieceworkForProduction: Record 7207386;
        //       Currency@1100286013 :
        Currency: Record 4;
        //       i@1100286000 :
        i: Integer;
        //       nLinea@1100286001 :
        nLinea: Integer;
        //       ImpOri@1100286003 :
        ImpOri: Decimal;
        //       ImpAnt@1100286002 :
        ImpAnt: Decimal;
        //       LinePrice@1100286011 :
        LinePrice: Decimal;
        //       MarcaFinal@1100286017 :
        MarcaFinal: TextConst ESP = 'z';
    begin
        //Cargar el temporal con las l�neas de las certificaciones a imprimir
        pTabla.RESET;
        pTabla.DELETEALL;
        CLEAR(pTotales);
        pMarcaFinal := MarcaFinal;
        if not PostCertifications1.GET(pNro) then
            exit;
        if not Job.GET(PostCertifications1."Job No.") then
            exit;

        Customer.GET(PostCertifications1."Customer No.");

        //Porcentajes generales
        pTotales[14] := Job."General Expenses / Other";
        pTotales[15] := Job."Industrial Benefit";
        pTotales[16] := Job."Low Coefficient";

        //% IVA
        pTotales[17] := 0;
        if (VATPostingSetup.GET(Customer."VAT Bus. Posting Group", Job."VAT Prod. PostingGroup")) then
            pTotales[17] := VATPostingSetup."VAT %";

        //% Retenciones
        pTotales[18] := 0;
        pTotales[19] := 0;
        if (WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", Customer."QW Withholding Group by GE")) then
            CASE WithholdingGroup."Withholding treating" OF
                WithholdingGroup."Withholding treating"::"Payment Withholding":
                    pTotales[19] := WithholdingGroup."Percentage Withholding";
                WithholdingGroup."Withholding treating"::"Pending Invoice":
                    pTotales[18] := WithholdingGroup."Percentage Withholding";
            end;


        tmpDataPieceworkForProduction.RESET;
        tmpDataPieceworkForProduction.DELETEALL;
        if not Currency.GET(PostCertifications1."Currency Code") then
            Currency.INIT;
        Currency.InitRoundingPrecision;

        nLinea := 0;

        //Primero a�ado las unidades de esta certificaci�n al temporal como medici�n a origen
        HistCertifications.RESET;
        HistCertifications.SETRANGE("Document No.", pNro);
        HistCertifications.SETFILTER("Piecework No.", '<>%1', '');
        if (HistCertifications.FINDSET) then
            repeat
                nLinea += 1;

                pTabla := HistCertifications;
                pTabla."Document No." := '';
                pTabla."Line No." := nLinea;
                pTabla."Tmp Quantity Origin" := HistCertifications."Cert Quantity to Term";
                pTabla."Tmp Quantity Previous" := 0;
                pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Data;
                pTabla.INSERT;
                if pDetMedicion then begin
                    nLinea += 1;
                    pTabla."Line No." := nLinea;
                    pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Med;
                    pTabla.INSERT;
                end;
                //A�ado al temporal de unidades de obra las de la certificaci�n para saber las que llevo metidas
                tmpDataPieceworkForProduction."Piecework Code" := HistCertifications."Piecework No.";
                if not tmpDataPieceworkForProduction.INSERT then;

                //Sumo a los ptotales
                CASE pPrice OF
                    pPrice::Venta:
                        LinePrice := pTabla."Contract Price";
                    pPrice::Contrato:
                        LinePrice := pTabla."Sale Price";
                end;

                pTotales[1] += ROUND(HistCertifications."Cert Quantity to Term" * LinePrice, Currency."Unit-Amount Rounding Precision");
            until (HistCertifications.NEXT = 0);


        //Ahora a�ado las certificaciones anteriores a la actual
        PostCertifications.RESET;
        PostCertifications.SETRANGE("Job No.", PostCertifications1."Job No.");
        PostCertifications.SETRANGE("Customer No.", PostCertifications1."Customer No.");
        PostCertifications.SETFILTER("No.", '<%1', PostCertifications1."No.");
        PostCertifications.SETFILTER("Cancel By", '');
        PostCertifications.SETFILTER("Cancel No.", '');
        if (PostCertifications.FINDLAST) then
            repeat
                HistCertifications.RESET;
                HistCertifications.SETRANGE("Document No.", PostCertifications."No.");
                HistCertifications.SETFILTER("Piecework No.", '<>%1', '');
                if (HistCertifications.FINDSET) then
                    repeat
                        pTabla.RESET;
                        pTabla.SETRANGE("Piecework No.", HistCertifications."Piecework No.");
                        if (not pTabla.FINDFIRST) then begin
                            nLinea += 1;

                            pTabla := HistCertifications;
                            pTabla."Document No." := '';
                            pTabla."Line No." := nLinea;
                            pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Data;
                            pTabla."Tmp Quantity Origin" := 0;
                            pTabla."Tmp Quantity Previous" := 0;
                            pTabla.INSERT;

                            if pDetMedicion then begin
                                nLinea += 1;
                                pTabla."Line No." := nLinea;
                                pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Med;
                                pTabla.INSERT;
                            end;
                            //A�ado al temporal de unidades de obra las de la certificaci�n para saber las que llevo metidas
                            tmpDataPieceworkForProduction."Piecework Code" := HistCertifications."Piecework No.";
                            if not tmpDataPieceworkForProduction.INSERT then;
                        end;

                        //La a�ado como medici�n anterior y a origen
                        pTabla.RESET;
                        pTabla.SETRANGE("Piecework No.", HistCertifications."Piecework No.");
                        pTabla.FINDFIRST;
                        pTabla."Tmp Quantity Origin" += HistCertifications."Cert Quantity to Term";
                        pTabla."Tmp Quantity Previous" += HistCertifications."Cert Quantity to Term";
                        pTabla.MODIFY;

                        //Sumo a los ptotales
                        CASE pPrice OF
                            pPrice::Venta:
                                LinePrice := pTabla."Contract Price";
                            pPrice::Contrato:
                                LinePrice := pTabla."Sale Price";
                        end;

                        pTotales[1] += ROUND(HistCertifications."Cert Quantity to Term" * LinePrice, Currency."Unit-Amount Rounding Precision");
                        pTotales[2] -= ROUND(HistCertifications."Cert Quantity to Term" * LinePrice, Currency."Unit-Amount Rounding Precision");
                    until (HistCertifications.NEXT = 0);
            until (PostCertifications.NEXT(-1) = 0);


        //Ahora a�ado las unidades de mayor asociadas a cada una de las l�neas de la certificaci�n
        pLevel0 := MAXSTRLEN(DataPieceworkForProduction."Piecework Code");  //Este es el tama�o de la primera unidad de obra a presentar, para la identaci�n.
        tmpDataPieceworkForProduction.RESET;
        if (tmpDataPieceworkForProduction.FINDSET) then
            repeat
                FOR i := 1 TO STRLEN(tmpDataPieceworkForProduction."Piecework Code") - 1 DO begin
                    if (DataPieceworkForProduction.GET(PostCertifications1."Job No.", COPYSTR(tmpDataPieceworkForProduction."Piecework Code", 1, i))) then begin
                        pTabla.RESET;
                        pTabla.SETRANGE("Piecework No.", DataPieceworkForProduction."Piecework Code");
                        if (not pTabla.FINDFIRST) then begin
                            //Calculo en importe de las U.O. por debajo
                            DataPieceworkForProduction.VALIDATE(Totaling); //por si acaso
                            ImpOri := 0;
                            ImpAnt := 0;
                            pTabla.RESET;
                            pTabla.SETRANGE("Tmp Piecework Header", pTabla."Tmp Piecework Header"::Data);
                            pTabla.SETFILTER("Piecework No.", DataPieceworkForProduction.Totaling);
                            if (pTabla.FINDSET) then
                                repeat
                                    CASE pPrice OF
                                        pPrice::Venta:
                                            LinePrice := pTabla."Contract Price";
                                        pPrice::Contrato:
                                            LinePrice := pTabla."Sale Price";
                                    end;

                                    ImpAnt += ROUND(pTabla."Tmp Quantity Previous" * LinePrice, Currency."Unit-Amount Rounding Precision");
                                    ImpOri += ROUND(pTabla."Tmp Quantity Origin" * LinePrice, Currency."Unit-Amount Rounding Precision");
                                until pTabla.NEXT = 0;

                            nLinea += 1;
                            pTabla.INIT;
                            pTabla."Line No." := nLinea;
                            pTabla."Piecework No." := DataPieceworkForProduction."Piecework Code";
                            pTabla."Tmp Origin amount" := ImpOri;
                            pTabla."Tmp Previous amount" := ImpAnt;
                            pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Header;
                            pTabla.INSERT;

                            nLinea += 1;
                            pTabla."Line No." := nLinea;
                            pTabla."Piecework No." := DataPieceworkForProduction."Piecework Code" + pMarcaFinal;
                            pTabla."Tmp Piecework Header" := pTabla."Tmp Piecework Header"::Total;
                            pTabla.INSERT;

                            if (STRLEN(DataPieceworkForProduction."Piecework Code") < pLevel0) then
                                pLevel0 := STRLEN(DataPieceworkForProduction."Piecework Code");
                        end;
                    end;
                end;
            until tmpDataPieceworkForProduction.NEXT = 0;

        //Calculo de ptotales, tenemos ya ptotales[1]=Total a origen y ptotales[2]=Total anterior
        //pTotales[14] = %GG , pTotales[15] = %BI, pTotales[16] = % Baja
        //ptotales[17] = % IVA, ptotales[18] = % RetFac, ptotales[19] = % RetPago

        pTotales[3] := pTotales[1] + pTotales[2];                                                                                               //Total certificaci�n
        if (pPrice = pPrice::Contrato) then begin
            pTotales[4] := ROUND(pTotales[3] * Job."General Expenses / Other" / 100, Currency."Unit-Amount Rounding Precision");                 //Gastos generales
            pTotales[5] := ROUND(pTotales[3] * Job."Industrial Benefit" / 100, Currency."Unit-Amount Rounding Precision");                       //Beneficio Industrial
            pTotales[6] := -ROUND((pTotales[3] + pTotales[4] + pTotales[5]) * Job."Low Coefficient" / 100, Currency."Unit-Amount Rounding Precision"); //Baja
        end;
        pTotales[7] := pTotales[3] + pTotales[4] + pTotales[5] - pTotales[6];                                                                         //Importe certificaci�n
        pTotales[8] := ROUND(pTotales[7] * pTotales[18] / 100, Currency."Unit-Amount Rounding Precision");                                    //Retenci�n en factura
        pTotales[9] := pTotales[7] - pTotales[8];                                                                                             //Base imponible
        pTotales[10] := ROUND(pTotales[9] * pTotales[17] / 100, Currency."Unit-Amount Rounding Precision");                                    //IVA
        pTotales[11] := pTotales[9] + pTotales[10];                                                                                            //Total Factura
        pTotales[12] := ROUND(pTotales[11] * pTotales[19] / 100, Currency."Unit-Amount Rounding Precision");                                   //Retenci�n de pago
        pTotales[13] := pTotales[11] - pTotales[12];                                                                                           //Total a pagar

        if (pTotales[7] = pTotales[3]) or (pTotales[8] = 0) then
            pTotales[7] := 0;
        if (pTotales[3] = pTotales[9]) or (pTotales[10] = 0) then
            pTotales[9] := 0;
        if (pTotales[12] = 0) then
            pTotales[13] := 0;
    end;

    /*begin
    //{
//      JAV 11/04/19: - Al traer la certificaci�n, se cambia el c�digo del documento por el texto de la certificaci�n, que es mas apropiado para el cliente
//      Q13152 DGG 22/06/21: - Se a�aden los campos:"Grouping Code","VAT Prod. Posting Group"
//
//      CPA 29/03/22: Q16867 - Mejora de rendimiento
//          - Modificada la clave: Job No.,Piecework No.,Certification Date,Invoiced Certif. (A�adido SumIndexField)
//      AML Q19447 Para no certificar no facturados
//    }
    end.
  */
}







