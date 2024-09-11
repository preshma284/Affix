table 7207390 "QBU Measurement Lin. Piecew. Prod."
{


    CaptionML = ENU = 'Measurement Lin. Piecew. Prod.', ESP = 'L�n. medici�n UO producci�n';
    LookupPageID = "Lin. Measure Piecework Product";
    DrillDownPageID = "Lin. Measure Piecework Product";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            TableRelation = "Job"."No.";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Description = 'Key 1';


        }
        field(2; "Piecework Code"; Code[20])
        {
            CaptionML = ENU = 'Job Unit Code', ESP = 'C�d. unidad de obra';
            Description = 'Key 2';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';
            Description = 'Key 4';


        }
        field(4; "Description"; Text[80])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Units"; Decimal)
        {


            CaptionML = ENU = 'Units', ESP = 'Unidades';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                Units := ROUND(Units, 0.000001);
                CalculateLineTotal;
            END;


        }
        field(6; "Length"; Decimal)
        {


            CaptionML = ENU = 'Length', ESP = 'Longitud';

            trigger OnValidate();
            BEGIN
                CalculateLineTotal;
            END;


        }
        field(7; "Width"; Decimal)
        {


            CaptionML = ENU = 'Width', ESP = 'Anchura';

            trigger OnValidate();
            BEGIN
                CalculateLineTotal;
            END;


        }
        field(8; "Height"; Decimal)
        {


            CaptionML = ENU = 'Height', ESP = 'Altura';

            trigger OnValidate();
            BEGIN
                CalculateLineTotal;
            END;


        }
        field(9; "Total"; Decimal)
        {
            CaptionML = ENU = 'Total', ESP = 'Total';
            Editable = false;


        }
        field(17; "Code Budget"; Code[20])
        {
            CaptionML = ENU = 'Code Budget', ESP = 'C�d. presupuesto';
            Description = 'Key 3';


        }
    }
    keys
    {
        key(key1;"Job No.","Piecework Code","Code Budget","Line No."){
            SumIndexFields=Units,Length,Width,Height,Total;
            Clustered=true;
        }
        key(key2;"Job No.","Piecework Code","Line No.")
        {

        }
    }
    fieldgroups
    {
    }

    var
        //       DataPieceworkForProduction@7001100 :
        DataPieceworkForProduction: Record 7207386;
        //       Job@7001101 :
        Job: Record 167;
        //       MeasurementLinPiecewProd@1100286002 :
        MeasurementLinPiecewProd: Record 7207390;
        //       ManagementLineofMeasure@1100286001 :
        ManagementLineofMeasure: Codeunit 7207292;
        //       cantidad@1100286000 :
        cantidad: Decimal;
        //       ProdMeasureLines@1100286004 :
        ProdMeasureLines: Record 7207400;
        //       RV@1100286003 :
        RV: Boolean;



    trigger OnInsert();
    begin
        CheckClosed;
        UpdatePiecework(0);
    end;

    trigger OnModify();
    begin
        CheckClosed;
        UpdatePiecework(1);
    end;

    trigger OnDelete();
    begin
        CheckClosed;
        UpdatePiecework(2);
    end;



    LOCAL procedure CheckClosed()
    var
        //       Text020@7001100 :
        Text020: TextConst ENU = 'Can not be modified since the State is Closed', ESP = 'No se puede modificar ya que el Estado es Cerrado';
        //       JobBudget@7001101 :
        JobBudget: Record 7207407;
    begin
        CLEAR(Job);
        Job.JobStatus("Job No.");

        JobBudget.RESET;
        JobBudget.SETRANGE("Job No.", "Job No.");
        JobBudget.SETRANGE("Cod. Budget", "Code Budget");
        if JobBudget.FINDFIRST then
            if JobBudget.Status = JobBudget.Status::Close then
                ERROR(Text020);
    end;

    LOCAL procedure CalculateLineTotal()
    var
        //       ManagementLineofMeasure@1100286000 :
        ManagementLineofMeasure: Codeunit 7207292;
    begin
        ManagementLineofMeasure.CalculateTotal(Units, Length, Width, Height, Total);
    end;

    //     procedure CalculateData (pJob@60003 : Code[20];pPiecework@1100286000 : Code[20];pBudget@1100286002 :
    procedure CalculateData(pJob: Code[20]; pPiecework: Code[20]; pBudget: Code[20]): Decimal;
    var
        //       MeasureTotal@1100286001 :
        MeasureTotal: Decimal;
    begin
        //JAV 27/10/20: - QB 1.07.00 Se cambia la longitud de la variable Job de 10 a 20
        //JAV 08/06/22: - QB 1.10.49 Se filtra sacar el total por el presupuesto para no sacar todos acumulados
        MeasureTotal := 0;

        MeasurementLinPiecewProd.RESET;
        MeasurementLinPiecewProd.SETRANGE("Job No.", pJob);
        MeasurementLinPiecewProd.SETRANGE("Piecework Code", pPiecework);
        MeasurementLinPiecewProd.SETRANGE("Code Budget", pBudget);
        //JAV 08/06/22: - QB 1.10.49 Se filtra sacar el total por el presupuesto para no sacar todos acumulados
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if MeasurementLinPiecewProd.FINDSET(FALSE,FALSE) then
        if MeasurementLinPiecewProd.FINDSET(FALSE) then
            repeat
                MeasureTotal += MeasurementLinPiecewProd.Total;
            until MeasurementLinPiecewProd.NEXT = 0;

        exit(MeasureTotal);
    end;

    //     LOCAL procedure UpdatePiecework (pType@1100286000 :
    LOCAL procedure UpdatePiecework(pType: Option "Insert","Modify","Delet")
    var
        //       Suma@1100286001 :
        Suma: Decimal;
    begin
        if (not DataPieceworkForProduction.GET("Job No.", "Piecework Code")) then
            exit;

        if not Job.GET("Job No.") then
            exit;

        if (pType = pType::Insert) then  //Todav�a no lo he dado de alta
            Suma := Total
        else
            Suma := 0;

        MeasurementLinPiecewProd.RESET;
        MeasurementLinPiecewProd.SETRANGE("Job No.", "Job No.");
        MeasurementLinPiecewProd.SETRANGE("Piecework Code", "Piecework Code");
        MeasurementLinPiecewProd.SETRANGE("Code Budget", "Code Budget"); //JMMA 010920 corrige error en c�lculo de medici�n cuando hay varias reestimaciones
        if (MeasurementLinPiecewProd.FINDSET(FALSE)) then
            repeat
                if (MeasurementLinPiecewProd."Line No." <> "Line No.") then     //Si no estoy en la l�nea actual la sumo
                    Suma += MeasurementLinPiecewProd.Total
                else if (pType = pType::Modify) then                            //Si es la l�nea actual, sumo solo si modifico pero con el dato actual
                    Suma += Total;
            until (MeasurementLinPiecewProd.NEXT = 0);

        DataPieceworkForProduction.SETFILTER("Budget Filter", "Code Budget");
        DataPieceworkForProduction.VALIDATE("Measure Budg. Piecework Sol", Suma);
        DataPieceworkForProduction.MODIFY;
    end;

    //     procedure AdjustTo (pJob@1100286001 : Code[20];pPiecework@1100286002 : Code[20];pBudget@1100286003 : Code[20];pQuantity@1100286000 :
    procedure AdjustTo(pJob: Code[20]; pPiecework: Code[20]; pBudget: Code[20]; pQuantity: Decimal)
    var
        //       Sum1@1100286004 :
        Sum1: Decimal;
        //       Sum2@1100286006 :
        Sum2: Decimal;
        //       JobBudget@1100286005 :
        JobBudget: Record 7207407;
        //       MeasureLinesBillofItem@1100286007 :
        MeasureLinesBillofItem: Record 7207395;
    begin
        //Esta funci�n ajusta las mediciones proporcionalmente a una cantidad dada
        //-Q17698 AML 06/06/23 Modificacion para ajustar bien la medici�n de la valorada.

        if RV and CheckRV then begin //Si viene de una RV y los porcentajes de avance no son iguales.
            JobBudget.SETRANGE("Job No.", pJob);
            JobBudget.SETRANGE("Actual Budget", TRUE);
            JobBudget.FINDFIRST;

            MeasureLinesBillofItem.SETRANGE("Document Type", MeasureLinesBillofItem."Document Type"::"Valued Relationship");
            MeasureLinesBillofItem.SETRANGE("Document No.", ProdMeasureLines."Document No.");
            if MeasureLinesBillofItem.FINDSET then
                repeat
                    if MeasureLinesBillofItem."Measured % Progress" > 100 then begin
                        MeasurementLinPiecewProd.GET(MeasureLinesBillofItem."Job No.", MeasureLinesBillofItem."Piecework Code", JobBudget."Cod. Budget", MeasureLinesBillofItem."Bill of Item No Line");

                        MeasurementLinPiecewProd.VALIDATE(Units, MeasureLinesBillofItem."Period Units");
                        MeasurementLinPiecewProd.MODIFY;
                    end;
                until MeasureLinesBillofItem.NEXT = 0;


        end
        else begin
            //AML Esta es la parte est�ndar

            MeasurementLinPiecewProd.RESET;
            MeasurementLinPiecewProd.SETRANGE("Job No.", pJob);
            MeasurementLinPiecewProd.SETRANGE("Piecework Code", pPiecework);
            MeasurementLinPiecewProd.SETRANGE("Code Budget", pBudget);
            MeasurementLinPiecewProd.SETFILTER(Units, '<>0');
            MeasurementLinPiecewProd.CALCSUMS(Total);
            Sum1 := MeasurementLinPiecewProd.Total;

            if (MeasurementLinPiecewProd.COUNT = 1) then begin
                //Solo hay una l�nea que ajustar
                MeasurementLinPiecewProd.FINDFIRST;
                MeasurementLinPiecewProd.VALIDATE(Units, pQuantity);
                MeasurementLinPiecewProd.MODIFY;
            end else begin
                //Si hay varias l�neas que ajustar
                if (MeasurementLinPiecewProd.FINDSET(TRUE)) then begin
                    Sum2 := 0;
                    repeat
                        MeasurementLinPiecewProd.VALIDATE(Units, MeasurementLinPiecewProd.Units * pQuantity / Sum1);
                        MeasurementLinPiecewProd.MODIFY;
                        Sum2 += MeasurementLinPiecewProd.Total
                    until (MeasurementLinPiecewProd.NEXT = 0);

                    //Ajustamos diferencia en la �ltima l�nea leida
                    if (pQuantity <> Sum2) then begin
                        MeasurementLinPiecewProd.VALIDATE(Units, MeasurementLinPiecewProd.Units + pQuantity - Sum2);
                        MeasurementLinPiecewProd.MODIFY;
                    end;
                end;
            end;
        end;
    end;

    //     procedure DeleteBlackLines (pJob@1100286000 :
    procedure DeleteBlackLines(pJob: Code[20])
    begin
        MeasurementLinPiecewProd.RESET;
        MeasurementLinPiecewProd.SETRANGE("Job No.", pJob);
        if (MeasurementLinPiecewProd.FINDSET) then
            repeat
                if (MeasurementLinPiecewProd.Description = '') and
                   (MeasurementLinPiecewProd.Units = 0) and (MeasurementLinPiecewProd.Length = 0) and (MeasurementLinPiecewProd.Width = 0) and (MeasurementLinPiecewProd.Height = 0) then
                    MeasurementLinPiecewProd.DELETE(TRUE);
            until (MeasurementLinPiecewProd.NEXT = 0);
    end;

    //     procedure ParamRV (pProdMeasureLines@1100286000 : Record 7207400;pRV@1100286001 :
    procedure ParamRV(pProdMeasureLines: Record 7207400; pRV: Boolean)
    begin
        //-Q17698 AML 06/06/23
        ProdMeasureLines := pProdMeasureLines;
        RV := pRV
    end;

    LOCAL procedure CheckRV() Salida: Boolean;
    var
        //       MeasureLinesBillofItem@1100286001 :
        MeasureLinesBillofItem: Record 7207395;
        //       Progress@1100286000 :
        Progress: Decimal;
    begin
        //-Q17698 AML 06/06/23
        Progress := 0;
        Salida := FALSE;
        MeasureLinesBillofItem.SETRANGE("Document Type", MeasureLinesBillofItem."Document Type"::"Valued Relationship");
        MeasureLinesBillofItem.SETRANGE("Document No.", ProdMeasureLines."Document No.");
        if MeasureLinesBillofItem.FINDSET then
            repeat
                if (Progress <> 0) and (Progress <> MeasureLinesBillofItem."Measured % Progress") then Salida := TRUE;
                Progress := MeasureLinesBillofItem."Measured % Progress";
            until MeasureLinesBillofItem.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 13/03/19: - Se corrige un error en los datos del c�lculo del total y se simplifica la forma de efectuarlo
//      JAV 08/06/22: - QB 1.10.49 Se filtra sacar el total por el presupuesto para no sacar todos acumulados
//      AML 07/06/23: - Q17698 Correcciones para la actualizacion de l�neas de medicion en RV.
//    }
    end.
  */
}







