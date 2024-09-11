table 7207343 "Measure Line Piecework Certif."
{


    CaptionML = ENU = 'Measure Line Piecework Certif.', ESP = 'L�n. medici�n UO certificaci�n';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Description = 'Key 1';


        }
        field(2; "Piecework Code"; Code[20])
        {
            CaptionML = ENU = 'Piecework Code', ESP = 'C�d. unidad de obra';
            Description = 'Key 2';


        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';
            Description = 'Key 3';


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
    }
    keys
    {
        key(key1; "Job No.", "Piecework Code", "Line No.")
        {
            SumIndexFields = "Units", "Length", "Width", "Height", "Total";
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       DataPieceworkForProduction@7001100 :
        DataPieceworkForProduction: Record 7207386;
        //       MeasureLinePieceworkCertif@1100286001 :
        MeasureLinePieceworkCertif: Record 7207343;
        //       ManagementLineofMeasure@1100286000 :
        ManagementLineofMeasure: Codeunit 7207292;



    trigger OnInsert();
    begin
        UpdatePiecework(0);
    end;

    trigger OnModify();
    begin
        UpdatePiecework(1);
    end;

    trigger OnDelete();
    begin
        UpdatePiecework(2);
    end;



    LOCAL procedure CalculateLineTotal()
    var
        //       ManagementLineofMeasure@1100286000 :
        ManagementLineofMeasure: Codeunit 7207292;
    begin
        ManagementLineofMeasure.CalculateTotal(Units, Length, Width, Height, Total);
    end;

    //     procedure CalculateData (pJob@60003 : Code[20];pPiecework@1100286000 :
    procedure CalculateData(pJob: Code[20]; pPiecework: Code[20]): Decimal;
    var
        //       MeasureTotal@1100286001 :
        MeasureTotal: Decimal;
    begin
        //JAV 27/10/20 - QB 1.07.00 Se cambia la longitud de la variable Job de 10 a 20

        MeasureTotal := 0;

        MeasureLinePieceworkCertif.RESET;
        MeasureLinePieceworkCertif.SETRANGE("Job No.", pJob);
        MeasureLinePieceworkCertif.SETRANGE("Piecework Code", pPiecework);
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if MeasureLinePieceworkCertif.FINDSET(FALSE,FALSE) then
        if MeasureLinePieceworkCertif.FINDSET(FALSE) then
            repeat
                MeasureTotal += MeasureLinePieceworkCertif.Total;
            until MeasureLinePieceworkCertif.NEXT = 0;

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

        if (pType = pType::Insert) then  //Todav�a no lo he dado de alta
            Suma := Total
        else
            Suma := 0;

        MeasureLinePieceworkCertif.RESET;
        MeasureLinePieceworkCertif.SETRANGE("Job No.", "Job No.");
        MeasureLinePieceworkCertif.SETRANGE("Piecework Code", "Piecework Code");
        if (MeasureLinePieceworkCertif.FINDSET(FALSE)) then
            repeat
                if (MeasureLinePieceworkCertif."Line No." <> "Line No.") then  //Si no es la l�nea actual la sumo
                    Suma += MeasureLinePieceworkCertif.Total
                else if (pType = pType::Modify) then                           //Si es la l�nea actual y modifico, sumo la actual
                    Suma += Total;
            until (MeasureLinePieceworkCertif.NEXT = 0);

        DataPieceworkForProduction.VALIDATE("Sale Quantity (base)", Suma);
        DataPieceworkForProduction.MODIFY;
    end;

    //     procedure AdjustTo (pJob@1100286001 : Code[20];pPiecework@1100286002 : Code[20];pBudget@1100286003 : Code[20];pQuantity@1100286000 :
    procedure AdjustTo(pJob: Code[20]; pPiecework: Code[20]; pBudget: Code[20]; pQuantity: Decimal)
    var
        //       Sum1@1100286004 :
        Sum1: Decimal;
        //       Sum2@1100286006 :
        Sum2: Decimal;
    begin
        //Esta funci�n ajusta las mediciones proporcionalmente a una cantidad dada
        MeasureLinePieceworkCertif.RESET;
        MeasureLinePieceworkCertif.SETRANGE("Job No.", pJob);
        MeasureLinePieceworkCertif.SETRANGE("Piecework Code", pPiecework);
        MeasureLinePieceworkCertif.SETFILTER(Units, '<>0');
        MeasureLinePieceworkCertif.CALCSUMS(Total);
        Sum1 := MeasureLinePieceworkCertif.Total;

        if (MeasureLinePieceworkCertif.COUNT = 1) then begin
            //Solo hay una l�nea que ajustar
            MeasureLinePieceworkCertif.FINDFIRST;
            MeasureLinePieceworkCertif.VALIDATE(Units, pQuantity);
            MeasureLinePieceworkCertif.MODIFY;
        end else begin
            //Si hay varias l�neas que ajustar
            if (MeasureLinePieceworkCertif.FINDSET(TRUE)) then begin
                Sum2 := 0;
                repeat
                    MeasureLinePieceworkCertif.VALIDATE(Units, MeasureLinePieceworkCertif.Units * pQuantity / Sum1);
                    MeasureLinePieceworkCertif.MODIFY;
                    Sum2 += MeasureLinePieceworkCertif.Total
                until (MeasureLinePieceworkCertif.NEXT = 0);

                //Ajustamos diferencia en la �ltima l�nea leida
                if (pQuantity <> Sum2) then begin
                    MeasureLinePieceworkCertif.VALIDATE(Units, MeasureLinePieceworkCertif.Units + pQuantity - Sum2);
                    MeasureLinePieceworkCertif.MODIFY;
                end;
            end;
        end;
    end;

    /*begin
    end.
  */
}







