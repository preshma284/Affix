table 7207396 "Post. Meas. Lines Bill of Item"
{


    CaptionML = ENU = 'Post. Meas. Lines Bill of Item', ESP = 'Descomp. hist. lineas medici�n';
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Enum "Sales Line Type")
        {
            //OptionMembers = "Measuring","Certification","Valued Relationship","Reestimation";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            // OptionCaptionML = ENU = 'Measuring,Certification,Valued Relationship,Reestimation', ESP = 'Medici�n,Certificaci�n,Relaci�n valorada,Reestimaci�n';

            Description = 'Key 1';


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
        field(4; "Piecework No."; Code[20])
        {
            CaptionML = ENU = 'Piecework No.', ESP = 'N� unidad de obra';


        }
        field(5; "Bill of Item No Line"; Integer)
        {
            CaptionML = ENU = 'Bill Of Item No. Line', ESP = 'N� l�nea descompuesto';
            Description = 'Key 4';


        }
        field(6; "Description"; Text[80])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(7; "Budget Units"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Units', ESP = 'Uds ppto.';
            DecimalPlaces = 0 : 6;
            Editable = false;


        }
        field(8; "Budget Length"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Length', ESP = 'Lon ppto.';
            Editable = false;


        }
        field(9; "Budget Width"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Width', ESP = 'Anc ppto.';
            Editable = false;


        }
        field(10; "Budget Height"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Budget Height', ESP = 'Alt ppto.';
            Editable = false;


        }
        field(11; "Budget Total"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total ppto.', ESP = 'Tot  ppto.';
            Editable = false;


        }
        field(12; "Measured Units"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measure Units', ESP = 'Unidades Origen';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                //JAV 24/09/19: - Se cambian los validates de todos los campos para los recalculos
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                UpdateOrigin;
            END;


        }
        field(16; "Measured Total"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total Measured', ESP = 'Total Origen';
            Description = 'JAV 17/09/19: - Se cambia el nombre del campo "Total Measured" para que mantenga la uniformidad  a "Measured Total"';

            trigger OnValidate();
            BEGIN
                //JAV 16/09/19: - Se cambian los validates de todos los campos para los recalculos, eliminando la funci�n "CalculateMeasured"
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                ManagementLineofMeasure.CalculateUnits("Period Units", "Budget Length", "Budget Width", "Budget Height", "Period Total");
                UpdateOrigin;
            END;


        }
        field(17; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� Proyecto';


        }
        field(18; "Realized Units"; Decimal)
        {
            CaptionML = ENU = 'Realized Units', ESP = 'Uds. origen anterior';
            Description = '[Q19284 CSM 17/05/23;]';
            Editable = false;


        }
        field(22; "Realized Total"; Decimal)
        {
            CaptionML = ENU = 'Total Realized', ESP = 'Tot. origen anterior';
            Description = '[Q19284 CSM 17/05/23; JAV 17/09/19: - Se cambia el nombre del campo "Total Realized" para que mantenga la uniformidad  a "Realized Total"]';
            Editable = false;


        }
        field(28; "Measured % Progress"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = '% de avance a origen', ESP = '% de avance a origen';
            DecimalPlaces = 2 : 2;
            Description = 'JAV 17/09/19: - Nuevo campo para establecer el porcentaje de avance de la l�nea a origen';

            trigger OnValidate();
            BEGIN
                //JAV 17/09/19: - Nuevo campo para establecer el porcentaje de avance de la l�nea a origen
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                "Measured Units" := ROUND("Budget Units" * "Measured % Progress" / 100, 0.01);
                UpdateOrigin;
            END;


        }
        field(30; "Period Units"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Measure Units', ESP = 'Unidades Periodo';
            DecimalPlaces = 0 : 6;
            Description = 'JAV 22/09/19: - Nuevo campo para establecer las unidades de avance del periodo de la l�nea';

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
            Description = 'JAV 22/09/19: - Nuevo campo para establecer el total de avance del periodo de la l�nea';

            trigger OnValidate();
            BEGIN
                //JAV 17/09/19: - Nuevo campo para establecer el total del periodo
                //JAV 22/09/19: - Nuevas funciones UpdateOrigen y UpdatePeriod para calcular el complementario de lo que se est� validando
                ManagementLineofMeasure.CalculateUnits("Period Units", "Budget Length", "Budget Width", "Budget Height", "Period Total");
                UpdatePeriod;
            END;


        }
    }
    keys
    {
        key(key1; "Document Type", "Document No.", "Line No.", "Bill of Item No Line")
        {
            Clustered = true;
        }
        key(key2; "Piecework No.", "Bill of Item No Line", "Job No.")
        {
            ;
        }
        key(key3; "Job No.", "Piecework No.", "Bill of Item No Line", "Document Type")
        {
            SumIndexFields = "Measured Units", "Measured Total";
        }
    }
    fieldgroups
    {
    }

    var
        //       ManagementLineofMeasure@1100286000 :
        ManagementLineofMeasure: Codeunit 7207292;

    //     procedure CalculateData (var TotOri@1100229001 : Decimal;var TotPer@1100229000 : Decimal;var TotAnt@1100229002 : Decimal;paropttype@1100229005 : 'Measuring,Certification,Valued Relationship,Reestimation';parcodeNoDoc@1100229006 : Code[20];parintNLine@1100229007 : Integer;parcodJob@1100229008 : Code[20];parcodPiecework@1100229009 :
    procedure CalculateData(var TotOri: Decimal; var TotPer: Decimal; var TotAnt: Decimal; paropttype: Option "Measuring","Certification","Valued Relationship","Reestimation"; parcodeNoDoc: Code[20]; parintNLine: Integer; parcodJob: Code[20]; parcodPiecework: Code[20])
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
        MeasureLinesBillofItem.SETRANGE("Document Type", paropttype);
        MeasureLinesBillofItem.SETRANGE("Document No.", parcodeNoDoc);
        MeasureLinesBillofItem.SETRANGE("Line No.", parintNLine);
        if MeasureLinesBillofItem.FINDSET then
            repeat
                TotOri := TotOri + MeasureLinesBillofItem."Measured Total";
            until MeasureLinesBillofItem.NEXT = 0;

        if DataPieceworkForProduction.GET(parcodJob, parcodPiecework) then begin
            if (paropttype = paropttype::Measuring) or (paropttype = paropttype::Certification) then begin
                DataPieceworkForProduction.CALCFIELDS("Quantity in Measurements");
                TotAnt := DataPieceworkForProduction."Quantity in Measurements";
            end else begin
                DataPieceworkForProduction.CALCFIELDS(DataPieceworkForProduction."Total Measurement Production");
                TotAnt := DataPieceworkForProduction."Total Measurement Production";
            end;

            if (paropttype <> paropttype::Reestimation) then begin
                TotOri := TotOri;
                TotPer := TotOri - TotAnt;
            end else begin
                TotPer := TotOri;
            end;
        end;
    end;

    procedure UpdateOrigin()
    begin
        //JAV 23/06/19: - Actualizar los datos a origen y los datos del periodo a partir de los datos a origen
        ManagementLineofMeasure.CalculateTotal("Measured Units", "Budget Length", "Budget Width", "Budget Height", "Measured Total");

        CALCFIELDS("Realized Total");

        "Period Total" := "Measured Total" - "Realized Total";
        ManagementLineofMeasure.CalculateUnits("Period Units", "Budget Length", "Budget Width", "Budget Height", "Period Total");
        if ("Budget Total" <> 0) then begin
            "Measured % Progress" := ROUND("Measured Total" * 100 / "Budget Total", 0.01);
        end;
    end;

    procedure UpdatePeriod()
    begin
        //JAV 23/06/19: - Actualizar los datos del periodo y los datos a origen a partir de los datos del periodo
        ManagementLineofMeasure.CalculateTotal("Period Units", "Budget Length", "Budget Width", "Budget Height", "Period Total");

        CALCFIELDS("Realized Total");

        "Measured Total" := "Realized Total" + "Period Total";
        ManagementLineofMeasure.CalculateUnits("Measured Units", "Budget Length", "Budget Width", "Budget Height", "Measured Total");
        if ("Budget Total" <> 0) then begin
            "Measured % Progress" := ROUND("Measured Total" * 100 / "Budget Total", 0.01);
        end;
    end;

    /*begin
    //{
//      CPA 24/08/22 Q17919 - Optimizaci�n
//              - Nueva Key: Job No.,Piecework No.,Bill of Item No Line,Document Type
//
//      Q19284 CSM 17/05/23 � Cancelar detalle de medici�n en RV.
//              - Change CAPTIONS of Fields: 18-"Realized Units" y 22-"Realized Total"
//    }
    end.
  */
}







