table 7207395 "QBU Measure Lines Bill of Item"
{


    CaptionML = ENU = 'Measure Lines Bill of Item', ESP = 'Descompuesto lineas medici�n';
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Enum "Sales Line Type")
        {
            // OptionMembers="Measuring","Certification","Valued Relationship","Reestimation";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            //OptionCaptionML=ENU='Measuring,Certification,Valued Relationship,Reestimation',ESP='Medici�n,Certificaci�n,Relaci�n valorada,Reestimaci�n';

            Description = 'Key 1';
            Editable = false;


        }
        field(2; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';
            Description = 'Key 2';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';
            Description = 'Key 3';


        }
        field(4; "Piecework Code"; Code[20])
        {
            CaptionML = ENU = 'Piecework Code', ESP = 'N� unidad de obra';


        }
        field(5; "Bill of Item No Line"; Integer)
        {
            CaptionML = ENU = 'Bill of Item No Line', ESP = 'N� l�nea descompuesto';
            Description = 'Key 4';


        }
        field(6; "Description"; Text[80])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            Description = 'Del Presupuesto';


        }
        field(7; "Budget Units"; Decimal)
        {
            CaptionML = ENU = 'Budget Units', ESP = 'Uds ppto.';
            DecimalPlaces = 2 : 6;
            Description = 'Del Presupuesto';
            Editable = false;


        }
        field(8; "Budget Length"; Decimal)
        {
            CaptionML = ENU = 'Budget Length', ESP = 'Lon ppto.';
            Description = 'Del Presupuesto';
            Editable = false;


        }
        field(9; "Budget Width"; Decimal)
        {
            CaptionML = ENU = 'Budget Width', ESP = 'Anc ppto.';
            Description = 'Del Presupuesto';
            Editable = false;


        }
        field(10; "Budget Height"; Decimal)
        {
            CaptionML = ENU = 'Budget Height', ESP = 'Alt ppto.';
            Description = 'Del Presupuesto';
            Editable = false;


        }
        field(11; "Budget Total"; Decimal)
        {
            CaptionML = ENU = 'Total ppto.', ESP = 'Tot  ppto.';
            Description = 'Del Presupuesto';
            Editable = false;


        }
        field(12; "Measured Units"; Decimal)
        {


            CaptionML = ENU = 'Measure Units', ESP = 'Unidades Origen';
            DecimalPlaces = 2 : 6;
            Description = 'A Origen';

            trigger OnValidate();
            BEGIN
                //JAV 24/09/19: - Se cambian los validates de todos los campos para los recalculos
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                UpdateOrigin;
            END;


        }
        field(16; "Measured Total"; Decimal)
        {


            CaptionML = ENU = 'Total Measured', ESP = 'Total Origen';
            Description = 'A Origen   JAV 17/09/19: - Se cambia el nombre del campo "Total Measured" para que mantenga la uniformidad  a "Measured Total"';
            Editable = false;

            trigger OnValidate();
            BEGIN
                UpdateOrigin;
            END;


        }
        field(17; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(18; "Realized Units"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Post. Meas. Lines Bill of Item"."Period Units" WHERE("Job No." = FIELD("Job No."),
                                                                                                                          "Piecework No." = FIELD("Piecework Code"),
                                                                                                                          "Bill of Item No Line" = FIELD("Bill of Item No Line"),
                                                                                                                          "Document Type" = FIELD("Document Type")));
            CaptionML = ENU = 'Realized Units', ESP = 'Uds realiz.';
            DecimalPlaces = 2 : 6;
            Description = 'Anterior';
            Editable = false;


        }
        field(22; "Realized Total"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Post. Meas. Lines Bill of Item"."Period Total" WHERE("Job No." = FIELD("Job No."),
                                                                                                                          "Piecework No." = FIELD("Piecework Code"),
                                                                                                                          "Bill of Item No Line" = FIELD("Bill of Item No Line"),
                                                                                                                          "Document Type" = FIELD("Document Type")));
            CaptionML = ENU = 'Total Realized', ESP = 'Tot realiz.';
            Description = 'Anterior  JAV 17/09/19: - Se cambia el nombre del campo "Total Realized" para que mantenga la uniformidad  a "Realized Total"';
            Editable = false;


        }
        field(28; "Measured % Progress"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = '% de avance a origen', ESP = '% de avance a origen';
            DecimalPlaces = 2 : 6;
            Description = 'A Origen   JAV 17/09/19: - Nuevo campo para establecer el porcentaje de avance de la l�nea a origen';

            trigger OnValidate();
            BEGIN
                //JAV 17/09/19: - Nuevo campo para establecer el porcentaje de avance de la l�nea a origen
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                "Measured Units" := ROUND("Budget Units" * "Measured % Progress" / 100, 0.000001);
                UpdateOrigin;
            END;


        }
        field(30; "Period Units"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measure Units', ESP = 'Unidades Periodo';
            DecimalPlaces = 2 : 6;
            Description = 'Periodo     JAV 22/09/19: - Nuevo campo para establecer las unidades de avance del periodo de la l�nea';

            trigger OnValidate();
            BEGIN
                //JAV 17/09/19: - Nuevo campo para establecer las unidades del periodo
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                UpdatePeriod;
            END;


        }
        field(34; "Period Total"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Measured', ESP = 'Total Periodo';
            Description = 'Periodo   JAV 22/09/19: - Nuevo campo para establecer el total de avance del periodo de la l�nea';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //JAV 17/09/19: - Nuevo campo para establecer el total del periodo
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                UpdatePeriod;
            END;


        }
    }
    keys
    {
        key(key1; "Document Type", "Document No.", "Line No.", "Piecework Code", "Bill of Item No Line")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       ManagementLineofMeasure@1100286000 :
        ManagementLineofMeasure: Codeunit 7207292;

    //     procedure CalculateData (var TotOri@1100229001 : Decimal;var TotPer@1100229000 : Decimal;var TotAnt@1100229002 : Decimal;pType@1100229005 : 'Measuring,Certification,Valued Relationship,Reestimation';pDocNo@1100229006 : Code[20];pNLine@1100229007 :
    // procedure CalculateData(var TotOri: Decimal; var TotPer: Decimal; var TotAnt: Decimal; pType: Option "Measuring","Certification","Valued Relationship","Reestimation"; pDocNo: Code[20]; pNLine: Integer)
    procedure CalculateData(var TotOri: Decimal; var TotPer: Decimal; var TotAnt: Decimal; pType: Enum "Sales Line Type"; pDocNo: Code[20]; pNLine: Integer)
    var
        //       MeasureLinesBillofItem@1100229003 :
        MeasureLinesBillofItem: Record 7207395;
        //       DataPieceworkForProduction@1100229004 :
        DataPieceworkForProduction: Record 7207386;
    begin
        TotOri := 0;
        TotPer := 0;
        TotAnt := 0;

        MeasureLinesBillofItem.RESET;
        MeasureLinesBillofItem.SETRANGE("Document Type", pType);
        MeasureLinesBillofItem.SETRANGE("Document No.", pDocNo);
        MeasureLinesBillofItem.SETRANGE("Line No.", pNLine);
        if MeasureLinesBillofItem.FINDSET then
            repeat
                TotOri += MeasureLinesBillofItem."Measured Total";
                TotPer += MeasureLinesBillofItem."Period Total";
            until MeasureLinesBillofItem.NEXT = 0;

        TotAnt := TotOri - TotPer;

        if (pType = pType::Reestimation) then
            TotPer := TotOri;
    end;

    procedure UpdateOrigin()
    begin
        //JAV 23/06/19: - Actualizar los datos a origen y calcular los datos del periodo a partir de los datos a origen
        ManagementLineofMeasure.CalculateTotal("Measured Units", "Budget Length", "Budget Width", "Budget Height", "Measured Total");
        if ("Budget Total" <> 0) then
            "Measured % Progress" := ROUND("Measured Units" * 100 / "Budget Units", 0.000001)
        else
            "Measured % Progress" := 0;

        CALCFIELDS("Realized Units", "Realized Total");
        "Period Units" := "Measured Units" - "Realized Units";
        "Period Total" := "Measured Total" - "Realized Total";
    end;

    procedure UpdatePeriod()
    begin
        //JAV 23/06/19: - Actualizar los datos del periodo y calcular los datos a origen a partir de los datos del periodo
        ManagementLineofMeasure.CalculateTotal("Period Units", "Budget Length", "Budget Width", "Budget Height", "Period Total");

        CALCFIELDS("Realized Units", "Realized Total");
        "Measured Units" := "Realized Units" + "Period Units";
        "Measured Total" := "Realized Total" + "Period Total";
        if ("Budget Total" <> 0) then
            //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
            //{
            //        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
            //        "Measured % Progress" := ROUND("Measured Units" * 100 / "Budget Units", 0.0001)
            //        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
            //        }
            "Measured % Progress" := ROUND("Measured Units" * 100 / "Budget Units", 0.000001)
        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
        else
            "Measured % Progress" := 0;
    end;

    /*begin
    //{
//      JAV 16/09/19: - Se cambian los validates de todos los campos para los recalculos, eliminando la funci�n "CalculateMeasured"
//                    - Se acolrtan los caption de los campos para que ocupen menos en la pantalla
//      JAV 17/09/19: - Se cambia el nombre del campo "Total Measured" para que mantenga la uniformidad a "Measured Total"
//                    - Se cambia el nombre del campo "Prev. Source Total Measured" para que mantenga la uniformidad a "Prev. Source Measured Total"
//                    - Se cambia el nombre del campo "Total Realized" para que mantenga la uniformidad a "Realized Total"
//                    - Nuevo campo "Source % Progress" para establecer el porcentaje de avance de la l�nea
//      JAV 22/09/19: - Nuevos campos 29 a 34 para establecer el avance del periodo
//                    - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
//      Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.
//                    - Se modifica el CALCFORMULA de los campos 18 y 22, para que no sean MAX, sino SUM de los datos del periodo.
//    }
    end.
  */
}







