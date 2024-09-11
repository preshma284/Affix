table 7207403 "QB Objectives Header"
{


    CaptionML = ENU = 'Header Card APM', ESP = 'Cabecera ficha APM';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';
            Editable = false;


        }
        field(2; "Budget Code"; Code[20])
        {
            TableRelation = "Job Budget"."Cod. Budget" WHERE("Job No." = FIELD("Job No."));
            CaptionML = ENU = 'Budget Code', ESP = 'Cod. presupuesto';
            NotBlank = true;


        }
        field(10; "Job Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Job"."Description" WHERE("No." = FIELD("Job No.")));
            CaptionML = ENU = 'Job Name', ESP = 'Nombre proyecto';
            Editable = false;


        }
        field(11; "Budget Date"; Date)
        {
            CaptionML = ENU = 'Budget Date', ESP = 'Fecha presupuesto';
            Editable = false;


        }
        field(12; "Allow Negative"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Negativo Aprobado';
            Description = 'Q13643 MMS 12/07/21 Se a�ade campo 12 "Allow Negative"';
            Editable = false;


        }
        field(13; "User Allow Negative"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Usuario aprobador';
            Description = 'Q13643 MMS 12/07/21 Se a�ade campo 13 "User Allow Negative"';
            Editable = false;


        }
        field(14; "Date Allow"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Fecha aprobaci�n';
            Description = 'Q13643 MMS 12/07/21 Se a�ade campo 14 "Date Allow"';
            Editable = false;


        }
        field(20; "Income Approved"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ingresos Aprobados';
            Editable = false;


        }
        field(21; "Income Improvements"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ingresos Mejoras';
            Editable = false;


        }
        field(22; "Income Target"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ingresos Objetivo';
            Editable = false;


        }
        field(23; "Cost Approved"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Gastos Aprobados';
            Editable = false;


        }
        field(24; "Cost Improvements"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Gastos Mejoras';
            Editable = false;


        }
        field(25; "Cost Target"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Gastos Objetivo';
            Editable = false;


        }
        field(26; "Total Approved"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Total Aprobados';
            Editable = false;


        }
        field(27; "Total Improvements"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Total Mejoras';
            Editable = false;


        }
        field(28; "Total Target"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Total Objetivo';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Job No.", "Budget Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       LineCardAPM@7001100 :
        LineCardAPM: Record 7207404;



    trigger OnDelete();
    begin
        LineCardAPM.SETRANGE("Job No.", "Job No.");
        LineCardAPM.SETRANGE("Budget Code", "Budget Code");
        if LineCardAPM.FINDFIRST then
            LineCardAPM.DELETEALL;
    end;



    /*begin
        {
          Q13643 MMS 13/07/21 Se a�ade campo 12 "Allow Negative", campo 13 "User Allow Negative", campo 14 "Date Allow"
        }
        end.
      */
}







