table 7207285 "QBU Measure Line Piecework PRESTO"
{


    CaptionML = ENU = 'Measure line Piecework PRESTO', ESP = 'L�neas de medici�n U.O.PRESTO';
    LookupPageID = "Measure Lin. PieceWork PRESTO";
    DrillDownPageID = "Measure Lin. PieceWork PRESTO";

    fields
    {
        field(1; "Cod. Jobs Unit"; Code[20])
        {
            CaptionML = ENU = 'Cod. Jobs Unit', ESP = 'Cod. Unidad de obra';
            Description = 'Key 3';


        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', ESP = 'No. Linea';
            Description = 'Key 4';


        }
        field(3; "Description"; Text[80])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(4; "Units"; Decimal)
        {


            CaptionML = ENU = 'Units', ESP = 'Unidades';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                CalculateLineTotal;
            END;


        }
        field(5; "Length"; Decimal)
        {


            CaptionML = ENU = 'Length', ESP = 'Longitud';

            trigger OnValidate();
            BEGIN
                CalculateLineTotal;
            END;


        }
        field(6; "Width"; Decimal)
        {


            CaptionML = ENU = 'Width', ESP = 'Anchura';

            trigger OnValidate();
            BEGIN
                CalculateLineTotal;
            END;


        }
        field(7; "Height"; Decimal)
        {


            CaptionML = ENU = 'Height', ESP = 'Altura';

            trigger OnValidate();
            BEGIN
                CalculateLineTotal;
            END;


        }
        field(8; "Total"; Decimal)
        {
            CaptionML = ENU = 'Total', ESP = 'Total';
            DecimalPlaces = 2 : 3;
            Editable = false;


        }
        field(14; "Cost Database Code"; Code[20])
        {
            TableRelation = "Cost Database"."Code";
            CaptionML = ENU = 'Cost Database Code', ESP = 'Cod. preciario';
            Description = 'Key 1';


        }
        field(16; "Use"; Option)
        {
            OptionMembers = "Cost","Sales";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Uso para';
            OptionCaptionML = ENU = 'Cost,Sales', ESP = 'Coste,Venta';

            Description = 'Key 2  QB 1.06.09 - JAV 08/08/20: - Si se usa en coste o en venta';


        }
    }
    keys
    {
        //key added 
        key(key1; "Cost Database Code", "Use", "Cod. Jobs Unit", "Line No.")
        {
            SumIndexFields = Units, Length, Width, Total;
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       MeasureLinePieceworkPRESTO@1100286000 :
        MeasureLinePieceworkPRESTO: Record 7207285;
        //       Piecework@1100286001 :
        Piecework: Record 7207277;



    trigger OnInsert();
    begin
        if ("Line No." = 0) then begin
            MeasureLinePieceworkPRESTO.RESET;
            MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", "Cost Database Code");
            MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", "Cod. Jobs Unit");
            MeasureLinePieceworkPRESTO.SETRANGE(Use, Use);
            if (MeasureLinePieceworkPRESTO.FINDFIRST) then
                "Line No." := MeasureLinePieceworkPRESTO."Line No." + 10000
            else
                "Line No." := 10000;
        end;
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

    //     procedure CalculateData (CodeCostDatabase@60003 : Code[20];CodeJobsUnits@1100286000 : Code[20];pUse@1100286002 :
    procedure CalculateData(CodeCostDatabase: Code[20]; CodeJobsUnits: Code[20]; pUse: Option): Decimal;
    var
        //       MeasureTotal@1100286001 :
        MeasureTotal: Decimal;
    begin
        //JAV 27/10/20 - QB 1.07.00 Se cambia la longitud de la variable CodeCostDatabase de 10 a 20
        MeasureTotal := 0;
        MeasureLinePieceworkPRESTO.RESET; //JMMA
        MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", CodeCostDatabase);
        MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", CodeJobsUnits);
        MeasureLinePieceworkPRESTO.SETRANGE(Use, pUse);
        //used without Updatekey Parameter to avoid warning - may become error in future release
        /*To be Tested*/
        //if MeasureLinePieceworkPRESTO.FINDSET(FALSE,FALSE) then
        if MeasureLinePieceworkPRESTO.FINDSET(FALSE) then
            repeat
                if (MeasureLinePieceworkPRESTO."Line No." = "Line No.") then
                    MeasureTotal += Total
                else
                    MeasureTotal += MeasureLinePieceworkPRESTO.Total;
            until MeasureLinePieceworkPRESTO.NEXT = 0;

        exit(MeasureTotal);
    end;

    //     LOCAL procedure UpdatePiecework (pType@1100286000 :
    LOCAL procedure UpdatePiecework(pType: Option "Insert","Modify","Delet")
    var
        //       Suma@1100286001 :
        Suma: Decimal;
    begin
        if (not Piecework.GET("Cost Database Code", "Cod. Jobs Unit")) then
            exit;

        if (pType = pType::Insert) then  //Todav�a no lo he dado de alta
            Suma := Total
        else
            Suma := 0;

        MeasureLinePieceworkPRESTO.RESET;
        MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", "Cost Database Code");
        MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", "Cod. Jobs Unit");
        MeasureLinePieceworkPRESTO.SETRANGE(Use, Use);
        if (MeasureLinePieceworkPRESTO.FINDSET(FALSE)) then
            repeat
                if (MeasureLinePieceworkPRESTO."Line No." <> "Line No.") then   //Si estoy en la l�nea actual la sumo
                    Suma += MeasureLinePieceworkPRESTO.Total
                else if (pType = pType::Modify) then                            //Si es la l�nea actual, sumo si modifico el dato actual
                    Suma += Total;
            until (MeasureLinePieceworkPRESTO.NEXT = 0);

        //JMMA 210820
        if (Suma <> 0) then begin
            if (Use = Use::Cost) then
                Piecework.VALIDATE("Measurement Cost", Suma)
            else
                Piecework.VALIDATE("Measurement Sale", Suma);
            Piecework.MODIFY;
        end;
    end;

    /*begin
    end.
  */
}







