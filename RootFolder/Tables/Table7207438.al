table 7207438 "Cert. Unit Redetermination"
{


    CaptionML = ENU = 'Cert. Unit Redetermination', ESP = 'Unidades de certificaci�n redeterminada';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';


        }
        field(2; "Redetermination Code"; Code[20])
        {
            TableRelation = "Job Redetermination"."Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Redetermination Code', ESP = 'Redeterminaci�n code';


        }
        field(3; "Piecework Code"; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Piecework Code', ESP = 'Cod. Unidad de obra';
            NotBlank = true;


        }
        field(4; "Certified Quantity to Adjust"; Decimal)
        {
            CaptionML = ENU = 'Certified Quantity to Adjust', ESP = 'Cantidad certificada a ajustar';
            Editable = false;


        }
        field(5; "Previous certified Quantity"; Decimal)
        {
            CaptionML = ENU = 'Previous certified Quantity', ESP = 'Cantidad certificada previa';
            Editable = false;


        }
        field(6; "Outstading Quantity to Cert."; Decimal)
        {
            CaptionML = ENU = 'Outstading Quantity to Cert.', ESP = 'Cantidad pendiente de certificar';
            Editable = false;


        }
        field(7; "Amount Executed"; Decimal)
        {
            CaptionML = ENU = 'Amount Executed', ESP = 'Importe ejecutado';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;


        }
        field(8; "Amount Sales Increase"; Decimal)
        {
            CaptionML = ENU = 'Amount Sales Increase', ESP = 'Importe invremento venta';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;


        }
        field(9; "Amount Pending Execution"; Decimal)
        {
            CaptionML = ENU = 'Amount Pending Execution', ESP = 'Importe pendiente de ejecuci�n';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;


        }
        field(10; "Unit Increase"; Decimal)
        {
            CaptionML = ENU = 'Unit Increase', ESP = 'Incremento unitario';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = GetCurrency;


        }
        field(11; "Factor applied"; Decimal)
        {


            CaptionML = ENU = 'Factor applied', ESP = 'Indice aplicado';

            trigger OnValidate();
            BEGIN
                TESTFIELD(Validated, FALSE);
                TESTFIELD(Adjusted, FALSE);
                GetCurrency;
                "Unit Price Redetermined" := ROUND("Previous Unit Price" * "Factor applied",
                                                   Currency."Unit-Amount Rounding Precision");
                "Unit Increase" := "Unit Price Redetermined" - "Previous Unit Price";

                "Amount Pending Execution" := ROUND("Outstading Quantity to Cert." * "Unit Price Redetermined",
                                                    Currency."Amount Rounding Precision");

                "Amount Sales Increase" := ROUND("Outstading Quantity to Cert." * "Unit Increase",
                                                 Currency."Amount Rounding Precision") +
                                           ROUND("Certified Quantity to Adjust" * "Unit Increase",
                                                 Currency."Amount Rounding Precision");
            END;


        }
        field(12; "Previous Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Previous Unit Price', ESP = 'Precio unitario anterior';
            Editable = false;
            AutoFormatType = 2;
            AutoFormatExpression = GetCurrency;


        }
        field(13; "Unit Price Redetermined"; Decimal)
        {


            CaptionML = ENU = 'Unit Price Redetermined', ESP = 'Precio unitario redeterminado';
            AutoFormatType = 2;
            AutoFormatExpression = GetCurrency;

            trigger OnValidate();
            BEGIN
                TESTFIELD(Validated, FALSE);
                TESTFIELD(Adjusted, FALSE);
                VALIDATE("Factor applied", ROUND("Unit Price Redetermined" / "Previous Unit Price", 0.00001));
            END;


        }
        field(14; "Last Sales Amount"; Decimal)
        {
            CaptionML = ENU = 'Last Sales Amount', ESP = 'Importe venta anterior';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;


        }
        field(15; "New Sales Amount"; Decimal)
        {
            CaptionML = ENU = 'New Sales Amount', ESP = 'Importe venta nuevo';
            Editable = false;
            AutoFormatType = 1;
            AutoFormatExpression = GetCurrency;


        }
        field(16; "Amount to Adjust"; Decimal)
        {
            CaptionML = ENU = 'Amount to Adjust', ESP = 'Importe a ajustar';
            Editable = false;
            AutoFormatExpression = GetCurrency;


        }
        field(17; "Account Type"; Option)
        {
            OptionMembers = "Unit"," Heading";
            CaptionML = ENU = 'Account Type', ESP = 'Tipo movimiento';
            OptionCaptionML = ENU = 'Unit,Heading', ESP = 'Unidad,Mayor';

            Editable = false;


        }
        field(18; "Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Data Piecework For Production"."Description" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Piecework Code" = FIELD("Piecework Code")));
            CaptionML = ENU = 'Description', ESP = 'Descripción';
            Editable = false;


        }
        field(19; "Validated"; Boolean)
        {
            CaptionML = ENU = 'Validated', ESP = 'Validada';
            Editable = false;


        }
        field(20; "Aplication Date"; Date)
        {
            CaptionML = ENU = 'Aplication Date', ESP = 'Fecha aplicaci�n';


        }
        field(21; "Adjusted"; Boolean)
        {
            CaptionML = ENU = 'Adjusted', ESP = 'Ajustes';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Job No.", "Redetermination Code", "Piecework Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Currency@7001100 :
        Currency: Record 4;

    procedure GetCurrency(): Code[10];
    var
        //       Job@7001100 :
        Job: Record 167;
    begin
        if Job.GET("Job No.") then begin
            CLEAR(Currency);
            if Job."Currency Code" <> '' then
                Currency.GET(Job."Currency Code");

            Currency.InitRoundingPrecision;
            exit(Currency.Code);
        end else begin
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
            exit(Currency.Code);
        end;
    end;

    //     procedure Amount (OptionAmount@7001100 :
    procedure Amount(OptionAmount: Option "Executed","Pending","Increment","Before","New","Adjusted"): Decimal;
    var
        //       DataPieceworkForProduction@7001101 :
        DataPieceworkForProduction: Record 7207386;
        //       CertUnitRedetermination@7001102 :
        CertUnitRedetermination: Record 7207438;
        //       AmountSalesTotal@7001103 :
        AmountSalesTotal: Decimal;
    begin
        if "Account Type" = "Account Type"::Unit then begin
            CASE OptionAmount OF
                OptionAmount::Executed:
                    exit("Amount Executed");
                OptionAmount::Pending:
                    exit("Amount Pending Execution");
                OptionAmount::Increment:
                    exit("Amount Sales Increase");
                OptionAmount::Before:
                    exit("Last Sales Amount");
                OptionAmount::New:
                    exit("New Sales Amount");
                OptionAmount::Adjusted:
                    exit("Amount to Adjust");
            end;
        end else begin
            DataPieceworkForProduction.GET("Job No.", "Piecework Code");
            AmountSalesTotal := 0;
            CertUnitRedetermination.SETRANGE("Job No.", "Job No.");
            CertUnitRedetermination.SETRANGE("Redetermination Code", "Redetermination Code");
            CertUnitRedetermination.SETFILTER("Piecework Code", DataPieceworkForProduction.Totaling);
            CertUnitRedetermination.SETRANGE("Account Type", CertUnitRedetermination."Account Type"::Unit);
            if CertUnitRedetermination.FINDSET then
                repeat
                    CASE OptionAmount OF
                        OptionAmount::Executed:
                            AmountSalesTotal := AmountSalesTotal + CertUnitRedetermination."Amount Executed";
                        OptionAmount::Pending:
                            AmountSalesTotal := AmountSalesTotal + CertUnitRedetermination."Amount Pending Execution";
                        OptionAmount::Increment:
                            AmountSalesTotal := AmountSalesTotal + CertUnitRedetermination."Amount Sales Increase";
                        OptionAmount::Before:
                            AmountSalesTotal := AmountSalesTotal + CertUnitRedetermination."Last Sales Amount";
                        OptionAmount::New:
                            AmountSalesTotal := AmountSalesTotal + CertUnitRedetermination."New Sales Amount";
                        OptionAmount::Adjusted:
                            AmountSalesTotal := AmountSalesTotal + CertUnitRedetermination."Amount to Adjust";
                    end;
                until CertUnitRedetermination.NEXT = 0;
            exit(AmountSalesTotal);
        end;
    end;

    /*begin
    end.
  */
}







