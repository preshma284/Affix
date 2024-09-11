table 7207392 "Forecast Data Amount Piecework"
{


    CaptionML = ENU = 'Forecast Data Amount Piecework', ESP = 'Datos previsi�n importes UO';
    LookupPageID = "Piecework Amount Planning";
    DrillDownPageID = "Piecework Amount Planning";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job"."No.";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(2; "Expected Date"; Date)
        {
            CaptionML = ENU = 'Expected Date', ESP = 'Fecha Prevista';


        }
        field(3; "Cod. Budget"; Code[20])
        {
            CaptionML = ENU = 'Cod. Budget', ESP = 'C�d. Presupuesto';


        }
        field(4; "Piecework Code"; Text[20])
        {
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';


        }
        field(5; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'N� Mov.';


        }
        field(6; "Amount"; Decimal)
        {
            CaptionML = ENU = 'Amount', ESP = 'Importe';


        }
        field(7; "Unit Type"; Option)
        {
            OptionMembers = "Job Unit","Cost Unit";
            CaptionML = ENU = 'Unit Type', ESP = 'Tipo unidad';
            OptionCaptionML = ENU = 'Job Unit,Cost Unit', ESP = 'Unidad de obra,Unidad de coste';



        }
        field(8; "Analytical Concept"; Code[20])
        {
            CaptionML = ENU = 'Analytical Concept', ESP = 'Concepto Anal�tico';


        }
        field(9; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(10; "Code Cost Database"; Code[20])
        {
            CaptionML = ENU = 'Code Cost Database', ESP = 'C�d. preciario';


        }
        field(11; "Unique Code"; Code[30])
        {
            CaptionML = ENU = 'Unique Code', ESP = 'C�digo �nico';
            Description = 'QB- Ampliado para importar m�s niveles en BC3';


        }
        field(12; "Entry Type"; Option)
        {
            OptionMembers = "Expenses","Incomes","Certification";
            CaptionML = ENU = 'Entry Type', ESP = 'Tipo movimiento';
            OptionCaptionML = ENU = 'Expenses,Incomes,Certification', ESP = 'Gastos,Ingresos,Certificaci�n';



        }
        field(13; "Performed"; Boolean)
        {
            CaptionML = ENU = 'Performed', ESP = 'Realizado';


        }
        field(50; "Currency Amount Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Amount Date', ESP = 'Fecha valor divisa';
            Description = 'GEN003-03';

            trigger OnValidate();
            BEGIN
                //GEN003-02
                VALIDATE("Amount (LCY)");
                VALIDATE("Amount (ACY)");
            END;


        }
        field(51; "Amount (LCY)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount (LCY)', ESP = 'Importe (DL)';
            Description = 'GEN003-03';

            trigger OnValidate();
            BEGIN
                //GEN003-02, Q7374
                Job.GET("Job No.");
                IF NOT Performed THEN
                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", Amount, Job."Currency Code", '', "Expected Date", Rec."Entry Type", "Amount (LCY)", "Currency Factor (LCY)")
                ELSE
                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", Amount, Job."Currency Code", '', "Currency Amount Date", Rec."Entry Type", "Amount (LCY)", "Currency Factor (LCY)");
            END;


        }
        field(52; "Currency Factor (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor (LCY)', ESP = 'Factor divisa (DL)';
            Description = 'GEN003-03';


        }
        field(53; "Amount (ACY)"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount (ACY)', ESP = 'Importe (DR)';
            Description = 'GEN003-03';

            trigger OnValidate();
            BEGIN
                //GEN003-02, Q7374
                Job.GET("Job No.");
                IF NOT Performed THEN
                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", Amount, Job."Currency Code", Job."Aditional Currency", "Expected Date", Rec."Entry Type", "Amount (ACY)", "Currency Factor (ACY)")
                ELSE
                    JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", Amount, Job."Currency Code", Job."Aditional Currency", "Currency Amount Date", Rec."Entry Type", "Amount (ACY)", "Currency Factor (ACY)");
            END;


        }
        field(54; "Currency Factor (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor (ACY)', ESP = 'Factor divisa (DR)';
            Description = 'GEN003-03';


        }
        field(55; "Job Currency Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Amount in Job Currency', ESP = 'Importe divisa proyecto';
            Description = 'GEN005-02';


        }
        field(56; "Job Currency Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Factor in Job Currency', ESP = 'Tipo cambio divisa proyecto';
            Description = 'GEN005-02';


        }
    }
    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Job No.", "Piecework Code", "Cod. Budget")
        {
            SumIndexFields = "Amount";
        }
        key(key3; "Job No.", "Piecework Code", "Expected Date", "Performed", "Cod. Budget")
        {
            SumIndexFields = "Amount";
        }
        key(key4; "Entry Type", "Job No.", "Piecework Code", "Cod. Budget", "Analytical Concept", "Expected Date", "Unit Type", "Performed")
        {
            SumIndexFields = "Amount";
        }
        key(key5; "Job No.", "Cod. Budget", "Expected Date", "Entry Type")
        {
            ;
        }
        key(key6; "Entry Type", "Job No.", "Cod. Budget")
        {
            SumIndexFields = "Amount";
        }
        key(key7; "Job No.", "Unit Type", "Entry Type", "Performed", "Cod. Budget", "Analytical Concept")
        {
            SumIndexFields = "Amount";
        }
        key(key8; "Entry Type", "Job No.", "Piecework Code", "Expected Date", "Cod. Budget")
        {
            SumIndexFields = "Amount";
        }
        key(key9; "Entry Type", "Job No.", "Piecework Code", "Expected Date", "Cod. Budget", "Analytical Concept")
        {
            SumIndexFields = "Amount";
        }
    }
    fieldgroups
    {
    }

    var
        //       JobCurrencyExchangeFunction@100000003 :
        JobCurrencyExchangeFunction: Codeunit 7207332;
        //       Job@100000002 :
        Job: Record 167;



    trigger OnInsert();
    begin
        //GEN003-02
        VALIDATE("Amount (LCY)");
        VALIDATE("Amount (ACY)");
    end;

    trigger OnModify();
    begin
        //GEN003-02
        VALIDATE("Amount (LCY)");
        VALIDATE("Amount (ACY)");
    end;



    /*begin
        {
          QBV102  NZG  16/01/18 : A�adido el campo "Studied"

          CPA 29/03/22: Q16867 - Mejora de rendimiento
              - Nueva Clave: Entry Type,Job No.,Cod. Budget
              - Nueva Clave: Job No.,Unit Type,Entry Type,Performed,Cod. Budget,Analytical Concept
              - Nueva clave: Entry Type,Job No.,Piecework Code,Expected Date,Cod. Budget
              - Nueva clave: Entry Type,Job No.,Piecework Code,Expected Date,Cod. Budget,Analytical Concept
          JAV 24/05/22: - QB 1.10.42 - Se a�ade la clave "Job No.,Cod. Budget,Unit Type,Performed" para acelerar consultas
          JAV 25/05/22: - QB 1.10.43 - Se cambia la clave anterior por "Job No.,Cod. Budget,Unit Type,Performed,Piecework Code"
        }
        end.
      */
}







